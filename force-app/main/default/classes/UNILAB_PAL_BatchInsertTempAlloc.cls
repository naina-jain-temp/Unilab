/*-------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   04.23.2019
Definition   :   Batch Apex for inserting Temporary Allocation Records from Callout Response
-------------------------------------------------------------------------------------------*/
global with sharing class UNILAB_PAL_BatchInsertTempAlloc implements Database.Batchable<sObject>, Database.AllowsCallouts{
    //BATCH TEMPORARY ALLOCATION FROM RESPONSE -- Inserting Temp Alloc
    
    private List<Temporary_Allocation__c> listOfTempAllocFromResp;
    private String allocId;
	private String allocChannel;
    
    public UNILAB_PAL_BatchInsertTempAlloc(List<Temporary_Allocation__c> tempAllocs, String allocationId, String allocationChannel) {
        listOfTempAllocFromResp = tempAllocs;
        allocId = allocationId;
        allocChannel = allocationChannel;
    }
    global Iterable<sObject> start(Database.BatchableContext BC) {
        List<Temporary_Allocation__c> listTempAlloc = listOfTempAllocFromResp;
        return listTempAlloc;
    }
    
    global void execute(Database.BatchableContext BC, List<Temporary_Allocation__c> scope) {
        //INSERT TEMPORARY ALLOCATIONS 
        insert scope;
    }
    
    global void finish(Database.BatchableContext BC) {
        List<Account_Allocation__c> listOfAccAlloc = UNILAB_PAL_ProcessTempAllocForConversion.processAccountAllocations(allocId,allocChannel);
     
        UNILAB_PAL_BatchInsertAccAlloc be = new UNILAB_PAL_BatchInsertAccAlloc(allocId,allocChannel,listOfAccAlloc);
        database.executeBatch(be);
    }
}