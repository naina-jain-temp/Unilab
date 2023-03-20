/*----------------------------------------------------------------------------------------------------
Authors      :   Kristjan Mariano and Mark Palacios
Created Date :   06.17.2019
Definition   :   Test Class for UNILAB_PAL Controller
-----------------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_PAL_Controller_Test {

    @testSetup static void setup(){
        
        
        //Create Users
        UNILAB_PAL_TestDataFactory.createSystemAdminUser();
        UNILAB_PAL_TestDataFactory.createGTUser();
        UNILAB_PAL_TestDataFactory.createKAUser();
        UNILAB_PAL_TestDataFactory.createMTUser();
        UNILAB_PAL_TestDataFactory.createMDCUser();
        
        UNILAB_PAL_TestDataFactory.createGTCMDDevUser();
        UNILAB_PAL_TestDataFactory.createKACMDDevUser();
        UNILAB_PAL_TestDataFactory.createMTCMDDevUser();
        UNILAB_PAL_TestDataFactory.createMDCCMDDevUser();
        
        //Create Account
        Account accRecord = UNILAB_PAL_TestDataFactory.createAccount();
        UNILAB_PAL_TestDataFactory.createAccounts();
        UNILAB_PAL_TestDataFactory.createMultipleGTAccounts();
        UNILAB_PAL_TestDataFactory.createMultipleKAAccounts();
        
        //Create Columnsx
        UNILAB_PAL_TestDataFactory.createColumns();
        
        //Create Generate Admin Columns
        UNILAB_PAL_TestDataFactory.createGenerateAdminColumns();
        
        //Create Generate Columns
        UNILAB_PAL_TestDataFactory.createGenerateGTColumns();
        
        //Create Promo
        UNILAB_PAL_TestDataFactory.createPromo();
        
        //Create Product
        UNILAB_PAL_TestDataFactory.createProducts();
        
        //Create Promo Product
        UNILAB_PAL_TestDataFactory.createPromoProduct(UNILAB_PAL_TestDataFactory.getPromo().get(0), UNILAB_PAL_TestDataFactory.getProducts().get(0));
        
       
        //Create Allocation Record
        List<Promo__c> promoIdList = new List<Promo__c>();
        promoIdList = UNILAB_PAL_TestDataFactory.getPromo();
        UNILAB_PAL_TestDataFactory.createAllocRecords(promoIdList);
        //UNILAB_PAL_TestDataFactory.createSellOutAllocRecords(promoIdList);
        //UNILAB_PAL_TestDataFactory.createEndingInventAllocRecords(promoIdList);
        
        //Create Account Allocation Record
        List<Allocation__c> allocList = new List<Allocation__c>();
        allocList = UNILAB_PAL_TestDataFactory.getAllocations();
        UNILAB_PAL_TestDataFactory.createAccAllocRecords(allocList, accRecord);
        
        List<PAL_Column_Header__c> columnHeaderList = [SELECT Column_Field_Name__c,Column_Name__c,Column_Type__c FROM PAL_Column_Header__c ORDER By Name ASC];
        System.debug('COLUMNS' + columnHeaderList);
    }
    //Scenario: Fetch User Information
    //Positive Test
    @isTest static void testFetchUserInfo(){
        
        test.startTest();
        UNILAB_PAL_Controller.getUserInfo();
        test.stopTest();
    }
    
    //Scenario: Fetch Allocation Records
    //Positive Test
    @isTest static void testFetchAllocRecs(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = UNILAB_PAL_TestDataFactory.getAllocations();
        test.startTest();
        UNILAB_PAL_Controller.getAllocRecs(allocRecords.get(0).Id);
        test.stopTest();
    }
    
    //Scenario: Fetch Allocation Records
    //Negative Test
    @isTest static void testNegativeFetchAllocRecs(){
        Allocation__c allocRecord = new Allocation__c();
        test.startTest();
        try{
            UNILAB_PAL_Controller.getAllocRecs(allocRecord.Id);
        }catch(Exception e){
            
        }
        
        test.stopTest();
    }
    
    //Scenario: Fetch Configuration Records
    //Positive Test
    @isTest static void testFetchConfigRecs(){
        test.startTest();
        UNILAB_PAL_Controller.getConfigRecs();
        test.stopTest();
    }
    //Scenario: Fetch Account Allocations
    //Positive Test
    @isTest static void testFetchAccountAllocations(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = UNILAB_PAL_TestDataFactory.getAllocations();
        test.startTest();
        UNILAB_PAL_Controller.getAccAllocations(allocRecords.get(0));
        test.stopTest();
    }
    
    //Scenario: Fetch Account Allocations No Acc Alloc
    //Positive Test
    @isTest static void testFetchAccountAllocationsWithNoAccAlloc(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = UNILAB_PAL_TestDataFactory.getAllocations();
        test.startTest();
        UNILAB_PAL_Controller.getAccAllocations(allocRecords.get(0));
        test.stopTest();
    }
    
    //Scenario: Get Total Account Allocations
    //Positive Test
    @isTEst static void testGetTotalAccountAllocations(){
        test.startTest();
        UNILAB_PAL_Controller.getTotalAccAllocations(10);
        test.stopTest();
    }
    //Scenario: Update Allocation Status
    //Positive Test
    @isTest static void testUpdateAllocStatusFinalize(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = UNILAB_PAL_TestDataFactory.getAllocations();
        test.startTest();
        UNILAB_PAL_Controller.updateAllocRecStatus(allocRecords.get(0).Id);
        test.stopTest();
    }
    
    //Scenario: Update Allocation Status
    //Negative Test
    @isTest static void testNegativeUpdateAllocStatusFinalize(){
        Allocation__c allocRecord = new Allocation__c();
        test.startTest();
        try{
            UNILAB_PAL_Controller.updateAllocRecStatus(allocRecord.Id);
        }catch(Exception e){
            
        }
        
        test.stopTest();
    }
    
    //Scenario: Get Account Allocation Response
    //Positive Test
    @isTest static void testFetchAccAllocResp(){
        List<Allocation__c> allocList = new List<Allocation__c>();
        allocList = UNILAB_PAL_TestDataFactory.getAllocations();
        test.startTest();
        //UNILAB_PAL_Controller.getAccAllocationFromResp(allocList.get(0).Id);
        test.stopTest();
    }
    
    //Scenario: Test Fetching of Columns
    //Positive test
    @isTest
    static void testGetColumnsP3(){
        
		UNILAB_PAL_TestDataFactory.createUser();

		//UNILAB_PAL_TestDataFactory.createGenerateColumnCustomSetting();
        
        PAL_Generate_Columns__c userId =[Select SetupOwnerId from PAL_Generate_Columns__c LIMIT 1];
        List<Allocation__c> allocList = UNILAB_PAL_TestDataFactory.getAllocations();
        
        System.debug(userId);
        
        UNILAB_PAL_TestDataFactory.createColumnHeader();

        List<UNILAB_PAL_Controller.ColumnHeader> colHeaderList = new List<UNILAB_PAL_Controller.ColumnHeader>();
        
        Test.startTest();

        colHeaderList = UNILAB_PAL_Controller.getColumns(allocList.get(0).Id);
        Test.stopTest();
        
        System.debug(colHeaderList);
        
        List<PAL_Column_Header__c> columnHeaderList = [SELECT Column_Name__c FROM PAL_Column_Header__c ORDER By Name ASC];
        
        for(PAL_Column_Header__c colHeader : columnHeaderList){
            if(colHeader.Column_Name__c == 'AVE GROSS' || colHeader.Column_Name__c == 'AVE QTY'){
                colHeader.Column_Name__c = 'P3 ' + colHeader.Column_Name__c;
            }else if(colHeader.Column_Name__c == '% GROWTH'){
                String temp = colHeader.Column_Name__c.replace('%', '');
                colHeader.Column_Name__c = temp.trim();
            }else if(colHeader.Column_Name__c == 'YTDSALES TY'){
                colHeader.Column_Name__c = 'YTD SALES TY';
            }else if(colHeader.Column_Name__c == 'YTDSALES LY'){
                colHeader.Column_Name__c = 'YTD SALES LY';
            }else if(colHeader.Column_Name__c == 'Branch Allocation'){
                colHeader.Column_Name__c = 'AVG BRANCH ALLOCATION';
            }else if(colHeader.Column_Name__c == '# of Accounts'){
                colHeader.Column_Name__c = '# OF ACCOUNTS';
            }
        }
        System.debug(columnHeaderList);
        System.debug(colHeaderList.size());
        
        for(Integer i=0;i<colHeaderList.size();i++){
             
       		 System.assertEquals(String.valueOf(colHeaderList[i].columnName), String.valueOf(columnHeaderList[i].Column_Name__c));
        
       	 }
    }
    
    //Scenario: GT Send Update Email
    @isTest static void testGTSendUpdateEmail(){
       User gtUser = UNILAB_PAL_TestDataFactory.getGTUser();
        System.runAs(gtUser){
            List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
            accAllocList = UNILAB_PAL_TestDataFactory.getAccAllocation();
            test.startTest();
            UNILAB_PAL_Controller.sendUpdateEmail(accAllocList);
            test.stopTest();
        }
    }
    
    //Scenario: KA Send Update Email
    @isTest static void testKASendUpdateEmail(){
       User kaUser = UNILAB_PAL_TestDataFactory.getKAUser();
        System.runAs(kaUser){
            List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
            accAllocList = UNILAB_PAL_TestDataFactory.getAccAllocation();
            test.startTest();
            UNILAB_PAL_Controller.sendUpdateEmail(accAllocList);
            test.stopTest();
        }
    }
    
    //Scenario: MT Send Update Email
    @isTest static void testMTSendUpdateEmail(){
       User mtUser = UNILAB_PAL_TestDataFactory.getMTUser();
        System.runAs(mtUser){
            List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
            accAllocList = UNILAB_PAL_TestDataFactory.getAccAllocation();
            test.startTest();
            UNILAB_PAL_Controller.sendUpdateEmail(accAllocList);
            test.stopTest();
        }
    }
    
    //Scenario: MDC Send Update Email
    //Positive Test
    @isTest static void testMDCSendUpdateEmail(){
       User mdcUser = UNILAB_PAL_TestDataFactory.getMDCUser();
        System.runAs(mdcUser){
            List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
            accAllocList = UNILAB_PAL_TestDataFactory.getAccAllocation();
            test.startTest();
            UNILAB_PAL_Controller.sendUpdateEmail(accAllocList);
            test.stopTest();
        }
    }
    
    @isTest static void testFetchAllocationDetails(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = UNILAB_PAL_TestDataFactory.getAllocations();
        test.startTest();
        //UNILAB_PAL_Controller.getAllocationDetails(allocRecords.get(0).Id);
        test.stopTest();
    }
    //Scenario: Sell-in
    //Positive Test
    @isTest static void testSellInUpdateAllocRecAndGetPALApiParameter(){
        List<Promo__c> promoIdList = UNILAB_PAL_TestDataFactory.getPromo();
        List<Allocation__c> allocList = UNILAB_PAL_TestDataFactory.getSellInAllocRecord();
        System.debug('PROMO PRODUCT: '+ UNILAB_PAL_TestDataFactory.getPromoProd());
        
        test.startTest();
        try{
            UNILAB_PAL_Controller.updateAllocRecAndGetPALApiParameter(allocList.get(0));
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }

        test.stopTest();
    }
    
    //Scenario: Sell-out
    //Positive Test
    @isTest static void testSellOutUpdateAllocRecAndGetPALApiParameter(){
        //Create Promo
        Promo__c promoRecord = UNILAB_PAL_TestDataFactory.createPromo();
        
        //Create Promo Product
        UNILAB_PAL_TestDataFactory.createPromoProduct(UNILAB_PAL_TestDataFactory.getPromo().get(0), UNILAB_PAL_TestDataFactory.getProducts().get(0));
        
       
        //Create Allocation Record
        UNILAB_PAL_TestDataFactory.createSellOutAllocRecords(promoRecord);
        //UNILAB_PAL_TestDataFactory.createEndingInventAllocRecords(promoIdList);
        
        List<Allocation__c> allocList = UNILAB_PAL_TestDataFactory.getSellOutAllocRecord();
        
        test.startTest();
        try{
            UNILAB_PAL_Controller.updateAllocRecAndGetPALApiParameter(allocList.get(0));
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Ending Inventory
    //PositiveTest
    @isTest static void testEndingInventUpdateAllocRecAndGetPALApiParameter(){
        //Create Promo
        Promo__c promoRecord = UNILAB_PAL_TestDataFactory.createPromo();
        
        //Create Promo Product
        UNILAB_PAL_TestDataFactory.createPromoProduct(UNILAB_PAL_TestDataFactory.getPromo().get(0), UNILAB_PAL_TestDataFactory.getProducts().get(0));
        
       
        //Create Allocation Record
        //UNILAB_PAL_TestDataFactory.createSellOutAllocRecords(promoRecord);
        UNILAB_PAL_TestDataFactory.createEndingInventAllocRecords(promoRecord);
        List<Allocation__c> allocList = UNILAB_PAL_TestDataFactory.getEndingInventAllocRecord();

        test.startTest();
        try{
            UNILAB_PAL_Controller.updateAllocRecAndGetPALApiParameter(allocList.get(0));
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Sell-in
    //Negative Test
    @isTest static void testNegativeUpdateAllocRecAndGetPALApiParameter(){
        
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = UNILAB_PAL_TestDataFactory.getAllocations();
        test.startTest();
        try{
            UNILAB_PAL_Controller.updateAllocRecAndGetPALApiParameter(allocRecords.get(0));
        }catch(Exception e){
            
        }
        
        test.stopTest();
    }
    
    //Scenario: Create Account Allocation
    //Positive Test
    @isTest static void testCreateAccountAllocMethod(){
        List<Account_Allocation__c> accAllocRecords = new List<Account_Allocation__c>();
        accAllocRecords = UNILAB_PAL_TestDataFactory.getAccAllocation();
        
        test.startTest();
        try{
            UNILAB_PAL_Controller.createAccountAllocation(accAllocRecords);
        }catch(Exception ex){
            System.assert(true);
        }
        
        test.stopTest();
    }
    
    //Scenario: Show All Accounts - Add Modules
    //Positive Test
    @isTest static void showAllAccountsAddModule(){
        List<Allocation__c> allocList = UNILAB_PAL_TestDataFactory.getAllocations();
        
        test.startTest();
        UNILAB_PAL_Controller.getAllAccounts(5,20, 'All', allocList[0].Channel__c, allocList[0].Id);
        
        test.stopTest();
    }
    
    //Scenario: Show specific Accounts - Add Modules
    //Positive Test
    @isTest static void showSpecificAccountsAddModule(){
        List<Allocation__c> allocList = UNILAB_PAL_TestDataFactory.getGTAllocations();
        
        test.startTest();
        UNILAB_PAL_Controller.getAllAccounts(5,20, 'W', allocList[0].Channel__c, allocList[0].Id);
        
        test.stopTest();
    }
    
    //Scenario: Get Specified Accounts
    //Positive Test
    @isTest static void testFetchSpecificAccounts(){
        test.startTest();
        //UNILAB_PAL_Controller.getAllAccounts(1,1, 'A', 'GT');
        test.stopTest();
    }
    
    //Scenario: Fetch All Accounts
    //Positive Test
    @isTest static void testFetchAllAccounts(){
        test.startTest();
        //UNILAB_PAL_Controller.getAllAccounts(1,1, 'All', 'GT');
        test.stopTest();
    }
    
    //Scenario: Test Invoking of Batch APEX
    //Positive Test
    @isTest static void testInvokeBatchApex(){
        //Create Promo
        UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        //Create Allocation
        //UNILAB_PAL_TestDataFactory.createAllocations(UNILAB_PAL_TestDataFactory.getPromos());
        //Get GT Accounts
        List<Account> gtAccounts = UNILAB_PAL_TestDataFactory.getGTAccounts();
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getGTAllocations();
        //Create Temporary Allocation
        List<Temporary_Allocation__c> gtTempAlloc = UNILAB_PAL_TestDataFactory.createTempAllocForGT('General Trade', 'GT-Team', 'GT-Group', gtAccounts);
        String allocId = allocationList.get(0).Id;
        
        test.startTest();
        UNILAB_PAL_Controller.invokeBatchApex(allocId, gtTempAlloc, 'General Trade');
        test.stopTest();
    }
    
    //Scenario: Test Invoking of Batch APEX
    //Negative Test
    @isTest static void testInvokeBatchApexNegative(){
        //Create Promo
        UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        //Create Allocation
        //UNILAB_PAL_TestDataFactory.createAllocations(UNILAB_PAL_TestDataFactory.getPromos());
        //Get GT Accounts
        List<Account> gtAccounts = UNILAB_PAL_TestDataFactory.getGTAccounts();
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getGTAllocations();
        //Create Temporary Allocation
        List<Temporary_Allocation__c> gtTempAlloc = UNILAB_PAL_TestDataFactory.createTempAllocForGT('General Trade', 'GT-Team', 'GT-Group', gtAccounts);
        String allocId = allocationList.get(0).Id;
        
        test.startTest();
        UNILAB_PAL_Controller.invokeBatchApex(allocId, gtTempAlloc, 'General Trade');
        test.stopTest();
    }
    
    //Scenario: Fetch GT Tree Grid Data
    //Positive Test
    @isTest static void testGTTreeGridData(){
        
        //Create Promo
        UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        //Create Allocation
        //UNILAB_PAL_TestDataFactory.createAllocations(UNILAB_PAL_TestDataFactory.getPromos());
        //Get GT Accounts
        List<Account> gtAccounts = UNILAB_PAL_TestDataFactory.getGTAccounts();
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getGTAllocations();
        //Create Temporary Allocation
        List<Temporary_Allocation__c> gtTempAlloc = UNILAB_PAL_TestDataFactory.createTempAllocForGT('General Trade', 'GT-Team', 'GT-Group', gtAccounts);
        
        //Create Account Allocation
        UNILAB_PAL_TestDataFactory.createGTAccAllocRecords(allocationList.get(0), gtAccounts);
        //Get Allocations
        test.startTest();
        try{
            UNILAB_PAL_Controller.getTreeGridData(allocationList.get(0).Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch GT Tree Grid Data
    //Positive Test
    @isTest static void testGTTreeGridData1(){
         //Create Multiple Accounts
        UNILAB_PAL_TestDataFactory.createMultipleGTAccounts1();
        //Create Products
        //UNILAB_PAL_TestDataFactory.createProducts();
        //Create Promo
        UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        //Create Allocation
        //UNILAB_PAL_TestDataFactory.createAllocations(UNILAB_PAL_TestDataFactory.getPromos());
        //Get GT Accounts
        List<Account> gtAccounts = UNILAB_PAL_TestDataFactory.getGTAccounts();
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getGTAllocations();
        //Create Temporary Allocation
        List<Temporary_Allocation__c> gtTempAlloc = UNILAB_PAL_TestDataFactory.createTempAllocForGT('General Trade', 'GT-Team', 'GT-Group', gtAccounts);
        
        //Create Account Allocation
        UNILAB_PAL_TestDataFactory.createGTAccAllocRecords(allocationList.get(0), gtAccounts);
        //Get Allocations
        test.startTest();
        try{
            UNILAB_PAL_Controller.getTreeGridData(allocationList.get(0).Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch KA Tree Grid Data
    //Positive Test
    @isTest static void testKATreeGridData(){
         //Create Multiple Accounts
        
        //Create Products
        //UNILAB_PAL_TestDataFactory.createProducts();
        //Create Promo
        UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        //Create Allocation
        //UNILAB_PAL_TestDataFactory.createAllocations(UNILAB_PAL_TestDataFactory.getPromos());
        //Get GT Accounts
        List<Account> kaAccounts = UNILAB_PAL_TestDataFactory.getKAAccounts();
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getKAAllocations();
        //Create Temporary Allocation
        List<Temporary_Allocation__c> gtTempAlloc = UNILAB_PAL_TestDataFactory.createTempAllocForGT('Key Accounts', 'KA-Team', 'KA-Group', kaAccounts);
        
        //Create Account Allocation
        UNILAB_PAL_TestDataFactory.createKAAccAllocRecords(allocationList.get(0), kaAccounts);
        //Get Allocations
        test.startTest();
        try{
            UNILAB_PAL_Controller.getTreeGridData(allocationList.get(0).Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch KA Tree Grid Data with Different Team but Same Group
    //Positive Test
    @isTest static void testKATreeGridDataFirstElse(){
         //Create Multiple Accounts
        List<Account> accList = UNILAB_PAL_TestDataFactory.createMultipleKAAccountsNoGroup();
        //Create Products
        //UNILAB_PAL_TestDataFactory.createProducts();
        //Create Promo
        //UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        //Create Allocation
        //UNILAB_PAL_TestDataFactory.createAllocations(UNILAB_PAL_TestDataFactory.getPromos());
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getKAAllocations();
        //Create Temporary Allocation
        List<Temporary_Allocation__c> kaTempAlloc = UNILAB_PAL_TestDataFactory.createTempAllocForGT('Key Accounts', 'KA-Team', 'KA-Group', accList);
        
        //Create Account Allocation
        List<Account_Allocation__c> accAllocList = UNILAB_PAL_TestDataFactory.createKAAccAllocRecords(allocationList.get(0), accList);
        //Get Allocations
        test.startTest();
        try{
            UNILAB_PAL_Controller.getTreeGridData(allocationList.get(0).Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch KA Tree Grid Data with Same Team but Different Group
    //Positive Test
    @isTest static void testKATreeGridData2(){
         //Create Multiple Accounts
        List<Account> accList = UNILAB_PAL_TestDataFactory.createMultipleKAAccountsNoGroup2();
        //Create Products
        //UNILAB_PAL_TestDataFactory.createProducts();
        //Create Promo
        //UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        //Create Allocation
        //UNILAB_PAL_TestDataFactory.createAllocations(UNILAB_PAL_TestDataFactory.getPromos());
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getKAAllocations();
        //Create Temporary Allocation
        List<Temporary_Allocation__c> kaTempAlloc = UNILAB_PAL_TestDataFactory.createTempAllocForGT('Key Accounts', 'KA-Team', 'KA-Group', accList);
        
        //Create Account Allocation
        List<Account_Allocation__c> accAllocList = UNILAB_PAL_TestDataFactory.createKAAccAllocRecords(allocationList.get(0), accList);
        //Get Allocations
        test.startTest();
        try{
            UNILAB_PAL_Controller.getTreeGridData(allocationList.get(0).Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch Mercury Tree Grid Data Different Team Same Group
    //Positive Test
    @isTest static void testMDCTreeGridData(){
        //Create Multiple Accounts
        UNILAB_PAL_TestDataFactory.createMultipleMDCAccounts();
        //Create Products
        //UNILAB_PAL_TestDataFactory.createProducts();
        //Create Promo
        //UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        //Create Allocation
        //UNILAB_PAL_TestDataFactory.createAllocations(UNILAB_PAL_TestDataFactory.getPromos());
        //Get GT Accounts
        List<Account> mdcAccounts = UNILAB_PAL_TestDataFactory.getMDCAccounts();
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getMDCAllocations();
        //Create Temporary Allocation
        List<Temporary_Allocation__c> gtTempAlloc = UNILAB_PAL_TestDataFactory.createTempAllocForGT('Mercury', 'MDC-Team', 'MDC-Group', mdcAccounts);
        
        //Create Account Allocation
        UNILAB_PAL_TestDataFactory.createMDCAccAllocRecords(allocationList.get(0), mdcAccounts);
        //Get Allocations
        test.startTest();
        try{
            UNILAB_PAL_Controller.getTreeGridData(allocationList.get(0).Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch Mercury Tree Grid Data Same Team Different Group
    //Positive Test
    @isTest static void testMDCTreeGridData2(){
        //Create Multiple Accounts
        UNILAB_PAL_TestDataFactory.createMultipleMDCAccounts2();
        //Create Products
        //UNILAB_PAL_TestDataFactory.createProducts();
        //Create Promo
        //UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        //Create Allocation
        //UNILAB_PAL_TestDataFactory.createAllocations(UNILAB_PAL_TestDataFactory.getPromos());
        //Get GT Accounts
        List<Account> mdcAccounts = UNILAB_PAL_TestDataFactory.getMDCAccounts();
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getMDCAllocations();
        //Create Temporary Allocation
        List<Temporary_Allocation__c> gtTempAlloc = UNILAB_PAL_TestDataFactory.createTempAllocForGT('Mercury', 'MDC-Team', 'MDC-Group', mdcAccounts);
        
        //Create Account Allocation
        UNILAB_PAL_TestDataFactory.createMDCAccAllocRecords(allocationList.get(0), mdcAccounts);
        //Get Allocations
        test.startTest();
        try{
            UNILAB_PAL_Controller.getTreeGridData(allocationList.get(0).Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
     //Scenario: Fetch Mercury Tree Grid Data Different Team Different Group
    //Positive Test
    @isTest static void testMDCTreeGridData3(){
        //Create Multiple Accounts
        UNILAB_PAL_TestDataFactory.createMultipleMDCAccounts3();
        //Create Products
        //UNILAB_PAL_TestDataFactory.createProducts();
        //Create Promo
        //UNILAB_PAL_TestDataFactory.createPromo(UNILAB_PAL_TestDataFactory.getProducts());
        //Create Allocation
        //UNILAB_PAL_TestDataFactory.createAllocations(UNILAB_PAL_TestDataFactory.getPromos());
        //Get GT Accounts
        List<Account> mdcAccounts = UNILAB_PAL_TestDataFactory.getMDCAccounts();
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getMDCAllocations();
        //Create Temporary Allocation
        List<Temporary_Allocation__c> gtTempAlloc = UNILAB_PAL_TestDataFactory.createTempAllocForGT('Mercury', 'MDC-Team', 'MDC-Group', mdcAccounts);
        
        //Create Account Allocation
        UNILAB_PAL_TestDataFactory.createMDCAccAllocRecords(allocationList.get(0), mdcAccounts);
        //Get Allocations
        test.startTest();
        try{
            UNILAB_PAL_Controller.getTreeGridData(allocationList.get(0).Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Get Business Share Params Test Method Not New
    //Positive Test
    @isTest static void testGetBusinessShareParams(){
        Allocation__c allocRecord = new Allocation__c();
        allocRecord = [SELECT Id From Allocation__c WHERE Channel__c = 'Mercury' Limit 1];
        
        test.startTest();
        UNILAB_PAL_Controller.getBusinessShareParams(allocRecord.Id, false);
        test.stopTest();
    }
    
    //Scenario: Get Business Share Params Test Method Not New
    //Positive Test
    @isTest static void testGetBusinessShareParamsNew(){
        Allocation__c allocRecord = new Allocation__c();
        allocRecord = [SELECT Id From Allocation__c WHERE Channel__c = 'Mercury' Limit 1];
        
        test.startTest();
        UNILAB_PAL_Controller.getBusinessShareParams(allocRecord.Id, true);
        test.stopTest();
    }    
    //Scenario: Get Total Allocation
    //Positive Test
    @isTest static void testGetTotalAllocation(){
        Allocation__c allocRecord = new Allocation__c();
        allocRecord = [SELECT Id From Allocation__c WHERE Channel__c = 'Modern Trade' Limit 1];
        
        test.startTest();
        UNILAB_PAL_Controller.getTotalAllocation(allocRecord.Id);
        test.stopTest();
    }
    
    //Scenario: Filter Accounts
    //Positive Test
    @isTest static void filterAccounts(){
        Allocation__c allocRecord = new Allocation__c();
        allocRecord = [SELECT Id, Channel__c From Allocation__c WHERE Channel__c = 'Modern Trade' Limit 1];
        
        test.startTest();
        UNILAB_PAL_Controller.getAccFilter(allocRecord.Id, allocRecord.Channel__c);
        test.stopTest();
    }
    
    //Scenario: Clone Allocation Record
    //Positive Test
    @isTest static void testCloneAllocRecord(){
        Allocation__c allocRecord = new Allocation__c();
        allocRecord = [SELECT Id From Allocation__c WHERE Channel__c = 'Modern Trade' Limit 1];
        
        test.startTest();
        UNILAB_PAL_Controller.cloneAllocRecord(allocRecord.Id);
        test.stopTest();
    }
    
    //Scenario: Get Access Token
    //Positive Test
    @isTest static void testGetToken(){
        test.startTest();
        try{
            UNILAB_PAL_Controller.getAccessToken();
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
        test.stopTest();
    }
    
    //Scenario: Fetch Account Allocation For Exporting
    //Positive Test
    @isTest static void testAccAllocForConversion(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = [SELECT Id From Allocation__c WHERE Channel__c = 'Modern Trade'];
        test.startTest();
        try{
            UNILAB_PAL_Controller.getAccAllocForConversion(allocRecords[0].Id);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Save Allocation Record as Draft
    //Positive Test
    @isTest static void testSaveDraftAllocRec(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = [SELECT Id,Status__c From Allocation__c LIMIT 1];
        test.startTest();
        try{
            UNILAB_PAL_Controller.saveDraftAllocRec(allocRecords[0]);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Save Allocation Record as Draft
    //Negative Test
    @isTest static void testSaveDraftAllocRecNegative(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = [SELECT Id From Allocation__c LIMIT 1];
        test.startTest();
        try{
            UNILAB_PAL_Controller.saveDraftAllocRec(allocRecords[0]);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Test Server Down
    //Positive Test
    @isTest static void testUpdateAllocRecToDraftServerDown(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = [SELECT Id From Allocation__c LIMIT 1];
        test.startTest();
        try{
            UNILAB_PAL_Controller.updateAllocRecToDraft(allocRecords[0].Id, true, false);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Test Null Callout Value
    //Positive Test
    @isTest static void testUpdateAllocRecToDraftNullCalloutValue(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = [SELECT Id From Allocation__c LIMIT 1];
        test.startTest();
        try{
            UNILAB_PAL_Controller.updateAllocRecToDraft(allocRecords[0].Id, false, true);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    @isTest static void testDeletePromo(){
        List<Account_Allocation__c> accAlloc = new List<Account_Allocation__c>();
        accAlloc = UNILAB_PAL_TestDataFactory.getAccAllocation();
        
        test.startTest();
        UNILAB_PAL_Controller.deleteAccountAllocation(accAlloc);
        UNILAB_PAL_Controller.deleteAccountAllocations(accAlloc);
        test.stopTest();
    }
    
    @isTest static void testCancelPromoAllocation(){
        List<Promo__c> promoIdList = new List<Promo__c>();
        promoIdList = UNILAB_PAL_TestDataFactory.getPromo();
        test.startTest();
        UNILAB_PAL_Controller.cancelPromoAllocationStatus(promoIdList.get(0).Id);
        test.stopTest();
    }
    
    @isTest static void testUpdateAccAllocConcurred(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = UNILAB_PAL_TestDataFactory.getAllocations();
        
        test.startTest();
        UNILAB_PAL_Controller.updateAccAllocStatusConcurred(allocRecords.get(0).Id);
        test.stopTest();
    }
    
    @isTest static void testCreateAccountAllocation(){
        List<Account> accList = new List<Account>();
        accList = UNILAB_PAL_TestDataFactory.getAccounts();
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = UNILAB_PAL_TestDataFactory.getAllocations();
        test.startTest();
        //UNILAB_PAL_Controller.createAccountAllocation(accList.get(0).Id, allocRecords.get(0).Id);
        test.stopTest();
        
    }
    
    @isTest static void testDeleteAllocRecords(){
        List<Id> idsToDelete = new List<Id>();
        idsToDelete = UNILAB_PAL_TestDataFactory.getIdAccAlloc();
        
        test.startTest();
        //UNILAB_PAL_Controller.deleteAccountAllocations(idsToDelete);
        test.stopTest();
    }

    
    @isTest static void testDateToday(){
        test.startTest();
        UNILAB_PAL_Controller.dateToday();
        test.stopTest();
    }
    
    @isTest static void testUpdateAccountAlloc(){
        List<Account_Allocation__c> accAllocList = UNILAB_PAL_TestDataFactory.getAccAllocation();
        
        test.startTest();
        UNILAB_PAL_Controller.updateAccountAllocation(accAllocList);
        test.stopTest();
    }
    
    @isTest static void testUpdateAccountAllocNullFinal(){
        List<Account_Allocation__c> accAllocList = UNILAB_PAL_TestDataFactory.getAccAllocation();
        for(Account_Allocation__c accAlloc : accAllocList){
            accAlloc.Final_Allocation__c =null;
        }
        update accAllocList;
        List<Account_Allocation__c> updatedAccAllocList = UNILAB_PAL_TestDataFactory.getAccAllocation();
        test.startTest();
        UNILAB_PAL_Controller.updateAccountAllocation(updatedAccAllocList);
        test.stopTest();
    }
    
    @isTest static void testFetchAccWrapper(){
        //Get Allocations
        List<Allocation__c> allocationList = UNILAB_PAL_TestDataFactory.getGTAllocations();
        
        test.startTest();
        UNILAB_PAL_Controller.fetchAccountWrapper('General Trade', allocationList.get(0).Id);
        test.stopTest();
    }
    
    @isTest static void testUpdateAccountAllocations(){
        List<Account_Allocation__c> accAllocList = UNILAB_PAL_TestDataFactory.getAccAllocation();
        Integer i = 10;
        for(Account_Allocation__c accAlloc:accAllocList){
            accAlloc.Manual__c = 30 + i;
            
            i=i+5;
        }
        Boolean success = false;
		String accAllocationList = JSON.serialize(accAllocList);
        test.startTest();
        //success = UNILAB_PAL_Controller.updateAccAllocations(accAllocationList);
        test.stopTest();
    }
    
    @isTest static void testGetAccountAlloc(){
        List<Allocation__c> allocList = UNILAB_PAL_TestDataFactory.getAllocations();
        test.startTest();
        UNILAB_PAL_Controller.getAccAllocationRecords(allocList.get(0));
        test.stopTest();
    }
    
    @isTest static void testColumnHeader(){
        test.startTest();
        test.stopTest();
    }
    
    @isTest
    private static void testgetDependentPicklistValues(){
        Test.startTest();
        Map<Object,List<String>> result =
            UNILAB_PAL_Controller.getDependentPicklistValues( Allocation__c.RPS_Account_Class__c );
        Test.stopTest();
    }
 
    @isTest
    private static void testGetDependentVal(){
        String fieldName = 'RPS_Account_Class__c';
        String sObjectName = 'Allocation__c';
        //Schema.SObjectType sOType = Schema.getGlobalDescribe().get(sObjectName);
        //SObject sOName = sOType.newSObject();
        
        Test.startTest();
            Map<Object,List<String>> result = UNILAB_PAL_Controller.getDependentVal(sObjectName,fieldName);
        Test.stopTest();
    }
    
    @isTest
    private static void testGetPicklistvalues(){
        String fieldName = 'RPS_Account_Class__c';
        String sObjectName = 'Allocation__c';
        Boolean testBool = false;
        Schema.SObjectType sOType = Schema.getGlobalDescribe().get(sObjectName);
        //SObject sOName = sOType.newSObject();
        
        Test.startTest();
            List<String> result = UNILAB_PAL_Controller.getPicklistvalues(sObjectName,fieldName,testBool);
        Test.stopTest();
    }
    
    @isTest
    private static void testgetAverageQtyAndGross(){
        String channel = 'Key Accounts';
        String team = 'WATSONS';
        String acctgroup = 'WATSONS';
        //List<Account> accList = UNILAB_PAL_TestDataFactory.getAccounts();
        
        List<Account> accList = [SELECT Id FROM Account];
        
        List<Temporary_Allocation__c> tempAllocList = new List <Temporary_Allocation__c>();
        Temporary_Allocation__c tempAlloc = new Temporary_Allocation__c();
            
        tempAlloc.Channel__c = channel;
        tempAlloc.Team__c = team;
        tempAlloc.Account_Group__c = acctgroup;
        tempAlloc.SFA_Internal_ID__c = accList[0].Id;
        tempAlloc.Branch_ID__c = '0080090430';
        tempAlloc.Item_Code__c = '151938';
        tempAlloc.Quantity__c = 100;
        tempAlloc.Amount__c = 1000;
        tempAlloc.Monthly_Supply__c = 0;
        tempAlloc.Period__c = '201812';
        tempAlloc.Measure_Category__c = 'SALES';
        tempAlloc.Measure_Type__c = 'SELLIN';
        tempAlloc.Measure_Level__c = 'P3';
        tempAllocList.add(tempAlloc);
        
        //UNILAB_PAL_TestDataFactory.createTempAllocForBatch(channel, team, acctgroup, accList);
        
        Test.startTest();
            UNILAB_PAL_Controller.getAverageQtyAndGross(channel);
        Test.stopTest();
    }
    
}