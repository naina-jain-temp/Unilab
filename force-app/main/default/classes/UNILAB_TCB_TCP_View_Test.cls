@isTest
public class UNILAB_TCB_TCP_View_Test {
	public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    /*
    @isTest
    public static void checkEventToday() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            List<Account> acctList = TestDataFactory.createAccount(10);
            insert acctList;
            
            Test.startTest();
                Integer checkEventToday = UNILAB_TCB_TCP_View.checkEventToday(acctList[0].Id);
            Test.stopTest();
            System.assert(checkEventToday!=null);
        }
    }
    
    @isTest
    public static void fetchECL() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.StartDateTime = dateTime.now(); 
            testEvent.EndDateTime = dateTime.now();
            //testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;         
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
            
            Double testLatitude = 14.5741292;
            Double testLongitude = 121.0542468;
            String userId = userInfo.getUserId();
            Date todayDate = Date.today() ;
            DateTime todayDateTime = Datetime.Now();
            
            Event_Log__c testECL = new Event_Log__c();
            testECL.Activity_Junction__c = aj.Id;
            testECL.Account__c = testAcc.Id;
            testECL.Latitude__c = testLatitude;
            testECL.Longitude__c = testLongitude;
            testECL.Start_Date__c = todayDateTime;
                                                            
            insert testECL;
            
            Test.startTest();
                String fetchECL = UNILAB_TCB_TCP_View.fetchECL(testAcc.Id);
            Test.stopTest();
            System.assert(fetchECL!=null);
        }
    }*/
    
    @isTest
    public static void fetchUserLoggedAcctEvent() {
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
                String fetchUserLoggedAcctEvent = UNILAB_TCB_TCP_View.fetchUserLoggedAcctEvent(testAcc.Id);
            Test.stopTest();
            System.assert(fetchUserLoggedAcctEvent!=null);
            
        }
    }
    
    @isTest
    public static void fetchPriorities() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;      
            
            Date todayDate = Date.today();
            
            Priority_Reference__c testPriorityRef = new Priority_Reference__c();
            testPriorityRef.Description__c = 'Test Promo';
            testPriorityRef.Initiatives_Type__c = 'Test Type';
            testPriorityRef.Initiatives_Sub_type__c = 'Test Sub Type';
            testPriorityRef.Category__c = 'OTC';
            testPriorityRef.Account_Group__c = testAcc.Account_Group__c;
            testPriorityRef.Priority_Type__c = 'TOP PROMO';
            testPriorityRef.Monitoring_Start_Date__c = todayDate;
            testPriorityRef.Monitoring_End_Date__c = todayDate;
            insert testPriorityRef;
            
            /*String acctGroup = [SELECT Account_Group__c FROM Account WHERE Id = :testAcc.Id 
                                     		Limit 1].Account_Group__c;*/
            
            Test.startTest();
                List<Priority_Reference__c> fetchECL = UNILAB_TCB_TCP_View.fetchPriorities(testAcc.Id,'TOP PROMO');
            Test.stopTest();
            System.assert(fetchECL!=null);
            
            
        }
    }
    
    @isTest
    public static void fetchPrevJournal() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            Account acc = new Account();
            //acc.RecordTypeId = '0127F000000pSdUQAU';
            acc.Name = 'acc1';
            acc.Bill_To_Code__c = '0080322195';
            acc.Account_Group__c = 'MDC';
            insert acc;
            
            String activityRecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('TCB Journal').getRecordTypeId();
                
            TCB_Activity__c tac = new TCB_Activity__c();
            tac.Account__c = acc.Id;
            tac.Category__c = 'Test Cat';
            tac.Remarks__c = 'Test Remarks';
            tac.RecordTypeId = activityRecordTypeId;
            insert tac;
            
            Test.startTest();
                String fetchPrevJournal = UNILAB_TCB_TCP_View.fetchPrevJournal(acc.Id);
            Test.stopTest();
            
            System.assertEquals('Test Remarks', fetchPrevJournal);
        }
        /*
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
            
            String activityRecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('TCB Journal').getRecordTypeId();
            
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
                String fetchPrevJournal = UNILAB_TCB_TCP_View.fetchPrevJournal(testAcc.Id);
            Test.stopTest();
            //System.assert(fetchPrevJournal!=null);
            System.assertNotEquals('', fetchPrevJournal);
            
        }*/
    }
    
    /*
    @isTest
    public static void fetchPreviousLearningsAndInsights() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            
            
            Test.startTest();
                String fetchPreviousLearningsAndInsights = UNILAB_TCB_TCP_View.fetchPreviousLearningsAndInsights(null,null);
            Test.stopTest();
            System.assert(fetchPreviousLearningsAndInsights!=null);
            
        }
    }*/
    
}