@IsTest
public class UNILAB_Batch_UploadTest {
    @IsTest
    static void massDelete(){
        createTestSetup();     
    }
    private static void createTestSetup(){
        List<Account> AccList = new List<Account>();
        Account acc = new Account();
        acc.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch/Single Accounts').getRecordTypeId();
        acc.Name = 'pappa';
        acc.Branch_Code__c = '80000002';
        acc.Bill_To_Code__c = '0822234567';
        AccList.add(acc);
        insert AccList;
        System.debug('Account'+acc.Id);
        
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
        
        List<Material__c> materialList = new List<Material__c>();
        Material__c material = new Material__c();
        material.Name = '100556';
        material.Company_Name__c = 'Appistoki';
        material.Material_Id__c = '7636374hfj';
        //insert material;
        materialList.add(material);
        insert materialList;
        //Id recordType =Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Senior & Disc').getRecordTypeId();
        List<RFCM_Line_Item__C> LineItemList = new List<RFCM_Line_Item__C>();
        RFCM_Line_Item__C lineItem = new RFCM_Line_Item__C();
        lineItem.unilab_Company__c = 'Salesforce';
        lineItem.RFCM__c = RFCMRecord.Id;
        lineItem.Material__c = material.Id;
        LineItemList.add(lineItem);
        insert LineItemList;
        
        UNILAB_Batch_Upload.slice(LineItemList, 1, 2);
        String uploadRecord = '[{"CustomerName":"80000002","MaterialCode":"100556","Amount":\"50,000\","PPD":"3100000030"}]';
        
        List<Project_Proposal_Document__c> ppdList = new List<Project_Proposal_Document__c>();
        Project_Proposal_Document__c ppd = new Project_Proposal_Document__c();
        ppd.Name = '3100000030';
        ppdList.add(ppd);
        insert ppdList;
        
        String gencsv = 'CustomerName,MaterialCode,Amount,PPD \n 80000002,100556,1001000,100010';
                
        UNILAB_Batch_Upload.saveFile(gencsv, RECMList[0].id);
        //UNILAB_Batch_Upload.saveFile1(gencsv);
        UNILAB_Batch_Upload.dummymethod();
        UNILAB_Batch_Upload.handleUpload(uploadRecord,RFCMRecord.Id );
        //UNILAB_Batch_Upload.handleUpload('file.csv', lineItem.Id);
    }
}