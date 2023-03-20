@isTest
public class TestRFCM_Form_Creation {

    @isTest
    public static void testrfcmform(){
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Main/Warehouse').getRecordTypeId();
        acc.Name = 'Appistoki';
        acc.Branch_Code__c = '1';
        acc.Bill_To_Code__c = '1230987654';
        insert acc;
        
        RFCM_FormNumber__c rfcnumform = new RFCM_FormNumber__c();
        rfcnumform.Name = 'rfcnumform';
        rfcnumform.Date__c = system.today();
        rfcnumform.Number__c = 1;
        insert rfcnumform;
        
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
        insert rfcm;
        
        
        RFCM_Form_Creation.wrapClas wrp = new RFCM_Form_Creation.wrapClas();
        RFCM_Form_Creation.getPickListValues('RFCM__c','Name');
        RFCM_Form_Creation.getPickListValues(null,null);
        RFCM_Form_Creation.getRecords('test', 'RFCM__c','Name');
        RFCM_Form_Creation.saveRecords(rfcm);
    }
    
    @isTest
    public static void testrfcmform1(){
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Main/Warehouse').getRecordTypeId();
        acc.Name = 'metacube';
        acc.Branch_Code__c = '1';
        acc.Bill_To_Code__c = '1230987654';
        insert acc;
        
        
        RFCM__c rfcm = new RFCM__c();
        rfcm.RecordTypeId = Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Regular RFCM').getRecordTypeId();
        rfcm.Customer_Team__c = 'Trade Marketing Group';
        rfcm.Customer_Sub_Team__c = 'Customer Team 5 - TMG ULSSI';
        //rfcm.unilab_Classification__c = 'MOS Internal';
        rfcm.unilab_Program__c = 'Trade Promotions - TMG Initiated';
        rfcm.unilab_Accrued__c = 'YES';
        rfcm.unilab_Claim_Reference_Number__c = '123';
        rfcm.unilab_Claim_Description__c = 'test';
        rfcm.unilab_Start_Date__c = Date.newInstance(2022, 06, 11);
        rfcm.unilab_End_Date__c =Date.newInstance(2022, 06, 20);
        rfcm.Customer_Name__c = acc.Id;
        rfcm.unilab_Customer_Code__c = '1';
        
        RFCM_Form_Creation.saveRecords(rfcm);
        RFCM_Form_Creation.wrapClas wrp = new RFCM_Form_Creation.wrapClas();
        RFCM_Form_Creation.getPickListValues('RFCM__c','Name');
        RFCM_Form_Creation.getPickListValues(null,null);
        RFCM_Form_Creation.getRecords('test', 'RFCM__c','Name');
        
    }
}