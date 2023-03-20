import { LightningElement, api, wire, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import myResource from "@salesforce/resourceUrl/custommodal";
//import myResource from '@salesforce/resourceUrl/styleSheet';
import { CloseActionScreenEvent } from 'lightning/actions';

import getProductSelection from '@salesforce/apex/UnilabProductSelection.getProductSelection';
import getRowValue from '@salesforce/apex/UnilabProductSelection.getRowValue';

export default class UnilabProductSelection extends LightningElement {
    @api recordId;
    objectName = 'Hat_Allocation__c';
    recordinfo = true;
    showProductDetails = false;
    @track hatObj = {};
    @track tableRows =[];

    //Life Cycle Method
    connectedCallback() {
        console.log('==recordId===' + this.recordId);
        
    }

    @wire(getProductSelection, {
        recordId: '$recordId'
    })
    wiredProducts({ error , data }) {
        if (data) {
            if (data.length > 0) {
                console.log('==data===' + JSON.stringify(data));
                data.forEach(row => {
                    this.hatObj.name = row.Name;
                    this.hatObj.allocationType = row.Allocation_Type__c || '';
                    this.hatObj.allocationMonth = row.Allocation_Month__c || '';
                    this.hatObj.itemCode = row.Product__c && row.Product__r.Item_Code__c || '';
                    this.hatObj.itemCase = row.Product__c && row.Product__r.Item_Case__c || '';
                    this.hatObj.itemDescription = row.Product__c && row.Product__r.Item_Description__c || '';
                    this.hatObj.storageLocation = row.Storage_Location__c && row.Storage_Location__r.Storage_Location_Code__c || '';
                    this.hatObj.sohQty = row.SKU_SOH_QTY__c || '';
                    this.hatObj.prodAllocObjNumber = row.Product__c && row.Product__r.Product_Allocation_Object_Number__c != null ? row.Product__r.Product_Allocation_Object_Number__c + (row.Sales_Org__c ? ' ' + row.Sales_Org__c : row.Product_Allocation_Object_Number__c) : row.Product_Allocation_Object_Number__c;
                    this.hatObj.division = row.Product__c && row.Product__r.Division__c || '';
                    this.hatObj.uom = row.Product__c && row.Product__r.UOM__c || '';
                    this.hatObj.itemWOPrice = row.Item_Price_w_o_VAT__c || '';
                });
            }
        }
    }

    
    @wire(getRowValue) record;
    

    

    /* Style Sheet Loading */
    renderedCallback() {
        Promise.all([
            //loadStyle(this, myResource + '/styleSheet.css')
            loadStyle(this, myResource + '/custommodal.css')
            
        ])
    }

    handleProductDetails() {
        
        this.showProductDetails = true;        
        this.recordinfo = false;
    }

    handleClose() {
        this.showProductDetails = false;        
        this.recordinfo = false;
        this.closeQuickAction();
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}