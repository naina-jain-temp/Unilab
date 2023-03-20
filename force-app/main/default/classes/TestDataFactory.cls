//   Author      : John Michael Mahaguay
//   Created     : 06.07.2017
//   Desription  : Test Data Factory for test classes

public with sharing class TestDataFactory{
    public static List<Account> createAccount(Integer cnt){
        List<Account> accList = new List<Account>();
        for(Integer x=0; x<cnt; x++){
            Account acc = new Account();
            acc.Name = 'Account '+x;
            acc.Team__c = 'SM Group';
            acc.Account_Group__c = '7-ELEVEN';
            acc.Account_Status__c = 'Active';
            acc.Bill_To_Code__c = '0001231111';
            acc.Ship_To_Code__c = '22345300';
            acc.Data_Source__c = 'SAP';
            acc.Ship_To_Name__c = 'ShipTo'+x;
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch/Single Accounts').getRecordTypeId();
            accList.add(acc);
        }
        return accList;
    }
    
    public static List<Activity_Junction__c> createActivityJunction(Integer cnt, Set<String> accIdSet){
        List<Activity_Junction__c> ajList = new List<Activity_Junction__c>();
        Integer ctr = 0;
        for(Integer x=0; x<cnt; x++){
            for(String accId : accIdSet){
                ctr++;
                Activity_Junction__c aj= new Activity_Junction__c();
                aj.Name = 'AJ '+ctr;
                aj.Related_to_Account__c = accId;
                ajList.add(aj);
            }
        }
        return ajList;
    }
    
    public static List<Survey_Summary_Form__c> createSurveySummaryForm(Integer cnt, String recordType){
        List<Survey_Summary_Form__c> ssfList = new List<Survey_Summary_Form__c>();
        for(Integer x=0; x<cnt; x++){
            Survey_Summary_Form__c ssf = new Survey_Summary_Form__c();
            ssf.Name = 'SSF '+x;
            ssf.Start_Date__c = date.Today().addDays(-3);
            ssf.End_Date__c = date.Today().addDays(3);
            ssf.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
            ssfList.add(ssf);
        }
        return ssfList;
    }
    
    public static List<Sub_Activity__c> createSubActivtiy(Integer cnt, Id ssfId, Id ajId){
        List<Sub_Activity__c> saList = new List<Sub_Activity__c>();
        for(Integer x=0; x<cnt; x++){
            Sub_Activity__c sa = new Sub_Activity__c();
            sa.Activity_Junction__c = ajId;
            sa.Survey_Summary_Form__c = ssfId;
            saList.add(sa);
        }
        return saList;
    }
    
    public static List<Product2> createProducts(Integer cnt){
        List<Product2> prodList = new List<Product2>();
        for(Integer x=0; x<cnt; x++){
            Product2 prod = new Product2();
            prod.Name = 'Product '+x;
            prod.IsActive = true;
            prodList.add(prod);
        }
        return prodList;
    }
    
    public static Survey_Question_Choices__c createQuestions(String qType, String pickListVal){
        Survey_Question_Choices__c q = new Survey_Question_Choices__c();
        q.Name = 'Question '+qType;
        q.Picklist_Values__c = pickListVal;
        q.Type_of_Question__c = qType;
        return q;
    }
    
    public static Survey_Form__c createSurveyForm(Integer cnt, Id ssfId, Id prodId, Id questionId, String recordType){
        Survey_Form__c sf = new Survey_Form__c();
        sf.Survey_Summary_Form__c = ssfId;
        sf.Survey_Question__c = questionId;
        sf.Product__c = prodId;
        sf.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        return sf;
    }
    
    
    public static User createUserAdmin() {
        
        Id sysAdId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;

        return new User(LastName = 'Test System Admin',
                        Alias = 'tsysad',
                        Email = 'test.sysad@unilabtest.com',
                        Username = 'test.sysad@unilabtest.com',
                        ProfileId = sysAdId,
                        TimeZoneSidKey = 'GMT',
                        LanguageLocaleKey = 'en_US',
                        EmailEncodingKey = 'UTF-8',
                        LocaleSidKey = 'en_US',
                        Channel__c = 'SALESOPS');
    }

    public static User createUserTL() {
        
        Id tlId = [SELECT Id FROM Profile WHERE Name = 'POS Team Lead'].Id;
        
        return new User(LastName = 'Test Team Leader',
                        Alias = 'tsysad',
                        Email = 'test.sysad@unilabtest.com',
                        Username = 'test.sysad@unilabtest.com',
                        ProfileId = tlId,
                        TimeZoneSidKey = 'GMT',
                        LanguageLocaleKey = 'en_US',
                        EmailEncodingKey = 'UTF-8',
                        LocaleSidKey = 'en_US',
                        Channel__c = 'SALESOPS');
    }
    
    
    public static User createUserCDS() {
        
        Id cdsId = [SELECT Id FROM Profile WHERE Name = 'POS CDS'].Id;
        
        return new User(LastName = 'Test CDS',
                        Alias = 'tsysad',
                        Email = 'test.sysad@unilabtest.com',
                        Username = 'test.sysad@unilabtest.com',
                        ProfileId = cdsId,
                        TimeZoneSidKey = 'GMT',
                        LanguageLocaleKey = 'en_US',
                        EmailEncodingKey = 'UTF-8',
                        LocaleSidKey = 'en_US',
                        Channel__c = 'SALESOPS');
    }
    
    
    public static List<Event> createBulkEvent(Integer count){
        List<Event> eventList = new List<Event>();
        
        for(Integer x=0; x<count; x++){
            eventList.add(new Event(Event_Type__c = 'Admin Work',
                                    Event_Sub_Type__c = 'ADMIN WORK',
                                    Location_Based__c = 'Out of Home Base'
                                    ));
        }
        return eventList;
    }
    
    /*-------------------------------------------------------------------------------------------
    Author       :   Kimiko Roberto
    Created Date :   05.05.2017
    Definition   :   returns single account record
    History      :   05.05.2017 - Kiko Roberto:  Created
    -------------------------------------------------------------------------------------------*/
    public static Account createSingleAccount(String acctName) {
        
        return new Account(Name = acctName,
        				   Team__c = 'GMA', 
                           Account_Group__c = '7-ELEVEN',
                           Account_Status__c = 'Active',
                           Bill_To_Code__c = '3435355512',
                           Ship_To_Code__c = '75776844',
                           Data_Source__c = 'SAP',
                           RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch/Single Accounts').getRecordTypeId());
    }
    
    public static void createParentSummaryForm(){
        Survey_Summary_Form__c surveySummaryForm = new Survey_Summary_Form__c();    
        surveySummaryForm.Name = 'Parent SSF1 - Questionnaire';
        surveySummaryForm.Start_Date__c = date.Today().addDays(-3);
        surveySummaryForm.End_Date__c = date.Today().addDays(3);
        surveySummaryForm.Parent_SSF__c = null;
        surveySummaryForm.Event_Sub_type__c = 'Branch Call';
        surveySummaryForm.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        surveySummaryForm.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Questionnaire').getRecordTypeId(); 
        surveySummaryForm.Team__c = 'GMA'; 
        
        insert surveySummaryForm;
    }
    
    public static Survey_Summary_Form__c getParentSummaryId(){
        return [SELECT Id FROM Survey_Summary_Form__c
                WHERE Parent_SSF__c = null];
    }
    
    public static void createChildSummaryForm(Id parentId){
        Survey_Summary_Form__c surveySummaryForm = new Survey_Summary_Form__c();    

        surveySummaryForm.Name = 'SSF1 - Questionnaire';
        surveySummaryForm.Start_Date__c = date.Today().addDays(-3);
        surveySummaryForm.End_Date__c = date.Today().addDays(3);
        surveySummaryForm.Parent_SSF__c = parentId;
        surveySummaryForm.Event_Sub_type__c = 'Branch Call';
        surveySummaryForm.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        surveySummaryForm.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Questionnaire').getRecordTypeId(); 
        surveySummaryForm.Team__c = 'GMA';
        
        insert surveySummaryForm;
    }
    
    public static Survey_Summary_Form__c getChildSummaryId(Id parentId){
        return [SELECT Id FROM Survey_Summary_Form__c
                WHERE Parent_SSF__c =: parentId];
    }
    
    
    
    public static void createAccount(){
        Account acc = new Account();
            acc.Name = 'Account';
            acc.Team__c = 'SM Group';
            acc.Account_Group__c = '7-ELEVEN';
            acc.Account_Status__c = 'Active';
            acc.Bill_To_Code__c = '0001231111';
            acc.Ship_To_Code__c = '22345300';
            acc.Data_Source__c = 'SAP';
            acc.Ship_To_Name__c = 'ShipTo';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch/Single Accounts').getRecordTypeId();
        
        insert acc;
    }
    
    public static Account getAccount(){
        return [SELECT Id FROM Account];
    }
    
    public static void createActJunction(Id accId){
        Activity_Junction__c aj= new Activity_Junction__c();
        aj.Name = 'AJ ';
        aj.Related_to_Account__c = accId;
        aj.Start_Date__c = date.today().addDays(-3);
        aj.End_Date__c = date.today().addDays(3);
        
        insert aj;
    }
    
    public static Activity_Junction__c getActJuntionId(){
        return [SELECT Id FROM Activity_Junction__c];
    }
    
    public static void createEvent(){
        
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        testEvent.Created_from_Classic__c = true;
        insert testEvent;
    }
    
    public static Event getEvent(){
        return [SELECT Id, Activity_Junction__c FROM Event];
    }
    
    public static void createSubAct(Id actId, Id ssfId){
        
        Sub_Activity__c subActivity = new Sub_Activity__c(); 
        subActivity.Activity_Junction__c = actId;
        subActivity.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subActivity.Survey_Summary_Form__c = ssfId;
        //subActivity.Activity_Junction__r.End_Date__c = date.today().addDays(3);
        
        insert subActivity;
    }
    

    
    
}