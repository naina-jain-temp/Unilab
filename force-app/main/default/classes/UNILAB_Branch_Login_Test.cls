@isTest
public class UNILAB_Branch_Login_Test {
    public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    
    @isTest
    public static void checkEventToday() {
        system.runAs(new User(Id = UserInfo.getUserId())){
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
            
            Test.startTest();
                Integer checkEventToday = UNILAB_Branch_Login.checkEventToday(testAcc.Id, testEvent.Id);
            Test.stopTest();
            System.assert(checkEventToday!=null);
        }
    }
    
    @isTest
    public static void fetchActJuncAccounts() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            
            Test.startTest();
                List<UNILAB_Branch_Login.ajAccountWrapper> fetchActJuncAccounts = UNILAB_Branch_Login.fetchActJuncAccounts(1,0);
            Test.stopTest();
            System.assert(fetchActJuncAccounts!=null);
        }
    }
    
    @isTest
    public static void insertCallEvent() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            List<Account> acctList = TestDataFactory.createAccount(10);
            insert acctList;
            
            Test.startTest();
                String insertCallEvent = UNILAB_Branch_Login.insertCallEvent(acctList[0].Id);
            Test.stopTest();
            System.assert(insertCallEvent!=null);
        }
    }
    
    @isTest
    public static void insertCallEventLog() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            Date todayDate = Date.today() ;
            DateTime todayDateTime = Datetime.Now();
            
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.Type = 'Call';
            testEvent.Event_Type__c = 'Call';
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
            
            Double testLatitude = 14.5741292;
            Double testLongitude = 121.0542468;
            String userId = userInfo.getUserId();
           
            Test.startTest();
            	/*
            	String activityJunctionId = [select Id
                from Activity_Junction__c 
                where Related_To_Account__c = :testAcc.Id].Id;*/
            
                String newEventLogRecord = UNILAB_Branch_Login.insertCallEventLog(testEvent.Related_To_Account__c,testLatitude,testLongitude);
                //Event_Log__c newEventLogRecord = new Event_Log__c();
                /*
                Event_Log__c newEventLogRecord = new Event_Log__c(Activity_Junction__c = aj.Id,
                                                     Account__c = testAcc.Id,
                                                     Latitude__c = testLatitude,
                                                     Longitude__c = testLongitude,
                                                     Start_Date__c = todayDateTime
                );
                insert newEventLogRecord;*/
            Test.stopTest();
            
            //System.assert(testAcc.Id!=null);
            System.assert(newEventLogRecord!=null);
        }
    }
    
    @isTest
    public static void endCallDraftEvent() {
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
            
            Event_Log__c testECL = new Event_Log__c(Activity_Junction__c = aj.Id,
                                                     Account__c = testAcc.Id,
                                                     Start_Date__c = todayDateTime
                                                             );
            insert testECL;
            
            Test.startTest();
            	String eventCallLogRecord = UNILAB_Branch_Login.endCallDraftEvent();
            	/*
                Event_Log__c eventCallLogRecord = [select End_Date__c
                                      from Event_Log__c 
                                      where CreatedById = :UserInfo.getUserId()
                                      and Account__c = :testUserRec.Currently_Logged_Account_ID__c
                                      and End_Date__c = null
                                      and Event_Id__c = :testUserRec.Currently_Logged_Event_ID__c
                                     ];
                
                eventCallLogRecord.End_Date__c = todayDateTime;
                
                update eventCallLogRecord;*/
            Test.stopTest();
            System.assert(eventCallLogRecord!=null);
            
        }
    }
	
    @isTest
    public static void updateUserLogged() {
        system.runAs(new User(Id = UserInfo.getUserId())){
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
            
            User testUserRec = new User();
            testUserRec = [select Id,Currently_Logged_Account_ID__c,Currently_Logged_Event_ID__c from User where Id = :UserInfo.getUserId()];
            testUserRec.Currently_Logged_Account_ID__c = testAcc.Id;
            testUserRec.Currently_Logged_Event_ID__c = testEvent.Id;
            update testUserRec;
            
            DateTime todayDateTime = Datetime.Now();
            
            Event_Log__c testECL = new Event_Log__c(Activity_Junction__c = aj.Id,
                                                     Account__c = testAcc.Id,
                                                     Start_Date__c = todayDateTime
                                                             );
            insert testECL;
            
            Test.startTest();
            	String updateUserLogged = UNILAB_Branch_Login.updateUserLogged(testAcc.Id,testEvent.Id,aj.Id);
            Test.stopTest();
            System.assert(updateUserLogged!=null);
        }
    }
}