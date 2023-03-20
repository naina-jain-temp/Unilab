public class RFCMApprovalProcessService { 
    
    public static Task objTask = new Task();
    
    public static RFCM__c getRFCMRec(String rfcmId){
        List<RFCM__c> listRFCMs = new List<RFCM__c>([Select Id,CreatedById,OwnerId,Name,Validator1__c,Validator_Comments__c,Encoder__c, Encoder__r.Name,Encoder_Comments__c,Project_Owner_Comments__c ,Validator__c,Project_Owner__c,SNCD_Approver__c,Rejected_Count__c,Approval_Status__c,RFCM_Approver__c,Workflow_Type__c,Status__c,Current_Approver__c,Approval_Type__c,Customer_Sub_Team__c, Customer_Name__c ,Customer_Name__r.Customer_Team__c,Next_Approver__c,unilab_Claimed_Amount__c,(Select Id from RFCM_line_items__r LIMIT 1)  from RFCM__c where id = :  rfcmId]);
        if(listRFCMs != null && listRFCMs.size() > 0 ){
            return listRFCMs[0];
        }
        return null;
    } 
    
    @AuraEnabled
    public static RFCMApprovalProcessController.RFCMApprovalProcessResponse submitForApproval(RFCMApprovalProcessController.RFCMApprovalProcessResponse resp) {
        
        List<Task> openTaskList = new List<Task>();
        String currentApprover = '';
        Id userId = null;
        resp.errorFlag = true;
        Id previousUserId = null;
        
        RFCM__c objRFCM = resp.rfcm;
        objRFCM.Approval_Status__c = 'Pending';
        
        if(objRFCM == null){
            resp.message = 'RFCM record not found. Please check with your Admin';
            return resp;
        }
        
        if(objRFCM.unilab_Claimed_Amount__c < 0){
            resp.message = 'Please check RFCM Claimed Amount';
            return resp;
        }
        
        objTask.Subject = 'RFCM '+resp.rfcm.Name +' is assigned for approval.';
        objTask.Status = 'Open';
        objTask.Priority = 'Normal';
        objTask.WhatId = resp.rfcm.Id;
        
        List<Approval.ProcessSubmitRequest> approvalRequestList = new List<Approval.ProcessSubmitRequest>();
        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
        approvalRequest.setComments('Submitting request for approval.');
        approvalRequest.setObjectId(objRFCM.Id);
        
        List<String> splitList = objRFCM.Current_Approver__c.split(';');
        String team = splitList[0];
        String role = splitList[1];
        if(team.contains('SNCD')){
            userId = getCurrentApprover(objRFCM.SNCD_Approver__c,team,role);
        } 
        else{
            userId = getCurrentApprover(objRFCM.Customer_Sub_Team__c,team,role);
        }
        if(userId != null){
            approvalRequest.setNextApproverIds(new List<Id>{userId});
            previousUserId = objRFCM.RFCM_Approver__c;
            objRFCM.RFCM_Approver__c = userId;
            objTask.OwnerId = userId;
        }
        else{
            resp.message = 'Unable to find Current Approver. Please check with your Admin';
            return resp;
        }    
        
        objRFCM =  nextApprover(objRFCM);
        resp.nextApprover = objRFCM.Next_Approver__c;
        
        If(string.isBlank(objRFCM.Next_Approver__c )){
            resp.message = 'Unable to find Next Approver. Please check with your Admin';
            return resp;
        }
        resp.message = 'Submitting request for approval.';
        resp.errorFlag = false;
        objRFCM.Approval_History_JSON__c = JSON.serialize(resp);
        
        if(previousUserId != null){
            openTaskList = new List<Task> ([select id,status from Task where (ownerId =: previousUserId and whatId =: objRFCM.Id and status = 'Open') OR (subject like '%is assigned for review%' and status = 'Open')]);
        }
        else{
            openTaskList = new List<Task> ([select id,status from Task where (subject like '%is assigned for review%' and status = 'Open')]);
        } 
        
        for(Task tsk : openTaskList){
            tsk.Status= 'Completed';
        }
        update objRFCM;
        resp.rfcm = objRFCM;
        openTaskList.add(objTask);
        Upsert openTaskList;
        approvalRequestList.add(approvalRequest);
        Approval.process(approvalRequestList);
        
        RFCMSharing.apexShareRead(objRFCM.Id,objRFCM.RFCM_Approver__c);
        return resp;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessController.RFCMApprovalProcessResponse nextApprovalRejectionAction(String rfcmId, String approveReject, String commentsFromApprover) {
        RFCMApprovalProcessController.RFCMApprovalProcessResponse resp = new RFCMApprovalProcessController.RFCMApprovalProcessResponse();
        Id approverUserId = null;
        String currentApprover = '';
        Id userId,previousUserId = null;
        List<Task> openTaskList = new List<Task>();
        resp.errorFlag = true;
        boolean toUpdate = false;
        List<Approval.ProcessWorkitemRequest> approvalRequestList = new List<Approval.ProcessWorkitemRequest>();
        
        RFCM__c objRFCM = getRFCMRec(rfcmId);
        
        if(objRFCM == null){
            resp.message = 'RFCM record not found. Please check with your Admin';
            return resp;
        }
        
        if(objRFCM.RFCM_Approver__c == null){
            resp.message = 'Unable to find Current Approver. Please check with your Admin';
            return resp;
        }
        
        if(objRFCM.Status__c == 'Credit Approver'){
            resp.rfcm = objRFCM;
            resp.message = 'Current Approver is Credit Team. Manual action needed';
            return resp; 
        }
        
        if(objRFCM.RFCM_Approver__c != UserInfo.getUserId()){
            resp.message = 'You are not the correct approver for this record. Please check with your Admin';
            return resp;
        }
        
        approverUserId = objRFCM.RFCM_Approver__c;
        objTask.Subject = 'RFCM '+objRFCM.Name +' is assigned for approval.';
        objTask.Status = 'Open';
        objTask.Priority = 'Normal';
        objTask.WhatId = objRFCM.Id;
        
        if (approveReject == 'Approve') {
            if((string.isNotBlank(objRFCM.Next_Approver__c) && ! objRFCM.Next_Approver__c.contains('Credit;Credit Specialist'))){
                List<String> splitList = objRFCM.Next_Approver__c.split(';');
                String team = splitList[0];
                String role = splitList[1];
                
                if(team.contains('SNCD')){
                    userId = getNextApprover(objRFCM.SNCD_Approver__c,team,role);
                }
                else
                {
                    userId = getNextApprover(objRFCM.Customer_Sub_Team__c,team,role);
                }
                if(userId == null){
                    resp.message = 'Next Approver not found. Please check with your Admin';
                    return resp;
                }
            }
            for (ProcessInstanceWorkitem workItem : getProcessInstanceWorkItems(objRFCM.Id)) {
                approvalRequestList.add(createProcessWorkItemRequest(workItem.Id, userId, approveReject, commentsFromApprover));
                toUpdate = true;
                previousUserId = objRFCM.RFCM_Approver__c ;
                objRFCM.RFCM_Approver__c = userId;
                resp.errorFlag = false;
                objTask.OwnerId = userId;
            }
        } 
        else if (approveReject == 'Reject' || approveReject == 'Removed') {
            for (ProcessInstanceWorkitem workItem : getProcessInstanceWorkItems(objRFCM.Id)) {
                approvalRequestList.add(createProcessWorkItemRequest(workItem.Id, null, approveReject, commentsFromApprover));
                toUpdate = true;
                previousUserId = objRFCM.RFCM_Approver__c ;
                objRFCM.Rejected_Count__c  = objRFCM.Rejected_Count__c > 0 ? objRFCM.Rejected_Count__c + 1 : 1;
                objRFCM.Approval_Status__C = 'Rejected'; 
                objRFCM.Status__c = 'Project Owner';
            }
            resp.message = 'RFCM record rejected and assigned back to Project Owner. Thanks.';
            resp.errorFlag = false;
        } 
        if(toUpdate){
            if(objRFCM.Approval_Status__c != 'Rejected'){
                objRFCM.Current_Approver__c = objRFCM.Next_Approver__c;
                if(objRFCM.Current_Approver__c != 'Credit;Credit Specialist'){
                    objRFCM =  nextApprover(objRFCM);
                    If(string.isBlank(objRFCM.Next_Approver__c)){
                        resp.message = 'Next Approver not found. Please check with your Admin';
                        return resp;
                    }
                    resp.currentApprover = objRFCM.Current_Approver__c;
                    resp.nextApprover = objRFCM.Next_Approver__c;
                    resp.rfcm = objRFCM;
                    objRFCM.Approval_History_JSON__c = JSON.serialize(resp);
                }
                else {
                    objRFCM.Status__c = 'Credit Approver';
                    objRFCM.RFCM_Approver__c = null;
                    objRFCM.Next_Approver__c = '';
                }
            }
            
            if(previousUserId != null){
                openTaskList = new List<Task> ([select id,status,type,description from Task where ownerId =: previousUserId and whatId =: objRFCM.Id and status = 'Open']);
            }
            
            for(Task tsk : openTaskList){
                tsk.Status= 'Completed';
                tsk.type = 'Others';
                tsk.description = 'Automatically Completed task';
            }
            
            update objRFCM;
            
            if(objRFCM.Approval_Status__c != 'Rejected' && objTask.ownerId != null){
                openTaskList.add(objTask);
            }
            if(!openTaskList.isEmpty() && !Test.isRunningTest()){
                upsert openTaskList;
            }
        }
        RFCMSharing.apexShareRead(objRFCM.Id,objRFCM.RFCM_Approver__c);
        Approval.process(approvalRequestList);
        return resp;
    }
    
    private static Id getNextApprover(String customerTeam, String team, String role ){
        System.debug(customerTeam + ' ' + team + ' ' + role);
        List<RFCM_User_Matrix__c> objUM = new List<RFCM_User_Matrix__c>([Select Id,Customer_Sub__c,Customer_Team__c,Role__c,Team__c,User__c from RFCM_User_Matrix__c where Customer_Sub__c =: customerTeam and Team__c=:team and Role__c=:role limit 1]);
        System.debug(objUM.size());
        if(objUM != null && objUM.size() > 0 ){
            return objUM[0].User__c;
        }
        return null; 
    }
    
    private static Id getCurrentApprover(String customerTeam, String team, String role ){
        System.debug(customerTeam + ' ' + team + ' ' + role);
        List<RFCM_User_Matrix__c> objUM = new List<RFCM_User_Matrix__c>([Select Id,Customer_Team__c,Role__c,Team__c,User__c,Customer_Sub__c from RFCM_User_Matrix__c where Customer_Sub__c =: customerTeam and Team__c=:team and Role__c=:role limit 1]);
        System.debug(objUM.size());
        if(objUM != null && objUM.size() > 0 ){
            return objUM[0].User__c;
        }
        return null; 
    }
    
    @TestVisible
    private static RFCM__c nextApprover(RFCM__c objRFCM){
        String currentApprover = objRFCM.Current_Approver__c;
        String approvalType = objRFCM.Approval_Type__c;
        Decimal claimedAmount = objRFCM.unilab_Claimed_Amount__c;
        String nextApprover = '';
        String status = '';
        integer dueDate = 0;
        if(approvalType == 'Approval Flow and Lead Time 1' || approvalType == 'Approval Flow and Lead Time 2'
           || approvalType == 'Approval Flow and Lead Time 3' || approvalType == 'Approval Flow and Lead Time 4'){ 
               if(currentApprover.contains('Project Owner')){
                   nextApprover = 'SNCD;Team Leader';
               }
               else if(currentApprover == 'SNCD;Team Leader'){
                   dueDate = 3;
                   system.debug('claimedAmount:::' +claimedAmount);
                   system.debug('ApprovalType:::' +ApprovalType);
                   system.debug('claimedAmount:::' +claimedAmount);
                   if(claimedAmount >= 500000 && (ApprovalType == 'Approval Flow and Lead Time 1' || approvalType == 'Approval Flow and Lead Time 2') ){
                       nextApprover = 'SNCD;Channel Head';
                   }
                   else if(claimedAmount > 0 && (approvalType == 'Approval Flow and Lead Time 3' || approvalType == 'Approval Flow and Lead Time 4')){
                       nextApprover = 'SNCD;Channel Head';
                   }
                   else{
                       nextApprover = 'Finance;Finance Analyst';
                   } 
               }
               else if(currentApprover == 'SNCD;Channel Head'){
                   dueDate = 3;
                   if(claimedAmount >= 5000000){
                       nextApprover = 'SNCD;Division Head';
                   }
                   else if(claimedAmount > 0 && (approvalType == 'Approval Flow and Lead Time 3' || approvalType == 'Approval Flow and Lead Time 4')){
                       nextApprover = 'SNCD;Division Head';
                   }
                   else{
                       nextApprover = 'Finance;Finance Analyst';
                   } 
               }
               else if(currentApprover == 'SNCD;Division Head'){
                   dueDate = 3;
                   nextApprover = 'Finance;Finance Analyst';
               }
               else if(currentApprover == 'Finance;Finance Analyst'){
                   dueDate = 4;
                   if(claimedAmount >= 250000 ){
                       nextApprover = 'Finance;Team Leader';
                   }
                   else if(claimedAmount > 0 && (approvalType == 'Approval Flow and Lead Time 3' || approvalType == 'Approval Flow and Lead Time 4')){
                       nextApprover = 'Finance;Team Leader';
                   }
                   else{
                       nextApprover = 'Credit;Credit Specialist';
                   } 
               }
               else if(currentApprover == 'Finance;Team Leader'){
                   dueDate = 5;
                   if(claimedAmount >= 1000000 && (ApprovalType == 'Approval Flow and Lead Time 1' || approvalType == 'Approval Flow and Lead Time 2') ){
                       nextApprover = 'Finance;FLT';
                   }
                   else if(claimedAmount >= 1000000 && (approvalType == 'Approval Flow and Lead Time 3' || approvalType == 'Approval Flow and Lead Time 4')){
                       nextApprover = 'Finance;CFO';
                   }
                   else{
                       nextApprover = 'Credit;Credit Specialist';
                   } 
               }
               else if(currentApprover == 'Finance;FLT'){
                   dueDate = 3;
                   if(claimedAmount >= 5000000){
                       nextApprover = 'Finance;CFO';
                   }
                   else{
                       nextApprover = 'Credit;Credit Specialist';
                   } 
               }
               else if(currentApprover == 'Finance;CFO'){
                   dueDate = 3;
                   if(claimedAmount >= 25000000){
                       nextApprover = 'Top Management;President';
                   }
                   else if(claimedAmount >= 1000000 && (approvalType == 'Approval Flow and Lead Time 3' || approvalType == 'Approval Flow and Lead Time 4')){
                       nextApprover = 'Top Management;President';
                   }
                   else{
                       nextApprover = 'Credit;Credit Specialist';
                   } 
               }
               else if(currentApprover == 'Top Management;President'){
                   dueDate = 5;
                   if(claimedAmount >= 25000000 ){
                       nextApprover = 'Top Management;CEO';
                   }
                   else if(claimedAmount >= 10000000 && (approvalType == 'Approval Flow and Lead Time 3' || approvalType == 'Approval Flow and Lead Time 4')){
                       nextApprover = 'Top Management;CEO';
                   }
                   else{
                       nextApprover = 'Credit;Credit Specialist';
                   } 
               }
               else if(currentApprover == 'Top Management;CEO'){
                   dueDate = 5;
                   nextApprover = 'Credit;Credit Specialist';
               }
               if(dueDate > 0){
                   objTask.ActivityDate = Date.today().addDays(dueDate);
               }
           }
        if(String.isNotBlank(currentApprover)){
            if(currentApprover.contains('Project Owner')){
                status = 'Project Manager';
            }
            else if(currentApprover.contains('SNCD')){
                status = 'S&CD Approver';
            }
            else if(currentApprover.contains('Finance')){
                status = 'Finance Approver';
            }
            else if(currentApprover.contains('Top Management')){
                status = 'Top Management Approver';
            }
            else if(currentApprover.contains('Credit')){
                status = 'Credit Approver';
            }
        }
        if(String.isNotBlank(status)){
            objRFCM.Status__c = status;
        }
        objRFCM.Next_Approver__c = nextApprover;
        return objRFCM;
    }
    
    //Helper method get Process Instance Work Items which represents a user’s pending approval request.
    private static List<ProcessInstanceWorkitem> getProcessInstanceWorkItems(Id objectId) {
        return [
            SELECT
            Id
            FROM
            ProcessInstanceWorkitem
            WHERE
            ProcessInstance.TargetObjectId =: objectId
        ];
    } 
    
    private static Approval.ProcessWorkitemRequest createProcessWorkItemRequest(Id approvalStepId, Id approverId, String approvalAction, String commentFromApprover){
        Approval.ProcessWorkitemRequest result = new Approval.ProcessWorkitemRequest();
        result.setComments(commentFromApprover);
        result.setAction(approvalAction);
        result.setWorkitemId(approvalStepId);
        if (approverId != null) {
            result.setNextApproverIds(new List<Id>{approverId});
        }
        return result;
    }
    
    public class ApprovalServiceResponseWrapper {
        public string message;
        public boolean errorFlag;
    }
}