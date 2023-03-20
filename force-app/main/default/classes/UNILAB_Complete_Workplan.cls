public class UNILAB_Complete_Workplan {
    /*@AuraEnabled
	public List<String> getModeOfContactPickList(){
       List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Event.Mode_of_Contact__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return pickListValuesList;
    }*/
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
    }*/
    
    @AuraEnabled
    public static string fetchUserLoggedAcctEvent(String branchId) {
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
        }else{eventId = 'NONE';}*/
        
        return eventId;
        
    }
    /*
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
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired){
        List<String> optionlist = new List<String>();       
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap();        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();       
        if(nullRequired == true){
            optionlist.add('--None--');
        }       
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        return optionlist;
    }
    
    /*
    @AuraEnabled
    public static string fetchEventId(String branchId){
        String userId = userInfo.getUserId();
        Date todayDate = Date.today();
        
        return[select Id
            from Event 
            where CreatedById = :userId
            and Related_To_Account__c = :branchId
            and StartDateTime = :todayDate
            and Event_Type__c = 'Call'
        ].Id;
    }*/
    
    @AuraEnabled
    public static string fetchEventMOC(String branchId, String eventId){
        
        /*String userId = userInfo.getUserId();
        Date todayDate = Date.today();
        
        String eventId = [select Id
            from Event 
           	where CreatedById = :userId
            and Related_To_Account__c = :branchId
            and StartDateTime = :todayDate
            and Event_Type__c = 'Call'
        ].Id;*/
        
        return [select Mode_of_Contact__c
                from Event
                where Id = :eventId
        ].Mode_of_Contact__c;
    }
    
    @AuraEnabled
    public static string fetchEventLocBase(String branchId, String eventId){
        /*String userId = userInfo.getUserId();
        Date todayDate = Date.today();
        
        String eventId = [select Id
            from Event 
            where CreatedById = :userId
            and Related_To_Account__c = :branchId
            and StartDateTime = :todayDate
            and Event_Type__c = 'Call'
        ].Id;*/
        
        return [select Location_Based__c
                from Event
                where Id = :eventId
        ].Location_Based__c;
    }
    
    @AuraEnabled
    public static string fetchEventLoc(String branchId, String eventId){
        /*String userId = userInfo.getUserId();
        Date todayDate = Date.today();
        
        String eventId = [select Id
            from Event 
            where CreatedById = :userId
            and Related_To_Account__c = :branchId
            and StartDateTime = :todayDate
            and Event_Type__c = 'Call'
        ].Id;*/
        
        return [select Location_Custom__c
                from Event
                where Id = :eventId
        ].Location_Custom__c;
    }
    
    @AuraEnabled
    public static string saveWorkplan(String branchId, String eventId, String modeOfContact, String locationBase, String location, String description){
        
        String userId = userInfo.getUserId();
        
        Event eventRecord = new Event();
        /*
        eventRecord = [SELECT Id, Mode_of_Contact__c, Location_Based__c, Location_Custom__c, Description
                                       FROM Event
                                       WHERE (Id =:eventId)
                                      ];
        
        eventRecord.Mode_of_Contact__c = modeOfContact;
        eventRecord.Location_Based__c = locationBase;
        eventRecord.Location_Custom__c = location;
        eventRecord.Description = description;
        
        update eventRecord;
        
        Activity_Junction__c ajRecord = new Activity_Junction__c();
        
        ajRecord = [SELECT Mode_of_Contact__c, Location_Based__c, Location__c, Description__c
                    FROM Activity_Junction__c
                    WHERE (Event_ID__c =:eventId)
                   ];
        
        ajRecord.Mode_of_Contact__c = modeOfContact;
        ajRecord.Location_Based__c = locationBase;
        ajRecord.Location__c = location;
        ajRecord.Description__c = description;
        
        update ajRecord;        
        */
        
        Map<Id, Event> eventRec = new Map<Id, Event>();
        eventRec.put(eventId, new Event(Id=eventId, Mode_of_Contact__c=modeOfContact, Location_Based__c = locationBase, Location_Custom__c = location, Description = description));
        update eventRec.values();
        
        String ajId = [select Id, Currently_Logged_Account_Junction_ID__c
                      from User where Id = :userId].Currently_Logged_Account_Junction_ID__c;
        
        Map<Id, Activity_Junction__c> ajRec = new Map<Id, Activity_Junction__c>();
        ajRec.put(ajId, new Activity_Junction__c(Id=ajId, Mode_of_Contact__c=modeOfContact, Location_Based__c = locationBase, Location__c = location, Description__c = description));
        update ajRec.values();
        
        return eventId;
    }
    
    @AuraEnabled
    public static string submitWorkplan(String branchId, String eventId){
        
        Activity_Junction__c ajRecord = new Activity_Junction__c();
        
        ajRecord = [SELECT Status__c
                    FROM Activity_Junction__c
                    WHERE (Event_ID__c =:eventId)
                   ];
        
        ajRecord.Status__c = 'Completed';
        
        update ajRecord;    
        
        Event eventRecord = new Event();
        
        eventRecord = [SELECT Status__c
                                       FROM Event
                                       WHERE (Id =:eventId)
                                      ];
        
        eventRecord.Status__c = 'Completed';
        
        update eventRecord;

        return eventRecord.Id;
    }
    
    @AuraEnabled
    public static string endCall(String branchId, String eventId){
        String userId = userInfo.getUserId();
        Date todayDate = Date.today();
        DateTime nowDate = DateTime.now();
        
        Event_Log__c eventCallLogRecord = new Event_Log__c();
        
        eventCallLogRecord = [select Id, End_Date__c
            from Event_Log__c 
            where CreatedById = :userId
            //and CreatedDate = TODAY
            and Account__c = :branchId
            and End_Date__c = null
            and Event_ID__c = :eventId
        ];
        
        eventCallLogRecord.End_Date__c = nowDate;
        
        update eventCallLogRecord;
        
        updateUserLogged();
        
        return eventCallLogRecord.Id;
    }
    
    public static void updateUserLogged() {
        String userId = userInfo.getUserId();
        
        User userRecord = new User();
        userRecord = [select Id from User where Id = :userId];
        userRecord.Currently_Logged_Account_ID__c = null;
        userRecord.Currently_Logged_Event_ID__c = null;
        userRecord.Currently_Logged_Account_Junction_ID__c = null;
        update userRecord;
    }
}