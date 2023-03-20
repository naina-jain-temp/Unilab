import { LightningElement,wire,track,api } from 'lwc';
import getRecordTypes from '@salesforce/apex/RecordTypesOfRFCM.getAllRecordTypes';
import getRecordTypeName from '@salesforce/apex/RecordTypesOfRFCM.getRecordTypeName';
export default class Unilab_RFCM_Record_Types extends LightningElement {
    @track recordTypes;
    @track error;
    @track RecordTypeVal;
    @track Buttontrue=true;
    
    @wire(getRecordTypes)
    wiredRFCMRecordTypes({error,data}){
        if(data){
            var records = [];
            for( var i=0;i<data.length; i++){
                var  duumyrec= {"check":'',"Id":data[i].Id,"Name":data[i].Name,"Description":data[i].Description};
                records.push(duumyrec);
            }
            this.recordTypes=records;
            console.log(JSON.stringify(this.recordTypes));
        }else if(error){
           console.log("error=====>"+error);
           this.error=error;
           this.recordTypes=undefined;
        }
        
    }
    ChanageRecordType(event){
        var data = this.recordTypes;
        console.log('record==>'+JSON.stringify(data));
        var records =[];
        data.forEach(element => {
            if( element.Id == event.target.dataset.recid ){
                element.check = true;
            }else{
                element.check = false;
            }
            records.push(element);
        });
        this.recordTypes = records;

        var record={Id:event.target.name,Name:event.target.dataset.recid};
        console.log('record==>'+JSON.stringify(record));
        const selectedEvent = new CustomEvent("detail", {
            detail:  record
          });
          // Dispatches the event.
         this.dispatchEvent(selectedEvent);

    }
}