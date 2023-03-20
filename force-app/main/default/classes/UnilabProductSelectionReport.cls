/**
    * @description : This class used to fetch and insert the values in HAT Product Selection Object
*/
public with sharing class UnilabProductSelectionReport {
    /**
        * @description : This function used to get HAT Allocation Object Details.
        * @return      : allocationArr
    **/
    @AuraEnabled(cacheable=true)
    public static List<HAT_Allocation__c> fetchHATAllocationDetails(String recordId){
        List<HAT_Allocation__c> allocationArr = new List<HAT_Allocation__c>();
        try {
            if (Schema.sObjectType.HAT_Allocation__c.isAccessible()) {
                allocationArr = [SELECT Id, Name, Allocation_Type__c, Product_Allocation_Object_Number__c, Sales_Org__c,  SKU_SOH_QTY__c, Product__c, Product__r.Name, SKU_SOH_Amount__c, CreatedBy.Name, CreatedDate, LastModifiedDate FROM HAT_Allocation__c WHERE Id =: recordId];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return allocationArr;
    }
}