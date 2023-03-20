public class UNILAB_TPA_Account_User {
	@AuraEnabled 
    public static List<public_data_tpa_user__x> fetchTPA(string recordID){
        
        return [Select group_alias__c,full_name__c, position_sub_type_name__c From public_data_tpa_user__x WHERE sfa_account_id__c = :recordID LIMIT 1000];
    }
}