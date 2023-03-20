public with sharing class Unilab_RfcmLineItemsClass {
    public Unilab_RfcmLineItemsClass() {

    }
    @AuraEnabled(cacheable=true)
    public static List<RFCM_line_item__c> RfcmLineItems(String rfcmId){
        system.debug('rfcmtest'+rfcmId);
        return [select Id,CM_No__c,unilab_Amount__c,Company__c,Customer_Name__r.Name,PPD_Contract__r.Name,Customer_Code__c,Material_Description__c,PPD_Description__c,Name,unilab_Material_Code__c,RFCM__c,unilab_Validation__c from RFCM_line_item__c where RFCM__c=:rfcmId];
}

@AuraEnabled(cacheable=true)
public static List<RFCM_line_item__c> getRfcm( String searchKey, String sortBy, String sortDirection) {
   
    String query = 'select Id,unilab_Amount__c,unilab_Company__c,Customer_Name__c,Customer_Code__c,Material_Description__c,PPD_Description__c,Name,unilab_Material_Code__c,PPD_Contract__c,RFCM__c,unilab_Validation__c from RFCM_line_item__c';
    if (!String.isBlank(searchKey)) {
        String key = '%' + searchKey + '%';
        query += ' WHERE Name LIKE :key';
    }
    if ( sortBy != null && sortDirection != null ) {
        query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
    }
    system.debug(query);
    return Database.query( query );
}

@AuraEnabled
public static boolean getRfcmlineitems( String rfcmId) {
    system.debug('inside apexs');
    List<RFCM_line_item__c> rfcmlitems= [select Id,CM_No__c,CM_Acknowledged__c from RFCM_line_item__c where RFCM__c=:rfcmId AND CM_No__c!=''];
    system.debug('rfcmlitems::'+rfcmlitems);
    List<RFCM_Line_Item__c> updaterfcmlitems = new List<RFCM_Line_Item__c>();
    if(rfcmlitems.size()>0){
        for(RFCM_line_item__c rf : rfcmlitems){
            rf.CM_Acknowledged__c = true;
            updaterfcmlitems.add(rf);
        }
        update updaterfcmlitems;
    }
    return true;
}
}