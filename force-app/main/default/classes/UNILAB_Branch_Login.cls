public class UNILAB_Branch_Login {
    /*
	@AuraEnabled 
    public static List<Account> fetchAccounts(){
        Id userId = UserInfo.getUserId();
        
        //AccountTeamMember Query
        List<AccountTeamMember> members = [
            SELECT
                Id,
                AccountId
            FROM
                AccountTeamMember
            WHERE
                UserId = :userId];
        
        //Get IDs for All Accounts in ATM
        Set<Id> accountIds = new Set<Id>();
        for(AccountTeamMember member : members) {
            accountIds.add(member.AccountId);
        }
        
        //Query the Accounts
        List<Account> acc = [
            SELECT
                Id,
            	Name,
            	Branch_Code__c,
           		Branch_Name__c,
            	(SELECT Id, WhatId, Count__c FROM Events WHERE Type='Call')
            FROM
                Account
            WHERE
                Id IN :accountIds
                OR OwnerId = :userId];
            //];
        
        return acc;
    }*/
    
    public static Activity_Junction__c populateActJunc(Event e,String actJuncRemarks){
        List<Event_Activity_Junction_Fields__c> eventActJuncFieldList = Event_Activity_Junction_Fields__c.getAll().values();
        Activity_Junction__c actJunctionParent = new Activity_Junction__c();
        if(eventActJuncFieldList != null && !eventActJuncFieldList.isEmpty()){
            for(Event_Activity_Junction_Fields__c eajf : eventActJuncFieldList){
                
                actJunctionParent.put(eajf.Target_Field_API__c, e.get(eajf.Source_Field_API__c));    
            }  
            actJunctionParent.Remarks_Analysis_Insights__c = actJuncRemarks;
        }
        
        return actJunctionParent;
    }
    
    
    @AuraEnabled
    public static integer checkEventToday(String branchId, String eventId){
        String userId = userInfo.getUserId();
        Date todayDate = Date.today();
        Integer completedEventRecCount = 0;
        Integer eventRecCount = 0;
        Integer eclRecCount = 0;
        Integer recCount = 0;
        
        /*	Primer: recCount
			0 = No Event (This will trigger the system to create one)
			1 = With Event (No pending logout or Not yet login to branch. The system will get the timestamp and location of the user)
			2 = With Event but Currently Logged In (With pending logout. The user will not be able to use the 360 Apps inside the Account Page)
			3 = With Event and Completed (The 360 Apps inside Account Page will be locked)
		*/
        
        completedEventRecCount = [
            select count()
            from Event 
            where CreatedById = :userId
            and Related_To_Account__c = :branchId
            //and StartDateTime = :todayDate
            //and Event_Type__c = 'Call'
            and Status__c = 'Completed'
            and Id = :eventId
            
        ];
       	
        eventRecCount = [
            select count()
            from Event 
            where CreatedById = :userId
            and Related_To_Account__c = :branchId
            //and StartDateTime = :todayDate
            //and Event_Type__c = 'Call'
            and Id = :eventId
            
        ];
        
        system.debug('=========> ' + eventRecCount);
        
        eclRecCount = [
            select count()
            from Event_Log__c 
            where CreatedById = :userId
            //and CreatedDate = TODAY
            and Account__c = :branchId
            and End_Date__c = null
            and Event_ID__c = :eventId
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
	/*    
    @AuraEnabled
    public static string fetchEventActivityJunctionToday(String branchId){
        String userId = userInfo.getUserId();
        Date todayDate = Date.today() ;
       
		return [
            select Activity_Junction__c
            from Event 
            where CreatedById = :userId
            and Related_To_Account__c = :branchId
            and StartDateTime = :todayDate
            and Event_Type__c = 'Call'
        ].Activity_Junction__c;     
    }*/
    
    public class ajAccountWrapper implements Comparable {
        @AuraEnabled public Account acct { get; set; }
        @AuraEnabled public Activity_Junction__c actjunction { get; set; }
        public ajAccountWrapper(Activity_Junction__c aj, Account a) {
            this.acct = a;
            this.actjunction = aj;
        }
        public Integer compareTo(Object o) {
            ajAccountWrapper that = (ajAccountWrapper) o;
            if(this.actjunction.Subject__c == null || this.actjunction.Subject__c == '') return 2;
            else if(this.actjunction.Status__c == 'Completed') return 1;
            else return 0;
        }
    }
    
    @AuraEnabled
    public static List<ajAccountWrapper> fetchActJuncAccounts(Integer workplanDay, Integer unplannedAcct) {
        Date todayDate = Date.today().addDays(workplanDay);
        Id userId = UserInfo.getUserId();
        //Integer psize = Integer.valueOf(pageSize);
        //Integer pnumber = Integer.valueOf(pageNumber)-1;
        
        List<ajAccountWrapper> ret = new List<ajAccountWrapper>();
        
        //AccountTeamMember Query
        List<AccountTeamMember> members = [SELECT Id,AccountId FROM AccountTeamMember WHERE UserId = :userId];
        
        //Get IDs for All Accounts in ATM
        Set<Id> accountIds = new Set<Id>();
        for(AccountTeamMember member : members) {
            accountIds.add(member.AccountId);
        }
        
        Account[] myAccts = [
            select id, name, branch_code__c, branch_name__c, retail_environment__c, account_group__c, mt_account_group__c
            from Account
            where Id IN :accountIds
                OR OwnerId = :userId
            //limit :Integer.valueOf(psize) OFFSET :(psize*pnumber)
        ];
        
        Map<String, Activity_Junction__c> actJunc = new Map<String, Activity_Junction__c>();
        
            for(Activity_Junction__c a : [SELECT Event_ID__c, subject__c, Related_to_Account__c, Start_Date__c, Status__c 
                                          from Activity_Junction__c 
                                          where ownerid =: UserInfo.getUserId()
                                             //and (Start_Date__c >= :yesterdayDate and Start_Date__c <= :todayDate)
                                             and (Start_Date__c = :todayDate)
                                              and Event_Type__c = 'Call'
                                         order by Start_Date__c]){
                                              actJunc.put(a.Related_to_Account__c, a);
                                          }
        
        for(Account myAcct : myAccts) {
            ajAccountWrapper w,x,y;
            if(actJunc.ContainsKey(myAcct.Id)){
                w = new ajAccountWrapper(actJunc.get(myAcct.Id),myAcct);
                y = new ajAccountWrapper(actJunc.get(myAcct.Id),myAcct);
            } else{
                w = new ajAccountWrapper(null, myAcct);         
                x = new ajAccountWrapper(null, myAcct); 
            }
            
            if (unplannedAcct <> 1 && workplanDay == 0){
            	ret.add(y);    
            }
            else if (unplannedAcct <> 1 && workplanDay == -1){
            	ret.add(y);    
            }
            else{
                ret.add(x);    
            }
            
            
        }
        ret.sort();
        System.debug('LIST WRAPPER SIZE: ' + ret.size());
        return ret;
    }
    @AuraEnabled
    public static String insertCallEvent(String branchId) {
    	
        String dateToday = Datetime.Now().format('MM/dd/yyyy');
        
        //create new event
        Event newEventRecord = new Event();
        newEventRecord = new Event(Event_Type__c = 'Call',
                             Event_Sub_type__c = 'BRANCH CALL',
                             Related_To_Account__c = branchId,
                             Mode_of_Contact__c = 'Online',
                             Location_Based__c = 'Home Base',
                             Location_Custom__c = 'Manila',
                             StartDateTime = DateTime.parse(dateToday+' '+'8:00 AM'),
                             EndDateTime = DateTime.parse(dateToday+' '+'6:00 PM'),
                             ActivityDate = Date.parse(dateToday),
                             IsAllDayEvent = false,
                             Validated__c = false,
                             Work_Plan__c = true,
                             Status__c = 'New',
                             Description = '',
                             RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('POS Event').getRecordTypeId()
                             
        );
        
        insert newEventRecord;
        
        Event eventRecord = new Event();
		
        eventRecord = [SELECT Id,
                                 Subject,
                                 OwnerId,
                                 Location_Custom__c,
                                 Event_Type__c,
                                 Location_Based__c,
                                 Mode_of_Contact__c,
                                 Event_Sub_type__c,
                                 StartDateTime,
                                 EndDateTime,
                                 Status__c,
                                 IsAllDayEvent,
                                 Reason_for_Cancellation__c,
                                 Description,
                                 Others__c,
                                 Work_Plan__c,
                                 Validated__c,
                                 WhoId,
                                 Related_To_Account__c,
                                 Activity_Junction__c,
                                 Activity_Junction__r.Remarks_Analysis_Insights__c,
                                 Target_Order__c,
                                 Actual_Order__c,
                                 Survey_Rating_Percentage__c,
                                 Amount_Collection__c,
                                 Target_Collection__c,
                                 Created_from_Classic__c,
                                 Work_With_ID__c,
                                 Work_With_Name__c,
                                 ActivityDate,
                                 Field_Work_Record_Type__c
                                 FROM Event
                                 WHERE Id = :newEventRecord.Id]; 
        //System.debug('event' + eventRecord);
       
        //create new parent Activity Junction Record
        Activity_Junction__c actJunctionParent = populateActJunc(eventRecord,'My Workplan');
        
        actJunctionParent.Event_ID__c = eventRecord.Id;
        actJunctionParent.Validated__c = eventRecord.Validated__c;
        
        // Set Activity Junction's Status to 'New'
        actJunctionParent.Status__c = 'New';
        
        
        
        // Set Activity Junction's Subject from Event's Subject
        List<Event> getEventSubject = [SELECT Subject
                                       FROM Event
                                       WHERE (Id =: eventRecord.Id)
                                      ];
        
        if (getEventSubject.size() > 0) {
            actJunctionParent.Subject__c = getEventSubject[0].Subject;
        }
        else {
            actJunctionParent.Subject__c = eventRecord.Event_Sub_type__c + '-New';
        }
        
        insert actJunctionParent;
        
        
        //System.debug('event' + actJunctionParent);
        
        //update the event record to the parent junction
        if(actJunctionParent != null){
            eventRecord =[SELECT Id,
                          Subject,
                          OwnerId,
                          Location_Custom__c,
                          Mode_of_Contact__c,
                          Event_Type__c,
                          Location_Based__c,
                          Event_Sub_type__c,
                          StartDateTime,
                          EndDateTime,
                          Status__c,
                          IsAllDayEvent,
                          Reason_for_Cancellation__c,
                          Description,
                          Others__c,
                          Work_Plan__c,
                          Validated__c,
                          WhoId,
                          Related_To_Account__c,
                          Activity_Junction__c,
                          Activity_Junction__r.Remarks_Analysis_Insights__c,
                          Target_Order__c,
                          Actual_Order__c,
                          Survey_Rating_Percentage__c,
                          Amount_Collection__c,
                          Target_Collection__c,
                          Created_from_Classic__c,
                          Work_With_ID__c,
                          Work_With_Name__c,
                          ActivityDate,
                          Field_Work_Record_Type__c
                          FROM Event
                          WHERE Id =:eventRecord.Id];
            eventRecord.Activity_Junction__c = actJunctionParent.Id;
            
            update eventRecord;
            
            //create sub activity child records
            Sub_Activity__c sa = new Sub_Activity__c();
            sa = new Sub_Activity__c(Activity_Junction__c = actJunctionParent.Id,
            						Activity_Name__c = 'TRADE CHECK BUDDY'
            );
            insert sa;
        }
        
		return branchId + '-' + eventRecord.Id + '-' + actJunctionParent.Id;  
		//return branchId + '-' + 'XXXXXXXXXXX';
    }
    
    @AuraEnabled
    public static String insertCallEventLog(String branchId, Double latitude, Double longitude){
		String userId = userInfo.getUserId();
        Date todayDate = Date.today() ;
        DateTime todayDateTime = Datetime.Now();
        
        
        String activityJunctionId = [select Activity_Junction__c
            from Event 
            where CreatedById = :userId
            and Related_To_Account__c = :branchId
            and StartDateTime = :todayDate
            and Event_Type__c = 'Call'].Activity_Junction__c;
        
        
        //Event_Log__c newEventLogRecord = new Event_Log__c();
        Event_Log__c newEventLogRecord = new Event_Log__c(Activity_Junction__c = activityJunctionId,
                                             Account__c = branchId,
                                             Latitude__c = latitude,
                                             Longitude__c = longitude,
                                             Start_Date__c = todayDateTime
        );
        insert newEventLogRecord;
        
        return newEventLogRecord.Id;
    }
    
    @AuraEnabled
    public static string endCallDraftEvent(){
        String userId = userInfo.getUserId();
        DateTime nowDate = DateTime.now();
        
        User userRecord = new User();
        userRecord = [select Id, Currently_Logged_Account_ID__c, 
                      Currently_Logged_Event_ID__c,  
                      Currently_Logged_Account_Junction_ID__c
                      from User where Id = :userId];
        
        Event_Log__c eventCallLogRecord = [select End_Date__c
            from Event_Log__c 
            where CreatedById = :userId
            //and CreatedDate = TODAY
            and Account__c = :userRecord.Currently_Logged_Account_ID__c
            and End_Date__c = null
           	and Event_Id__c = :userRecord.Currently_Logged_Event_ID__c
        ];
        
        /*
        eventCallLogRecord = [select End_Date__c
            from Event_Log__c 
            where CreatedById = :userId
            //and CreatedDate = TODAY
            and Account__c = :branchId
            and End_Date__c = null
           	and Event_Id__c = :eventId
        ];*/
        
        eventCallLogRecord.End_Date__c = nowDate;
        
        update eventCallLogRecord;
        
        return eventCallLogRecord.Id;
    }
    
    @AuraEnabled
    public static String updateUserLogged(String branchId, String eventId, String activityJunctionId) {
        String userId = userInfo.getUserId();
        
        User userRecord = new User();
        userRecord = [select Id from User where Id = :userId];
        userRecord.Currently_Logged_Account_ID__c = branchId;
        userRecord.Currently_Logged_Event_ID__c = eventId;
        userRecord.Currently_Logged_Account_Junction_ID__c = activityJunctionId;
        update userRecord;
        
        return userRecord.Id;
        
    }
}