/*----------------------------------------------------------------------------------------------------
Author       :   Joan Bautista
Created Date :   04.05.2019
Definition   :   Apex Controller Class for UNILAB_PAL_AllocationCDSview Lightning Component
-----------------------------------------------------------------------------------------------------*/
public class UNILAB_PAL_AllocationCDSview {
    
    @AuraEnabled
    public static List <Account_Allocation__c> getAllocation(Id recID) {
        return [SELECT Account__r.Name,
                	   Status__c,
                	   Final_Allocation__c
                FROM Account_Allocation__c 
                WHERE (Allocation__c = :recID)
                AND (Account__r.OwnerId = :UserInfo.getUserId())
                ORDER BY Account__r.Name ASC
               ];
    }

}