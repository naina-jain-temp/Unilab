trigger UNILAB_SurveySummaryFormTrigger on Survey_Summary_Form__c(after update) {

        UNILAB_SurveySummaryFormController.computeEventRatings(Trigger.New);
 
}