public class UNILAB_MCR_SubmForm {
	@AuraEnabled
    public static String submitForm(Double lat, Double lon, String networkTest, String remarks, String recordId) {
        //String userId = userInfo.getUserId();
        //Map<String,String> currentSessionAttributes = Auth.SessionManagement.getCurrentSession();
        //String ip = currentSessionAttributes.get('SourceIp');
        
        
        MCR__c mcrRec = [select Id from MCR__c where Id = :recordId];
        mcrRec.Latitude__c = lat;
        mcrRec.Longitude__c = lon;
        //mcrRec.IP_Address__c = ip;
        mcrRec.Network_Test__c = networkTest;
        mcrRec.Remarks__c = remarks;

        update mcrRec;
        
        return mcrRec.Id;
        
    }
}