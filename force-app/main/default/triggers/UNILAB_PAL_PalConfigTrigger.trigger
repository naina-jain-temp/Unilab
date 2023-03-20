trigger UNILAB_PAL_PalConfigTrigger on PAL_Configuration__c (before update, before insert) {

    if(Trigger.isBefore && Trigger.isUpdate){
        
        UNILAB_PAL_Configuration_TriggerHandler.doBeforeUpdate(Trigger.new);
    }
}