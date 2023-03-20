/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.14.2017
Definition   :   Controller for Event Cancellation page
History      :   07.14.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
public class UNILAB_EventCancellationPageCX{
    public Id recId;
    public Event eventRec{get;set;}
    public UNILAB_EventCancellationPageCX(){
        recId = apexpages.currentpage().getparameters().get('Id');
        eventRec = new Event(Id = recId);
    }
    
    public PageReference saveEvent(){
        try{
            if(eventRec.Reason_for_Cancellation__c == null || eventRec.Reason_for_Cancellation__c == ''){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add a reason for cancellation.'));
            }else{
                if(eventRec.Reason_for_Cancellation__c == 'Others' && (eventRec.Others__c == '' || eventRec.Others__c == null)){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Others field is required.'));
                }else{
                    eventRec.Status__c = 'Cancelled';
                    update eventRec;
                    return new PageReference('/'+String.valueOf(eventRec.Id));
                }  
            }
            
        }catch(Exception ex){
            system.Debug(ex.getMessage());
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0) );
            ApexPages.addMessage(msg);
        }
        return null;
    }
}