public class UNILAB_TCB_TCP_View {
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
    public static List<Priority_Reference__c> fetchPriorities(string recordId, string priorityType){
        
        String acctGroup = [SELECT Account_Group__c FROM Account WHERE Id = :recordId 
                                     		Limit 1].Account_Group__c;
        
        List<Priority_Reference__c> topPrioritiesData = [
            select Id, Description__c, Initiatives_Type__c, Initiatives_Sub_type__c, Category__c
            from Priority_Reference__c 
            where Account_Group__c = :acctGroup 
            and Priority_Type__c = :priorityType
            and  (Monitoring_Start_Date__c <= THIS_MONTH and Monitoring_End_Date__c >= THIS_MONTH)
        ];
        
        return topPrioritiesData;
    }
    
    @AuraEnabled 
    public static string fetchPrevJournal(string recordId){
        return [select Id, Remarks__c
                from TCB_Activity__c
                where RecordType.Name = 'TCB Journal'
                and Account__c = :recordID
                order by CreatedDate desc limit 1].Remarks__c;
    }    
    
}