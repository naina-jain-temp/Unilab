// Author      : KC Roberto
// Created     : 8/24/2018
// Description : Test class for UNILAB_SubActivityTriggerHandler

@isTest
private class UNILAB_SubActivityTriggerHandlerTest {
    
    public static testMethod void NILAB_SubActivityTriggerHandler (){
        UNILAB_SubActivityTriggerHandler controller = new UNILAB_SubActivityTriggerHandler();
        
        
        TestDataFactory.createEvent();
        TestDataFactory.createAccount();
        Account account = TestDataFactory.getAccount();
        TestDataFactory.createActJunction(account.Id);
        Activity_Junction__c act = TestDataFactory.getActJuntionId();
        Event evt = TestDataFactory.getEvent();
        
        evt.Activity_Junction__c = act.Id;
        update evt;
        
        TestDataFactory.createParentSummaryForm();
        Survey_Summary_Form__c parentSummary = TestDataFactory.getParentSummaryId();
        TestDataFactory.createChildSummaryForm(parentSummary.Id);
        Survey_Summary_Form__c childSummary = TestDataFactory.getChildSummaryId(parentSummary.Id);
        
        
        TestDataFactory.createSubAct(act.Id, childSummary.Id);
    }

}