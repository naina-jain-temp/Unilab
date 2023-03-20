@isTest
private class PerDiemCSVController_Test {
    @isTest
    private static void exportCSV() {
        Per_Diem__c perdiem = new Per_Diem__c();
        
        perdiem = new Per_Diem__c(Approval_Status__c = 'New',
                            RecordTypeId = Schema.SObjectType.Per_Diem__c.getRecordTypeInfosByName().get('Per Diem').getRecordTypeId());
        
        insert perdiem;
        
        Per_Diem_Item__c perdiemItem = new Per_Diem_Item__c(
                    Exemption_Remarks__c = 'Test',
                    HB_OHB__c = 'Home Base',
                    Place_of_Work__c = '',
                    CreatedById = perdiem.CreatedById,
                    Number_of_Days__c = 1,
                    RecordTypeId = Schema.SObjectType.Per_Diem_Item__c.getRecordTypeInfosByName().get('Per Diem').getRecordTypeId(),
                    Sub_Activity_Report__c = perdiem.Id);

        insert perdiemItem;
        
        Test.startTest();
        
        List<Per_Diem_Item__c> exportResult = PerDiemCSVController.fetch(perdiem.Id);
        
        Test.stopTest();
        
        System.assert(exportResult.size() > 0);
    }
}