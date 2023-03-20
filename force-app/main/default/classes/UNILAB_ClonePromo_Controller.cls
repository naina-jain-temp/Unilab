/*----------------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   05.06.2019
Definition   :   Clone Promo Apex Class
-----------------------------------------------------------------------------------------------------*/
public class UNILAB_ClonePromo_Controller {
	//promoRecord.RecordTypeId = Schema.SObjectType.Promo__c.getRecordTypeInfosByName().get('Cancelled').getRecordTypeId();
    @AuraEnabled
    public static Promo__c getPromoDetails (Id recordId) {
        Promo__c promoRec = [SELECT Id,Promo_Name__c,Start_Date__c FROM Promo__c WHERE Id =: recordId];
        return promoRec;
    }
}