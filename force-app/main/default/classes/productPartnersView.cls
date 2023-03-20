public with sharing class productPartnersView {
    @AuraEnabled
    public static String fetchProducts() {
        
        List<Product2> product2List = [SELECT Id, 
                                        Name, 
                                        ProductCode,
                                        Brand_Name__c,
                                        Family,
                                        Generic_Name__c,
                                        StockKeepingUnit
                                        FROM   Product2 
                                        WHERE IsActive=true
                                        ORDER BY Name];
        return JSON.serialize(product2List);
    }
}