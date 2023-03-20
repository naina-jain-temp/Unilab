public class UNILAB_TCB_Form {
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
        eventId = branchId == userRecord.Currently_Logged_Account_ID__c ? userRecord.Currently_Logged_Event_ID__c:'NONE';
        /*
        if(branchId == userRecord.Currently_Logged_Account_ID__c){
            eventId = userRecord.Currently_Logged_Event_ID__c;
        }else{eventId = 'NONE';}
        */
        return eventId;
        
    }
    
	@AuraEnabled 
    public static List<TCB_Category_Ref__c> fetchAcctCategory(string recordId){
        
        return [
            select Id, Category__c
            from TCB_Category_Ref__c 
            where Account__c = :recordId
            order by Category__c
        ];
    }
    
    @AuraEnabled
    public static string fetchRES(string recordId){
        
        return [SELECT Retail_Environment__c FROM Account WHERE Id = :recordId 
                                     		Limit 1].Retail_Environment__c;
    }
    
    @AuraEnabled
    public static string fetchAcctGroup(string recordId){
        return [SELECT Account_Group__c FROM Account WHERE Id = :recordId 
                                     		Limit 1].Account_Group__c;
    }
    
    @AuraEnabled 
    public static integer fetchTCBActivityCount(String recordId, String eventId){
        
        Integer recCount = [
            select count()
            from TCB_Activity__c 
            //where (RecordTypeId = '0120T000000BgFwQAK' or RecordTypeId = '0120T000000Bi01QAC' or RecordTypeId = '0120T000000BioaQAC')
            where (RecordType.Name = 'Visibility' or RecordType.Name = 'Assortment' or RecordType.Name = 'TOP Priorities')
            and Account__c = :recordId
            //and CreatedDate = TODAY
            and Event_ID__c = :eventId
        ];
        system.debug('=========> ' + recCount);
        
        return recCount;
    }
    
    @AuraEnabled
    public static String populateTCBSubActivity(String eventId) {
        String activityJunctionId = [
            select Activity_Junction__c
            from Sub_Activity__c
            where Event_ID__c = :eventId
        ].Activity_Junction__c;
        
      	String subActivityID;
            
        subActivityID = [
            select Id
            from Sub_Activity__c
            where Event_ID__c = :eventId
        ].Id;
        
        //if (!String.isNotBlank(subActivityID)) {
        if(subActivityID.length()<=0){
            //create sub activity child records
            //Sub_Activity__c sa = new Sub_Activity__c();
            Sub_Activity__c sa = new Sub_Activity__c(Activity_Junction__c = activityJunctionId,
            						Activity_Name__c = 'TRADE CHECK BUDDY'
            );
            insert sa;
            
            subActivityID = sa.Id;
        }
        
        return subActivityID;
    }
    
    @AuraEnabled
    public static String populateInitialTCBVisibility(String recordID, String res, String eventId) {
        List<TCB_Visibility_Ref__c> visibilityData = [
            select Id, Criteria__c, Target__c, Criteria_Sorting__c, Category__c
            from TCB_Visibility_Ref__c 
            where Retail_Environment__c = :res 
            order by Criteria_Sorting__c
        ];
        
        string subActivityID = [
            select Id
            from Sub_Activity__c
            where Event_ID__c = :eventId
        ].Id;
        
        List<TCB_Activity__c> priorityCheckList = new List<TCB_Activity__c>();
        TCB_Activity__c priorityCheckListItem = new TCB_Activity__c();
        
        for (TCB_Visibility_Ref__c pData : visibilityData) {
            priorityCheckListItem = new TCB_Activity__c(Item__c = pData.Criteria__c,
                                                        Item_Target__c = pData.Target__c,
                                                    Account__c = recordID,
                                                    Category__c = pData.Category__c,
                                                    Yes__c = true,
                                                    No__c = false,
                                                    Sub_Activity__c = subActivityID,
                                                    RecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Visibility').getRecordTypeId()
                                                    );
            
            priorityCheckList.add(priorityCheckListItem);
        }    
        
        insert priorityCheckList;
        
        return priorityCheckListItem.Id;
    }
	
    @AuraEnabled
    public static String populateInitialTCBAssortment(String recordID, String eventId) {
        List<TCB_Assortment_Ref__c> assortmentData = [
            select Id, Item_Code__c, Item_Name__c, Category__c
            from TCB_Assortment_Ref__c 
            where Account__c = :recordId 
        ];
        
        string subActivityID = [
            select Id
            from Sub_Activity__c
            where Event_ID__c = :eventId
        ].Id;
        
        List<TCB_Activity__c> priorityCheckList = new List<TCB_Activity__c>();
        TCB_Activity__c priorityCheckListItem = new TCB_Activity__c();
        
        for (TCB_Assortment_Ref__c pData : assortmentData) {
            priorityCheckListItem = new TCB_Activity__c(Item__c = pData.Item_Code__c,
                                                        Item_Target__c = pData.Item_Name__c,
                                                    Account__c = recordID,
                                                    Category__c = pData.Category__c,
                                                    Yes__c = true,
                                                    No__c = false,
                                                    Sub_Activity__c = subActivityID,
                                                    RecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('Assortment').getRecordTypeId()
                                                    );
            
            priorityCheckList.add(priorityCheckListItem);
        }    
        
        insert priorityCheckList;
        
        return priorityCheckListItem.Id;
    }
    
    @AuraEnabled
    public static String populateInitialTCBTOPPriorities(String recordID, String acctGroup, String eventId) {
        List<Priority_Reference__c> topPrioritiesData = [
            select Id, Description__c, Initiatives_Type__c, Initiatives_Sub_type__c, Category__c
            from Priority_Reference__c 
            where Account_Group__c = :acctGroup 
            and  (Monitoring_Start_Date__c <= THIS_MONTH and Monitoring_End_Date__c >= THIS_MONTH)
        ];
        
        string subActivityID = [
            select Id
            from Sub_Activity__c
            where Event_ID__c = :eventId
        ].Id;
        
        List<TCB_Activity__c> priorityCheckList = new List<TCB_Activity__c>();
        TCB_Activity__c priorityCheckListItem = new TCB_Activity__c();
        
        for (Priority_Reference__c pData : topPrioritiesData) {
            priorityCheckListItem = new TCB_Activity__c(Item__c = pData.Description__c,
                                                    Account__c = recordID,
                                                    Category__c = pData.Category__c,
                                                    Yes__c = true,
                                                    No__c = false,
                                                    Sub_Activity__c = subActivityID,
                                                    RecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('TOP Priorities').getRecordTypeId()
                                                    );
            
            priorityCheckList.add(priorityCheckListItem);
        }    
        
        insert priorityCheckList;
        
        return priorityCheckListItem.Id;
    }
	
    @AuraEnabled
    public static List<TCB_Activity__c> fetchVisibilityData(String recordID, String cat, String eventId){
        
        return [
            select Id, Item__c, Item_Target__c, Yes__c, No__c
            from TCB_Activity__c
            //where RecordTypeId = '0120T000000BgFwQAK' //Visibility Record Type
            where RecordType.Name = 'Visibility'
            and Account__c = :recordID
            //and CreatedDate = TODAY
            and Category__c = :cat
            and Event_ID__c = :eventId
            order by Id
        ];
    }
	
    /*
    @AuraEnabled
    public static List<TCB_Activity__c> fetchAssortmentData(String recordID, String cat){
        
        return [
            select Id, Item__c, Item_Target__c, Yes__c, No__c
            from TCB_Activity__c
            where RecordTypeId = '0120T000000BioaQAC' //Assortment Record Type
            and Account__c = :recordID
            and CreatedDate = TODAY
            and Category__c = :cat
            order by Id
        ];
    }*/
    
    @AuraEnabled
    public static List<TCB_Activity__c> fetchAssortData(String recordID, String cat, String eventId){
        
        //Integer psize = Integer.valueOf(pageSize);
        //Integer pnumber = Integer.valueOf(pageNumber)-1;
        
        return [
            select Id, Item__c, Item_Target__c, Yes__c, No__c
            from TCB_Activity__c
            //where RecordTypeId = '0120T000000BioaQAC' //Assortment Record Type
            where RecordType.Name = 'Assortment'
            and Account__c = :recordID
            //and CreatedDate = TODAY
            and Category__c = :cat
            and Event_ID__c = :eventId
            order by Id
            //limit :Integer.valueOf(psize) OFFSET :(psize*pnumber)
        ];
    }
	
    @AuraEnabled
    public static List<TCB_Activity__c> fetchTOPPrioritiesData(String recordID, String cat, String eventId){
        
        return [
            select Id, Item__c, Item_Target__c, Yes__c, No__c
            from TCB_Activity__c
            //where RecordTypeId = '0120T000000Bi01QAC' //TOP Priorities Record Type
            where RecordType.Name = 'TOP Priorities'
            and Account__c = :recordID
            //and CreatedDate = TODAY
            and Category__c = :cat
            and Event_ID__c = :eventId
            order by Id
        ];
    }
    
    @AuraEnabled
    public static List<TAFT__c> fetchTAFT(string recordId){
        return [select Id, Activity_Title__c, Affected_BU__c, Market_Activity_Type__c,
                Start_Date__c, End_Date__c
                from TAFT__c 
                where Account__c = :recordId 
               	and CreatedDate = TODAY];
    }
    
    /*
    @AuraEnabled 
    public static string fetchPreviousLearningsAndInsights(string recordId, string activityName){
        
        String userId = userInfo.getUserId();
        
        String activityJunction =  [select Name
            from Activity_Junction__c 
            where CreatedById = :userId
            and Related_To_Account__c = :recordId
            and Event_Type__c = 'Call'
           and End_Date__c <> null
        order by End_Date__c desc
        limit 1].Id;
        
        return [select Learnings_Insights__c 
                from Sub_Activity__c
                where Activity_Junction__c = :activityJunction
                and Activity_Name__c = :activityName
        ].Learnings_Insights__c;
        
    }
    */
    @AuraEnabled 
    public static string fetchPrevJournal(string recordId, string cat){
        return [select Id, Remarks__c
                from TCB_Activity__c
                where RecordType.Name = 'TCB Journal'
                and Account__c = :recordID
                and Category__c = :cat
                order by CreatedDate desc limit 1].Remarks__c;
    }
    
    /*
    @AuraEnabled 
    public static string updateLearningsAndInsights(string recordId, string activityName, string learningAndInsights){
        
        String userId = userInfo.getUserId();
        
        String activityJunction =  [select Name
            from Activity_Junction__c 
            where CreatedById = :userId
            and Related_To_Account__c = :recordId
            and Event_Type__c = 'Call'
           	and End_Date__c <> null
           	and End_Date__c = TODAY
        order by End_Date__c desc
        limit 1].Id;
        
        Sub_Activity__c subActivityRecord = new Sub_Activity__c();
        
        subActivityRecord = [select Learnings_Insights__c 
                from Sub_Activity__c
                where Activity_Junction__c = :activityJunction
                and Activity_Name__c = :activityName
        ];
        
        subActivityRecord.Learnings_Insights__c = learningAndInsights;
        
        update subActivityRecord;
        
        return subActivityRecord.Id;
        
    }*/
    
    @AuraEnabled
    public static String saveJournal(string recordId, string cat, string journal, string eventId) {

        string subActivityID = [
            select Id
            from Sub_Activity__c
            where Event_ID__c = :eventId
        ].Id;
        
        TCB_Activity__c tcbJournal = new TCB_Activity__c();
        
        tcbJournal = new TCB_Activity__c(Item__c = 'Journal',
                                         Account__c = recordID,
                                         Category__c = cat,
                                         Yes__c = true,
                                         No__c = false,
                                         Remarks__c = journal,
                                         Sub_Activity__c = subActivityID,
                                         RecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('TCB Journal').getRecordTypeId()
                                        );
        
        insert tcbJournal;
        
        return tcbJournal.Id;
    }
    
    @AuraEnabled
    public static String saveFiles(string recordId, string cat, string eventId) {
		String userId = userInfo.getUserId();
        
        string subActivityID = [
            select Id
            from Sub_Activity__c
            where Event_ID__c = :eventId
        ].Id;
        
        TCB_Activity__c tcbJournal = new TCB_Activity__c();
        
        tcbJournal = new TCB_Activity__c(Item__c = 'Related File',
                                         Account__c = recordID,
                                         Category__c = cat,
                                         Yes__c = true,
                                         No__c = false,
                                         Sub_Activity__c = subActivityID,
                                         RecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get('TCB Files').getRecordTypeId()
                                        );
        
        insert tcbJournal;
        
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
                    LinkedEntityId = tcbJournal.Id,
                    ContentDocumentId = cdlr.ContentDocumentId,
                    Visibility = cdlr.Visibility,
                    ShareType = cdlr.ShareType
                )
            );
        }
        
        insert contDocLinkRecordItems;
        
        delete contDocLinkRecord;
        
        return tcbJournal.Id;
        
        //return tcbJournal.Id;
    }
    
    @AuraEnabled
    public static String deleteTAFTRecord(String recordId) {
        delete [select Id from TAFT__c where Id = :recordId];
        return 'Success';
    }
    
    @AuraEnabled
    public static String updateForm(List<TCB_Activity__c> priorityData, String recordID) {
        update priorityData;
        return 'Success';
    }
    
	/*    
    @AuraEnabled 
    public static List<TCB_Visibility_Ref__c> fetchVisibilityCriteria(string res, string cat){
        
        return [
            select Id, Criteria__c, Target__c, Criteria_Sorting__c
            from TCB_Visibility_Ref__c 
            where Retail_Environment__c = :res 
            and Category__c = :cat
            order by Criteria_Sorting__c
        ];
    }
    
    @AuraEnabled 
    public static List<TCB_Assortment_Ref__c> fetchAssortment(string recordId, string cat){
        
        return [
            select Id, Item_Code__c, Item_Name__c
            from TCB_Assortment_Ref__c 
            where Account__c = :recordId 
            and Category__c = :cat
        ];
    }
    
    @AuraEnabled 
    public static List<Priority_Reference__c> fetchTOPPriorities(string acctGroup, string cat){
        
        return [
            select Id, Description__c, Initiatives_Type__c, Initiatives_Sub_type__c
            from Priority_Reference__c 
            where Account_Group__c = :acctGroup 
            and Category__c = :cat
            and  (Monitoring_Start_Date__c <= THIS_MONTH and Monitoring_End_Date__c >= THIS_MONTH)
        ];
    }
    */
    /*
    @AuraEnabled
    public static String saveForm(List<TCB_Activity__c> priorityData, String recordID, String rType) {
        String userId = userInfo.getUserId();
        Date todayDate = Date.today() ;
        
        System.debug(priorityData);
        List<TCB_Activity__c> priorityCheckList = new List<TCB_Activity__c>();
        
        TCB_Activity__c priorityCheckListItem = new TCB_Activity__c();
        for (TCB_Activity__c pData : priorityData) {
            priorityCheckListItem = new TCB_Activity__c(Item__c = pData.Item__c,
                                                    Item_Target__c = pData.Item_Target__c,
                                                    Account__c = recordID,
                                                    Yes__c = pData.Yes__c,
                                                    No__c = pData.No__c,
                                                    RecordTypeId = Schema.SObjectType.TCB_Activity__c.getRecordTypeInfosByName().get(rType).getRecordTypeId()
                                                    );
            
            priorityCheckList.add(priorityCheckListItem);
        }    
        
        insert priorityCheckList;
        return priorityCheckListItem.Id;

    }*/
}