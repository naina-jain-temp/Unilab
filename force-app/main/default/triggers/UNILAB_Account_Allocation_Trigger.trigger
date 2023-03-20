trigger UNILAB_Account_Allocation_Trigger on Account_Allocation__c (before delete) {
    if(Trigger.isBefore && Trigger.isDelete){
        UNILAB_Account_Allocation_TriggerHandler.doBeforeDelete(Trigger.old, Trigger.oldMap);
    }
}