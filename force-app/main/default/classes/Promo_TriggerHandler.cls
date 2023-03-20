/*-------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   05.06.2019
Definition   :   Trigger Handler for UNILAB_Promo
-------------------------------------------------------------------------------------------*/
public class Promo_TriggerHandler {

    public static void doBeforeUpdate(List<Promo__c> newListRecords ,Map<Id,Promo__c> newMapRecords){
        
        List<Allocation__c> allocRecordList = [SELECT Id, Status__c FROM Allocation__c WHERE Promo__c =: newMapRecords.keySet()];

        for(Promo__c promoRec : newListRecords){
            for(Allocation__c allocRec : allocRecordList){
                if(promoRec.Status__c == 'Implemented' && allocRec.Status__c != 'Finalized'){
                    String errorMessage = 'Promo can only be implemented if Allocations are Finalized';
                    promoRec.addError(errorMessage,false);
                }
            }
        }
    }
}