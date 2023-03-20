@isTest
private class GetGeolocationController_Test {
       
    @isTest static void PageRefTest(){
      Account acct = new Account (Name = 'TestAccount',
                                    Account_Code__c = 'AcctTest1',
                                    Bill_To_Code__c = '0231312321',
                                    Branch_Code__c= 'AcctTest1',
                                    Account_Address_1_Bldg_No_Street__c = 'Rufino Tower, 6790, Ayala Avenue',
                                    Account_Address_2_District_Brgy__c = 'Makati',
                                    Territory_Town_City_Municipality__c = 'Makati',
                                    Province__c = 'NCR - National Capital Region',
                                    District__c = 'Makati',
                                    Region__c = 'Metro Manila',
                                    Area__c = 'Metro Manila',
                                    Zip_Code__c = '1229'
                                   );
        insert acct;
        
        Test.startTest();
        Test.setCurrentPage(Page.CoordinateAPEXMap);
        
        GetGeolocationController controller = new GetGeolocationController(new ApexPages.StandardController(acct));
        controller.savePositionMethod();
        Test.stopTest();
        
        System.assertEquals(acct.Latitude__c,controller.latT);
        System.assertEquals(acct.Longitude__c,controller.longT);
    }
    
}