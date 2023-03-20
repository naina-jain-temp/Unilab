import { LightningElement,api } from 'lwc';
import massDelete from '@salesforce/apex/MassDeleteRFCMLineItemCont.massDelete';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class MassDeleteRFCMLineItems extends LightningElement {
    @api recordId

    @api invoke() {
        massDelete({recordId : this.recordId})
        .then(result => {

            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Success',
                    message: 'Delete Successfull',
                    variant: 'success'
                } )
            );

            eval("$A.get('e.force:refreshView').fire();")
         
        })
        .catch(error => {
            
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Error Deleting Line Items',
                    message: error.body.message,
                    variant: 'error'
                } )
            );
           
        })
    }
}