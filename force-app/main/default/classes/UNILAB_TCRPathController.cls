public class UNILAB_TCRPathController {
    
    @AuraEnabled
    public static List<ChevronData> getChevronData(String recId){ 
        
        Training_Contact_Report__c tcr = [SELECT Id,Status__c FROM Training_Contact_Report__c WHERE Id =: recId];
        String selVal = tcr.Status__c;  
        List<String> ple = UNILAB_Utility.getPicklistFieldValues('Training_Contact_Report__c','Status__c');     
        Boolean curValMatched = false;
        Integer widthPerItem = 100/ple.size() ;
        List<ChevronData> lstRet = new List<ChevronData>();        
        for( String f : ple)
        {
            ChevronData obj = new ChevronData();
            obj.val = f;
            obj.width = widthPerItem+'%';            
            if(obj.val == selVal && obj.val != 'Approved'){
                obj.cssClass = 'active';
                curValMatched = true;
            }
            
            else if(curValMatched){
                obj.cssClass = '';
            }else{
                obj.cssClass = 'visited'; 
            } 
            lstRet.add(obj);
        } 
        return lstRet;
        
    }    
    public class ChevronData{
        @AuraEnabled public String val{get;set;}
        @AuraEnabled public String cssClass{get;set;}
        @AuraEnabled public String width {get;set;}
    }
    
}