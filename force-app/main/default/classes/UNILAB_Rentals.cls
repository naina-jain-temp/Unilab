public class UNILAB_Rentals {
    
    /*
    @AuraEnabled
    public static integer checkEventToday(String branchId){
        String userId = userInfo.getUserId();
        Date todayDate = Date.today();
        Integer completedEventRecCount = 0;
        Integer eventRecCount = 0;
        Integer eclRecCount = 0;
        Integer recCount = 0;
        
        completedEventRecCount = [
            select count()
            from Event 
            where CreatedById = :userId
            and Related_To_Account__c = :branchId
            and StartDateTime = :todayDate
            and Event_Type__c = 'Call'
            and Status__c = 'Completed'
            
        ];
       	
        eventRecCount = [
            select count()
            from Event 
            where CreatedById = :userId
            and Related_To_Account__c = :branchId
            and StartDateTime = :todayDate
            and Event_Type__c = 'Call'
            
        ];
        
        system.debug('=========> ' + eventRecCount);
        
        eclRecCount = [
            select count()
            from Event_Log__c 
            where CreatedById = :userId
            and CreatedDate = TODAY
            and Account__c = :branchId
            and End_Date__c = null
        ];
        
        system.debug('=========> ' + eclRecCount);
        
        if (completedEventRecCount > 0){
            recCount = 3;
        }
        else{
            recCount = completedEventRecCount + eventRecCount + eclRecCount;
            system.debug('=========> ' + recCount);
        }
        return recCount;        
    }
    
    @AuraEnabled
    public static string fetchECL(String branchId){
        String userId = userInfo.getUserId();
        Date todayDate = Date.today();
       
        
        String account = [
            select Account__c
            from Event_Log__c 
            where CreatedById = :userId
            and CreatedDate = TODAY
            and Account__c = :branchId
            and End_Date__c = null
        ].Account__c;
        
       return account;
    }*/
    
    @AuraEnabled
    public static string fetchUserLoggedAcctEvent(String branchId){
        String userId = userInfo.getUserId();
        
        User userRecord = new User();
        userRecord = [select Id, Currently_Logged_Account_ID__c, 
                      Currently_Logged_Event_ID__c,  
                      Currently_Logged_Account_Junction_ID__c
                      from User where Id = :userId];
        
        
        String eventId;
        
        if(branchId == userRecord.Currently_Logged_Account_ID__c){
            eventId = userRecord.Currently_Logged_Event_ID__c;
        }else{eventId = 'NONE';}
        
        return eventId;
        
    }
    
    @AuraEnabled 
    public static integer fetchRentalTodayCount(String recordId, String eventId){
        
        Integer recCount = [
            select count()
            from TCB_Activity__c 
            where RecordType.Name = 'Rentals'
            and Account__c = :recordId
            //and CreatedDate = TODAY
            and Event_ID__c = :eventId
            
        ];
        system.debug('=========> ' + recCount);
        
        return recCount;
        
        /*
        return [
            select count(Id)
            from TCB_Activity__c 
            where CreatedDate = :todayDate
        ].expr0;*/
    }
    
    @AuraEnabled
    public static String populateInitialRentals(String recordID, String eventId) {
        List<Rental_Ref__c> priorityData = [
            select Criteria__c, Criteria_Sorting__c
            from Rental_Ref__c 
            order by Criteria_Sorting__c 
        ];
 
        String subActivityID = [
            select Id
            from Sub_Activity__c
            where Event_ID__c = :eventId
        ].Id;
        
        //if (!String.isNotBlank(subActivityID)) {
        if(subActivityID.length()<=0){
            /*String activityJunctionId = [
                    select Activity_Junction__c
                    from Sub_Activity__c
                    where Event_ID__c = :eventId
                ].Activity_Junction__c;
            */  
                    
            //create sub activity child records
            Sub_Activity__c sa = new Sub_Activity__c(Activity_Junction__c = [select Activity_Junction__c
                                                                from Sub_Activity__c
                                                                where Event_ID__c = :eventId
                                                            ].Activity_Junction__c,
            						Activity_Name__c = 'TRADE CHECK BUDDY'
            );
            insert sa;
            
            subActivityID = sa.Id;
        }
        
        List<TCB_Activity__c> priorityCheckList = new List<TCB_Activity__c>();
        TCB_Activity__c priorityCheckListItem = new TCB_Activity__c();
        
        for (Rental_Ref__c pData : priorityData) {
            priorityCheckListItem = new TCB_Activity__c(Item__c = pData.Criteria__c,
                                                    Account__c = recordID,
                                                    Yes__c = true,
                                                    No__c = false,
                                                   	Sub_Activity__c = subActivityID,
                                                    RecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Rentals').getRecordTypeId()
                                                    );
            
            priorityCheckList.add(priorityCheckListItem);
        }    
        
        insert priorityCheckList;
        
        return priorityCheckListItem.Id;
    }
    @AuraEnabled 
    public static List<TCB_Activity__c> fetchCriteria(String recordID, String eventId){
    	return [
            select Id, Item__c, Yes__c, No__c
            from TCB_Activity__c
            //where RecordTypeId = '0120T000000BdNUQA0'
            where RecordType.Name = 'Rentals'
            and Account__c = :recordID
            //and CreatedDate = TODAY
            and Event_ID__c = :eventID
            order by Id
        ];
    }
    
    @AuraEnabled 
    public static string fetchPrevJournal(string recordId){
        return [select Id, Remarks__c
                from TCB_Activity__c
                where RecordType.Name = 'Rentals Journal'
                and Account__c = :recordID
                order by CreatedDate desc limit 1].Remarks__c;
    }
    
    @AuraEnabled
    public static String saveJournal(string recordId, string journal, string eventId) {
        
        String subActivityID = [
            select Id
            from Sub_Activity__c
            where Event_ID__c = :eventId
        ].Id;

        TCB_Activity__c tcbJournal = new TCB_Activity__c();
        
        tcbJournal = new TCB_Activity__c(Item__c = 'Journal',
                                         Account__c = recordID,
                                         Yes__c = true,
                                         No__c = false,
                                         Remarks__c = journal,
                                         Sub_Activity__c = subActivityID,
                                         RecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Rentals Journal').getRecordTypeId()
                                        );
        
        insert tcbJournal;
        
        return tcbJournal.Id;
    }
    
    @AuraEnabled
    public static String saveFiles(string recordId, string eventId) {
		String userId = userInfo.getUserId();
        
        String subActivityID = [
            select Id
            from Sub_Activity__c
            where Event_ID__c = :eventId
        ].Id;
        
        TCB_Activity__c rentalFiles = new TCB_Activity__c();
        
        rentalFiles = new TCB_Activity__c(Item__c = 'Related File',
                                         Account__c = recordID,
                                         Yes__c = true,
                                         No__c = false,
                                         Sub_Activity__c = subActivityID,
                                         RecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Rental Files').getRecordTypeId()
                                        );
        
        insert rentalFiles;
        
        List<ContentDocumentLink> contDocLinkRecord = [
            SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType
            FROM ContentDocumentLink
            WHERE LinkedEntityId=:recordID
            AND SystemModstamp = TODAY
            AND ContentDocument.CreatedById = :userId
        ];
            
        List<ContentDocumentLink> contDocLinkRecordItems = new List<ContentDocumentLink>();
        
        for (ContentDocumentLink cdlr : contDocLinkRecord) {
        	contDocLinkRecordItems.add(
            	new ContentDocumentLink(
                    LinkedEntityId = rentalFiles.Id,
                    ContentDocumentId = cdlr.ContentDocumentId,
                    Visibility = cdlr.Visibility,
                    ShareType = cdlr.ShareType
                )
            );
        }
        
        insert contDocLinkRecordItems;
        
        delete contDocLinkRecord;
        
        return rentalFiles.Id;
        
        //return tcbJournal.Id;
    }
    
    @AuraEnabled
    public static String updateForm(List<TCB_Activity__c> priorityData, String recordID) {
        update priorityData;
        return recordID;
    }
    /*
	@AuraEnabled 
    public static List<Rental_Ref__c> fetchRentalCriteria(){
        
        return [
            select Criteria__c, Criteria_Sorting__c
            from Rental_Ref__c 
            order by Criteria_Sorting__c
        ];
    }
    
    @AuraEnabled
    public static String saveForm(List<TCB_Activity__c> priorityData, String recordID) {
        String userId = userInfo.getUserId();
        Date todayDate = Date.today() ;
        System.debug(priorityData);
        List<TCB_Activity__c> priorityCheckList = new List<TCB_Activity__c>();
        
        TCB_Activity__c priorityCheckListItem = new TCB_Activity__c();
        for (TCB_Activity__c pData : priorityData) {
            priorityCheckListItem = new TCB_Activity__c(Item__c = pData.Item__c,
                                                    Account__c = recordID,
                                                    Yes__c = pData.Yes__c,
                                                    No__c = pData.No__c,
                                                    RecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Rentals').getRecordTypeId()
                                                    );
            
            priorityCheckList.add(priorityCheckListItem);
        }    
        
        insert priorityCheckList;
        
        return priorityCheckListItem.Id;

    }*/
}