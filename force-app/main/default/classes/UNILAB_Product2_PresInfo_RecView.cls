public class UNILAB_Product2_PresInfo_RecView {
	@AuraEnabled 
    public static string fetchPPI(string recordID){
        String prescribingInfoId = [SELECT Id FROM Prescribing_Info__c WHERE PRODUCT__C = :recordID Limit 1].Id;
        return prescribingInfoId;
        
    }
}