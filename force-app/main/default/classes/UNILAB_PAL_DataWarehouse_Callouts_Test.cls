/*----------------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   06.14.2019
Definition   :   Test Class for UNILAB_PAL Data Warehouse Callout
-----------------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_PAL_DataWarehouse_Callouts_Test {
  
    
        @isTest static void testGetAPIResponsePositive(){
        
           // String accessToken = UNILAB_PAL_Authentication.getToken(); // 98d1e60cbfaed66b926858046cdc1383
            String allocId = 'a0O0w0000004uzeEAA';
            //System.debug('accessToken '+accessToken);//'f951bf853836a745f6b6f17191f7080b'
            List<Temporary_Allocation__c> lisOfTempAlloc = new List<Temporary_Allocation__c>();
            
            Test.startTest();
                Test.setMock(HttpCalloutMock.class, new UNILAB_PAL_DataWarehouse_Callouts_Mock(true));
                lisOfTempAlloc = UNILAB_PAL_DataWarehouse_Callouts.getAPIResponse('f951bf853836a745f6b6f17191f7080b', '{"period":"201812","measureType":["SELLIN"],"measureLevel":"P3","itemCode":["151917"],"endingInventoryValue":"","endingInventoryOperator":"","accounts":["0010w000005VWKgAAO"]}', allocId);
            Test.stopTest();
            
            
        }
        

         @isTest static void testGetAPIResponseNegative(){
        
           // String accessToken = UNILAB_PAL_Authentication.getToken(); // 61887a06509d4dfe421166e6bc263e95
            String allocId = 'a0O0w0000004uzeEAA';
            //System.debug('accessToken '+accessToken);//'f951bf853836a745f6b6f17191f7080b'

            //Creating new List for Temporary_Allocation__c Custom Object
            List<Temporary_Allocation__c> lisOfTempAlloc = new List<Temporary_Allocation__c>();
            
            Test.startTest();
             
                Test.setMock(HttpCalloutMock.class, new UNILAB_PAL_DataWarehouse_Callouts_Mock(false));
             
                lisOfTempAlloc = UNILAB_PAL_DataWarehouse_Callouts.getAPIResponse('f951bf853836a745f6b6f17191f7080b', '{"period":"201812","measureType":["SELLIN"],"measureLevel":"P3","itemCode":["151917"],"endingInventoryValue":"","endingInventoryOperator":"","accounts":["0010w000005VWKgAAO"]}', allocId);
            Test.stopTest();
            
            
        }   

    
}