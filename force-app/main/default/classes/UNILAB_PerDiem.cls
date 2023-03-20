public class UNILAB_PerDiem {
    /* wrapper class */  
    public class EventListWrapper {
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  Event objEvent{get;set;}
        public eventListWrapper(boolean isChecked, Event objEvent){
            this.isChecked = isChecked;
            this.objEvent = objEvent;
        }
    }
    
	@AuraEnabled
    public static List<EventListWrapper> fetch(string recordID, String startDate, String endDate, String pageSize, String pageNumber) {
        //Integer psize = Integer.valueOf(pageSize);
        //Integer pnumber = Integer.valueOf(pageNumber)-1;
        String userId = userInfo.getUserId();
        //System.debug(userId);
        List<EventListWrapper> activity = new List<EventListWrapper>();
        
        if(startDate!=null || endDate!=null) {
            Date startD = Date.valueOf(startDate);
       		Date endD = Date.valueOf(endDate);
            for(Event evnt : [SELECT Id,
                                    EndDate,
                                    Event_Sub_type__c,
                                    Event_Type__c,
                                    Location_Based__c,
                                    Location_Custom__c,
                                    Mode_of_Contact__c,
                                    Owner.Name,
                                    Related_To_Account__r.Name,
                                    StartDateTime,
                                    Status__c,
                                    Activity_Junction__c,
                                    CreatedById
                                FROM Event
                                WHERE (Activity_Junction__c NOT IN (SELECT Activity_Junction__c
                                                                    FROM Per_Diem_Item__c
                                                                    WHERE CreatedById=:userId)) 
                                AND (Status__c='Completed' 
                                              OR Status__c='Missed')
                                AND (DAY_ONLY(StartDateTime)>=:startD 
                                     AND DAY_ONLY(StartDateTime)<=:endD)
                              	AND CreatedById=:userId
                                
                                ORDER BY StartDateTime ASC
                                //LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)
                                //LIMIT 50
                               ]) {
                activity.add(new EventListWrapper(false, evnt));
            }
        } else {
            for(Event evnt : [SELECT Id,
                                    EndDate,
                                    Event_Sub_type__c,
                                    Event_Type__c,
                                    Location_Based__c,
                                    Location_Custom__c,
                                    Mode_of_Contact__c,
                                    Owner.Name,
                                    Related_To_Account__r.Name,
                                    StartDateTime,
                                    Status__c,
                                    Activity_Junction__c,
                                    CreatedById
                                FROM Event 
                                WHERE (Activity_Junction__c NOT IN (SELECT Activity_Junction__c
                                                                    FROM Per_Diem_Item__c
                                                                    WHERE CreatedById=:userId)) 
                                AND (Status__c='Completed' 
                                              OR Status__c='Missed')
                              	AND CreatedById=:userId
                                ORDER BY StartDateTime ASC
                             //   LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)
                             //LIMIT 50
                             ]) {
                activity.add(new EventListWrapper(false, evnt));
            }
        }
        return activity;
    }
    
    @AuraEnabled
    public static String onSubmit(List<Event> eventData, List<Per_Diem_Item__c> perdiemData, String recordID) {
        
        Per_Diem__c subActivityRep = new Per_Diem__c();
        
        if (eventData.size() > 0) {
            
            if (String.isBlank(recordID)) {
                
                subActivityRep = 
                    new Per_Diem__c(Approval_Status__c = 'Draft',
                                    RecordTypeId = Schema.SObjectType.Per_Diem__c.getRecordTypeInfosByName().get('Per Diem').getRecordTypeId());
                
                insert subActivityRep;
            }
            
            List<Per_Diem_Item__c> subActivityReportLineItemList = new List<Per_Diem_Item__c>();
	        List<Id> createdUserIds = new List<Id>();
            Per_Diem_Item__c subActivityReportLineItem = new Per_Diem_Item__c();
    
            for (Integer i = 0; i < eventData.size(); i++) {
                Date startDate = Date.newInstance(eventData[i].StartDateTime.year(), eventData[i].StartDateTime.month(), eventData[i].StartDateTime.day());
                Integer numDays = startDate.daysBetween(eventData[i].EndDate);
                if(numDays==0){
                    numDays=1;
                }
                subActivityReportLineItem = new Per_Diem_Item__c(
                    Activity_Junction__c = eventData[i].Activity_Junction__c,
                    Exemption_Remarks__c = perdiemData[i].Exemption_Remarks__c,
                    HB_OHB__c = eventData[i].Location_Based__c,
                    Place_of_Work__c = eventData[i].Location_Custom__c,
                    CreatedById = eventData[i].CreatedById,
                    Number_of_Days__c = numDays,
                    RecordTypeId = Schema.SObjectType.Per_Diem_Item__c.getRecordTypeInfosByName().get('Per Diem').getRecordTypeId(),
                    Sub_Activity_Report__c = subActivityRep.Id);
                
                subActivityReportLineItemList.add(subActivityReportLineItem);
                createdUserIds.add(eventData[i].CreatedById);
            }
            
            List<User> employeeNumberList = [SELECT Id, EmployeeNumber FROM User WHERE Id IN:createdUserIds];
            List<Per_Diem_Item__c> mergeResultList = new List<Per_Diem_Item__c>();
            
            Per_Diem_Item__c mergeResult = new Per_Diem_Item__c();
            
            for(Integer evnt = 0; evnt < employeeNumberList.size(); evnt++) {
                for(Integer perdiemItem = 0; perdiemItem < subActivityReportLineItemList.size(); perdiemItem++ ) {
                    if(employeeNumberList[evnt].Id == subActivityReportLineItemList[perdiemItem].CreatedById) {
                        mergeResult = new Per_Diem_Item__c(
                            Activity_Junction__c = subActivityReportLineItemList[perdiemItem].Activity_Junction__c,
                            Exemption_Remarks__c = subActivityReportLineItemList[perdiemItem].Exemption_Remarks__c,
                            HB_OHB__c = subActivityReportLineItemList[perdiemItem].HB_OHB__c,
                            Place_of_Work__c = subActivityReportLineItemList[perdiemItem].Place_of_Work__c,
                            Employee_ID__c = employeeNumberList[evnt].EmployeeNumber,
                            Division__c = 'S&CD',
                            Number_of_Days__c = subActivityReportLineItemList[perdiemItem].Number_of_Days__c,
                            RecordTypeId = subActivityReportLineItemList[perdiemItem].RecordTypeId,
                            Sub_Activity_Report__c = subActivityReportLineItemList[perdiemItem].Sub_Activity_Report__c);
                        mergeResultList.add(mergeResult);
                    }
                 }
            }
            if (String.isBlank(recordID)) {
                insert mergeResultList;
                update eventData;
            }
        }
        return subActivityRep.Id;
    }
    
    /***EDIT***/
    @AuraEnabled
    public static List<EventListWrapper> fetchExist(String recordID) {
        String userId = userInfo.getUserId();        
        List<EventListWrapper> activity = new List<EventListWrapper>();
        if(String.isNotBlank(recordID)) {
            Per_Diem__c perdiem = [SELECT Id FROM Per_Diem__c WHERE Id=:recordID];
            List<Per_Diem_Item__c> perdiemItemList = [SELECT Id,
                                                      	Activity_Junction__c,
                                                        Exemption_Remarks__c,
                                                        HB_OHB__c,
                                                        Place_of_Work__c,
                                                        CreatedById,
                                                        Number_of_Days__c,
                                                        Sub_Activity_Report__c 
                                                FROM Per_Diem_Item__c 
                                                WHERE Sub_Activity_Report__c =: perdiem.Id];
            
            Set<Id> activityJunc = new Set<Id>();
            for(Per_Diem_Item__c perdiemItem : perdiemItemList) {
            	activityJunc.add(perdiemItem.Activity_Junction__c);    
            }
            
            activity = getExistEvent(activityJunc, perdiemItemList);
            
        }
        return activity;
    }
    
    private static List<EventListWrapper> getExistEvent(Set<Id> activityJunc, List<Per_Diem_Item__c> perdiemItemList) {
       List<EventListWrapper> activity = new List<EventListWrapper>();
       List<Event> evntList = [SELECT Id,
                                        EndDate,
                                        Event_Sub_type__c,
                                        Event_Type__c,
                                        Location_Based__c,
                                        Location_Custom__c,
                                        Mode_of_Contact__c,
                                        Owner.Name,
                                    	Related_To_Account__r.Name,
                                        StartDateTime,
                                        Status__c,
                                        Activity_Junction__c,
                                        CreatedById
                               FROM Event 
                               WHERE ((Planned_Unplanned__c = 'Planned' 
                                       AND (Status__c='Missed' 
                                            OR Status__c='Cancelled' 
                                            OR Status__c='Completed'))
                                      OR (Planned_Unplanned__c = 'Unplanned' 
                                          AND Status__c='Completed')) AND Activity_Junction__c IN :activityJunc
                               ORDER BY StartDateTime ASC
                               //   LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)
                               //   LIMIT 50
                              ];
        
            for(Event evnt : evntList) {
                for(Per_Diem_Item__c pdItem : perdiemItemList) {
                    if(evnt.Activity_Junction__c == pdItem.Activity_Junction__c){                       
                        activity.add(new EventListWrapper(true, evnt));   
                    }
                }
                
            }
        return activity;
    }
    
    @AuraEnabled
    public static void onUpdate(List<Event> eventData, List<Per_Diem_Item__c> perdiemData, List<Event> existEventData, List<Per_Diem_Item__c> existPerdiemData, List<Per_Diem_Item__c> removeEventData,String recordID) {
        
        Per_Diem__c subActivityRep = [SELECT Id, Name, Approval_Status__c FROM Per_Diem__c WHERE Id=: recordID];
        
        if (existEventData.size() > 0) {
            List<Per_Diem_Item__c> subActivityRepItem = [SELECT Id, Activity_Junction__c FROM Per_Diem_Item__c 
                                                         WHERE Sub_Activity_Report__c=: recordID];
            
            List<Per_Diem_Item__c> existItemList = new List<Per_Diem_Item__c>();
            Per_Diem_Item__c existItem = new Per_Diem_Item__c();
    
            for (Integer i = 0; i < existEventData.size(); i++) {
                Date startDate = Date.newInstance(existEventData[i].StartDateTime.year(), existEventData[i].StartDateTime.month(), existEventData[i].StartDateTime.day());
                Integer numDays = startDate.daysBetween(existEventData[i].EndDate);
                if(numDays==0){
                    numDays=1;
                }
                String exemptRemarks = '';
                String itemId = '';
                
                if(String.isNotBlank(existPerdiemData[i].Exemption_Remarks__c)) {
                    exemptRemarks = existPerdiemData[i].Exemption_Remarks__c;
                }
                for(Integer item = 0; item < subActivityRepItem.size(); item++) {
                    if(subActivityRepItem[item].Activity_Junction__c == existEventData[i].Activity_Junction__c) {
                        itemId = subActivityRepItem[item].Id;
                    }
                }
                
                existItem = new Per_Diem_Item__c(Id=itemId,
                                                 Activity_Junction__c = existEventData[i].Activity_Junction__c,
                                                 Exemption_Remarks__c = exemptRemarks,
                                                 HB_OHB__c = existEventData[i].Location_Based__c,
                                                 Place_of_Work__c = existEventData[i].Location_Custom__c,
                                                 CreatedById = existEventData[i].CreatedById,
                                                 Number_of_Days__c = numDays);
                
                existItemList.add(existItem);
            }
            if (String.isNotBlank(recordID)) {
                update existItemList;
                update existEventData;
            }
        }
        if (eventData.size() > 0) {            
            List<Per_Diem_Item__c> subActivityReportLineItemList = new List<Per_Diem_Item__c>();
	        List<Id> createdUserIds = new List<Id>();
            Per_Diem_Item__c subActivityReportLineItem = new Per_Diem_Item__c();
    
            for (Integer i = 0; i < eventData.size(); i++) {
                Date startDate = Date.newInstance(eventData[i].StartDateTime.year(), eventData[i].StartDateTime.month(), eventData[i].StartDateTime.day());
                Integer numDays = startDate.daysBetween(eventData[i].EndDate);
                if(numDays==0){
                    numDays=1;
                }
                subActivityReportLineItem = new Per_Diem_Item__c(
                    Activity_Junction__c = eventData[i].Activity_Junction__c,
                    Exemption_Remarks__c = perdiemData[i].Exemption_Remarks__c,
                    HB_OHB__c = eventData[i].Location_Based__c,
                    Place_of_Work__c = eventData[i].Location_Custom__c,
                    CreatedById = eventData[i].CreatedById,
                    Number_of_Days__c = numDays,
                    RecordTypeId = Schema.SObjectType.Per_Diem_Item__c.getRecordTypeInfosByName().get('Per Diem').getRecordTypeId(),
                    Sub_Activity_Report__c = recordID);
                
                subActivityReportLineItemList.add(subActivityReportLineItem);
                createdUserIds.add(eventData[i].CreatedById);
            }
            
            List<User> employeeNumberList = [SELECT Id, EmployeeNumber FROM User WHERE Id IN:createdUserIds];
            List<Per_Diem_Item__c> mergeResultList = new List<Per_Diem_Item__c>();
            
            Per_Diem_Item__c mergeResult = new Per_Diem_Item__c();
            
            for(Integer evnt = 0; evnt < employeeNumberList.size(); evnt++) {
                for(Integer perdiemItem = 0; perdiemItem < subActivityReportLineItemList.size(); perdiemItem++ ) {
                    if(employeeNumberList[evnt].Id == subActivityReportLineItemList[perdiemItem].CreatedById) {                        mergeResult = new Per_Diem_Item__c(
                            Activity_Junction__c = subActivityReportLineItemList[perdiemItem].Activity_Junction__c,
                            Exemption_Remarks__c = subActivityReportLineItemList[perdiemItem].Exemption_Remarks__c,
                            HB_OHB__c = subActivityReportLineItemList[perdiemItem].HB_OHB__c,
                            Place_of_Work__c = subActivityReportLineItemList[perdiemItem].Place_of_Work__c,
                            Employee_ID__c = employeeNumberList[evnt].EmployeeNumber,
                            Division__c = 'S&CD',
                            Number_of_Days__c = subActivityReportLineItemList[perdiemItem].Number_of_Days__c,
                            RecordTypeId = subActivityReportLineItemList[perdiemItem].RecordTypeId,
                            Sub_Activity_Report__c = subActivityReportLineItemList[perdiemItem].Sub_Activity_Report__c);
                        mergeResultList.add(mergeResult);
                    }
                 }
            }
            if (String.isNotBlank(recordID)) {
                upsert mergeResultList;
                update existEventData;
            }
        }
        
         onRemove(removeEventData, recordID);
       
    }
     
    private static void onRemove(List<Per_Diem_Item__c> removeEventData, String recordID) {
        List<Per_Diem_Item__c> subActivityRepItem = [SELECT Id, Activity_Junction__c FROM Per_Diem_Item__c 
                                                         WHERE Sub_Activity_Report__c=: recordID];
        Set<Per_Diem_Item__c> noDupli = new Set<Per_Diem_Item__c>();
        List<Per_Diem_Item__c> removeItemList = new List<Per_Diem_Item__c>();
        if(removeEventData.size()>0) {
            for(Integer i=0; i<removeEventData.size(); i++) {
                for(Per_Diem_Item__c item: subActivityRepItem) {
                    if(removeEventData[i].Activity_Junction__c == item.Activity_Junction__c) {
                        if(noDupli.add(item)) {
                            removeItemList.add(item);
                        }
                    }
                }
        	}
            
            if(removeItemList.size()>0) {
                delete removeItemList;
            }
        }
    }
    
    @AuraEnabled
    public static Per_Diem__c getApprovalStatus(String recordID) {
        Boolean isEdit = false;
        Per_Diem__c perdiem = new Per_Diem__c();
        
        if(String.isNotBlank(recordID)) {
            perdiem = [SELECT Approval_Status__c, Processed_by_Admin__c FROM Per_Diem__c WHERE Id=:recordID];
        }
        return perdiem;
    }
    
    @AuraEnabled
    public static void updateProcessedByAdmin(String recordID) {
        if(String.isNotBlank(recordID)) {
            Per_Diem__c perdiem = new Per_Diem__c(Id = recordID,
                                                 Processed_by_Admin__c = true);
            update perdiem;
        }
    }
}