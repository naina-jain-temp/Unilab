/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.18.2017
Definition   :   SSF Trigger Handler
History      :   07.18.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
public class UNILAB_SubActivityTriggerHandler{
    
    public static void onAfterInsert(List<Sub_Activity__c> newSaList){
        getEventEndDate(newSaList);
    }
    
    public static void getEventEndDate(List<Sub_Activity__c> subActList){
        Set<Id> ssfIdSet = new Set<Id>();
        //system.Debug('**ssfList:'+ssfList);
        for(Sub_Activity__c sa : subActList){
            ssfIdSet.add(sa.Survey_Summary_Form__c);
        }
        system.Debug('**ssfIdSet:'+ssfIdSet);
        List<Sub_Activity__c> subActListToProcess = [SELECT Id,
                                                   Activity_Junction__c,
                                                   Activity_Junction__r.End_Date__c,
                                                   Survey_Summary_Form__c,
                                                   Survey_Summary_Form__r.Event_End_Date__c 
                                            FROM Sub_Activity__c
                                            WHERE Survey_Summary_Form__c IN: ssfIdSet
                                            LIMIT 45000];
        system.Debug('**subActList:'+subActListToProcess);                                    
        if(subActListToProcess != null && !subActListToProcess.isEmpty()){
            List<Survey_Summary_Form__c> ssfToUpdateList = new List<Survey_Summary_Form__c>();
            Set<Id> ssfDupChkr = new Set<Id>();
            for(Sub_Activity__c sa : subActListToProcess){
                if(!ssfDupChkr.contains(sa.Survey_Summary_Form__c)){
                    if(sa.Survey_Summary_Form__c != null && sa.Activity_Junction__r.End_Date__c != null ){
                        ssfToUpdateList.add(new Survey_Summary_Form__c(Id = sa.Survey_Summary_Form__c,
                                                                           Event_End_Date__c = sa.Activity_Junction__r.End_Date__c.date()));
                        ssfDupChkr.add(sa.Survey_Summary_Form__c);
                    }
                }  
            }
            
            if(ssfToUpdateList != null && !ssfToUpdateList.isEmpty()){
                /*List<Survey_Summary_Form__c> toUpdateList = new List<Survey_Summary_Form__c>();
                toUpdateList.addAll(ssfToUpdateList);*/
                update ssfToUpdateList;
            }
        }                                      
    }
}