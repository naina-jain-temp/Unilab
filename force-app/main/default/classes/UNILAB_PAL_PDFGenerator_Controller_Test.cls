/*----------------------------------------------------------------------------------------------------
Author       :   Katherine Roberto
Created Date :   06.13.2019
Definition   :   Test Class for UNILAB_PAL PDF Generator Controller
-----------------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_PAL_PDFGenerator_Controller_Test {
    
    @isTest
    static void generatePDF(){
        String channel = 'Key Accounts';
        // Create Account
        UNILAB_PAL_TestDataFactory.createAccounts();
        List<Account> acctList = UNILAB_PAL_TestDataFactory.getAccounts();
        
        // Create Promo and Allocation
        UNILAB_PAL_TestDataFactory.createPromoAndAllocation();
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromoForBatchApexTest();
        
        // Get Allocations
       List<Allocation__c> allocList = [SELECT Id, Channel__c FROM Allocation__c 
                               WHERE Promo__c =: promoRec.Id
                               AND Channel__c =: channel LIMIT 10 ];
        
        
        // Create Account Allocation
        UNILAB_PAL_TestDataFactory.createAccountAllocation(allocList,acctList);
        List<Account_Allocation__c> acctAllocRecs = UNILAB_PAL_TestDataFactory.getAccountAllocs(allocList);
        
        System.debug('allocrecs' + acctAllocRecs);
        
        PageReference pageRef = Page.UNILAB_PAL_PDFGenerator;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('recordId', acctAllocRecs[0].Id);
        
        System.debug('ACCT ALLOC RECS: ' + acctAllocRecs[0].Id);
        
        Account_Allocation__c newAccAlloc = [SELECT Account__r.Channel__c,Account__r.Team__c,Account__r.Account_Group__c,
                        Account__r.Name, Allocation__r.Total_Account_Allocation__c, Final_Allocation__c,
                        Allocation__r.Start_Date__c, Allocation__r.End_Date__c,Account__r.Owner.Name 
                        FROM Account_Allocation__c 
                        WHERE Allocation__c =: allocList[0].Id];

        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(newAccAlloc);
        UNILAB_PAL_PDFGenerator_Controller palPDF = new UNILAB_PAL_PDFGenerator_Controller(stdCon);

        List<Account_Allocation__c> newAccAlloc2 = [SELECT Account__r.Channel__c,Account__r.Team__c,Account__r.Account_Group__c,
                        Account__r.Name, Allocation__r.Total_Account_Allocation__c, Final_Allocation__c,
                        Allocation__r.Start_Date__c, Allocation__r.End_Date__c,Account__r.Owner.Name 
                        FROM Account_Allocation__c 
                        WHERE Allocation__c =: allocList[0].Id];

        
        palPDF.accAllocList = newAccAlloc2;
        
        if (palPDF.accAllocList !=null && !palPDF.accAllocList.isEmpty()) { 
            palPDF.accAllocWrapList = new List<UNILAB_PAL_PDFGenerator_Controller.accAllocListWrapper>();
            for (Account_Allocation__c accAlloc : palPDF.accAllocList) {
                palPDF.accAllocWrapList.add(new UNILAB_PAL_PDFGenerator_Controller.accAllocListWrapper(accAlloc));
            }
        }        
        
        System.debug('ACC ALLOC LIST: ' + palPDF.accAllocWrapList);
        
        
 		System.assert(palPDF.accAllocList != NULL);   
        System.assert(palPDF.accAllocWrapList != NULL); 
        //system.debug(ApexPages.currentPage().getParameters().put('recordId', acctAllocRecs[0].Id));
         
    } 

}