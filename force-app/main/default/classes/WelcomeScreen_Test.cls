@isTest
private class WelcomeScreen_Test {
    
    @testSetup static void setup() {
        
        insert TestDataFactory.createUserAdmin();
        
    }
    
    @isTest static void userRecords() {
        
        User newUser = [SELECT Id
                        FROM User
                        LIMIT 1
                       ];
        
        System.runAs(newUser) {
            
            User getRecord = [SELECT Name,
                              		 FullPhotoUrl
                              FROM User
                              WHERE (Id = :UserInfo.getUserId())
                             ];
            
            Test.startTest();
            
            User selectRecord = WelcomeScreen.getUserRecord();
            
            Test.stopTest();
            
            System.assert(selectRecord != NULL);
            System.assertEquals(getRecord.Name, selectRecord.Name);
            System.assertEquals(getRecord.FullPhotoUrl, selectRecord.FullPhotoUrl);
            
        }
        
    }
    
}