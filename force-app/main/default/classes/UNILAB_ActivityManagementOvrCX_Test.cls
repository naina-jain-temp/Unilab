/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   06.14.2017
Definition   :   UNILAB_ActivityManagementOvrCX Test Class
History      :   05.05.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_ActivityManagementOvrCX_Test {
    public static User testUser1;
    public static UserRole adminRole;
   static{
        //add your test data here using a test data factory
         
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;       

        /*List<Account> testAccountList = TestDataFactory.createBulkAccount('Test Name', 10);
        insert testAccountList;*/
    }

    @isTest static void createWorkPlan_Test(){
                
        system.runAs(testUser1){
            //create account record
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            Account testAccount1 = TestDataFactory.createSingleAccount('Test Name');
            testAccount1.Team__c = 'SM Group';
            testAccount1.Account_Group__c = '7-ELEVEN';
            testAccount1.Account_Status__c = 'Active';
            testAccount1.Bill_To_Code__c = '0001231190';
            testAccount1.Ship_To_Code__c = '22345300';
            testAccount1.Data_Source__c = 'SAP';
            testAccount1.Ship_To_Name__c = 'ShipTo';
            testAccount1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch/Single Accounts').getRecordTypeId();
            insert testAccount1;
            //create custom setting
            Activity_Dependency__c actDependencyTest = new Activity_Dependency__c(Name = '1',
                                                                              Role_ID__c = adminRole.Id,
                                                                              Role_Name__c = adminRole.Name,
                                                                              Activity_Name__c = 'COMPETITIVE ACTIVITY',
                                                                              Event_Sub_Type__c = 'Branch Call');
            insert actDependencyTest;
            //create survey records
            List<Survey_Summary_Form__c> ssfList = TestDataFactory.createSurveySummaryForm(1, 'Questionnaire');
            ssfList[0].Assign_to_Account__c = testAccount1.Id;
            ssfList[0].Activity_Name__c = 'COMPETITIVE ACTIVITY';
            ssfList[0].Event_Sub_type__c = 'Branch Call';
            insert ssfList;
            
            List<Survey_Question_Choices__c> qList = new List<Survey_Question_Choices__c>();
            Survey_Question_Choices__c q1 = TestDataFactory.createQuestions('Checkbox (Yes/No)', '');
            Survey_Question_Choices__c q2 = TestDataFactory.createQuestions('Picklist', 'Value1;Value2;Value3;');
            qList.add(q1);
            qList.add(q2);
            insert qList;
            
            List<Survey_Form__c> sfList = new List<Survey_Form__c>();
            for(Survey_Summary_Form__c ssf : ssfList){
                for(Survey_Question_Choices__c q : qList){
                    Survey_Form__c sf = TestDataFactory.createSurveyForm(1, ssf.Id, null, q.Id, 'Question');
                    sfList.add(sf);
                }
            }
            insert sfList;
            //create event
            Event eventTest = new Event();
            ApexPages.StandardController sc = new ApexPages.StandardController(eventTest);
            UNILAB_ActivityManagementOvrCX testWorkPlan = new UNILAB_ActivityManagementOvrCX(sc);
            
            testWorkPlan.startDate = String.valueOf(date.Today());
            testWorkPlan.startTime = '08:30';
            testWorkPlan.endDate = String.valueOf(date.Today().addDays(1));
            testWorkPlan.endTime = '16:00';
            testWorkPlan.eventRecord.Event_Type__c = 'Call';
            testWorkPlan.actJuncRemarks = 'Test';
            testWorkPlan.eventRecord.Event_Sub_type__c = 'Branch Call';
            testWorkPlan.eventRecord.Related_To_Account__c = testAccount1.Id;
            testWorkPlan.eventRecord.Location_Custom__c = 'test1';
            testWorkPlan.getActivityMatrixList();
            testWorkPlan.addRow();
            
            System.debug('>>>>>>>>>>>>>>>>>>>>>>' + testWorkPlan.subActivityList);
            testWorkPlan.subActivityList[0].Activity_Name__c = 'COMPETITIVE ACTIVITY';
            
            testWorkPlan.save();
            Event insertedEvent = [SELECT Id, Activity_Junction__c FROM Event WHERE Id =: testWorkPlan.eventRecord.Id];
            system.Assert(insertedEvent != null);
            List<Sub_Activity__c> subActList = [SELECT Id FROM Sub_Activity__c WHERE Activity_Junction__c =:insertedEvent.Activity_Junction__c];
            
            system.Assert(subActList != null);
            testWorkPlan.saveAndClone();
            testWorkPlan.cancel();
            testWorkPlan.getStartDate();
            testWorkPlan.getStartTime();
            testWorkPlan.getEndDate();
            testWorkPlan.getEndTime();
        }                
    }
}