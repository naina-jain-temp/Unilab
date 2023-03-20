@IsTest
public class RecordTypesOfRFCMTest {
     @IsTest
    static void getAllRecordTypes(){
        createTestSetup();     
    }
    private static void createTestSetup(){
   
        Id recordType =Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Senior & Disc').getRecordTypeId();
        RecordTypesOfRFCM.getAllRecordTypes();
        RecordTypesOfRFCM.getFieldDependency('Richa');
        RecordTypesOfRFCM.getRecordTypeName(recordType);
        RecordTypesOfRFCM.isCommunity();
    }
    

}