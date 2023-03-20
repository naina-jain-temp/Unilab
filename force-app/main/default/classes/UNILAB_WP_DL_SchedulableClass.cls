/*-------------------------------------------------------------------------------------------
Author       :   Kristjan Mariano
Created Date :   10.04.2019
Definition   :   Schedulable Class process for workplan completion notification
-------------------------------------------------------------------------------------------*/

global class UNILAB_WP_DL_SchedulableClass implements Schedulable{
    global void execute(SchedulableContext sc) {
         
        UNILAB_WP_DLNotif_Batch b = new UNILAB_WP_DLNotif_Batch();
        database.executeBatch(b);
    }  
}