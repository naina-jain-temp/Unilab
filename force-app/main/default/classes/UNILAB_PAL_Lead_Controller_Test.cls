@isTest
public class UNILAB_PAL_Lead_Controller_Test {

    @testSetup static void setup(){
        
         //Create Users
        UNILAB_PAL_TestDataFactory.createSystemAdminUser();
        UNILAB_PAL_TestDataFactory.createGTUser();
        UNILAB_PAL_TestDataFactory.createKAUser();
        UNILAB_PAL_TestDataFactory.createMTUser();
        UNILAB_PAL_TestDataFactory.createMDCUser();    
        
        //Create Account
        Account accRecord = UNILAB_PAL_TestDataFactory.createAccount();
               
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
		//List<Allocation__c> allocList = new List<Allocation__c>();
        //allocList = UNILAB_PAL_TestDataFactory.getAllocations();
        //UNILAB_PAL_TestDataFactory.createAccAllocRecords(allocList, accRecord);
    }
    
    //Scenario: Testing of Get Allocation Record Method
    //Positive Test
     @isTest
     static void testGetAllocationRecords(){
 
        //UNILAB_PAL_TestDataFactory.createSingleAllocationForProcess();
         List<Promo__c> promoIdList = new List<Promo__c>();
        promoIdList = UNILAB_PAL_TestDataFactory.getPromo();
         
        List<Allocation__c> allocList;
        
        Test.startTest();
        allocList = UNILAB_PAL_Lead_Controller.getAllocationRecords (promoIdList[0].Id);
        Test.stopTest();
        
        System.debug(allocList);
        
        System.assert(allocList.size() != 0);
        
        
    }
    
    //Scenario: Testing of Get Allocation Record Method
    //Negative Test
     @isTest
     static void testGetAllocationRecordsNegative(){
        List<Allocation__c> allocList;
        
        Test.startTest();
        allocList = UNILAB_PAL_Lead_Controller.getAllocationRecords (null);
        Test.stopTest();
        
        System.debug(allocList);
        
        System.assert(allocList.size() == 0);
        
        
    }
    
    //Scenario: Check if Allocation is empty method
    //Positive Test
    @isTest
    public static void testCheckAllocationNotEmpty(){
        List<Promo__c> promoIdList = UNILAB_PAL_TestDataFactory.getPromo();
        
        test.startTest();
        Boolean notEmpty = UNILAB_PAL_Lead_Controller.allocationIsEmpty(promoIdList.get(0).Id);
        test.stopTest();
        
        System.assertEquals(notEmpty, true);
    }
    
    //Scenario: Check if Allocation is empty method
    //Negative Test
    @isTest
    public static void testCheckAllocationEmpty(){
        Id recordId = null;
        
        test.startTest();
        Boolean notEmpty = UNILAB_PAL_Lead_Controller.allocationIsEmpty(recordId);
        test.stopTest();
        
        System.assertEquals(notEmpty, false);
    }
    
    @isTest
    static void testGetAllocationRecordException(){
     
        Promo__c promoId = new Promo__c();
        //promoId = UNILAB_PAL_TestDataFactory.createPromo();
        promoId.Id = null;
         
       List<Allocation__c> allocList;

       test.startTest();
               
       try{
           allocList = UNILAB_PAL_Lead_Controller.getAllocationRecords(promoId.Id);
       }catch(Exception e){
           
           System.debug('Inside catch');
       }
       
       test.stopTest();
               System.debug(allocList);
   
        
    }
          
    //Scenario: Test Fetching of Columns
    //Positive test
    @isTest
    static void testGetColumnsP3(){
        
		UNILAB_PAL_TestDataFactory.createUser();

		UNILAB_PAL_TestDataFactory.createColumns();
        
        //Create Generate Admin Columns
        UNILAB_PAL_TestDataFactory.createGenerateAdminColumns();
        
        
        PAL_Generate_Columns__c userId =[Select SetupOwnerId from PAL_Generate_Columns__c LIMIT 1];
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromos();
        List<Allocation__c> allocList = UNILAB_PAL_TestDataFactory.getAllocations();
        
        System.debug(userId);
        
        UNILAB_PAL_TestDataFactory.createColumnHeader();

        List<UNILAB_PAL_Lead_Controller.ColumnHeader> colHeaderList = new List<UNILAB_PAL_Lead_Controller.ColumnHeader>();
        
        Test.startTest();

        colHeaderList = UNILAB_PAL_Lead_Controller.getColumns(promoRec.Id);
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
    
     
    //Scenario: Fetch All Tree Grid Data
    //Positive Test
    @isTest static void testGetTreeGridData(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = UNILAB_PAL_TestDataFactory.getAllocations();
        test.startTest();
        try{
            UNILAB_PAL_Lead_Controller.getTreeGridData(allocRecords);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch GT Tree Grid Data
    //Positive Test
    @isTest static void testGTTreeGridData(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = [SELECT Id From Allocation__c WHERE Channel__c = 'General Trade'];
        test.startTest();
        try{
            UNILAB_PAL_Lead_Controller.getTreeGridData(allocRecords);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch KA Tree Grid Data
    //Positive Test
    @isTest static void testKATreeGridData(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = [SELECT Id From Allocation__c WHERE Channel__c = 'Key Accounts'];
        System.debug(allocRecords);
        test.startTest();
        try{
            UNILAB_PAL_Lead_Controller.getTreeGridData(allocRecords);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch Mercury Tree Grid Data
    //Positive Test
    @isTest static void testMDCTreeGridData(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = [SELECT Id From Allocation__c WHERE Channel__c = 'Mercury'];
        test.startTest();
        try{
            UNILAB_PAL_Lead_Controller.getTreeGridData(allocRecords);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    //Scenario: Fetch Modern Trade Tree Grid Data
    //Positive Test
    @isTest static void testMTTreeGridData(){
        List<Allocation__c> allocRecords = new List<Allocation__c>();
        allocRecords = [SELECT Id From Allocation__c WHERE Channel__c = 'Modern Trade'];
        test.startTest();
        try{
            UNILAB_PAL_Lead_Controller.getTreeGridData(allocRecords);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        test.stopTest();
    }
    
    
    @isTest
    static void testMercuryChannelDataMapping(){
            
        Promo__c promoIdList = [Select Id from Promo__c];
        
        //UNILAB_PAL_TestDataFactory.createAllocations(promoIdList);      
        
        List<Allocation__c> allocList = [Select Id, Channel__c from Allocation__c where Channel__c='Mercury' and Promo__c =: promoIdList.Id LIMIT 1]; 
        System.debug(allocList);

        
        UNILAB_PAL_TestDataFactory.createMDCAccountRecords();
        
       
        List<Account> accountRecords = [Select Id, Channel__c, Team__c, Account_Group__c from Account where channel__c='Mercury'];
        System.debug(accountRecords);
                
        UNILAB_PAL_TestDataFactory.createAccountAllocation(allocList, accountRecords);
        
        List<Account_Allocation__c> accAllocRecords = new List<Account_Allocation__c>();
        
        accAllocRecords = [Select Id, Account__c, Account__r.Channel__c, Account__r.Team__c,
							Account__r.Account_Group__c, Account__r.Name, YTDSales_LY__c, YTDSales_TY__c,
							Ave_Qty__c, Ave_Gross_Sales__c, Final_Allocation__c, Computed_Allocation__c, Status__c,
                            Manual__c, Allocation__c
 						  from Account_Allocation__c where Account__r.Channel__c='Mercury' and Allocation__c =: allocList[0].Id];
        
        for (Account_Allocation__c newAccAlloc : accAllocRecords) {
            System.debug(newAccAlloc.Account__r.Channel__c + '-' + newAccAlloc.Account__c );
        }
        
        test.startTest();
        
            UNILAB_PAL_Lead_Controller.mercuryChannelDataMapping(accAllocRecords);
       
        test.stopTest();
        
    
    
    	System.debug(accAllocRecords);
        
    }
    
    
     @isTest
    static void testKAChannelDataMapping(){
             
        Promo__c promoIdList = [Select Id from Promo__c];
        
        //UNILAB_PAL_TestDataFactory.createAllocations(promoIdList);      
        
        List<Allocation__c> allocList = [Select Id, Channel__c from Allocation__c where Channel__c='Key Accounts' and Promo__c =: promoIdList.Id LIMIT 1]; 
        System.debug(allocList);

        
        UNILAB_PAL_TestDataFactory.createKAAccountRecords();
        
        List<Account> accRecords = [Select Id, Channel__c, Team__c, Account_Group__c from Account where channel__c='Key Accounts'];
        System.debug(accRecords);
        
        UNILAB_PAL_TestDataFactory.createAccountAllocation(allocList, accRecords);
        
        List<Account_Allocation__c> accAllocRecords = new List<Account_Allocation__c>();
        
        accAllocRecords = [Select Id, Account__c, Account__r.Channel__c, Account__r.Team__c,
							Account__r.Account_Group__c, Account__r.Name, YTDSales_LY__c, YTDSales_TY__c,
							Ave_Qty__c, Ave_Gross_Sales__c, Final_Allocation__c, Computed_Allocation__c, Status__c,
                            Manual__c, Allocation__c
 						  from Account_Allocation__c where Account__r.Channel__c='Key Accounts' and Allocation__c =: allocList[0].Id];
        
        for (Account_Allocation__c newAccAlloc : accAllocRecords) {
            System.debug(newAccAlloc.Account__r.Channel__c);
        }
        
        test.startTest();
        
            UNILAB_PAL_Lead_Controller.mercuryChannelDataMapping(accAllocRecords);
       
        test.stopTest();
            
    	System.debug(accAllocRecords);
        
    }
    

    
    @isTest
    static void testGTChannelDataMapping(){
             
        Promo__c promoIdList = [Select Id from Promo__c];
        
        //UNILAB_PAL_TestDataFactory.createAllocations(promoIdList);      
        
        List<Allocation__c> allocList = [Select Id, Channel__c from Allocation__c where Channel__c='General Trade' and Promo__c =: promoIdList.Id LIMIT 1]; 
        System.debug(allocList);

        
        UNILAB_PAL_TestDataFactory.createGTAccountRecords();
        
        List<Account> accRecords = [Select Id, Channel__c, Team__c, Account_Group__c from Account where channel__c='General Trade'];
        System.debug(accRecords);
        
        UNILAB_PAL_TestDataFactory.createAccountAllocation(allocList, accRecords);
        
        List<Account_Allocation__c> accAllocRecords = new List<Account_Allocation__c>();
        
        accAllocRecords = [Select Id, Account__c, Account__r.Channel__c, Account__r.Team__c,
							Account__r.Account_Group__c, Account__r.Name, YTDSales_LY__c, YTDSales_TY__c,
							Ave_Qty__c, Ave_Gross_Sales__c, Final_Allocation__c, Computed_Allocation__c, Status__c,
                            Manual__c, Allocation__c
 						  from Account_Allocation__c where Account__r.Channel__c='General Trade' and Allocation__c =: allocList[0].Id];
        
        for (Account_Allocation__c newAccAlloc : accAllocRecords) {
            System.debug(newAccAlloc.Account__r.Channel__c);
        }
        
        test.startTest();
        
            UNILAB_PAL_Lead_Controller.mercuryChannelDataMapping(accAllocRecords);
       
        test.stopTest();
            
    	System.debug(accAllocRecords);
        
    }
    
    
    @isTest
    static void testMTChannelDataMapping(){
             
         Promo__c promoIdList = [Select Id from Promo__c];
        
        //UNILAB_PAL_TestDataFactory.createAllocations(promoIdList);      
        
        List<Allocation__c> allocList = [Select Id, Channel__c from Allocation__c where Channel__c='Modern Trade' and Promo__c =: promoIdList.Id LIMIT 1]; 
        System.debug(allocList);

        
        UNILAB_PAL_TestDataFactory.createMTAccountRecords();
        
        List<Account> accRecords = [Select Id, Channel__c, Team__c, Account_Group__c from Account where channel__c='Modern Trade'];
        System.debug(accRecords);
        
        UNILAB_PAL_TestDataFactory.createAccountAllocation(allocList, accRecords);
        
        List<Account_Allocation__c> accAllocRecords = new List<Account_Allocation__c>();
        
        accAllocRecords = [Select Id, Account__c, Account__r.Channel__c, Account__r.Team__c,
							Account__r.Account_Group__c, Account__r.Name, YTDSales_LY__c, YTDSales_TY__c,
							Ave_Qty__c, Ave_Gross_Sales__c, Final_Allocation__c, Computed_Allocation__c, Status__c,
                            Manual__c
 						  from Account_Allocation__c where Account__r.Channel__c='Modern Trade' and Allocation__c =: allocList[0].Id];
        
        for (Account_Allocation__c newAccAlloc : accAllocRecords) {
            System.debug(newAccAlloc.Account__r.Channel__c);
        }
        
        test.startTest();
        
            UNILAB_PAL_Lead_Controller.mercuryChannelDataMapping(accAllocRecords);
       
        test.stopTest();
            
    	System.debug(accAllocRecords);
        
    }
    
    
  

	    
}