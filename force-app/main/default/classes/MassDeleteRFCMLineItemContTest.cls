@IsTest
public class MassDeleteRFCMLineItemContTest {
    @IsTest
    static void massDelete(){
        createTestSetup();     
    }
    private static void createTestSetup(){
        List<Account> AccList = new List<Account>();
        Account acc = new Account();
        acc.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch/Single Accounts').getRecordTypeId();
        acc.Name = 'pappa';
        acc.Branch_Code__c = '1234567897';
        acc.Bill_To_Code__c = '0822234567';
        AccList.add(acc);
        insert AccList;
        System.debug('Account'+acc.Id);
        
        //Id recordType =Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Senior & Disc').getRecordTypeId();
        
  
        List<RFCM__c> RECMList = new List<RFCM__c>();
        RFCM__c RFCMRecord = new RFCM__c();
        RFCMRecord.unilab_Accrued__c = 'YES';
        RFCMRecord.RecordTypeId = Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Senior & Disc').getRecordTypeId();
        RFCMRecord.Customer_Team__c = 'Customer Team 1';
        RFCMRecord.unilab_Classification__c = 'Marketing Charges Internal';
        RFCMRecord.unilab_Program__c = 'New Product Support & Listing Fees - Field Initiated';
        RFCMRecord.unilab_Claim_Reference_Number__c = '123';
        RFCMRecord.unilab_Claim_Description__c = 'Very good';
        RFCMRecord.unilab_Company__c = 'Salesforce';  
        RFCMRecord.unilab_Start_Date__c=   Date.TOday().addDays(-7);
        RFCMRecord.unilab_End_Date__c = Date.TOday();
        RFCMRecord.Customer_Name__c = acc.id;
        RFCMRecord.unilab_Customer_Code__c = acc.Branch_Code__c;
        RECMList.add(RFCMRecord);
        System.debug(RFCMRecord.Customer_Name__c);
        //insert RECMList;

        //Id recordType =Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Senior & Disc').getRecordTypeId();
        List<RFCM_Line_Item__C> LineItemList = new List<RFCM_Line_Item__C>();
        RFCM_Line_Item__C lineItem = new RFCM_Line_Item__C();
        lineItem.unilab_Company__c = 'Salesforce';
        lineItem.RFCM__c = RFCMRecord.Id;
        LineItemList.add(lineItem);
        insert LineItemList;
        MassDeleteRFCMLineItemCont.massDelete(RFCMRecord.Id);
    }

}