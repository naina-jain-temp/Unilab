trigger CompetitiveActivity_Trigger on Competitive_Activity__c (after insert, after update) {
    
    Trigger_Switch__c tafAfterInsert = Trigger_Switch__c.getValues('TAF_AfterInsert_RecordNotification');
    Trigger_Switch__c tafAfterUpdate = Trigger_Switch__c.getValues('TAF_AfterUpdate_RecordNotification');
    
    if (Trigger.isAfter) {
        
        if (Trigger.isInsert) {
            
            if (tafAfterInsert.Is_Active__c) {
                
                CompetitiveActivity_TriggerHandler.postToChatterAfterInsert(Trigger.new);
                
            }
            
        }
        
        if (Trigger.isUpdate) {
            
            if (tafAfterUpdate.Is_Active__c) {
                
                CompetitiveActivity_TriggerHandler.postToChatterAfterUpdate(Trigger.newMap, Trigger.oldMap);
                
            }
            
        }
        
    }

}