@isTest
public with sharing class TestTCRDataFactory { 

    public static void createChatterGroup(){
        List<CollaborationGroup> ExistingPOC = [SELECT Id,Name FROM CollaborationGroup WHERE Name = 'POC Channel Group'];
        if(!ExistingPOC.isEmpty()){
            CollaborationGroup poc = new CollaborationGroup();
            poc.Name='POC Channel Group';
            poc.CollaborationType='Public'; //can be 'Public' or 'Private'                   
            insert poc;
        }
        List<CollaborationGroup> ExistingPOS = [SELECT Id,Name FROM CollaborationGroup WHERE Name = 'POS Channel Group'];
        if(!ExistingPOS.isEmpty()){
            CollaborationGroup pos = new CollaborationGroup();
            pos.Name='POS Channel Group';
            pos.CollaborationType='Public'; //can be 'Public' or 'Private'                   
            insert pos;
        }
    }
    public static User createUserAdmin(String username) {
        
        UserRole adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        Id sysAdId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        
        User user = new User(LastName = 'Test System Admin',
                        Alias = 'tsysad',
                        Email = 'test.sysad@unilabtest.com',
                        Username = username,
                        ProfileId = sysAdId,
                        TimeZoneSidKey = 'GMT',
                        LanguageLocaleKey = 'en_US',
                        EmailEncodingKey = 'UTF-8',
                        LocaleSidKey = 'en_US',
                        Channel__c = 'SALESOPS',
                        UserRoleId = adminRole.Id);
        insert user;
         User newUser = [SELECT Id,UserRoleId FROM User WHERE Id = :user.Id];
        return newUser;
    }
    
    public static User createUserChannelHead(String role,String username,String profile){
        UserRole chRole = [SELECT Id, Name FROM UserRole WHERE Name = :role];
        Id profileCH = [SELECT Id FROM Profile WHERE Name = :profile].Id;
        
        User userCH = new User(LastName = 'Test ChannelHead',
                                Alias = 'cHead',
                                Email = 'CHeadTEST@unilab.com',
                                FirstName ='FirstName CHead',
                                Username = username,
                                ProfileId = profileCH,
                                TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US',
                                EmailEncodingKey = 'UTF-8',
                                LocaleSidKey = 'en_US',
                                Channel__c = 'SALESOPS',
                                UserRoleId = chRole.Id);
        insert userCH;  
        User newUser = [SELECT Id,UserRoleId FROM User WHERE Id = :userCH.Id];
        return newUser;
    }
      
    public static User createUserTL(String role,String username,Id chID,String profile) {
        
        UserRole tlRole = [SELECT Id, Name FROM UserRole WHERE Name = :role];
        Id profileTLID = [SELECT Id FROM Profile WHERE Name = :profile].Id;
        User userTL = new User(LastName = 'Test TL',
                               FirstName ='FirstName TL',
                               Alias = 'tsTL',
                               Email = 'TLtest.sysad@unilab.com',
                               Username = username,
                               ProfileId = profileTLID,
                               TimeZoneSidKey = 'GMT',
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Channel__c = 'SALESOPS',
                               ManagerId = chID,
                               UserRoleId = tlRole.Id);
        
      
        insert userTL;   
        User newUser = [SELECT Id,UserRoleId FROM User WHERE Id = :userTL.Id];
        return newUser;
    }
    
    public static User createUserCDS(Id tlID,String role,String username,String profile){
        UserRole cdsRole = [SELECT Id, Name FROM UserRole WHERE Name = :role];
        Id profileTLCDS = [SELECT Id FROM Profile WHERE Name = :profile].Id;
        
        User userCDS = new User(LastName = 'Test CDS',
                           Alias = 'tscds',
                                Email = 'CDSTEST@unilab.com',
                                FirstName ='FirstName CDS',
                                Username = username,
                                ProfileId = profileTLCDS,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           Channel__c = 'SALESOPS',
                           ManagerId =tlID,
                           UserRoleId = cdsRole.Id);
        insert userCDS;  
        User newUser = [SELECT Id,UserRoleId FROM User WHERE Id = :userCDS.Id];
        return newUser;
    }
    
    public static Id createAccountMainWareHouse(String accountName,String BillToCode,String ShipToCode){
        Account acc = new Account();
        acc.Name = accountName;
        acc.Team__c = 'SM Group';
        acc.Account_Group__c = '7-ELEVEN';
        acc.Account_Status__c = 'Active';
        acc.Bill_To_Code__c = BillToCode;
        acc.Ship_To_Code__c = ShipToCode;
        acc.Data_Source__c = 'SAP';
        acc.Ship_To_Name__c = 'ShipTo';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Main/Warehouse').getRecordTypeId();
        
        insert acc;
        return acc.Id;
    }
    
    public static Id createAccountBranch(Id parentId){
        Account acc = new Account();
        acc.Name = 'AccountBranch';
        acc.Team__c = 'SM Group';
        acc.Account_Group__c = '7-ELEVEN';
        acc.Account_Status__c = 'Active';
        acc.Bill_To_Code__c = '9999999999';
        acc.Ship_To_Code__c = '0000000002';
        acc.Data_Source__c = 'SAP';
        acc.Ship_To_Name__c = 'ShipTo';
        acc.ParentId = parentId;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch/Single Accounts').getRecordTypeId();
        
        insert acc;
        return acc.Id;
    }
    
    public static Id createTLFieldWorkEvent(User cds,Id recordType){
        
        UNIlAB_ActivityManagementCX.EventRecord fieldWorkEvent = UNIlAB_ActivityManagementCX.getEventRecord(null);
        
        List<Sub_Activity__c> subActivityList = new List<Sub_Activity__c>();
        String strSubActivityList = JSON.Serialize(subActivityList);  
        fieldWorkEvent.event.Event_Type__c = 'Field Work';
        fieldWorkEvent.event.Event_Sub_type__c = 'Training Contact';
        fieldWorkEvent.event.Location_Custom__c = 'Pasig City';
        fieldWorkEvent.event.Location_Based__c = 'Home Base';
        fieldWorkEvent.event.Field_Work_Record_Type__c = recordType;
        fieldWorkEvent.event.Work_With_ID__c = cds.Id;
   
        Id newFieldWorkEventId = UNIlAB_ActivityManagementCX.saveEventRecord(fieldWorkEvent.event, strSubActivityList, 'Sample Remark');
        //insert fieldWorkEvent;
       
        return newFieldWorkEventId;
    }
    
    public static Id createCDSFieldWorkEvent(Contact contact,Id recordType){
        
        UNIlAB_ActivityManagementCX.EventRecord fieldWorkEvent = UNIlAB_ActivityManagementCX.getEventRecord(null);
        List<Sub_Activity__c> subActivityList = new List<Sub_Activity__c>();
        String strSubActivityList = JSON.Serialize(subActivityList);  
        
        fieldWorkEvent.event.Event_Type__c = 'Field Work';
        fieldWorkEvent.event.Event_Sub_type__c = 'Training Contact';
        fieldWorkEvent.event.Location_Custom__c = 'Pasig City';
        fieldWorkEvent.event.Location_Based__c = 'Home Base';
        fieldWorkEvent.event.WhoId = contact.Id;
        fieldWorkEvent.event.Field_Work_Record_Type__c = recordType;
        Id newFieldWorkEventId = UNIlAB_ActivityManagementCX.saveEventRecord(fieldWorkEvent.event, strSubActivityList, 'Sample Remark');
        //insert fieldWorkEvent;
        
        return newFieldWorkEventId;
    }
    
    public static Id createCDSBranchCall (Id accountId,Id contactId){
        List<Sub_Activity__c> subActivityList = new List<Sub_Activity__c>();
        Sub_Activity__c subActivity = new Sub_Activity__c();
        subActivity.Activity_Name__c = 'COMPETITIVE ACTIVITY';
        subActivityList.add(subActivity);
        Event event = UNILAB_ActivityManagementCX.getEventRecord(null).event; 
        event.Id = null;
        event.Event_Type__c ='Call';
        event.Event_Sub_type__c ='BRANCH CALL';
        event.WhoId = contactId;
        event.Related_To_Account__c = accountId;
        String strSobjects = JSON.Serialize(subActivityList);   
        
        Id recordId = UNILAB_ActivityManagementCX.saveEventRecord(event,strSobjects,'remarks');
        return null;
    }
    
    public static Id createCDSHeadOfficeCall(Id accountId,Id contactId){
        List<Sub_Activity__c> subActivityList = new List<Sub_Activity__c>();
        Sub_Activity__c subActivity = new Sub_Activity__c();
        subActivity.Activity_Name__c = 'DISTRIBUTOR MANAGEMENT';
        subActivityList.add(subActivity);
        Event event = UNILAB_ActivityManagementCX.getEventRecord(null).event; 
        event.Id = null;
        event.Event_Type__c ='Call';
        event.Event_Sub_type__c ='HEAD OFFICE CALL';
        event.WhoId = contactId;
        event.Related_To_Account__c = accountId;
        String strSobjects = JSON.Serialize(subActivityList);   
        
        Id recordId = UNILAB_ActivityManagementCX.saveEventRecord(event,strSobjects,'Sample Remarks');
        return null;
    }
    public static Id createCDSMeeting(Id contactId){
        List<Sub_Activity__c> subActivityList = new List<Sub_Activity__c>();
        Sub_Activity__c subActivity = new Sub_Activity__c();
        subActivity.Activity_Name__c = 'TEAM MEETING';
        subActivityList.add(subActivity);
        Event event = UNILAB_ActivityManagementCX.getEventRecord(null).event; 
        event.Id = null;
        event.Event_Type__c ='Meeting';
        event.Event_Sub_type__c ='MEETING';
        event.WhoId = contactId;
        String strSobjects = JSON.Serialize(subActivityList);   
        
        Id recordId = UNILAB_ActivityManagementCX.saveEventRecord(event,strSobjects,'remarks');
        return null;
    }
    public static Id createContact(String Role, Id accountId){
        Contact contact = new Contact();
        contact.Salutation = 'Mr.';
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.AccountId = accountId;
        contact.Role_Assignment__c = Role;
        insert contact;
        return contact.Id;
    }
    
    public static void createActivityMatrix(Id roleId,String name){
        UserRole userRole = [SELECT Id, Name FROM UserRole WHERE Id = : roleId];
              List<Activity_Dependency__c> actDependencyTest = new List<Activity_Dependency__c>();
        
        actDependencyTest.add(new Activity_Dependency__c(Name = name+'1',
                                                         Role_ID__c = userRole.Id,
                                                         Role_Name__c = userRole.Name,
                                                         Activity_Name__c = 'COMPETITIVE ACTIVITY',
                                                         Event_Sub_Type__c = 'BRANCH CALL',
                                                         Channel__c = 'SALESOPS'));
        actDependencyTest.add(new Activity_Dependency__c(Name = name+'2',
                                                         Role_ID__c = userRole.Id,
                                                         Role_Name__c = userRole.Name,
                                                         Activity_Name__c = 'DISTRIBUTOR MANAGEMENT',
                                                         Event_Sub_Type__c = 'HEAD OFFICE CALL',
                                                         Channel__c = 'SALESOPS'));
        actDependencyTest.add(new Activity_Dependency__c(Name = name+'3',
                                                         Role_ID__c = userRole.Id,
                                                         Role_Name__c = userRole.Name,
                                                         Activity_Name__c = 'TEAM MEETING',
                                                         Event_Sub_Type__c = 'MEETING',
                                                         Channel__c = 'SALESOPS'));
        insert actDependencyTest;
    }
    
    
    
    public static void createTCRCustomSettings(){
        //GT TL
        createCustomSettingTCRMatrixFields('1', 'POS-GT Team Lead (Mindanao)', 'CALL', 'HEAD OFFICE CALL','SUBD AUDIT TCR','Field Work','Training Contact');                
        createCustomSettingTCRMatrixFields('2', 'POS-GT Team Lead (Mindanao)', 'MEETING','MEETING', 'MEETING TCR','Field Work','Training Contact');
        createCustomSettingTCRMatrixFields('3', 'POS-GT Team Lead (Mindanao)', 'FIELD WORK','TRAINING CONTACT', 'T3 TCR','Field Work','Training Contact');
        //GT CDS
        createCustomSettingTCRMatrixFields('4', 'POS-GT CDS (Mindanao)', 'CALL', 'HEAD OFFICE CALL','SUBD AUDIT TCR','Field Work','Training Contact');                
        createCustomSettingTCRMatrixFields('5', 'POS-GT CDS (Mindanao)', 'FIELD WORK','TRAINING CONTACT', 'T3 TCR','Field Work','Training Contact');
        //GT Channel Head
        createCustomSettingTCRMatrixFields('5', 'POS-GT Channel Head', 'CALL','HEAD OFFICE CALL', 'SUBD AUDIT TCR','Field Work','Training Contact');
        createCustomSettingTCRMatrixFields('6', 'POS-GT Channel Head', 'MEETING','MEETING', 'MEETING TCR','Field Work','Training Contact');
        //KA TL
        createCustomSettingTCRMatrixFields('7', 'POS-KA Team Lead (VisMin)', 'CALL','BRANCH CALL', 'ACCOUNT TCR','Field Work','Training Contact');                
        createCustomSettingTCRMatrixFields('8', 'POS-KA Team Lead (VisMin)', 'MEETING','MEETING', 'MEETING TCR','Field Work','Training Contact');
        
        //createCustomSettingTCRMatrixFields('9', 'POS-KA CDS (VisMin)', 'CALL', 'SUBD AUDIT TCR');   
        //createCustomSettingTCRMatrixFields('10', 'POS-KA CDS (VisMin)', 'MEETING', 'MEETING TCR');
        createCustomSettingTCRMatrixFields('9', 'POS-KA Channel Head', 'CALL','BRANCH CALL', 'ACCOUNT TCR','Field Work','Training Contact');
        createCustomSettingTCRMatrixFields('10', 'POS-KA Channel Head', 'MEETING','MEETING', 'MEETING TCR','Field Work','Training Contact');
        
        
        
    }
    
    
    public static void createCustomSettingTCRRequiredFields(String name, String PageName,String RequiredField, String PageNo, String TCRType){
        
        TCR_Required_Fields_Config__c fields = new TCR_Required_Fields_Config__c(Name = name,Page_Name__c=PageName,Required_Field__c = RequiredField,Page_No__c = PageNo,TCR_Type__c = TCRType);  
    	insert fields;
    }
     
    public static void createCustomSettingTCRMatrixFields(String name, String role, String eventType,String eventSubType, String tcrType,String tlEventType,String tlEventSubType){
        
        TCR_Matrix__c fields = new TCR_Matrix__c(Name = name, 
                                                 Role__c = role, 
                                                 Event_Type__c = eventType,
                                                 Event_Sub_Type__c = eventSubType, 
                                                 TCR_Type__c = tcrType,
                                                 TL_Event_Type__c = tlEventType,
                                                 TL_Event_Sub_Type__c = tlEventSubType);
        insert fields;
        
    }
    	
}