/*-------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   04.23.2019
Definition   :   Batch Apex for deleting Temporary Allocation Records
-------------------------------------------------------------------------------------------*/
global with sharing class UNILAB_PAL_BatchDeleteTempAlloc implements Database.Batchable<sObject> {
    
    private String allocChannel;
    public UNILAB_PAL_BatchDeleteTempAlloc(String allocationChannel) {
        allocChannel = allocationChannel;
    }
    
    global Database.QueryLocator start(Database.BatchableContext batchTempAllocForDeletion) {
        String query = 'SELECT Id, Channel__c FROM Temporary_Allocation__c WHERE Channel__c =:allocChannel';
        return Database.getQueryLocator(query);
	}
    global void execute(Database.BatchableContext batchTempAllocForDeletion, List<Temporary_Allocation__c> scope) {
        //DELETE TEMPORARY ALLOCATIONS
        delete scope;
    }
    global void finish(Database.BatchableContext batchTempAllocForDeletion) {
        
    }
}