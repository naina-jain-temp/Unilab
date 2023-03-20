@isTest
private class CompetitiveActivity_TriggerHandler_Test {
    
    @testSetup static void setup() {
        
        Trigger_Switch__c tafAfterInsert = new Trigger_Switch__c(Name = 'TAF_AfterInsert_RecordNotification',
                                                                 Is_Active__c = true
                                                                );
        
        insert tafAfterInsert;
        
        Trigger_Switch__c tafAfterUpdate = new Trigger_Switch__c(Name = 'TAF_AfterUpdate_RecordNotification',
                                                                 Is_Active__c = true
                                                                );
        
        insert tafAfterUpdate;
        
    }
    
    @isTest
    private static void completeFieldsAfterInsert() {
        
        Account newAccount = TestDataFactory.createSingleAccount('Test Account');
        
        insert newAccount;
        
        Contact newContact = new Contact(LastName = 'Last Name Contact',
                                         Role_Assignment__c = 'Owner',
                                         AccountId = newAccount.Id
                                        );
        
        insert newContact;
        
        CollaborationGroup testCollaborationGroup = new CollaborationGroup(Name = 'TAF-Chatter Group',
                                                                           CollaborationType = 'Private'
                                                                          );
        
        insert testCollaborationGroup;
        
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           Date_Implemented__c = Date.valueOf('2019-09-03'),
                                                                           Account__c = newAccount.Id,
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra',
                                                                           Description__c = 'Test Description',
                                                                           Contact__c = newContact.Id
                                                                          );
        
        Test.startTest();
        
        insert compActivity;
        
        Test.stopTest();
        
        List<Competitive_Activity__c> savedCompActList = [SELECT Date__c,
                                                          		 Competitive_Type__c,
                                                          		 Competitive_Activity_Sub_Type__c,
                                                          		 Date_Implemented__c,
                                                          		 Account__c,
                                                          		 BU__c,
                                                          		 Division__c,
                                                          		 Brand__c,
                                                          		 Description__c,
                                                          		 Contact__c,
                                                          		 Channel_Group__c,
                                                          		 Channel__c
                                                          FROM Competitive_Activity__c
                                                          LIMIT 1
                                                         ];
        
        List<FeedItem> feedItemList = [SELECT Id
                                       FROM FeedItem
                                      ];
        
        System.assert(compActivity != null);
        
        System.assertEquals(Date.valueOf('2019-09-03'), savedCompActList[0].Date__c);
        System.assertEquals('Promotion', savedCompActList[0].Competitive_Type__c);
        System.assertEquals('Loyalty Program', savedCompActList[0].Competitive_Activity_Sub_Type__c);
        System.assertEquals(Date.valueOf('2019-09-03'), savedCompActList[0].Date_Implemented__c);
        System.assertEquals(newAccount.Id, savedCompActList[0].Account__c);
        System.assertEquals('PHG', savedCompActList[0].BU__c);
        System.assertEquals('Biofemme', savedCompActList[0].Division__c);
        System.assertEquals('Alendra', savedCompActList[0].Brand__c);
        System.assertEquals('Test Description', savedCompActList[0].Description__c);
        System.assertEquals(newContact.Id, savedCompActList[0].Contact__c);
        
        System.assert(feedItemList.size() > 0);
        
    }
    
    @isTest
    private static void noFieldsUpdatedAfterUpdate() {
        
        Account newAccount = TestDataFactory.createSingleAccount('Test Account');
        
        insert newAccount;
        
        Contact newContact = new Contact(LastName = 'Last Name Contact',
                                         Role_Assignment__c = 'Owner',
                                         AccountId = newAccount.Id
                                        );
        
        insert newContact;
        
        CollaborationGroup testCollaborationGroup = new CollaborationGroup(Name = 'TAF-Chatter Group',
                                                                           CollaborationType = 'Private'
                                                                          );
        
        insert testCollaborationGroup;
        
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           Date_Implemented__c = Date.valueOf('2019-09-03'),
                                                                           Account__c = newAccount.Id,
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra',
                                                                           Description__c = 'Test Description',
                                                                           Contact__c = newContact.Id
                                                                          );
        
        insert compActivity;
        
        Test.startTest();
        
        update compActivity;
        
        Test.stopTest();
        
        List<Competitive_Activity__c> savedCompActList = [SELECT Date__c,
                                                          		 Competitive_Type__c,
                                                          		 Competitive_Activity_Sub_Type__c,
                                                          		 Date_Implemented__c,
                                                          		 Account__c,
                                                          		 BU__c,
                                                          		 Division__c,
                                                          		 Brand__c,
                                                          		 Description__c,
                                                          		 Contact__c,
                                                          		 Channel_Group__c,
                                                          		 Channel__c
                                                          FROM Competitive_Activity__c
                                                          LIMIT 1
                                                         ];
        
        List<FeedItem> feedItemList = [SELECT Id
                                       FROM FeedItem
                                      ];
        
        System.assert(compActivity != null);
        
        System.assertEquals(Date.valueOf('2019-09-03'), savedCompActList[0].Date__c);
        System.assertEquals('Promotion', savedCompActList[0].Competitive_Type__c);
        System.assertEquals('Loyalty Program', savedCompActList[0].Competitive_Activity_Sub_Type__c);
        System.assertEquals(Date.valueOf('2019-09-03'), savedCompActList[0].Date_Implemented__c);
        System.assertEquals(newAccount.Id, savedCompActList[0].Account__c);
        System.assertEquals('PHG', savedCompActList[0].BU__c);
        System.assertEquals('Biofemme', savedCompActList[0].Division__c);
        System.assertEquals('Alendra', savedCompActList[0].Brand__c);
        System.assertEquals('Test Description', savedCompActList[0].Description__c);
        System.assertEquals(newContact.Id, savedCompActList[0].Contact__c);
        
        System.assert(feedItemList.size() > 0);
        
    }
    
    @isTest
    private static void fieldsUpdatedAfterUpdate() {
        
        Account newAccount = TestDataFactory.createSingleAccount('Test Account');
        
        insert newAccount;
        
        Account newAccount1 = TestDataFactory.createSingleAccount('Test Account 1');
        
        insert newAccount1;
        
        Contact newContact = new Contact(LastName = 'Last Name Contact',
                                         Role_Assignment__c = 'Owner',
                                         AccountId = newAccount.Id
                                        );
        
        insert newContact;
        
        Contact newContact1 = new Contact(LastName = 'Last Name Contact 1',
                                         Role_Assignment__c = 'Owner',
                                         AccountId = newAccount.Id
                                        );
        
        insert newContact1;
        
        CollaborationGroup testCollaborationGroup = new CollaborationGroup(Name = 'TAF-Chatter Group',
                                                                           CollaborationType = 'Private'
                                                                          );
        
        insert testCollaborationGroup;
        
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           Date_Implemented__c = Date.valueOf('2019-09-03'),
                                                                           Account__c = newAccount.Id,
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra',
                                                                           Description__c = 'Test Description',
                                                                           Contact__c = newContact.Id
                                                                          );
        
        insert compActivity;
        
        compActivity.Date__c = Date.valueOf('2019-09-04');
        compActivity.Competitive_Type__c = 'Others';
        compActivity.Competitive_Activity_Sub_Type__c = 'Others';
        compActivity.Date_Implemented__c = Date.valueOf('2019-09-04');
        compActivity.Account__c = newAccount1.Id;
        compActivity.BU__c = 'Skin Science';
        compActivity.Division__c = 'UL Skin Sciences Inc';
        compActivity.Brand__c = 'Celeteque';
        compActivity.Description__c = 'Test Description 1';
        compActivity.Contact__c = newContact1.Id;
        
        Test.startTest();
        
        update compActivity;
        
        Test.stopTest();
        
        List<Competitive_Activity__c> savedCompActList = [SELECT Date__c,
                                                          		 Competitive_Type__c,
                                                          		 Competitive_Activity_Sub_Type__c,
                                                          		 Date_Implemented__c,
                                                          		 Account__c,
                                                          		 BU__c,
                                                          		 Division__c,
                                                          		 Brand__c,
                                                          		 Description__c,
                                                          		 Contact__c,
                                                          		 Channel_Group__c,
                                                          		 Channel__c
                                                          FROM Competitive_Activity__c
                                                          LIMIT 1
                                                         ];
        
        List<FeedItem> feedItemList = [SELECT Id
                                       FROM FeedItem
                                      ];
        
        System.assert(compActivity != null);
        
        System.assertEquals(Date.valueOf('2019-09-04'), savedCompActList[0].Date__c);
        System.assertEquals('Others', savedCompActList[0].Competitive_Type__c);
        System.assertEquals('Others', savedCompActList[0].Competitive_Activity_Sub_Type__c);
        System.assertEquals(Date.valueOf('2019-09-04'), savedCompActList[0].Date_Implemented__c);
        System.assertEquals(newAccount1.Id, savedCompActList[0].Account__c);
        System.assertEquals('Skin Science', savedCompActList[0].BU__c);
        System.assertEquals('UL Skin Sciences Inc', savedCompActList[0].Division__c);
        System.assertEquals('Celeteque', savedCompActList[0].Brand__c);
        System.assertEquals('Test Description 1', savedCompActList[0].Description__c);
        System.assertEquals(newContact1.Id, savedCompActList[0].Contact__c);
        
        System.assert(feedItemList.size() > 0);
        
    }
    
    @isTest
    private static void fieldsUpdatedAfterUpdateNull() {
        
        Account newAccount = TestDataFactory.createSingleAccount('Test Account');
        
        insert newAccount;
        
        Account newAccount1 = TestDataFactory.createSingleAccount('Test Account 1');
        
        insert newAccount1;
        
        Contact newContact = new Contact(LastName = 'Last Name Contact',
                                         Role_Assignment__c = 'Owner',
                                         AccountId = newAccount.Id
                                        );
        
        insert newContact;
        
        Contact newContact1 = new Contact(LastName = 'Last Name Contact 1',
                                         Role_Assignment__c = 'Owner',
                                         AccountId = newAccount.Id
                                        );
        
        insert newContact1;
        
        CollaborationGroup testCollaborationGroup = new CollaborationGroup(Name = 'TAF-Chatter Group',
                                                                           CollaborationType = 'Private'
                                                                          );
        
        insert testCollaborationGroup;
        
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           Date_Implemented__c = Date.valueOf('2019-09-03'),
                                                                           Account__c = newAccount.Id,
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra',
                                                                           Description__c = 'Test Description',
                                                                           Contact__c = newContact.Id
                                                                          );
        
        insert compActivity;
        
        compActivity.Date__c = null;
        compActivity.Competitive_Type__c = 'Others';
        compActivity.Competitive_Activity_Sub_Type__c = null;
        compActivity.Date_Implemented__c = null;
        compActivity.Account__c =null;
        compActivity.BU__c = null;
        compActivity.Division__c = null;
        compActivity.Brand__c = null;
        compActivity.Description__c = null;
        compActivity.Contact__c = null;
        
        Test.startTest();
        
        update compActivity;
        
        Test.stopTest();
        
        List<Competitive_Activity__c> savedCompActList = [SELECT Date__c,
                                                          		 Competitive_Type__c,
                                                          		 Competitive_Activity_Sub_Type__c,
                                                          		 Date_Implemented__c,
                                                          		 Account__c,
                                                          		 BU__c,
                                                          		 Division__c,
                                                          		 Brand__c,
                                                          		 Description__c,
                                                          		 Contact__c,
                                                          		 Channel_Group__c,
                                                          		 Channel__c
                                                          FROM Competitive_Activity__c
                                                          LIMIT 1
                                                         ];
        
        List<FeedItem> feedItemList = [SELECT Id
                                       FROM FeedItem
                                      ];
        
        System.assert(compActivity != null);
        
        System.assertEquals(null, savedCompActList[0].Date__c);
        System.assertEquals('Others', savedCompActList[0].Competitive_Type__c);
        System.assertEquals(null, savedCompActList[0].Competitive_Activity_Sub_Type__c);
        System.assertEquals(null, savedCompActList[0].Date_Implemented__c);
        System.assertEquals(null, savedCompActList[0].Account__c);
        System.assertEquals(null, savedCompActList[0].BU__c);
        System.assertEquals(null, savedCompActList[0].Division__c);
        System.assertEquals(null, savedCompActList[0].Brand__c);
        System.assertEquals(null, savedCompActList[0].Description__c);
        System.assertEquals(null, savedCompActList[0].Contact__c);
        
        System.assert(feedItemList.size() > 0);
        
    }
    
    @isTest
    private static void fieldsInsertAndUpdateNull() {
        
        Account newAccount = TestDataFactory.createSingleAccount('Test Account');
        
        insert newAccount;
        
        Account newAccount1 = TestDataFactory.createSingleAccount('Test Account 1');
        
        insert newAccount1;
        
        Contact newContact = new Contact(LastName = 'Last Name Contact',
                                         Role_Assignment__c = 'Owner',
                                         AccountId = newAccount.Id
                                        );
        
        insert newContact;
        
        Contact newContact1 = new Contact(LastName = 'Last Name Contact 1',
                                         Role_Assignment__c = 'Owner',
                                         AccountId = newAccount.Id
                                        );
        
        insert newContact1;
        
        CollaborationGroup testCollaborationGroup = new CollaborationGroup(Name = 'TAF-Chatter Group',
                                                                           CollaborationType = 'Private'
                                                                          );
        
        insert testCollaborationGroup;
        
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = null,
                                                                           Competitive_Type__c = 'Others',
                                                                           Competitive_Activity_Sub_Type__c = null,
                                                                           Date_Implemented__c = null,
                                                                           Account__c = null,
                                                                           BU__c = null,
                                                                           Division__c = null,
                                                                           Brand__c = null,
                                                                           Description__c = null,
                                                                           Contact__c = null
                                                                          );
        
        insert compActivity;
        
        compActivity.Date__c = null;
        compActivity.Competitive_Type__c = 'Others';
        compActivity.Competitive_Activity_Sub_Type__c = null;
        compActivity.Date_Implemented__c = null;
        compActivity.Account__c =null;
        compActivity.BU__c = null;
        compActivity.Division__c = null;
        compActivity.Brand__c = null;
        compActivity.Description__c = null;
        compActivity.Contact__c = null;
        
        Test.startTest();
        
        update compActivity;
        
        Test.stopTest();
        
        List<Competitive_Activity__c> savedCompActList = [SELECT Date__c,
                                                          		 Competitive_Type__c,
                                                          		 Competitive_Activity_Sub_Type__c,
                                                          		 Date_Implemented__c,
                                                          		 Account__c,
                                                          		 BU__c,
                                                          		 Division__c,
                                                          		 Brand__c,
                                                          		 Description__c,
                                                          		 Contact__c,
                                                          		 Channel_Group__c,
                                                          		 Channel__c
                                                          FROM Competitive_Activity__c
                                                          LIMIT 1
                                                         ];
        
        List<FeedItem> feedItemList = [SELECT Id
                                       FROM FeedItem
                                      ];
        
        System.assert(compActivity != null);
        
        System.assertEquals(null, savedCompActList[0].Date__c);
        System.assertEquals('Others', savedCompActList[0].Competitive_Type__c);
        System.assertEquals(null, savedCompActList[0].Competitive_Activity_Sub_Type__c);
        System.assertEquals(null, savedCompActList[0].Date_Implemented__c);
        System.assertEquals(null, savedCompActList[0].Account__c);
        System.assertEquals(null, savedCompActList[0].BU__c);
        System.assertEquals(null, savedCompActList[0].Division__c);
        System.assertEquals(null, savedCompActList[0].Brand__c);
        System.assertEquals(null, savedCompActList[0].Description__c);
        System.assertEquals(null, savedCompActList[0].Contact__c);
        
        System.assert(feedItemList.size() > 0);
        
    }
    
    @isTest
    private static void formattedChannelKA() {
        
        Test.startTest();
        
        String formattedChannelName = CompetitiveActivity_TriggerHandler.formattedChannel('Key Accounts');
        
        Test.stopTest();
        
        System.assert(String.isNotBlank(formattedChannelName));
        
    }
    
    @isTest
    private static void formattedChannelMDC() {
        
        Test.startTest();
        
        String formattedChannelName = CompetitiveActivity_TriggerHandler.formattedChannel('Mercury');
        
        Test.stopTest();
        
        System.assert(String.isNotBlank(formattedChannelName));
        
    }
    
    @isTest
    private static void formattedChannelGT() {
        
        Test.startTest();
        
        String formattedChannelName = CompetitiveActivity_TriggerHandler.formattedChannel('General Trade');
        
        Test.stopTest();
        
        System.assert(String.isNotBlank(formattedChannelName));
        
    }
    
    @isTest
    private static void formattedChannelMT() {
        
        Test.startTest();
        
        String formattedChannelName = CompetitiveActivity_TriggerHandler.formattedChannel('Modern Trade');
        
        Test.stopTest();
        
        System.assert(String.isNotBlank(formattedChannelName));
        
    }
    
    @isTest
    private static void noChatterGroup() {
        
        Test.startTest();
        
        Map<String, String> chatterGroupMap = CompetitiveActivity_TriggerHandler.getChatterGroup();
        
        Test.stopTest();
        
        System.assert(chatterGroupMap == null);
        
    }

}