@isTest
private class Unilab_CloseAccount_Test {
    
    @testSetup static void setup() {
        
        List<Account> listOfAcct = TestDataFactory.createAccount(10);
        
        insert listOfAcct;
        
    }
    
    
    @isTest static void updateAcctRec() {
        
        Integer count = [SELECT COUNT() 
                         FROM Account
                        ];
        
        Integer rand = Math.floor(Math.random() * count).intValue();
        
        Account selectedAcct =  [SELECT Id
                                 FROM Account 
                                 LIMIT 1 
                                 OFFSET :rand
                                ];
        
        Account savedAcct = [SELECT Account_Status__c,
                             		Account_Sub_Status__c,
                             		Account_Closure_Date__c
                             FROM Account
                             WHERE Id = :selectedAcct.Id
                            ];
        
        savedAcct.Account_Closure_Date__c = Date.today();
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(savedAcct);        
        Unilab_CloseAccount closeAcct = new Unilab_CloseAccount(stdCon);
        
        Test.startTest();
        
        PageReference expectedPageReference = closeAcct.saveRecord();
        
        Test.stopTest();
        
        PageReference actualPageReference = new PageReference('/' + selectedAcct.Id);
        
        Account updatedAcct = [SELECT Account_Status__c,
                               		  Account_Sub_Status__c,
                               		  Account_Closure_Date__c
                               FROM Account
                               WHERE Id = :selectedAcct.Id
                              ];
        
        System.assert(updatedAcct != null);
        System.assert(updatedAcct.Account_Status__c == 'Closed');
        System.assert(updatedAcct.Account_Sub_Status__c == 'Closed');
        System.assertEquals(expectedPageReference.getUrl(), actualPageReference.getUrl());
        
    }

}