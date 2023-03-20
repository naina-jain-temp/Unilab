/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.18.2017
Definition   :   Trigger for Survey Summary Form
History      :   07.18.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
trigger UNILAB_SubActivityTrigger on Sub_Activity__c(after insert)
{
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            UNILAB_SubActivityTriggerHandler.onAfterInsert(Trigger.New);
        }
    }
}