/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   09.06.2017
Definition   :   Schedulable Class process for Survey SUmmary Forms
History      :   09.06.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
global class UNILAB_SurveySummaryFormSchedulableClass implements Schedulable {
   global void execute(SchedulableContext sc) {
      UNILAB_SurveySummaryFormBatch b = new UNILAB_SurveySummaryFormBatch(); 
      database.executebatch(b,10);
   }
}