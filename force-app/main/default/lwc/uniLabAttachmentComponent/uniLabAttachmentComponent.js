import { LightningElement,api,track,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import updateFiles from '@salesforce/apex/FileUploadController.updateFiles';
import deleteFile from '@salesforce/apex/FileUploadController.deleteFile';
import getFiles from '@salesforce/apex/FileUploadController.getFiles';

//import Name from '@salesforce/schema/Account.Name';
export default class uniLabAttachmentUploadComponent extends NavigationMixin (LightningElement) {
    
    @track openModalpopupForFileupload=true;
    @track error;
    @track files;
    @track selectedFileId;
    @api rfId;
    @track filesAccountConc;
    @track filesBilling;
    @track filesImplementation;
    
    @api 
    parentData(resp){
        this.rfId=resp;
        console.log('@22'+this.rfId);
    }
    
  /*  closeModalPopupForFileupload(){
        this.openModalpopupForFileupload=false;
    } */

    navigateToFile(event) {
        this.selectedFileId  = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state : {
                recordIds: this.selectedFileId ,
                selectedRecordId : this.selectedFileId
            }
        })
    }

    deleteSelectedFile(event){
        debugger;
        const deleteDocId = event.currentTarget.dataset.id;
        deleteFile({contentDocumentId : deleteDocId})
            .then((result) => {
                        console.log('success')
                        const evt = new ShowToastEvent({
                        title: 'File Delete Status.',
                        message: 'File delete successfully.',
                        variant: 'success',
                        });
                        this.dispatchEvent(evt); 
                 this.getFileData(this.rfId,result)
            })
            .catch((error) => {
                console.log('error')
            });
    }

    getFileData(currentRecId,fileName){
        getFiles({recordId : currentRecId,fileName : fileName})
            .then((result) => {
                if(fileName.includes('Proof Of Account Concurrence'))
                    this.filesAccountConc = result 
                else if(fileName.includes('Proof Of Billing / Deduction')){
                    this.filesBilling = result 
                }    
                else if(fileName.includes('Proof Of Implementation')){
                    this.filesImplementation = result 
                }
            })
            .catch((error) => {
                console.log('error')
            });
    } 


    //This method fires after files got uploaded
    handleUploadFinished1(event) {
        
        //const name = event.target.Title;
        const uploadedFiles = event.detail.files;
        console.log('uploadedFiles '+JSON.stringify(uploadedFiles))
        console.log('recordId  '+this.rfId) 
        const lastIndexOfDot = uploadedFiles[0].name.lastIndexOf(".");
        let title = '';
        if(lastIndexOfDot > 0){
            title = uploadedFiles[0].name.substring(0, lastIndexOfDot);
            title = title + '_Proof Of Account Concurrence';
        }
        else 
         title = 'Proof Of Account Concurrence';
         

        updateFiles({ documentId: uploadedFiles[0].documentId, title:title,recordId: this.rfId})
        .then((result) => {
            console.log('success')
            this.filesAccountConc = result;
        })
        .catch((error) => {
            console.log('error')
        }); 
        const evt = new ShowToastEvent({
            title: 'File Upload Status...',
            message: uploadedFiles.length + 'file(s) uploaded successfully.',
            variant: 'success',
        });
        this.dispatchEvent(evt);    
        
    }

        handleUploadFinished2(event) {
           debugger;
            //const name = event.target.Title;
            const uploadedFiles = event.detail.files; 
            console.log('uploadedFiles '+uploadedFiles)
             console.log('recordId  '+this.rfId) 
        const lastIndexOfDot = uploadedFiles[0].name.lastIndexOf(".");
        let title = '';
        if(lastIndexOfDot > 0){
            title = uploadedFiles[0].name.substring(0, lastIndexOfDot);
            title = title + '_Proof Of Billing / Deduction';
        }
        else 
         title = 'Proof Of Billing / Deduction';
         
            updateFiles({ documentId: uploadedFiles[0].documentId, title:title,recordId: this.rfId})
            .then((result) => {
                console.log('success')
                this.filesBilling = result;
            })
            .catch((error) => {
                console.log('error')
            });
            const evt = new ShowToastEvent({
                title: 'File Upload Status...',
                message: uploadedFiles.length + 'file(s) uploaded successfully.',
                variant: 'success',
            });
            this.dispatchEvent(evt);    
          
        }

        handleUploadFinished3(event) {
           debugger;
            //const name = event.target.Title;
            const uploadedFiles = event.detail.files;
            console.log('uploadedFiles '+uploadedFiles) 
            console.log('recordId  '+this.rfId) 
             const lastIndexOfDot = uploadedFiles[0].name.lastIndexOf(".");
        let title = '';
        if(lastIndexOfDot > 0){
            title = uploadedFiles[0].name.substring(0, lastIndexOfDot);
            title = title + '_Proof Of Implementation';
        }
        else 
         title = 'Proof Of Implementation';
         

             updateFiles({ documentId: uploadedFiles[0].documentId, title:title,recordId: this.rfId})
            .then((result) => {
                console.log('success')
                this.filesImplementation = result;
            })
            .catch((error) => {
                console.log('error')
            });
            const evt = new ShowToastEvent({
                title: 'File Upload Status...',
                message: uploadedFiles.length + 'file(s) uploaded successfully.',
                variant: 'success',
            });
            this.dispatchEvent(evt);    
          
        }
    
    /*    handleChange(event){
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId:this.rfId,
                    //objectApiName: 'RFCM__c',
                    actionName: 'view',
                },
            });
            
        } */
        
       
        


   
}