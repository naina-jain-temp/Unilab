@isTest
public class UNILAB_PAL_PalConfigTrigger_Test {
    @testSetup static void setup(){
        PAL_Configuration__c palRecord = new PAL_Configuration__c(PAL_Configuration_Name__c = 'GT CMD Developer',
                                                                  CONF_Channel__c  = 'General Trade',
                                                                  Ending_Inventory_Data_Type__c = 'Months Supply',
                                                                  Ending_Inventory_Operator__c = 'greater than',
                                                                  Ending_Inventory_Value__c = 75.0
                                                                  );
        
        insert palRecord;
        
        
    }
    @isTest static void createPALConfig_doBeforeUpdateTest(){
        PAL_Configuration__c palRecord = [SELECT Id, Ending_Inventory_Data_Type__c FROM PAL_Configuration__c LIMIT 1];
        
        palRecord.Ending_Inventory_Data_Type__c = null;
        
        test.startTest();
        update palRecord;
        test.stopTest();
    }

}