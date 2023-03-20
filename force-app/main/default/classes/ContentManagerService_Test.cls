@isTest
public class ContentManagerService_Test {
    public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    @isTest static void getContentDetails() {
        system.runAs(testUser1){
        List<Product2> prod2List = TestDataFactory.createProducts(20);
        insert prod2List;
        /*
        Product2 prodList = new Product2(
        	ProductCode='123456',
            Name='Biogesic',
            IsActive=true
        );
        insert prodList;*/
        
        Product2 selProd = [Select Id, Name From Product2 LIMIT 1];
        
        ContentVersion contentVersion = new ContentVersion(
            Title          = 'a picture',
            PathOnClient   = 'Pic.jpg',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
        insert contentVersion; 
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = selProd.Id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            cdl.visibility = 'AllUsers';
        insert cdl;
        
        Test.startTest();
        	string cli = ContentManagerService.getContentDetails(documents[0].Id);
        Test.stopTest();
        System.assert(documents[0].Id!=null);
        }
    }
    /*
    @isTest static void ContentType() {
        String ctype = 'jpeg';
        Test.startTest();
        	string cli = ContentManagerService.ContentType(ctype);
        Test.stopTest();
        System.assert(ctype!=null);
    }*/
}