/*----------------------------------------------------------------------------------------------------
Authors      :   Kristjan Mariano
Created Date :   05.06.2019
Definition   :   Test Class for UNILAB_PAL Clone Promo Controller
-----------------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_ClonePromo_Controller_Test {
    
    @testSetup static void setup() {
        UNILAB_PAL_TestDataFactory.createPromoAndAllocation();
    }
    
    static testmethod void getPromoDetailsPositiveTest(){
        
        Promo__c promoRec = [SELECT Id FROM Promo__c LIMIT 1];
        
        Test.startTest();
        Promo__c clonedPromo = UNILAB_ClonePromo_Controller.getPromoDetails(promoRec.Id);
        Test.stopTest();
        
        System.debug('clonedPromo --> ' + clonedPromo);
    }
    
    static testmethod void getPromoDetailsNegativeTest(){
        
        Promo__c promoRec = null;
        Promo__c clonedPromo = new Promo__c();
        Test.startTest();
        try{
            clonedPromo = UNILAB_ClonePromo_Controller.getPromoDetails(promoRec.Id);
        } catch(Exception e){
            System.debug(e.getMessage());
        }
        Test.stopTest();
        
        System.debug('clonedPromo --> ' + clonedPromo);
    }
}