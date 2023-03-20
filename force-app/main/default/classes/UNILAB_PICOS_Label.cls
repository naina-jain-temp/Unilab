public class UNILAB_PICOS_Label {
	@AuraEnabled
    public static string fetchRES(string recordId){
        
        return [SELECT Retail_Environment__c FROM Account WHERE Id = :recordId 
                                     		Limit 1].Retail_Environment__c;
    }
}