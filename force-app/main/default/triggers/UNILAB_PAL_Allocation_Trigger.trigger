trigger UNILAB_PAL_Allocation_Trigger on Allocation__c (before insert) {
	if(Trigger.isBefore && Trigger.isInsert){
        UNILAB_PAL_Allocation_TriggerHandler.doBeforeInsert(Trigger.new);
    }
}