/*-------------------------------------------------------------------------------------------
Author       :   Kristjan Mariano
Created Date :   10.04.2019
Definition   :   Test class for UNILAB_WP_DL Schedulable Class
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_WP_DL_SchedulableClass_Test {

    @isTest(SeeAllData=true) static void runBatch_Test(){
        List<Event> eventTestList = TestDataFactory.createBulkEvent(10);
        
        for(Event e : eventTestList){
            e.StartDateTime = dateTime.Now()-2;
            e.EndDateTime = dateTime.Now()-1;
            //e.OwnerId = Userinfo.getUserId();
            e.Status__c = 'New';
            e.Created_from_Classic__c = false;
        }
        Test.startTest();
        insert eventTestList;
        
        UNILAB_WP_DL_SchedulableClass sh1 = new UNILAB_WP_DL_SchedulableClass();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Events Completion Batch', sch, sh1); 
        Test.stopTest();
    }
}