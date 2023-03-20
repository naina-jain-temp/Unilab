public with sharing class unilab_RfcmLineItems {
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> RfcmLineItemsAmount(String rfcmId){
        return [SELECT Material__r.Company_Name__c, sum(unilab_Amount__c)total  FROM RFCM_line_item__c WHERE RFCM__c =: rfcmId  GROUP BY Material__r.Company_Name__c ];
    }

}