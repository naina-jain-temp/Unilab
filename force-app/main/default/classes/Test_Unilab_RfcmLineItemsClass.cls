@isTest
public class Test_Unilab_RfcmLineItemsClass {
    @isTest
    public static void testRfcmLineItemsClassAmount(){
        
        Unilab_RfcmLineItemsClass controller = new Unilab_RfcmLineItemsClass();
        
        RFCM_FormNumber__c rfcmForm = new RFCM_FormNumber__c();
        List<RFCM_FormNumber__c> formList = new List<RFCM_FormNumber__c>();
        rfcmForm.Name = 'test';
        rfcmForm.Number__c = 100000;
        rfcmForm.Date__c =Date.newInstance(2022, 12, 9);
        insert rfcmForm;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Main/Warehouse').getRecordTypeId();
        acc.Name = 'appistoki';
        acc.Branch_Code__c = '1';
        acc.Account_Code__c = '1';
        acc.Bill_To_Code__c = '1230987654';
        insert acc;
        
        RFCM__c rfcm = new RFCM__c();
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
        insert rfcm;
        
        Project_Proposal_Document__c ppd = new Project_Proposal_Document__c();
        ppd.name= '0S3AB3ITBMN6';
        ppd.Company__c = 'UNILAB, Inc.';
        insert ppd;
        
        Material__c mat = new Material__c();
        mat.Name = '7613267378';
        mat.Company_Name__c = 'Unilab';
        mat.Material_Id__c = '76788hjg';
        insert mat;
        RFCM_line_item__c rfcmlineitem = new RFCM_line_item__c();
        List<RFCM_line_item__c> RFCMList = new List<RFCM_line_item__c>();
        rfcmlineitem.unilab_Amount__c= 1000;
        rfcmlineitem.unilab_Company__c = 'Appistoki'; 
        rfcmlineitem.CM_No__c='1234';
        rfcmlineitem.RFCM__c = rfcm.id;
        rfcmlineitem.Material__c = mat.Id;
        rfcmlineitem.PPD_Contract__c = ppd.id;
        rfcmlineitem.CM_No__c ='sdvds';
        RFCMList.add(rfcmlineitem);
        Unilab_RfcmLineItemsClass.RfcmLineItems(rfcmlineitem.Id);
        Unilab_RfcmLineItemsClass.getRfcm('1','Name', 'ASC');
        Unilab_RfcmLineItemsClass.getRfcmlineitems(rfcm.Id);
   
    }
}