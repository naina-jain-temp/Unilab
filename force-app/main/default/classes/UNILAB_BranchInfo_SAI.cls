public class UNILAB_BranchInfo_SAI {
	@AuraEnabled 
    public static List<public_vw_data_sales_so_ob_pos_mt_s0__x> fetchSAI(string recordId){
        
        return [
            select bu_company__c, measure_type_sorting__c, measure_type__c, amt__c, indices__c
            from public_vw_data_sales_so_ob_pos_mt_s0__x 
            where sfa_account_id__c = :recordId
            order by measure_type_sorting__c,bu_company__c
        ];
    }
}