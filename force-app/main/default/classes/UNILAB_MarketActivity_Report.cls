public class UNILAB_MarketActivity_Report {
	@AuraEnabled
    public static List<public_data_market_activity__x> fetch(string recordID){
        /*List<public_data_market_activity__x> acc = [SELECT activity_name__c, affected_ul_brand__c, price__c, start_date__c, remarks__c
                                                    FROM public_data_market_activity__x
                                                   	WHERE sfa_account_id__c = :recordID];
        return acc;*/
        return [
            	SELECT activity_name__c, competitor_brand__c, affected_ul_brand__c, price__c, start_date__c, remarks__c
                                                    FROM public_data_market_activity__x
                                                   	WHERE sfa_account_id__c = :recordID
            	ORDER BY start_date__c DESC, activity_name__c ASC
            ];
    }
}