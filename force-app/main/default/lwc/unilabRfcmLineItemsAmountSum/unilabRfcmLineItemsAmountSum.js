import { LightningElement,wire,api,track } from 'lwc';
import lineItemsAmount from "@salesforce/apex/unilab_RfcmLineItems.RfcmLineItemsAmount";
import { CurrentPageReference } from 'lightning/navigation';
  
export default class UnilabRfcmLineItemsAmountSum extends LightningElement {
    
    @api recordId;
    @track error;
    @track itemsAmount = []; 
    
    @track Total_claim=0;
     
    @wire(lineItemsAmount, { rfcmId:'$recordId'})
    wiredRecordsMethod({data,error}) {
        //alert('inside wire');
        if(data){
            console.log('@15'+JSON.stringify(data));
            var recs=[];
            var final_Amount=0;
            var cnt=1;
            for( var i=0;i<data.length; i++){
              // let totalValue=0;
                //totalValue=data[i].total;
                var  duumyrec= {
                    "sno":cnt++,    
                    "Company":data[i].Company_Name__c,
                    "total":data[i].total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","),
                };
                recs.push(duumyrec);
                console.log('@26'+JSON.stringify(recs));
                final_Amount+=data[i].total;
                console.log('@26'+final_Amount);
            }
            this.itemsAmount = recs;
            this.Total_claim=this.numberWithCommas(final_Amount);

            this.error = undefined;
        }else if (error) {
            console.log('error::'+error);
            this.error = error;
            this.itemsAmount = undefined;
            
        }
    }  
     numberWithCommas(x) {
        var z;
         x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        
         return z=x.toFixed(2);
      
        
     }
    

}