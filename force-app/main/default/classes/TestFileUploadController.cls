@isTest
public class TestFileUploadController {
    @isTest
    public static void testFileUpload(){
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Main/Warehouse').getRecordTypeId();
        acc.Name = 'metacube';
        acc.Branch_Code__c = '1';
        acc.Bill_To_Code__c = '1230987654';
        insert acc;
        
        ContentVersion contentdoc = new ContentVersion();
        contentdoc.Title = 'test';
        contentdoc.PathOnClient = 'test';
        contentdoc.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert contentdoc;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        RFCM_line_item__c rfcmlineitem = new RFCM_line_item__c();
        List<RFCM_line_item__c> RFCMList = new List<RFCM_line_item__c>();
        rfcmlineitem.unilab_Amount__c= 1000;
        rfcmlineitem.unilab_Company__c = 'Appistoki'; 
        RFCMList.add(rfcmlineitem);
        FileUploadController.getFiles(contentdoc.id, 'page.csv');
        FileUploadController.updateFiles(documents[0].id, 'test' , acc.Id);
        FileUploadController.deleteFile(documents[0].id);
        
        
        
    }

}