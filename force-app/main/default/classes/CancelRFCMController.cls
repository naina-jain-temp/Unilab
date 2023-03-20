public class CancelRFCMController {
    
    @AuraEnabled
    public static boolean cancelRFCM(String rfcmId, String comments){ 
        try{
            RFCM__c objRFCM = new RFCM__c();
            objRFCM.Id = rfcmId;
            objRFCM.Status__c = 'Canceled';
            objRFCM.Cancelation_Comments__c  = comments;
            Update objRFCM;
            
            List<Task> openTaskList = new List<Task> ([select id,status,createddate,activitydate from Task where whatId =: objRFCM.Id and status = 'Open' and subject like '%assigned for approval%']);
            for(Task objTasks : openTaskList){
                objTasks.status = 'Completed';
                objTasks.Description = 'Cancelled';
            }  
            if(!openTaskList.isEmpty()){
                update openTaskList;
            }
            
            return true;
        }
        catch(Exception objException){
            //to-do error handling
            return false;
        }
    }
    
}