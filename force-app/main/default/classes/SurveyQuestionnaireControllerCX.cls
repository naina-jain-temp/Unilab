// Author: John Michael B. Mahaguay
// Company: Third Pillar
// Date Created: 05.30.2017

public with sharing class SurveyQuestionnaireControllerCX{
    
    public Sub_Activity__c sDetails{get;set;}
    public List<SurveyQuestionsWrapper> sqWrapper{get;set;}
    private Survey_Form__c sf = new Survey_Form__c();
     
    public SurveyQuestionnaireControllerCX(){
        sqWrapper = new List<SurveyQuestionsWrapper>();
        getSurveyDetails();
    }
    
    public void getSurveyDetails(){
        sqWrapper = new List<SurveyQuestionsWrapper>();
        sDetails = new Sub_Activity__c();
        sDetails = [SELECT Id, Account_ID__c, Survey_Summary_Form__r.Total_Weight__c, Survey_Summary_Form__r.Name,Survey_Summary_Form__r.Account__c, Survey_Summary_Form__r.Survey_Summary_Form_Name__c, Related_ContactId__c FROM Sub_Activity__c WHERE Survey_Summary_Form__c =: ApexPages.currentPage().getParameters().get('id') LIMIT 1]; // survey forms
        List<Survey_Form__c> questions = [SELECT Id, Survey_Summary_Form__c, Answer__c, Answered__c, Weight__c, Survey_Question__c, Survey_Question__r.Name, Survey_Question__r.Type_of_Question__c, Survey_Question__r.Picklist_Values__c FROM Survey_Form__c WHERE Survey_Summary_Form__c =: ApexPages.currentPage().getParameters().get('id') AND RecordType.Name = 'Question']; //survey questions
        SET<Id> qIds = new SET<Id>();

        for(Survey_Form__c sq : questions){
            qIds.add(sq.Id);
        }
        system.Debug('**questions:'+questions);
        if(!questions.isEmpty()){
        
            //system.assertequals(questions, null);
        
            for(Survey_Form__c sq : questions){
                List<String> choicesList = new List<String>();
                List<SelectOption> aOptionList = new List<SelectOption>();
                if(sq.Survey_Question__r.Type_of_Question__c == 'Checkbox (Yes/No)'){
                    aOptionList.add(new SelectOption('No', 'No', false));
                    aOptionList.add(new SelectOption('Yes', 'Yes', false));
                    aOptionList.add(new SelectOption('Disapproved', 'Disapproved', false));  
                    aOptionList.add(new SelectOption('N/A', 'N/A', false));                  
                }else if(sq.Survey_Question__r.Type_of_Question__c == 'Picklist'){
                    List<String> strVal = sq.Survey_Question__r.Picklist_Values__c.split(';');
                    if(sq.Answer__c != null){
                        aOptionList.add(new SelectOption(sq.Answer__c, sq.Answer__c, false));
                    }
                    
                    for(String str : strVal){
                        //if(str == sq.Answer__c){
                        //system.assertequals(str,null);
                        //}
                        if(str != sq.Answer__c){
                            aOptionList.add(new SelectOption(str, str, false));
                        }
                    }
                }
                sqWrapper.add(new SurveyQuestionsWrapper(sq, choicesList, aOptionList));
            }
        }
    }
    
    public PageReference btnSave(){
         if(!sqWrapper.isEmpty()) {
             List<Survey_Form__c> sqList = new List<Survey_Form__c>();
             for(SurveyQuestionsWrapper sqw : sqWrapper){
                 sqList.add(sqw.sqObj);
             }
             system.Debug('**sqList:'+sqList);
             if(sqList != null && !sqList.isEmpty()){
                 try{
                     update sqList;
                 }catch(Exception ex){
                     system.Debug(ex.getMessage());
                     ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0) );
                     ApexPages.addMessage(msg);
                     return null;
                 }
                 
             }
             
             PageReference Page = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
             return Page;
         }
         return null;
    }
 
    public class SurveyQuestionsWrapper{
        public Boolean checkSQ{get;set;}
        public Survey_Form__c sqObj{get;set;}
        public List<String> saList{get;set;}
        public List<SelectOption> answerOptionList{get;set;}
        public SurveyQuestionsWrapper(Survey_Form__c sq, List<String> aList, List<SelectOption> aOptionList){
            checkSQ = sq.Answered__c;
            sqObj = sq;
            saList = aList;
            answerOptionList = aOptionList;
        }
    }
}