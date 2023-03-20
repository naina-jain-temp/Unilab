public class UNILAB_BranchInfo_AcctSched {
	@AuraEnabled 
    public static List<Account> fetchAcctSched(string recordId){
        
        return [
            select PO_Day__c, Delivery_Day__c, TPA_Schedule__c
            from Account 
            where Id = :recordId
        ];
    }
}