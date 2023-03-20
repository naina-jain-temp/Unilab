trigger NEON_UploadISPlan_AutoBrandTarget on NEON_IS_Plan__c (before insert, after insert) {
    NEON_UploadISPlanLog_TriggerHandler triggerHandler = new NEON_UploadISPlanLog_TriggerHandler();
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            triggerHandler.beforeInsertBranchValue(Trigger.new);
        }
    } else {
        if(Trigger.isInsert) {
            triggerHandler.afterInsertLogs(Trigger.new);
        }
    }
}