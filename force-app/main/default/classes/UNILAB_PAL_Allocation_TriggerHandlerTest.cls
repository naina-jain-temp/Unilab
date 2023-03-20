@isTest
public class UNILAB_PAL_Allocation_TriggerHandlerTest {
	@testSetup static void setup(){
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        
        insert promoRecord;
        
        Allocation__c alloc = new Allocation__c(Promo__c = promoRecord.Id,
                                                Channel__c = 'Key Accounts'
                                               );
        insert alloc;
    }
    
    @isTest static void createAllocation_doBeforeInsert(){
        
        List<Promo__c> promoList =[SELECT Id From Promo__c];
        Allocation__c alloc = new Allocation__c(Promo__c = promoList[0].Id,
                                                Channel__c = 'Key Accounts'
                                               );
        test.startTest();
        try{
            insert alloc;
        }catch(Exception e){
            System.assert(e.getMessage().contains('Creation of new Allocation record in a Promo with an existing or duplicate channel is not allowed.'));
        }
        test.stopTest();
    }
}