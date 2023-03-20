public class UNILAB_PAL_Postpone_Controller {

    @AuraEnabled
    public static List < Allocation__c > getAllocInformation(Id recId) {
        
        List < Allocation__c > allocInfo = new List<Allocation__c>();
        
        try {
            
            allocInfo = [SELECT Id, Start_Date__c, End_Date__c FROM Allocation__c WHERE Id =: recId];
            
        }catch (Exception e) {
            throw new AuraHandledException('Error in fetching Base Product: ' + e.getMessage());  
        }
        
        return allocInfo;
        
    }
    
    @AuraEnabled
    public static String updateAllocInformation(Id recId, Allocation__c allocation) {
        
        String valid;
        
        Allocation__c getAlloc = new Allocation__c();
        
        try {
            
            getAlloc = [SELECT Id, Start_Date__c, End_Date__c, Status__c FROM Allocation__c WHERE Id =: recId];
            
            if(getAlloc.Status__c == 'Finalized'){
                getAlloc.Start_Date__c = allocation.Start_Date__c;
            	getAlloc.End_Date__c = allocation.End_Date__c;
                valid = 'Success';
            }else{
                valid = 'Failed';
            }

            update getAlloc;
            
        }catch (Exception e) {
            throw new AuraHandledException('Error in fetching Base Product: ' + e.getMessage());  
        }
        
        return valid;
        
    }
    
}