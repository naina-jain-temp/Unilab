import { LightningElement,track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import {NavigationMixin} from 'lightning/navigation';  
import checkCommunity from '@salesforce/apex/RecordTypesOfRFCM.isCommunity';
export default class Unilab_RFCM_Forms extends NavigationMixin(LightningElement) {
    @track recordTypeScreen=true;
    @track saverecordscreen=false;
    @track filerecordscreen=false;
    @track filescreen=false;
    @track Buttontrue=true;
    @track recordtypeid;
    @track recordid;
    @track isCommunity;
    @track headingName='New RFCM';



    connectedCallback(){
        checkCommunity()
        .then(result => {
           this.isCommunity = result;

        })
        .catch(error => {
            this.error = error;
           
        })
    }





    @wire(CurrentPageReference)
    pageRef;
    closeModalPopup(){
        console.log('closeModalPopup');
        const selectedEvent = new CustomEvent("close", {
            detail:  'close'
          });
      
          // Dispatches the event.
         this.dispatchEvent(selectedEvent);
    }
    
    capturerecordtypeid(event){
        console.log('event detail ==>@@##'+JSON.stringify(event.detail));
        this.recordtypeid = event.detail;
        this.Buttontrue=false;
    }

    saveNext(event){
        if( this.recordTypeScreen == true){
            this.recordTypeScreen =false;
            this.saverecordscreen = true;
        }
        this.headingName = 'New RFCM - '+this.recordtypeid.Id;
    }

    saveData(event){
        if( this.saverecordscreen == true){
            this.template.querySelector('c-unilab-detail-form').saveData();
        }
    }

    recorddetails(event){
        this.recordid = event.detail;
        console.log('event.detail'+event.detail);
        this.saverecordscreen = false;
        this.filerecordscreen = true;
        this.headingName = 'Attachments';
        //this.template.querySelector('c-uni-lab-attachment-component').parentData(event.detail);
    }

    handleChange(){
        /*
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                actionName: "view",
                recordId: this.recordId,
                objectApiName:"RFCM__c",
            }
        }); 
        */
     // alert(JSON.stringify(this.pageRef));
     console.log(this.isCommunity);
     if(this.isCommunity == true){
        window.location.href = window.location.origin +'/partners/s/rfcm/'+this.recordid+'/'; 
     }
     else{
        window.location.href = window.location.origin +'/lightning/r/RFCM__c/'+this.recordid+'/view';
     }
    
     
      
    }



}