@isTest
public class TestRFCMGenerateCSVController {
    @isTest
    public static void testRFCMGenerateCSV(){
        
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
        
        RFCM__c rfcm1 = new RFCM__c();
        //List<RFCM__c> rfcmList = new List<RFCM__c>();
        rfcm1.RecordTypeId = Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Regular RFCM').getRecordTypeId();
        rfcm1.Customer_Team__c = 'Trade Marketing Group';
        rfcm1.Customer_Sub_Team__c = 'Customer Team 1 HO';
        rfcm1.unilab_Classification__c = 'MOS Internal';
        rfcm1.unilab_Program__c = 'Trade Promotions - TMG Initiated';
        rfcm1.unilab_Accrued__c = 'YES';
        rfcm1.unilab_Claim_Reference_Number__c = '123';
        rfcm1.unilab_Claim_Description__c = 'test';
        rfcm1.unilab_Start_Date__c = Date.newInstance(2022, 06, 11);
        rfcm1.unilab_End_Date__c =Date.newInstance(2022, 06, 20);
        rfcm1.Customer_Name__c = acc.Id;
        rfcm1.unilab_Customer_Code__c = '1';
        rfcm1.Project_Owner__c  = 'Customer Team 1 HO'; 
        rfcm1.Validator__c = 'Customer Team 1 HO';
        rfcm1.RFCM_Approver__c = userinfo.getuserid();
        rfcm1.Next_Approver__c = 'SNCD;Division Head';
        rfcm1.Current_Approver__c = 'Finance;Finance Analyst';
        Insert rfcm1;
        
        RFCM__c rf = [select id,name,status__c from RFCM__c where id=: rfcm1.id];
		rf.Status__c = 'Credit Approver';
        update rf;
        
        RFCM_line_item__c rfcmlineitem = new RFCM_line_item__c();
        Material__c mat = new Material__c();
        mat.Material_Id__c= 'dfdsfds';
        mat.Material_Name__c = 'fdfdfs';
        mat.Company_Name__c = 'dfdsfsd';
        mat.Sales_Area__c = 'S002';
        insert mat;
        
        List<RFCM_line_item__c> RFCMlineList = new List<RFCM_line_item__c>();
        rfcmlineitem.unilab_Amount__c= 1000;
        rfcmlineitem.RFCM__c = rfcm1.Id;
        rfcmlineitem.Material__c = mat.id;
        rfcmlineitem.unilab_Company__c = 'Appistoki';
        rfcmlineitem.Customer_Name__c = acc.id;
        RFCMlineList.add(rfcmlineitem);
        insert RFCMlineList;
        RFCMGenerateCSVController.generateCSV(rfcm1.id);
        //RFCMGenerateCSVController.createCSV(rfcmlineitem.id);
        //RFCMGenerateCSVController.createFile('test', 'test', 'test');
    }

}