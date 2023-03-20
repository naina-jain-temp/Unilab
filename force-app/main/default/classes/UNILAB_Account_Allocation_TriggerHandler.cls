/*-------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   04.08.2019
Definition   :   Trigger Handler for UNILAB_Account_Allocation_Trigger
-------------------------------------------------------------------------------------------*/
public class UNILAB_Account_Allocation_TriggerHandler {
    public static void doBeforeDelete(List<Account_Allocation__c> oldRecords,Map<Id,Account_Allocation__c> oldMapRecords){
        
        List<Account_Allocation__c> accAlloc = [SELECT Allocation__r.Status__c 
                                                 FROM Account_Allocation__c 
                                                 WHERE Id=:oldMapRecords.keySet()];
        User loggedUser = [SELECT Id,Name,UserRole.Name FROM User WHERE id =: userInfo.getUserId()];
        for(Account_Allocation__c accAllocRec : oldRecords){
            for(Account_Allocation__c accAllocWithStatus : accAlloc){
                if(loggedUser.UserRole.Name != 'System Administrator'){
                    if(accAllocWithStatus.Allocation__r.Status__c == 'Finalized'){
                        String errorMessage = 'Cannot delete account allocation that has a finalized allocation.';
                        accAllocRec.addError(errorMessage,false);
                    }
                }else{
                    if(accAllocWithStatus.Allocation__r.Status__c == 'Finalized'){
                        String errorMessage = 'Cannot delete account allocation that has a finalized allocation.';
                        accAllocRec.addError(errorMessage,false);
                    }
                }
                
            }
            
        }
    }
}