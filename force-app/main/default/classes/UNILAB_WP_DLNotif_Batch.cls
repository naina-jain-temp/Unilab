/*-------------------------------------------------------------------------------------------
Author       :   Kristjan Mariano
Created Date :   10.04.2019
Definition   :   Batch Class process for workplan completion notification
-------------------------------------------------------------------------------------------*/

global class UNILAB_WP_DLNotif_Batch implements Database.Batchable<sObject>{
    
    global String query;
    
    global UNILAB_WP_DLNotif_Batch(){
        Datetime dateToday = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
        String missedStatus = 'Missed';
        String newStatus = 'New';
        String leaveHoliday = 'Leave/Holiday';

        if(Test.isRunningTest()){
            query = 'SELECT Id, Status__c, OwnerId, EndDateTime, Owner.UserRole.Name FROM Event WHERE Status__c = \''+newStatus+'\' AND Event_Type__c != \''+leaveHoliday+'\' LIMIT 200';
        }else{
            if(Datetime.now().format('EEEE') == 'Monday'){
                query = 'SELECT Id, Status__c, OwnerId, EndDateTime, Owner.UserRole.Name FROM Event WHERE EndDateTime != Today AND EndDateTime = LAST_N_DAYS: 2 AND Status__c = \''+newStatus+'\' AND Event_Type__c != \''+leaveHoliday+'\'';
            }else{
                query = 'SELECT Id, Status__c, OwnerId, EndDateTime, Owner.UserRole.Name FROM Event WHERE EndDateTime = Yesterday AND Status__c = \''+newStatus+'\' AND Event_Type__c != \''+leaveHoliday+'\'';
            }
            
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> eventList){
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
        List<FeedItem> FeedItemList = New List<FeedItem>();
        
        if(eventList != null && !eventList.isEmpty()){
            for(Event evt : (List<Event>) eventList){
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
                
				messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();   
                String userRoleName = evt.Owner.UserRole.Name;
                //Mention user here

                mentionSegmentInput.id = evt.OwnerId;
                textSegmentInput2.text = 'Hi ';
                messageBodyInput.messageSegments.add(textSegmentInput2);
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                String formatted = Datetime.now().formatGMT('EEEE, MMM d, yyyy');

                textSegmentInput.text = ',';
                textSegmentInput.text += '\n'+' You have a pending workplan that needs to be completed. Please accomplish it before ' +formatted + ' 6 PM' +'\n';
                textSegmentInput.text += '\n'+' Link: ' + System.Url.getSalesforceBaseURL().toExternalForm() + '/' + evt.Id;
                messageBodyInput.messageSegments.add(textSegmentInput);
                
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput.subjectId = evt.Id;
                
                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
                batchInputs.add(batchInput);
            }
        }
        
        if (batchInputs.size()>0) {     
                ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);  
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
   
   }

}