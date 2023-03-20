public class UNILAB_NEON_SubmitISPlan {
	
    @AuraEnabled
    public static List<NEON_User_Matrix__c> fetchData(String prodId) {
        String userId = userInfo.getUserId();
        NEON_Product__c prodBU = [SELECT BU__c 
                                  FROM NEON_Product__c 
                                  WHERE Id = :prodId];
        List<NEON_User_Matrix__c> ctData = [SELECT Customer_Team__c
                                        	FROM NEON_User_Matrix__c
                                        	WHERE User__c = :userId
                                           		AND BU__c = :prodBU.BU__c];
        return ctData;
    }
    
    @AuraEnabled
    public static string updateISP(List<NEON_User_Matrix__c> ctData, String prodId) {
        List<String> ctList = new List<String>();
        String returnresponse ='';
        
        for(NEON_User_Matrix__c um : ctData) {
            ctList.add(um.Customer_Team__c);
        }
        List<NEON_IS_Plan__c> updateISPList = new List<NEON_IS_Plan__c>();
        for(NEON_IS_Plan__c ispList : [SELECT Id, 
                                   		  IS_Status__c 
                                   FROM NEON_IS_Plan__c 
                                   WHERE CT_Customer_Team_Name__c IN :ctList 
                                   		AND NEON_Product__c = :prodId]) {
        	NEON_IS_Plan__c isp = new NEON_IS_Plan__c();
            isp.Id = ispList.Id;
            isp.IS_Status__c = 'Submitted';
            updateISPList.add(isp);
        }
        
        if(updateISPList.size() > 0){
            try {
                update updateISPList;
                afterUpdateLogs(updateISPList);
                returnresponse = prodId;
            }
            catch(Exception ex){
                returnresponse = 'ERROR';
            }
        }
        return returnresponse;
    }
    
    public static void afterUpdateLogs(List<NEON_IS_Plan__c> updatedISP) {
        List<NEON_IS_Plan_Log__c> ispLog = new List<NEON_IS_Plan_Log__c>();
        
        for(NEON_IS_Plan_Log__c isp : [SELECT Id 
                                       FROM NEON_IS_Plan_Log__c
                                       WHERE NEON_IS_Plan__c IN : updatedISP
                                      ]) {
            ispLog.add(new NEON_IS_Plan_Log__c(Id = isp.Id,
                                              	Status__c = 'Submitted'
                                              ));
        }
        update ispLog;
    }
}