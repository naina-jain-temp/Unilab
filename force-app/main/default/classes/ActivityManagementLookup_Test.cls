@isTest
private class ActivityManagementLookup_Test {

     @isTest static void testSurveyQuestionnaireControllerCX(){

         ActivityManagementLookupController.fetchLookUpValues('Sample Account', 'Account');
         
         System.debug(ActivityManagementLookupController.fetchLookUpValues('Watsons - PC Branch 1', 'Account'));
     }
}