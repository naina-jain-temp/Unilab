/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   08.30.2017
Definition   :   Batch Class process for missed events
History      :   08.30.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
global class UNILAB_SurveySummaryFormBatch implements Database.Batchable<sObject>{
   global String query;
   global List<Survey_Summary_Form__c> ssfToProcessList;
   global Set<Id> acctIdSet;
   global Set<String> acctTeamSet;
   global Set<String> eventSubTypeSet;
   
   global UNILAB_SurveySummaryFormBatch(){

       ssfToProcessList = new List<Survey_Summary_Form__c>();
       ssfToProcessList = [SELECT Id,
                                  Name,
                                  Active__c,
                                  Activity_Name__c,
                                  Start_Date__c,
                                  End_Date__c,
                                  Team__c,
                                  Assign_to_Account__c,
                                  RecordTypeId,
                                  Account__c,
                                  Event_Sub_type__c,
                                  (SELECT Id,
                                   Account__c,
                                   Answer__c,
                                   Backroom__c,
                                   Product__c,
                                   Shelf__c,
                                   Survey_Question__c,
                                   Survey_Summary_Form__c,
                                   Weight__c,
                                   RecordTypeId
                                   FROM Survey_Forms__r)
                            FROM Survey_Summary_Form__c
                            WHERE Parent_SSF__c = null
                            AND Active__c = true
                            AND isBatch__c = TRUE];
       system.Debug('***ssfToProcessList: '+ssfToProcessList);
       Set<String> ssfListEventSubTypeSet = new Set<String>();
       Map<String, List<Survey_Summary_Form__c>> ssfMap = new Map<String, List<Survey_Summary_Form__c>>();
       acctIdSet = new Set<Id>();
       
       
       acctTeamSet = new Set<String>();
       for(Survey_Summary_Form__c ssf : ssfToProcessList){
          acctIdSet.add(ssf.Assign_to_Account__c);
          acctTeamSet.add(ssf.Team__c);
          if(ssfMap.containsKey(ssf.Event_Sub_Type__c)){
             ssfMap.get(ssf.Event_Sub_Type__c).add(ssf);
          }else{
             ssfMap.put(ssf.Event_Sub_Type__c, new List<Survey_Summary_Form__c>{ssf});
          }
       }
       if(ssfMap != null && ssfMap.size() > 0){
           eventSubTypeSet = new Set<String>();
           eventSubTypeSet = ssfMap.keySet();
           query = 'SELECT Id,Start_Date__c,End_Date__c,Related_to_Account__c,Related_to_Account__r.Name,Related_to_Account__r.Team__c, Event_Sub_Type__c,Event_Type__c,Status__c, ' +
           'Related_Contact__c, Related_Contact__r.AccountId, Related_Contact__r.Account_Team__c FROM Activity_Junction__c WHERE Start_Date__c >= '+dateTime.Now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' AND ' +
           '(Related_to_Account__r.Team__c IN: acctTeamSet OR Related_to_Account__c IN: acctIdSet OR Related_Contact__r.AccountId IN: acctIdSet OR Related_Contact__r.Account_Team__c IN: acctTeamSet) ' +
           'AND Event_Sub_Type__c IN: eventSubTypeSet';
       }
       /*query = 'SELECT Id, Name, Active__c, Activity_Name__c, Start_Date__c, End_Date__c, Team__c, Assign_to_Account__c, RecordTypeId, Account__c, Event_Sub_type__c, (SELECT Id, Account__c, Answer__c, Backroom__c, Product__c, Shelf__c, Survey_Question__c, Survey_Summary_Form__c, Weight__c, RecordTypeId FROM Survey_Forms__r) FROM Survey_Summary_Form__c WHERE Parent_SSF__c = null AND Active__c = true AND isBatch__c = TRUE';*/
       system.Debug(query);
       /*CreatedDate = date.Today().addDays(-1) AND*/
       /*
           query = 'SELECT Id,
                       Name,
                       Active__c,
                       Activity_Name__c,
                       Start_Date__c,
                       End_Date__c,
                       Team__c,
                       Assign_to_Account__c,
                       RecordTypeId,
                       Account__c,
                       Event_Sub_type__c,
                       (SELECT Id,
                             Account__c,
                             Answer__c,
                             Backroom__c,
                             Product__c,
                             Shelf__c,
                             Survey_Question__c,
                             Survey_Summary_Form__c,
                             Weight__c,
                             RecordTypeId
                       FROM Survey_Forms__r)
               FROM Survey_Summary_Form__c
               WHERE Parent_SSF__c = null
               AND Active__c = true
               AND CreatedDate = date.Today().addDays(-1)
               AND isBatch__c = TRUE';
       */
   
   }
   
   global Database.QueryLocator start(Database.BatchableContext BC){

      return Database.getQueryLocator(query);

   }

   global void execute(Database.BatchableContext BC, List<sObject> actJuncList){
      system.Debug('***actJuncList: '+actJuncList);
      

      if(actJuncList != null && !actJuncList.isEmpty()){
        List<Survey_Summary_Form__c> ssfToInsertList = new List<Survey_Summary_Form__c>();
        List<Survey_Form__c> sfToInsertList = new List<Survey_Form__c>();
        List<Sub_Activity__c> subActToInsert = new List<Sub_Activity__c>();
        Map<String, Sub_Activity__c> tempSubActivitiesToInsert = new Map<String, Sub_Activity__c>();
        Map<Id, List<Survey_Summary_Form__c>> activitySummaryForms = new Map<Id, List<Survey_Summary_Form__c>>();
        Map<String, Survey_Form__c> surveyFormsToInsertMap = new Map<String, Survey_Form__c>();
        
        //clone parent survey summary forms
        for(Activity_Junction__c aj : (List<Activity_Junction__c>)actJuncList){
           for(Survey_Summary_Form__c ssf : ssfToProcessList){
               Date tempActivityJunctionStartDate = Date.newInstance(aj.Start_Date__c.year(), aj.Start_Date__c.month(), aj.Start_Date__c.day());
               Date tempActivityJunctionEndDate = Date.newInstance(aj.End_Date__c.year(), aj.End_Date__c.month(), aj.End_Date__c.day());
               Date tempSSFStartDate = Date.newInstance(ssf.Start_Date__c.year(), ssf.Start_Date__c.month(), ssf.Start_Date__c.day());
               
              if(((aj.Related_to_Account__c == ssf.Assign_to_Account__c || aj.Related_to_Account__r.Team__c== ssf.Team__c) &&
                  aj.Event_Sub_Type__c == ssf.Event_Sub_type__c) && (tempActivityJunctionStartDate <= tempSSFStartDate || tempActivityJunctionEndDate >= tempSSFStartDate)){
                 
                 Survey_Summary_Form__c ssfTemp = new Survey_Summary_Form__c(Name = ssf.Name+' - '+ aj.Related_to_Account__r.Name,
                                                                           Activity_Name__c = ssf.Activity_Name__c,
                                                                           Start_Date__c = ssf.Start_Date__c,
                                                                           End_Date__c = ssf.End_Date__c,
                                                                           Team__c = ssf.Team__c,
                                                                           Assign_to_Account__c = ssf.Assign_to_Account__c,
                                                                           RecordTypeId = ssf.RecordTypeId,
                                                                           Account__c = aj.Related_to_Account__c,
                                                                           Parent_SSF__c = ssf.Id,
                                                                           Event_Sub_type__c = ssf.Event_Sub_type__c,
                                                                           isBatchCreated__c = true);
                 if(ssfTemp.Name.length() > 80){
                   ssfTemp.SSF_Name_Backend__c = ssfTemp.Name;
                   ssfTemp.Name = ssfTemp.Name.subString(0,79);
                 }
                 ssfToInsertList.add(ssfTemp);
                 
                 if(activitySummaryForms.containsKey(aj.Id)){
                     activitySummaryForms.get(aj.Id).add(ssfTemp);
                 }else{
                     activitySummaryForms.put(aj.Id, new List<Survey_Summary_Form__c>{ssfTemp});
                 }
                 
                 for(Survey_Form__c sf : ssf.Survey_Forms__r){

                    sfToInsertList.add(new Survey_Form__c(Account__c = aj.Related_to_Account__c,
                                                       Answer__c = sf.Answer__c,
                                                       Backroom__c = sf.Backroom__c,
                                                       Product__c = sf.Product__c,
                                                       Shelf__c = sf.Shelf__c,
                                                       Survey_Question__c = sf.Survey_Question__c,
                                                       Weight__c = sf.Weight__c,
                                                       RecordTypeId = sf.RecordTypeId,
                                                       Survey_Summary_Form__c = ssf.Id));
                 }
              } 
           }
        }

        if(ssfToInsertList != null && !ssfToInsertList.isEmpty()){
           system.Debug('***ssfToInsertList size: '+ssfToInsertList.size());
           insert ssfToInsertList;

            for(Survey_Summary_Form__c ssf : ssfToInsertList){
                for(Survey_Form__c sf : sfToInsertList){
                    String tempSecondaryKey = (String.isNotEmpty(sf.Product__c)) ? sf.Product__c : sf.Survey_Question__c;
                    String tempKey = ssf.Id + '~' + tempSecondaryKey;
                    if(ssf.Parent_SSF__c == sf.Survey_Summary_Form__c && !surveyFormsToInsertMap.containsKey(tempKey)){
                        sf.Survey_Summary_Form__c = ssf.Id;
                        
                        surveyFormsToInsertMap.put(tempKey, sf);
                    }
                }  
            }

           if(surveyFormsToInsertMap != null && !surveyFormsToInsertMap.isEmpty()){
               system.Debug('***sfToInsertList size: '+surveyFormsToInsertMap.size());
               // system.assertEquals('','QUERY' + sfToInsertList.size());
               insert surveyFormsToInsertMap.values();
           }
        }

        /*
        for(Activity_Junction__c aj : (List<Activity_Junction__c>)actJuncList){

           for(Survey_Summary_Form__c ssf : ssfToInsertList){
              
              if(aj.Event_Sub_Type__c == ssf.Event_Sub_type__c && (aj.Related_to_Account__r.Team__c == ssf.Team__c || aj.Related_to_Account__c == ssf.Account__c)){
                 /*subActToInsert.add(new Sub_Activity__c(Activity_Name__c = ssf.Activity_Name__c,
                                                        Survey_Summary_Form__c = ssf.Id,
                                                        Activity_Junction__c = aj.Id));*/
                 /*if(!tempSubActivitiesToInsert.containsKey(ssf.Name + '~' + ssf.Activity_Name__c + '~' + aj.Id)){
                     tempSubActivitiesToInsert.put(ssf.Name + '~' + ssf.Activity_Name__c + '~' + aj.Id, new Sub_Activity__c(Activity_Name__c = ssf.Activity_Name__c, Survey_Summary_Form__c = ssf.Id, Activity_Junction__c = aj.Id));
                 }               
              }
           }
        }
        */
        
        for(string activityJunctionId : activitySummaryForms.keySet()){
            List<Survey_Summary_Form__c> surveySummaryForms = activitySummaryForms.get(activityJunctionId);
            
            for(Survey_Summary_Form__c surveySummaryForm : surveySummaryForms){
                subActToInsert.add(new Sub_Activity__c(Activity_Name__c = surveySummaryForm.Activity_Name__c, Survey_Summary_Form__c = surveySummaryForm.Id, Activity_Junction__c = activityJunctionId));
            }
        }

        if(subActToInsert != null && !subActToInsert.isEmpty()){
           system.Debug('***subActToInsert size: '+subActToInsert.size());
           insert subActToInsert;
           
           for(Survey_Summary_Form__c ssf : ssfToProcessList){
               ssf.isBatch__c = false;
           }
           system.Debug('***ssfList size: '+ssfToProcessList.size());
           update ssfToProcessList;
        }
      }
    }

   global void finish(Database.BatchableContext BC){
      system.Debug('Finished');
   }
}