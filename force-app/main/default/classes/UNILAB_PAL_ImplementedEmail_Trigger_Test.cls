/*----------------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   06.17.2019
Definition   :   Test Class for UNILAB_PAL Implemented Email Trigger
-----------------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_PAL_ImplementedEmail_Trigger_Test {
    
    @testSetup static void setup() {
        UNILAB_PAL_TestDataFactory.createAccountForBatch();
        UNILAB_PAL_TestDataFactory.createPromoForEmailHandling();
        UNILAB_PAL_TestDataFactory.createPMOGUser();
        UNILAB_PAL_TestDataFactory.createGTCMDDevUser();
        UNILAB_PAL_TestDataFactory.createKACMDDevUser();
        UNILAB_PAL_TestDataFactory.createMTCMDDevUser();
        UNILAB_PAL_TestDataFactory.createMDCCMDDevUser();
        UNILAB_PAL_TestDataFactory.createGTUser();
        UNILAB_PAL_TestDataFactory.createKAUser();
        UNILAB_PAL_TestDataFactory.createMTUser();
        UNILAB_PAL_TestDataFactory.createMDCUser();
    }
    @isTest
    private static  void implementedEmailTriggerTest(){
        Promo__c promoRec =[SELECT Id From Promo__c LIMIT 1];
        List<Allocation__c> listOfAlloc = [SELECT Id,Status__c,Promo__c From Allocation__c WHERE Promo__c =: promoRec.Id];
        List<Allocation__c> listOfAllocToUpdate = new List<Allocation__c>();
        
        
        for(Allocation__c allocRec : listOfAlloc){
            
            allocRec.Status__c = 'Finalized';
            listOfAllocToUpdate.add(allocRec);
        }
        promoRec.Status__c = 'Implemented';
        
        test.startTest();
        update listOfAllocToUpdate;
        update promoRec;
        test.stopTest();
    }
}