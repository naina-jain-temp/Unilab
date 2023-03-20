// Author      : Gizelle Latosa
// Created     : 2/25/2018
 
trigger UNILAB_SurveyFormTrigger on Survey_Form__c(after insert, after update, after delete) {

    Set<Id> itemIds = new Set<Id>();
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
    
        for(Survey_Form__c sf : Trigger.new) {
            itemIds.add(sf.Survey_Summary_Form__c);
        }
    
    }
    
    else if(Trigger.isAfter && Trigger.isDelete) {
    
        for(Survey_Form__c sf : Trigger.old) {
            itemIds.add(sf.Survey_Summary_Form__c);
        }
    
    }
    
    if(!itemIds.isEmpty()) {
        UNILAB_SurveySummaryFormController.computeAnsweredCount(itemIds);
    }   
    
}