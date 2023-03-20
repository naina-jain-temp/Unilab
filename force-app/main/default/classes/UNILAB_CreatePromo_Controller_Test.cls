/*----------------------------------------------------------------------------------------------------
Authors      :   Kristjan Mariano and Mark Palacios
Created Date :   05.06.2019
Definition   :   Test Class for UNILAB_PAL CreatePromo Controller
-----------------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_CreatePromo_Controller_Test {
    
    @testSetup static void setup(){
        //Create Multiple Products
        UNILAB_PAL_TestDataFactory.insertProducts();
        
        //Create Promo
        UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
    }
    
    //Scenario: Check Promo Type Picklist Values
    //Positive Test
    @isTest static void checkPromoTypePicklistValues(){
        
        String fieldName = 'Promo_Type__c';
        String sObjectName = 'Promo__c';
        Schema.SObjectType sOType = Schema.getGlobalDescribe().get(sObjectName);
        SObject sOName = sOType.newSObject();
        
        Test.startTest();
        List<String> allOpts = UNILAB_CreatePromo_Controller.getselectOptions(sOName,fieldName);
        Test.stopTest();
        
        System.debug('Picklist Values of ' + fieldName + ' = ' + allOpts);
    }
    
    //Scenario: Check Promo Type Picklist Values
    //Negative Test
    @isTest static void checkPromoTypePicklistValues_NegativeTest(){
        Test.startTest();
        try{
            List<String> allOpts = UNILAB_CreatePromo_Controller.getselectOptions(null,null);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
        Test.stopTest();
    }

    //Scenario: Check Sub Brands
    //Positive Test
    @isTest static void checkProd2SubBrand() {
        
        List<Product2> dummyListOfProds = UNILAB_PAL_TestDataFactory.getProducts();
        
        Test.startTest();
        List<AggregateResult> subBrandList = UNILAB_CreatePromo_Controller.getSubBrands(dummyListOfProds[0].Brand_Name__c);
        Test.stopTest();
        
        System.debug('LIST OF SUB BRANDS ' +subBrandList);
    }
    
    //Scenario: Check Sub Brands
    //Negative Test
    @isTest static void checkProd2SubBrand_Negative() {
        
        Test.startTest();
        List<AggregateResult> subBrandList = UNILAB_CreatePromo_Controller.getSubBrands(null);
        Test.stopTest();

    }
    
    @isTest static void checkNullProd2() {
        
        Test.startTest();
        List<AggregateResult> subBrandList = UNILAB_CreatePromo_Controller.getSubBrands(null);
        Test.stopTest();
        
        System.debug('LIST OF SUB BRANDS' +subBrandList);
        
    }
    // Scenario: Check Base Product Coverage
    // Positive Test
    @isTest static void checkProd2BaseProduct() {
        
        List<Product2> dummyListOfProds = UNILAB_PAL_TestDataFactory.getProducts();
        List<String> subBrandList = new List <String>();
        
        subBrandList.add(dummyListOfProds[0].Sub_Brand_Name__c);
        
        Test.startTest();
        List<Product2> baseProduct = UNILAB_CreatePromo_Controller.getBaseProducts(dummyListOfProds[0].Brand_Name__c , subBrandList);
        Test.stopTest();
        
        System.debug('LIST OF BASE PRODUCT' +baseProduct);
    }
    
    // Scenario: Check Base Product Coverage
    // Negative Test
    @isTest static void checkProd2BaseProduct_NegativeTest() {
        
        Test.startTest();
        try{
            List<Product2> baseProduct = UNILAB_CreatePromo_Controller.getBaseProducts(null, null);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
        Test.stopTest();

    }
    
    // Scenario: Check SKU coverage
    // Positive Test
    @isTest static void checkProd2SKU() {
        
        List<Product2> dummyListOfProds = UNILAB_PAL_TestDataFactory.getProducts();
        List<String> subBrandList = new List <String>();
        List<String> baseProductList = new List<String>();

        subBrandList.add(dummyListOfProds[0].Sub_Brand_Name__c);
        baseProductList.add(dummyListOfProds[0].Name);
        
        Test.startTest();
        List<Product2> skuProduct = UNILAB_CreatePromo_Controller.getSKU(dummyListOfProds[0].Brand_Name__c , subBrandList, baseProductList);
        Test.stopTest();
        
        System.debug('LIST OF SKU Products' +skuProduct);
    }
    
    // Scenario: Check SKU coverage
    // Negative Test
    @isTest static void checkProd2SKU_NegativeTest() {
        
        Test.startTest();
        try{
            List<Product2> skuProduct = UNILAB_CreatePromo_Controller.getSKU(null, null, null);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
        Test.stopTest();
    }
    
    
    //Scenario: Insert Single Promo
    //Positive Test
    @isTest static void insertNewPromo(){
        
        List<Product2> dummyListOfProds = UNILAB_PAL_TestDataFactory.getProducts();
        System.debug('PRODUCTS: ' + dummyListOfProds);
        Promo__c dummyPromo = new Promo__c(Promo_Name__c = 'New Promo',
                                            Promo_Type__c = 'Consumer Redemption',
                                            Start_Date__c = Date.today(),
                                            End_Date__c = Date.today()+30,
                                            //Brand__c = dummyListOfProds[0].Brand_Name__c,
                                            Reason_for_Cancelation__c = 'Sample Reason');
        
        
        List<String> baseProductList = new List<String>();
        List<String> skuProductList = new List<String>();

		Integer i = 0;
        for(Product2 prodRecord:dummyListOfProds){
            
            if(i<=5){
                baseProductList.add(dummyListOfProds[i].Id);
                i++;
            }else{
                skuProductList.add(dummyListOfProds[i].Id);
                i++;
            }
        }
        
        System.debug('SKU:' + skuProductList);

        Test.startTest();
        String newPromo = UNILAB_CreatePromo_Controller.insertPromo(dummyPromo , baseProductList, skuProductList);
        Test.stopTest();
    }
    
    //Scenario: Create Promo record
    //Negative Test
    @isTest static void insertNewPromo_NegativeTest(){
        
        Promo__c dummyPromo = new Promo__c();
        List<Product2> dummyListOfProds = UNILAB_PAL_TestDataFactory.getProducts();
        List<String> baseProductList = new List<String>();
        List<String> skuProductList = new List<String>();

        Integer i = 0;
        for(Product2 prodRecord:dummyListOfProds){
            
            if(i<=5){
                baseProductList.add(dummyListOfProds[i].Id);
                i++;
            }else{
                skuProductList.add(dummyListOfProds[i].Id);
                i++;
            }
        }
        
        Test.startTest();
        try{
            String newPromo = UNILAB_CreatePromo_Controller.insertPromo(dummyPromo , baseProductList, skuProductList);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();

        
    }
    
    //Scenario: Fetch Promo for cloning
    //Positive
    @isTest static void fetchPromoToBeCloned(){
        UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        Promo__c promoRecord = [SELECT Id FROM Promo__c LIMIT 1];
        
        test.startTest();
        UNILAB_CreatePromo_Controller.getPromoToBeCloned(promoRecord.Id);
        test.stopTest();
    }
    
    //Scenario: Fetch Promo for cloning
    //Negative
    @isTest static void fetchPromoToBeCloned_NegativeTest(){
        Promo__c promoRecord = new Promo__c();
        
        test.startTest();
        try{
            UNILAB_CreatePromo_Controller.getPromoToBeCloned(promoRecord.Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch Promo Product for cloning
    //Positive
    @isTest static void fetchPromoProductToBeCloned(){
        List<Product2> dummyListOfProds = UNILAB_PAL_TestDataFactory.getProducts();
        System.debug('PRODUCTS: ' + dummyListOfProds);
        Promo__c dummyPromo = new Promo__c(Promo_Name__c = 'New Promo',
                                            Promo_Type__c = 'Consumer Redemption',
                                            Start_Date__c = Date.today(),
                                            End_Date__c = Date.today()+30,
                                            //Brand__c = dummyListOfProds[0].Brand_Name__c,
                                            Reason_for_Cancelation__c = 'Sample Reason');
        
        List<String> baseProductList = new List<String>();
        List<String> skuProductList = new List<String>();

		Integer i = 0;
        for(Product2 prodRecord:dummyListOfProds){
            
            if(i<=5){
                baseProductList.add(dummyListOfProds[i].Id);
                i++;
            }else{
                skuProductList.add(dummyListOfProds[i].Id);
                i++;
            }
        }

        String newPromo = UNILAB_CreatePromo_Controller.insertPromo(dummyPromo , baseProductList, skuProductList);

        
        test.startTest();
        UNILAB_CreatePromo_Controller.getPromoProductBrandToBeCloned(newPromo);
        test.stopTest();
    }
    
    //Scenario: Fetch Promo Product for cloning
    //Negative
    @isTest static void fetchPromoProductToBeCloned_NegativeTest(){
        Promo__c promoRecord = new Promo__c();
        
        test.startTest();
        try{
            UNILAB_CreatePromo_Controller.getPromoProductBrandToBeCloned(promoRecord.Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch Sub Brand for cloning
    //Positive
    @isTest static void fetchPromoProdToBeCloned(){
        List<Product2> dummyListOfProds = UNILAB_PAL_TestDataFactory.getProducts();
        System.debug('PRODUCTS: ' + dummyListOfProds);
        Promo__c dummyPromo = new Promo__c(Promo_Name__c = 'New Promo',
                                            Promo_Type__c = 'Consumer Redemption',
                                            Start_Date__c = Date.today(),
                                            End_Date__c = Date.today()+30,
                                            //Brand__c = dummyListOfProds[0].Brand_Name__c,
                                            Reason_for_Cancelation__c = 'Sample Reason');
        
        List<String> baseProductList = new List<String>();
        List<String> skuProductList = new List<String>();

		Integer i = 0;
        for(Product2 prodRecord:dummyListOfProds){
            
            if(i<=5){
                baseProductList.add(dummyListOfProds[i].Id);
                i++;
            }else{
                skuProductList.add(dummyListOfProds[i].Id);
                i++;
            }
        }

        String newPromo = UNILAB_CreatePromo_Controller.insertPromo(dummyPromo , baseProductList, skuProductList);
        
        test.startTest();
        UNILAB_CreatePromo_Controller.getPromoProdSubBrandToBeCloned(newPromo);
        test.stopTest();
    }
    
    //Scenario: Fetch Sub Brand for cloning
    //Negative Test
    @isTest static void fetchPromoProdToBeCloned_NegativeTest(){
        Promo__c promoRecord = new Promo__c(); 
        
        test.startTest();
        try{
            UNILAB_CreatePromo_Controller.getPromoProdSubBrandToBeCloned(promoRecord.Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
        test.stopTest();
    }
    
    //Scenario: Fetch Base Product for cloning
    //Positive Test
    @isTest static void fetchBaseProductToBeCloned(){
        List<Product2> dummyListOfProds = UNILAB_PAL_TestDataFactory.getProducts();
        System.debug('PRODUCTS: ' + dummyListOfProds);
        Promo__c dummyPromo = new Promo__c(Promo_Name__c = 'New Promo',
                                            Promo_Type__c = 'Consumer Redemption',
                                            Start_Date__c = Date.today(),
                                            End_Date__c = Date.today()+30,
                                            //Brand__c = dummyListOfProds[0].Brand_Name__c,
                                            Reason_for_Cancelation__c = 'Sample Reason');
        
        List<String> baseProductList = new List<String>();
        List<String> skuProductList = new List<String>();

		Integer i = 0;
        for(Product2 prodRecord:dummyListOfProds){
            
            if(i<=5){
                baseProductList.add(dummyListOfProds[i].Id);
                i++;
            }else{
                skuProductList.add(dummyListOfProds[i].Id);
                i++;
            }
        }

        String newPromo = UNILAB_CreatePromo_Controller.insertPromo(dummyPromo , baseProductList, skuProductList);
        test.startTest();
        UNILAB_CreatePromo_Controller.getBasePromoProdToBeCloned(newPromo);
        test.stopTest();
    }
    
    //Scenario: Fetch Base Product for cloning
    //Negative Test
    @isTest static void fetchBaseProductToBeCloned_NegativeTest(){
        Promo__c promoRecord = new Promo__c();
        
        test.startTest();
        try{
            UNILAB_CreatePromo_Controller.getBasePromoProdToBeCloned(promoRecord.Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
        
        test.stopTest();
    }
    
    //Scenario: Fetch SKU Product for cloning
    //Positive Test
    @isTest static void fetchSKUProductToBeCloned(){
        List<Product2> dummyListOfProds = UNILAB_PAL_TestDataFactory.getProducts();
        System.debug('PRODUCTS: ' + dummyListOfProds);
        Promo__c dummyPromo = new Promo__c(Promo_Name__c = 'New Promo',
                                            Promo_Type__c = 'Consumer Redemption',
                                            Start_Date__c = Date.today(),
                                            End_Date__c = Date.today()+30,
                                            //Brand__c = dummyListOfProds[0].Brand_Name__c,
                                            Reason_for_Cancelation__c = 'Sample Reason');
        
        List<String> baseProductList = new List<String>();
        List<String> skuProductList = new List<String>();

		Integer i = 0;
        for(Product2 prodRecord:dummyListOfProds){
            
            if(i<=5){
                baseProductList.add(dummyListOfProds[i].Id);
                i++;
            }else{
                skuProductList.add(dummyListOfProds[i].Id);
                i++;
            }
        }

        String newPromo = UNILAB_CreatePromo_Controller.insertPromo(dummyPromo , baseProductList, skuProductList);
        test.startTest();
        UNILAB_CreatePromo_Controller.getSKUPromoProdToBeCloned(newPromo);
        test.stopTest();
    }
    //Scenario: Fetch SKU Product for cloning
    //Negative Test
    @isTest static void fetchSKUProductToBeCloned_NegativeTest(){
        Promo__c promoRecord = new Promo__c();
        
        test.startTest();
        try{
            UNILAB_CreatePromo_Controller.getSKUPromoProdToBeCloned(promoRecord.Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
        
        test.stopTest();
    }
    
    //Scenario: Cancel Promo
    //Positive Test
    @isTest static void cancelPromoRecord(){
        Promo__c promoRecord = [SELECT Id FROM Promo__c LIMIT 1];
        
        test.startTest();
        UNILAB_CreatePromo_Controller.cancelPromoStatus(promoRecord.Id, 'reason');
        test.stopTest();
    }
    
    
}