/*----------------------------------------------------------------------------------------------------
Author       :   Katherine Roberto
Created Date :   06.13.2019
Definition   :   Test Class for UNILAB_PAL Allocation CDS View
-----------------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_PAL_AllocationCDSview_Test {

    @isTest
    static void getAllocationPositive(){
        String channel = 'Key Accounts';
        // Create Account
        UNILAB_PAL_TestDataFactory.createAccounts();
        List<Account> acctList = UNILAB_PAL_TestDataFactory.getAccounts();
        
        // Create Promo and Allocation
        UNILAB_PAL_TestDataFactory.createPromoAndAllocation();
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromoForBatchApexTest();
        
        // Get Allocations
       LiST<Allocation__c> allocList = [SELECT Id, Channel__c FROM Allocation__c 
                               WHERE Promo__c =: promoRec.Id
                               AND Channel__c =: channel LIMIT 10 ];
        
        
        // Create Account Allocation
        UNILAB_PAL_TestDataFactory.createAccountAllocation(allocList,acctList);
        List<Account_Allocation__c> acctAllocRecs = UNILAB_PAL_TestDataFactory.getAccountAllocs(allocList);
        
        Test.startTest();
        UNILAB_PAL_AllocationCDSview.getAllocation(acctAllocRecs[0].id);
        Test.stopTest();
        
  		system.assert( acctAllocRecs.size() > 0 );
    }
        
}