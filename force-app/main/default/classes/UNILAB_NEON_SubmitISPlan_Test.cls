@isTest
private class UNILAB_NEON_SubmitISPlan_Test {
    @isTest
    private static void getCustomerTeam() {
        
        Product2 prod = new Product2();
        prod.Name = 'TestProd';
        prod.GLU_Name__c = 'ULCH';
        insert prod;
        
        NEON_Product__c neonProd = new NEON_Product__c();
        neonProd.Product__c = prod.Id;
        insert neonProd;
        
        User usr = [SELECT Id FROM User WHERE Alias='mconq'];
        
        NEON_User_Matrix__c neonUM = new NEON_User_Matrix__c();
        neonUM.Customer_Team__c = 'Customer Team 1';
        neonUM.BU__c = prod.GLU_Name__c;
        neonUM.User__c = usr.Id;
        insert neonUM;
        
        Test.startTest();
        
        List<NEON_User_Matrix__c> fetchData = UNILAB_NEON_SubmitISPlan.fetchData(neonProd.Id);
        
        Test.stopTest();
        
        System.assert(fetchData.size() > 0);
    }
    
    @isTest
    private static void putISPlan() {
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
        
        User usr = [SELECT Id FROM User WHERE Alias='mconq'];
        
        NEON_User_Matrix__c neonUM = new NEON_User_Matrix__c();
        neonUM.Customer_Team__c = 'Customer Team 1';
        neonUM.BU__c = prod.GLU_Name__c;
        neonUM.User__c = usr.Id;
        
        List<NEON_User_Matrix__c> neonUMList = new List<NEON_User_Matrix__c>();
        neonUMList.add(neonUM); 
        insert neonUMList;
        
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
        
        String updateISP = UNILAB_NEON_SubmitISPlan.updateISP(neonUMList, neonProd.Id);
        
        Test.stopTest();
        
        System.assert(updateISP!='');
    }
}