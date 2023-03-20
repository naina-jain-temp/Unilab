/*----------------------------------------------------------------------------------------------------
Author       :   Zeus Lopez-Dee and Mark Palacios
Created Date :   03.01.2019
Definition   :   APEX Controller Class for UNILAB_CreatePromo Lightning Component
-----------------------------------------------------------------------------------------------------*/
public class UNILAB_CreatePromo_Controller {
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        
        List < String > allOpts = new list < String > ();
        
        try {
            
            // Get the object type of the SObject.
            Schema.sObjectType objType = objObject.getSObjectType();
            
            // Describe the SObject using its object type.
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            
            // Get a map of fields for the SObject
            map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
            
            // Get the list of picklist values for this field.
            List < Schema.PicklistEntry > values =
                fieldMap.get(fld).getDescribe().getPickListValues();
            
            // Add these values to the selectoption list.
            for (Schema.PicklistEntry a: values) {
                allOpts.add(a.getValue());
            }
            
            allOpts.sort();
            
        }
        catch (Exception e) {
            throw new AuraHandledException('Error in fetching Promo Type Selection: ' + e.getMessage());    
        }
        
        return allOpts;
        
        
        
    }
    
    @AuraEnabled
    public static List < AggregateResult > getSubBrands(String brand) {	
        
        List<AggregateResult> subBrandList = new List<AggregateResult>();
        
        try {
            
            subBrandList = [SELECT Sub_Brand_Name__c FROM Product2 WHERE Brand_Name__c =: brand GROUP BY Sub_Brand_Name__c];
            subBrandList.sort();
            
        }catch (Exception e) {
            throw new AuraHandledException('Error in fetching Product Sub Brands: ' + e.getMessage());    
        }
        
        
        return subBrandList;
        
    }
    
    @AuraEnabled
    public static List < Product2 > getBaseProducts(String brand, List<String> subBrandList) {
        
        List < Product2 > baseProductList = new List<Product2>();
        
        try {
            
            baseProductList = [SELECT Id, Name FROM Product2 WHERE Brand_Name__c =: brand AND Sub_Brand_Name__c IN :subBrandList];
            baseProductList.sort();
            
        }catch (Exception e) {
            throw new AuraHandledException('Error in fetching Base Product: ' + e.getMessage());    
        }
        
        
        return baseProductList;
        
    }
    
    @AuraEnabled
    public static List < Product2 > getSKU(String brand, List<String> subBrandList, List<String> baseProdList) {
        
        List < Product2 > prodSKUList = new List<Product2>();
        
        try {
            
            prodSKUList = [SELECT Id, Name FROM Product2 WHERE Brand_Name__c =: brand AND Id NOT IN :baseProdList];
            prodSKUList.sort();
            
        }catch (Exception e) {
            throw new AuraHandledException('Error in fetching Product SKUs: ' + e.getMessage());    
        }
        
        return prodSKUList;
        
    }
        
    @AuraEnabled
    public static String insertPromo(Promo__c promo, List<Id> baseProd, List<Id> skuProd) {
        
        Promo__c newPromo = new Promo__c();
        List<Promo_Product__c> newPromoProduct = new List<Promo_Product__c>();
        
        try {
            
            newPromo.Promo_Name__c = promo.Promo_Name__c;
            newPromo.Promo_Type__c = promo.Promo_Type__c;
            newPromo.Start_Date__c = promo.Start_Date__c;
            newPromo.End_Date__c = promo.End_Date__c;
            
            insert newPromo;
            
            for(String product1 : baseProd){
                Promo_Product__c promoBaseProduct = new Promo_Product__c();
                promoBaseProduct.Promo__c = newPromo.Id;
                promoBaseProduct.Product__c = product1;
                promoBaseProduct.Product_Type__c = 'Base';
                newPromoProduct.add(promoBaseProduct);
            }
            
            if(skuProd != null){
                for(String product2 : skuProd){
                    Promo_Product__c promoSKUProduct = new Promo_Product__c();
                    promoSKUProduct.Promo__c = newPromo.Id;
                    promoSKUProduct.Product__c = product2;
                    promoSKUProduct.Product_Type__c = 'SKU';
                    newPromoProduct.add(promoSKUProduct);
                } 
            }
            
            insert newPromoProduct;
            
        }catch (Exception e) {
            throw new AuraHandledException('Error in saving Promo: ' + e.getMessage());    
        }
        
        return newPromo.Id;
        
    }
    
    @AuraEnabled
    public static Promo__c getPromoToBeCloned (Id recordId) {
        Promo__c promoRec = new Promo__c();
        
        try{
            promoRec = [SELECT Id,Promo_Name__c,Start_Date__c,End_Date__c, Promo_Type__c FROM Promo__c WHERE Id =: recordId];
        }catch(Exception e){
            throw new AuraHandledException('Error in retrieving Promo record: '
                                           + e.getMessage());    
            
        }
        
        return promoRec;
    }
    
    @AuraEnabled
    public static Product2 getPromoProductBrandToBeCloned (Id promoRecId) {
        Promo_Product__c promoProdList = new Promo_Product__c();
        Product2 prodBrand = new Product2();
        
        try{
            promoProdList = [SELECT Id,Name, Product__c, Product_Type__c 
                             FROM Promo_Product__c 
                             WHERE Promo__c =: promoRecId
                             AND Product_Type__c = 'BASE'
                             LIMIT 1];
            
            prodBrand = [SELECT Id, Name, Brand_Name__c FROM Product2 WHERE Id=:promoProdList.Product__c];
            prodBrand.Name = prodBrand.Brand_Name__c;
        }catch(Exception e){
            throw new AuraHandledException('Error in retrieving Promo Product record: '
                                           + e.getMessage());    
            
        }
        
        return prodBrand;
    }
    
    @AuraEnabled
    public static List<String>  getPromoProdSubBrandToBeCloned (Id promoRecId) {
        Set<String> subBrands = new Set<String>();
        List<String> subBrandList=new List<String>();
        List<Promo_Product__c> promoProdList = new List<Promo_Product__c>();
        Product2 prods = new Product2();
        try{
            promoProdList = [SELECT Id,Name, Product__c, Product_Type__c 
                             FROM Promo_Product__c 
                             WHERE Promo__c =: promoRecId
                             AND Product_Type__c = 'BASE'];
            
            for (Integer i = 0; i < promoProdList.size(); i++) {
                prods = [SELECT Sub_Brand_Name__c 
                         FROM Product2 
                         WHERE Id=:promoProdList[i].Product__c 
                         LIMIT 1];
                subBrands.add(prods.Sub_Brand_Name__c);
            }
            
            subBrandList.addAll(subBrands);
        }catch(Exception e){
            throw new AuraHandledException('Error in retrieving Promo Product Sub Brand Record: '
                                           + e.getMessage());    
        }
        return subBrandList;
    }
    
    @AuraEnabled
    public static List<Id>  getBasePromoProdToBeCloned (Id promoRecId) {
        Set<Id> baseProdSet = new Set<Id>();
        List<Id> baseProdList = new List<Id>();
        List<Promo_Product__c> promoProdList = new List<Promo_Product__c>();
        Product2 prods = new Product2();
        
        try{
            promoProdList = [SELECT Id,Name, Product__c, Product_Type__c 
                             FROM Promo_Product__c 
                             WHERE Promo__c =: promoRecId
                             AND Product_Type__c = 'BASE'];
            
            for (Integer i = 0; i < promoProdList.size(); i++) {
                prods = [SELECT Id, Name 
                         FROM Product2 
                         WHERE Id=:promoProdList[i].Product__c 
                         LIMIT 1];
                baseProdSet.add(prods.Id);
            }
            
            baseProdList.addAll(baseProdSet);
        }catch(Exception e){
            throw new AuraHandledException('Error in retrieving BASE Promo Product Sub Brand Record: '
                                           + e.getMessage());    
        }
        return baseProdList;
    }
    
    @AuraEnabled
    public static List<Id>  getSKUPromoProdToBeCloned (Id promoRecId) {
        Set<Id> skuProdSet = new Set<Id>();
        List<Id> skuProdList = new List<Id>();
        List<Promo_Product__c> promoProdList = new List<Promo_Product__c>();
        Product2 prods = new Product2();
        
        try{
            promoProdList = [SELECT Id,Name, Product__c, Product_Type__c 
                             FROM Promo_Product__c 
                             WHERE Promo__c =: promoRecId
                             AND Product_Type__c = 'SKU'];
            
            for (Integer i = 0; i < promoProdList.size(); i++) {
                prods = [SELECT Id, Name 
                         FROM Product2 
                         WHERE Id=:promoProdList[i].Product__c 
                         LIMIT 1];
                skuProdSet.add(prods.Id);
            }
            
            skuProdList.addAll(skuProdSet);
        }catch(Exception e){
            throw new AuraHandledException('Error in retrieving SKU Promo Product Sub Brand Record: '
                                           + e.getMessage());    
        }
        return skuProdList;
    }
    
    @AuraEnabled
    public static Boolean cancelPromoStatus(String recordId, String reason){
        Promo__c promoRecord = new Promo__c();
        Boolean isImplemented = false;
        promoRecord = [SELECT Id, Status__c,RecordTypeId FROM Promo__c WHERE Id =: recordId];
        if(promoRecord.Status__c == 'Implemented'){
            isImplemented = true;
        }else{
            isImplemented = false;
            
            promoRecord.Status__c = 'Canceled';
            promoRecord.Reason_for_Cancelation__c = reason;
            promoRecord.RecordTypeId = Schema.SObjectType.Promo__c.getRecordTypeInfosByName().get('Cancelled').getRecordTypeId();
            
            
            List<Allocation__c> relatedAllocRecords = new List<Allocation__c>();
            
            relatedAllocRecords = fetchRelatedAllocationRecords(recordId);
            for(Allocation__c allocRecord : relatedAllocRecords){
                
                allocRecord.Status__c = 'Canceled';
                allocRecord.RecordTypeId = Schema.SObjectType.Allocation__c.getRecordTypeInfosByName().get('Cancelled').getRecordTypeId();
            }
            try{
                update promoRecord;
                update relatedAllocRecords;
            }catch(Exception e){
                System.debug('ERROR:' + e.getMessage());
            }
            
        }
        
        return isImplemented;
    }
    
    public static List<Allocation__c> fetchRelatedAllocationRecords(String recordId){
        return [SELECT Id, Status__c,RecordTypeId FROM Allocation__c
                WHERE Promo__c =: recordId];
        
    }
    
    
}