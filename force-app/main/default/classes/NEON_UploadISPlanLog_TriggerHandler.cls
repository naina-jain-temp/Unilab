public class NEON_UploadISPlanLog_TriggerHandler {
    public NEON_Product__c prodBU {get;set;}
    public List<NEON_User_Matrix__c> userMatrix {get;set;}
    
    public void beforeInsertBranchValue(List<NEON_IS_Plan__c> newISP) {
        for(NEON_IS_Plan__c isplan : newISP) {
            //if(isplan.Account_Type__c <> 'Head Office') {
            if(isplan.Account_Record_Type_Name__c <> 'Main/Warehouse') {
                isplan.Branch_Target__c = 1;
            }
        }
    }
    
    public void afterInsertLogs(List<NEON_IS_Plan__c> newISP) {
        String userId = userInfo.getUserId();
        List<NEON_IS_Plan_Log__c> ispLog = new List<NEON_IS_Plan_Log__c>();
        List<NEON_IS_Plan__c> setProd = new List<NEON_IS_Plan__c>();
        
        for(NEON_IS_Plan__c isp : newISP) {
            setProd.add(new NEON_IS_Plan__c(Product__c=isp.Product__c));
        }
        
        prodBU = [SELECT BU__c FROM NEON_Product__c WHERE Product__c = :setProd[0].Product__c];    
        userMatrix = [SELECT Id FROM NEON_User_Matrix__c WHERE User__c = :userId];
        for(NEON_IS_Plan__c isp : newISP) {
            ispLog.add(new NEON_IS_Plan_Log__c(NEON_IS_Plan__c = isp.Id,
                                                NEON_Product__c = isp.NEON_Product__c,
                       							NEON_User_Matrix__c = userMatrix[0].Id,
                       							BU__c = prodBU.BU__c,
                                              	Status__c = 'Draft'));
        }
        insert ispLog;
    }
}