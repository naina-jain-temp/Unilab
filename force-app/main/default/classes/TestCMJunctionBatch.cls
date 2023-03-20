@isTest
public class TestCMJunctionBatch {
    static testMethod void testMethod1() {
        User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
	);
         System.runAs(u) {
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
        acc.Account_Code__c = '1';
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
        rfcm.unilab_Start_Date__c = Date.newInstance(2022, 06, 11);
        rfcm.unilab_End_Date__c =Date.newInstance(2022, 06, 20);
        rfcm.Customer_Name__c = acc.Id;
        rfcm.unilab_Customer_Code__c = '1';
        rfcm.Project_Owner__c  = 'Customer Team 1 HO';
        rfcm.Validator__c = 'Customer Team 1 HO';
        rfcm.RFCM_Approver__c = userinfo.getuserid();
             rfcm.Encoder__c = userinfo.getuserid();
        rfcmList.add(rfcm);
        
        RFCM__c rfcm1 = new RFCM__c();
        rfcm1.RecordTypeId = Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Regular RFCM').getRecordTypeId();
        rfcm1.Customer_Team__c = 'Trade Marketing Group';
        rfcm1.Customer_Sub_Team__c = 'Customer Team 5 - TMG ULSSI';
        rfcm1.unilab_Classification__c = 'MOS Internal';
        rfcm1.unilab_Program__c = 'Trade Promotions - TMG Initiated';
        rfcm1.unilab_Accrued__c = 'YES';
        rfcm1.unilab_Claim_Reference_Number__c = '1231';
        rfcm1.unilab_Claim_Description__c = 'test1';
        rfcm1.unilab_Start_Date__c = Date.newInstance(2022, 06, 11);
        rfcm1.unilab_End_Date__c =Date.newInstance(2022, 06, 20);
        rfcm1.Customer_Name__c = acc.Id;
        rfcm1.unilab_Customer_Code__c = '1';
        rfcm1.Project_Owner__c  = 'Customer Team 1 HO';
        rfcm1.Validator__c = 'Customer Team 1 HO';
        rfcm1.RFCM_Approver__c = userinfo.getuserid();
        rfcmList.add(rfcm1);
        Insert rfcmList;
        
             Material__c mat = new Material__c();
             mat.Material_Id__c= 'dfdsfds';
             mat.Material_Name__c = 'fdfdfs';
             mat.Company_Name__c = 'dfdsfsd';
             insert mat;
        
        List<RFCM_line_item__c> RFCMList1 = new List<RFCM_line_item__c>();
        RFCM_line_item__c rfcmlineitem = new RFCM_line_item__c();
        rfcmlineitem.unilab_Amount__c= 1000;
        rfcmlineitem.Customer_Name__c = acc.Id;
        rfcmlineitem.Material__c = mat.Id;
        rfcmlineitem.RFCM__C = rfcmList[0].Id;
        rfcmlineitem.unilab_Company__c = 'Appistoki';
        RFCMList1.add(rfcmlineitem);
        RFCM_line_item__c rfcmlineitem1 = new RFCM_line_item__c();
        rfcmlineitem1.unilab_Amount__c= 1000;
        rfcmlineitem1.unilab_Company__c = 'Appistoki';
        rfcmlineitem1.Material__c = mat.Id;
        rfcmlineitem.Customer_Name__c = acc.Id;
        rfcmlineitem1.RFCM__C = rfcmList[1].Id;
        RFCMList1.add(rfcmlineitem1);
        insert RFCMList1;
        
        CM_Junction__c cm = new CM_Junction__c();
        List<CM_Junction__c> CMJunctionList = new List<CM_Junction__c>();
        cm.Name = 'testCM';
        RFCM_line_item__c rfcli = [select id,Customer_Code__c,RFCM__r.Name from RFCM_line_item__c where RFCM__c=:rfcm.id];
        cm.CustRFCM_Code__c = rfcli.Customer_Code__c+rfcli.RFCM__r.Name;
        CMJunctionList.add(cm);
             insert CMJunctionList;
        
        Test.startTest();
			system.debug('query'+[select id,name,CustRFCM_Code__c from CM_Junction__c]);
            CMJunctionBatch obj = new CMJunctionBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
        
          }
         
        
        
    }

}