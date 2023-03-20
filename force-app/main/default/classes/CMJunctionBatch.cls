global class CMJunctionBatch implements Database.Batchable<sObject>,Database.stateful {
    global Map<String,List<RFCM__c> > emailMessageIds = new Map<String,List<RFCM__c>>();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Id,Name,RFCM__r.Encoder__c,RFCM__r.Customer_Name__r.Name,RFCM__r.Name,RFCM__r.Encoder__r.Name,Customer_Code__c,RFCM__r.unilab_RFCM_No__c,RFCM__r.unilab_CM_No__c,RFCM__r.Customer_Name__c,RFCM__r.unilab_Claimed_Amount__c,RFCM__r.unilab_Claim_Description__c,RFCM__c,CM_No__c,RFCM__r.CreatedById, RFCM__r.CreatedDate  FROM RFCM_Line_Item__C  where CM_No__c =  \'\'';
       
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<RFCM_Line_Item__c> lineItems) {
        
        try{
            system.debug('lineItems::'+lineItems);
            List<RFCM_Line_Item__c> updaterfcmli = new list<RFCM_Line_Item__c>();
            Set<String> CMJunction = New Set<String>();
            Set<String> userIds = New Set<String>();
            Map<String,String> custRFCMMap = new Map<String,String>();
            
            for(RFCM_Line_Item__c inst : lineItems) {  
                System.debug(inst.Name);
                userIds.add(inst.RFCM__r.Encoder__c);
                CMJunction.add(inst.Customer_Code__c+inst.RFCM__r.Name);
                system.debug('CMJunction'+CMJunction);
                //CMJunction.add(inst.RFCM__r.Name+'-'+inst.Customer_Code__c);
            }
            System.debug(userIds);
            
            Map<Id,User> usrLst = new Map<Id,User>([Select Id,Email from User Where Id=: userIds]);
            System.debug(usrLst);
            List<CM_Junction__c> CMJunctionList = [select id,Name,CustRFCM_Code__c from CM_Junction__c where CustRFCM_Code__c in : CMJunction ];
            
            system.debug('CMJunctionList::'+CMJunctionList);
            for(CM_Junction__c inst : CMJunctionList){
                custRFCMMap.put(inst.custRFCM_Code__c,inst.Name);
            }
            
            
            for(RFCM_Line_Item__c inst : lineItems){
                //inst.CM_No__c = custRFCMMap.get(inst.RFCM__r.Name+'-'+inst.Customer_Code__c); 
                
                if(custRFCMMap.containsKey(inst.Customer_Code__c+inst.RFCM__r.Name) == true && custRFCMMap.get(inst.Customer_Code__c+inst.RFCM__r.Name)!= ''){
                RFCM__c rec = new RFCM__c();
                rec.Id =inst.RFCM__c;
                rec.Name = inst.RFCM__r.Name;
                rec.unilab_CM_No__c = inst.RFCM__r.unilab_CM_No__c;
                rec.unilab_Claim_Description__c = inst.RFCM__r.unilab_Claim_Description__c;
                rec.unilab_Claimed_Amount__c = inst.RFCM__r.unilab_Claimed_Amount__c;
                rec.unilab_RFCM_No__c = inst.RFCM__r.unilab_RFCM_No__c;
                rec.unilab_Company__c = inst.RFCM__r.Encoder__r.Name;
                rec.Condition_Type__c =inst.RFCM__r.Customer_Name__r.Name;
                rec.Current_Approver__c = inst.RFCM__r.Encoder__c;
                
                
                inst.CM_No__c = custRFCMMap.get(inst.Customer_Code__c+inst.RFCM__r.Name);
                updaterfcmli.add(inst);
                User usr = usrLst.get( inst.RFCM__r.Encoder__c );
                /*if( emailMessageIds != null && emailMessageIds.containskey( usr.Email+'-'+rec.Id ) == true ){
                    System.debug('inside');
                    List<RFCM__c> dummyLst = emailMessageIds.get(usr.Email+'-'+rec.Id);
                    system.debug('dummyLst:::'+dummyLst);
                    dummyLst.add(rec);
                    system.debug('dummyLst1:::'+dummyLst);
                    emailMessageIds.put( usr.Email, dummyLst );
                    system.debug('emailMessageIds'+emailMessageIds);
                }else{
                    System.debug('else');
                    emailMessageIds.put( usr.Email+'-'+rec.Id , new List<RFCM__c>{rec} );
                    System.debug('after');
                }*/
                    if(emailMessageIds.containskey( usr.Email+'-'+rec.Id ) == false){
                        emailMessageIds.put( usr.Email+'-'+rec.Id , new List<RFCM__c>{rec} );
                        system.debug('emailMessageIds'+emailMessageIds);
                    }
                }

            }            
            update updaterfcmli;            
        }
        catch(Exception e){
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        try{
            
            System.debug('in finish' + emailMessageIds);
            List< Messaging.SingleEmailMessage > emlLst = new List< Messaging.SingleEmailMessage >();
            for(String key : emailMessageIds.keySet()){
                if( emailMessageIds.get(key) != null ){
                    List<String> keys = key.split('-');
                    List<RFCM__c> records = emailMessageIds.get(key);
                    CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='RFCM_notification']; 
                    for( RFCM__c rfcm : records ){
                        //Prashanth starts
                        //CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='RFCM_notification']; 
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();
                        notification.setTitle('RFCM Request for CM acknowledgement ');
                        notification.setBody('Please Acknowledge the RFCM '+rfcm.Name +'submitted for CM');
                        notification.setNotificationTypeId(notificationType.Id);
                        notification.setTargetId(rfcm.Id);
                        system.debug('rfcm.Current_Approver__c:::'+rfcm.Current_Approver__c);
                        notification.send(new Set<String>{rfcm.Current_Approver__c});
                        //Prahsanth Ends
                        Messaging.SingleEmailMessage emal = new Messaging.SingleEmailMessage();
                        emal.setToAddresses( new List<String>{ keys[0] });
                        emal.setSubject('[RFCM : '+rfcm.Name+'] For CM Acknowledgment -- Due Today');
                        system.debug('emal.setToAddresses::'+new List<String>{ keys[0] });
                        String htmlbody = 'Hi <b>'+rfcm.unilab_Company__c+'</b>,';
                        htmlbody ='<div style="padding-top:15px;">You have an approved RFCM waiting for your CM acknowledgment. Please review and take action now.</div>';
                        htmlbody +='<div style="padding-top:15px;">';
                        htmlbody +='RFCM Number: '+rfcm.Name+'<br/>';
                        htmlbody +='Claim Description: '+rfcm.unilab_Claim_Description__c+'<br/>';
                        htmlbody +='Claim Amount: '+rfcm.unilab_Claimed_Amount__c+'<br/>';
                        htmlbody +='Request Date: '+rfcm.CreatedDate+'<br/>';
                        htmlbody +='Account Name: '+rfcm.Condition_Type__c+'<br/>';
                        htmlbody +='CM Number: '+rfcm.unilab_CM_No__c+'<br/>';
                        htmlbody +='</div>';
                        htmlbody +='<div style="padding-top:15px;">';
                        htmlbody +='You can view your request by clicking this <a href="'+System.label.RFCM_URL+''+rfcm.Id+'/view" style="text-decoration:none;color:#;text-decoration:underline;">Click Here</a><br/>';
                        htmlbody +='If you have no more issues on this claim, kindly <a href="'+System.label.RFCM_URL+''+rfcm.Id+'/view" style="text-decoration:none;color:#;text-decoration:underline;">Click this</a> to acknowledge and close this transaction.';
                        htmlbody +='</div>';
                        htmlbody +='<div style="padding-top:15px;">';
                        htmlbody +='This is a system generated email. Please do not reply.';
                        htmlbody +='</div>';
                        emal.setHtmlBody(htmlbody);
                        emlLst.add(emal); 
                        system.debug('emal::'+emal);
                    }
                }
                
                
            }
            if( emlLst.Size() > 0 ){
                Messaging.sendEmail(emlLst);
            } 
            
        }catch(Exception e){
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
        }

        
    }
}