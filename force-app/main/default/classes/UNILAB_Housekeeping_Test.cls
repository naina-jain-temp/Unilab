@isTest
public class UNILAB_Housekeeping_Test {

	
    @isTest static void loadChecklist () {
        
        Warehouse_Checklist__c getField = new Warehouse_Checklist__c(); 
        getField.Type__c = 'House Keeping';
        getField.Category__c = 'A - Receiving Area';
        getField.Title__c = 'Ceiling';
        getField.inactive__c = false;
       	insert getField;
        
        Test.startTest();
        	List<Warehouse_Checklist__c> getLoadChecklist =  UNILAB_Housekeeping.loadChecklist('House Keeping', 'A - Receiving Area');
        Test.stopTest();
        system.assert(getLoadChecklist.size() > 0);       
    }
	    
    
     @isTest static void warehouseAssessment () {
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
         insert account;
         
          
            WarehouseAssessment__c warehouseAssessment = new WarehouseAssessment__c();
	              
         
            warehouseAssessment.Account__c = account.Id;
            warehouseAssessment.Title__c = '1 - Ceiling-free of cobwebs, dust/dirt,leak/holes';
            warehouseAssessment.Category__c = 'A - Receiving Area';
            warehouseAssessment.Yes__c = True;
            warehouseAssessment.No__c = False;
            warehouseAssessment.NA__c = False;
            warehouseAssessment.Remarks__c ='TEST Remarks';
            warehouseAssessment.type__c = 'House Keeping';
            warehouseAssessment.Year__c = '2022';
            warehouseAssessment.Period__c = 'May';
            insert warehouseAssessment;
        
          Map<String, String> checklist = new Map<String, String >();

          checklist.put('title', '1 - Ceiling-free of cobwebs, dust/dirt,leak/holes');
          checklist.put('category', 'A - Receiving Area');
          checklist.put('Yes', 'True');
          checklist.put('No', 'False');
          checklist.put('Na', 'False');
          checklist.put('remarks', 'TEST Remarks');
          checklist.put('type', 'House Keeping');
              
         Test.startTest();
            String saveWarehouseAssessment = UNILAB_Housekeeping.saveWarehouseAssessment(checklist, account.Id, '2022', 'May');
            //Test.setMock(HttpCalloutMock.class, new UNILAB_Housekeeping_Mock(false));
            //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        	
          Test.stopTest();

         system.assert(saveWarehouseAssessment != null); 
                   
      }
    
    @isTest static void testCalloutSuccess(){
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
         insert account;
        
        Test.startTest();
           Test.setMock(HttpCalloutMock.class, new UNILAB_Housekeeping_Mock(true));
           UNILAB_Housekeeping.runApi(account.Id,'2022','July');
        Test.stopTest();
    }
    
    @isTest static void testCalloutFailed(){
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
         insert account;
        
        Test.startTest();
           Test.setMock(HttpCalloutMock.class, new UNILAB_Housekeeping_Mock(false));
           UNILAB_Housekeeping.runApi(account.Id,'2022','July');
        Test.stopTest();
    }
    
    @isTest static void loadAssessment () {
        
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
        insert account;
        
        WarehouseAssessment__c assessment = new WarehouseAssessment__c();
        assessment.Account__c = account.Id;
        assessment.Category__c = 'Backroom Personnel';
        assessment.Title__c = 'Test Data';
        assessment.Yes__c = true;
        assessment.No__c = false;
        assessment.NA__c = false;
        assessment.Remarks__c = 'Test Remarks';
        assessment.Year__c = '2022';
        assessment.Period__c = 'June';
        assessment.Type__c = 'House Keeping';
        insert assessment;
        
        Test.startTest();
        	List<WarehouseAssessment__c> result = UNILAB_Housekeeping.loadAssessment('House Keeping',account.Id,  '2022', 'June' );
        Test.stopTest();
        
        System.assert(result.size() > 0);
    }
    
    @isTest static void checkThisMonthRecords () {
        
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
        insert account;
        
        WarehouseAssessment__c assessment = new WarehouseAssessment__c();
        assessment.Account__c = account.Id;
        assessment.Category__c = 'Backroom Personnel';
        assessment.Title__c = 'Test Data';
        assessment.Yes__c = true;
        assessment.No__c = false;
        assessment.NA__c = false;
        assessment.Remarks__c = 'Test Remarks';
        assessment.Year__c = '2022';
        assessment.Period__c = 'June';
        assessment.Type__c = 'House Keeping';
        insert assessment;
        
        Test.startTest();
        	List<WarehouseAssessment__c> result = UNILAB_Housekeeping.checkThisMonthRecords('House Keeping', 'June',  '2022',account.Id );
        Test.stopTest();
        
        System.assert(result.size() > 0);
    }
    
    @isTest static void getWarehouseAssessment () {
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
         insert account;
         
          
            WarehouseAssessment__c warehouseAssessment = new WarehouseAssessment__c();
	              
         
            warehouseAssessment.Account__c = account.Id;
            warehouseAssessment.Title__c = '1 - Ceiling-free of cobwebs, dust/dirt,leak/holes';
            warehouseAssessment.Category__c = 'A - Receiving Area';
            warehouseAssessment.Yes__c = True;
            warehouseAssessment.No__c = False;
            warehouseAssessment.NA__c = False;
            warehouseAssessment.Remarks__c ='TEST Remarks';
            warehouseAssessment.type__c = 'House Keeping';
            warehouseAssessment.Year__c = '2022';
            warehouseAssessment.Period__c = 'May';
            insert warehouseAssessment;
        
          Map<String, String> checklist = new Map<String, String >();

          checklist.put('title', '1 - Ceiling-free of cobwebs, dust/dirt,leak/holes');
          checklist.put('category', 'A - Receiving Area');
          checklist.put('Yes', 'True');
          checklist.put('No', 'False');
          checklist.put('Na', 'False');
          checklist.put('remarks', 'TEST Remarks');
          checklist.put('type', 'House Keeping');
              
         Test.startTest();
        	Integer getWarehouseAssessment =  UNILAB_Housekeeping.getWarehouseAssessment(account.Id, '2022', 'May');
          Test.stopTest();

         system.assert(getWarehouseAssessment >= 0); 


    
                   
      }
        
}