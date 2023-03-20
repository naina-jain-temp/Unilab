public class UNILAB_CLI {
	@AuraEnabled
    public static List<public_data_cli__x> fetch(string recordID){
       
        List<public_data_cli__x> acc = [SELECT Id, due_date__c, ui__c, rt__c, ulssi__c, phx__c
                                                    FROM public_data_cli__x
                                                   	WHERE sfa_account_id__c = :recordID
                                       				AND due_date__c = THIS_MONTH
                                       ORDER BY due_date__c];
        return acc;
    }
    
    @AuraEnabled
    public static string fetchEA(string recordID){
        String userId = userInfo.getUserId();
        Date todayDate = Date.today();
        
        return [SELECT Id FROM Event WHERE CreatedById = :userId 
                                          AND Related_To_Account__c = :recordId
                                          AND StartDateTime = :todayDate
                          					  AND Event_Type__c = 'Call'
                                     		Limit 1].Id;
        
        /*
        List<Event> ea = [SELECT Id FROM Event WHERE CreatedById = :userId 
                                          AND Related_To_Account__c = :recordId
                                          AND StartDateTime = :todayDate
                          				  AND Event_Type__c = 'Call'
                                     		Limit 1
                                         ];
        
        List<String> ea2 = new List<String>();
        
        for(Event ea3 : ea){
            ea2.add(ea3.Id);
        }
        return ea2[0];
        */
    }
    
    @AuraEnabled
    public static List<Sub_Activity__c> fetchESA(string recordID){
        String userId = userInfo.getUserId();
        Date todayDate = Date.today() ;
        
        List<Event> activityJunctionId = [SELECT Activity_Junction__c FROM Event WHERE CreatedById = :userId 
                                          AND Related_To_Account__c = :recordId
                                     		//Limit 1
                                         ];
        List<String> activityJunctionId2 = new List<String>();
        
        for(Event event2 : activityJunctionId){
            activityJunctionId2.add(event2.Activity_Junction__c);
        }
        
        
        List<Sub_Activity__c> esa = [SELECT Id, Name, Activity_Junction__c, Activity__c, CreatedDate, Learnings_Insights__c, Show_Sub_Activity__c
                                                    FROM Sub_Activity__c
                                                   	WHERE Activity_Junction__c in :activityJunctionId2
                                     		AND Activity__c = 'COLLECTION'
                                     Order By CreatedDate Desc
                                    Limit 10
                                    ];
        
        return esa;
        
    }
    /*
    public class SaveRecordParameters {
        @AuraEnabled public List<String> keyFieldList { get; set; }
    }
    */
    
    @AuraEnabled
    public static void saveForm(List<public_data_cli__x> lstKF, String recordID, String journalBox) {
        
        String userId = userInfo.getUserId();
        Date todayDate = Date.today() ;
        
        /* START: Get the Activity Junction from Event Object and Insert Sub-Activity */
		
        List<Event> activityJunctionId = [SELECT Activity_Junction__c FROM Event WHERE CreatedById = :userId 
                                          AND Related_To_Account__c = :recordId
                                          AND StartDateTime = :todayDate
                                     		Limit 1
                                         ];
        List<String> activityJunctionId2 = new List<String>();
        
        for(Event event2 : activityJunctionId){
            activityJunctionId2.add(event2.Activity_Junction__c);
        }
        
        List<Sub_Activity__c> subActivityList = new List<Sub_Activity__c>();
        
        
        
        /* END: Get the Activity Junction from Event Object and Insert Sub-Activity */
        
        /* START: Insert Priorities */
        
        List<String> Activity = new List<String>();
        
        List<public_data_cli__x> rf = [SELECT descr__c FROM public_data_cli__x WHERE Id IN :lstKF];
        
        for(public_data_cli__x rf2 : rf){
            Activity.add(rf2.descr__c);
        }
        
        List<Priority__c> priorityCheckList = new List<Priority__c>();
        
        Sub_Activity__c subActivityListItem = new Sub_Activity__c(Activity_Junction__c = activityJunctionId2[0],
                                                            Activity_Name__c = 'COLLECTION',
                                                            Learnings_Insights__c = journalBox
                                                           );
        
        insert subActivityListItem;
        
        
        Integer c1 = 0;
        for (String keyFieldRec : Activity) {
            
            Priority__c priorityCheckListItem = new Priority__c(Name = keyFieldRec,
                                                                Status__c = 'Available',
                                                                Sub_Activity__c = subActivityListItem.Id,
                                                                RecordTypeId = Schema.SObjectType.Priority__c.getRecordTypeInfosByName().get('COLLECTION').getRecordTypeId()
                                                               );
            priorityCheckList.add(priorityCheckListItem);
            c1 = c1 + 1;
        }    
        
        /* END: Insert Priorities */
        
        
        insert priorityCheckList;
    }
    
}