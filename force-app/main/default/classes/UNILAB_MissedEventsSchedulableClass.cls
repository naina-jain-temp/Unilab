/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   06.05.2017
Definition   :   Schedulable Class process for missed events
History      :   06.05.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
global class UNILAB_MissedEventsSchedulableClass implements Schedulable {
   global void execute(SchedulableContext sc) {
      UNILAB_MissedEventsBatch b = new UNILAB_MissedEventsBatch(); 
      database.executebatch(b);
   }
}