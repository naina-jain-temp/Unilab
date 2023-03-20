/*-------------------------------------------------------------------------------------------
Author       :   Manuelito Ortega
Created Date :   09.13.2018
Definition   :   UNILAB_TrainingContactController Test Class
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_TrainingContactController_Test {
     
    //User username
    private static final String ADMIN_USERNAME ='UnilabAdmin@unilabtest.com';
    private static final String POS_GT_CHANNEL_HEAD = 'POSGTCH@unilabtest.com';
    private static final String POS_KA_CHANNEL_HEAD = 'POSKACH@unilabtest.com';
    private static final String POS_GT_TL ='POSGTTL@unilabtest.com';
    private static final String POS_GT_CDS ='POSGTCDS@unilabtest.com';
    private static final String POS_KA_TL ='POSKATL@unilabtest.com';
    private static final String POS_KA_CDS ='POSKACDS@unilabtest.com';
    //Events
    public static Id posGTfieldWorkTLEventId;
    public static Id posGTfieldWorkCDSEventId;
	public static Id posGTWarehouseAccountId;
    public static Id posGTbranchAccountId;
    public static Id posGTbranchCallCDSEventId;
    
    public static Id posKAfieldWorkTLEventId;
    public static Id posKAfieldWorkCDSEventId;
	public static Id posKAWarehouseAccountId;
    public static Id posKAbranchAccountId;
    public static Id posKAbranchCallCDSEventId;
    //TCR TYPES
    private static final String TCR_TYPE_T3_TCR = 'T3 TCR';
    private static final String TCR_TYPE_TRADE_TCR ='TRADE TCR';
    private static final String TCR_TYPE_SUBAUDIT_TCR ='SUBD AUDIT TCR';
    private static final String TCR_TYPE_MEETING_TCR = 'Meeting TCR';
    //Required field for T3 TCR
    private static final String TCR_TYPE_T3_TCR_RequiredField_Name = '1';
    private static final String TCR_TYPE_T3_TCR_RequiredField_PageName = 'Section 2B';
    private static final String TCR_TYPE_T3_TCR_RequiredField_FieldName = 'Availability_RPS_Core__c';
    private static final String TCR_TYPE_T3_TCR_RequiredField_PageNo = '5';
    //Required field for TRADE TCR
    private static final String TCR_TYPE_TRADE_TCR_RequiredField_Name = '1';
    private static final String TCR_TYPE_TRADE_TCR_RequiredField_PageName = 'Section 2B';
    private static final String TCR_TYPE_TRADE_TCR_RequiredField_FieldName = 'Availability_RPS_Core__c';
    private static final String TCR_TYPE_TRADE_TCR_RequiredField_PageNo = '5';
    //Required field for SUBD AUDIT TCR
    private static final String TCR_TYPE_SUBAUDIT_TCR_RequiredField_Name = '1';
    private static final String TCR_TYPE_SUBAUDIT_TCR_RequiredField_PageName = 'Section 3';
    private static final String TCR_TYPE_SUBAUDIT_TCR_RequiredField_FieldName = 'Recommend__c';
    private static final String TCR_TYPE_SUBAUDIT_TCR_RequiredField_PageNo = '7';
    //Required field for Meeting TCR
    private static final String TCR_TYPE_MEETING_TCR_RequiredField_Name = '1';
    private static final String TCR_TYPE_MEETING_TCR_RequiredField_PageName = 'Basics';
    private static final String TCR_TYPE_MEETING_TCR_RequiredField_FieldName = 'Team_Leader_Trainer__c';
    private static final String TCR_TYPE_MEETING_TCR_RequiredField_PageNo = '2';
    //Object
    private static final String objectTrainingContactReport = 'Training_Contact_Report__c';
    //Error Messages for Test Class
    private static final String ERROR_MESSAGE_InvalidCustomFieldInfo ='Invalid Custom Field Info';
    private static final String ERROR_MESSAGE_InvalidRequiredField = 'Invalid Required Field';
    
    @testSetup static void setup() {
        
        //Create Admin Account
        User userAdmin = TestTCRDataFactory.createUserAdmin(ADMIN_USERNAME);
        //Create GT Channel Head Account
       	User userPOSGT_CH = TestTCRDataFactory.createUserChannelHead('POS-GT Channel Head',POS_GT_CHANNEL_HEAD,'POS Channel Head/Head Office');
        //Create POS-GT Team Lead Account
        User userPOSGT_TL = TestTCRDataFactory.createUserTL('POS-GT Team Lead (Mindanao)',POS_GT_TL,userPOSGT_CH.Id,'GT Team Lead'); 
        //Create POS-GT CDS Account
        User userPOSGT_CDS = TestTCRDataFactory.createUserCDS(userPOSGT_TL.Id,'POS-GT CDS (Mindanao)',POS_GT_CDS,'GT CDS');
        //Create KA Channel Head Account
        User userPOSKA_CH = TestTCRDataFactory.createUserChannelHead('POS-KA Channel Head',POS_KA_CHANNEL_HEAD,'POS Channel Head/Head Office');
        //Create POS-KA Team Lead Account
        User userPOSKA_TL = TestTCRDataFactory.createUserTL('POS-KA Team Lead (VisMin)',POS_KA_TL,userPOSKA_CH.Id,'KA Team Lead');
        //Create POS-KA CDS Account
        User userPOSKA_CDS = TestTCRDataFactory.createUserCDS(userPOSKA_TL.Id,'POS-KA CDS (VisMin)',POS_KA_CDS,'KA CDS');
        system.runAs(userAdmin){
            //Create Chatter Groups
            TestTCRDataFactory.createChatterGroup();
            //Create eventActJuncFields
            Event_Activity_Junction_Fields__c eventActJunctFields = new Event_Activity_Junction_Fields__c(Name='Location', Source_Field_API__c = 'Location_Custom__c', Target_Field_API__c = 'Location__c');
            insert eventActJunctFields;
            
            //Create POS-GT Activity Matrix
            TestTCRDataFactory.createActivityMatrix(userPOSGT_TL.UserRoleId,'1');
            TestTCRDataFactory.createActivityMatrix(userPOSGT_CDS.UserRoleId,'2');
            //Create POS-KA Activity Matrix
            TestTCRDataFactory.createActivityMatrix(userPOSKA_TL.UserRoleId,'3');
            TestTCRDataFactory.createActivityMatrix(userPOSKA_CDS.UserRoleId,'4');
            //Create Custom Setting Required Field
            TestTCRDataFactory.createCustomSettingTCRRequiredFields(TCR_TYPE_T3_TCR_RequiredField_Name,
                                                                    TCR_TYPE_T3_TCR_RequiredField_PageName,
                                                                    TCR_TYPE_T3_TCR_RequiredField_FieldName,
                                                                    TCR_TYPE_T3_TCR_RequiredField_PageNo,
                                                                    TCR_TYPE_T3_TCR);
            TestTCRDataFactory.createCustomSettingTCRRequiredFields(TCR_TYPE_TRADE_TCR_RequiredField_Name,
                                                                    TCR_TYPE_TRADE_TCR_RequiredField_PageName,
                                                                    TCR_TYPE_TRADE_TCR_RequiredField_FieldName,
                                                                    TCR_TYPE_TRADE_TCR_RequiredField_PageNo,
                                                                    TCR_TYPE_TRADE_TCR);
            TestTCRDataFactory.createCustomSettingTCRRequiredFields(TCR_TYPE_SUBAUDIT_TCR_RequiredField_Name,
                                                                    TCR_TYPE_SUBAUDIT_TCR_RequiredField_PageName,
                                                                    TCR_TYPE_SUBAUDIT_TCR_RequiredField_FieldName,
                                                                    TCR_TYPE_SUBAUDIT_TCR_RequiredField_PageNo,
                                                                    TCR_TYPE_SUBAUDIT_TCR);
            TestTCRDataFactory.createCustomSettingTCRRequiredFields(TCR_TYPE_MEETING_TCR_RequiredField_Name,
                                                                    TCR_TYPE_MEETING_TCR_RequiredField_PageName,
                                                                    TCR_TYPE_MEETING_TCR_RequiredField_FieldName,
                                                                    TCR_TYPE_MEETING_TCR_RequiredField_PageNo,
                                                                    TCR_TYPE_MEETING_TCR);
            //Create TCR Matrix
            TestTCRDataFactory.createTCRCustomSettings();
        }
        system.runAs(userPOSGT_CDS){
         
            /*
            //Create POS GT CDS field Work 
            posGTfieldWorkCDSEventId = TestTCRDataFactory.createCDSFieldWorkEvent(dfs);
            //Create POS GT Branch Call
            posGTbranchCallCDSEventId = TestTCRDataFactory.createCDSBranchCall(posGTbranchAccountId,dfsId);
            //Create POS GT Head Office Call
            TestTCRDataFactory.createCDSHeadOfficeCall(posGTbranchAccountId,dfsId);
            //Create POS GT Meeting
            TestTCRDataFactory.createCDSMeeting(dfsId);
			*/
        }
         
        system.runAs(userPOSGT_TL){
            /*
            //Create TL Field Work 
            posGTfieldWorkTLEventId = TestTCRDataFactory.createTLFieldWorkEvent(userPOSGT_CDS);
    		*/
        }
        
        
    }
    //Test T3 TCR For Approval 
    @isTest static void testT3TCRPendingApproval() {
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        Test.startTest();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            posGTWarehouseAccountId = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : posGTWarehouseAccountId];
            posGTWarehouseAccount.OwnerId = userPOSGT_CDS.Id;
            update posGTWarehouseAccount;  
        }  
        system.runAs(userPOSGT_CDS){
            //Create POS GT Branch Account
            posGTbranchAccountId = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create DFS Contact
            Id dfsId = TestTCRDataFactory.createContact('DFS', posGTWarehouseAccountId);
            Contact dfs = [SELECT Id FROM Contact WHERE Id = : dfsId];
            //Create Field Work Event 
            Id fieldWorkId = TestTCRDataFactory.createCDSFieldWorkEvent(dfs, Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('T3 TCR').getRecordTypeId());
            Training_Contact_Report__c isTCRExist = UNILAB_TrainingContactController.getTcrRecord(fieldWorkId);
            if(isTCRExist !=null){
                newTCR = UNILAB_TrainingContactController.getTcrRecord(fieldWorkId);
                newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('T3 TCR').getRecordTypeId();
                newTCR.RecordType = UNILAB_TrainingContactController.getTcrRecordTypeById(newTCR.RecordTypeId);
                List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
                
                Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
                Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
                String strTCRCALLS = JSON.Serialize(tcrCalls);
                if(accountBranch!=null){
                    tcrCall.Account__c = accountBranch.Id;
                    tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                    strTCRCALLS = JSON.Serialize(tcrCalls);
                    tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                }
                newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
                strTCRCALLS = JSON.Serialize(tcrCalls);
                savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
                //Get Updated Record
                savedTCR = UNILAB_TrainingContactController.getTcrRecord(savedTCR.Id);
                
                //Update TCR Status
                savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
            }
            
        }
         
        Test.stopTest();
       // System.assertEquals(savedTCR.Availability_RPS_Target_Prep_Notes__c,'Note Test');
       System.assertEquals(UNILAB_TrainingContactController.STATUS_PENDING_APPROVAL, savedTCR.Status__c);
    }
    //Test T3 TCR Update
    @isTest static void testT3TCRUpdate() {
        List<Training_Contact_Report_Call__c> savedTCRCalls = new List<Training_Contact_Report_Call__c>();
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        Test.startTest();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            posGTWarehouseAccountId = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : posGTWarehouseAccountId];
            posGTWarehouseAccount.OwnerId = userPOSGT_CDS.Id;
            update posGTWarehouseAccount;  
        }  
        system.runAs(userPOSGT_CDS){
            
            //Create POS GT Branch Account
            posGTbranchAccountId = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create DFS Contact
            Id dfsId = TestTCRDataFactory.createContact('DFS', posGTWarehouseAccountId);
            Contact dfs = [SELECT Id FROM Contact WHERE Id = : dfsId];
            //Create Field Work Event 
            Id fieldWorkId = TestTCRDataFactory.createCDSFieldWorkEvent(dfs, Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('T3 TCR').getRecordTypeId());
            //Training_Contact_Report__c isTCRExist = UNILAB_TrainingContactController.getTcrRecord(fieldWorkId);
       
            
                newTCR = UNILAB_TrainingContactController.getTcrRecord(fieldWorkId);
                newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('T3 TCR').getRecordTypeId();
                newTCR.RecordType = UNILAB_TrainingContactController.getTcrRecordTypeById(newTCR.RecordTypeId);
                List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
                
                Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
                Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
                String strTCRCALLS = JSON.Serialize(tcrCalls);
                if(accountBranch!=null){
                    tcrCall.Account__c = accountBranch.Id;
                    tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                    strTCRCALLS = JSON.Serialize(tcrCalls);
                    tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                }
                newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
                strTCRCALLS = JSON.Serialize(tcrCalls);
                savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
                //Get Updated Record
                savedTCR = UNILAB_TrainingContactController.getTcrRecord(savedTCR.Id);
                savedTCRCalls = UNILAB_TrainingContactController.getCdsCalls(savedTCR);
                strTCRCALLS = JSON.Serialize(savedTCRCalls);
                if(savedTCRCalls.size()>0){
                    savedTCRCalls = UNILAB_TrainingContactController.deleteTcrCallAccount(savedTCRCalls.get(0),strTCRCALLS);
                }
                strTCRCALLS = JSON.Serialize(savedTCRCalls);
                savedTCR =UNILAB_TrainingContactController.saveTCR(savedTCR,strTCRCALLS);
                //Update TCR Status
                savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
            
            
        }
        
        Test.stopTest();
        // System.assertEquals(savedTCR.Availability_RPS_Target_Prep_Notes__c,'Note Test');
        System.assertEquals(UNILAB_TrainingContactController.STATUS_PENDING_APPROVAL, savedTCR.Status__c);
        System.assert(savedTCRCalls.size()==1,'Invalid TCR Calls');
    }
      //Test T3 TCR  Approval 
    @isTest static void testT3TCRApproval() {
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        Test.startTest();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            posGTWarehouseAccountId = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : posGTWarehouseAccountId];
            posGTWarehouseAccount.OwnerId = userPOSGT_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSGT_CDS){
            //Create POS GT Branch Account
            posGTbranchAccountId = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create DFS Contact
            Id dfsId = TestTCRDataFactory.createContact('DFS', posGTWarehouseAccountId);
            Contact dfs = [SELECT Id FROM Contact WHERE Id = : dfsId];
            //Create Field Work Event
            Id fw = TestTCRDataFactory.createCDSFieldWorkEvent(dfs, Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('T3 TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(fw);
            
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
            Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
            Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            if(accountBranch!=null){
                tcrCall.Account__c = accountBranch.Id;
                tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                strTCRCALLS = JSON.Serialize(tcrCalls);
                tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
            }
            newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('T3 TCR').getRecordTypeId();
            newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
            strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
            
        }
        
        system.runAs(userPOSGT_TL){
            //Update TCR Status to Approved
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
        }
        Test.stopTest();
        System.assertEquals(UNILAB_TrainingContactController.STATUS_APPROVED, savedTCR.Status__c);
        //System.assertEquals(UNILAB_TrainingContactController.STATUS_APPROVED, status);
    }
    //Test SUBD AUDIT TCR Pending Concurrence
    @isTest static void testSUBDAUDITPendingConcurrence(){
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        Test.startTest();
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            posGTWarehouseAccountId = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : posGTWarehouseAccountId];
            posGTWarehouseAccount.OwnerId = userPOSGT_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSGT_CDS){
            //Create POS GT Branch Account
            posGTbranchAccountId = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create CDS Branch Call
            TestTCRDataFactory.createCDSHeadOfficeCall(posGTbranchAccountId,null);
        }
        system.runAs(userPOSGT_TL){
            //Create TL Feld Work / Training Contact
            posGTfieldWorkTLEventId = TestTCRDataFactory.createTLFieldWorkEvent(userPOSGT_CDS, Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('SUBD AUDIT TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(posGTfieldWorkTLEventId);
            
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
            //Get CDS Workplans
            tcrCalls = UNILAB_TrainingContactController.populateTCRcalls(UNILAB_TrainingContactController.getWorkPlanCDS(newTCR));
            
            Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
            Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            if(accountBranch!=null){
                tcrCall.Account__c = accountBranch.Id;
                tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                strTCRCALLS = JSON.Serialize(tcrCalls);
                tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
            }
            newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('SUBD AUDIT TCR').getRecordTypeId();
            newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
            strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status: update status to pending concurrence
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR); 
            //Change Owner
            UNILAB_TrainingContactController.updateRecOwner(savedTCR);
        }
        System.assertEquals(UNILAB_TrainingContactController.STATUS_PENDING_CONCURRENCE,savedTCR.Status__c);
  
        Test.stopTest();
    }
    //Test SUBD AUDIT TCR Pending Approval
    @isTest static void testSUBDAUDITPendingApproval(){
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        Test.startTest();
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            posGTWarehouseAccountId = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : posGTWarehouseAccountId];
            posGTWarehouseAccount.OwnerId = userPOSGT_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSGT_CDS){
            //Create POS GT Branch Account
            posGTbranchAccountId = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create CDS Branch Call
            TestTCRDataFactory.createCDSHeadOfficeCall(posGTbranchAccountId,null);
        }
        system.runAs(userPOSGT_TL){
            //Create TL Feld Work / Training Contact
            posGTfieldWorkTLEventId = TestTCRDataFactory.createTLFieldWorkEvent(userPOSGT_CDS, Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('SUBD AUDIT TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(posGTfieldWorkTLEventId);
                newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('SUBD AUDIT TCR').getRecordTypeId();
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
             //Get CDS Workplans
            tcrCalls = UNILAB_TrainingContactController.populateTCRcalls(UNILAB_TrainingContactController.getWorkPlanCDS(newTCR));
            Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
            Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            if(accountBranch!=null){
                tcrCall.Account__c = accountBranch.Id;
                tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                strTCRCALLS = JSON.Serialize(tcrCalls);
                tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
            } 
            newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
            strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status: update status to pending concurrence
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR); 
            //Change Owner
            UNILAB_TrainingContactController.updateRecOwner(savedTCR);
        }
        
        //CDS Concur
        system.runAs(userPOSGT_CDS){
            //Update TCR Status to Pending Approval
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR); 
        }
        System.assertEquals(UNILAB_TrainingContactController.STATUS_PENDING_APPROVAL,savedTCR.Status__c);
        Test.stopTest();
    }
    //Test SUBD AUDIT TCR Approval
    @isTest static void testSUBDAUDITApproval(){
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        Test.startTest();
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            posGTWarehouseAccountId = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : posGTWarehouseAccountId];
            posGTWarehouseAccount.OwnerId = userPOSGT_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSGT_CDS){
            //Create POS GT Branch Account
            posGTbranchAccountId = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create CDS Branch Call
            TestTCRDataFactory.createCDSHeadOfficeCall(posGTbranchAccountId,null);
        }
        system.runAs(userPOSGT_TL){
            //Create TL Feld Work / Training Contact
            posGTfieldWorkTLEventId = TestTCRDataFactory.createTLFieldWorkEvent(userPOSGT_CDS, Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('SUBD AUDIT TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(posGTfieldWorkTLEventId);
            newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('SUBD AUDIT TCR').getRecordTypeId();
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
            //Get CDS Workplans
            tcrCalls = UNILAB_TrainingContactController.populateTCRcalls(UNILAB_TrainingContactController.getWorkPlanCDS(newTCR));
            Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
            Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            if(accountBranch!=null){
                tcrCall.Account__c = accountBranch.Id;
                tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                strTCRCALLS = JSON.Serialize(tcrCalls);
                tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
            }
            newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
            strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status: update status to pending concurrence
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR); 
            //Change Owner
            UNILAB_TrainingContactController.updateRecOwner(savedTCR);
            
        }
        
        //CDS Concur
        system.runAs(userPOSGT_CDS){
            //Update TCR Status to Pending Approval
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR); 
        }
        //Channel Head Approve
        system.runAs(userPOSGT_CHANNEL_HEAD){
            //Update TCR Status to Approved
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR); 
        }
        System.assertEquals(UNILAB_TrainingContactController.STATUS_APPROVED,savedTCR.Status__c);
        Test.stopTest();
    }
    //Test Meeting TCR For Pending Concurrence
    @isTest static void testMeetingPendingConcurrence(){
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        Test.startTest();
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            posGTWarehouseAccountId = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : posGTWarehouseAccountId];
            posGTWarehouseAccount.OwnerId = userPOSGT_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSGT_CDS){
            //Create POS GT Branch Account
            posGTbranchAccountId = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create CDS Meeting 
            TestTCRDataFactory.createCDSMeeting(null);
            
        }
        system.runAs(userPOSGT_TL){
            
            Id fw = TestTCRDataFactory.createTLFieldWorkEvent(userPOSGT_CDS,Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Meeting TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(fw);
            newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Meeting TCR').getRecordTypeId();            
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
            //Get CDS Workplans
            tcrCalls = UNILAB_TrainingContactController.populateTCRcalls(UNILAB_TrainingContactController.getWorkPlanCDS(newTCR));
            Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
            Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            if(accountBranch!=null){
                tcrCall.Account__c = accountBranch.Id;
                tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                strTCRCALLS = JSON.Serialize(tcrCalls);
                tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
            }
            newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
            strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
        }
        Test.stopTest();
        System.assertEquals(UNILAB_TrainingContactController.STATUS_PENDING_CONCURRENCE, savedTCR.Status__c);
    }
     //Test Meeting TCR For Pending Approval
    @isTest static void testMeetingPendingApproval(){
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        Test.startTest();
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            posGTWarehouseAccountId = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : posGTWarehouseAccountId];
            posGTWarehouseAccount.OwnerId = userPOSGT_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSGT_CDS){
            //Create POS GT Branch Account
            posGTbranchAccountId = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create CDS Meeting 
            TestTCRDataFactory.createCDSMeeting(null);
            
        }
        system.runAs(userPOSGT_TL){
            
            Id fw = TestTCRDataFactory.createTLFieldWorkEvent(userPOSGT_CDS,Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Meeting TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(fw);
              newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Meeting TCR').getRecordTypeId();            
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
             //Get CDS Workplans
            tcrCalls = UNILAB_TrainingContactController.populateTCRcalls(UNILAB_TrainingContactController.getWorkPlanCDS(newTCR));
            Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
            Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            if(accountBranch!=null){
                tcrCall.Account__c = accountBranch.Id;
                tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                strTCRCALLS = JSON.Serialize(tcrCalls);
                tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
            }
            newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
            strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
            //Change Owner
            UNILAB_TrainingContactController.updateRecOwner(savedTCR);
            savedTCR =UNILAB_TrainingContactController.getTcrRecord(savedTCR.Id);
        }
        system.runAs(userPOSGT_CDS){
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
        }
        Test.stopTest();
        System.assertEquals(UNILAB_TrainingContactController.STATUS_PENDING_APPROVAL, savedTCR.Status__c);
    }
    //Test Meeting TCR For Approval
    @isTest static void testMeetingApproval(){
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        Test.startTest();
        Id fw;
        system.runAs(userPOSGT_CDS){
            //Create CDS Meeting 
            TestTCRDataFactory.createCDSMeeting(null);
            
        }
        system.runAs(userPOSGT_TL){
            
            fw = TestTCRDataFactory.createTLFieldWorkEvent(userPOSGT_CDS,Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Meeting TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(fw);
            newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Meeting TCR').getRecordTypeId();            
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
            //Change Owner
            UNILAB_TrainingContactController.updateRecOwner(savedTCR);
           

        }
        system.runAs(userPOSGT_CDS){
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.getTcrRecord(savedTCR.Id);
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
            //Change Owner
            UNILAB_TrainingContactController.updateRecOwner(savedTCR);
           
            
        }
        system.runAs(userPOSGT_CHANNEL_HEAD){
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.getTcrRecord(savedTCR.Id);
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
        }
        Test.stopTest();
        System.assertEquals(UNILAB_TrainingContactController.STATUS_APPROVED, savedTCR.Status__c);
    }
    //Test Account TCR For Pending Concurrence
    @isTest static void testAccountTCRPendingConcurrence(){
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSKA_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_TL];
        User userPOSKA_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_CDS];
        User userPOSKA_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_CHANNEL_HEAD];
        Id accountID;
        Id accountBranchID;
        Test.startTest();
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            accountID = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : accountID];
            posGTWarehouseAccount.OwnerId = userPOSKA_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSKA_CDS){
            //Create POS GT Branch Account
            accountBranchID = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create CDS Branch Call 
            TestTCRDataFactory.createCDSBranchCall(accountBranchID,null);
            
        }
        system.runAs(userPOSKA_TL){
            Id fw = TestTCRDataFactory.createTLFieldWorkEvent(userPOSKA_CDS,Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Account TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(fw);
            newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Account TCR').getRecordTypeId();            
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
            Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
             //Get CDS Workplans
            tcrCalls = UNILAB_TrainingContactController.populateTCRcalls(UNILAB_TrainingContactController.getWorkPlanCDS(newTCR));
            Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            if(accountBranch!=null){
                tcrCall.Account__c = accountBranch.Id;
                tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                strTCRCALLS = JSON.Serialize(tcrCalls);
                tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
            }
            newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
            strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
        }
        Test.stopTest();
        System.assertEquals(UNILAB_TrainingContactController.STATUS_PENDING_CONCURRENCE, savedTCR.Status__c);
    }
    //Test Account TCR For Pending Approval
    @isTest static void testAccountTCRPendingApproval(){
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSKA_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_TL];
        User userPOSKA_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_CDS];
        User userPOSKA_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_CHANNEL_HEAD];
        Id accountID;
        Id accountBranchID;
        Test.startTest();
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            accountID = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : accountID];
            posGTWarehouseAccount.OwnerId = userPOSKA_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSKA_CDS){
            //Create POS GT Branch Account
            accountBranchID = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create CDS Branch Call 
            TestTCRDataFactory.createCDSBranchCall(accountBranchID,null);
            
        }
        system.runAs(userPOSKA_TL){
            Id fw = TestTCRDataFactory.createTLFieldWorkEvent(userPOSKA_CDS,Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Account TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(fw);
            newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Account TCR').getRecordTypeId();   
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
            Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
             //Get CDS Workplans
            tcrCalls = UNILAB_TrainingContactController.populateTCRcalls(UNILAB_TrainingContactController.getWorkPlanCDS(newTCR));
            Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            if(accountBranch!=null){
                tcrCall.Account__c = accountBranch.Id;
                tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                strTCRCALLS = JSON.Serialize(tcrCalls);
                tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
            }
            newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
            strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
            //Change Owner
            UNILAB_TrainingContactController.updateRecOwner(savedTCR);
            savedTCR =UNILAB_TrainingContactController.getTcrRecord(savedTCR.Id);
        }
        system.runAs(userPOSKA_CDS){
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
        }
        Test.stopTest();
        System.assertEquals(UNILAB_TrainingContactController.STATUS_PENDING_APPROVAL, savedTCR.Status__c);
    }
    //Test Account TCR Approval
    @isTest static void testAccountTCRApproval(){
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSKA_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_TL];
        User userPOSKA_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_CDS];
        User userPOSKA_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_CHANNEL_HEAD];
        Id accountID;
        Id accountBranchID;
        Test.startTest();
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            accountID = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : accountID];
            posGTWarehouseAccount.OwnerId = userPOSKA_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSKA_CDS){
            //Create POS GT Branch Account
            accountBranchID = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create CDS Branch Call 
            TestTCRDataFactory.createCDSBranchCall(accountBranchID,null);
            
        }
        system.runAs(userPOSKA_TL){
            Id fw =TestTCRDataFactory.createTLFieldWorkEvent(userPOSKA_CDS,Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Account TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(fw);
            newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Account TCR').getRecordTypeId(); 
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
            Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
             //Get CDS Workplans
            tcrCalls = UNILAB_TrainingContactController.populateTCRcalls(UNILAB_TrainingContactController.getWorkPlanCDS(newTCR));
            Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            if(accountBranch!=null){
                tcrCall.Account__c = accountBranch.Id;
                tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                strTCRCALLS = JSON.Serialize(tcrCalls);
                tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
            }
            newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
            strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
            //Change Owner
            UNILAB_TrainingContactController.updateRecOwner(savedTCR);
            savedTCR =UNILAB_TrainingContactController.getTcrRecord(savedTCR.Id);
        }
        system.runAs(userPOSKA_CDS){
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
       
        }
        system.runAs(userPOSKA_CHANNEL_HEAD){
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
        }
        Test.stopTest();
        System.assertEquals(UNILAB_TrainingContactController.STATUS_APPROVED, savedTCR.Status__c);
    }
    //Test getCustomFieldInfo method
    @isTest static void testGetCustomFieldInfo(){
        
        Test.startTest();
        Map<String,String> actualResult = UNILAB_TrainingContactController.getCustomFieldInfo(objectTrainingContactReport,TCR_TYPE_T3_TCR);

        String mainString = actualResult.get('availability_rps_core__c');

        Test.stopTest();
        System.assert(mainString.contains('isRequired" : true,'),ERROR_MESSAGE_InvalidCustomFieldInfo);
    }
    //Test getWorkplanCDS & CDS Calls & isRecorExist
    /*
    @isTest static void testGetWorkplanCDS(){

        List<event> cdsEvents = new List<Event>();
        List<Training_Contact_Report_Call__c> cdsEventsCalls = new List<Training_Contact_Report_Call__c>();
        Boolean isRecordExist = false;
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        Test.startTest();
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            posGTWarehouseAccountId = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : posGTWarehouseAccountId];
            posGTWarehouseAccount.OwnerId = userPOSGT_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSGT_CDS){
            //Create POS GT Branch Account
            posGTbranchAccountId = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            TestTCRDataFactory.createCDSBranchCall(posGTbranchAccountId, null);

        }
       
        system.runAs(userPOSGT_TL){ 
            TestTCRDataFactory.createTLFieldWorkEvent(userPOSGT_CDS,Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Account TCR').getRecordTypeId());
            Event tlEvent = [SELECT Id,Activity_Junction__c FROM Event WHERE OwnerId =:userPOSGT_TL.Id];
            isRecordExist=UNILAB_TrainingContactController.isRecordExists(tlEvent);
        	cdsEvents = UNILAB_TrainingContactController.getWorkPlanCDS(userPOSGT_CDS);
            cdsEventsCalls = UNILAB_TrainingContactController.populateTCRcalls(cdsEvents);
        }
        
        Test.stopTest();
        System.assert(cdsEvents.size() > 0,'Invalid CDS Count');
        System.assert(cdsEventsCalls.size() > 0,'Invalid CDS Call Count');
        System.assert(isRecordExist == false,'Invalid Record Checker');
        
    }
	*/
    //Test getMapRequiredFieldsByPageNo method
    @isTest static void testGetMapRequiredFieldsByPageNo(){
        Test.startTest();
        Map<String,String> T3_TCR_Required_Fields =UNILAB_TrainingContactController.getMapRequiredFieldsByPageNo(TCR_TYPE_T3_TCR);
        Map<String,String> TRADE_TCR_Required_Fields =UNILAB_TrainingContactController.getMapRequiredFieldsByPageNo(TCR_TYPE_TRADE_TCR);
        Map<String,String> TCR_TYPE_SUBAUDIT_TCR_Required_Fields =UNILAB_TrainingContactController.getMapRequiredFieldsByPageNo(TCR_TYPE_SUBAUDIT_TCR);
        Map<String,String> Meeting_TCR_Required_Fields =UNILAB_TrainingContactController.getMapRequiredFieldsByPageNo(TCR_TYPE_MEETING_TCR);
        
        Test.stopTest();
        
        for (String key : T3_TCR_Required_Fields.keySet()) {
            
            system.assert(T3_TCR_Required_Fields.get(key).contains(TCR_TYPE_T3_TCR_RequiredField_FieldName.toLowerCase()),ERROR_MESSAGE_InvalidRequiredField);
        }      
        
        for (String key : TRADE_TCR_Required_Fields.keySet()) {
            system.assert(TRADE_TCR_Required_Fields.get(key).contains(TCR_TYPE_TRADE_TCR_RequiredField_FieldName.toLowerCase()),ERROR_MESSAGE_InvalidRequiredField);
        }      
        
        for (String key : TCR_TYPE_SUBAUDIT_TCR_Required_Fields.keySet()) {
      
            system.assert(TCR_TYPE_SUBAUDIT_TCR_Required_Fields.get(key).contains(TCR_TYPE_SUBAUDIT_TCR_RequiredField_FieldName.toLowerCase()),ERROR_MESSAGE_InvalidRequiredField);
        }      
        
        for (String key : Meeting_TCR_Required_Fields.keySet()) {
            system.assert(Meeting_TCR_Required_Fields.get(key).contains(TCR_TYPE_MEETING_TCR_RequiredField_FieldName.toLowerCase()),ERROR_MESSAGE_InvalidRequiredField);
        }      
        
    }
    //Test getActivityJunctionID
    @isTest static void  testGetTcrRecordByActivityJunction(){
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSKA_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_TL];
        User userPOSKA_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_CDS];
        User userPOSKA_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_KA_CHANNEL_HEAD]; 
        List<Activity_Junction__c> activityJunctions = new List<Activity_Junction__c>();
        Test.startTest();
        system.runAs(userPOSKA_TL){
            TestTCRDataFactory.createTLFieldWorkEvent(userPOSKA_CDS,Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Account TCR').getRecordTypeId());
            activityJunctions = [SELECT Id FROM Activity_Junction__c];
            if(activityJunctions.size()>0){
                UNILAB_TrainingContactController.getTcrRecordByActivityJunction(activityJunctions.get(0).Id+''); 
            }
        }
        Test.stopTest();
        System.assert(activityJunctions.size()>0);
    }
    //Test getCDSCalls
    @isTest static void  testGetCDSCalls(){
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
        Training_Contact_Report__c savedTCR =  new Training_Contact_Report__c();
        List<Training_Contact_Report_Call__c> tcrRCall = new List<Training_Contact_Report_Call__c> ();
        Test.startTest();
        User userAdmin = [SELECT Id, UserRoleId FROM User WHERE Username =:ADMIN_USERNAME];
        User userPOSGT_TL = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_TL];
        User userPOSGT_CDS = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CDS];
        User userPOSGT_CHANNEL_HEAD = [SELECT Id, UserRoleId FROM User WHERE Username =:POS_GT_CHANNEL_HEAD];
        system.runAs(userAdmin){
            //Create POS-GT Main Warehouse Account
            posGTWarehouseAccountId = TestTCRDataFactory.createAccountMainWareHouse('POSTGTMainAccount','9999999999','1111111111');
            Account posGTWarehouseAccount = [Select Id, OwnerId FROM Account WHERE Id = : posGTWarehouseAccountId];
            posGTWarehouseAccount.OwnerId = userPOSGT_CDS.Id;
            update posGTWarehouseAccount;  
        }
        system.runAs(userPOSGT_CDS){
            //Create POS GT Branch Account
            posGTbranchAccountId = TestTCRDataFactory.createAccountBranch(posGTWarehouseAccountId);
            //Create DFS Contact
            Id dfsId = TestTCRDataFactory.createContact('DFS', posGTWarehouseAccountId);
            Contact dfs = [SELECT Id FROM Contact WHERE Id = : dfsId];
            //Create Field Work Event
            Id fw = TestTCRDataFactory.createCDSFieldWorkEvent(dfs,Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('T3 TCR').getRecordTypeId());
            
            newTCR = UNILAB_TrainingContactController.getTcrRecord(fw);
            
            List<Training_Contact_Report_Call__c> tcrCalls = new List<Training_Contact_Report_Call__c>();
            Training_Contact_Report_Call__c tcrCall = new Training_Contact_Report_Call__c();
            Account accountBranch = [SELECT Id, Name FROM Account WHERE Name = :'AccountBranch'];
            String strTCRCALLS = JSON.Serialize(tcrCalls);
            if(accountBranch!=null){
                tcrCall.Account__c = accountBranch.Id;
                tcrCalls =UNILAB_TrainingContactController.addTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
                strTCRCALLS = JSON.Serialize(tcrCalls);
                tcrCalls =UNILAB_TrainingContactController.editTcrCallAccount(1+'', accountBranch.Id+'', strTCRCALLS);
            }
            newTCR.Availability_RPS_Target_Prep_Notes__c ='Note Test';
            strTCRCALLS = JSON.Serialize(tcrCalls);
            savedTCR =UNILAB_TrainingContactController.saveTCR(newTCR,strTCRCALLS);
            //Update TCR Status
            savedTCR = UNILAB_TrainingContactController.updateTCRStatus(savedTCR);
            tcrRCall = UNILAB_TrainingContactController.getCdsCalls(savedTCR);
            
        }
        
        Test.stopTest();
        System.assert(tcrRCall.size()>0);
    }

    
    
    
}