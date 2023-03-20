@isTest
public class TestRFCMTriggerHandler {
    @isTest
    public static void testRFCMtriggerHandler(){
        
        User u = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last',
         Email = 'j@unilab.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
		);
        insert u;
        RFCM_FormNumber__c rfcmForm = new RFCM_FormNumber__c();
        List<RFCM_FormNumber__c> formList = new List<RFCM_FormNumber__c>();
        rfcmForm.Name = 'test';
        rfcmForm.Number__c = 100000;
        rfcmForm.Date__c =Date.newInstance(2022, 12, 9);
        insert rfcmForm;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Main/Warehouse').getRecordTypeId();
        acc.Name = 'metacube';
        acc.Branch_Code__c = '1';
        acc.Bill_To_Code__c = '1230987654';
        insert acc;
        
        RFCM__c rfcm = new RFCM__c();
        List<RFCM__c> rfcmList = new List<RFCM__c>();
        rfcm.RecordTypeId = Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Regular RFCM').getRecordTypeId();
        rfcm.Customer_Team__c = 'Trade Marketing Group';
        rfcm.Customer_Sub_Team__c = 'Customer Team 5 - TMG ULSSI';
        rfcm.unilab_Classification__c = 'MOS Internal';
        rfcm.unilab_Program__c = 'Trade Promotions - TMG Initiated';
        rfcm.unilab_Accrued__c = 'YES';
        rfcm.unilab_Claim_Reference_Number__c = '123';
        rfcm.unilab_Claim_Description__c = 'test';
        rfcm.Condition_Type__c = 'testCondition';
        rfcm.unilab_Start_Date__c = Date.newInstance(2022, 06, 11);
        rfcm.unilab_End_Date__c =Date.newInstance(2022, 06, 20);
        rfcm.Customer_Name__c = acc.Id;
        rfcm.unilab_Customer_Code__c = acc.Branch_Code__c;
        rfcm.Project_Owner__c  = 'Customer Team 1 HO';
        rfcm.Validator__c = 'Customer Team 1 HO';
        rfcm.RFCM_Approver__c = userinfo.getuserid();
        rfcmList.add(rfcm);
        Insert rfcmList;
        
        Material__c mat =new Material__c();
        mat.Company_Name__c = 'UNILAB, Inc.';
        mat.Name = '10001';
        mat.Material_Id__c = '78234hjeb';
        insert mat;
        
        RFCM_line_item__c rfcmlineitem = new RFCM_line_item__c();
        List<RFCM_line_item__c> RFCMList1 = new List<RFCM_line_item__c>();
        rfcmlineitem.unilab_Amount__c= 1000;
        rfcmlineitem.Material__c = mat.Id;
        rfcmlineitem.Customer_Name__c = acc.Id;
        rfcmlineitem.RFCM__c = rfcmList[0].Id;
        RFCMList1.add(rfcmlineitem);
        insert RFCMList1;
        
        rfcmList[0].Status__c = 'Credit Approver';
        rfcmList[0].unilab_Start_Date__c = Date.newInstance(2022, 06, 12);
        update rfcmList[0];
        system.debug([Select id, Status__c from RFCM__c]);
			        
        Set<Id> RFCMidsset = new Set<Id>();
        RFCMidsset.add(rfcmList[0].Id);
        system.debug(RFCMidsset);
        system.debug(rfcmList[0].Status__c);
        test.startTest();
        RFCMTriggerHandler.createCSV(RFCMidsset);
        test.stopTest();
        
        Credit_Team__c ct = new Credit_Team__c();
        ct.Company__c = 'UNILAB, Inc.';
        ct.User__c = u.Id;
        ct.Account__c = acc.Id;
        insert ct;
        
        
        
        System.debug(RFCMList1);
        
        
        ContentVersion cvlist = new Contentversion(); 
        cvlist.Title = 'CZDSTOU'; 
        cvlist.Description = 'test';
        cvlist.PathOnClient = 'test'; 
        cvlist.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body'); 
        List<ContentVersion> cvl = new List<ContentVersion>(); 
        cvl.add(cvlist); 
        insert cvl;
    

        //RFCMTriggerHandler.createCSV(RFCMidsset);
        RFCMTriggerHandler.rejectPendingApprovals(rfcmList);
        RFCMTriggerHandler.setApprovalConfigAttributes(rfcmList);
        
        RFCMTriggerHandler.createFile('test', cvlist.Title, cvlist.Description);
        RFCMTriggerHandler.sendEMailtoCredit(RFCMidsset);
    }

}