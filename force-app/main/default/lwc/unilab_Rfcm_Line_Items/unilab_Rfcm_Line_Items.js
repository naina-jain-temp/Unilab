import { LightningElement, api, track, wire } from "lwc";
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from "lightning/navigation";
import lineItems from "@salesforce/apex/Unilab_RfcmLineItemsClass.RfcmLineItems";
import { updateRecord } from 'lightning/uiRecordApi';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    
  
  { label: "RFCM Line Item", fieldName: "Name", Type:"text", editable: false,initialWidth: 100, },
  { label: "Company", fieldName: "Company__c", Type:"text", editable: true,initialWidth: 150,},
   { label: "CM No", fieldName: "CM_No__c", Type:"text", editable: true,initialWidth: 100,},
   { label: "CM Acknowledged", fieldName: "CM_Acknowledged__c", type: 'text', editable: true,initialWidth: 150,},
  //{ label: "Contract Number", fieldName: "Contract_Number__c", Type:"Number", editable: true,initialWidth: 150,},
  { label: "Amount", fieldName: "unilab_Amount__c", Type:"Number", editable:true,initialWidth: 150,},
  { label: "Material Code", fieldName: "unilab_Material_Code__c", Type:"text", editable: true,initialWidth: 150,},
  { label: "Material Description", fieldName: "Material_Description__c", Type:"text",initialWidth: 250,},
  { label: "PPD/Contract", fieldName: "PPD_Contract", Type:"Number", editable: true,initialWidth: 150,},
 { label: "PPD Description", fieldName: "PPD_Description__c", Type:"text", editable: true,initialWidth: 150,},
  { label: "Customer code", fieldName: "Customer_Code__c", Type:"text", editable:true,initialWidth: 150,},
   { label: "Customer Name", fieldName: "Customer_Name", Type:"text", editable: true,initialWidth: 150,},
 
  //{ label: "Validation", fieldName: "unilab_Validation__c", Type:"text", editable: true,initialWidth: 150,},
 // { label: "Status", fieldName: "Status__c", Type:"text", editable: true,initialWidth: 150,},
 
 
  //{Type:"text", editable:false,initialWidth: 0,},
];

export default class unilab_Rfcm_Line_Items extends NavigationMixin(LightningElement) {
  @api recordId;
 //@track data1=[];
 @track error;
  @track columns = columns;
  draftValues = [];
    @track value;
    @api sortedDirection = 'asc';
    @api sortedBy = 'Name';
    @api searchKey = '';
    //result;
    @track getAccId=[];
    @track page = 1; 
    @track items = []; 
    @track data = [];
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @track pageSize = 10; 
    @track totalRecountCount = 0;
    @track totalPage = 0;
    saveDraftValues =[];
    error;
    @ track updated;
    @track recData;
    @track log;
   
 
    @wire(lineItems, { rfcmId:'$recordId'})
    logList(result) {
        if (result.data) {
            this.log = result.data;
            console.log('testingleela'+this.log);
            this.error = undefined;

            let preparedArr = [];
            result.data.forEach(record => {
                let preparedRec = {};
                preparedRec.Name = record.Name;
                preparedRec.Company__c = record.Company__c;
               // preparedRec.Contract_Number__c = record.Contract_Number__c;
                preparedRec.CM_No__c = record.CM_No__c;
                preparedRec.CM_Acknowledged__c = record.CM_Acknowledged__c;
                preparedRec.unilab_Amount__c = record.unilab_Amount__c;
                preparedRec.unilab_Material_Code__c = record.unilab_Material_Code__c;
                preparedRec.Material_Description__c = record.Material_Description__c;
                preparedRec.PPD_Contract= record.PPD_Contract__r.Name;
                preparedRec.PPD_Description__c = record.PPD_Description__c;
                preparedRec.Customer_Code__c = record.Customer_Code__c;

                preparedRec.Customer_Name = record.Customer_Name__r.Name;

                preparedArr.push(preparedRec);
            });
            this.items = preparedArr;
            
        } else if (result.error) {
            this.items = undefined;
            this.error = result.error;
        } 
    }  
  handleSave(event) {
    this.saveDraftValues = event.detail.draftValues;
    const recordInputs = this.saveDraftValues.slice().map(draft => {
        const fields = Object.assign({}, draft);
        return { fields };
    });

    // Updateing the records using the UiRecordAPi
    const promises = recordInputs.map(recordInput => updateRecord(recordInput));
    Promise.all(promises).then(res => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Records Updated Successfully!!',
                variant: 'success'
            })
        );
        this.saveDraftValues = [];
        
        eval("$A.get('e.force:refreshView').fire();");
        return refreshApex(this.items);
    }).catch(error => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'An Error Occured!!',
                variant: 'error'
            })
        );
    }).finally(() => {
        this.saveDraftValues = [];
    });
    
}

// This function is used to refresh the table once data updated
async refresh() {
    await refreshApex(this.items);
}
    
navigateToRecordViewPage(event) {
    const row = event.detail.row;

    // View a custom object record.
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: row.Id,
            objectApiName: 'RFCM_line_item__c',
            actionName: 'edit'
        }
    });
}    
  

}