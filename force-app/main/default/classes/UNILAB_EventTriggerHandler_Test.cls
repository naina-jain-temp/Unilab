/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   09.19.2017
Definition   :   UNILAB_EventTriggerHandler Test Class
History      :   09.19.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
@isTest 
private class UNILAB_EventTriggerHandler_Test {
    public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    
    //ON AFTER UPDATE METHOD
    @isTest static void createUpdateEvent_Test(){
        
        system.runAs(testUser1){
            Test.startTest();
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            //create account record
            Account testAccount1 = TestDataFactory.createSingleAccount('Test Name');
            testAccount1.Team__c = 'SM Group';
            testAccount1.Account_Group__c = '7-ELEVEN';
            testAccount1.Account_Status__c = 'Active';
            testAccount1.Bill_To_Code__c = '0001231112';
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
                                                                                  Event_Sub_Type__c = 'BRANCH CALL',
                                                                                  Channel__c = 'SALESOPS');
            insert actDependencyTest;
            //  system.Debug('actDependencyTest: '+actDependencyTest);
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
            
            List<Sub_Activity__c> subActivityList = new List<Sub_Activity__c>();
            Sub_Activity__c subActivity = new Sub_Activity__c();
            subActivity.Activity_Name__c = 'COMPETITIVE ACTIVITY';
            subActivityList.add(subActivity);
            Event event = UNILAB_ActivityManagementCX.getEventRecord(null).event; 
            event.Id = null;
            event.Event_Type__c ='Call';
            event.Event_Sub_type__c ='BRANCH CALL';
            event.Related_To_Account__c = testAccount1.Id;
            // event.Activity_Junction__c = 
            String strSobjects = JSON.Serialize(subActivityList);   
            //insert
            Id recordId = UNILAB_ActivityManagementCX.saveEventRecord(event,strSobjects,'remarks');
            
            UNILAB_ActivityManagementCX.EventRecord newEventRecord = UNILAB_ActivityManagementCX.getEventRecord(recordId);
            newEventRecord.event.Location_Custom__c = 'TEST';
            Event newEvent = [SELECT Id, Activity_Junction__c, Location_Custom__c FROM Event WHERE Id =: recordId
                             ];
            Id updatedRecordId = UNILAB_ActivityManagementCX.saveEventRecord(newEventRecord.event,JSON.Serialize(newEventRecord.subActivityList),'remarks');
            Test.stopTest();
            // system.Debug(insertedEvent);    
            
            Event updatedEvent = [SELECT Id, Activity_Junction__c, Location_Custom__c FROM Event WHERE Id =: updatedRecordId];
            
            System.assertEquals(recordId, updatedRecordId);
            System.assertNotEquals(newEvent.Location_Custom__c,updatedEvent.Location_Custom__c);
            System.assertEquals(newEvent.Activity_Junction__c, updatedEvent.Activity_Junction__c);
            
        }                
    }
    
    // ON BEFORE DELETE METHOD
    @isTest static void testOnBeforeDelete(){
        
        system.runAs(testUser1){
            Test.startTest();
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX();
            
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
                                                                                  Event_Sub_Type__c = 'BRANCH CALL',
                                                                                  Channel__c = 'SALESOPS');
            insert actDependencyTest;
            //create survey records
            List<Survey_Summary_Form__c> ssfList = TestDataFactory.createSurveySummaryForm(1, 'Questionnaire');
            ssfList[0].Assign_to_Account__c = testAccount1.Id;
            ssfList[0].Activity_Name__c = 'COMPETITIVE ACTIVITY';
            ssfList[0].Event_Sub_type__c = 'BRANCH CALL';
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
            
            List<Sub_Activity__c> subActivityList = new List<Sub_Activity__c>();
            Sub_Activity__c subActivity = new Sub_Activity__c();
            subActivity.Activity_Name__c = 'COMPETITIVE ACTIVITY';
            subActivityList.add(subActivity);
            Event event = UNILAB_ActivityManagementCX.getEventRecord(null).event; 
            event.Id = null;
            event.Event_Type__c ='Call';
            event.Event_Sub_type__c ='BRANCH CALL';
            event.Related_To_Account__c = testAccount1.Id;
            // event.Activity_Junction__c = 
            String strSobjects = JSON.Serialize(subActivityList);   
            //insert
            Id recordId = UNILAB_ActivityManagementCX.saveEventRecord(event,strSobjects,'remarks');
            
            
            Event newEvent = [SELECT Id, Activity_Junction__c, Location_Custom__c FROM Event WHERE Id =: recordId
                             ];
            
            try{
                
                delete newEvent;
            }catch (DMLException e){
                system.assert(e.getMessage().contains('You do not have access to delete an event.'));
            }
            
            Test.stopTest();
            
            
        }                
    }
    
    @isTest static void testSetSurveyEventEndDate(){
        
        system.runAs(testUser1){
            
            
        }                
        
    }
    /*
    @isTest static void groupChannelPost() {
        
        User channelHead;
        
        channelHead = TestTCRDataFactory.createUserChannelHead('POS-KA Channel Head','poskaCH@unilabtest.com','KA Channel Head');
        
        UserRole tlRole = [SELECT Id, Name FROM UserRole WHERE Name = 'POS-KA Team Lead (Watsons)'];
        Id profileTLID = [SELECT Id FROM Profile WHERE Name = 'KA Team Lead'].Id;
        
        User userTL = new User(LastName = 'Test TL',
                               FirstName ='FirstName TL',
                               Alias = 'tsTL',
                               Email = 'TLtest.sysad@unilab.com',
                               Username = 'TLtestUsername.sysad@unilab.com',
                               ProfileId = profileTLID,
                               TimeZoneSidKey = 'GMT',
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Channel__c = 'SALESOPS',
                               ManagerId = channelHead.Id,
                               UserRoleId = tlRole.Id);
        
      
        insert userTL;
        
        Event newEvent = new Event(Event_Type__c = 'Field Work',
                                   Event_Sub_type__c = 'Training Contact',
                                   Location_Custom__c = 'Pasig City',
                                   Location_Based__c = 'Home Base',
                                   Field_Work_Record_Type__c = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Account TCR').getRecordTypeId(),
                                   Work_With_ID__c = userTL.Id);
        
        Test.startTest();
   
        insert newEvent;
        
        Test.stopTest();
        
        //System.assert(newFieldWorkEventId != NULL);
        
        
    }
    */
    
}