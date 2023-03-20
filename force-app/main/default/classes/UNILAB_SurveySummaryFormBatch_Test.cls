/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   09.06.2017
Definition   :   UNILAB_SurveySummaryFormBatch Test Class
History      :   09.06.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_SurveySummaryFormBatch_Test {
    
    public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;       
        
        /*List<Account> testAccountList = TestDataFactory.createBulkAccount('Test Name', 10);
insert testAccountList;*/
    }
    
    @isTest static void runBatch_Test(){
        system.runAs(testUser1){
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.StartDateTime = dateTime.now(); 
            testEvent.EndDateTime = dateTime.now();
            testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            //create account record
            Account testAccount1 = TestDataFactory.createSingleAccount('Test Name');
            testAccount1.Team__c = 'SM Group';
            testAccount1.Account_Group__c = '7-ELEVEN';
            testAccount1.Account_Status__c = 'Active';
            testAccount1.Bill_To_Code__c = '0001231111';
            testAccount1.Ship_To_Code__c = '22345300';
            testAccount1.Data_Source__c = 'SAP';
            testAccount1.Ship_To_Name__c = 'ShipTo';
            testAccount1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch/Single Accounts').getRecordTypeId();
            insert testAccount1;
            
            //create activity junction
            List<Activity_Junction__c> actJuncList = new List<Activity_Junction__c>();
            for(Integer i = 0; i<5; i++){
                Activity_Junction__c aj = new Activity_Junction__c();
                aj.Start_Date__c = date.today().addDays(-3);
                aj.End_Date__c = date.today().addDays(3);
                aj.Event_Id__c = testEvent.Id;
                aj.Related_to_Account__c = testAccount1.Id;
                aj.Event_Sub_Type__c = 'Branch Call';
                actJuncList.add(aj);
            }
            
            insert actJuncList;
            
            //create custom setting
            Activity_Dependency__c actDependencyTest = new Activity_Dependency__c(Name = '1',
                                                                                  Role_ID__c = adminRole.Id,
                                                                                  Role_Name__c = adminRole.Name,
                                                                                  Activity_Name__c = 'COMPETITIVE ACTIVITY',
                                                                                  Event_Sub_Type__c = 'Branch Call');
            insert actDependencyTest;
            system.Debug('actDependencyTest: '+actDependencyTest);
            //create survey records
            List<Survey_Summary_Form__c> ssfList = TestDataFactory.createSurveySummaryForm(1, 'Questionnaire');
            ssfList[0].Assign_to_Account__c = testAccount1.Id;
            ssfList[0].Activity_Name__c = 'COMPETITIVE ACTIVITY';
            ssfList[0].Event_Sub_type__c = 'Branch Call';
            ssfList[0].isBatch__c = true;
            insert ssfList;
            system.Debug('ssfList: '+ssfList);
            
            List<Survey_Question_Choices__c> qList = new List<Survey_Question_Choices__c>();
            Survey_Question_Choices__c q1 = TestDataFactory.createQuestions('Checkbox (Yes/No)', '');
            Survey_Question_Choices__c q2 = TestDataFactory.createQuestions('Picklist', 'Value1;Value2;Value3;');
            qList.add(q1);
            qList.add(q2);
            insert qList;
            system.Debug('qList: '+qList);
            
            List<Survey_Form__c> sfList = new List<Survey_Form__c>();
            for(Survey_Summary_Form__c ssf : ssfList){
                for(Survey_Question_Choices__c q : qList){
                    Survey_Form__c sf = TestDataFactory.createSurveyForm(1, ssf.Id, null, q.Id, 'Question');
                    sfList.add(sf);
                }
            }
            insert sfList;
            
            List<Sub_Activity__c> subActivityList = new List<Sub_Activity__c>();
            Sub_Activity__c subActivity = new Sub_Activity__c();
            subActivity.Activity_Name__c = 'AR RECON';
            subActivityList.add(subActivity);
            Event event = UNILAB_ActivityManagementCX.getEventRecord(null).event; 
            event.Id = null;
            event.Event_Type__c ='Admin Work';
            event.Event_Sub_type__c ='ADMIN WORK';
            String strSobjects = JSON.Serialize(subActivityList);   
            
            Id recordId = UNILAB_ActivityManagementCX.saveEventRecord(event,strSobjects,'remarks');      
            UNILAB_SurveySummaryFormBatch b = new UNILAB_SurveySummaryFormBatch(); 
            b.start(null);
            b.execute(null, actJuncList);
            b.finish(null);
            
            
        }
    }
}