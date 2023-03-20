@isTest
private class UNILAB_MarketActivity_Report_Test {
	@isTest static void fetch() {
        
        //String acctId='0017F000006PUiQQAW';
        String acctId='0019D00000836HiQAI';
        Test.startTest();
        	
        		List<public_data_market_activity__x> acc = UNILAB_MarketActivity_Report.fetch(acctId);
            
        Test.stopTest();
        System.assert(acctId!=null);
    }
}