@isTest
public class UNILAB_Rentals_Test {
	
    @isTest
    public static void fetchUserLoggedAcctEvent() {
        system.runAs(new User(Id = UserInfo.getUserId())){
			
			Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;     
            
            Test.startTest();
                String fetchUserLoggedAcctEvent = UNILAB_Rentals.fetchUserLoggedAcctEvent(testAcc.Id);
            Test.stopTest();
            System.assert(fetchUserLoggedAcctEvent!=null);
        }
    }
    
    @isTest
    public static void fetchRentalTodayCount() {
        system.runAs(new User(Id = UserInfo.getUserId())){
			
			Date todayDate = Date.today() ;
            DateTime todayDateTime = Datetime.Now();
            
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.Type = 'Call';
            testEvent.StartDateTime = todayDate; 
            testEvent.EndDateTime = todayDate;
            //testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;      
            
            testEvent.Related_To_Account__c = testAcc.Id;
            update testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
            
            User testUserRec = new User();
            testUserRec = [select Id,Currently_Logged_Account_ID__c,Currently_Logged_Event_ID__c from User where Id = :UserInfo.getUserId()];
            testUserRec.Currently_Logged_Account_ID__c = testAcc.Id;
            testUserRec.Currently_Logged_Event_ID__c = testEvent.Id;
            update testUserRec;
            
            Event_Log__c testECL = new Event_Log__c();
            testECL.Activity_Junction__c = aj.Id;
			testECL.Account__c = testAcc.Id;
            testECL.Start_Date__c = todayDateTime;
            insert testECL;
            
            Test.startTest();
                Integer fetchRentalTodayCount = UNILAB_Rentals.fetchRentalTodayCount(testAcc.Id, testEvent.Id);
            Test.stopTest();
            System.assert(fetchRentalTodayCount!=null);
        }
    }
    
    @isTest
    public static void populateInitialRentals() {
        system.runAs(new User(Id = UserInfo.getUserId())){
			
			Date todayDate = Date.today() ;
            DateTime todayDateTime = Datetime.Now();
            
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.Type = 'Call';
            testEvent.StartDateTime = todayDate; 
            testEvent.EndDateTime = todayDate;
            //testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;      
            
            testEvent.Related_To_Account__c = testAcc.Id;
            update testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'TRADE CHECK BUDDY';
            insert subActivity;
            
            /*
            User testUserRec = new User();
            testUserRec = [select Id,Currently_Logged_Account_ID__c,Currently_Logged_Event_ID__c from User where Id = :UserInfo.getUserId()];
            testUserRec.Currently_Logged_Account_ID__c = testAcc.Id;
            testUserRec.Currently_Logged_Event_ID__c = testEvent.Id;
            update testUserRec;
            
            Event_Log__c testECL = new Event_Log__c();
            testECL.Activity_Junction__c = aj.Id;
			testECL.Account__c = testAcc.Id;
            testECL.Start_Date__c = todayDateTime;
            insert testECL;*/
            
            Rental_Ref__c testPriorityData = new Rental_Ref__c();
            testPriorityData.Criteria__c='Planogram';
            testPriorityData.Criteria_Sorting__c = 1;
            insert testPriorityData;
            
            Test.startTest();
                String populateInitialRentals = UNILAB_Rentals.populateInitialRentals(testAcc.Id, testEvent.Id);
            Test.stopTest();
            System.assert(populateInitialRentals!=null);
        }
    }
    
    @isTest
    public static void fetchCriteria() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            Date todayDate = Date.today() ;
            DateTime todayDateTime = Datetime.Now();
            
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.Type = 'Call';
            testEvent.StartDateTime = todayDate; 
            testEvent.EndDateTime = todayDate;
            //testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;      
            
            testEvent.Related_To_Account__c = testAcc.Id;
            update testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'TRADE CHECK BUDDY';
            insert subActivity;
            
            String activityRecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Rentals').getRecordTypeId();
            
            TCB_Activity__c testActivity = new TCB_Activity__c();
            testActivity.Account__c = testAcc.Id;
            testActivity.Sub_Activity__c = subActivity.Id;
            testActivity.RecordTypeId = activityRecordTypeId;
            testActivity.Item__c = 'Planogram';
            testActivity.Yes__c = true;
            testActivity.No__c = false;
            insert testActivity;
            
            Test.startTest();
                List<TCB_Activity__c> fetchCriteria = UNILAB_Rentals.fetchCriteria(testAcc.Id, testEvent.Id);
            Test.stopTest();
            System.assert(fetchCriteria!=null);
            
        }
    }
    
    @isTest
    public static void fetchPrevJournal() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            Date todayDate = Date.today() ;
            DateTime todayDateTime = Datetime.Now();
            
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.Type = 'Call';
            testEvent.StartDateTime = todayDate; 
            testEvent.EndDateTime = todayDate;
            //testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;      
            
            testEvent.Related_To_Account__c = testAcc.Id;
            update testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'TRADE CHECK BUDDY';
            insert subActivity;
            
            String activityRecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Rentals Journal').getRecordTypeId();
            
            TCB_Activity__c testActivity = new TCB_Activity__c();
            testActivity.Account__c = testAcc.Id;
            testActivity.Sub_Activity__c = subActivity.Id;
            testActivity.RecordTypeId = activityRecordTypeId;
            testActivity.Item__c = '---';
            testActivity.Remarks__c = 'Journal 101';
            testActivity.Yes__c = true;
            testActivity.No__c = false;
            insert testActivity;
            
            Test.startTest();
                String fetchPrevJournal = UNILAB_Rentals.fetchPrevJournal(testAcc.Id);
            Test.stopTest();
            System.assert(fetchPrevJournal!=null);
            
        }
    }
    
    @isTest
    public static void saveJournal() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            Date todayDate = Date.today() ;
            DateTime todayDateTime = Datetime.Now();
            
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.Type = 'Call';
            testEvent.StartDateTime = todayDate; 
            testEvent.EndDateTime = todayDate;
            //testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;      
            
            testEvent.Related_To_Account__c = testAcc.Id;
            update testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'TRADE CHECK BUDDY';
            insert subActivity;
            
            /*
            String activityRecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Rentals Journal').getRecordTypeId();
            
            TCB_Activity__c testActivity = new TCB_Activity__c();
            testActivity.Account__c = testAcc.Id;
            testActivity.Sub_Activity__c = subActivity.Id;
            testActivity.RecordTypeId = activityRecordTypeId;
            testActivity.Item__c = '---';
            testActivity.Remarks__c = 'Journal 101';
            testActivity.Yes__c = true;
            testActivity.No__c = false;
            insert testActivity;*/
            
            Test.startTest();
                String saveJournal = UNILAB_Rentals.saveJournal(testAcc.Id,'Journal 101',testEvent.Id);
            Test.stopTest();
            System.assert(saveJournal!=null);
            
        }
    }
    
    @isTest
    public static void saveFiles() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            Date todayDate = Date.today() ;
            DateTime todayDateTime = Datetime.Now();
            
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.Type = 'Call';
            testEvent.StartDateTime = todayDate; 
            testEvent.EndDateTime = todayDate;
            //testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;      
            
            testEvent.Related_To_Account__c = testAcc.Id;
            update testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'TRADE CHECK BUDDY';
            insert subActivity;
            
            
            String activityRecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Rental Files').getRecordTypeId();
            
            TCB_Activity__c testActivity = new TCB_Activity__c();
            testActivity.Account__c = testAcc.Id;
            testActivity.Sub_Activity__c = subActivity.Id;
            testActivity.RecordTypeId = activityRecordTypeId;
            testActivity.Item__c = 'Related File';
            testActivity.Remarks__c = '---';
            testActivity.Yes__c = true;
            testActivity.No__c = false;
            insert testActivity;
            
            Test.startTest();
                String saveFiles = UNILAB_Rentals.saveFiles(testAcc.Id,testEvent.Id);
            Test.stopTest();
            System.assert(saveFiles!=null);
            
        }
    }
    @isTest
    public static void updateForm() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            Date todayDate = Date.today() ;
            DateTime todayDateTime = Datetime.Now();
            
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.Type = 'Call';
            testEvent.StartDateTime = todayDate; 
            testEvent.EndDateTime = todayDate;
            //testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;      
            
            testEvent.Related_To_Account__c = testAcc.Id;
            update testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'TRADE CHECK BUDDY';
            insert subActivity;
            
            
            String activityRecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Rentals').getRecordTypeId();
            
            List<TCB_Activity__c> testActivity = new List<TCB_Activity__c>();
            Integer cnt = 5;
            for(Integer x=0; x<cnt; x++){
                TCB_Activity__c testActivityList = new TCB_Activity__c();
                testActivityList.Account__c = testAcc.Id;
                testActivityList.Sub_Activity__c = subActivity.Id;
                testActivityList.RecordTypeId = activityRecordTypeId;
                testActivityList.Item__c = 'Planogram ' + x;
                testActivityList.Remarks__c = '---';
                testActivityList.Yes__c = true;
                testActivityList.No__c = false;
                
                testActivity.add(testActivityList);
            }
            
            insert testActivity;
            
            Test.startTest();
            	String updateForm = UNILAB_Rentals.updateForm(testActivity, testAcc.Id);
            Test.stopTest();
            System.assert(updateForm!=null);
            
        }
    }
}