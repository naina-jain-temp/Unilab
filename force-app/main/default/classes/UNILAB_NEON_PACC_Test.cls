@isTest
public class UNILAB_NEON_PACC_Test {
	@isTest
    public static void fetchProductAcct() {
        NEON_Account_Ref__c acctRef = new NEON_Account_Ref__c();
        acctRef.CT_Customer_Team_Name__c = 'Customer Team 1';
        acctRef.Account_Group__c = 'MDC';
        acctRef.Is_Active__c = true;
        insert acctRef;
   		
        Test.startTest();
        	List<NEON_Account_Ref__c> fetchProductAcct = UNILAB_NEON_PACC.fetchProductAcct('Customer Team 1');
        Test.stopTest();
        System.assert(fetchProductAcct.size()>0);
    }
    
    @isTest
    public static void fetch() {
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
        insert newProd;
        
        NEON_Product_Account__c prodAcct = new NEON_Product_Account__c();
        prodAcct.NEON_Product__c = newProd.Id;
        prodAcct.Account_Group__c = 'MDC';
        prodAcct.CT_Customer_Team_Name__c = 'Customer Team 1';
        prodAcct.Pipeline_Date__c = date.today();
        prodAcct.Saturation_Date__c = date.today();
        insert prodAcct;
        
        List<String> ct = new List<String>();
        ct.add('Customer Team 1');
        
        List<String> ct2 = new List<String>();
        ct2.add('Customer Team 2');
        
        Test.startTest();
        	List<UNILAB_NEON_PACC.NAccountListWrapper> fetch = UNILAB_NEON_PACC.fetch(ct,newProd.Id);
        	List<UNILAB_NEON_PACC.NAccountListWrapper> fetch2 = UNILAB_NEON_PACC.fetch(ct2,'0');
        Test.stopTest();
        
        
        System.assert(fetch2.size()<=0);
        System.assert(fetch.size()>0);
    }
    
    @isTest
    public static void fetchWithoutNeonProdAcc() {
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
        insert newProd;
        
        
        List<String> ct = new List<String>();
        ct.add('Customer Team 1');
        
        List<String> ct2 = new List<String>();
        ct2.add('Customer Team 2');
        
        Test.startTest();
        	List<UNILAB_NEON_PACC.NAccountListWrapper> fetch = UNILAB_NEON_PACC.fetch(ct,newProd.Id);
        	List<UNILAB_NEON_PACC.NAccountListWrapper> fetch2 = UNILAB_NEON_PACC.fetch(ct2,'0');
        Test.stopTest();
        
        
        System.assert(fetch2.size()<=0);
        System.assert(fetch.size()>0);
    }
    
    @isTest
    public static void saveForm() {
        NEON_Account_Ref__c acctRef = new NEON_Account_Ref__c();
        acctRef.CT_Customer_Team_Name__c = 'Customer Team 1';
        acctRef.Account_Group__c = 'MDC';
        acctRef.Is_Active__c = true;
        insert acctRef;
        
        Product2 prod = new Product2();
        prod.Name = 'BIOGESIC';
        prod.ProductCode = '156168';
        insert prod;
        
        Product2 prod2 = new Product2();
        prod2.Name = 'NEOZEP';
        prod2.ProductCode = '166168';
        insert prod2;
        
        NEON_Product__c newProd = new NEON_Product__c();
        newProd.Product__c = prod.Id;
        newProd.Stock_Size__c =100;
        newProd.SRP_Net_of_VAT__c = 100.10;
        newProd.Status__c = 'Draft';
        insert newProd;
        
        NEON_Product__c newProd2 = new NEON_Product__c();
        newProd2.Product__c = prod2.Id;
        newProd2.Stock_Size__c =100;
        newProd2.SRP_Net_of_VAT__c = 100.10;
        newProd2.Status__c = 'Draft';
        insert newProd2;
        
        string npId = newProd.Id;
        string npIdCut = npId.left(18);
        
        NEON_Product_Account__c prodAcct = new NEON_Product_Account__c();
        prodAcct.NEON_Product__c = newProd.Id;
        prodAcct.Account_Group__c = 'MDC';
        prodAcct.CT_Customer_Team_Name__c = 'Customer Team 1';
        prodAcct.Pipeline_Date__c = date.today();
        prodAcct.Saturation_Date__c = date.today();
        insert prodAcct;
        
        List<NEON_Product_Account__c> prodAcctList =  [Select id, NEON_Product__c, Account_Group__c, CT_Customer_Team_Name__c  
                                                       ,Pipeline_Date__c, Saturation_Date__c
                                                       From NEON_Product_Account__c Limit 1];
        
        List<NEON_Product_Account__c> prodAcctList2 = new List<NEON_Product_Account__c>();
        
        /*prodAcctList[0].Account_Group__c = 'MDC';
        prodAcctList[0].CT_Customer_Team_Name__c = 'Customer Team 1';
        prodAcctList[0].Pipeline_Date__c = date.today();
        prodAcctList[0].Saturation_Date__c = date.today();
        prodAcctList[0].NEON_Product__c = newProd.Id;
        insert prodAcctList;*/
        
        Test.startTest();
        	String saveForm = UNILAB_NEON_PACC.saveForm(prodAcctList,newProd.Id);
        	String saveForm2 = UNILAB_NEON_PACC.saveForm(prodAcctList2,newProd2.Id);
        Test.stopTest();
        System.assert(saveForm == null);
        System.assert(saveForm != '');
        System.assert(saveForm2 == null);
        
        
    }
    
    @isTest
    public static void saveFormWithoutNeonProdAcc() {
        NEON_Account_Ref__c acctRef = new NEON_Account_Ref__c();
        acctRef.CT_Customer_Team_Name__c = 'Customer Team 1';
        acctRef.Account_Group__c = 'MDC';
        acctRef.Is_Active__c = true;
        insert acctRef;
        
        Product2 prod = new Product2();
        prod.Name = 'BIOGESIC';
        prod.ProductCode = '156168';
        insert prod;
        
        Product2 prod2 = new Product2();
        prod2.Name = 'NEOZEP';
        prod2.ProductCode = '166168';
        insert prod2;
        
        NEON_Product__c newProd = new NEON_Product__c();
        newProd.Product__c = prod.Id;
        newProd.Stock_Size__c =100;
        newProd.SRP_Net_of_VAT__c = 100.10;
        newProd.Status__c = 'Draft';
        insert newProd;
        
        NEON_Product__c newProd2 = new NEON_Product__c();
        newProd2.Product__c = prod2.Id;
        newProd2.Stock_Size__c =100;
        newProd2.SRP_Net_of_VAT__c = 100.10;
        newProd2.Status__c = 'Draft';
        insert newProd2;
        
        string npId = newProd.Id;
        string npIdCut = npId.left(18);
        
        List<NEON_Product_Account__c> prodAcctList =  new List<NEON_Product_Account__c>();
        
        NEON_Product_Account__c prodAcct = new NEON_Product_Account__c();
        prodAcct.NEON_Product__c = newProd.Id;
        prodAcct.Account_Group__c = 'MDC';
        prodAcct.CT_Customer_Team_Name__c = 'Customer Team 1';
        prodAcct.Pipeline_Date__c = date.today();
        prodAcct.Saturation_Date__c = date.today();
        prodAcctList.add(prodAcct);
        
        
        Test.startTest();
        	String saveForm = UNILAB_NEON_PACC.saveForm(prodAcctList,newProd.Id);
        Test.stopTest();
        
        System.assert(saveForm != '');
        
        
    }
}