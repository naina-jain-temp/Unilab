/**
 * @description       :
 * @author            : Amit Singh
 * @group             :
 * @last modified on  : 02-14-2022
 * @last modified by  : Amit Singh
**/
import { api, LightningElement, track, wire } from 'lwc';
import fetchsObjects from '@salesforce/apex/FlowDataTableHelper.fetchsObjects';
import fetchsObjectsWire from '@salesforce/apex/FlowDataTableHelper.fetchsObjectsWire';
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const WHERE_CLAUSE = ' WHERE ';
const ORDER_BY_CLAUSE = ' ORDER BY ';

const actions = [
    { label: 'Show details', name: 'show_details' },
    { label: 'Delete', name: 'delete' },
];

export default class FlowDataTableComponent extends LightningElement {

    /* Public Property */
    @api recordId;
    @api fieldToFilter;
    @api firstSelectRowId;
    @api allSelectedRecordIds;
    @api firstSelectedRecord;
    @api allSelectedRecords;
    @api objectAPIName    = 'Account';
    @api fieldsToDisplay  = 'Name, Industry, Rating, Parent.Name';
    @api inlineEditFields = '';
    @api fieldsToLink     = 'Name';
    @api orderByField     = 'CreatedDate';
    @api orderByDirection = 'DESC';
    @api maxNoOfRecordsToSelect = '1';
    @api noOfRecordsToReturn = '10';
    @api recordPerPage = '10';

    __errors = undefined;

    /* Private Property */
    @track dataList;
    columnsList;
    rowActions = {
        type: 'action',
        typeAttributes: { rowActions: actions },
    };
    /*
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    */

    requiredData;
    isRendered = false;
    isSpinner  = false;
    @track refreshApexData = [];

    /* Prepare the SOQL Query with the filters and also the order by clause */
    renderedCallback(){

        if(this.isRendered){
            return;
        }
        this.isRendered     = true;
        this.isSpinner      = true;
        let filterClause    = '';
        let orderByClause   = '';
        if(this.fieldToFilter && this.recordId){
            filterClause = WHERE_CLAUSE + this.fieldToFilter + ' = \'' + this.recordId + '\'';
        }
        if(this.orderByField && this.orderByDirection){
            orderByClause = ORDER_BY_CLAUSE + this.orderByField + ' ' + this.orderByDirection;
        }
        /* Prepare the Data for Apex Class */
        let tableWrapper = {
            fieldsToDisplay : this.fieldsToDisplay,
            fieldsToLink    : this.fieldsToLink,
            objectAPIName   : this.objectAPIName,
            filter          : filterClause,
            orderBy         : orderByClause,
            limitClause     : this.noOfRecordsToReturn
        }
        this.requiredData = JSON.stringify(tableWrapper);
    }

    @wire(fetchsObjectsWire, {
        requiredData : '$requiredData'
    })
    wiredSObjectData( resultFromApex ) {
        this.refreshApexData =  resultFromApex;
        if (resultFromApex.data) {
            // handle the result coming from Salesforce Apex
            this.handleApexResult(resultFromApex.data);
        } else if (resultFromApex.error) {
            console.error('Error: \n ', resultFromApex.error);
            this.isSpinner = false;
            this.__errors = resultFromApex.error;
        }
    }

    handleApexResult = resultFromApex => {
        //console.log('resultFromApex ', JSON.stringify(resultFromApex.data) );
        this.dataList           = resultFromApex.data;
        this.columnsList        = resultFromApex.columns;
        let originalColumns     = JSON.parse( JSON.stringify( this.columnsList ) );
        let fieldsLinkArrays    = [];
        if(this.fieldsToLink){
            this.fieldsToLink.split(',').forEach(field => {
                fieldsLinkArrays.push(field.trim()+'Url');
            });
        }
        let filedsToEdit = [];
        if(this.inlineEditFields){
            filedsToEdit =  this.inlineEditFields.split(',');
        }
        //console.log('filedsToEdit ', filedsToEdit);
        originalColumns.forEach(col => {
            if(col.type === 'reference' || fieldsLinkArrays.includes(col.fieldName) ){
                col.type = 'url';
            }
        });

        /* Check if there are any fields to edit */
        originalColumns.forEach(col => {
            //console.log('col ', JSON.stringify(col));
            filedsToEdit.forEach(field => {
                //console.log(field.trim() === col.fieldName);
                if(field.trim() === col.fieldName || field.trim() === col.label){
                    col.editable = true;
                }
            });
        });

        originalColumns.push(this.rowActions);
        this.columnsList = originalColumns;
        this.isSpinner   = false;
    }

    handleRowSelection = event =>{
        event.preventDefault();
        //console.log('Selected Records ', JSON.stringify(event.detail) );
        const selectedRows = event.detail.selectedRows;
        //console.log('Selected Rows ', JSON.stringify(selectedRows));
        this.allSelectedRecords = selectedRows;
        if(selectedRows && selectedRows.length){
            this.firstSelectedRecord = selectedRows[0];
            this.firstSelectRowId    = selectedRows[0].Id;
        }
        this.allSelectedRecordIds = [];
        for (let i = 0; i < selectedRows.length; i++) {
            this.allSelectedRecordIds.push(selectedRows[i].Id);
        }
    }

    handleRowAction = (actionName, row) => {
        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            case 'show_details':
                this.showRowDetails(row);
                break;
            default:
        }
    }

    handleSave = event => {
        event.preventDefault();
        //refreshApex(this.refreshApexData);
        this.isSpinner = true;
        fetchsObjects({
            requiredData : this.requiredData
        })
        .then(result => {
            //console.log('result ', JSON.stringify(result) );
            this.handleApexResult(result);
        })
        .catch(error => {
            // TODO Error handling
            console.error('Error: \n ', error );
            this.__errors = error;
        })
        .finally(() => {
            this.isSpinner = false;
        });
    }

    showRowDetails = row => {
        let baseUrl = 'https://'+window.location.host+'/'+row.Id;
        let open    = window.open(baseUrl, url);
        window.location.href = open;
    }

    deleteRow = row => {
        this.isSpinner = true;
        deleteRecord(row.Id)
        .then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Record Deleted',
                variant: 'success'
            }));
            refreshApex(this.refreshApexData);
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title   : 'Error',
                message : JSON.stringify(error),
                variant : 'error'
            }));
            console.error(' error: ', error);
        })
        .finally(() => {
            this.isSpinner = false;
        });
    }
    /*
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                return primer(x[field]);
            }
            : function (x) {
                return x[field];
            };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.dataList];
        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.dataList = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }*/

    handleRowActions(event){
        this.handleRowAction(event.detail.actionName, event.detail.data);
    }

    handlePagination(event){
        //window.console.log('Pagination Action Handled ', JSON.stringify(event.detail.records));
    }
}