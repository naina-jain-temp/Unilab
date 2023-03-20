trigger RunCAR on Case (before insert) {
    RunCAR_TriggerHandler triggerHandler = new RunCAR_TriggerHandler();
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            triggerHandler.beforeInsertCase();
        }
    }
}