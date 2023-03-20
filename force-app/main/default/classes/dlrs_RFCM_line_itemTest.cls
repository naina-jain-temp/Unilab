/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_RFCM_line_itemTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_RFCM_line_itemTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new RFCM_line_item__c());
    }
}