/**
    * @description   : HAT Allocation Create and Edit Functionality Handled
**/

import { LightningElement, api, wire } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import LightningAlert from 'lightning/alert';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { refreshApex } from "@salesforce/apex";

//Importing HAT Allocation Object Details
import HAT_ALLOCATION_OBJECT from '@salesforce/schema/Hat_Allocation__c';
import ID_FIELD from '@salesforce/schema/Hat_Allocation__c.Id';
import NAME_FIELD from '@salesforce/schema/Hat_Allocation__c.Name';
import PRODUCT_FIELD from '@salesforce/schema/Hat_Allocation__c.Product__c';
import SKU_SOH_FIELD from '@salesforce/schema/Hat_Allocation__c.SKU_SOH_QTY__c';
import SKU_SOH_AMOUNT_FIELD from '@salesforce/schema/Hat_Allocation__c.SKU_SOH_Amount__c';
import PRODUCT_ALLOCATION_OBJECT_NUMBER_FIELD from '@salesforce/schema/Hat_Allocation__c.Product_Allocation_Object_Number__c';
import ACCOUNT_FIELD from '@salesforce/schema/Hat_Allocation__c.Account__c';
import ALLOCATION_FINAL_AMOUNT_FIELD from '@salesforce/schema/Hat_Allocation__c.ALLOCATION_FINAL_Amount__c';
import ALLOCATION_FINAL_QTY_FIELD from '@salesforce/schema/Hat_Allocation__c.ALLOCATION_FINAL_QTY__c';
import ALLOCATION_MONTH_FIELD from '@salesforce/schema/Hat_Allocation__c.Allocation_Month__c';
import ALLOCATION_TYPE_FIELD from '@salesforce/schema/Hat_Allocation__c.Allocation_Type__c';
import CT_TEAM_NAME_FIELD from '@salesforce/schema/Hat_Allocation__c.CT_Team_Name__c';
import DIVISION_FIELD from '@salesforce/schema/Hat_Allocation__c.Division__c';
import ITEM_PRICE_VAT_FIELD from '@salesforce/schema/Hat_Allocation__c.Item_Price_w_o_VAT__c';
import STORAGE_LOCATION_FIELD from '@salesforce/schema/Hat_Allocation__c.Storage_Location__c';
import ACCOUNT_GROUP_CODE_FIELD from '@salesforce/schema/Hat_Allocation__c.Account_Group_code__c';//Formula
import ACCOUNT_GROUP_NAME_FIELD from '@salesforce/schema/Hat_Allocation__c.Account_Group_Name__c';//Formula
import CHANNEL_FIELD from '@salesforce/schema/Hat_Allocation__c.Channel__c';//Formula
import ITEM_CASE_FIELD from '@salesforce/schema/Hat_Allocation__c.Item_Case__c';//Formula
import SKU_CODE_FIELD from '@salesforce/schema/Hat_Allocation__c.SKU_Code__c';//Formula
import SKU_DESCRIPTION_FIELD from '@salesforce/schema/Hat_Allocation__c.SKU_Description__c';//Formula
import UOM_FIELD from '@salesforce/schema/Hat_Allocation__c.UOM__c';//Formula

import fetchHATAllocationDetails from '@salesforce/apex/UnilabProductSelectionReport.fetchHATAllocationDetails';
import getHATAllocationDetails from '@salesforce/apex/UNILAB_HAT_Allocation.getHATAllocationDetails';
import getProductDetails from '@salesforce/apex/UNILAB_HAT_Allocation.getProductDetails';
import getAccountDetails from '@salesforce/apex/UNILAB_HAT_Allocation.getAccountDetails';

import {loadStyle } from 'lightning/platformResourceLoader';
import myResource from '@salesforce/resourceUrl/styleSheet';
import { NavigationMixin } from 'lightning/navigation';

const columns = [{
        label: "PLANNING TYPE",
        fieldName: 'PlanningType',
        initialWidth: 160
    }, {
        label: "PROD ALLOC OBJECT",
        fieldName: 'ProdAllObjNo',
        initialWidth: 160
    }, {
        label: "SALES ORG",
        fieldName: "SalesOrg",
        initialWidth: 150
    }, {
        label: "DIST.CHANNEL",
        fieldName: 'DistChannel',
        initialWidth: 150
    }, {
        label: "CUSTOMER GROUP",
        fieldName: "CustomerGroup",
        initialWidth: 150
    }, {
        label: "SOLD-TO-PARTY",
        fieldName: "SoldToParty",
        initialWidth: 150
    }, {
        label: "PROD ALLOC QTY",
        fieldName: "ProdAllocQty",
        initialWidth: 150
    },
];

export default class UnilabProductSelectionReport extends LightningElement {

    //Array Variable Declaration
    hatAllocationData = [];
    columns = columns;
    filteredProductArr = [];
    allocationTypeOptions = [];
    filteredAccountArr = [];

    //String Variable Declaration
    wiredAllocationDetails;
    @api recordId;
    attachmentIcon;// = images + "/contact-newIcon.svg";
    title = 'HAT ALLOCATION';
    currentStep = 1;
    productName;
    accountName;

    //Sort Function
	defaultSortDirection = "asc";
	sortDirection = "asc";
	sortedBy = 'Name';

    //Pagination
	totalAllocationCount = 0;
	totalAllocations = [];
	page = 1;
	currentPageAllocationData;
	setPagination = 5;
	perpage = 10;

    Spinner = false;

   //Wire Method is used to fetch the HAT Allocation object values inside Lightning Datatable 
    @wire(fetchHATAllocationDetails, {
        recordId: '$recordId'
    })
    wiredFetchDetails({ data, error }) {
        if (data) {
            console.log('==data==' + JSON.stringify(data));
            this.wiredTotalAllocations = data.length;

            /*this.hatAllocationData = data.map(row => {
                return {
                    Id: row.Id,
                    Name: row.Name,
                    PlanningType: row.Product__r.Name,
                    ProdAllObjNo: row.SKU_SOH_QTY__c,
                    SalesOrg: '$' + row.SKU_SOH_Amount__c,
                    DistChannel: row.CreatedBy.Name,
                    CustomerGroup: row.CreatedDate,
                    SoldToParty: row.LastModifiedDate,
                    ProdAllocQty: row.LastModifiedDate
                }
            });*/
            refreshApex(this.wiredTotalAllocations);
        }
    }

    //LifeCycle Method on Load the Page
    connectedCallback() {
        this.hatAllocationData = [{
            PlanningType: 'Commit',
            ProdAllObjNo: '001',
            SalesOrg: '3501',
            DistChannel: '01',
            CustomerGroup: '01',
            SoldToParty: '80075019',
            ProdAllocQty: '104256',
        }]
    }

    /* Style Sheet Loading */
    renderedCallback() {
        Promise.all([
            loadStyle(this, myResource + '/styleSheet.css')        
        ])
    }

    onHandleSort() {
    }

    handleRowAction(event) {
        let recordId = event.detail.row.Id;
        this.allocationObj.Id = event.detail.row.Id;
        if (recordId) {
            getHATAllocationDetails({
                recordId: recordId
            })
            .then(result => {
                if (result.length > 0) {
                    this.allocationObj.Id = result[0].Id;
                    this.allocationObj.Name = result[0].Name;
                    this.allocationObj.Product = result[0].Product__r.Name;
                    this.allocationObj.Qty = result[0].SKU_SOH_QTY__c;
                    this.allocationObj.Amount = result[0].SKU_SOH_Amount__c;
                    this.allocationObj.Account = result[0].Account__r.Name;
                    this.allocationObj.TeamName = result[0].CT_Team_Name__c;
                    this.allocationObj.ItemPrice = result[0].Item_Price_w_o_VAT__c;
                    //this.allocationObj.StorageLocation = result[0].Storage_Location__c;
                    this.allocationObj.AllocationType = result[0].Allocation_Type__c;
                    //this.allocationObj.AllocationMonth = result[0].Allocation_Month__c;
                    this.allocationObj.ProductAllocation = result[0].Product_Allocation_Object_Number__c;

                    this.showAllocationModal = true;
                } else {
                    this.showAllocationModal = false;
                    return this.dispatchEvent(new ShowToastEvent({
                        label: "warning",
                        message: "Error found, please contact system admin",
                        variant: "warning"
                    }));
                }
            })
            .catch(error => {
                return this.dispatchEvent(new ShowToastEvent({
                    label: "warning",
                    message: "No Record Found",
                    variant: "warning"
                }));
            })
        }
    }
}