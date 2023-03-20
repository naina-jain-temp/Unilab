@isTest
public class UNILAB_ProcessCompliance_Checklist_Test {
   
    @isTest static void getChecklist() {
       
        Warehouse_Checklist__c Checklist = new Warehouse_Checklist__c();
        Checklist.Type__c = 'Process Compliance';
        Checklist.Category__c = 'TOM-02: Order Processing';
        Checklist.Title__c = 'testData';
        Checklist.Section__c = 'I. Total Order Management';
        Checklist.inactive__c  = false;
        insert Checklist;
        
        Test.startTest();
        	List<Warehouse_Checklist__c> result = UNILAB_ProcessCompliance_Checklist.getChecklist('Process Compliance');
        Test.stopTest();
        
        System.assert(result.size() > 0);
        
    }
    @isTest static void loadAssessment() {
        
       	Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
        insert account;
        
        WarehouseAssessment__c assessment = new WarehouseAssessment__c();
        assessment.Account__c = account.Id;
        assessment.Type__c = 'Process Compliance';
        assessment.Category__c = 'TOM-02: Order Processing';
        assessment.Section__c = 'I. Total Order Management';
        assessment.Title__c = 'testdatatitle';
        assessment.Year__c = '2022';
        assessment.Period__c = 'June';
		assessment.Remarks__c = 'Test Remarks';
        assessment.ActualSize__c = 10;
        assessment.is_Draft__c = true;
        assessment.Rating__c = 1;
        assessment.Required_Size__c = 10;
        assessment.Deficit__c = 0;
        insert assessment;
        
        Test.startTest();
        	List<WarehouseAssessment__c> assessmentResult = UNILAB_ProcessCompliance_Checklist.loadAssessment('Process Compliance', account.Id,'June', '2022' );
        Test.stopTest();
        
        system.assert(assessmentResult.size() > 0);
           
    } 
    
    @isTest static void retrieveDraftAssessment() {
        
       	Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
        insert account;
        
        WarehouseAssessment__c assessment = new WarehouseAssessment__c();
        assessment.Account__c = account.Id;
        assessment.Type__c = 'Process Compliance';
        assessment.Category__c = 'TOM-02: Order Processing';
        assessment.Section__c = 'I. Total Order Management';
        assessment.Title__c = 'testdatatitle';
        assessment.Year__c = '2022';
        assessment.Period__c = 'June';
		assessment.Remarks__c = 'Test Remarks';
        assessment.ActualSize__c = 10;
        assessment.is_Draft__c = true;
        assessment.Rating__c = 1;
        assessment.Required_Size__c = 10;
        assessment.Deficit__c = 0;
        insert assessment;
        
        Test.startTest();
        	List<WarehouseAssessment__c> assessmentResult = UNILAB_ProcessCompliance_Checklist.retrieveDraftAssessment('Process Compliance', 'June', '2022', account.Id);
        Test.stopTest();
        
        system.assert(assessmentResult.size() > 0);
           
    } 
    
    @isTest static void checkWarehouseAssessment () {
        
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
        insert account;
        
        WarehouseAssessment__c assessment = new WarehouseAssessment__c();
        assessment.Account__c = account.Id;
        assessment.Type__c = 'Process Compliance';
        assessment.Category__c = 'TOM-02: Order Processing';
        assessment.Section__c = 'I. Total Order Management';
        assessment.Title__c = 'testdatatitle';
        assessment.Year__c = '2022';
        assessment.Period__c = 'June';
		assessment.Remarks__c = 'Test Remarks';
        assessment.ActualSize__c = 10;
        assessment.is_Draft__c = true;
        assessment.Rating__c = 1;
        assessment.Required_Size__c = 10;
        assessment.Deficit__c = 0;
        insert assessment;
        
        Test.startTest();
        	String assessmentResult = UNILAB_ProcessCompliance_Checklist.checkWarehouseAssessment('June', '2022');
        Test.stopTest();
        
        system.assert(assessmentResult != null);
        
    }
    @isTest static void checkThisSemesterRecord () {
        
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
        insert account;
        
        WarehouseAssessment__c assessment = new WarehouseAssessment__c();
        assessment.Account__c = account.Id;
        assessment.Category__c = 'Backroom Personnel';
        assessment.Title__c = 'Test Data';
        assessment.Required_Size__c = 5;
        assessment.ActualSize__c = 5;
        assessment.Deficit__c = 0;
        assessment.Rating__c = 1;
        assessment.Remarks__c = 'Test Remarks';
        assessment.selected_Value__c = 'Albert Fermo';
        assessment.Year__c = '2022';
        assessment.Period__c = 'June';
        assessment.Type__c = 'Process Compliance';
        insert assessment;
        
        Test.startTest();
        	List<WarehouseAssessment__c> result = UNILAB_ProcessCompliance_Checklist.checkThisSemesterRecord('Process Compliance', 'June', '2022', account.Id);
        Test.stopTest();
        
        System.assert(result.size() > 0);
    }
    @isTest static void saveWarehouseAssessment () {
        
        
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
        insert account;
        
        WarehouseAssessment__c assessment = new WarehouseAssessment__c();
        assessment.Account__c = account.Id;
        assessment.Type__c = 'Process Compliance';
        assessment.Category__c = 'TOM-02: Order Processing';
        assessment.Section__c = 'I. Total Order Management';
        assessment.Title__c = 'testdatatitle';
        assessment.Year__c = '2022';
        assessment.Period__c = 'June';
		assessment.Remarks__c = 'Test Remarks';
        assessment.ActualSize__c = 10;
        assessment.is_Draft__c = true;
        assessment.Rating__c = 1;
        assessment.Required_Size__c = 10;
        assessment.Deficit__c = 0;
        insert assessment;
        
        Map<String, String> checklist = new Map<String, String >();
        checklist.put('title', 'testdata');
        checklist.put('section', 'I. Total Order Management');
        checklist.put('category', 'TOM-02: Order Processing');
        checklist.put('rating', '1');
        checklist.put('remarks', 'test remarks');
        checklist.put('type', 'Process Compliance');
        
        Test.startTest();
        	String assessmentResult = UNILAB_ProcessCompliance_Checklist.saveWarehouseAssessment(checklist, account.Id, '2022', 'June', 1);
        Test.stopTest();
        
        system.assert(assessmentResult != null);
    }
    
}