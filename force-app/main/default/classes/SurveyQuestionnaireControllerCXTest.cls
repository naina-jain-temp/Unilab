// Author      : John Michael B. Mahaguay
// Created     : 06.08.2017
// Description : Test class for SurveyQuestionnaireControllerCX

@isTest
public class SurveyQuestionnaireControllerCXTest{
    @testSetup static void setup(){
        Set<String> accIdSet = new Set<String>();
        List<Account> accList = TestDataFactory.createAccount(1);
        insert accList;
        
        for(Account acc : accList){
            accIdSet.add(acc.Id);
        }
        
        List<Activity_Junction__c> ajList = TestDataFactory.createActivityJunction(1, accIdSet);
        insert ajList;
        
        List<Survey_Summary_Form__c> ssfList = TestDataFactory.createSurveySummaryForm(1, 'Questionnaire');
        insert ssfList;
        
        List<Sub_Activity__c> saList = new List<Sub_Activity__c>();
        for(Activity_Junction__c aj : ajList){
            for(Survey_Summary_Form__c ssf : ssfList){
                List<Sub_Activity__c> saListTemp = TestDataFactory.createSubActivtiy(1, ssf.Id, aj.Id);
                saList.addAll(saListTemp);
            }
        }
        insert saList;
        
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
    }
    
    
    
    @isTest static void testSurveyQuestionnaireControllerCX(){
        
        List<Survey_Summary_Form__c> ssfList = [SELECT Id , Name, Start_Date__c, End_Date__c, RecordTypeId
                                                FROM Survey_Summary_Form__c];
        
        List<Survey_Form__c> sfList = [SELECT Id, Survey_Summary_Form__c,Survey_Question__c,Product__c,RecordTypeId
                                       FROM Survey_Form__c];
        
        
        PageReference tpageRef = Page.SurveyQuestionnaire;
        Test.setCurrentPage(tpageRef);
        
        Apexpages.currentpage().getparameters().put('id' , ssfList[0].Id);
        SurveyQuestionnaireControllerCX sic = new SurveyQuestionnaireControllerCX();
        
        List<Survey_Form__c> updateSfList = new List<Survey_Form__c>();
        
        Test.startTest();
		sic.btnSave();
      	sic.sqWrapper = new List<SurveyQuestionnaireControllerCX.SurveyQuestionsWrapper>();
        //sic.btnSave();
        
        Test.stopTest();
        
    }
    
    @isTest static void testNegativeSurveyQuestionnaireControllerCX(){
         List<Survey_Summary_Form__c> ssfList = [SELECT Id , Name, Start_Date__c, End_Date__c, RecordTypeId
                                                FROM Survey_Summary_Form__c];
        
        List<Survey_Form__c> sfList = [SELECT Id, Survey_Summary_Form__c,Survey_Question__c,Product__c,RecordTypeId
                                       FROM Survey_Form__c];
        
        
        PageReference tpageRef = Page.SurveyQuestionnaire;
        Test.setCurrentPage(tpageRef);
        
        Apexpages.currentpage().getparameters().put('id' , ssfList[0].Id);
        SurveyQuestionnaireControllerCX sic = new SurveyQuestionnaireControllerCX();
        
        List<SurveyQuestionnaireControllerCX.SurveyQuestionsWrapper> updateSfList = new List<SurveyQuestionnaireControllerCX.SurveyQuestionsWrapper>();
       
        Test.startTest();
      	sic.sqWrapper = new List<SurveyQuestionnaireControllerCX.SurveyQuestionsWrapper>();
        
         try{
            sic.btnSave();
        }catch(DmlException dmle){
            for(ApexPages.Message msg :  ApexPages.getMessages()){
                System.assertEquals(dmle.getMessage(),msg.getSummary()); 
                System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());       
            }
        }   
        
        Test.stopTest();
     }
}