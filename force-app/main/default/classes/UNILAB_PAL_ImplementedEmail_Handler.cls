/*----------------------------------------------------------------------------------------------------
Author       :   Kristjan Mariano
Created Date :   05.06.2019
Definition   :   Trigger Handler for UNILAB_PAL_ImplementedEmail_Trigger
-----------------------------------------------------------------------------------------------------*/
public class UNILAB_PAL_ImplementedEmail_Handler {
    
    public static void doAfterUpdate(List<Id> promoId){
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 
        
        List<Allocation__c> allocGTList = [SELECT Id, Name, Channel__c, Total_Account_Allocation__c, Promo__c, Promo__r.Promo_Name__c FROM Allocation__c WHERE Promo__c =: promoId AND Channel__c = 'General Trade'];
        List<Allocation__c> allocMTList = [SELECT Id, Name, Channel__c, Total_Account_Allocation__c, Promo__c, Promo__r.Promo_Name__c FROM Allocation__c WHERE Promo__c =: promoId AND Channel__c = 'Modern Trade'];
        List<Allocation__c> allocMDCList = [SELECT Id, Name, Channel__c, Total_Account_Allocation__c, Promo__c, Promo__r.Promo_Name__c FROM Allocation__c WHERE Promo__c =: promoId AND Channel__c = 'Mercury'];
        List<Allocation__c> allocKAList = [SELECT Id, Name, Channel__c, Total_Account_Allocation__c, Promo__c, Promo__r.Promo_Name__c FROM Allocation__c WHERE Promo__c =: promoId AND Channel__c = 'Key Accounts'];
        
        mails.add(pmogEmail(promoId[0]));
        
        if(allocGTList.size() > 0){
            mails.add(gtCMDDev(promoId[0]));
        }
        if(allocMTList.size() > 0){
            mails.add(mtCMDDev(promoId[0]));
        }
        if(allocMDCList.size() > 0){
            mails.add(mdcCMDDev(promoId[0]));
        }
        if(allocKAList.size() > 0){
            mails.add(kaCMDDev(promoId[0]));
        }
        
        Messaging.sendEmail(mails);
    }
    
    public static Messaging.SingleEmailMessage pmogEmail(Id promoId){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        Map<String, Id> mapProfileId = getProfileId();
        // Change to PMOG profile
        String pmogProfileId = mapProfileId.get('CMD Lead');

        List<User> recipientList = new List<User>();
        
        recipientList = [SELECT Name, Email FROM User
                           WHERE ProfileId =: pmogProfileId];
        
        List<Allocation__c> allocList = [SELECT Id, Name, Channel__c, Total_Account_Allocation__c, Promo__c, Promo__r.Name FROM Allocation__c WHERE Promo__c =: promoId AND Promo__r.Status__c = 'Implemented'];
        String subject = 'Implemented Promo Summary';
        String promoRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + promoId;
        String htmlBody = 'Greetings '+recipientList[0].Name+', <br/> Please see the summary of all allocations for <a href="'+promoRecordURL+'">'+allocList.get(0).Promo__r.Name+'</a> promo <br/>';
        htmlBody = '<tr><th>Allocation ID</th><th>Channel</th><th>Channel Allocation Volume</th></tr>';
        Decimal totalAlloc = 0;
        for(Allocation__c alloc:allocList){
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + alloc.Id;
            totalAlloc += alloc.Total_Account_Allocation__c;
            htmlBody += '<tr><td><a href="'+fullRecordURL+'">'+alloc.Name +'</a></td><td>'+alloc.Channel__c+'</td><td>'+alloc.Total_Account_Allocation__c+'</td></tr>';
        }
        htmlBody += '<tr><td></td><td><b>Total Allocation:</b></td><td>'+totalAlloc+'</td></tr><br/><br/>';
        htmlBody += 'Regards, <br/> Salesforce';
        
        List<String> sendTo = new List<String>();
        for(User recipientRec:recipientList){
            sendTo.add(recipientRec.Email);
        }
        mail.setToAddresses(sendTo);
        mail.setReplyTo('noreply@gmail.com');
        mail.setSenderDisplayName('Salesforce'); 
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        
        return mail;
    }
    
    public static Messaging.SingleEmailMessage gtCMDDev(Id promoId){
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Map<String, Id> mapProfileId = getProfileId();
        String profileId = mapProfileId.get('GT CMD Developer');
        List<User> recipientList = new List<User>();
        
        recipientList = [SELECT Id, Name, Email FROM User
                           WHERE ProfileId =: profileId];
        
        
        List<Allocation__c> allocList = [SELECT Id, Name, Channel__c, Total_Account_Allocation__c, Promo__c, Promo__r.Promo_Name__c FROM Allocation__c WHERE Promo__c =: promoId AND Channel__c = 'General Trade'];
        String subject =  allocList[0].Promo__r.Promo_Name__c+' has been implemented';
        String allocRecordUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + allocList[0].Id;
        String htmlBody = 'Greetings '+recipientList[0].Name+', <br/> Please see the summary of  <a href="'+allocRecordUrl+'">'+allocList.get(0).Name+'</a> under your channel below<br/>';
        htmlBody = '<tr><th>Allocation ID</th><th>Channel</th><th>Channel Allocation Volume</th></tr>';
        Decimal totalAlloc = 0;
        for(Allocation__c alloc:allocList){
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + alloc.Id;
            totalAlloc += alloc.Total_Account_Allocation__c;
            htmlBody += '<tr><td><a href="'+fullRecordURL+'">'+alloc.Name +'</a></td><td>'+alloc.Channel__c+'</td><td>'+alloc.Total_Account_Allocation__c+'</td></tr>';
        }
        htmlBody += '<tr><td></td><td><b>Total Allocation:</b></td><td>'+totalAlloc+'</td></tr><br/><br/>';
        htmlBody += 'Regards, <br/> Salesforce';
        
        List<String> sendTo = new List<String>();
        for(User recipientRec:recipientList){
            sendTo.add(recipientRec.Email);
        }
        mail.setToAddresses(sendTo);
        mail.setReplyTo('noreply@gmail.com');
        mail.setSenderDisplayName('Salesforce'); 
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        
        sendToCDS(promoId,allocList[0]);
        
        return mail;
    }
    
    public static Messaging.SingleEmailMessage kaCMDDev(Id promoId){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Map<String, Id> mapProfileId = getProfileId();
        String profileId = mapProfileId.get('GT CMD Developer');
        List<User> recipientList = new List<User>();
        
        recipientList = [SELECT Id, Name, Email FROM User
                           WHERE ProfileId =: profileId];
        
        
        List<Allocation__c> allocList = [SELECT Id, Name, Channel__c, Total_Account_Allocation__c, Promo__c, Promo__r.Promo_Name__c FROM Allocation__c WHERE Promo__c =: promoId AND Channel__c = 'Key Accounts'];
        String subject =  allocList[0].Promo__r.Promo_Name__c+' has been implemented';
        String allocRecordUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + allocList[0].Id;
        String htmlBody = 'Greetings '+recipientList[0].Name+', <br/> Please see the summary of  <a href="'+allocRecordUrl+'">'+allocList.get(0).Name+'</a> under your channel below<br/>';
        htmlBody = '<tr><th>Allocation ID</th><th>Channel</th><th>Channel Allocation Volume</th></tr>';
        Decimal totalAlloc = 0;
        for(Allocation__c alloc:allocList){
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + alloc.Id;
            totalAlloc += alloc.Total_Account_Allocation__c;
            htmlBody += '<tr><td><a href="'+fullRecordURL+'">'+alloc.Name +'</a></td><td>'+alloc.Channel__c+'</td><td>'+alloc.Total_Account_Allocation__c+'</td></tr>';
        }
        htmlBody += '<tr><td></td><td><b>Total Allocation:</b></td><td>'+totalAlloc+'</td></tr><br/><br/>';
        htmlBody += 'Regards, <br/> Salesforce';
        
        List<String> sendTo = new List<String>();
        for(User recipientRec:recipientList){
            sendTo.add(recipientRec.Email);
        }
        mail.setToAddresses(sendTo);
        mail.setReplyTo('noreply@gmail.com');
        mail.setSenderDisplayName('Salesforce'); 
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        
        sendToCDS(promoId,allocList[0]);
        
        return mail;
    }
    
    public static Messaging.SingleEmailMessage mtCMDDev(Id promoId){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        Map<String, Id> mapProfileId = getProfileId();
        String profileId = mapProfileId.get('GT CMD Developer');
        List<User> recipientList = new List<User>();
        
        recipientList = [SELECT Id, Name, Email FROM User
                           WHERE ProfileId =: profileId];
        
        
        List<Allocation__c> allocList = [SELECT Id, Name, Channel__c, Total_Account_Allocation__c, Promo__c, Promo__r.Promo_Name__c FROM Allocation__c WHERE Promo__c =: promoId AND Channel__c = 'Modern Trade'];
        String subject =  allocList[0].Promo__r.Promo_Name__c+' has been implemented';
        String allocRecordUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + allocList[0].Id;
        String htmlBody = 'Greetings '+recipientList[0].Name+', <br/> Please see the summary of  <a href="'+allocRecordUrl+'">'+allocList.get(0).Name+'</a> under your channel below<br/>';
        htmlBody = '<tr><th>Allocation ID</th><th>Channel</th><th>Channel Allocation Volume</th></tr>';
        Decimal totalAlloc = 0;
        for(Allocation__c alloc:allocList){
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + alloc.Id;
            totalAlloc += alloc.Total_Account_Allocation__c;
            htmlBody += '<tr><td><a href="'+fullRecordURL+'">'+alloc.Name +'</a></td><td>'+alloc.Channel__c+'</td><td>'+alloc.Total_Account_Allocation__c+'</td></tr>';
        }
        htmlBody += '<tr><td></td><td><b>Total Allocation:</b></td><td>'+totalAlloc+'</td></tr><br/><br/>';
        htmlBody += 'Regards, <br/> Salesforce';
        
        List<String> sendTo = new List<String>();
        for(User recipientRec:recipientList){
            sendTo.add(recipientRec.Email);
        }
        mail.setToAddresses(sendTo);
        mail.setReplyTo('noreply@gmail.com');
        mail.setSenderDisplayName('Salesforce'); 
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        
        sendToCDS(promoId,allocList[0]);
        
        return mail;
    }
    
    public static Messaging.SingleEmailMessage mdcCMDDev(Id promoId){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        Map<String, Id> mapProfileId = getProfileId();
        String profileId = mapProfileId.get('GT CMD Developer');
        List<User> recipientList = new List<User>();
        
        recipientList = [SELECT Id, Name, Email FROM User
                           WHERE ProfileId =: profileId];
        
        
        List<Allocation__c> allocList = [SELECT Id, Name, Channel__c, Total_Account_Allocation__c, Promo__c, Promo__r.Promo_Name__c FROM Allocation__c WHERE Promo__c =: promoId AND Channel__c = 'Mercury'];
        String subject =  allocList[0].Promo__r.Promo_Name__c+' has been implemented';
        String allocRecordUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + allocList[0].Id;
        String htmlBody = 'Greetings '+recipientList[0].Name+', <br/> Please see the summary of  <a href="'+allocRecordUrl+'">'+allocList.get(0).Name+'</a> under your channel below<br/>';
        htmlBody = '<tr><th>Allocation ID</th><th>Channel</th><th>Channel Allocation Volume</th></tr>';
        Decimal totalAlloc = 0;
        for(Allocation__c alloc:allocList){
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + alloc.Id;
            totalAlloc += alloc.Total_Account_Allocation__c;
            htmlBody += '<tr><td><a href="'+fullRecordURL+'">'+alloc.Name +'</a></td><td>'+alloc.Channel__c+'</td><td>'+alloc.Total_Account_Allocation__c+'</td></tr>';
        }
        htmlBody += '<tr><td></td><td><b>Total Allocation:</b></td><td>'+totalAlloc+'</td></tr><br/><br/>';
        htmlBody += 'Regards, <br/> Salesforce';
        
        List<String> sendTo = new List<String>();
        for(User recipientRec:recipientList){
            sendTo.add(recipientRec.Email);
        }
        mail.setToAddresses(sendTo);
        mail.setReplyTo('noreply@gmail.com');
        mail.setSenderDisplayName('Salesforce'); 
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        
        sendToCDS(promoId,allocList[0]);
        
        return mail;
    }
    
    public static void sendToCDS(Id promoId, Allocation__c allocRecord){
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 
        
        List<Account_Allocation__c> accAllocList = [SELECT Id, Final_Allocation__c, Account__c, Account__r.OwnerId, Account__r.Name FROM Account_Allocation__c WHERE Allocation__c =: allocRecord.Id];
        List<String> recipientList = new List<String>();
        for(Account_Allocation__c accAlloc:accAllocList){
            recipientList.add(accAlloc.Account__r.OwnerId);
        }
        List<User> userList = [SELECT Id, Email,NAME FROM User WHERE Id IN: recipientList];
        
        for(User userRec:userList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            String subject = allocRecord.Promo__r.Promo_Name__c+' has been implemented';
            String allocRecordUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + allocRecord.Id;
            String htmlBody = 'Greetings '+userRec.Name+', <br/> Please see the summary of  <a href="'+allocRecordUrl+'">'+allocRecord.Name+'</a> under your channel below<br/>';
            htmlBody = '<tr><th>Allocation ID</th><th>Final Allocation</th></tr>';
            Decimal totalAlloc = 0;
            for(Account_Allocation__c alloc:accAllocList){
                totalAlloc += alloc.Final_Allocation__c;
                htmlBody += '<tr><td>'+alloc.Account__r.Name +'</td><td>'+alloc.Final_Allocation__c+'</td></tr>';
            }
            htmlBody += '<tr><td><b>Total Allocation:</b></td><td>'+totalAlloc+'</td></tr><br/><br/>';
            htmlBody += 'Regards, <br/> Salesforce';
            
            List<String> sendTo = new List<String>();
            sendTo.add(userRec.Email);
            
            mail.setToAddresses(sendTo);
            mail.setReplyTo('noreply@gmail.com');
            mail.setSenderDisplayName('Salesforce'); 
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            
            mails.add(mail);
        }
       
        //mails.add(gtCDS(promoId, allocList.get(0)));
        Messaging.sendEmail(mails);
    }
    
    public static Map<String, Id> getProfileId(){
        Map<String, Id> mapProfile = new Map<String, Id>();
        
        for (Profile listOfProfile : [SELECT Id, Name FROM Profile]) {
            mapProfile.put(listOfProfile.Name, listOfProfile.Id);
        }
        
        return mapProfile;
    }

}