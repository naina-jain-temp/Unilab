import { LightningElement,track,api } from 'lwc';
import getRecords from '@salesforce/apex/RFCM_Form_Creation.getRecords';


export default class UnilabDynamicLookup extends LightningElement {
    @track  lookupControll="slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click";
    @track  lookupControl1="slds-input slds-combobox__input slds-combobox__input-value slds-show";
    @track lookupControl2="slds-pill_container slds-hide";
    @track usersLoadSpinner = false;
    @track serch='';
    @track selectedRecordName;
    @track filteredNames;
    @track norecordcombobox = false;
    @api icon='slds-icon_container slds-icon-standard-account';
    @api fieldname;
    @api objectname;
    @api fieldsnames;
    @api disableinput = false;

    //combobox
    @track pickListTop;
    @track comboboxheader = 'No Records found';

    showRecord(event){
        this.filteredNames = [];
        this.norecordcombobox = false;
        this.serch = event.target.value;
        //call apex class
        getRecords({searchkey : this.serch ,ObjectName : this.objectname,fieldsname : this.fieldsnames})
        .then( (result) =>{
            console.log('data'+JSON.stringify(result));
            if(result.length != 0){
                this.filteredNames = result;
                this.comboboxheader = 'All Data';
            }else{
                
                this.norecordcombobox = true;
                this.comboboxheader = 'No Records found';               
            }
            
        });
        this.lookupControll ="slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open";
    }

    remove(event){
        this.serch = null;
        this.lookupControl1="slds-input slds-combobox__input slds-combobox__input-value slds-show";
        this.lookupControl2="slds-pill_container slds-hide";

        //events will need to right
        var record ={Id:'',Name:'',description:''};
        //events will need to right
        if( this.objectname == 'Account'){
            const selectedEvent = new CustomEvent("accountdetails", {
                detail:  record
              });
          
              // Dispatches the event.
             this.dispatchEvent(selectedEvent);
        }
        if( this.objectname == 'Project_Proposal_Document__c'){
            const selectedEvent = new CustomEvent("projectdetails", {
                detail:  record
              });
          
              // Dispatches the event.
             this.dispatchEvent(selectedEvent);
        }
        if( this.objectname == 'SAFE__c'){
            const selectedEvent = new CustomEvent("contractdetails", {
                detail:  record
              });
          
              // Dispatches the event.
             this.dispatchEvent(selectedEvent);
        }
    }

    closeCombobox(event){
        this.lookupControll ="slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click";
        this.serch = null;
    }

    selectedRecord(event){
        console.log(event.target.dataset.recid);
        console.log(event.target.dataset.name);
        this.lookupControll ="slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click";
        this.lookupControl1="slds-input slds-combobox__input slds-combobox__input-value slds-hide";
        this.lookupControl2="slds-pill_container slds-show";
        this.selectedRecordName=event.target.dataset.name;

        var record ={Id:event.target.dataset.recid,Name:event.target.dataset.name,description:'',customcode:''};

        //events will need to right
        if( this.objectname == 'Account'){
            record.customcode = this.filteredNames[event.target.dataset.indx].Branch_Code__c;
            const selectedEvent = new CustomEvent("accountdetails", {
                detail:  record
              });
          
              // Dispatches the event.
             this.dispatchEvent(selectedEvent);
        }
        if( this.objectname == 'Project_Proposal_Document__c'){
            this.filteredNames[event.target.dataset.indx];
            record.description = this.filteredNames[event.target.dataset.indx].PPD_Description__c;
            record.customcode = this.filteredNames[event.target.dataset.indx].Company__c;
            const selectedEvent = new CustomEvent("projectdetails", {
                detail:  record
              });
          
              // Dispatches the event.
             this.dispatchEvent(selectedEvent);
        }
        if( this.objectname == 'SAFE__c'){
            this.filteredNames[event.target.dataset.indx];
            record.description = this.filteredNames[event.target.dataset.indx].Contract_Description__c;
            record.customcode = this.filteredNames[event.target.dataset.indx].Project_Proposal_Document__r.Company__c;
            console.log('SAFE__c'+JSON.stringify(record));
            const selectedEvent = new CustomEvent("contractdetails", {
                detail:  record
              });
          
              // Dispatches the event.
             this.dispatchEvent(selectedEvent);
        }
        

    }
}