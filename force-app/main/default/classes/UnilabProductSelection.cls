public with sharing class UnilabProductSelection {
    @AuraEnabled(cacheable=true)
    public static List<HAT_Allocation__c> getProductSelection (String recordId) {
        List<HAT_Allocation__c> hatLst = new List<HAT_Allocation__c>();

        if (Schema.sObjectType.HAT_Allocation__c.isAccessible()) {
            hatLst = [SELECT Id, Name, Allocation_Type__c, Allocation_Month__c, Product_Allocation_Object_Number__c, Product__r.Name, Storage_Location__r.Storage_Location_Code__c, SKU_SOH_QTY__c, Product__r.Product_Allocation_Object_Number__c, Product__r.Sales_Org__c, Product__r.Item_Case__c, Product__r.Item_Code__c, Product__r.Item_Description__c, Product__r.Division__c, Product__r.UOM__c, Item_Price_w_o_VAT__c FROM HAT_Allocation__c WHERE Id =: recordId];
        }
        return hatLst;
    }
    @AuraEnabled(cacheable=true)
    public static List<string> getRowValue(){
        List<String> rowListReturn= new List<String>();
        List<Row_Values__mdt> rowList = [SELECT Order__c, Name__c FROM Row_Values__mdt ORDER BY Order__c];
        for (Row_Values__mdt row : rowList){
            rowListReturn.add(row.Name__c);
        }
        return rowListReturn;
    }
}