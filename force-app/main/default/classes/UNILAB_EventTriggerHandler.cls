/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.18.2017
Definition   :   Event Trigger Handler
History      :   07.18.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
public class UNILAB_EventTriggerHandler{
    
 
    public static void onAfterInsert(List<Event> newEventList){
        for(Event e: newEventList){
            system.debug(e.Work_Plan__c);
        }
        setSurveyEventEndDate(newEventList);
    }
    
    public static void onAfterUpdate(List<Event> newEventList, Map<Id,Event> oldEventMap){
        
        List<Event> eventToProcessList = new List<Event>();
        List<Event> eventCopyActJuncList = new List<Event>();
        List<Event_Activity_Junction_Fields__c> eventActJuncFieldList = Event_Activity_Junction_Fields__c.getAll().values();
        List<Event_Activity_Junction_Fields__c> fieldApiWithChangesList = new List<Event_Activity_Junction_Fields__c>();
        for(Event e : newEventList){
            Event oldEvent = oldEventMap.get(e.Id);
            if(e.EndDateTime.date() != oldEvent.EndDateTime.date()){
                eventToProcessList.add(e);
            }

            if(eventActJuncFieldList != null && !eventActJuncFieldList.isEmpty()){
                for(Event_Activity_Junction_Fields__c eajf : eventActJuncFieldList){

                    if(e.get(eajf.Source_Field_API__c) != oldEvent.get(eajf.Source_Field_API__c)){
                        eventCopyActJuncList.add(e);
                        fieldApiWithChangesList.add(eajf);
                    }
                }   
            }
        } 
        
        //call method to update 
        if(eventToProcessList != null && !eventToProcessList.isEmpty()){
            setSurveyEventEndDate(eventToProcessList);
        }
        if(eventCopyActJuncList != null && !eventCopyActJuncList.isEmpty()){
            updateActivityJunctionFields(eventCopyActJuncList, eventActJuncFieldList);
        }
    } 
    
    public static void OnBeforeDelete(List<Event> oldEventList){
        Set<Id> actJuncIdSet = new Set<Id>();
        for(Event e : oldEventList){
            if(Validation_Rules__c.getInstance().Event_Deletion_Trigger__c == true){
                e.addError('You do not have access to delete an event.');
            }else{
                //collect activity junction ids to be deleted
                actJuncIdSet.add(e.Activity_Junction__c);
            }
        }
        
        if(actJuncIdSet!= null && !actJuncIdSet.isEmpty()){
            List<Activity_Junction__c> actJuncList = [SELECT Id FROM Activity_Junction__c WHERE Id IN: actJuncIdSet];
            if(actJuncList != null && !actJuncList.isEmpty()){
                delete actJuncList;
            }
        }
    }
    
    public static void setSurveyEventEndDate(List<Event> eventList){
        Set<Id> eventIdSet = new Set<Id>();
        for(Event e : eventList){
            eventIdSet.add(e.Id);
        }
        
        List<Event> eventRecList = [SELECT Id, Activity_Junction__c, EndDateTime FROM Event WHERE Id IN: eventIdSet];
        
        if(eventRecList != null && !eventRecList.isEmpty()){
            Set<Id> actJunctionIdSet = new Set<Id>();
            for(Event e : eventRecList){
                actJunctionIdSet.add(e.Activity_Junction__c);
            }
            
            if(actJunctionIdSet != null && !actJunctionIdSet.isEmpty()){
                List<Sub_Activity__c> subActList = [SELECT Id,
                                                           Survey_Summary_Form__c,
                                                           Survey_Summary_Form__r.Event_End_Date__c,
                                                           Activity_Junction__c 
                                                    FROM Sub_Activity__c
                                                    WHERE Survey_Summary_Form__c != null
                                                    AND Activity_Junction__c IN: actJunctionIdSet];
                                                    
                if(subActList != null && !subActList.isEmpty()){
                    List<Survey_Summary_Form__c> ssfToUpdateList = new List<Survey_Summary_Form__c>();
                    for(Event e : eventRecList){
                        for(Sub_Activity__c sa : subActList){
                            if(e.Activity_Junction__c == sa.Activity_Junction__c){
                                //sa.Survey_Summary_Form__r.Event_End_Date__c = e.EndDateTime.date();
                                ssfToUpdateList.add(new Survey_Summary_Form__c(Id = sa.Survey_Summary_Form__c,
                                                                               Event_End_Date__c = e.EndDateTime.date()));
                            }    
                        }
                    }
                    
                    if(ssfToUpdateList != null && !ssfToUpdateList.isEmpty()){
                        update ssfToUpdateList;
                    }
                }
            }
        }
    }

    public static void updateActivityJunctionFields(List<Event> eventList, List<Event_Activity_Junction_Fields__c> eventActAPIList){
        Set<Id> actJunctionIdSet = new Set<Id>();

        for(Event e : eventList){
            actJunctionIdSet.add(e.Activity_Junction__c);
        }

        if(actJunctionIdSet != null && !actJunctionIdSet.isEmpty()){
            String queryString = 'SELECT Id,Event_ID__c,';
            for(Event_Activity_Junction_Fields__c eajf : eventActAPIList){
                queryString = queryString + eajf.Target_Field_API__c +',';
            }
            queryString = queryString.removeEnd(',');
            queryString = queryString + ' FROM Activity_Junction__c WHERE Id IN: actJunctionIdSet';
            List<Activity_Junction__c> actJuncToUpdateList = Database.query(queryString);

            if(actJuncToUpdateList != null && !actJuncToUpdateList.isEmpty()){
                for(Event e : eventList){
                    for(Activity_Junction__c aj : actJuncToUpdateList){
                        if(aj!=null && aj.Event_ID__c!=null){
                            if(aj.Event_ID__c.contains(String.valueOf(e.Id))){
                                for(Event_Activity_Junction_Fields__c eajf : eventActAPIList){
                                    aj.put(eajf.Target_Field_API__c, e.get(eajf.Source_Field_API__c));
                                }
                            }
                        }
                    }
                }

                update actJuncToUpdateList;
            }
        }
    }
    

	
   
}