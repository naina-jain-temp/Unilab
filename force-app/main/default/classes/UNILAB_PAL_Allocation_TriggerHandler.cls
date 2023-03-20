/*-------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   07.03.2019
Definition   :   Trigger Handler for UNILAB_PAL_Allocation
-------------------------------------------------------------------------------------------*/
public class UNILAB_PAL_Allocation_TriggerHandler {
	//Checks if Newly Created Allocation record has an existing record with same promo
    public static void doBeforeInsert(List<Allocation__c> newAllocRecords){
        
        Set<Id> promoSet = new Set<Id>();
        Set<String> allocWithPromoSet = new Set<String>();
        for(Allocation__c allocRec : newAllocRecords){
            promoSet.add(allocRec.Promo__c);
        }
        
        for(Allocation__c allocRecFromDB : [SELECT Id, Promo__c, Channel__c FROM Allocation__c WHERE Promo__c IN : promoSet AND Status__c != 'Canceled']){
            allocWithPromoSet.add(allocRecFromDB.Channel__c);
            for(Allocation__c allocRec : newAllocRecords){
                if(allocWithPromoSet.contains(allocRec.Channel__c)){
                   String errorMessage = 'Creation of new Allocation record in a Promo with an existing or duplicate channel is not allowed.';
                   allocRec.addError(errorMessage,false); 
                }
            }
        }
    }
}