/*-------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   04.22.2019
Definition   :   Test class for UNILAB_PAL Batch APEX
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_PAL_BatchAPEX_Test {
    
    private static final String ADMIN_USERNAME = 'ADMIN@unilabtest.com';
    private static final String KA_DEV_USERNAME = 'KA_DEV@unilabtest.com';
    private static final String GT_DEV_USERNAME = 'GT_DEV@unilabtest.com';
    private static final String MDC_DEV_USERNAME = 'MDC_DEV@unilabtest.com';
    private static final String MT_DEV_USERNAME = 'MT_DEV@unilabtest.com';
    
    @testSetup static void setup() {
        User userAdmin = UNILAB_PAL_TestDataFactory.createUserAdmin('System Administrator',ADMIN_USERNAME,'System Administrator','SALESOPS');
        User userKADev = UNILAB_PAL_TestDataFactory.createUserCMDDev('KA CMD Developer',KA_DEV_USERNAME,'KA CMD Developer','NKA');
        User userGTDev = UNILAB_PAL_TestDataFactory.createUserCMDDev('GT CMD Developer',GT_DEV_USERNAME,'GT CMD Developer','GT');
        User userMDCDev = UNILAB_PAL_TestDataFactory.createUserCMDDev('MDC CMD Developer',MDC_DEV_USERNAME,'MDC CMD Developer','MDC');
        User userMTDev = UNILAB_PAL_TestDataFactory.createUserCMDDev('MT CMD Developer',MT_DEV_USERNAME,'MT CMD Developer','MT');
        
        
    }
    
    static testmethod void testBatchInsertTempAllocRunAsGTDev(){
        String channel = 'General Trade';
        String team = 'NC Luzon Dist';
        String acctgroup = 'RKT MARKETING';
        
        UNILAB_PAL_TestDataFactory.createAccountForBatch();
        List<Account> acctList = UNILAB_PAL_TestDataFactory.getAccountsForBatch(channel);
        List<Temporary_Allocation__c> tempALlocList = UNILAB_PAL_TestDataFactory.createTempAllocForBatch(channel,team,acctgroup,acctList);

        UNILAB_PAL_TestDataFactory.createPromoAndAllocation();
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromoForBatchApexTest();
        
        Allocation__c alloc = [SELECT Id, Channel__c FROM Allocation__c 
                               WHERE Promo__c =: promoRec.Id
                               AND Channel__c =: channel LIMIT 1 ];
        alloc.Allocation_Volume__c = 100000;
        update alloc;
        
        Test.startTest();
        /*
        UNILAB_PAL_BatchInsertTempAlloc batchTempAlloc = new UNILAB_PAL_BatchInsertTempAlloc(tempALlocList,alloc.Id,alloc.Channel__c);
        Database.executeBatch(batchTempAlloc);*/
        UNILAB_PAL_Controller.invokeBatchApex(alloc.Id,tempALlocList,alloc.Channel__c);
        Test.stopTest();
    }
    
    static testmethod void testBatchInsertTempAllocRunAsKADev(){
        String channel = 'Key Accounts';
        String team = 'SOUTH STAR GROUP';
        String acctgroup = 'SOUTH STAR';
        
        UNILAB_PAL_TestDataFactory.createAccountForBatch();
        List<Account> acctList = UNILAB_PAL_TestDataFactory.getAccountsForBatch(channel);
        List<Temporary_Allocation__c> tempALlocList = UNILAB_PAL_TestDataFactory.createTempAllocForBatch(channel,team,acctgroup,acctList);

        UNILAB_PAL_TestDataFactory.createPromoAndAllocation();
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromoForBatchApexTest();
        
        Allocation__c alloc = [SELECT Id, Channel__c FROM Allocation__c 
                               WHERE Promo__c =: promoRec.Id
                               AND Channel__c =: channel LIMIT 1 ];
        alloc.Allocation_Volume__c = 100000;
        update alloc;
        
        Test.startTest();
		/*
        UNILAB_PAL_BatchInsertTempAlloc batchTempAlloc = new UNILAB_PAL_BatchInsertTempAlloc(tempALlocList,alloc.Id,alloc.Channel__c);
        Database.executeBatch(batchTempAlloc);*/
        UNILAB_PAL_Controller.invokeBatchApex(alloc.Id,tempALlocList,alloc.Channel__c);
        Test.stopTest();
    }
    
    static testmethod void testBatchInsertTempAllocRunAsMDCDev(){
        String channel = 'Mercury';
        String team = 'MDC';
        String acctgroup = 'MDC';
        
        UNILAB_PAL_TestDataFactory.createAccountForBatch();
        List<Account> acctList = UNILAB_PAL_TestDataFactory.getAccountsForBatch(channel);
        List<Temporary_Allocation__c> tempALlocList = UNILAB_PAL_TestDataFactory.createTempAllocForBatch(channel,team,acctgroup,acctList);

        UNILAB_PAL_TestDataFactory.createPromoAndAllocation();
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromoForBatchApexTest();
        
        Allocation__c alloc = [SELECT Id, Channel__c FROM Allocation__c 
                               WHERE Promo__c =: promoRec.Id
                               AND Channel__c =: channel LIMIT 1 ];
        alloc.Allocation_Volume__c = 100000;
        update alloc;
        
        Test.startTest();
        /*
        UNILAB_PAL_BatchInsertTempAlloc batchTempAlloc = new UNILAB_PAL_BatchInsertTempAlloc(tempALlocList,alloc.Id,alloc.Channel__c);
        Database.executeBatch(batchTempAlloc);*/
        UNILAB_PAL_Controller.invokeBatchApex(alloc.Id,tempALlocList,alloc.Channel__c);
        Test.stopTest();
    }
    
    static testmethod void testBatchInsertTempAllocRunAsMTDev(){
        String channel = 'Modern Trade';
        String team = 'SM Group';
        String acctgroup = 'SVI';
        
        UNILAB_PAL_TestDataFactory.createAccountForBatch();
        List<Account> acctList = UNILAB_PAL_TestDataFactory.getAccountsForBatch(channel);
        List<Temporary_Allocation__c> tempALlocList = UNILAB_PAL_TestDataFactory.createTempAllocForBatch(channel,team,acctgroup,acctList);

        UNILAB_PAL_TestDataFactory.createPromoAndAllocation();
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromoForBatchApexTest();
        
        Allocation__c alloc = [SELECT Id, Channel__c FROM Allocation__c 
                               WHERE Promo__c =: promoRec.Id
                               AND Channel__c =: channel LIMIT 1 ];
        alloc.Allocation_Volume__c = 100000;
        update alloc;
        
        Test.startTest();
        /*
        UNILAB_PAL_BatchInsertTempAlloc batchTempAlloc = new UNILAB_PAL_BatchInsertTempAlloc(tempALlocList,alloc.Id,alloc.Channel__c);
        Database.executeBatch(batchTempAlloc);*/
        UNILAB_PAL_Controller.invokeBatchApex(alloc.Id,tempALlocList,alloc.Channel__c);
        Test.stopTest();
    }
    
    static testmethod void testBatchInsertNullTempAlloc() {
        List<Temporary_Allocation__c> tempALlocList = new List <Temporary_Allocation__c>();
        
        UNILAB_PAL_TestDataFactory.createPromo();
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromoForBatchApexTest();
        
        Allocation__c alloc = new Allocation__c();
        alloc.Allocation_Volume__c = 100000;
        alloc.Promo__c = promoRec.Id;
        alloc.Status__c = 'Draft';
        alloc.Channel__c = 'Key Accounts';
        alloc.Start_Date__c = Date.today();
        alloc.End_Date__c = Date.today()+30;
        
        insert alloc;
        
        Test.startTest();
        
        User userAdmin = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:ADMIN_USERNAME];
        User KA_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:KA_DEV_USERNAME];
        User GT_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:GT_DEV_USERNAME];
        User MDC_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:MDC_DEV_USERNAME];
        User MT_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:MT_DEV_USERNAME];
        System.runAs(userAdmin){
            UNILAB_PAL_BatchInsertTempAlloc batchTempAlloc = new UNILAB_PAL_BatchInsertTempAlloc(tempALlocList,alloc.Id,alloc.Channel__c);
            Database.executeBatch(batchTempAlloc);
        }
        System.runAs(KA_DEV){
            UNILAB_PAL_BatchInsertTempAlloc batchTempAlloc = new UNILAB_PAL_BatchInsertTempAlloc(tempALlocList,alloc.Id,alloc.Channel__c);
            Database.executeBatch(batchTempAlloc);
        }
        System.runAs(GT_DEV){
            UNILAB_PAL_BatchInsertTempAlloc batchTempAlloc = new UNILAB_PAL_BatchInsertTempAlloc(tempALlocList,alloc.Id,alloc.Channel__c);
            Database.executeBatch(batchTempAlloc);
        }
        System.runAs(MDC_DEV){
            UNILAB_PAL_BatchInsertTempAlloc batchTempAlloc = new UNILAB_PAL_BatchInsertTempAlloc(tempALlocList,alloc.Id,alloc.Channel__c);
            Database.executeBatch(batchTempAlloc);
        }
        System.runAs(MT_DEV){
            UNILAB_PAL_BatchInsertTempAlloc batchTempAlloc = new UNILAB_PAL_BatchInsertTempAlloc(tempALlocList,alloc.Id,alloc.Channel__c);
            Database.executeBatch(batchTempAlloc);
        }
        
        Test.stopTest();
    }
    
    static testmethod void testSendUpdateEmailServerDown() {
        UNILAB_PAL_TestDataFactory.createPromo();
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromoForBatchApexTest();
        
        Allocation__c alloc = new Allocation__c();
        alloc.Allocation_Volume__c = 100000;
        alloc.Promo__c = promoRec.Id;
        alloc.Status__c = 'Draft';
        alloc.Channel__c = 'Key Accounts';
        alloc.Start_Date__c = Date.today();
        alloc.End_Date__c = Date.today()+30;
        
        insert alloc;
        
        Test.startTest();
        User userAdmin = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:ADMIN_USERNAME];
        User KA_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:KA_DEV_USERNAME];
        User GT_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:GT_DEV_USERNAME];
        User MDC_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:MDC_DEV_USERNAME];
        User MT_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:MT_DEV_USERNAME];
        
        System.runAs(userAdmin){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, true, false, false);
        }
        System.runAs(KA_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, true, false, false);
        }
        System.runAs(GT_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, true, false, false);
        }
        System.runAs(MDC_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, true, false, false);
        }
        System.runAs(MT_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, true, false, false);
        }
        Test.stopTest();
    }
    
    static testmethod void testSendUpdateEmailNullCallOutValue() {
        UNILAB_PAL_TestDataFactory.createPromo();
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromoForBatchApexTest();
        
        Allocation__c alloc = new Allocation__c();
        alloc.Allocation_Volume__c = 100000;
        alloc.Promo__c = promoRec.Id;
        alloc.Status__c = 'Draft';
        alloc.Channel__c = 'Key Accounts';
        alloc.Start_Date__c = Date.today();
        alloc.End_Date__c = Date.today()+30;
        
        insert alloc;
        
        Test.startTest();
        User userAdmin = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:ADMIN_USERNAME];
        User KA_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:KA_DEV_USERNAME];
        User GT_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:GT_DEV_USERNAME];
        User MDC_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:MDC_DEV_USERNAME];
        User MT_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:MT_DEV_USERNAME];
        
        System.runAs(userAdmin){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, false, true, false);
        }
        System.runAs(KA_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, false, true, false);
        }
        System.runAs(GT_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, false, true, false);
        }
        System.runAs(MDC_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, false, true, false);
        }
        System.runAs(MT_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, false, true, false);
        }
        Test.stopTest();
    }
    
    static testmethod void testSendUpdateEmailHasOngoingApexJobs() {
        UNILAB_PAL_TestDataFactory.createPromo();
        Promo__c promoRec = UNILAB_PAL_TestDataFactory.getPromoForBatchApexTest();
        
        Allocation__c alloc = new Allocation__c();
        alloc.Allocation_Volume__c = 100000;
        alloc.Promo__c = promoRec.Id;
        alloc.Status__c = 'Draft';
        alloc.Channel__c = 'Key Accounts';
        alloc.Start_Date__c = Date.today();
        alloc.End_Date__c = Date.today()+30;
        
        insert alloc;
        
        Test.startTest();
        User userAdmin = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:ADMIN_USERNAME];
        User KA_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:KA_DEV_USERNAME];
        User GT_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:GT_DEV_USERNAME];
        User MDC_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:MDC_DEV_USERNAME];
        User MT_DEV = [SELECT Id, Name, UserRoleId,Channel__c FROM User WHERE Username =:MT_DEV_USERNAME];
        
        System.runAs(userAdmin){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, false, false, true);
        }
        System.runAs(KA_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, false, false, true);
        }
        System.runAs(GT_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, false, false, true);
        }
        System.runAs(MDC_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, false, false, true);
        }
        System.runAs(MT_DEV){
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(alloc, false, false, true);
        }
        Test.stopTest();
    }
}