public class RFCM_Form_Creation {
	@AuraEnabled(cacheable=true)
    public static List < Map < String, String >> getPickListValues(String objApiName, String fieldName) {
        List < Map < String, String >> options = new List < Map < String, String >> ();
        Map < String, Schema.SObjectType > objGlobalMap = Schema.getGlobalDescribe();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objApiName);
        if (objType == null) {
            return options;
        }
        Schema.DescribeSObjectResult sobjectDescribe = objType.getDescribe();
        Map < String, Schema.SObjectField > fieldMap = sobjectDescribe.fields.getMap();
        if (fieldMap.get(fieldName) == null) {
            return options;
        }
        List < Schema.PicklistEntry > pickListValues = fieldMap.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry f: pickListValues) {
            Map < String, String > values = new Map < String, String > {
                'label' => f.getLabel(),
                'value' => f.getValue()
            };
            options.add(values);
        }
        return options;
    }
    
    @auraEnabled
    public static List<Sobject> getRecords( String searchkey,String ObjectName,String fieldsname){
        String query = 'Select '+fieldsname+' from '+ObjectName;
        if(searchkey != null && searchkey!= '' && String.isEmpty(searchkey) == false && searchkey.length() != 0){
            query += ' where Name like \''+searchkey+'%%\'';
        }
        System.debug(query);
        query += ' limit 30';
        List<Sobject> data = Database.query(query);
        return data;
    }
    @auraEnabled
    public static wrapClas saveRecords( RFCM__c objRecord){
        System.debug('objRecord'+objRecord);
        wrapClas wrpcls = new wrapClas();        
        try{
           upsert objRecord;
           wrpcls.check = true;
           wrpcls.msg = objRecord.Id;
           //List<RFCM__share> rfcms = [select id from RFCM__share where id =:objRecord.Id and userOrGroupId =:objRecord.createdById];
           //if(rfcms.size() == 0){
            RFCMSharing.apexShareRead(objRecord.Id , objRecord.createdById);
           //}
           return wrpcls;
           
        }catch( Exception e){
           wrpcls.check = false;
           wrpcls.msg = e.getMessage();
           System.debug('==>'+e.getMessage());
           return wrpcls;
        }
        
    }
    
    public class wrapClas{
        @AuraEnabled public string msg;
        @AuraEnabled public boolean check;
    }
}