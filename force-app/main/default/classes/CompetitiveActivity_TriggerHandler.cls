public class CompetitiveActivity_TriggerHandler {
    
    public static void postToChatterAfterInsert(List<Competitive_Activity__c> compActList) {
        
        Map<String, String> chatterGroupMap = getChatterGroup();
        Map<Id, String> acctMap = getAccountName();
        
        List<FeedItem> feedItemList = new List<FeedItem>();
        
        for (Competitive_Activity__c compActRec : compActList) {
            
            String channelName = compActRec.Channel__c;
            
            String acctName = '-';
            String formattedDate = '-';
            String compType = '-';
            String compSubType = '-';
            String formattedDateImplemented = '-';
            String bu = '-';
            String division = '-';
            String brand = '-';
            String description = '-';
            String contactName = '-';
            
            if (String.isNotBlank(compActRec.Account__c)) {
                acctName = acctMap.get(compActRec.Account__c);
            }
            
            if (String.isNotBlank(String.valueOf(compActRec.Date__c))) {
                DateTime dateField = compActRec.Date__c;
                formattedDate = dateField.format('MMMM dd, yyyy');
            }
            
            if (String.isNotBlank(compActRec.Competitive_Type__c)) {
                compType = compActRec.Competitive_Type__c;
            }
            
            if (String.isNotBlank(compActRec.Competitive_Activity_Sub_Type__c)) {
                compSubType = compActRec.Competitive_Activity_Sub_Type__c;
            }
            
            if (String.isNotBlank(String.valueOf(compActRec.Date_Implemented__c))) {
                DateTime dateImplementedField = compActRec.Date_Implemented__c;
                formattedDateImplemented = dateImplementedField.format('MMMM dd, yyyy');
            }
            
            if (String.isNotBlank(compActRec.BU__c)) {
                bu = compActRec.BU__c;
            }
            
            if (String.isNotBlank(compActRec.Division__c)) {
                division = compActRec.Division__c;
            }
            
            if (String.isNotBlank(compActRec.Brand__c)) {
                brand = compActRec.Brand__c;
            }
            
            if (String.isNotBlank(compActRec.Description__c)) {
                description = compActRec.Description__c;
            }
            
            if (String.isNotBlank(compActRec.Contact__c)) {
                contactName = compActRec.Contact__r.Name;
            }
            
            System.debug(compActRec.Owner.Name);
            
            String chatterBody = '<p><b>Record Name</b>: '+ compActRec.Name + '</p>' +
                                 '<p><b>Link</b>: ' + System.Url.getSalesforceBaseURL().toExternalForm() + '/' + compActRec.Id + '</p>' +
                                 '<p>&nbsp;</p>' +
                                 '<p><b>Account</b>: ' + acctName + '</p>' +
                                 '<p><b>Date Created</b>: ' + formattedDate  + '</p>' +
                                 '<p><b>Trade Activity Type</b>: ' + compType + '</p>' +
                                 '<p><b>Trade Activity Sub Type</b>: ' + compSubType + '</p>' +
                                 '<p><b>Date Implemented</b>: ' + formattedDateImplemented + '</p>' +
                                 '<p><b>BU</b>: ' + bu + '</p>' +
                                 '<p><b>Division</b>: ' + division + '</p>' +
                                 '<p><b>Brand</b>: ' + brand + '</p>' +
                                 '<p><b>Description</b>: ' + description + '</p>' +
                                 '<p><b>Contact</b>: ' + contactName + '</p>';
            
            if (String.isNotBlank(channelName) && (channelName.contains('Key Accounts') || channelName.contains('Mercury') || channelName.contains('General Trade') || channelName.contains('Modern Trade'))) {
                
                channelName = formattedChannel(compActRec.Channel__c);
                
                FeedItem chatterGroupFeed = new FeedItem();
                
                chatterGroupFeed.ParentId = chatterGroupMap.get(channelName);
                chatterGroupFeed.Body = chatterBody;
                chatterGroupFeed.IsRichText = true;
                chatterGroupFeed.Type = 'TextPost';
                
                feedItemList.add(chatterGroupFeed);
                
            }
            
            FeedItem recordFeedItem = new FeedItem();
            
            recordFeedItem.ParentId = compActRec.Id;
            recordFeedItem.Body = chatterBody;
            recordFeedItem.IsRichText = true;
            recordFeedItem.Type = 'TextPost';
            
            feedItemList.add(recordFeedItem);
            
        }
        
        if (feedItemList.size() > 0) {
            insert feedItemList;
        }
        
    }
    
    public static void postToChatterAfterUpdate(Map<Id, Competitive_Activity__c> compActNewMap, Map<Id, Competitive_Activity__c> compActOldMap) {
        
        Map<String, String> chatterGroupMap = getChatterGroup();
        Map<Id, String> acctMap = getAccountName();
        
        List<FeedItem> feedItemList = new List<FeedItem>();
        
        for (Competitive_Activity__c newCompActRec : compActNewMap.values()) {
            
            Competitive_Activity__c oldCompActRec = compActOldMap.get(newCompActRec.Id);
            
            String channelName = newCompActRec.Channel__c;
            
            Integer countValueChanged = 0;
            String acctName;
            String formattedDate;
            String compType;
            String compSubType;
            String formattedDateImplemented;
            String bu;
            String division;
            String brand;
            String description;
            String contactName;
            
            if (newCompActRec.Account__c != oldCompActRec.Account__c) {
                if (String.isNotBlank(newCompActRec.Account__c)) {
                    acctName = '<p><u><b>Account</b></u>: ' + acctMap.get(newCompActRec.Account__c) + '</p>';
                }
                else {
                    acctName = '<p><u><b>Account</b></u>: -</p>';
                }
                countValueChanged++;
            }
            else {
                if (String.isNotBlank(newCompActRec.Account__c)) {
                    acctName = '<p><b>Account</b>: ' + acctMap.get(newCompActRec.Account__c) + '</p>';
                }
                else {
                    acctName = '<p><b>Account</b>: -</p>';
                }
            }
            
            if (newCompActRec.Date__c != oldCompActRec.Date__c) {
                if (String.isNotBlank(String.valueOf(newCompActRec.Date__c))) {
                    DateTime dateField = newCompActRec.Date__c;
                    formattedDate = '<p><u><b>Date Created</b></u>: ' + dateField.format('MMMM dd, yyyy') + '</p>';
                }
                else {
                    formattedDate = '<p><u><b>Date Created</b></u>: -</p>';
                }
                countValueChanged++;
            }
            else {
                if (String.isNotBlank(String.valueOf(newCompActRec.Date__c))) {
                    DateTime dateField = newCompActRec.Date__c;
                    formattedDate = '<p><b>Date Created</b>: ' + dateField.format('MMMM dd, yyyy') + '</p>';
                }
                else {
                    formattedDate = '<p><b>Date Created</b>: -</p>';
                }
            }
            
            if (newCompActRec.Competitive_Type__c != oldCompActRec.Competitive_Type__c) {
                if (String.isNotBlank(newCompActRec.Competitive_Type__c)) {
                    compType = '<p><u><b>Trade Activity Type</b></u>: ' + newCompActRec.Competitive_Type__c + '</p>';
                }
                countValueChanged++;
            }
            else {
                if (String.isNotBlank(newCompActRec.Competitive_Type__c)) {
                    compType = '<p><b>Trade Activity Type</b>: ' + newCompActRec.Competitive_Type__c + '</p>';
                }
            }
            
            if (newCompActRec.Competitive_Activity_Sub_Type__c != oldCompActRec.Competitive_Activity_Sub_Type__c) {
                if (String.isNotBlank(newCompActRec.Competitive_Activity_Sub_Type__c)) {
                    compSubType = '<p><u><b>Trade Activity Sub Type</b></u>: ' + newCompActRec.Competitive_Activity_Sub_Type__c + '</p>';
                }
                else {
                    compSubType = '<p><u><b>Trade Activity Sub Type</b></u>: -</p>';
                }
                countValueChanged++;
            }
            else {
                if (String.isNotBlank(newCompActRec.Competitive_Activity_Sub_Type__c)) {
                    compSubType = '<p><b>Trade Activity Sub Type</b>: ' + newCompActRec.Competitive_Activity_Sub_Type__c + '</p>';
                }
                else {
                    compSubType = '<p><b>Trade Activity Sub Type</b>: -</p>';
                }
            }
            
            if (newCompActRec.Date_Implemented__c != oldCompActRec.Date_Implemented__c) {
                if (String.isNotBlank(String.valueOf(newCompActRec.Date_Implemented__c))) {
                    DateTime dateImplementedField = newCompActRec.Date_Implemented__c;
                    formattedDateImplemented = '<p><u><b>Date Implemented</b></u>: ' + dateImplementedField.format('MMMM dd, yyyy') + '</p>';
                }
                else {
                    formattedDateImplemented = '<p><u><b>Date Implemented</b></u>: -</p>';
                }
                countValueChanged++;
            }
            else {
                if (String.isNotBlank(String.valueOf(newCompActRec.Date_Implemented__c))) {
                    DateTime dateImplementedField = newCompActRec.Date_Implemented__c;
                    formattedDateImplemented = '<p><b>Date Implemented</b>: ' + dateImplementedField.format('MMMM dd, yyyy') + '</p>';
                }
                else {
                    formattedDateImplemented = '<p><b>Date Implemented</b>: -</p>';
                }
            }
            
            if (newCompActRec.BU__c != oldCompActRec.BU__c) {
                if (String.isNotBlank(newCompActRec.BU__c)) {
                    bu = '<p><u><b>BU</b></u>: ' + newCompActRec.BU__c + '</p>';
                }
                else {
                    bu = '<p><u><b>BU</b></u>: -</p>';
                }
                countValueChanged++;
            }
            else {
                if (String.isNotBlank(newCompActRec.BU__c)) {
                    bu = '<p><b>BU</b>: ' + newCompActRec.BU__c + '</p>';
                }
                else {
                    bu = '<p><b>BU</b>: -</p>';
                }
            }
            
            if (newCompActRec.Division__c != oldCompActRec.Division__c) {
                if (String.isNotBlank(newCompActRec.Division__c)) {
                    division = '<p><u><b>Division</b></u>: ' + newCompActRec.Division__c + '</p>';
                }
                else {
                    division = '<p><u><b>Division</b></u>: -</p>';
                }
                countValueChanged++;
            }
            else {
                if (String.isNotBlank(newCompActRec.Division__c)) {
                    division = '<p><b>Division</b>: ' + newCompActRec.Division__c + '</p>';
                }
                else {
                    division = '<p><b>Division</b>: -</p>';
                }
            }
            
            if (newCompActRec.Brand__c != oldCompActRec.Brand__c) {
                if (String.isNotBlank(newCompActRec.Brand__c)) {
                    brand = '<p><u><b>Brand</b></u>: ' + newCompActRec.Brand__c + '</p>';
                }
                else {
                    brand = '<p><u><b>Brand</b></u>: -</p>';
                }
                countValueChanged++;
            }
            else {
                if (String.isNotBlank(newCompActRec.Brand__c)) {
                    brand = '<p><b>Brand</b>: ' + newCompActRec.Brand__c + '</p>';
                }
                else {
                    brand = '<p><b>Brand</b>: -</p>';
                }
            }
            
            if (newCompActRec.Description__c != oldCompActRec.Description__c) {
                if (String.isNotBlank(newCompActRec.Description__c)) {
                    description = '<p><u><b>Description</b></u>: ' + newCompActRec.Description__c + '</p>';
                }
                else {
                    description = '<p><u><b>Description</b></u>: -</p>';
                }
                countValueChanged++;
            }
            else {
                if (String.isNotBlank(newCompActRec.Description__c)) {
                    description = '<p><b>Description</b>: ' + newCompActRec.Description__c + '</p>';
                }
                else {
                    description = '<p><b>Description</b>: -</p>';
                }
            }
            
            if (newCompActRec.Contact__c != oldCompActRec.Contact__c) {
                if (String.isNotBlank(newCompActRec.Contact__c)) {
                    contactName = '<p><u><b>Contact</b></u>: ' + newCompActRec.Contact__c + '</p>';
                }
                else {
                    contactName = '<p><u><b>Contact</b></u>: -</p>';
                }
                countValueChanged++;
            }
            else {
                if (String.isNotBlank(newCompActRec.Contact__c)) {
                    contactName = '<p><b>Contact</b>: ' + newCompActRec.Contact__c + '</p>';
                }
                else {
                    contactName = '<p><b>Contact</b>: -</p>';
                }
            }
            
            if (countValueChanged > 0) {
                
                String chatterBody = '<p>Details of <b>' + newCompActRec.Name + '</b> has been updated.' + '</p>' +
                    				 '<p><b>Link</b>: ' + System.Url.getSalesforceBaseURL().toExternalForm() + '/' + newCompActRec.Id + '</p>' +
                    				 '<p>&nbsp;</p>' + acctName + formattedDate + compType + compSubType + formattedDateImplemented + 
                    				 bu + division + brand + description + contactName;
                
                if (String.isNotBlank(channelName) && (channelName.contains('Key Accounts') || channelName.contains('Mercury') || channelName.contains('General Trade') || channelName.contains('Modern Trade'))) {
                    
                    channelName = formattedChannel(newCompActRec.Channel__c);
                    
                    FeedItem chatterGroupFeed = new FeedItem();
                    
                    chatterGroupFeed.ParentId = chatterGroupMap.get(channelName);
                    chatterGroupFeed.Body = chatterBody;
                    chatterGroupFeed.IsRichText = true;
                    chatterGroupFeed.Type = 'TextPost';
                    
                    feedItemList.add(chatterGroupFeed);
                    
                }
                
                FeedItem recordFeedItem = new FeedItem();
                
                recordFeedItem.ParentId = newCompActRec.Id;
                recordFeedItem.Body = chatterBody;
                recordFeedItem.IsRichText = true;
                recordFeedItem.Type = 'TextPost';
                
                feedItemList.add(recordFeedItem);
                
            }
            
        }
        
        if (feedItemList.size() > 0) {
            insert feedItemList;
        }
        
    }
    
    public static Map<String, String> getChatterGroup() {
        
        Map<String, String> chatterGroupMap = new Map<String, String>();
        
        List<CollaborationGroup> chatterGroupList = [SELECT Id,
                                                     		Name
                                                     FROM CollaborationGroup
                                                     WHERE (Name LIKE '%TAF-%')
                                                     AND (IsArchived = false)
                                                    ];
        
        if (chatterGroupList.size() > 0) {
            
            for (CollaborationGroup chatterGroupRec : chatterGroupList) {
                chatterGroupMap.put(chatterGroupRec.Name, chatterGroupRec.Id);
            }
            
            if (Test.isRunningTest()) {
                List<CollaborationGroup> testChatterGroupList = [SELECT Id,
                                                                 		Name
                                                                 FROM CollaborationGroup
                                                                 WHERE (Name LIKE 'TAF-Chatter Group')
                                                                 AND (IsArchived = false)
                                                                ];
                
                chatterGroupMap.put(testChatterGroupList[0].Name, testChatterGroupList[0].Id);
                
            }
            
            return chatterGroupMap;
            
        }
        
        else {
            
            return null;
            
        }
        
    }
    
    public static String formattedChannel(String channelName) {
        
        String formattedChannelName;
        
        if (channelName == 'Key Accounts') {
            formattedChannelName = 'TAF-KA';
        }
        
        if (channelName == 'General Trade') {
            formattedChannelName = 'TAF-GT';
        }
        
        if (channelName == 'Modern Trade') {
            formattedChannelName = 'TAF-GT';
        }
        
        if (channelName == 'Mercury') {
            formattedChannelName = 'TAF-MDC';
        }
        
        if (Test.isRunningTest()) {
            formattedChannelName = 'TAF-Chatter Group';
        }
        
        return formattedChannelName;
        
    }
    
    public static Map<Id, String> getAccountName() {
        
        Map<Id, String> acctMap = new Map<Id, String>();
        
        List<Account> acctList = [SELECT Id,
                                  		 Name
                                  FROM Account
                                  LIMIT 50000
                                 ];
        
        for (Account acctRec : acctList) {
            acctMap.put(acctRec.Id, acctRec.Name);
        }
        
        return acctMap;
        
    }
    
}