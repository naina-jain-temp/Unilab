public class UNILAB_PICOS {
	@AuraEnabled 
    public static List<contentDocument> fetchContentDocument(string recordID){
        
        Account AccountRES = [SELECT retail_environment__c FROM Account WHERE Id = :recordID
                                     Limit 1];
        String AcctRES = AccountRES.Retail_Environment__c;
        //String ReturnQuery = 'Select id,Title From contentDocument WHERE Description LIKE \'%' + AcctRES + '%\'';
        
        //return [ReturnQuery];
        return [Select id,Title From contentDocument WHERE Description LIKE :('%' + AcctRES + '%') LIMIT 1000];
    }
    
}