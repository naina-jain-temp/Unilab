@isTest
private class UNILAB_TCB_Form_Test {
	@isTest
    private static void fetchUserLogged() {
        Account acc = new Account();
        acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
     	insert acc;
        
        Test.startTest();
        String eventResp = UNILAB_TCB_Form.fetchUserLoggedAcctEvent(acc.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(eventResp));
    }
    
    @isTest
    private static void fetchAcctCategory() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
     	insert acc;
        
        TCB_Category_Ref__c tcr = new TCB_Category_Ref__c();
        tcr.Category__c = 'Pharmacy';
        tcr.Account__c = acc.Id;
        insert tcr;
        
        Test.startTest();
        List<TCB_Category_Ref__c> listTCR = UNILAB_TCB_Form.fetchAcctCategory(acc.Id);
        Test.stopTest();
        
        System.assert(listTCR.size()>0);
    }
    
    @isTest
    private static void fetchRES() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
        acc.Retail_Environment__c = 'Drugstore Commercial Self-service Big';
     	insert acc;
        
        Test.startTest();
        String listTCR = UNILAB_TCB_Form.fetchRES(acc.Id);
        Test.stopTest();
        
        System.assertEquals('Drugstore Commercial Self-service Big', listTCR);
    }
    
    @isTest
    private static void fetchAcctGroup() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
        acc.Account_Group__c = 'MDC';
     	insert acc;
        
        Test.startTest();
        String listTCR = UNILAB_TCB_Form.fetchAcctGroup(acc.Id);
        Test.stopTest();
        
        System.assertEquals('MDC', listTCR);
    }
    
    @isTest
    private static void fetchTCBActivityCount() {
        Account acc = TestDataFactory.createSingleAccount('TestAccount');
        insert acc;
        
        Activity_Junction__c aj = new Activity_Junction__c(
                               Validated__c= false,
                               Work_Plan__c= true,
                               Event_Type__c= 'Special Activity/Partnering',
                               Event_Sub_type__c= 'HOSPITAL ACTIVITY',
                               Location_Based__c= 'Home Base',
                               Mode_of_Contact__c= 'Online',
                               Status__c = 'Completed'
                              );
        insert aj;
        
        Sub_Activity__c sub = new Sub_Activity__c();
        sub.Remarks__c = 'Test';
        sub.Activity_Junction__c = aj.Id;
        insert sub;
        
        TCB_Activity__c tact = new TCB_Activity__c();
        tact.Account__c = acc.Id;
        tact.Sub_Activity__c = sub.Id;
        insert tact;
        
        Test.startTest();
        Integer listTCR = UNILAB_TCB_Form.fetchTCBActivityCount(acc.Id, sub.Id);
        Test.stopTest();
        
        System.assertEquals(0, listTCR);
    }
    
    @isTest
    private static void populateTCBSubActivity() {
        
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
        
        Sub_Activity__c subact = new Sub_Activity__c();
        subact.Activity_Junction__c = aj.Id;
        insert subact;
        
        Test.startTest();
        String listTCR = UNILAB_TCB_Form.populateTCBSubActivity(testEvent.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(listTCR));
    }
    
    @isTest
    private static void populateInitialTCBVisibility() {
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
        
        Sub_Activity__c subact = new Sub_Activity__c();
        subact.Activity_Junction__c = aj.Id;
        insert subact;
        
        String fRES = UNILAB_TCB_Form.fetchRES(testAcc.Id);
        
        TCB_Visibility_Ref__c tvr = new TCB_Visibility_Ref__c();
        tvr.Target__c = 'Test Target';
        tvr.Category__c = 'Soap';
        insert tvr;
            
        Test.startTest();
        String vis = UNILAB_TCB_Form.populateInitialTCBVisibility(testAcc.Id, fRES, testEvent.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(vis));
    }
    
    @isTest
    private static void populateInitialTCBAssortment() {
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        insert testEvent;
        
        Account acc = TestDataFactory.createSingleAccount('TestAccount');
        insert acc;         
        
        Activity_Junction__c aj = new Activity_Junction__c();
        aj.Event_Id__c = testEvent.Id;
        aj.Related_to_Account__c = acc.Id;
        insert aj;
        
        testEvent.Activity_Junction__c = aj.Id;
        update testEvent;
        
        Sub_Activity__c subact = new Sub_Activity__c();
        subact.Activity_Junction__c = aj.Id;
        insert subact;
        
        TCB_Assortment_Ref__c tvr = new TCB_Assortment_Ref__c();
        tvr.Item_Name__c = 'Test Target';
        tvr.Category__c = 'Soap';
        tvr.Account__c = acc.Id;
        insert tvr;
            
        Test.startTest();
        String vis = UNILAB_TCB_Form.populateInitialTCBAssortment(acc.Id, testEvent.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(vis));
    }
    
    @isTest
    private static void populateInitialTCBTOPPriorities() {
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
        
        Sub_Activity__c subact = new Sub_Activity__c();
        subact.Activity_Junction__c = aj.Id;
        insert subact;
        
        //String fRES = UNILAB_TCB_Form.fetchRES(testAcc.Id);
        
        Date todayDate = Date.today();
            
        Priority_Reference__c testPriorityRef = new Priority_Reference__c();
        testPriorityRef.Description__c = 'Test Promo';
        testPriorityRef.Initiatives_Type__c = 'Test Type';
        testPriorityRef.Initiatives_Sub_type__c = 'Test Sub Type';
        testPriorityRef.Category__c = 'OTC';
        testPriorityRef.Account_Group__c = '7-ELEVEN';
        testPriorityRef.Priority_Type__c = 'TOP PROMO';
        testPriorityRef.Monitoring_Start_Date__c = todayDate;
        testPriorityRef.Monitoring_End_Date__c = todayDate;
        insert testPriorityRef;
            
        Test.startTest();
        	String top = UNILAB_TCB_Form.populateInitialTCBTOPPriorities(testAcc.Id, testAcc.Account_Group__c, testEvent.Id);
        Test.stopTest();
        
        System.assert(String.isNotEmpty(top));
    }
    
    @isTest
    private static void fetchVisibilityData() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
        acc.Account_Group__c = 'MDC';
     	insert acc;
            
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        insert testEvent;
        
        Activity_Junction__c aj = new Activity_Junction__c();
        aj.Event_Id__c = testEvent.Id;
        aj.Related_to_Account__c = acc.Id;
        insert aj;
        
        testEvent.Activity_Junction__c = aj.Id;
        update testEvent;
        
        TCB_Activity__c tac = new TCB_Activity__c();
        tac.Account__c = acc.Id;
        tac.Category__c = 'Test Cat';
        insert tac;
        
        Test.startTest();
        List<TCB_Activity__c> listTCR = UNILAB_TCB_Form.fetchVisibilityData(acc.Id, 'Test Cat', testEvent.Id);
        Test.stopTest();
        
        System.assertEquals(0, listTCR.size());
    }
    
    @isTest
    private static void fetchAssortData() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
        acc.Account_Group__c = 'MDC';
     	insert acc;
            
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        insert testEvent;
        
        Activity_Junction__c aj = new Activity_Junction__c();
        aj.Event_Id__c = testEvent.Id;
        aj.Related_to_Account__c = acc.Id;
        insert aj;
        
        testEvent.Activity_Junction__c = aj.Id;
        update testEvent;
        
        TCB_Activity__c tac = new TCB_Activity__c();
        tac.Account__c = acc.Id;
        tac.Category__c = 'Test Cat';
        insert tac;
        
        Test.startTest();
        List<TCB_Activity__c> listTCR = UNILAB_TCB_Form.fetchAssortData(acc.Id, 'Test Cat', testEvent.Id);
        Test.stopTest();
        
        System.assertEquals(0, listTCR.size());
    }
    
    @isTest
    private static void fetchTOPPrioritiesData() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
        acc.Account_Group__c = 'MDC';
     	insert acc;
            
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        insert testEvent;
        
        Activity_Junction__c aj = new Activity_Junction__c();
        aj.Event_Id__c = testEvent.Id;
        aj.Related_to_Account__c = acc.Id;
        insert aj;
        
        testEvent.Activity_Junction__c = aj.Id;
        update testEvent;
        
        TCB_Activity__c tac = new TCB_Activity__c();
        tac.Account__c = acc.Id;
        tac.Category__c = 'Test Cat';
        insert tac;
        
        Test.startTest();
        List<TCB_Activity__c> listTCR = UNILAB_TCB_Form.fetchTOPPrioritiesData(acc.Id, 'Test Cat', testEvent.Id);
        Test.stopTest();
        
        System.assertEquals(0, listTCR.size());
    }
    
    @isTest
    private static void fetchTAFT() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
        acc.Account_Group__c = 'MDC';
     	insert acc;
        
        TAFT__c taft = new TAFT__c();
        taft.Account__c = acc.Id;
        insert taft;
        
        Test.startTest();
        List<TAFT__c> listTCR = UNILAB_TCB_Form.fetchTAFT(acc.Id);
        Test.stopTest();
        
        System.assert(listTCR.size()>0);
    }
    
    @isTest
    private static void fetchPrevJournal() {
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
        String result = UNILAB_TCB_Form.fetchPrevJournal(acc.Id, 'Test Cat');
        Test.stopTest();
        
        System.assertEquals('Test Remarks', result);
    }
    
    @isTest
    private static void saveJournal() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
        acc.Account_Group__c = 'MDC';
     	insert acc;
        
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        insert testEvent;
        
        Activity_Junction__c aj = new Activity_Junction__c();
        aj.Event_Id__c = testEvent.Id;
        aj.Related_to_Account__c = acc.Id;
        insert aj;
        
        testEvent.Activity_Junction__c = aj.Id;
        update testEvent;
        
        String activityRecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('TCB Journal').getRecordTypeId();
        
        TCB_Activity__c tac = new TCB_Activity__c();
        tac.Account__c = acc.Id;
        tac.Category__c = 'Test Cat';
        tac.Remarks__c = 'Test Remarks';
        tac.RecordTypeId = activityRecordTypeId;
        insert tac;
        
        String journalBox = 'Test Journal Box';
        
        Sub_Activity__c subact = new Sub_Activity__c();
        subact.Activity_Junction__c = aj.Id;
        insert subact;
        
        Test.startTest();
        String result = UNILAB_TCB_Form.saveJournal(acc.Id, 'Test Cat', journalBox, testEvent.Id);
        Test.stopTest();
        
        System.assertNotEquals('', result);
    }
    
    @isTest
    private static void saveFiles() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
        acc.Account_Group__c = 'MDC';
     	insert acc;
        
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        insert testEvent;
        
        Activity_Junction__c aj = new Activity_Junction__c();
        aj.Event_Id__c = testEvent.Id;
        aj.Related_to_Account__c = acc.Id;
        insert aj;
        
        testEvent.Activity_Junction__c = aj.Id;
        update testEvent;
        
        String activityRecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('TCB Files').getRecordTypeId();
        
        TCB_Activity__c tac = new TCB_Activity__c();
        tac.Account__c = acc.Id;
        tac.Category__c = 'Test Cat';
        tac.Remarks__c = 'Test Remarks';
        tac.RecordTypeId = activityRecordTypeId;
        insert tac;
        
        String journalBox = 'Test Journal Box';
        
        Sub_Activity__c subact = new Sub_Activity__c();
        subact.Activity_Junction__c = aj.Id;
        insert subact;
        
        Test.startTest();
        String result = UNILAB_TCB_Form.saveFiles(acc.Id, 'Test Cat', testEvent.Id);
        Test.stopTest();
        
        System.assertNotEquals('', result);
    }
    
    @isTest
    private static void deleteTAFTRecord() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
        acc.Account_Group__c = 'MDC';
     	insert acc;
        
        TAFT__c taft = new TAFT__c();
        taft.Account__c = acc.Id;
        insert taft;
        
        Test.startTest();
        String response = UNILAB_TCB_Form.deleteTAFTRecord(acc.Id);
        Test.stopTest();
        
        System.assertEquals('Success', response);
    }
    
    @isTest
    private static void updateForm() {
        Account acc = new Account();
        //acc.RecordTypeId = '0127F000000pSdUQAU';
        acc.Name = 'acc1';
        acc.Bill_To_Code__c = '0080322195';
        acc.Account_Group__c = 'MDC';
     	insert acc;
        
        TAFT__c taft = new TAFT__c();
        taft.Account__c = acc.Id;
        insert taft;
        
        List<TCB_Activity__c> priorityData = new List<TCB_Activity__c>();
        TCB_Activity__c prData = new TCB_Activity__c();
        prData.Category__c = 'Soap';
        priorityData.add(prData);
        insert prData;
        
        Test.startTest();
        String response = UNILAB_TCB_Form.updateForm(priorityData, prData.Id);
        Test.stopTest();
        
        System.assertEquals('Success', response);
    }
}