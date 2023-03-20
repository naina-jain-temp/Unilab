global class CMJunctionBatchScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
      CMJunctionBatch CM = new CMJunctionBatch();
       Database.executeBatch(CM, 200);
   }
}