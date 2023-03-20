/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   06.14.2017
Definition   :   UNILAB_MissedEventsBatch Test Class
History      :   05.05.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_MissedEventsBatch_Test{
    
    @isTest static void runBatch_Test(){
        List<Event> eventTestList = TestDataFactory.createBulkEvent(10);
        
        for(Event e : eventTestList){
            e.StartDateTime = dateTime.Now().addDays(-2);
            e.EndDateTime = dateTime.Now().addDays(-1);
            e.OwnerId = Userinfo.getUserId();
            e.Created_from_Classic__c = true;
        }
        
        insert eventTestList;
        
        UNILAB_MissedEventsBatch bc = new UNILAB_MissedEventsBatch();
        Database.executeBatch(bc);
    }
}