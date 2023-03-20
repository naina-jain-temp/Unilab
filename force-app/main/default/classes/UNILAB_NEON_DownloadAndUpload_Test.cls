@isTest
private class UNILAB_NEON_DownloadAndUpload_Test {
    public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    
    @isTest
    private static void getHOAccountDetails() {
        system.runAs(testUser1){
            RecordType rtypeHO = [Select Name, Id From RecordType 
                      where sObjectType='Account' and Name ='Main/Warehouse' and isActive=true];
            
            Account acc = new Account();
            acc.Name = 'TestAcc';
            acc.Branch_Code__c = 'BR1';
            acc.Branch_Name__c = 'BrName';
            acc.Channel_Group__c = 'POS';
            acc.Channel__c = 'Mercury';
            acc.Account_Type__c = 'Head Office';
            acc.RecordTypeId = rtypeHO.Id;
            acc.Team__c = 'MDC';
            acc.Account_Group__c = 'MDC';
            acc.Account_Status__c = 'Open';
            acc.Bill_To_Code__c = '0987654321';
            insert acc;
            
            Product2 prod = new Product2();
            prod.Name = 'TestProd';
            prod.GLU_Name__c = 'ULCH';
            insert prod;
            
            NEON_Product__c neonProd = new NEON_Product__c();
            neonProd.Product__c = prod.Id;
            insert neonProd;
            
            NEON_Product_Account__c neonProdAcc = new NEON_Product_Account__c();
            neonProdAcc.NEON_Product__c = neonProd.Id;
            neonProdAcc.CT_Customer_Team_Name__c = 'Customer Team 1';
            neonProdAcc.Account_Group__c = 'MDC';
            insert neonProdAcc;
            
            //User usr = [SELECT Id FROM User WHERE Alias='jlorz'];
            
            NEON_User_Matrix__c neonUM = new NEON_User_Matrix__c();
            neonUM.Customer_Team__c = 'Customer Team 1';
            neonUM.BU__c = prod.GLU_Name__c;
            //neonUM.User__c = usr.Id;
            neonUM.User__c = testUser1.Id;
            insert neonUM;
            
            Test.startTest();
            
            List<Account> fetchData = UNILAB_NEON_DownloadAndUpload.fetchData(neonProd.Id,'Head Office');
            
            Test.stopTest();
            
            System.assert(fetchData.size() > 0);
        }
    }
    
    @isTest
    private static void getNotHOAccountDetails() {
        system.runAs(testUser1){
            RecordType rtypeNotHO = [Select Name, Id From RecordType 
                      where sObjectType='Account' and Name ='Branch/Single Accounts' and isActive=true];
            
            Account acc = new Account();
            acc.Name = 'TestAcc';
            acc.Branch_Code__c = 'BR1';
            acc.Branch_Name__c = 'BrName';
            acc.Channel_Group__c = 'POS';
            acc.Channel__c = 'Mercury';
            acc.Account_Type__c = 'Ware House';
            acc.RecordTypeId = rtypeNotHO.Id;
            acc.Team__c = 'MDC';
            acc.Account_Group__c = 'MDC';
            acc.Account_Status__c = 'Open';
            acc.Bill_To_Code__c = '0987654321';
            insert acc;
            
            Product2 prod = new Product2();
            prod.Name = 'TestProd';
            prod.GLU_Name__c = 'ULCH';
            insert prod;
            
            NEON_Product__c neonProd = new NEON_Product__c();
            neonProd.Product__c = prod.Id;
            insert neonProd;
            
            NEON_Product_Account__c neonProdAcc = new NEON_Product_Account__c();
            neonProdAcc.NEON_Product__c = neonProd.Id;
            neonProdAcc.CT_Customer_Team_Name__c = 'Customer Team 1';
            neonProdAcc.Account_Group__c = 'MDC';
            insert neonProdAcc;
            
            //User usr = [SELECT Id FROM User WHERE Alias='jlorz'];
            
            NEON_User_Matrix__c neonUM = new NEON_User_Matrix__c();
            neonUM.Customer_Team__c = 'Customer Team 1';
            neonUM.BU__c = prod.GLU_Name__c;
            //neonUM.User__c = usr.Id;
            neonUM.User__c = testUser1.Id;
            insert neonUM;
            
            Test.startTest();
            
            List<Account> fetchData = UNILAB_NEON_DownloadAndUpload.fetchData(neonProd.Id,'Ware House');
            
            Test.stopTest();
            
            System.assert(fetchData.size() > 0);
        }
    }
    
    @isTest
    private static void postISPlan() {
        system.runAs(testUser1){
            Product2 prod = new Product2();
            prod.Name = 'TestProd';
            prod.GLU_Name__c = 'ULCH';
            insert prod;
            
            NEON_Product__c neonProd = new NEON_Product__c();
            neonProd.Product__c = prod.Id;
            insert neonProd;
            
            //User usr = [SELECT Id FROM User WHERE Alias='jlorz'];
            
            NEON_User_Matrix__c neonUM = new NEON_User_Matrix__c();
            neonUM.Customer_Team__c = 'Customer Team 1';
            neonUM.BU__c = prod.GLU_Name__c;
            //neonUM.User__c = usr.Id;
            neonUM.User__c = testUser1.Id;
            insert neonUM;
            
            String strfromle = '[{"is_qty":"123","branch_target":"3","channel":"Modern Trade","team":"SMEC Team","account_group":"SAVEMORE","sfa_internal_id":"001p000000zqmWAAAY","branch_code":"89124578","branch_name":"HO-SAVEMORE","account_type":"Head Office"}]';
            
            Test.startTest();
            
            String insertData = UNILAB_NEON_DownloadAndUpload.insertData(strfromle, neonProd.Id);
            
            Test.stopTest();
            
            System.assert(insertData!='');
        }
    }
    
    @isTest
    private static void postISPlanError() {
        system.runAs(testUser1){
            Product2 prod = new Product2();
            prod.Name = 'TestProd';
            prod.GLU_Name__c = 'ULCH';
            insert prod;
            
            NEON_Product__c neonProd = new NEON_Product__c();
            neonProd.Product__c = prod.Id;
            insert neonProd;
            
            String strfromle = '[{"is_qty":"123","branch_target":"3","channel":"Modern Trade","team":"SMEC Team","account_group":"SAVEMORE","sfa_internal_id":"001p000000zqmWAAAY","branch_code":"89124578","branch_name":"HO-SAVEMORE","account_type":"Head Office"}]';
            
            Test.startTest();
            
            String insertData = UNILAB_NEON_DownloadAndUpload.insertData(strfromle, neonProd.Id);
            
            Test.stopTest();
            
            System.assert(insertData=='ERROR');
        }
    }
    
    @isTest
    private static void getISPlanStatus() {
        system.runAs(testUser1){
            Account acc = new Account();
            acc.Name = 'TestAcc';
            acc.Branch_Code__c = 'BR1';
            acc.Branch_Name__c = 'BrName';
            acc.Channel_Group__c = 'POS';
            acc.Channel__c = 'Mercury';
            acc.Account_Type__c = 'Ware House';
            acc.Team__c = 'MDC';
            acc.Account_Group__c = 'MDC';
            acc.Account_Status__c = 'Open';
            acc.Bill_To_Code__c = '0987654321';
            acc.CT_Customer_Team_Name__c = 'Customer Team 1';
            insert acc;
            
            Product2 prod = new Product2();
            prod.Name = 'TestProd';
            prod.GLU_Name__c = 'ULCH';
            insert prod;
            
            NEON_Product__c neonProd = new NEON_Product__c();
            neonProd.Product__c = prod.Id;
            insert neonProd;
            
            NEON_Product_Account__c neonProdAcc = new NEON_Product_Account__c();
            neonProdAcc.NEON_Product__c = neonProd.Id;
            neonProdAcc.CT_Customer_Team_Name__c = 'Customer Team 1';
            neonProdAcc.Account_Group__c = 'MDC';
            insert neonProdAcc;
            
            //User usr = [SELECT Id FROM User WHERE Alias='jlorz'];
            
            NEON_User_Matrix__c neonUM = new NEON_User_Matrix__c();
            neonUM.Customer_Team__c = 'Customer Team 1';
            neonUM.BU__c = prod.GLU_Name__c;
            //neonUM.User__c = usr.Id;
            neonUM.User__c = testUser1.Id;
            insert neonUM;
            
            List<NEON_IS_Plan__c> neonISP = new List<NEON_IS_Plan__c>();
            for(Integer i=0; i<=2; i++) {
                NEON_IS_Plan__c isp = new NEON_IS_Plan__c();
                isp.Account__c = acc.Id;
                isp.Account_Type__c = 'Head Office';
                isp.NEON_Product__c = neonProd.Id;
                isp.Branch_Target__c = 1;
                isp.IS_Qty__c = 1;
                isp.Product__c = neonProd.Product__c;
                isp.IS_Status__c = 'Draft';
                neonISP.add(isp);
            }
            insert neonISP;
            
            Test.startTest();
            
            List<UNILAB_NEON_DownloadAndUpload.FieldWrapper> fetchStatus = UNILAB_NEON_DownloadAndUpload.fetchStatus(neonProd.Id);
            
            Test.stopTest();
            
            System.assert(fetchStatus.size() > 0);
        }
    }
    
    @isTest
    private static void getISPlanStatusWithNoStatus() {
        system.runAs(testUser1){
            Account acc = new Account();
            acc.Name = 'TestAcc';
            acc.Branch_Code__c = 'BR1';
            acc.Branch_Name__c = 'BrName';
            acc.Channel_Group__c = 'POS';
            acc.Channel__c = 'Mercury';
            acc.Account_Type__c = 'Ware House';
            acc.Team__c = 'MDC';
            acc.Account_Group__c = 'MDC';
            acc.Account_Status__c = 'Open';
            acc.Bill_To_Code__c = '0987654321';
            acc.CT_Customer_Team_Name__c = 'Customer Team 1';
            insert acc;
            
            Product2 prod = new Product2();
            prod.Name = 'TestProd';
            prod.GLU_Name__c = 'ULCH';
            insert prod;
            
            NEON_Product__c neonProd = new NEON_Product__c();
            neonProd.Product__c = prod.Id;
            insert neonProd;
            
            NEON_Product_Account__c neonProdAcc = new NEON_Product_Account__c();
            neonProdAcc.NEON_Product__c = neonProd.Id;
            neonProdAcc.CT_Customer_Team_Name__c = 'Customer Team 1';
            neonProdAcc.Account_Group__c = 'MDC';
            insert neonProdAcc;
            
            //User usr = [SELECT Id FROM User WHERE Alias='jlorz'];
            
            NEON_User_Matrix__c neonUM = new NEON_User_Matrix__c();
            neonUM.Customer_Team__c = 'Customer Team 1';
            neonUM.BU__c = prod.GLU_Name__c;
            //neonUM.User__c = usr.Id;
            neonUM.User__c = testUser1.Id;
            insert neonUM;
            
            List<NEON_IS_Plan__c> neonISP = new List<NEON_IS_Plan__c>();
            for(Integer i=0; i<=2; i++) {
                NEON_IS_Plan__c isp = new NEON_IS_Plan__c();
                isp.Account__c = acc.Id;
                isp.Account_Type__c = 'Head Office';
                isp.NEON_Product__c = neonProd.Id;
                isp.Branch_Target__c = 1;
                isp.IS_Qty__c = 1;
                isp.Product__c = neonProd.Product__c;
                neonISP.add(isp);
            }
            insert neonISP;
            
            Test.startTest();
            
            List<UNILAB_NEON_DownloadAndUpload.FieldWrapper> fetchStatus = UNILAB_NEON_DownloadAndUpload.fetchStatus(neonProd.Id);
            
            Test.stopTest();
            
            System.assert(fetchStatus.size() > 0);
        }
    }
    
    @isTest
    private static void getISPlanStatusWithNoISP() {
        system.runAs(testUser1){
            Account acc = new Account();
            acc.Name = 'TestAcc';
            acc.Branch_Code__c = 'BR1';
            acc.Branch_Name__c = 'BrName';
            acc.Channel_Group__c = 'POS';
            acc.Channel__c = 'Mercury';
            acc.Account_Type__c = 'Ware House';
            acc.Team__c = 'MDC';
            acc.Account_Group__c = 'MDC';
            acc.Account_Status__c = 'Open';
            acc.Bill_To_Code__c = '0987654321';
            acc.CT_Customer_Team_Name__c = 'Customer Team 1';
            insert acc;
            
            Product2 prod = new Product2();
            prod.Name = 'TestProd';
            prod.GLU_Name__c = 'ULCH';
            insert prod;
            
            NEON_Product__c neonProd = new NEON_Product__c();
            neonProd.Product__c = prod.Id;
            insert neonProd;
            
            NEON_Product_Account__c neonProdAcc = new NEON_Product_Account__c();
            neonProdAcc.NEON_Product__c = neonProd.Id;
            neonProdAcc.CT_Customer_Team_Name__c = 'Customer Team 1';
            neonProdAcc.Account_Group__c = 'MDC';
            insert neonProdAcc;
            
            //User usr = [SELECT Id FROM User WHERE Alias='jlorz'];
            
            NEON_User_Matrix__c neonUM = new NEON_User_Matrix__c();
            neonUM.Customer_Team__c = 'Customer Team 1';
            neonUM.BU__c = prod.GLU_Name__c;
            //neonUM.User__c = usr.Id;
            neonUM.User__c = testUser1.Id;
            insert neonUM;
            
            Test.startTest();
            
            List<UNILAB_NEON_DownloadAndUpload.FieldWrapper> fetchStatus = UNILAB_NEON_DownloadAndUpload.fetchStatus(neonProd.Id);
            
            Test.stopTest();
            
            System.assert(fetchStatus.size() > 0);
        }
    }
    
    

}