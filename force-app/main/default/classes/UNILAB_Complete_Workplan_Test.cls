@isTest
private class UNILAB_Complete_Workplan_Test {
	@isTest
    private static void fetchUserLoggedAcctEvent() {
        Account acc = new Account();
        acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
     	insert acc;
        
        Test.startTest();
        String eventResp = UNILAB_Complete_Workplan.fetchUserLoggedAcctEvent(acc.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(eventResp));
    }
    
    @isTest
    private static void getPicklistvaluesNotRequired() {
        String obj = 'Event';
        String apiField = 'Mode_of_Contact__c';
        
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
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
        List<String> picklist = UNILAB_Complete_Workplan.getPicklistvalues(obj, apiField, false);
        Test.stopTest();
        
        System.assert(picklist.size()>0);
    }
    
    @isTest
    private static void getPicklistvaluesRequired() {
        String obj = 'Event';
        String apiField = 'Mode_of_Contact__c';
        
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
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
        List<String> picklist = UNILAB_Complete_Workplan.getPicklistvalues(obj, apiField, true);
        Test.stopTest();
        
        System.assert(picklist.size()>0);
    }
    
    @isTest
    private static void fetchEventMOC() {
        String obj = 'Event';
        String apiField = 'Mode_of_Contact__c';
        
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        testEvent.Mode_of_Contact__c = 'Onsite';
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
        String moc = UNILAB_Complete_Workplan.fetchEventMOC(testAcc.Id, testEvent.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(moc));
    }
    
    @isTest
    private static void fetchEventLocBase() {
        String obj = 'Event';
        String apiField = 'Location_Based__c';
        
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        testEvent.Location_Based__c = 'Home Base';
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
        String loc = UNILAB_Complete_Workplan.fetchEventLocBase(testAcc.Id, testEvent.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(loc));
    }
    
    @isTest
    private static void fetchEventLoc() {
        String obj = 'Event';
        String apiField = 'Location_Custom__c';
        
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        testEvent.Location_Custom__c = 'MANILA';
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
        String loc = UNILAB_Complete_Workplan.fetchEventLoc(testAcc.Id, testEvent.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(loc));
    }
    
    @isTest
    private static void saveWorkplan() {
        String obj = 'Event';
        String apiField = 'Location_Custom__c';
        
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        testEvent.Location_Custom__c = 'MANILA';
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
        testUserRec = [select Id,Currently_Logged_Account_ID__c,Currently_Logged_Event_ID__c,Currently_Logged_Account_Junction_ID__c from User where Id = :UserInfo.getUserId()];
        testUserRec.Currently_Logged_Account_ID__c = testAcc.Id;
        testUserRec.Currently_Logged_Event_ID__c = testEvent.Id;
        testUserRec.Currently_Logged_Account_Junction_ID__c = aj.Id;
        update testUserRec;
        
        String modeOfContact = 'Onsite';
        String locationBase = 'Home Base';
        String location = 'MANILA';
        String description = 'Test';
            
        
        Test.startTest();
        String result = UNILAB_Complete_Workplan.saveWorkplan(testAcc.Id, testEvent.Id, modeOfContact, locationBase, location, description);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(result));
    }
    
    @isTest
    private static void submitWorkplan() {
        String obj = 'Event';
        String apiField = 'Location_Custom__c';
        
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        testEvent.Location_Custom__c = 'MANILA';
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
        String result = UNILAB_Complete_Workplan.submitWorkplan(testAcc.Id, testEvent.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(result));
    }
    
    @isTest
    private static void endCall() {
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        testEvent.Location_Custom__c = 'MANILA';
        insert testEvent;
        
        Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
        insert testAcc;         
        
        Activity_Junction__c aj = new Activity_Junction__c();
        aj.Event_Id__c = testEvent.Id;
        aj.Related_to_Account__c = testAcc.Id;
        insert aj;
        
        testEvent.Activity_Junction__c = aj.Id;
        update testEvent;
        
        DateTime nowDate = DateTime.now();
                
        Event_Log__c log = new Event_Log__c();
        log.Account__c = testAcc.Id;
        log.End_Date__c = null;
        log.Activity_Junction__c = aj.Id;
        insert log;
        
        Test.startTest();
        String result = UNILAB_Complete_Workplan.endCall(testAcc.Id, testEvent.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(result));
    }
}