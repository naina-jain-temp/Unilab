public class RFCMApprovalProcessController {
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse getValidators(String rfcmId){
        RFCMApprovalProcessResponse resp = new RFCMApprovalProcessResponse();
        resp.validators = new List<PicklistOption>();
        String message = '';
        
        Boolean errorFlag = true;
        resp.message = 'Unable to find Validators. Please contact Admin';
        
        try{
            RFCM__c objRFCM = getRFCMRec(rfcmId);
            resp.rfcm = objRFCM;
            if(objRFCM != null && String.isNotBlank(objRFCM.Validator__c)){
                List<PicklistOption> listValidators = getMultipleApprovers(objRFCM.Validator__c,'Validator');
                if(listValidators != null && listValidators.size() > 0){
                    resp.validators.addAll(listValidators);
                    resp.errorFlag = false;
                    resp.message = '';
                }
            }
        }
        catch(Exception obj){
            resp.errorFlag = true;
            resp.message = obj.getMessage();
        }
        return resp;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse getProjectOwners(String rfcmId){
        RFCMApprovalProcessResponse resp = new RFCMApprovalProcessResponse();
        resp.projectOwners = new List<PicklistOption>();
        String message = '';
        
        Boolean errorFlag = true;
        resp.message = 'Unable to find Project Owners. Please contact Admin';
        
        try{
            RFCM__c objRFCM = getRFCMRec(rfcmId);
            resp.rfcm = objRFCM;
            if(objRFCM != null && String.isNotBlank(objRFCM.Project_Owner__c)){
                List<PicklistOption> listProjectOwners = getMultipleApprovers(objRFCM.Project_Owner__c,'Project Owner');
                if(listProjectOwners != null && listProjectOwners.size() > 0){
                    resp.projectOwners.addAll(listProjectOwners);
                    resp.errorFlag = false;
                    resp.message = '';
                }
            }
        }
        catch(Exception obj){
            resp.errorFlag = true;
            resp.message = obj.getMessage();
        }
        return resp;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse getReassignList(String rfcmId){
        RFCMApprovalProcessResponse resp = new RFCMApprovalProcessResponse();
        resp.reassignList = new List<PicklistOption>();
        String message = '';
        Boolean errorFlag = true;
        resp.message = 'Unable to find Users. Please contact Admin';
        
        try{
            RFCM__c objRFCM = getRFCMRec(rfcmId);
            resp.rfcm = objRFCM;
            
            if(objRFCM != null){
                List<PicklistOption> reassignList = getUsers();
                system.debug('reassignList::'+reassignList);
                if(reassignList != null && reassignList.size() > 0){
                    resp.reassignList.addAll(reassignList);
                    resp.errorFlag = false;
                    resp.message = '';
                }
            }
        }
        catch(Exception obj){
            resp.errorFlag = true;
            resp.message = obj.getMessage();
        }
        return resp;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse submitToValidator(RFCMApprovalProcessResponse request){ 
        try{
            RFCM__c objRFCM = getRFCMRec(request.rfcm.Id);
            if(objRFCM.Encoder__c == null){
                objRFCM.Encoder__c = objRFCM.CreatedById ;
            }
            objRFCM.Encoder__c = UserInfo.getUserId();
            objRFCM.Current_Approver__c = request.validator+';Validator';
            objRFCM.Next_Approver__c  = '';
            objRFCM.Status__c = 'Validator';
            objRFCM.OwnerId = request.validator;
            if(objRFCM.Validator_Comments__c == null)
                objRFCM.Validator_Comments__c = '';
            objRFCM.Validator_Comments__c += '\r\n' + '[' + DateTime.now() + ']'+ '['+ UserInfo.getName() +']' + ' : ' + request.validatorComments;
            update objRFCM;
            
            //Prashanth starts
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='RFCM_notification']; 
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle('RFCM Request for Validation ');
            notification.setBody('Please validate the RFCM '+objRFCM.Name + 'Amount:' +objRFCM.unilab_Claimed_Amount__c+'submitted for validation');
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(request.rfcm.Id);
            notification.send(new Set<String>{request.validator});
            
            //Email Alert starts
            	RFCM__c rfc = [select id,name,Customer_Name__r.Name,unilab_Claim_Description__c,unilab_Claimed_Amount__c,CreatedDate,Encoder__r.name,Customer_Name__c from RFCM__c where id=:request.rfcm.Id];
            	//Email Alert starts
                List<Messaging.SingleEmailMessage> messages = new  List<Messaging.SingleEmailMessage>();
                //EmailTemplate emailTemplate = [Select Id,Subject,Description, HtmlValue,DeveloperName,Body from EmailTemplate where name = 'project owner for validation'];
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTargetObjectId(request.projectOwner);
            	message.setSubject('RFCM : '+rfc.Name+' For Validation -- Action Required');
            	String htmlbody = 'Hi <b>Project Owner</b>,';
            	htmlbody ='<div style="padding-top:15px;">You have an RFCM request waiting for your validation. You are given 5 calendar days to validate and submit this claim to the approvers</div>';
                htmlbody +='<div style="padding-top:15px;">';
                htmlbody +='RFCM Number: '+rfc.Name+'<br/>';
                htmlbody +='Claim Description: '+rfc.unilab_Claim_Description__c+'<br/>';
                htmlbody +='Claim Amount: '+rfc.unilab_Claimed_Amount__c+'<br/>';
                htmlbody +='Request Date: '+rfc.CreatedDate+'<br/>';
                htmlbody +='Account Name: '+rfc.Customer_Name__r.Name+'<br/>';
                htmlbody +='</div>';
                htmlbody +='<div style="padding-top:15px;">';
                htmlbody +='You can view your request by clicking this <a href="'+System.label.RFCM_URL+''+rfc.Id+'/view" style="text-decoration:none;color:#;text-decoration:underline;">Click Here</a><br/>';
				htmlbody +='</div>';
                htmlbody +='<div style="padding-top:15px;">';
                htmlbody +='This is a system generated email. Please do not reply.';
                htmlbody +='</div>';
                message.setSenderDisplayName('RFCM Support');
                message.setReplyTo('no-reply@unilab.com');
                message.setUseSignature(false);
                message.setBccSender(false);
                message.setSaveAsActivity(false);
            	message.setHtmlBody(htmlbody);
                //message.setTemplateID(emailTemplate.Id);
                message.toAddresses = new String[] { request.validator};
                messages.add(message);
       			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            	//Email alert ends
				
            //Task starts
            List<Task> listTasks = new List<Task>([Select Id from Task where subject like '%is assigned for review%' and status = 'Open' ]);
            for(Task objTask : listTasks){
                objTask.Status = 'Completed';
            }
            Task objTask = new Task();
            objTask.Subject = 'Validator - RFCM '+objRFCM.Name +' is assigned for review.';
            objTask.Status = 'Open';
            objTask.Priority = 'Normal';
            objTask.WhatId = objRFCM.Id;
            objTask.OwnerId = objRFCM.OwnerId;
            objTask.ActivityDate = Date.today().addDays(5);
            listTasks.add(objTask);
            Upsert listTasks;
            //Task Ends
            
            //Prashanth Ends
            
            request.rfcm = objRFCM;
            request.errorFlag = false;
            request.message = '';
            RFCMSharing.apexShareRead(objRFCM.Id,objRFCM.OwnerId);
            RFCMSharing.apexShareRead(objRFCM.Id,objRFCM.Encoder__c);
        }
        catch(Exception obj){
            request.errorFlag = true;
            request.message = obj.getMessage();
        }
        return request;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse reassign(RFCMApprovalProcessResponse request){ 
        Id previousUserId = null;
        try{
            Task objTask = new Task();
            objTask.Status = 'Open';
            objTask.Priority = 'Normal';
            objTask.WhatId = request.rfcm.Id;
            RFCM__c objRFCM = getRFCMRec(request.rfcm.Id);
            objTask.Subject = 'RFCM '+objRFCM.Name +' is assigned for approval.';
            previousUserId = objRFCM.RFCM_Approver__c;
            objRFCM.RFCM_Approver__c = request.reassignTo;  
            objTask.OwnerId = request.reassignTo;
            
            List<Task> openTaskList = new List<Task> ([select id,status,createddate,activitydate from Task where ownerId =: previousUserId and whatId =: objRFCM.Id and status = 'Open' and subject like '%assigned for approval%']);
            
            for(Task objTask1 :openTaskList){
                objTask1.status =  'Canceled';
                objTask.activitydate =  Date.Today().addDays(Date.valueOf(objTask1.createddate).daysBetween(Date.valueOf(objTask1.activitydate)) - 1);
            }
            update objRFCM;
            //insert objTask;
            openTaskList.add(objTask);
            upsert openTaskList;
            request.rfcm = objRFCM;
            request.errorFlag = false;
            request.message = '';
            List<ProcessInstanceWorkitem> objPWI = new List<ProcessInstanceWorkitem>([SELECT Id, ActorId  FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =:  request.rfcm.Id]);
            if(objPWI != null && objPWI.size()>0){
                objPWI[0].ActorId = objRFCM.RFCM_Approver__c;
                update objPWI[0];
            }
            RFCMSharing.apexShareRead(objRFCM.Id,objRFCM.OwnerId);
        }
        catch(Exception obj){
            request.errorFlag = true;
            request.message = obj.getMessage();
        }
        return request;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse submitToProjectOwner(RFCMApprovalProcessResponse request){ 
        try{
            system.debug('request:::'+request);
            RFCM__c objRFCM = getRFCMRec(request.rfcm.Id);
            system.debug('objRFCM::'+objRFCM);
            RFCM__c rfc = [select id,createdbyId,name,unilab_Claim_Description__c,Customer_Name__r.Name,unilab_Claimed_Amount__c,CreatedDate,Customer_Name__c from RFCM__c where id=:request.rfcm.Id];
            system.debug('rfc::'+rfc);
            //Task starts

            List<Task> listTasks = new List<Task>([Select Id from Task where subject like '%is assigned for review%' and status = 'Open' ]);
            system.debug('listTasks:::'+listTasks);
            if(listTasks.Size() > 0){
                for(Task objTask : listTasks){
                objTask.Status = 'Completed';
            }
            }
            
            Task objTask = new Task();
            objTask.Subject = 'Project Owner - RFCM '+objRFCM.Name +' is assigned for review.';
            objTask.Status = 'Open';
            objTask.Priority = 'Normal';
            objTask.WhatId = objRFCM.Id;
            objTask.OwnerId = request.projectOwner;
            system.debug('objRFCM.OwnerId::'+objRFCM.OwnerId);
            objTask.ActivityDate = Date.today().addDays(5);
            listTasks.add(objTask);
            upsert listTasks;
            system.debug('listTasks'+listTasks);
            //Task Ends
            if(objRFCM.Encoder__c == null){
                objRFCM.Encoder__c = objRFCM.CreatedById ;
            }
            
            //objRFCM.Encoder__c = UserInfo.getUserId();
            objRFCM.Current_Approver__c = request.projectOwner+';Project Owner';
            //objRFCM.Next_Approver__c  = '';
            objRFCM.Status__c = 'Project Owner';
            objRFCM.OwnerId = request.projectOwner;
            if(objRFCM.Encoder_Comments__c == null)
                objRFCM.Encoder_Comments__c = '';
            objRFCM.Encoder_Comments__c += '\r\n' + '[' + DateTime.now() + ']'+ '['+ UserInfo.getName() +']' + ' : ' + request.encoderComments;
            update objRFCM;
            system.debug('here after update objRFCM');
            //Prashanth starts
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='RFCM_notification']; 
            system.debug('notificationType');
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle('RFCM Request for Project Owner Approval ');
            notification.setBody('Please approve the RFCM '+objRFCM.Name + 'Amount:' +objRFCM.unilab_Claimed_Amount__c+'Please check and submit for approval');
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(request.rfcm.Id);
            notification.send(new Set<String>{request.projectOwner});
            system.debug('187:: request.rfcm.createdById' +request.rfcm.createdById);
            RFCMSharing.apexShareRead(request.rfcm.Id , request.rfcm.createdById);
            system.debug('189 end');
            
            system.debug('245request.rfcm.Id:::'+request.rfcm.Id);
            //RFCM__c rfc = [select id,name,unilab_Claim_Description__c,Customer_Name__r.Name,unilab_Claimed_Amount__c,CreatedDate,Customer_Name__c from RFCM__c where id=:request.rfcm.Id];
            	//Email Alert starts
            	system.debug('rfc::'+rfc);
                List<Messaging.SingleEmailMessage> messages = new  List<Messaging.SingleEmailMessage>();
                //EmailTemplate emailTemplate = [Select Id,Subject,Description, HtmlValue,DeveloperName,Body from EmailTemplate where name = 'project owner for validation'];
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTargetObjectId(request.projectOwner);
            	message.setSubject('RFCM : '+rfc.Name+' For Validation -- Action Required');
            	String htmlbody = 'Hi <b>Project Owner</b>,';
            	htmlbody ='<div style="padding-top:15px;">You have an RFCM request waiting for your validation. You are given 5 calendar days to validate and submit this claim to the approvers</div>';
                htmlbody +='<div style="padding-top:15px;">';
                htmlbody +='RFCM Number: '+rfc.Name+'<br/>';
                htmlbody +='Claim Description: '+rfc.unilab_Claim_Description__c+'<br/>';
                htmlbody +='Claim Amount: '+rfc.unilab_Claimed_Amount__c+'<br/>';
                htmlbody +='Request Date: '+rfc.CreatedDate+'<br/>';
                htmlbody +='Account Name: '+rfc.Customer_Name__r.Name+'<br/>';
                htmlbody +='</div>';
                htmlbody +='<div style="padding-top:15px;">';
                htmlbody +='You can view your request by clicking this <a href="'+System.label.RFCM_URL+''+rfc.Id+'/view" style="text-decoration:none;color:#;text-decoration:underline;">Click Here</a><br/>';
				htmlbody +='</div>';
                htmlbody +='<div style="padding-top:15px;">';
                htmlbody +='This is a system generated email. Please do not reply.';
                htmlbody +='</div>';
                message.setSenderDisplayName('RFCM Support');
                message.setReplyTo('no-reply@unilab.com');
                message.setUseSignature(false);
                message.setBccSender(false);
                message.setSaveAsActivity(false);
            	message.setHtmlBody(htmlbody);
                message.toAddresses = new String[] { request.projectOwner};
                messages.add(message);
       			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            	//Email alert ends
            	//
            	//


            //Prashanth Ends
            
            request.rfcm = objRFCM;
            request.errorFlag = false;
            request.message = '';
            //RFCMSharing.apexShareRead(objRFCM.Id,objRFCM.OwnerId);
            RFCMSharing.apexShareRead(objRFCM.Id,objRFCM.Encoder__c);
            
        }
        catch(Exception obj){
            request.errorFlag = true;
            request.message = obj.getMessage();
            system.debug('request.message::'+request.message);
        }
        return request;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse getEncoder(String rfcmId){
        RFCMApprovalProcessResponse resp = new RFCMApprovalProcessResponse();
        String message = '';
        Boolean errorFlag = true;
        resp.message = 'Unable to find Encoder Info. Please contact Admin';
        
        try{
            RFCM__c objRFCM = getRFCMRec(rfcmId);
            resp.rfcm = objRFCM;
            if(objRFCM != null && String.isNotBlank(objRFCM.Encoder__c)){
                resp.errorFlag = false;
                resp.message = '';
            }
        }
        catch(Exception obj){
            resp.errorFlag = true;
            resp.message = obj.getMessage();
        }
        return resp;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse submitToEncoder(RFCMApprovalProcessResponse request){ 
        try{
            RFCM__c objRFCM = getRFCMRec(request.rfcm.Id);
            objRFCM.Next_Approver__c = objRFCM.Current_Approver__c;
            objRFCM.Current_Approver__c = objRFCM.Encoder__c+';Encoder';
            objRFCM.Status__c = 'New';
            objRFCM.OwnerId = objRFCM.Encoder__c;
            if(objRFCM.Project_Owner_Comments__c == null)
                objRFCM.Project_Owner_Comments__c = '';
            objRFCM.Project_Owner_Comments__c += '\r\n' + '[' + DateTime.now() + ']'+ '['+ UserInfo.getName() +']' + ' : ' +  request.projectOwnerComments;
            update objRFCM;
            
            //Prashanth starts
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='RFCM_notification']; 
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle('RFCM Request for reverification ');
            notification.setBody('Your RFCM '+objRFCM.Name + 'Amount:' +objRFCM.unilab_Claimed_Amount__c+'has been rejected. Please check and revert back' );
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(request.rfcm.Id);
            notification.send(new Set<String>{objRFCM.Encoder__c});
            
            RFCM__c rfc = [select id,name,Customer_Name__r.Name,unilab_Claim_Description__c,unilab_Claimed_Amount__c,CreatedDate,Encoder__r.name,Customer_Name__c from RFCM__c where id=:request.rfcm.Id];
            	//Email Alert starts
                List<Messaging.SingleEmailMessage> messages = new  List<Messaging.SingleEmailMessage>();
                //EmailTemplate emailTemplate = [Select Id,Subject,Description, HtmlValue,DeveloperName,Body from EmailTemplate where name = 'project owner for validation'];
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            	message.setSubject('RFCM : '+rfc.Name+' For Validation -- Action Required');
            	String htmlbody = 'Hi <b>Encoder</b>,';
            	htmlbody ='<div style="padding-top:15px;">You have an RFCM returned. Resubmit this claim to the approvers</div>';
                htmlbody +='<div style="padding-top:15px;">';
                htmlbody +='RFCM Number: '+rfc.Name+'<br/>';
                htmlbody +='Claim Description: '+rfc.unilab_Claim_Description__c+'<br/>';
                htmlbody +='Claim Amount: '+rfc.unilab_Claimed_Amount__c+'<br/>';
                htmlbody +='Request Date: '+rfc.CreatedDate+'<br/>';
                htmlbody +='Account Name: '+rfc.Customer_Name__r.Name+'<br/>';
                htmlbody +='</div>';
                htmlbody +='<div style="padding-top:15px;">';
                htmlbody +='You can view your request by clicking this <a href="'+System.label.RFCM_URL+''+rfc.Id+'/view" style="text-decoration:none;color:#;text-decoration:underline;">Click Here</a><br/>';
				htmlbody +='</div>';
                htmlbody +='<div style="padding-top:15px;">';
                htmlbody +='This is a system generated email. Please do not reply.';
                htmlbody +='</div>';
                message.setSenderDisplayName('RFCM Support');
                message.setReplyTo('no-reply@unilab.com');
                message.setUseSignature(false);
                message.setBccSender(false);
                message.setSaveAsActivity(false);
            	message.setHtmlBody(htmlbody);
                message.toAddresses = new String[] {objRFCM.Encoder__c};
                messages.add(message);
       			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            	//Email alert ends
            
            //Prashanth Ends
            
            request.rfcm = objRFCM;
            request.errorFlag = false;
            request.message = '';
            RFCMSharing.apexShareRead(objRFCM.Id,objRFCM.OwnerId);
        }
        catch(Exception obj){
            request.errorFlag = true;
            request.message = obj.getMessage();
        }
        return request;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse initAction(String rfcmId){
        RFCMApprovalProcessResponse resp = new RFCMApprovalProcessResponse();
        resp.projectOwners = new List<PicklistOption>();
        String message = '';
        resp.errorFlag = false;
        try{
            RFCM__c objRFCM = getRFCMRec(rfcmId);
            resp.rfcm = objRFCM;
            List<ContentDocumentLink> listCDLs = new List<ContentDocumentLink>([select Id from contentdocumentlink where linkedentityid =: rfcmId]);
            if(!(resp.rfcm.RFCM_line_items__r != null && resp.rfcm.RFCM_line_items__r.size() > 0 )){
                resp.errorFlag = true;
                resp.message = 'No RFCM Line Items for this RFCM. Cannot submit for approval.';
            }
            else  if(!(listCDLs != null && listCDLs.size() > 0 )){
                resp.errorFlag = true;
                resp.message = 'No Attachments on this RFCM. Cannot submit for approval.';
            }
        }
        catch(Exception obj){
            resp.errorFlag = true;
            resp.message = obj.getMessage();
        }
        return resp;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse submitForApproval(String rfcmId){
        RFCMApprovalProcessResponse request = new RFCMApprovalProcessResponse();
        try{
            RFCM__c objRFCM = getRFCMRec(rfcmId);
            request.rfcm = objRFCM;
            if(request.rfcm.Rejected_Count__c > 0 && objRFCM.Approval_Status__c == 'Rejected'){
                request.currentApprover = request.rfcm.Current_Approver__c;
                /*request.currentApprover = request.rfcm.Next_Approver__c; 
                request.rfcm.Current_Approver__c = request.rfcm.Next_Approver__c;  */
            }
            else if(request.rfcm.Approval_Type__c == 'Approval Flow and Lead Time 1' || request.rfcm.Approval_Type__c == 'Approval Flow and Lead Time 3' || request.rfcm.Approval_Type__c == 'Approval Flow and Lead Time 4'){
                request.rfcm.Current_Approver__c = 'SNCD;Team Leader';
                request.rfcm.Status__c = 'S&CD Approver';
                request.currentApprover = request.rfcm.Current_Approver__c;
            }
            else if(request.rfcm.Approval_Type__c == 'Approval Flow and Lead Time 2'){
                request.rfcm.Current_Approver__c = 'SNCD;Channel Head';
                request.rfcm.Status__c = 'S&CD Approver';
                request.currentApprover = request.rfcm.Current_Approver__c;
            }
            System.debug('request is : '+JSON.serialize(request));
            request = RFCMApprovalProcessService.submitForApproval(request);
            System.debug('request is : '+JSON.serialize(request)); 
            
            List<Task> openTaskList = new List<Task>();
            openTaskList = new List<Task> ([select id,status from Task where whatId =: request.rfcm.Id and status = 'Open']);
            for(Task tsk : openTaskList){
            tsk.Status= 'Completed';
       		}
            /*openTaskList.add(objTask);
        	Upsert openTaskList;*/
        }
        catch(Exception obj){
            request.errorFlag = true;
            request.message = obj.getMessage();
        }
        return request;
    }
    
    @AuraEnabled
    public static RFCMApprovalProcessResponse submitForNextApprovalOrReject(String rfcmId, String approveReject, String commentsFromApprover){
        RFCMApprovalProcessResponse responseData = RFCMApprovalProcessService.nextApprovalRejectionAction(rfcmId,approveReject,commentsFromApprover);
        return responseData;
    }
    public static RFCM__c getRFCMRec(String rfcmId){
        return RFCMApprovalProcessService.getRFCMRec(rfcmId);
    }
    public static List<PicklistOption> getMultipleApprovers(String customerTeam, String role){
        List<PicklistOption> listApprovers = new List<PicklistOption>();
        List<RFCM_User_Matrix__c> listUM = new List<RFCM_User_Matrix__c>([Select Id,Customer_Team__c,Customer_Sub__c,Role__c,Team__c,User__c,User__r.Name from
                                                                          RFCM_User_Matrix__c where Customer_Sub__c =: customerTeam and Role__c=:role]);
        if(listUM != null && listUM.size() > 0 ){
            for(RFCM_User_Matrix__c objUM : listUM){
                listApprovers.add(new PicklistOption(objUM.User__c,objUM.User__r.Name));
            }
            return listApprovers;
        }
        return null;
    }
    public static List<PicklistOption> getUsers(){
        List<PicklistOption> listApprovers = new List<PicklistOption>();
        List<User> listUM = new List<User>([Select Id,Name from User where isActive = true order by name asc]);
        if(listUM != null && listUM.size() > 0 ){
            for(User objUM : listUM){
                listApprovers.add(new PicklistOption(objUM.Id,objUM.Name));
            }
            return listApprovers;
        }
        return null;
    }
    
    public class RFCMApprovalProcessResponse {
        @AuraEnabled public string message{get;set;}
        @AuraEnabled public string currentApprover{get;set;}
        @AuraEnabled public string nextApprover{get;set;}
        @AuraEnabled public RFCM__c rfcm{get;set;}
        @AuraEnabled public boolean errorFlag{get;set;}
        @AuraEnabled public List<PicklistOption> projectOwners{get;set;}
        @AuraEnabled public string projectOwner{get;set;}
        @AuraEnabled public string encoderComments{get;set;}
        @AuraEnabled public string projectOwnerComments{get;set;}
        @AuraEnabled public string validator{get;set;}
        @AuraEnabled public List<PicklistOption> validators{get;set;}
        @AuraEnabled public string validatorComments{get;set;}
        @AuraEnabled public List<PicklistOption> reassignList{get;set;}
        @AuraEnabled public string reassignTo{get;set;}
    }
}