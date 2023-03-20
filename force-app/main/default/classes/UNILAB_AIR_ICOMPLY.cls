public class UNILAB_AIR_ICOMPLY {
    
	@AuraEnabled
    public static List<public_vw_data_icomply_wprio__x> fetch(string recordID){
        List<public_vw_data_icomply_wprio__x> icmp = [SELECT Id, name__c
                                                    FROM public_vw_data_icomply_wprio__x];
        return icmp;
    }
    
    
    @AuraEnabled
    public static string fetchEA(string recordID){
        String userId = userInfo.getUserId();
        Date todayDate = Date.today() ;
        
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
                                     		AND 	Activity_Name__c = 'ICOMPLY'
                                     Order By CreatedDate Desc
                                    Limit 10
                                    ];
        
        return esa;
        
    }
    
    public class SaveRecordParameters {
        
        @AuraEnabled public String recordID { get; set; }
        @AuraEnabled public List<String> mydata { get; set; }
        @AuraEnabled public List<String> productComment { get; set; }
        @AuraEnabled public String journalBox { get; set; }
        
    }
    
    //Record Submission
    @AuraEnabled
    public static void submitRecord(String recordParameters) {
    	//if (String.isNotBlank(recordParameters)) {
            SaveRecordParameters recordParams = (SaveRecordParameters) JSON.deserialize(recordParameters, SaveRecordParameters.class);
            
         	String recordID = recordParams.recordID;
            List<String> mydata = recordParams.mydata;
            List<String> productComment = recordParams.productComment;
        	String journalBox = recordParams.journalBox;
            
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
            
            Sub_Activity__c subActivityListItem = new Sub_Activity__c(Activity_Junction__c = activityJunctionId2[0],
                                                            Activity_Name__c = 'ICOMPLY',
                                                            Learnings_Insights__c = journalBox
                                                           );
        
        	insert subActivityListItem;
            
            /* END: Get the Activity Junction from Event Object and Insert Sub-Activity  */
            
            List<Priority__c> priorityCheckList = new List<Priority__c>();
            
            Integer count = 0;
            for (String productIDRec : mydata) {
                Priority__c priorityCheckListItem = new Priority__c(Name = productIDRec,
                                                                //Status__c = 'Available',
                                                                Value__c = decimal.valueOf(productComment[count]),     
                                                                //Status__c = productComment[count],     
                                                                Sub_Activity__c = subActivityListItem.Id,
                                                                RecordTypeId = Schema.SObjectType.Priority__c.getRecordTypeInfosByName().get('ICOMPLY').getRecordTypeId()
                                                                       );
                priorityCheckList.add(priorityCheckListItem);
                count = count + 1;
            }
            
            insert priorityCheckList;
            
            
        //}
    
    }
}