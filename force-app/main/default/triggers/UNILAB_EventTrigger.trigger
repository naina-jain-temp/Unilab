/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.18.2017
Definition   :   Trigger for Event
History      :   07.18.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
trigger UNILAB_EventTrigger on Event (before delete, after insert, after update,before insert)
{
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            //call beforeDelete method on handler
            UNILAB_EventTriggerHandler.OnBeforeDelete(Trigger.Old);
        }
        if(Trigger.isInsert){
            
            for(Event e : Trigger.New){
                if(date.today().day() > 7 && e.StartDateTime.month() == date.today().month()){
                    e.Work_Plan__c = false;
                }else{
                    e.Work_Plan__c = true;
                }
            }
  
            
        }
        
    }else if(Trigger.isAfter){
        if(Trigger.isInsert){
            UNILAB_EventTriggerHandler.onAfterInsert(Trigger.New);
            
            
        }else if(Trigger.isUpdate){
            UNILAB_EventTriggerHandler.onAfterUpdate(Trigger.New, Trigger.oldMap);
        }
    }
}