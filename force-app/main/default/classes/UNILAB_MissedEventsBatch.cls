/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   06.05.2017
Definition   :   Batch Class process for missed events
History      :   06.05.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
global class UNILAB_MissedEventsBatch implements Database.Batchable<sObject>{

   global String query;
   global DateTime dtConverted;
   global String filter1;
   global String filter2;
   global String filter3;
   global String filter;

   global String qfilter1;
   global String qfilter2;
   global String qfilter3;
   global String qfilter;

   global UNILAB_MissedEventsBatch(){
       query = '';
       filter1= 'Cancelled';
       filter2= 'Completed';
       filter3= 'Missed';
       filter= 'New';

       qfilter1 = '\''+filter1+'\'';
       qfilter2 = '\''+filter2+'\'';
       qfilter3 = '\''+filter3+'\'';
       qfilter = '\''+filter+'\'';
       
       Date orig = Date.today();
       dtConverted = DateTime.newInstance(orig.year(), orig.month(), orig.day());
       //query = 'SELECT Id, Status__c, EndDateTime FROM Event WHERE IsChild = false '+'AND Status__c !='+qfilter3+' AND Status__c !='+qfilter1+' AND Status__c !='+qfilter2+ ' AND EndDateTime < '+dateTime.Now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        query = 'SELECT Id, Status__c, EndDateTime FROM Event WHERE IsChild = false '+'AND Status__c ='+qfilter+' AND EndDateTime < '+dateTime.Now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

       system.Debug(query);
    
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> eventList){
       List<Event> eventToBeUpdatedList = new List<Event>();
       system.Debug(eventList);
       
       if(eventList != null && !eventList.isEmpty()){
           for(Event e : (List<Event>) eventList){
               if(e.EndDateTime.date() < date.Today()){
                   e.Status__c = 'Missed';
                   eventToBeUpdatedList.add(e);
               }
                 
           }
           
           if(eventToBeUpdatedList != null && !eventToBeUpdatedList.isEmpty()){
               try{
                
                   Database.update(eventToBeUpdatedList, false);
               }catch(Exception ex){
                   system.Debug(ex.getMessage());
               }               
           }         
       }   
   }

   global void finish(Database.BatchableContext BC){
   
   }
}