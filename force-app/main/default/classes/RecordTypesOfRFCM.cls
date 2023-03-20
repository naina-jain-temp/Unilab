public class RecordTypesOfRFCM {
    @AuraEnabled(cacheable=true)
    public static list<recordtype> getAllRecordTypes(){
        
        return[select Id,Name,description from Recordtype  where sobjecttype= 'RFCM__c' ORDER BY Name DESC ];
    }
    @AuraEnabled(cacheable=true)
    public static string getRecordTypeName(string RecordTypeId){
        
        string RecordTypeName;
        List<Recordtype> RecordtypeList=[select Id,Name from Recordtype where Id=: RecordTypeId];
        for(Recordtype Rec:RecordtypeList){
            RecordTypeName = Rec.Name;
        }
        return RecordTypeName;
        
    }

    @AuraEnabled(cacheable = true)
    public static String getFieldDependency(String recordTypeName){
        return JSON.serialize([SELECT Id, Classification__c, Condition_Type__c, Customer_Team__c,Record_Type__c,Customer_Sub_Team__c, Programs__c from RFCM_fields_dependency__mdt where Record_Type__c =: recordTypeName]);
    }


    @AuraEnabled
    public static boolean isCommunity(){
        String siteId = Site.getSiteId(); // take a look at the apex class Site, you may find more useful method concerning site/community
        if (siteId != null) {
            return true;
        }
        return false;
    }
    
   /* @AuraEnabled(cacheable=true)
    public static void SaveFormData(object Formdata){
        String str = JSON.serialize(Formdata); 
       System.debug(str);
        
    
    }*/
}