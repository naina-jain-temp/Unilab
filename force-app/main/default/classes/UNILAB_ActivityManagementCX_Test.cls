/*-------------------------------------------------------------------------------------------
Author       :   Katherine Claire Roberto, Manuelito Ortega
Created Date :   09.02.2018
Definition   :   UNILAB_ActivityManagementCX Test Class
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_ActivityManagementCX_Test {
    public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    
    
    @isTest static void savedAdminWorkEvent() {      
        system.runAs(testUser1){
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.StartDateTime = dateTime.now(); 
            testEvent.EndDateTime = dateTime.now();
            testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;         
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
            
            List<Survey_Summary_Form__c> ssfList = TestDataFactory.createSurveySummaryForm(1, 'Questionnaire');
            ssfList[0].Assign_to_Account__c = testAcc.Id;
            ssfList[0].Activity_Name__c = 'COMPETITIVE ACTIVITY';
            ssfList[0].Event_Sub_type__c = 'Branch Call';
            insert ssfList;
            
            List<Sub_Activity__c> subActs = new List<Sub_Activity__c>();
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
            subActivity.Survey_Summary_Form__c = ssfList[0].Id ;
            
            insert subActs;
            
            PageReference pageRef = Page.UNILAB_ActivityManagementPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',testEvent.Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(testEvent);
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX(sc);
            
            UNILAB_ActivityManagementCX.getRecordId();
            UNILAB_ActivityManagementCX.populateActJunc(testWorkPlan.EventRecord, 'Test');
            
            
            Event insertedEvent = [SELECT Id, Activity_Junction__c FROM Event WHERE Id =: testWorkPlan.eventRecord.Id];
            system.Assert(insertedEvent != null);
            List<Sub_Activity__c> subActList = [SELECT Id FROM Sub_Activity__c WHERE Activity_Junction__c =:insertedEvent.Activity_Junction__c]; 
            system.Assert(subActList != null);
            
            
            
        }          
    }
    
    @isTest static void closeButton(){
        Test.setCurrentPage(Page.UNILAB_ActivityManagementPage); 
        ApexPages.currentPage().getParameters().put('retURL','/lightning/page/home');
        
        system.runAs(testUser1){
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.StartDateTime = dateTime.now(); 
            testEvent.EndDateTime = dateTime.now();
            testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(testEvent);
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX(sc);
            
            Test.startTest();
            PageReference pageRef = testWorkPlan.closeButtonLightning();
            Test.stopTest();
            
            System.assert(pageRef.getUrl() == ApexPages.currentPage().getParameters().get('retURL'));
            
        }
    }
    
    @isTest static void testCreate_AdmiWork_WorkPlan(){
        
        system.runAs(testUser1){           
            Test.startTest();
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX();
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
            Test.stopTest();
            
            
            system.assert(recordId!=null,'Workplan creation error');
            
            
        }                
    }
    
    // INSERTED BY KC
    @isTest static void testCreate_BranchCall_WorkPlan(){
        
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
            event.WhoId = null;
            event.Related_To_Account__c = testAccount1.Id;
            String strSobjects = JSON.Serialize(subActivityList);   
            
            Id recordId = UNILAB_ActivityManagementCX.saveEventRecord(event,strSobjects,'remarks');
            System.debug('recordId>>>'+recordId);
            System.debug('TestAcctId>>>'+testAccount1.Id);
            
            Test.stopTest();
            
            
            system.assert(recordId!=null,'Workplan creation error');
            
            
        }                        
    }
    
    @isTest static void negativeTestSavedWorkplan(){
        
        system.runAs(testUser1){           
            Test.startTest();
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX();
            List<Sub_Activity__c> subActivityList = new List<Sub_Activity__c>();
            Sub_Activity__c subActivity = new Sub_Activity__c();
            subActivity.Activity_Name__c = 'AR RECON';
            subActivityList.add(subActivity);
            Event event = UNILAB_ActivityManagementCX.getEventRecord(null).event; 
            event.Id = null;
            event.Event_Type__c ='Admin Work';
            event.Event_Sub_type__c ='ADMIN WORK';
            String strSobjects = JSON.Serialize(subActivityList);   
            
            try{
                 Id recordId = UNILAB_ActivityManagementCX.saveEventRecord(event,strSobjects,'remarks');
            }catch(DmlException dmle){
                for(ApexPages.Message msg :  ApexPages.getMessages()){
                    System.assertEquals(dmle.getMessage(),msg.getSummary()); 
                    System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());       
                }
            }   
            
           
            Test.stopTest();         
        }                      
        
    }
    
    @isTest static void testUpdateWorkPlan(){
        
        system.runAs(testUser1){     
            
            Test.startTest();
            //Create Workplan
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX();
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
            //Update Workplan
            UNILAB_ActivityManagementCX.EventRecord newEventRecord = UNILAB_ActivityManagementCX.getEventRecord(recordId);
            String newSubActivity = JSON.serialize(newEventRecord.subActivityList);
            newEventRecord.event.Location_Custom__c = 'Pasig City';
            Id newEventId = UNILAB_ActivityManagementCX.saveEventRecord(newEventRecord.event,newSubActivity,newEventRecord.actJuncRemarks);
            
            //Get the updated Workplan
            UNILAB_ActivityManagementCX.EventRecord updatedEventRecord = UNILAB_ActivityManagementCX.getEventRecord(newEventId);
            Test.stopTest();
            
            system.assert(updatedEventRecord.event.Id!=null,'Update Workplan error');
            System.assertEquals('Pasig City', updatedEventRecord.event.Location_Custom__c,'Workplan location is not updated');
            
            
            
        }                       
    }
    
    @isTest static void testCompleteAdminWorkPlan(){
        
        system.runAs(testUser1){     
            
            Test.startTest();
            //Create Workplan
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX();
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
            //Update Workplan
            UNILAB_ActivityManagementCX.EventRecord newEventRecord = UNILAB_ActivityManagementCX.getEventRecord(recordId);
            String newSubActivity = JSON.serialize(newEventRecord.subActivityList);
            newEventRecord.event.Location_Custom__c = 'Pasig City';
            Id newEventId = UNILAB_ActivityManagementCX.completeEventRecord(newEventRecord.event,newSubActivity,newEventRecord.actJuncRemarks);
            
            //Get the updated Workplan
            UNILAB_ActivityManagementCX.EventRecord updatedEventRecord = UNILAB_ActivityManagementCX.getEventRecord(newEventId);
            Test.stopTest();
            
            system.assert(updatedEventRecord.event.Id!=null,'Complete Work Error');
            System.assertEquals('Completed', updatedEventRecord.event.Status__c,'Workplan status error');
            
            
            
        }                       
    }
    
    @isTest static void testCancelWorkPlan(){
        
        system.runAs(testUser1){     
            
            Test.startTest();
            //Create Workplan
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX();
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
            //Update Workplan
            UNILAB_ActivityManagementCX.EventRecord newEventRecord = UNILAB_ActivityManagementCX.getEventRecord(recordId);
            String newSubActivity = JSON.serialize(newEventRecord.subActivityList);
            newEventRecord.event.Location_Custom__c = 'Pasig City';
            Id newEventId = UNILAB_ActivityManagementCX.cancelEventRecord(newEventRecord.event,newSubActivity,newEventRecord.actJuncRemarks);
            
            //Get the updated Workplan
            UNILAB_ActivityManagementCX.EventRecord updatedEventRecord = UNILAB_ActivityManagementCX.getEventRecord(newEventId);
            Test.stopTest();
            
            system.assert(updatedEventRecord.event.Id!=null,'Cancel Error');
            
            
            
        }                       
    }
    
    @isTest static void testNewTaskWorkPlan(){
        
        system.runAs(testUser1){     
            
            Test.startTest();
            //Create Workplan
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX();
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
            //Update Workplan
            UNILAB_ActivityManagementCX.EventRecord newEventRecord = UNILAB_ActivityManagementCX.getEventRecord(recordId);
            String newSubActivity = JSON.serialize(newEventRecord.subActivityList);
            newEventRecord.event.Location_Custom__c = 'Pasig City';
            Id newEventId = UNILAB_ActivityManagementCX.saveAndNewTask(newEventRecord.event,newSubActivity,newEventRecord.actJuncRemarks);
            
            //Get the updated Workplan
            UNILAB_ActivityManagementCX.EventRecord updatedEventRecord = UNILAB_ActivityManagementCX.getEventRecord(newEventId);
            Test.stopTest();
            
            system.assert(updatedEventRecord.event.Id!=null,'New Task Error');
            
            
            
        }                       
    }
    
    @isTest static void testCloneWorkPlan(){
        
        system.runAs(testUser1){     
            
            Test.startTest();
            //Create Workplan
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX();
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
            //Update Workplan
            UNILAB_ActivityManagementCX.EventRecord newEventRecord = UNILAB_ActivityManagementCX.getEventRecord(recordId);
            String newSubActivity = JSON.serialize(newEventRecord.subActivityList);
            newEventRecord.event.Location_Custom__c = 'Pasig City';
            Id clonedEventId = UNILAB_ActivityManagementCX.cloneEventRecord(newEventRecord.event,newSubActivity,newEventRecord.actJuncRemarks);
            
            Test.stopTest();
            
            system.assert(clonedEventId!=null,'Clone Event Error');
            System.assert(recordId!= clonedEventId,'Clone Event Error');
            
            
            
            
        }                       
    }
    
    @isTest static void positiveTestCompleteStatus(){
        
        system.runAs(testUser1){
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.StartDateTime = date.today().addDays(3); 
            testEvent.EndDateTime = date.today().addDays(+3);
            testEvent.Created_from_Classic__c = true;
            testEvent.Event_Type__c = 'Call';
            testEvent.Status__c = 'Completed';
            insert testEvent;
            
            Test.setCurrentPage(Page.UNILAB_ActivityManagementPage); 
            ApexPages.currentPage().getParameters().put('retURL','/'+String.valueOf(testEvent.Id));
            
            ApexPages.StandardController sc = new ApexPages.StandardController(testEvent);
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX(sc);
            
            //    testWorkPlan.eventRecord = testEvent;
            //    testWorkPlan.isCompleteWholeEvent = true;
            testWorkPLan.actJuncRemarks = '';
            
            Test.startTest();
            //    PageReference pageRef = testWorkPlan.completeStatus();
            //   pageRef = testWorkPlan.saveAndNewTask();
            Test.stopTest();
            
            PageReference expectedPageRef = new PageReference('/' + testWorkPlan.eventRecord.Id);
            //  System.assertEquals(expectedPageRef.getUrl(),pageRef.getUrl());
            
            
        } 
    }
    
    @isTest static void negativeCompleteStatus(){
        system.runAs(testUser1){
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.StartDateTime = date.today().addDays(3); 
            testEvent.EndDateTime = date.today().addDays(+3);
            testEvent.Created_from_Classic__c = true;
            testEvent.Event_Type__c = 'Call';
            testEvent.Status__c = 'Completed';
            insert testEvent;
            
            Test.setCurrentPage(Page.UNILAB_ActivityManagementPage); 
            ApexPages.currentPage().getParameters().put('retURL','/'+String.valueOf(testEvent.Id));
            
            ApexPages.StandardController sc = new ApexPages.StandardController(testEvent);
            UNILAB_ActivityManagementCX testWorkPlan = new UNILAB_ActivityManagementCX(sc);
            
            //  testWorkPlan.isCompleteWholeEvent = false;
            testWorkPlan.actJuncRemarks = '';
            testWorkPlan.eventRecord = testEvent;
            
            Test.startTest();
            //  PageReference pageRef = testWorkPlan.completeStatus();       
            //  pageRef = testWorkPlan.saveAndNewTask();
            Test.stopTest();
            
            ApexPages.Message[] errorMessage = ApexPages.getMessages();
            //   System.assertEquals('Required Field: Remarks/Analysis/Insights', errorMessage.get(0).getSummary());
            //   System.assertEquals(ApexPages.Severity.ERROR, errorMessage.get(0).getSeverity());    
            
        }
        
        
    }
    
    @isTest static void DeleteSubActivity() {      
        system.runAs(testUser1){
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //create event
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
            testEvent.StartDateTime = dateTime.now(); 
            testEvent.EndDateTime = dateTime.now();
            testEvent.Created_from_Classic__c = true;
            insert testEvent;
            
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;         
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
            
            List<Survey_Summary_Form__c> ssfList = TestDataFactory.createSurveySummaryForm(1, 'Questionnaire');
            ssfList[0].Assign_to_Account__c = testAcc.Id;
            ssfList[0].Activity_Name__c = 'COMPETITIVE ACTIVITY';
            ssfList[0].Event_Sub_type__c = 'Branch Call';
            insert ssfList;
            
            List<Sub_Activity__c> subActs = new List<Sub_Activity__c>();
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
            subActivity.Survey_Summary_Form__c = ssfList[0].Id ;
            
            subActs.add(subActivity);
            
            insert subActs;
            
            Test.startTest();
            
            UNILAB_ActivityManagementCX.deleteSubActivity(subActs[0].Id);
            
            Test.stopTest();
            
            List<Sub_Activity__c> deletedSubActivity = [SELECT Id
                                                        FROM Sub_Activity__c
                                                       ];
            
            System.assert(deletedSubActivity.size() == 0);
            
        }          
    }
    
    //Wrapper Class
    
    
}