@isTest
private class UNILAB_CompetitiveActivity_Export_Test {
    
    @testSetup static void setup() {
        
        Trigger_Switch__c tafAfterInsert = new Trigger_Switch__c(Name = 'TAF_AfterInsert_RecordNotification',
                                                                 Is_Active__c = true
                                                                );
        
        insert tafAfterInsert;
        
        Trigger_Switch__c tafAfterUpdate = new Trigger_Switch__c(Name = 'TAF_AfterUpdate_RecordNotification',
                                                                 Is_Active__c = true
                                                                );
        
        insert tafAfterUpdate;
        
        CollaborationGroup testCollaborationGroup = new CollaborationGroup(Name = 'TAF-Chatter Group',
                                                                           CollaborationType = 'Private'
                                                                          );
        
        insert testCollaborationGroup;
        
    }
    
    @isTest
    private static void getDependentOptionsImplTest(){
        test.startTest();
        Map<String,List<String>> valueMap = UNILAB_CompetitiveActivity_Export.getPicklistDependency('Competitive_Activity__c', 'Division__c', 'Brand__c');
        test.stopTest();
    }
    
    @isTest
    private static void getDependentOptionsImplTest1(){
        test.startTest();
        Map<String,List<String>> valueMap = UNILAB_CompetitiveActivity_Export.getPicklistDependency(null, null, null);
        test.stopTest();
    }
    
    @isTest
    private static void getPicklistFields_Test(){
        test.startTest();
        UNILAB_CompetitiveActivity_Export.getPicklistFields('Competitive_Activity__c', 'Channel__c');
        test.stopTest();
    }
    
    @isTest
    private static void getDateYear_Test(){
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra'
                                                                          );
        
        insert compActivity;
        
        test.startTest();
        List<String> results = UNILAB_CompetitiveActivity_Export.getDateYear();
        test.stopTest();
        
        System.assert(results.size() > 0);
    }
    
    @isTest
    private static void getCompetitiveActivity_TestDateRangeDateField(){
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra'
                                                                          );
        
        insert compActivity;
        
        Competitive_Activity__c cpResults = [SELECT Id FROM Competitive_Activity__c LIMIT 1];

        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink cdLink = new ContentDocumentLink(ContentDocumentId = documents[0].Id,
                                                             LinkedEntityId  = cpResults.Id,
                                                             ShareType  = 'V');
        
        insert cdLink;
        
        UNILAB_CompetitiveActivity_Export.FilterParameters fParam = new UNILAB_CompetitiveActivity_Export.FilterParameters();
        fParam.filterDateBySelected = 'dateRangeByDateField';
        fParam.startDate = '2019-09-02';
        fParam.endDate = '2019-09-05';
        fParam.monthDate = 0;
        fParam.yearDate = 2019;
        
        String filterParam = JSON.serialize(fParam);
        
        test.startTest();
        UNILAB_CompetitiveActivity_Export.getCompetitiveActivity(filterParam);
        test.stopTest();
    }
    
    @isTest
    private static void getCompetitiveActivity_TestDateRangeDateImplementedField(){
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date_Implemented__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra'
                                                                          );
        
        insert compActivity;
        
        Competitive_Activity__c cpResults = [SELECT Id FROM Competitive_Activity__c LIMIT 1];

        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink cdLink = new ContentDocumentLink(ContentDocumentId = documents[0].Id,
                                                             LinkedEntityId  = cpResults.Id,
                                                             ShareType  = 'V');
        
        insert cdLink;
        
        UNILAB_CompetitiveActivity_Export.FilterParameters fParam = new UNILAB_CompetitiveActivity_Export.FilterParameters();
        fParam.filterDateBySelected = 'dateRangeByDateImplementedField';
        fParam.startDate = '2019-09-02';
        fParam.endDate = '2019-09-05';
        fParam.monthDate = 0;
        fParam.yearDate = 2019;
        
        String filterParam = JSON.serialize(fParam);
        
        test.startTest();
        UNILAB_CompetitiveActivity_Export.getCompetitiveActivity(filterParam);
        test.stopTest();
    }
    
    @isTest
    private static void getCompetitiveActivity_TestAllMonthYear(){
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra'
                                                                          );
        
        insert compActivity;
        
        UNILAB_CompetitiveActivity_Export.FilterParameters fParam = new UNILAB_CompetitiveActivity_Export.FilterParameters();
        fParam.filterDateBySelected = 'monthAndYear';
        fParam.startDate = '2019-09-02';
        fParam.endDate = '2019-09-05';
        fParam.monthDate = 0;
        fParam.yearDate = 2019;
        
        String filterParam = JSON.serialize(fParam);
        
        test.startTest();
        UNILAB_CompetitiveActivity_Export.getCompetitiveActivity(filterParam);
        test.stopTest();
    }
    
    @isTest
    private static void getCompetitiveActivity_TestMonthYear() {
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra'
                                                                          );
        
        insert compActivity;
        
        UNILAB_CompetitiveActivity_Export.FilterParameters fParam = new UNILAB_CompetitiveActivity_Export.FilterParameters();
        fParam.filterDateBySelected = 'monthAndYear';
        fParam.startDate = '2019-09-02';
        fParam.endDate = '2019-09-05';
        fParam.monthDate = 9;
        fParam.yearDate = 2019;
        
        String filterParam = JSON.serialize(fParam);
        
        test.startTest();
        UNILAB_CompetitiveActivity_Export.getCompetitiveActivity(filterParam);
        test.stopTest();
    }
    
    @isTest
    private static void getCompetitiveActivity_TestNullFilterDate(){
        UNILAB_CompetitiveActivity_Export.FilterParameters fParam = new UNILAB_CompetitiveActivity_Export.FilterParameters();
        fParam.filterDateBySelected = null;
        fParam.startDate = '2019-09-02';
        fParam.endDate = '2019-09-05';
        fParam.monthDate = 9;
        fParam.yearDate = 2019;
        
        String filterParam = JSON.serialize(fParam);
        
        
        test.startTest();
        UNILAB_CompetitiveActivity_Export.getCompetitiveActivity(filterParam);
        test.stopTest();
    }
    
    @isTest
    private static void getCompetitiveActivity_TestClass() {
        
        
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra'
                                                                          );
        
        insert compActivity;
        
        UNILAB_CompetitiveActivity_Export.FilterParameters fParam = new UNILAB_CompetitiveActivity_Export.FilterParameters();
        fParam.filterDateBySelected = 'monthAndYear';
        fParam.startDate = '2019-09-02';
        fParam.endDate = '2019-09-05';
        fParam.monthDate = 9;
        fParam.yearDate = 2019;
        
        List<String> compIDList = new List<String>();
        compIDList.add(compActivity.Id);
        
        String filterParam = UNILAB_CompetitiveActivity_Export.getCompetitiveActivity(JSON.serialize(fParam));
        List<UNILAB_CompetitiveActivity_Export.CompetitiveActivity> competitveActivityList = (List<UNILAB_CompetitiveActivity_Export.CompetitiveActivity>) JSON.deserialize(filterParam, List<UNILAB_CompetitiveActivity_Export.CompetitiveActivity>.class);
        
        test.startTest();
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(new Competitive_Activity__c());
        ApexPages.currentPage().getParameters().put('filterOptions', JSON.serialize(compIDList));
        
        UNILAB_CompetitiveActivity_Export ec = new UNILAB_CompetitiveActivity_Export(sc);
        
        test.stopTest();
    }
    
    @isTest
    private static void getCompetitiveActivity_TestClassNull() {
        
        
        Competitive_Activity__c compActivity = new Competitive_Activity__c(Date__c = Date.valueOf('2019-09-03'),
                                                                           Competitive_Type__c = 'Promotion',
                                                                           Competitive_Activity_Sub_Type__c = 'Loyalty Program',
                                                                           BU__c = 'PHG',
                                                                           Division__c = 'Biofemme',
                                                                           Brand__c = 'Alendra'
                                                                          );
        
        insert compActivity;

        test.startTest();
        
        String filterParam = UNILAB_CompetitiveActivity_Export.getCompetitiveActivity(null);
        test.stopTest();
    }
    
    @isTest
    private static void displayDataInVFPageNull() {
        
        List<String> competitiveIDList = new List<String>();
        
        Test.startTest();
        
        List<UNILAB_CompetitiveActivity_Export.CompetitiveActivity> competitiveActivityList =  UNILAB_CompetitiveActivity_Export.displayDataInVFPage(competitiveIDList);
        
        Test.stopTest();
        
        System.assert(competitiveActivityList == null);
        
    }

}