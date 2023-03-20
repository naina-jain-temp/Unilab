/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.20.2017
Definition   :   Test class for UNILAB_SubActivityListCX
History      :   07.20.2017 - Kiko Roberto:  Created
Modified by  : 	 KC Roberto - 08.22.2018
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_SubActivityListCXTest{
    
    @testSetup static void setup(){
        Event testEvent = new Event(Subject = 'Test',
                                    StartDateTime = dateTime.now(),
                                    EndDateTime = dateTime.now(),
                                    Created_from_Classic__c = true);
        insert testEvent;
        
        
        Set<String> accIdSet = new Set<String>();
        List<Account> accList = TestDataFactory.createAccount(1);
        insert accList;
        
        for(Account acc : accList){
            accIdSet.add(acc.Id);
        }
        
        List<Activity_Junction__c> ajList = TestDataFactory.createActivityJunction(1, accIdSet);
        insert ajList;
        
        testEvent.Activity_Junction__c = ajList[0].Id;
        
        update testEvent;
        
        List<Survey_Summary_Form__c> ssfList = TestDataFactory.createSurveySummaryForm(1, 'Questionnaire');
        insert ssfList;
        
        List<Survey_Question_Choices__c> qList = new List<Survey_Question_Choices__c>();
        Survey_Question_Choices__c q1 = TestDataFactory.createQuestions('Checkbox (Yes/No)', 'Yes;No');
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
        
        List<Sub_Activity__c> saList = new List<Sub_Activity__c>();
        for(Activity_Junction__c aj : ajList){
            for(Survey_Summary_Form__c ssf : ssfList){
                List<Sub_Activity__c> saListTemp = TestDataFactory.createSubActivtiy(1, ssf.Id, aj.Id);
                saList.addAll(saListTemp);
            }
        }
        insert saList;
        
        
        
    }

    //SCENARIO : Successfully SubActivityList
    public static testMethod void UNILAB_SubActivityListCXTest(){
        
        Event testEvent = [SELECT Id,Subject,StartDateTime,EndDateTime
                                 FROM Event
                                 WHERE Subject = 'Test'];
 
        ApexPages.StandardController sc = new ApexPages.StandardController(testEvent);	
        
        Test.startTest();  	
            UNILAB_SubActivityListCX cont = new UNILAB_SubActivityListCX(sc);
        Test.stopTest();
        
        List <Sub_Activity__c> insertedActivity = [SELECT Id, Name, Survey_Summary_Form__c
                                                   FROM Sub_Activity__c] ;
        
        for (integer i = 0; i<cont.subActMasterList.size();i++){
             System.assertEquals(cont.subActMasterList[i].Name, insertedActivity[i].Name);
             System.assertEquals(cont.subActMasterList[i].Survey_Summary_Form__c, insertedActivity[i].Survey_Summary_Form__c);
        }
        
    }
}