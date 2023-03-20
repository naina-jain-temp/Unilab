@isTest
public class UNILAB_Monthly_Manpower_Monitoring_Test {

    @isTest static void getChecklist() {
       
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
        insert account;
        
        Warehouse_Checklist__c Checklist = new Warehouse_Checklist__c();
        Checklist.Account__c = account.Id;
        Checklist.Type__c = 'Manpower';
        Checklist.Category__c = 'Backroom Personnel';
        Checklist.Title__c = 'Pharmacist';
        Checklist.inactive__c  = false;
        insert Checklist;
        
        Test.startTest();
        	List<Warehouse_Checklist__c> result = UNILAB_Monthly_Manpower_Monitoring.getChecklist('Manpower', 'Backroom Personnel', account.Id);
        Test.stopTest();
        
        System.assert(result.size() > 0);
	}
    
    
    
    @isTest static void getContacts () {
        
        Account account = new Account ();
        account.Name = '01010101';
        account.Branch_Code__c = '12345678';
        account.Bill_To_Code__c = '1234567890';
        insert account;
        
        Contact personnel = new Contact();
        personnel.AccountId = account.Id;
        personnel.LastName = 'Fermo';
        personnel.Role_Assignment__c = 'Distributor';
        personnel.Category__c = 'Backroom Personnel';
        personnel.Position__c = 'Pharmacist';
        insert personnel;
        
        List<String> personnels = new List<String>();
        personnels.add(personnel.Id);
 
        Test.startTest();
        	List<Contact> result = UNILAB_Monthly_Manpower_Monitoring.getContacts('Backroom Personnel', personnels, account.Id);
        	List<Contact> result2 = UNILAB_Monthly_Manpower_Monitoring.getContacts(null, personnels, account.Id);
        Test.stopTest();
        
        System.assert(result.size() > 0);
        System.assert(result2.size() > 0);
        
    }
    
    @isTest static void getTrucks () {
        
        Trucks__c trucks = new Trucks__c();
        trucks.Plate_No__c = 'ABC 123';
        trucks.Brand__c = 'ELF Truck';
        trucks.Transport_Type__c = 'Company Owned';
        trucks.Capacity__c = '1000 Boxes';
        insert trucks;
        
         List<String> truckList = new List<String>();
         truckList.add(trucks.id);
        
        List<String> truckList2 = new List<String>();
        
        Test.startTest();
        	List<Trucks__c> result = UNILAB_Monthly_Manpower_Monitoring.getTrucks(truckList);
        	List<Trucks__c> result2 = UNILAB_Monthly_Manpower_Monitoring.getTrucks(truckList2);
        Test.stopTest();
        
        System.assert(result.size() > 0);
        System.assert(result2.size() > 0);
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
        assessment.Required_Size__c = 5;
        assessment.ActualSize__c = 5;
        assessment.Deficit__c = 0;
        assessment.Rating__c = 1;
        assessment.Remarks__c = 'Test Remarks';
        assessment.selected_Value__c = 'Albert Fermo';
        assessment.Year__c = '2022';
        assessment.Period__c = 'June';
        assessment.Type__c = 'Manpower';
        insert assessment;
        
        Test.startTest();
        	List<WarehouseAssessment__c> result = UNILAB_Monthly_Manpower_Monitoring.loadAssessment('Manpower',account.Id, 'June', '2022' );
        Test.stopTest();
        
        System.assert(result.size() > 0);
    }
    
    @isTest static void getLastMonthRecord () {
        
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
        assessment.Type__c = 'Manpower';
        insert assessment;
        
        Test.startTest();
        	List<WarehouseAssessment__c> result = UNILAB_Monthly_Manpower_Monitoring.getLastMonthRecord('Manpower', 'June', '2022', account.Id);
        Test.stopTest();
        
        System.assert(result.size() > 0);
    }
    
    @isTest static void checkThisMonthRecord () {
        
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
        assessment.Type__c = 'Manpower';
        insert assessment;
        
        Test.startTest();
        	List<WarehouseAssessment__c> result = UNILAB_Monthly_Manpower_Monitoring.checkThisMonthRecord('Manpower', 'June', '2022', account.Id);
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
        assessment.Type__c = 'Manpower';
        assessment.Category__c = 'Backroom Personnel';
        assessment.Title__c = 'Pharmacist';
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
        checklist.put('position', 'Pharmacist');
        checklist.put('category', 'Backroom Personnel');
        checklist.put('rating', '1');
        checklist.put('remarks', 'test remarks');
        checklist.put('type', 'Manpower');
        checklist.put('actual', '5');
        checklist.put('required', '5');
        checklist.put('deficit', '0');
        checklist.put('object', 'Albert Fermo, Test2');
        
     
        Test.startTest();
        	String assessmentResult = UNILAB_Monthly_Manpower_Monitoring.saveWarehouseAssessment(checklist, account.Id, '2022', 'June');
        Test.stopTest();
        
        system.assert(assessmentResult != null);
    }
}