import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import csvFileRead from '@salesforce/apex/UNILAB_HAT_Allocation.csvFileRead';

const columnsAccount = [
    { label: 'Name', fieldName: 'Name' }, 
    { label: 'Source', fieldName: 'AccountSource' },
    { label: 'Account Site', fieldName: 'Site'}, 
    { label: 'Type', fieldName: 'Type'}, 
    { label: 'Website', fieldName: 'Website', type:'url'}
];

export default class UnilabHATUpload extends LightningElement {
    @api recordId;
    @track error;
    @track columnsAccount = columnsAccount;
    @track data;
    @track value = '';

    
    uploadedFiles = [];
    isFileUploaded = false;

    // accepted parameters
    get acceptedCSVFormats() {
        return '.csv';
    }

    get options() {
        return [
            { label: 'Import', value: 'Import' },
            { label: 'Export', value: 'Export' },
        ];
    }

    get selectType() {
        return [{
            label: 'Import',
            value: 'Import'
        }, {
            label: 'Export',
            value: 'Export'
        }]
    }
    
    uploadFileHandler() {
        if (!this.uploadedFiles)
            return this.dispatchEvent(
                new ShowToastEvent({
                    title: "Warning",
                    message: "CSV File has not added",
                    variant: "warning"
                })
            );
        // Get the list of records from the uploaded files

        // calling apex class csvFileread method
        csvFileRead({
            contentDocumentId : this.uploadedFiles[0].documentId,
            productId: this.recordId
        })
        .then(result => {
            this.data = result;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'HAT Allocation Plan records are created based on the CSV file upload!!!',
                    variant: 'Success'
                }),
            );
            const redirectEvent = new CustomEvent('redirecttoallocation', {
                detail : {
                    first: true
                }
            });
            this.dispatchEvent(redirectEvent);
        })
        .catch(error => {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: JSON.stringify(error),
                    variant: 'error'
                }),
            );     
        })
    }

    
    handleUploadFinished(event) {        
        this.showSpinner = true;

        // Get the list of uploaded files
        this.uploadedFiles = event.detail.files;
        this.fileName = event.detail.files[0].name;
        this.isFileUploaded = this.fileName ? true : false;

        let file = event.detail.files;

        if (!file) {
            return this.dispatchEvent(new ShowToastEvent({
                label: 'warning',
                message: 'No File has selected',
                variant: 'warning'
            }));
        }
    }

    handleSelectType(event) {
        console.log('==event===' + JSON.stringify(event));
    }
}