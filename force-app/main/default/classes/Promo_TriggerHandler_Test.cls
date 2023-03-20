@isTest
private class Promo_TriggerHandler_Test {
    
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
        UNILAB_PAL_TestDataFactory.createPromo();
    }
    
    @isTest static void updateStatusImplemented(){
        
        Promo__c promoRecord = UNILAB_PAL_TestDataFactory.createPromo();
        UNILAB_PAL_TestDataFactory.createAllocRecords(promoRecord.Id);
        List<Allocation__c> allocList = UNILAB_PAL_TestDataFactory.getPromoAllocations(promoRecord.Id);
        UNILAB_PAL_TestDataFactory.finalizeAllocations(allocList);
        
        test.startTest();
        try{
            UNILAB_PAL_TestDataFactory.updatePromoStatus(promoRecord.Id);
        }catch(DmlException e){
            System.assertEquals('Update failed. First exception on row 0 with id '+promoRecord.Id+'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Promo can only be implemented if Allocations are Finalized: []',
                                e.getMessage());
        }        
        
        test.stopTest();
    }
    
    @isTest static void singlePromoRecordInsert(){
        test.startTest();
        UNILAB_PAL_TestDataFactory.createPromo();
        test.stopTest();
        
        Promo__c actualPromo = [SELECT Id, Name, Promo_Type__c, Start_Date__c, End_Date__c FROM Promo__c LIMIT 1];
        System.assert(actualPromo.Id != NULL);
        
    }
    
    @isTest static void negativePromo(){

        test.startTest();
        try{
              UNILAB_PAL_TestDataFactory.createPromoTriggerImplemented();
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            System.assert(e.getMessage().contains('Promo can only be implemented if Allocations are Finalized'));
        }  
        test.stopTest();

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