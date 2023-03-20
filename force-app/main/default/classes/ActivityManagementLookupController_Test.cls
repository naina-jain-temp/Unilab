@isTest
private class ActivityManagementLookupController_Test {
    //User Username
    private static final String POS_GT_TL ='POSGTTL@unilabtest.com';
    private static final String POS_GT_CDS ='POSGTCDS@unilabtest.com';
    private static final String POS_GT_CHANNEL_HEAD = 'POSGTCH@unilabtest.com';
    @isTest static void testFetchLookupValues(){
        //Create GT Channel Head Account 
        User userPOSGT_CH = TestTCRDataFactory.createUserChannelHead('POS-GT Channel Head',POS_GT_CHANNEL_HEAD,'POS Channel Head/Head Office');
        //Create POS-GT Team Lead Account
        User userPOSGT_TL = TestTCRDataFactory.createUserTL('POS-GT Team Lead (Mindanao)',POS_GT_TL,userPOSGT_CH.Id,'GT Team Lead'); 
        //Create POS-GT CDS Account 
        User userPOSGT_CDS = TestTCRDataFactory.createUserCDS(userPOSGT_TL.Id,'POS-GT CDS (Mindanao)',POS_GT_CDS,'GT CDS');
        //Lookup Results Storage
        List < sObject > lookupResults = new List<sObject>();
        Test.startTest();
        System.runAs(userPOSGT_TL){
            lookupResults = ActivityManagementLookupController.fetchLookUpValues('First', 'User');
        }
        System.assert(lookupResults.size()>0,'Invalid Lookup Results');
        Test.stopTest();
    }
    
}