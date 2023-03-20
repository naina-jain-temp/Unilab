/*-------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   04.23.2019
Definition   :   Batch Apex for inserting Account Allocation Records
-------------------------------------------------------------------------------------------*/
global with sharing class UNILAB_PAL_BatchInsertAccAlloc implements Database.Batchable<sObject>, Database.AllowsCallouts{
    //BATCH TEMPORARY ALLOCATION FOR CONVERSION TO ACCOUNT ALLOCATION
    
    private String allocId;
	private String allocChannel;
    private List<Account_Allocation__c> listOfAccAlloc;
        
    public UNILAB_PAL_BatchInsertAccAlloc(String allocationId, String allocationChannel, List<Account_Allocation__c> processAccAlloc) {
        allocId = allocationId;
        allocChannel = allocationChannel;
        listOfAccAlloc = processAccAlloc;
    }
    
    global Iterable<sObject> start(Database.BatchableContext batchTempForConversion) {
        List<Account_Allocation__c> listAccAlloc = listOfAccAlloc;
        return listAccAlloc;
	}
    
    global void execute(Database.BatchableContext batchTempForConversion, List<Account_Allocation__c> scope) {
        //System.debug('scope----'+scope.size());
        //INSERT ACCOUNT ALLOCATIONS 
        insert scope;
    }
    
    global void finish(Database.BatchableContext batchTempForConversion) {
        
        AsyncApexJob apexJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email, ExtendedStatus
                          from AsyncApexJob where Id = :batchTempForConversion.getJobId()];
        
        if(apexJob.Status == 'Completed') {
            
            //DELETE TEMPORARY ALLOCATION
            UNILAB_PAL_BatchDeleteTempAlloc be = new UNILAB_PAL_BatchDeleteTempAlloc(allocChannel);
            database.executeBatch(be);
            
            Allocation__c allocRec= [SELECT Id,Name, Data_Retrieved__c, Status__c, Channel__c FROM Allocation__c WHERE Id=:allocId];
            
            List<Account_Allocation__c> computedAllocationList = new List<Account_Allocation__c>();
            
            //UPDATE ALLOCATION
            allocRec.Data_Retrieved__c = true;
            allocRec.Status__c = 'Adjustment';
            update allocRec;
            //COMPUTE FOR FINAL ALLOCATION
            //computedAllocationList = UNILAB_PAL_Controller.computeFinalAllocation(allocRec, true);
            
            //SEND UPDATE TO DEV THAT ALLOCATION IS NOW READY FOR ADJUSTMENT AND CONCURRENCE
            Boolean serverDownError = false;
            Boolean nullCalloutValue = false;
            Boolean hasOngoingApexJobs = false;
            sendUpdateEmail(allocRec,serverDownError,nullCalloutValue,hasOngoingApexJobs);
        }
        
    }
    
    public static void sendUpdateEmail(Allocation__c allocRecord, Boolean serverDownError, Boolean nullCalloutValue, Boolean hasOngoingApexJobs){
        Id userId = UserInfo.getUserId();
        String profileId;
        
        User userRecord = [SELECT FirstName,LastName, Email, Channel__c FROM User 
                           WHERE Id=:userId];
        Map<String, Id> mapProfileId = getProfileId();
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        if(userRecord.Channel__c.equals('GT')){ 
            profileId = mapProfileId.get('GT CMD Developer');
            //System.debug('GT CMD DEV: ' + profileId);
            List<User> recipientRecord = new List<User>();
            recipientRecord = [SELECT Email FROM User
                               WHERE ProfileId =: profileId];
            
            mails.add(setEmail(userRecord,recipientRecord,allocRecord,serverDownError,nullCalloutValue,hasOngoingApexJobs));
            Messaging.sendEmail(mails);
        }else if(userRecord.Channel__c.equals('LKA') || userRecord.Channel__c.equals('NKA')){
            profileId = mapProfileId.get('KA CMD Developer');
            //System.debug('GT CMD DEV: ' + profileId);
            List<User> recipientRecord = new List<User>();
            recipientRecord = [SELECT Email FROM User
                               WHERE ProfileId =: profileId];
            
            mails.add(setEmail(userRecord,recipientRecord,allocRecord,serverDownError,nullCalloutValue,hasOngoingApexJobs));
            Messaging.sendEmail(mails);
        }else if(userRecord.Channel__c.equals('MDC')){
            profileId = mapProfileId.get('MDC CMD Developer');
            //System.debug('GT CMD DEV: ' + profileId);
            List<User> recipientRecord = new List<User>();
            recipientRecord = [SELECT Email FROM User
                               WHERE ProfileId =: profileId];
            
            mails.add(setEmail(userRecord,recipientRecord,allocRecord,serverDownError,nullCalloutValue,hasOngoingApexJobs));
            Messaging.sendEmail(mails);
        }else if(userRecord.Channel__c.equals('MT')){
            profileId = mapProfileId.get('MT CMD Developer');
            //System.debug('GT CMD DEV: ' + profileId);
            List<User> recipientRecord = new List<User>();
            recipientRecord = [SELECT Email FROM User
                               WHERE ProfileId =: profileId];
            
            mails.add(setEmail(userRecord,recipientRecord,allocRecord,serverDownError,nullCalloutValue,hasOngoingApexJobs));
            Messaging.sendEmail(mails);
        }else if(userRecord.Channel__c.equals('SALESOPS')){
            profileId = mapProfileId.get('System Administrator');
            List<User> recipientRecord = new List<User>();
            recipientRecord = [SELECT Email FROM User
                               WHERE ProfileId =: profileId];
            
            mails.add(setEmail(userRecord,recipientRecord,allocRecord,serverDownError,nullCalloutValue,hasOngoingApexJobs));
            Messaging.sendEmail(mails);
        }
        
    }
    
    private static Messaging.SingleEmailMessage setEmail(User userRecord, List<User> recipientRecords,Allocation__c allocRecord,Boolean serverDownError,Boolean nullCalloutValue,Boolean hasOngoingApexJobs){
        
        String messageBody = 'Hi '+ userRecord.FirstName + ' ' + userRecord.LastName + '!<br/><br/>';
        String sendrDPName = 'UNILAB PROMO ALLOCATION - Salesforce';
        String subject;
        if(serverDownError){
            subject = 'Promo Allocation : Sales Data Retrieval Error - Server Down';
            messageBody += 'This allocation has encountered an error while retrieving sales data : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+allocRecord.Id+'">'+allocRecord.Name+'</a><br/>';
            messageBody += '<br/>Thanks,<br/> Salesforce' ;
            
        }else if(nullCalloutValue){
            subject = 'Promo Allocation : Sales Data Retrieval - No Available Data';
            messageBody += 'There is no available sales data on this allocation : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+allocRecord.Id+'">'+allocRecord.Name+'</a><br/>';
            messageBody += '<br/>Thanks,<br/> Salesforce' ;
        }else if(hasOngoingApexJobs){
            subject = 'Promo Allocation : Sales Data Retrieval - Queue Timeout';
            messageBody += 'There is a queue timeout on this allocation : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+allocRecord.Id+'">'+allocRecord.Name+'</a> .Please try again.<br/>';
            messageBody += '<br/>Thanks,<br/> Salesforce' ;
        }else{
            subject = 'Promo Allocation: Sales Data Retrieval Complete';
            messageBody += 'This allocation is now ready for adjustment : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+allocRecord.Id+'">'+allocRecord.Name+'</a><br/>';
            messageBody += '<br/>Thanks,<br/> Salesforce';
        }
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        for(User recipientRec:recipientRecords){
            sendTo.add(recipientRec.Email);
        }
        mail.setToAddresses(sendTo);
        mail.setReplyTo(userRecord.Email);
        //mail.setSenderDisplayName(userRecord.FirstName + ' ' + userRecord.LastName); 
        mail.setSenderDisplayName(sendrDPName); 
        mail.setSubject(subject);
        mail.setHtmlBody(messageBody);
        
        
        return mail;
    }
    
    private static Map<String, Id> getProfileId(){
        Map<String, Id> mapProfile = new Map<String, Id>();
        
        for (Profile listOfProfile : [SELECT Id, Name FROM Profile]) {
            mapProfile.put(listOfProfile.Name, listOfProfile.Id);
        }
        
        return mapProfile;
    }
}