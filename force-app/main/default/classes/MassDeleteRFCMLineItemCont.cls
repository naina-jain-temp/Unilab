public class MassDeleteRFCMLineItemCont {
    
    @AuraEnabled
    public static void massDelete(String recordId){
        try{
            
            List<RFCM_Line_Item__C> lineItems = [SELECT id from RFCM_line_item__c where RFCM__c=: recordId];
            System.debug(lineItems);
            if(!lineItems.isEmpty()){
                delete lineItems;
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }

}