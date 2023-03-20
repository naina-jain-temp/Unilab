@isTest
public class UNILAB_PAL_Postpone_Controller_Test {

    @testSetup static void setup(){
        
        UNILAB_PAL_TestDataFactory.createAccPostpone();
        
    }
    
    //POSITIVE
    @isTest static void getAllocInformationPositive(){
        
        List<Allocation__c> newAlloc = [SELECT Id FROM Allocation__c LIMIT 1];
        
        Test.startTest();
        
        try{
            UNILAB_PAL_Postpone_Controller.getAllocInformation(newAlloc[0].Id);
            
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
        Test.stopTest();
    }
    
    
    //NEGATIVE
    @isTest static void getAllocInformationNegative(){
        
        Test.startTest();
        
        try{
            UNILAB_PAL_Postpone_Controller.getAllocInformation(null);
        }catch(Exception e){
            System.assert(e.getMessage().contains('Invalid id'));
        }
        
        Test.stopTest();
    }
    
    //POSITIVE
    @isTest static void updateAllocInformationPositive(){
        
        List<Allocation__c> newAlloc = [SELECT Id FROM Allocation__c LIMIT 1];
        
        Allocation__c dummyAlloc = new Allocation__c(Start_Date__c = Date.today(),
                                            		 End_Date__c = Date.today()+30);
        
		String valid;
        
        Test.startTest();
        
        try{
            UNILAB_PAL_Postpone_Controller.updateAllocInformation(newAlloc[0].Id, dummyAlloc);
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
        Test.stopTest();
    }
    
    //NEGATIVE
    @isTest static void updateAllocInformationNegative(){
        
        UNILAB_PAL_TestDataFactory.createAccPostponeNegative();
        
        List<Allocation__c> newAlloc = [SELECT Id FROM Allocation__c WHERE Status__c = 'Draft' LIMIT 1];
        
        Allocation__c dummyAlloc = new Allocation__c(Start_Date__c = Date.today(),
                                            		 End_Date__c = Date.today()+30);
        
		String valid;
        
        Test.startTest();
        
        try{
            UNILAB_PAL_Postpone_Controller.updateAllocInformation(newAlloc[0].Id, dummyAlloc);
            
        }catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
        Test.stopTest();
    }
    
}