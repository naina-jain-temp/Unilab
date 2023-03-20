Trigger Promo_Trigger on Promo__c (before update, after insert, after update) {
    /*if(Trigger.isAfter && Trigger.isInsert){
        Promo_TriggerHandler.doAfterInsert(Trigger.new);
    } else */
    
    if(Trigger.isBefore && Trigger.isUpdate){
        Promo_TriggerHandler.doBeforeUpdate(Trigger.new, Trigger.newMap);
    }else if(trigger.IsAfter && trigger.IsUpdate){
        List<Id> promoId = new List<Id>();
        for(Promo__c promoRecord : Trigger.New){
            
            if(promoRecord.Status__c == 'Implemented'){
                promoId.add(promoRecord.Id);
            }
        }
        if(promoId.size() > 0){
            UNILAB_PAL_ImplementedEmail_Handler.doAfterUpdate(promoId);
            
        }
        
    }
}