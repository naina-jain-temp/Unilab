public class RFCMTriggerHandler {
    
    public static boolean RFCMTriggerBypassFlag = false;
    
    public static void rejectPendingApprovals(List<RFCM__c> newList){
        List<Approval.ProcessWorkitemRequest> approvalRequestList = new List<Approval.ProcessWorkitemRequest>();
            
         for(ProcessInstanceWorkitem objPWI : [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId in:  newList]){
                Approval.ProcessWorkitemRequest result = new Approval.ProcessWorkitemRequest();
                result.setComments('RFCM Canceled');
                result.setAction('Reject');
                result.setWorkitemId(objPWI.Id);
                approvalRequestList.add(result);
            }
      if(!approvalRequestList.isEmpty()){
          Approval.process(approvalRequestList);
      }  
     
    } 
    
    public static void setApprovalConfigAttributes(List<RFCM__c> newList){
        Map<String,RFCM_Approval_Configurations__mdt> mapApprovalConfigs = new Map<String,RFCM_Approval_Configurations__mdt> ();
        Set<String> setRFCMTypes = new Set<String>();
        Set<String> setClassifications = new Set<String>();
        Set<String> setCustomerTeams = new Set<String>();
        List<RFCM__c> newInsertedUpdatedList = [Select Id,Status__c,Customer_Sub_Team__c,Approval_Configuration_Identifier__c,RecordType.Name,Customer_Name__c,Customer_Name__r.Customer_Team__c,unilab_Classification__c from RFCM__c where Id in : newList];
        List<RFCM__c> toUpdateList = new List<RFCM__c>();
        
        for(RFCM__c objRFCM : newInsertedUpdatedList){ 
            setRFCMTypes.add(objRFCM.RecordType.Name);
            //if(String.isNotBlank(objRFCM.Customer_Name__c) && String.isNotBlank(objRFCM.Customer_Name__r.Customer_Team__c) ){
            if(String.isNotBlank(objRFCM.Customer_Sub_Team__c)  ){
                setCustomerTeams.add(objRFCM.Customer_Sub_Team__c);
                //setCustomerTeams.add(objRFCM.Customer_Name__r.Customer_Team__c);
            }
            if(String.isNotBlank(objRFCM.unilab_Classification__c)){
                setClassifications.add(objRFCM.unilab_Classification__c);
            }  
        } 
        if(!setRFCMTypes.isEmpty() && !setCustomerTeams.isEmpty() && !setClassifications.isEmpty()){
            
            for(RFCM_Approval_Configurations__mdt objConfig : [Select Id,RFCM_Type__c,Customer_Team__c,Customer_Sub_Team__c,Classification__c,Approval_Matrix__c,Workflow__c,Validator__c,SNCD_Approvers__c,Project_Owner__c  from RFCM_Approval_Configurations__mdt where RFCM_Type__c in: setRFCMTypes and Customer_Sub_Team__c in: setCustomerTeams and Classification__c in:setClassifications]){
                if(String.isNotBlank(objConfig.RFCM_Type__c) 
                    && String.isNotBlank(objConfig.Customer_Sub_Team__c)
                   //&& String.isNotBlank(objConfig.Customer_Team__c) 
                   && String.isNotBlank(objConfig.Classification__c)
                   && String.isNotBlank(objConfig.Approval_Matrix__c) 
                   && String.isNotBlank(objConfig.Workflow__c)){
                    mapApprovalConfigs.put((objConfig.RFCM_Type__c + '-' + objConfig.Customer_Sub_Team__c + '-' + objConfig.Classification__c).trim(),objConfig); 
                       system.debug('mapApprovalConfigs::'+mapApprovalConfigs);
                       //mapApprovalConfigs.put((objConfig.RFCM_Type__c + '-' + objConfig.Customer_Team__c + '-' + objConfig.Classification__c).trim(),objConfig); 
                   }
            }    
        }  
        if(!mapApprovalConfigs.isEmpty()){
            for(RFCM__c objRFCM : newInsertedUpdatedList){ 
				objRFCM.Status__c = 'New';
                objRFCM.Current_Approver__c = '';
                objRFCM.Next_Approver__c = '';
                objRFCM.Approval_History_JSON__c = '';
                objRFCM.RFCM_Approver__c = null;
                objRFCM.Rejected_Count__c = 0;
                if(mapApprovalConfigs.get(objRFCM.Approval_Configuration_Identifier__c) != null){
                    objRFCM.Approval_Type__c = mapApprovalConfigs.get(objRFCM.Approval_Configuration_Identifier__c).Approval_Matrix__c;
                    objRFCM.Workflow_Type__c = mapApprovalConfigs.get(objRFCM.Approval_Configuration_Identifier__c).Workflow__c;
                    if(objRFCM.Workflow_Type__c == 'Workflow 2'){
                        objRFCM.Status__c = 'Project Owner';
                    }
                    objRFCM.Validator__c = mapApprovalConfigs.get(objRFCM.Approval_Configuration_Identifier__c).Validator__c;
                    objRFCM.Project_Owner__c  = mapApprovalConfigs.get(objRFCM.Approval_Configuration_Identifier__c).Project_Owner__c ;
                    objRFCM.SNCD_Approver__c  = mapApprovalConfigs.get(objRFCM.Approval_Configuration_Identifier__c).SNCD_Approvers__c ;
                }
            }
            RFCMTriggerHandler.RFCMTriggerBypassFlag = true;
            update newInsertedUpdatedList;
            RFCMTriggerHandler.RFCMTriggerBypassFlag = false;
        }
    }

    @future
    public static void createCSV(Set<Id> setRFCMIds){
        String csvColumnHeader = 'Customer Code, Customer Name, RFCM#, OR Number, OR Date, DM Number, Amount, Month/Period, Branch Name, Source Doc Type,Nature Of Deduction, Contract No, Contract Duration, Condition Type, Material, Functional Area, Sales Area, Contract Price \n';   
        List<ContentVersion> listCvs = new List<ContentVersion>();
        for(RFCM__c objRFCM : [Select id,Condition_Type__c,Status__c,Name,unilab_Claim_Reference_Number__c,unilab_Start_Date__c,unilab_End_Date__c,unilab_Claim_Description__c From RFCM__c where Id in: setRFCMIds]){
            if(objRFCM.Status__c == 'Credit Approver'){
                // create csv
                List<String> rowList = new List<String>();
                
                for(RFCM_line_item__c objRFCMLineItem : [Select Id,PPD_Contract__r.Sales_Area__c,Customer_Name__c,PPD_Contract__c,PPD_Contract__r.Functional_Area__c,PPD_Description__c,Material__c,unilab_Amount__c,Customer_Code__c,Customer_Name__r.Name,PPD_Contract__r.Name,Material__r.Name From RFCM_line_item__c where RFCM__c =: objRFCM.Id] ){ 
                    String customerName = objRFCMLineItem.Customer_Name__c != null ? objRFCMLineItem.Customer_Name__r.Name.replaceAll(',','-'): '';    
                    String customerCode = String.isBlank(objRFCMLineItem.Customer_Code__c) ? ' ' :  objRFCMLineItem.Customer_Code__c ;
                    String row  = customerCode
                        + ','
                        + customerName
                        + ',' 
                        +  objRFCM.Name
                        + ','
                        +'N/A'
                        + ',' 
                        +  'N/A'
                        + ',' 
                        + objRFCM.unilab_Claim_Reference_Number__c  
                        + ',' 
                        +  String.valueOf(objRFCMLineItem.unilab_Amount__c) 
                        + ',' 
                        +  'N/A'
                        + ',' 
                        + 'N/A'
                        + ',' 
                        + 'N/A' 
                        + ',' 
                        +  objRFCM.unilab_Claim_Description__c 
                        + ',' 
                        + (objRFCMLineItem.PPD_Contract__c != null && String.isNotBlank(objRFCMLineItem.PPD_Contract__r.Name) ? objRFCMLineItem.PPD_Contract__r.Name : 'N/A')
                        + ',' 
                        +  (objRFCM.unilab_Start_Date__c + '-' + objRFCM.unilab_End_Date__c)
                        + ',' 
                        + objRFCM.Condition_Type__c
                        +','
                        + objRFCMLineItem.Material__r.Name 
                        + ',' 
                        +  (String.isNotBlank(objRFCMLineItem.PPD_Contract__r.Functional_Area__c) ? objRFCMLineItem.PPD_Contract__r.Functional_Area__c : 'S002')
                        + ',' 
                        + objRFCMLineItem.PPD_Contract__r.Sales_Area__c
                        +','
                        + objRFCMLineItem.PPD_Description__c ;
                    rowList.add(row);
                    
                }
                if(!rowList.isEmpty()){
                    String csvFile = csvColumnHeader + String.join(rowList,'\n');
                    ContentVersion cv = createFile(csvFile,'CSV RFCM-Classification-Program-Mapping',objRFCM.Id);
                    listCvs.add(cv);
                }
            }
        }
        
        if(!listCvs.isEmpty()){
            insert listCvs;
            List<ContentDocumentLink> listCDLs = new List<ContentDocumentLink>();
            for(ContentVersion cv : [SELECT Id, ContentDocumentId,Title,Description FROM ContentVersion WHERE Id in: listCvs]){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cv.ContentDocumentId;
                cdl.LinkedEntityId = cv.Description;
                cdl.ShareType = 'V';
                listCDLs.add(cdl);
            }
            if(!listCDLs.isEmpty()){
                insert listCDLs;
            }
        }
        
    } 
    @Testvisible
     private static ContentVersion createFile(String versionData, String title,string description) {
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S'; //denotes it resides on Salesforce
        cv.Title = title + '.csv'; //title of the file
        cv.PathOnClient = title; // full path within Salesforce this can just be the name of file to be in the library
        cv.VersionData = Blob.valueOf(versionData); //file data
        cv.Description = description;
        //insert cv;
        return cv;
    }
    
    public static void sendEMailtoCredit(Set<Id> setRFCMIds){
        List<RFCM_line_item__c> rfcmline = [select id,Company__c,RFCM__c,RFCM__r.Name,Customer_Name__c from RFCM_line_item__c where RFCM__c IN :setRFCMIds];
        
        Map<String, RFCM_line_item__c> uniqueValues = new Map<String, RFCM_line_item__c>();
        Map<String,Credit_Team__c> mapOfCreditTeam = new Map<String,Credit_Team__c>();

        Set<String> customerName = new Set<String>();
        Set<String> company = new Set<String>();
        for(RFCM_line_item__c rfcmli : rfcmline){
            if(String.isNotBlank(rfcmli.Company__c) && String.isNotBlank(rfcmli.Customer_Name__c)){
                String combinedData = rfcmli.Company__c +  '@@@@' + rfcmli.Customer_Name__c;
                customerName.add(rfcmli.Customer_Name__c);
                company.add(rfcmli.Company__c);
                if(!mapOfCreditTeam.containsKey(combinedData)){
                    mapOfCreditTeam.put(combinedData,null);
                    system.debug('mapOfCreditTeam::'+mapOfCreditTeam);
                    uniqueValues.put(combinedData,rfcmli);
                    system.debug('uniqueValues::'+uniqueValues);
                }
            }
            
        }
        System.debug('@@@@@@yyy' + uniqueValues);

        List<Credit_Team__c>  creditList = [Select Id, User__c, User__r.Email, Company__c, Account__c From Credit_Team__c Where Company__c IN : company AND Account__c IN : customerName];

        for(Credit_Team__c instance  : creditList){
            String combinedData = instance.Company__c +  '@@@@' + instance.Account__c;
            if(mapOfCreditTeam.containsKey(combinedData)){
                mapOfCreditTeam.put(combinedData,instance);
                system.debug('196mapOfCreditTeam::'+mapOfCreditTeam);
            }
        }
        System.debug('@@@@@@' + mapOfCreditTeam);
        
        List<Messaging.SingleEmailMessage> messages = new  List<Messaging.SingleEmailMessage>();
       EmailTemplate emailTemplate = [Select Id,Subject,Description, HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Division Approvers'];
        for(String data : mapOfCreditTeam.keySet()){
            if(mapOfCreditTeam.containsKey(data) && mapOfCreditTeam.get(data) != null){
                //Prashanth starts
                CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='RFCM_notification']; 
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                notification.setTitle('RFCM Request for Credit Team ');
                notification.setBody('Please upload the csv to SAP and generate CM number');
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetId(uniqueValues.get(data).RFCM__c);
                notification.send(new Set<String>{mapOfCreditTeam.get(data).User__c});
            	//Prashanth ends
            	//
            	RFCM__c rfc = [select id,name,Customer_Name__r.Name,unilab_Claim_Description__c,unilab_Claimed_Amount__c,CreatedDate,Encoder__r.name,Customer_Name__c from RFCM__c where id=:uniqueValues.get(data).RFCM__c];
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTargetObjectId(mapOfCreditTeam.get(data).User__c);
                message.setSubject('RFCM : '+rfc.Name+'  For CM Creation -- Action Required');
            	String htmlbody = 'Hi <b>Credit Analyst</b>,';
            	htmlbody ='<div style="padding-top:15px;">You have an RFCM waiting for CM creation.</div>';
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
                message.setHtmlBody(htmlbody);
                //message.toAddresses = new String[] {objRFCM.Encoder__c};
                message.setUseSignature(false);
                message.setBccSender(false);
                message.setSaveAsActivity(false);
                
                //Get templete id for set the templete.

                //message.setTemplateID(emailTemplate.Id);
                message.toAddresses = new String[] { mapOfCreditTeam.get(data).User__r.email};

                messages.add(message);
            }
            

            
        }
        Messaging.SendEmailResult[] results =
            Messaging.sendEmail(messages);
        
    }

}