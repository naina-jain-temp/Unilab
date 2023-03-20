import { LightningElement, track, api, wire } from 'lwc';
//import uploadFile from '@salesforce/apex/UNILAB_Hat_Upload.handleUpload';
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
import modal from '@salesforce/resourceUrl/Unilab';
import { loadStyle } from 'lightning/platformResourceLoader';
import csvFileUpload from '@salesforce/apex/UNILAB_HAT_Allocation.csvFileUpload';
import fetchObjectDetail from '@salesforce/apex/UNILAB_HAT_Allocation.fetchObjectDetail';
import { NavigationMixin } from 'lightning/navigation';
import myResource from '@salesforce/resourceUrl/styleSheet';
import { deleteRecord } from 'lightning/uiRecordApi';

export default class Unilab_TOMG_upload extends NavigationMixin(LightningElement) {
    @api recordId;
    @track errorMessage;
    @track keys;
    @track delimiter;
    @track responseData;
    @track readCSVData;
    @track showSpinner = false;
    @track successCount;
    @track failureCount;
    @track fileName;

    //String Variable Declaration
    selectedObjectName = '';

    //Object Variable Declaration
    uploadObj = {};

    //Boolean Variable Declaration
    showSpinner = false;
    showDownloadButtons = false;
    showFileUpload = false;
    showDownloadUpload = false;
    isFileUploaded = false;

    //Array Variable Declaration
    uploadedFiles = [];
    csvLstArr = [];

    // accepted parameters
    get acceptedCSVFormats() {
        return '.csv';
    }

    //Getter Method for Upload Options
    get uploadOptions() {
        return [
            { label: 'Import', value: 'Import' },
            { label: 'Export', value: 'Export' },
        ];
    }

    //Getter Method for Object Options
    get objectOptions() {
        return [{
            label: 'Customer Master Data',
            value: 'HAT_Account__c'
        }, {
            label: 'Product Allocation',
            value: 'Product_Allocation__c'
        }, {
            label: 'Storage Location',
            value: 'Storage_Location__c'
        }, {
            label: 'Cut-Off Compliance',
            value: 'Cut_Off_Compliance__c'
        }];
    }

    @wire(fetchObjectDetail, {
        objectName: '$selectedObjectName'
    })
    wiredObjectDetails({ error, data }) {
        console.log('===data===' + JSON.stringify(data));
        if (data) {
            if (data.length > 0) {
                if (this.uploadObj.objectName == 'HAT_Account__c') {
                    this.csvLstArr = data.map(row => {
                        return {
                            Id: row.Id,
                            Name: row.Name ? row.Name : '',
                            DistributionChannel: row.Distribution_Channel__c ? '0'+row.Distribution_Channel__c : '',
                            CustomerGroup: row.Customer_group__c ? '0'+row.Customer_group__c : '',
                            CustomerGroupDescription: row.Customer_Group_Description__c,
                            SoldToParty: row.Sold_To_Party__c,
                            SoldToName: row.Sold_To_Name__c ? row.Sold_To_Name__r.Name : ''
                        }
                    });
                    console.log('====' + this.csvLstArr);
                }
                else if (this.uploadObj.objectName == 'Product_Allocation__c') {
                    this.csvLstArr = data.map(row => {
                        return {
                            Id: row.Id,
                            Name: row.Name,
                            SalesOrg: row.Sales_Org__c,
                            MaterialNumber: row.Material_Number__c,
                            MaterialDescription: row.Material_Description__c,
                            AllocationObjectNumber: row.Product_Allocation_Object_Number__c
                        }
                    });
                }
                else if (this.uploadObj.objectName == 'Storage_Location__c') {
                    this.csvLstArr = data.map(row => {
                        return {
                            Id: row.Id,
                            Name: row.Name,
                            PlantCode: row.Plant_Code__c,
                            StorageLocationCode: row.Storage_Location_Code__c
                        }
                    });
                }
                else if (this.uploadObj.objectName == 'Cut_Off_Compliance__c') {
                    this.csvLstArr = data.map(row => {
                        return {
                            Id: row.Id,
                            Name: row.Name,
                            AccountGroupName: row.Account_Group_Name__c,
                            OrderDrop: row.OrderDrop__c,
                            BranchName: row.Branch_Name__c,
                            SODate: row.SO_Date__c,
                            DeliveryDate: row.Delivery_Date__c,
                        }
                    });
                }
                console.log('===ddd===' + JSON.stringify(this.csvLstArr));
            }
        }
    }

    /* Style Sheet Loading */
    renderedCallback() {
        Promise.all([
            loadStyle(this, myResource + '/styleSheet.css')
        ])
    }

    //Handle On Change method
    handleOnChange(event) {
        let name = event.target.name;
        let value = event.target.value;
        console.log('==event.target.value==' + event.target.value);

        switch(name) {
            case 'type':
                this.uploadObj.type = event.target.value;
                this.showFileUpload = value === 'Import' ? true : false;
                this.showDownloadUpload = value === 'Export' ? true : false;;
                break;
            case 'objectName':
                this.uploadObj.objectName = event.target.value;
                this.selectedObjectName = event.target.value;
                if (this.isFileUploaded === true) {
                    this.removeInsertedRecord();
                }
                break;
        }
    }

    removeInsertedRecord() {
        deleteRecord(this.uploadedFiles[0].documentId)
        .then(() => {
            console.log('==res===');
            this.uploadedFiles = [];
            this.isFileUploaded = false;
        })
        .catch(error => {
            this.error = error;
            console.log('==error==' + JSON.stringify(error));
        })
    }

    //Handle Upload Finished Method for Uploading the Object
    handleUploadFinished(event) {
        if (!this.uploadObj.objectName)
            return this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Warning',
                    message: 'Object Name Selection is mandatory',
                    variant: 'warning'
                })
            );
        
        this.showSpinner = true;

        // Get the list of uploaded files
        this.uploadedFiles = event.detail.files;
        this.fileName = event.detail.files[0].name;
        this.isFileUploaded = this.fileName ? true : false;

        let file = event.detail.files;
        console.log('==fiel===' + JSON.stringify(file));

        if (!file) {
            return this.dispatchEvent(new ShowToastEvent({
                title: 'warning',
                message: 'No File has selected',
                variant: 'warning'
            }));
        } else {
            this.showSpinner = false;
        }
    }

    //Handle Upload Button functionality
    uploadFileHandler() {
        console.log('111');
        if (!this.uploadObj.objectName)
            return this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Warning',
                    message: 'Object Name is mandatory',
                    variant: 'warning'
                })
            );

        if (this.uploadedFiles.length == 0)
            return this.dispatchEvent(
                new ShowToastEvent({
                    title: "Warning",
                    message: "CSV File has not added",
                    variant: "warning"
                })
            );

        this.showSpinner = true;
        // Get the list of records from the uploaded files
console.log('==this.uploadedFiles[0].documentId==' + this.uploadedFiles[0].documentId);
        // calling apex class csvFileread method
        csvFileUpload({
            contentDocumentId: this.uploadedFiles[0].documentId,
            objectName: this.uploadObj.objectName
        })
        .then(result => {
            console.log('===resul===' + JSON.stringify(result));
            this.data = result;
            this.showSpinner = false;

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'HAT Account records are created successfully',
                    variant: 'Success'
                }),
            );
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: this.uploadObj.objectName,
                    actionName: 'list'
                },
                state: {
                    filterName: 'All'
                }
            });
            this.uploadObj = {};
            this.isFileUploaded = false;
            this.uploadedFiles = [];
        })
        .catch(error => {
            console.log('---error---' + JSON.stringify(error));
            this.error = 'File mismatched / Improper data found';
            this.showSpinner = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: JSON.stringify(this.error),
                    variant: 'warning'
                }),
            );     
        })
    }

    //Download as CSV file
    exportToCSV() {
        console.log('==22==' + this.selectedObjectName);
        if (!this.uploadObj.objectName)
            return this.dispatchEvent(new ShowToastEvent({
                title: 'warning',
                message: 'Object Name is mandatory',
                variant: 'warning'
            }));

        this.showSpinner = true;
        var columnHeader = [];
        var jsonKeys = [];
        var fileName = '';

        this.objectOptions.forEach(row => {
            if (row.value == this.selectedObjectName) {
                fileName = row.label;
            }
        });

        if (this.selectedObjectName == 'HAT_Account__c') {
            columnHeader = ["ID", "DISTRIBUTION CHANNEL", "CUSTOMER GROUP", "CUSTOMER GROUP DESCRIPTON", "SOLD TO PARTY", "SOLD TO NAME"];
            jsonKeys = ["Name", "DistributionChannel", "CustomerGroup", "CustomerGroupDescription", "SoldToParty", "SoldToName"];
        } else if (this.selectedObjectName == 'Product_Allocation__c') {
            columnHeader = ["SALES ORG", "MATERIAL NUMBER", "MATERIAL DESCRIPTION", "PRODUCT ALLOCATION OBJECT NUMBER"];
            jsonKeys = ["SalesOrg", "MaterialNumber", "MaterialDescription", "AllocationObjectNumber"];
        } else if (this.selectedObjectName == 'Storage_Location__c') {
            columnHeader = ["ID", "PLANT CODE", "STORAGE LOCATION CODE"];
            jsonKeys = ["Name", "PlantCode", "StorageLocationCode"];
        } else if (this.selectedObjectName == 'Cut_Off_Compliance__c') {
            columnHeader = ["ID", "ACCOUNT GROUP NAME", "ORDER DROP", "BRANCH NAME", "SO DATE", "DELIVERY DATE"];
            jsonKeys = ["Name", "AccountGroupName", "OrderDrop", "BranchName", "SODate", "DeliveryDate"];
        }
        console.log('==this.csvLstArr==' + JSON.stringify(this.csvLstArr));
        // This array holds the keys in the json data
        var jsonRecordsData = this.csvLstArr;
        let csvIterativeData;
        let csvSeperator;
        let newLineCharacter;
        csvSeperator = ",";
        newLineCharacter = "\n";
        csvIterativeData = "";
        csvIterativeData += columnHeader.join(csvSeperator);
        csvIterativeData += newLineCharacter;

        for (let i = 0; i < jsonRecordsData.length; i++) {
            let counter = 0;
            for (let iteratorObj in jsonKeys) {
                let dataKey = jsonKeys[iteratorObj];
                if (counter > 0) {
                    csvIterativeData += csvSeperator;
                }
                if (jsonRecordsData[i][dataKey] !== null && jsonRecordsData[i][dataKey] !== undefined) {
                    csvIterativeData += '"' + jsonRecordsData[i][dataKey] + '"';
                } else {
                    csvIterativeData += '""';
                }
                counter++;
            }
            csvIterativeData += newLineCharacter;
        }
        console.log('==csvIterativeData==' + csvIterativeData)
        this.hrefdata = "data:text/csv;charset=utf-8," + encodeURI(csvIterativeData);
        let downloadElement = document.createElement('a');
        downloadElement.href = this.hrefdata;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = fileName + '.csv';
        document.body.appendChild(downloadElement);
        this.showSpinner = false;
        downloadElement.click();
    }
}