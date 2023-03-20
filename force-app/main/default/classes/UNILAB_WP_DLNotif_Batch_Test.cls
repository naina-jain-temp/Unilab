/*-------------------------------------------------------------------------------------------
Author       :   Kristjan Mariano
Created Date :   10.04.2019
Definition   :   Test Class for UNILAB_WP_DL Batch Apex
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_WP_DLNotif_Batch_Test {
    
	@isTest(SeeAllData=true) static void runBatch_Test(){
        List<Event> eventTestList = TestDataFactory.createBulkEvent(1);
        
        for(Event e : eventTestList){
            e.StartDateTime = dateTime.Now()-2;
            e.EndDateTime = dateTime.Now()-1;
            e.OwnerId = Userinfo.getUserId();
            e.Status__c = 'New';
            e.Created_from_Classic__c = false;
        }
        Test.startTest();
        insert eventTestList;
        
        UNILAB_WP_DLNotif_Batch bc = new UNILAB_WP_DLNotif_Batch();
        Database.executeBatch(bc);
        Test.stopTest();
        
    }
}