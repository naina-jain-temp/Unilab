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

import fetchHATAllocationDetails from '@salesforce/apex/UNILAB_HAT_Allocation.fetchHATAllocationDetails';
import getHATAllocationDetails from '@salesforce/apex/UNILAB_HAT_Allocation.getHATAllocationDetails';
import getProductDetails from '@salesforce/apex/UNILAB_HAT_Allocation.getProductDetails';
import getAccountDetails from '@salesforce/apex/UNILAB_HAT_Allocation.getAccountDetails';

import {loadStyle } from 'lightning/platformResourceLoader';
import myResource from '@salesforce/resourceUrl/styleSheet';
import { NavigationMixin } from 'lightning/navigation';

const columns = [{
        label: "HAT ALLOCATION NAME",
        fieldName: 'Id',
        type: "button",
        sortable: true,
        typeAttributes: {
            label: {
                fieldName: "Name"
            },
            class: "blue",
            target: "_self",
            color: "blue"
        },
        initialWidth: 220
    }, {
        label: "PRODUCT",
        fieldName: 'Product',
        type: "text"
    }, {
        label: "SKU SOH QTY",
        fieldName: "SKU_SOH_QTY",
        initialWidth: 150
    }, {
        label: "SKU_SOH_AMOUNT",
        fieldName: 'SKU_SOH_AMOUNT',
        initialWidth: 150
    }, {
        label: "CREATED BY",
        fieldName: "CreatedBy",
        type: "text",
        initialWidth: 170
    }, {
        label: "CREATED DATE",
        fieldName: "CreatedDate",
        type: "date",
        typeAttributes: {
            month: '2-digit',
            day: '2-digit',
            year: 'numeric'
        },
        initialWidth: 170
    }, {
        label: "LAST MODIFIED DATE",
        fieldName: "LastModifiedDate",
        type: "date",
        typeAttributes: {
            month: '2-digit',
            day: '2-digit',
            year: 'numeric'
        },
        initialWidth: 170
    },
];

export default class UnilabHATAllocation extends NavigationMixin(LightningElement) {
    //Object Variable Declaration
    allocationObj = {};

    //Array Variable Declaration
    hatAllocationData = [];
    columns = columns;
    filteredProductArr = [];
    allocationTypeOptions = [];
    filteredAccountArr = [];

    //String Variable Declaration
    btnLabel = 'Next';
    wiredAllocationDetails;
    recordId;
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

    //Boolean Variable Declaration
    isDisable = false;
    showAllocationModal = false;
    noRecordsFound = false;
	fieldsDisable = false;
	buttonDisable = false;
    isStepOne = false;
    isStepTwo = false;
    isStepThree = false;
    showProductModal = false;
    showAccountModal = false;
    Spinner = false;

    //Getter Method
    get isStepOne() {
        return this.currentStep === "1";
    }

    get isStepTwo() {
        return this.currentStep === "2";
    }

    get isStepThree() {
        return this.currentStep === "3";
    }

   //Wire Method is used to fetch the HAT Allocation object values inside Lightning Datatable 
    @wire(fetchHATAllocationDetails)
    wiredFetchDetails({ data, error }) {
        if (data) {
            this.wiredTotalAllocations = data.length;

            if (this.wiredTotalAllocations === 0)
                this.noRecordsFound = true;
            else
                this.noRecordsFound = false;

            this.hatAllocationData = data.map(row => {
                return {
                    Id: row.Id,
                    Name: row.Name,
                    Product: row.Product__r.Name,
                    SKU_SOH_QTY: row.SKU_SOH_QTY__c,
                    SKU_SOH_AMOUNT: '$' + row.SKU_SOH_Amount__c,
                    CreatedBy: row.CreatedBy.Name,
                    CreatedDate: row.CreatedDate,
                    LastModifiedDate: row.LastModifiedDate
                }
            });
            refreshApex(this.wiredTotalAllocations);
        }
    }

    //Declare HAT Allocation object
    @wire(getObjectInfo, { objectApiName: HAT_ALLOCATION_OBJECT })
    objectInfo;

    //Function used to get all picklist values from sanction object - Wire to a function
    @wire(getPicklistValuesByRecordType, {
        objectApiName: HAT_ALLOCATION_OBJECT,
        recordTypeId: '$objectInfo.data.defaultRecordTypeId'
    })
    getAllPicklistValues({ error, data }) {
        if (data) {
            this.error = null;

            // Allocation Type Field Picklist values
            this.allocationTypeOptions = data.picklistFieldValues[ALLOCATION_TYPE_FIELD.fieldApiName].values.map(key => {
                return {
                    label: key.label,
                    value: key.value
                }
            });
        } else if (error) {
            this.error = JSON.stringify(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Warning',
                    message: 'Unable to fetch Allocation Type Picklist values',
                    variant: 'warning'
                })
            );
        }
    }

    //Get Product Details based on Filter
    @wire(getProductDetails, {
        productName: '$productName'
    })
    wiredProductInfo({ data, error }) {
        if (data) {
            this.filteredProductArr = data.map(row => {
                return {
                    Id: row.Id,
                    Value: row.Name
                }
            });
            if (this.filteredProductArr.length > 0) {
                this.showProductModal = true;
            } else {
                this.showProductModal = false;
            }
        }
    }

    //Get Account Details based on Filter
    @wire(getAccountDetails, {
        accountName: '$accountName'
    })
    wiredAccountInfo({ data, error }) {
        if (data) {
            this.filteredAccountArr = data.map(row => {
                return {
                    Id: row.Id,
                    Value: row.Name
                }
            });
            if (this.filteredAccountArr.length > 0) {
                this.showAccountModal = true;
            } else {
                this.showAccountModal = false;
            }
        }
    }

    //LifeCycle Method on Load the Page
    connectedCallback() {
        this.handleAllocationModal();
        /*this.isStepOne = true;
        this.isStepTwo = false;
        this.isStepThree = false;*/
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

    hanldeProgressValueChange() {

    }

    //Handle On Change Method
    handleOnChange(event) {
        let name = event.target.name;
        let value = event.target.value;

        switch(name) {
            case 'Product':
                this.allocationObj.Product = value;
                this.productName = value;
                if (value) {
                    this.showProductModal = true;
                } else {
                    this.showProductModal = false;
                }
                break;
            case 'Quantity':
                this.allocationObj.Qty = value;
                break;
            case 'Amount':
                this.allocationObj.Amount = value;
                break;
            case 'Account':
                this.allocationObj.Account = value;
                this.accountName = value;
                if (value) {
                    this.showAccountModal = true;
                } else {
                    this.showAccountModal = false;
                }
                break;
            case 'TeamName':
                this.allocationObj.TeamName = value;
                break;
            case 'ItemPrice':
                this.allocationObj.ItemPrice = value;
                break;
            case 'StorageLocation':
                this.allocationObj.StorageLocation = value;
                break;
            case 'AllocationType':
                this.allocationObj.AllocationType = value;
                break;
            case 'ProductAllocation':
                this.allocationObj.ProductAllocation = value;
                break;
            case 'AllocationMonth':
                this.allocationObj.AllocationMonth = value;
                break;
        }
    }

    //Handle Open Allocation Modal method
    handleAllocationModal() {
        this.Spinner = true;
        this.showAllocationModal = true;
        this.isStepOne = true;
        this.isStepTwo = false;
        this.isStepThree = false;
        this.btnLabel = 'Next';
        setTimeout(() => {
            this.Spinner = false;
        }, 2000);
    }

    //Handle Close Allocation modal
    handleCloseAllocationModal() {
        this.showAllocationModal = false;
        this.Spinner = true;
        setTimeout(() => {
            this.allocationObj = {};
            this.Spinner = false;
        }, 2000);
    }

    handleCloseUpload(event) {
        if (event.detail.first === true) {
            this.showAllocationModal = false;
            this.Spinner = false;
            this.allocationObj = false;

            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'HAT_Allocation_Plan__c',
                    actionName: 'list'
                },
                state: {
                    filterName: 'All' 
                }
            });
        }
    }

    //Handle Progress Bar On Click Method
    handleOnStepClick(event) {
        if (event.target.value == 1) {
            this.currentStep = event.target.value;
            this.isStepOne = true;
            this.isStepTwo = false;
            this.isStepThree = false;
            this.form_Title = "Product Information";
        } else if (event.target.value == 2) {
            this.currentStep = event.target.value;
            this.isStepOne = false;
            this.isStepTwo = true;
            this.isStepThree = false;
            this.form_Title = "Account Information";
        } else if (event.target.value == 3) {
            this.currentStep = event.target.value;
            this.isStepOne = false;
            this.isStepTwo = false;
            this.isStepThree = true;
            this.form_Title = "Upload";
        }
    }

    //Select Product Value from DropDown
    handleSelectProduct(event) {
        this.allocationObj.Product = event.currentTarget.dataset.value;
        this.allocationObj.ProductId = event.currentTarget.dataset.id;
        this.showProductModal = false;
    }

    //Select Account Value from DropDown
    handleSelectAccount(event) {
        this.allocationObj.Account = event.currentTarget.dataset.value;
        this.allocationObj.AccountId = event.currentTarget.dataset.id;
        this.showAccountModal = false;
    }
    
    //On Click Next Method
    handleNext() {
        if (this.isStepOne === true) {
            if (!this.allocationObj.Product)
                return this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Warning',
                        message: 'Product is mandatory',
                        variant: 'warning'
                    })
                );
            
            if (!this.allocationObj.Qty)
                return this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Warning',
                        message: 'Quantity is mandatory',
                        variant: 'warning'
                    })
                );

            if (!this.allocationObj.Amount)
                return this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Warning',
                        message: 'Amount is mandatory',
                        variant: 'warning'
                    })
                );

            if (this.allocationObj.Qty && this.allocationObj.Qty < 1)
                return this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Warning',
                        message: 'Quantity should be greater than 0',
                        variant: 'warning'
                    })
                );

            if (this.allocationObj.Amount && this.allocationObj.Amount < 1)
                return this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Warning',
                        message: 'Amount should be greater than 0',
                        variant: 'warning'
                    })
                );

            this.isStepTwo = true;
            this.isStepOne = false;
            this.currentStep = '2';
            this.btnLabel = this.isStepTwo === true ? (this.allocationObj.Id ? 'Update' : 'Save') : 'Next';
        } else if (this.isStepTwo === true) {
            if (!this.allocationObj.Account)
                return this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Warning',
                        message: 'Account is mandatory',
                        variant: 'warning'
                    })
                );
            
            if (!this.allocationObj.AllocationType)
                return this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Warning',
                        message: 'Allocation Type is mandatory',
                        variant: 'warning'
                    })
                );
            this.Spinner = true;
            this.isStepTwo = false;
            this.currentStep = '3';

            const fields = {};
    
            fields[PRODUCT_FIELD.fieldApiName] = this.allocationObj.ProductId;
            fields[SKU_SOH_FIELD.fieldApiName] = this.allocationObj.Qty;
            fields[SKU_SOH_AMOUNT_FIELD.fieldApiName] = this.allocationObj.Amount;
            fields[ACCOUNT_FIELD.fieldApiName] = this.allocationObj.AccountId;
            fields[CT_TEAM_NAME_FIELD.fieldApiName] = this.allocationObj.TeamName;
            fields[ITEM_PRICE_VAT_FIELD.fieldApiName] = this.allocationObj.ItemPrice;
            fields[STORAGE_LOCATION_FIELD.fieldApiName] = this.allocationObj.StorageLocation;
            fields[ALLOCATION_TYPE_FIELD.fieldApiName] = this.allocationObj.AllocationType;
            fields[ALLOCATION_MONTH_FIELD.fieldApiName] = this.allocationObj.AllocationMonth;
            fields[PRODUCT_ALLOCATION_OBJECT_NUMBER_FIELD.fieldApiName] = this.allocationObj.ProductAllocation;

            if (!this.allocationObj.Id) {
                const recordInput = {
                    apiName: HAT_ALLOCATION_OBJECT.objectApiName,
                    fields
                };

                createRecord(recordInput)
                .then(result => {
                    this.isLoading = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'HAT Allocation has been created',
                            variant: 'success',
                        })
                    );
                    this.recordId = result.id;
                    this.allocationObj = {};
                    this.isStepOne = false;
                    this.isStepTwo = false;
                    this.isStepThree = true;
                    this.Spinner = false;
                    return refreshApex(this.wiredTotalAllocations);
                })
                .catch(error => {
                    this.Spinner = false;
                    this.isStepOne = false;
                    this.isStepTwo = true;
                    this.isStepThree = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                    this.isLoading = false;
                });
            } else {
                this.recordId = this.allocationObj.Id;
                fields[ID_FIELD.fieldApiName] = this.allocationObj.Id;

                const recordInput = { fields };

                updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'HAT Allocation has been updated',
                            variant: 'success'
                        })
                    );
                    this.isStepThree = true;
                    this.allocationObj = {};
                    this.Spinner = false;
                    return refreshApex(this.wiredTotalAllocations);
                })
                .catch(error => {
                    this.Spinner = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error updating record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
            }
        }
    }
}