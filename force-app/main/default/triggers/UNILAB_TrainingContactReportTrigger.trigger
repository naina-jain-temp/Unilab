trigger UNILAB_TrainingContactReportTrigger on Training_Contact_Report__c (before delete, after update) {
    
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            UserRole userRole = [SELECT Id,Name FROM UserRole WHERE Id =:UserInfo.getUserRoleId()];
            if(!userRole.Name.equalsIgnoreCase('System Administrator')){
                for(Training_Contact_Report__c tcr : trigger.old){
                    if(!tcr.Status__c.equals('Draft')){
                        tcr.adderror('Training Contact Report Cannot be deleted');
                    }
                }
            }
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            //UNILAB_TCR_Trigger_Handler.groupChannelPost(Trigger.New);
        }
    }
}