@isTest
public class UNILAB_TCRPathController_Test {
    
    //User username
    private static final String ADMIN_USERNAME ='UnilabAdmin@unilabtest.com';
    private static final String POS_GT_CHANNEL_HEAD = 'POSGTCH@unilabtest.com';
    private static final String POS_KA_CHANNEL_HEAD = 'POSKACH@unilabtest.com';
    private static final String POS_GT_TL ='POSGTTL@unilabtest.com';
    private static final String POS_GT_CDS ='POSGTCDS@unilabtest.com';
    private static final String POS_KA_TL ='POSKATL@unilabtest.com';
    private static final String POS_KA_CDS ='POSKACDS@unilabtest.com';
    //Events 
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
        
        
    }
    
    @isTest static void testStatusNotDraft(){
        
        Boolean isDelete = true;
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
        List<UNILAB_TCRPathController.chevronData> lstChevronData = UNILAB_TCRPathController.getChevronData(savedTCR.Id);
        Test.stopTest();
        System.assert(lstChevronData != null);
    }
    
}