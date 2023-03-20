public class UNILAB_NEON_ISPlan_Summary {

    @AuraEnabled
    public static List<AggregateResult> fetchISSummary(string recordId){
        AggregateResult[] result = [
        	SELECT Account__r.CT_Customer_Team_Name__c, IS_Status__c, SUM(IS_Qty__c) sum_is_qty, SUM(Branch_Target__c) sum_branch_target
                FROM NEON_IS_Plan__c
                WHERE NEON_Product__c = :recordId
                GROUP BY
                    Account__r.CT_Customer_Team_Name__c,
            		IS_Status__c

        ];
        
        return result;
    }
}