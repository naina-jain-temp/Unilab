@isTest
public class UNILAB_NEON_ISPlan_Summary_Test {
	
    @isTest
    public static void fetchISSummary() {
        
        Account acc = new Account();
        acc.Name = 'acc1';
        acc.CT_Customer_Team_Name__c = 'Customer Team 1';
        acc.Account_Group__c = 'MDC';
        acc.Channel__c = 'Mercury';
        acc.Bill_To_Code__c = '0080322195';
     	insert acc;
        
    	NEON_Account_Ref__c acctRef = new NEON_Account_Ref__c();
        acctRef.CT_Customer_Team_Name__c = 'Customer Team 1';
        acctRef.Account_Group__c = 'MDC';
        acctRef.Is_Active__c = true;
        insert acctRef;
        
        Product2 prod = new Product2();
        prod.Name = 'BIOGESIC';
        prod.ProductCode = '156168';
        insert prod;
        
        NEON_Product__c newProd = new NEON_Product__c();
        newProd.Product__c = prod.Id;
        newProd.Stock_Size__c =100;
        newProd.SRP_Net_of_VAT__c = 100.10;
        newProd.Status__c = 'Draft';
        insert newProd;
        
        List<NEON_Product_Account__c> prodAcctList =  new List<NEON_Product_Account__c>();
        
        NEON_Product_Account__c prodAcct = new NEON_Product_Account__c();
        prodAcct.NEON_Product__c = newProd.Id;
        prodAcct.Account_Group__c = 'MDC';
        prodAcct.CT_Customer_Team_Name__c = 'Customer Team 1';
        prodAcct.Pipeline_Date__c = date.today();
        prodAcct.Saturation_Date__c = date.today();
        prodAcctList.add(prodAcct);
        
        //List<NEON_IS_Plan__c> prodISPlanList =  new List<NEON_IS_Plan__c>();
        
        /*NEON_IS_Plan__c prodISPlan = new NEON_IS_Plan__c();
        prodISPlan.NEON_Product__c = newProd.Id;
        prodISPlan.Account__c = acc.Id;
        prodISPlan.IS_Status__c = 'Submitted';
        prodISPlan.IS_Qty__c = 1000;
        prodISPlan.Branch_Target__c = 500;
        insert prodISPlan;*/
        
        Test.startTest();
        	List<AggregateResult> fetchISSummary = UNILAB_NEON_ISPlan_Summary.fetchISSummary(newProd.Id);
        Test.stopTest();
        
        //System.assert(fetchISSummary.size()<0);
    }
}