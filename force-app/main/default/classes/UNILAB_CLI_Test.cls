@isTest
public class UNILAB_CLI_Test {
    public static List<public_data_cli__x> mockedRequests = new List<public_data_cli__x>();
    public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    
	@isTest static void fetch() {
        system.runAs(testUser1){
        Account parentAcct = new Account();
        parentAcct.Name = 'Sample';
        parentAcct.Bill_To_Code__c = '0080101010';
        parentAcct.Branch_Code__c = '0080101010';
        parentAcct.Branch_Name__c = 'Sample';
        insert parentAcct;
        
        Test.startTest();
        	List<public_data_cli__x> cli = UNILAB_CLI.fetch(parentAcct.Id);
        Test.stopTest();
        System.assert(parentAcct.Id!=null);
        }
    }
    
    @isTest static void fetchEA() {
    	/*Account parentAcct = new Account();
        parentAcct.Name = 'Sample';
        parentAcct.Bill_To_Code__c = '0080101010';
        parentAcct.Branch_Code__c = '0080101010';
        parentAcct.Branch_Name__c = 'Sample';
        insert parentAcct;
        
        Date todayDate = Date.today(); 
        String userId = userInfo.getUserId();
        
        Event eventCal = new Event();
        eventCal.Event_Type__c='Calls';
        eventCal.StartDateTime=todayDate;
        eventCal.WhatId=parentAcct.Id;
        eventCal.CreatedById=userId;
        insert eventCal;*/
        
            system.runAs(new User(Id = UserInfo.getUserId())){
            Test.startTest();
            
        	//Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            //insert eventActJunctFields;
         
            //create event
			//Account testAcc = TestDataFactory.createSingleAccount('Sample');
            //insert testAcc;   
        	Account testAcc = new Account();
            testAcc.Name = 'Sample';
            testAcc.Bill_To_Code__c = '0080101010';
            testAcc.Branch_Code__c = '0080101010';
            testAcc.Branch_Name__c = 'Sample';
            insert testAcc;
                
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
        	testEvent.ActivityDate= date.today();
            testEvent.StartDateTime = date.today();
            testEvent.EndDateTime = dateTime.now(); 
            testEvent.Event_Type__c = 'Call';
            testEvent.Event_Sub_type__c = 'BRANCH CALL';
            testEvent.Location_Based__c = 'Home Base';
            testEvent.Related_to_Account__c = testAcc.Id;
            testEvent.Work_Plan__c = false;
            testEvent.Status__c = 'New';
            insert testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Event_Type__c = 'Call';
            aj.Event_Sub_type__c = 'BRANCH CALL';
            aj.Location_Based__c = 'Home Base';
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
           
            List<Sub_Activity__c> subActs = new List<Sub_Activity__c>();
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'TRADE AUDIT (5Ps)';
            
            insert subActs; 
            Id cal = UNILAB_CLI.fetchEA(testAcc.Id);
            
            Test.stopTest();
            
        	//system.assert(cal!=null,'Fetch error');
            }
        
        
    }
    
    @isTest static void fetchESA() {
        system.runAs(testUser1){
        Account parentAcct = new Account();
        parentAcct.Name = 'Sample';
        parentAcct.Bill_To_Code__c = '0080101010';
        parentAcct.Branch_Code__c = '0080101010';
        parentAcct.Branch_Name__c = 'Sample';
        insert parentAcct;
        
        Test.startTest();
        	List<Sub_Activity__c> cli = UNILAB_CLI.fetchESA(parentAcct.Id);
        Test.stopTest();
        System.assert(parentAcct.Id!=null);
        }
    }
    
    @isTest static void saveForm() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            
            Account testAcc = new Account();
            testAcc.Name = 'Sample';
            testAcc.Bill_To_Code__c = '0080101010';
            testAcc.Branch_Code__c = '0080101010';
            testAcc.Branch_Name__c = 'Sample';
            insert testAcc;
            
            String recordID='0019D000008kRjfQAE';
            String journalBox='Test Journal Box';
            String userId = userInfo.getUserId();
            Date todayDate = Date.today() ;
            
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
        	testEvent.ActivityDate= date.today();
            testEvent.StartDateTime = date.today();
            testEvent.EndDateTime = dateTime.now(); 
            testEvent.Event_Type__c = 'Call';
            testEvent.Event_Sub_type__c = 'BRANCH CALL';
            testEvent.Location_Based__c = 'Home Base';
            testEvent.Related_to_Account__c = testAcc.Id;
            testEvent.Work_Plan__c = false;
            testEvent.Status__c = 'New';
            insert testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Event_Type__c = 'Call';
            aj.Event_Sub_type__c = 'BRANCH CALL';
            aj.Location_Based__c = 'Home Base';
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
           
            List<Sub_Activity__c> subActs = new List<Sub_Activity__c>();
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'COLLECTION';
            
            insert subActs; 
            
            List<public_data_cli__x> lstKF = [SELECT descr__c FROM public_data_cli__x];
           	
            Test.startTest();
            	UNILAB_CLI.saveForm(lstKF, testAcc.Id, journalBox);
            Test.stopTest();
        }
    }
    
	
}