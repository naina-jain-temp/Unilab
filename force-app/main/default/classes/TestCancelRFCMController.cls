@isTest
public class TestCancelRFCMController {
    @isTest
    public static void testRfcmLineItemsClassAmount(){
        
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
        rfcm.unilab_Start_Date__c = Date.newInstance(2022, 06, 11);
        rfcm.unilab_End_Date__c =Date.newInstance(2022, 06, 20);
        rfcm.Customer_Name__c = acc.Id;
        rfcm.unilab_Customer_Code__c = '1';
        rfcmList.add(rfcm);
        Insert rfcmList;
        Task objTask = new Task();
        objTask.whatId = rfcmList[0].Id;
        objTask.status = 'Open';
        objTask.subject = 'assigned for approval';
        Insert objTask;
        CancelRFCMController.cancelRFCM(rfcmList[0].Id,'Test');
        
    }
}