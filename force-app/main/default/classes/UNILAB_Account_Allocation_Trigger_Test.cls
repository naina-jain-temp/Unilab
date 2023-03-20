/*-------------------------------------------------------------------------------------------
Author       :   Zeus Lopez-Dee
Created Date :   06.11.2019
Definition   :   Test class for UNILAB_Account_Allocation_Trigger
-------------------------------------------------------------------------------------------*/
@isTest
private	 class UNILAB_Account_Allocation_Trigger_Test {
    private static final String ADMIN_USERNAME = 'ADMIN@unilabtest.com';
    private static final String DEV_USERNAME = 'DEV@unilabtest.com';
    
    @testSetup static void setup(){
        User userAdmin = UNILAB_PAL_TestDataFactory.createUserAdmin('System Administrator',ADMIN_USERNAME,'System Administrator','SALESOPS');
        User newUser = UNILAB_PAL_TestDataFactory.createUserCMDDev('MDC CMD Developer',DEV_USERNAME,'MDC CMD Developer', 'Key Accounts');
    }
    
    @isTest static void doBeforeDeletePositive() { 
        
        User userAdmin = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:ADMIN_USERNAME];
         
        System.runAs(userAdmin){
            
            UNILAB_PAL_TestDataFactory.createAccounts();
            List<Account> accList = UNILAB_PAL_TestDataFactory.getAccounts();
            
            test.startTest();
            	UNILAB_PAL_TestDataFactory.createAccAllocTrigger(accList);
            List<Allocation__c> allocList = [SELECT Id, Name, Status__c  FROM Allocation__c WHERE Status__c = 'Finalized'];
            List<Account_Allocation__c> accAllocList = UNILAB_PAL_TestDataFactory.getAccountAllocs(allocList);
            
            try{
                Delete accAllocList;
            }
            catch(Exception e){
                 System.assert(e.getMessage().contains('Cannot delete account allocation that has a finalized allocation.'));
            }
            test.stopTest();
            
        }
        
    }  
    
    @isTest static void doBeforeDeleteNotSysAdmin() { 
        UNILAB_PAL_TestDataFactory.createMDCCMDDevUser();
        User MDC_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Channel__c = 'MDC'
                        LIMIT 1];
        
        System.runAs(MDC_DEV){
            UNILAB_PAL_TestDataFactory.createAccounts();
            List<Account> accList = UNILAB_PAL_TestDataFactory.getAccounts();
            
            test.startTest();
            	UNILAB_PAL_TestDataFactory.createMDCAccAllocTrigger(accList);
            List<Allocation__c> allocList = [SELECT Id, Name, Status__c  FROM Allocation__c WHERE Status__c = 'Finalized' AND Channel__c = 'Mercury'];
            List<Account_Allocation__c> accAllocList = UNILAB_PAL_TestDataFactory.getAccountAllocs(allocList);
            
            try{
                Delete accAllocList;
            }
            catch(Exception e){
                 System.assert(e.getMessage().contains('Cannot delete account allocation that has a finalized allocation.'));
            }
            test.stopTest();
        }

    } 
        
}