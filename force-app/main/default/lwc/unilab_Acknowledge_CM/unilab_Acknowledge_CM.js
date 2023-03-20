import { LightningElement,track, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';
import { CloseActionScreenEvent } from 'lightning/actions';
import getRfcmlineitems from '@salesforce/apex/Unilab_RfcmLineItemsClass.getRfcmlineitems'

export default class Unilab_Acknowledge_CM extends LightningElement {
    @api recordId;
    @track errorCheck = false;
    @track message = 'Please wait.';
    @wire(CurrentPageReference)currentPageReference;

    connectedCallback(){
        //this.recordId = this.currentPageReference.state.recordId;
        this.acknowledgeRFCM();
    }
    acknowledgeRFCM(event){
        //alert('inside acknowledge');
        getRfcmlineitems({ rfcmId : this.recordId})
        .then( (responseJson) => {
            if( responseJson == true){
                const selectedEvent = new CustomEvent("close", {
                    detail:  'close'
                  });
              
                  // Dispatches the event.
                 this.dispatchEvent(selectedEvent);
            }/*else{
                this.checkData();
            }*/
        }).catch( error => {
            alert('this.errorMessage'+error.message);
            //If there is an error on response
        }) 
    }

}