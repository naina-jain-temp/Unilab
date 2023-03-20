/*----------------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   05.06.2019
Definition   :   Controller Class for PDF Generator Visualforce Page
-----------------------------------------------------------------------------------------------------*/
public class UNILAB_PAL_PDFGenerator_Controller {
    
    public List<accAllocListWrapper> accAllocWrapList {get;set;}
    public List<Account_Allocation__c> accAllocList;
    
    public class accAllocListWrapper{
        public Account_Allocation__c accAllocRecord{get;set;}
        public accAllocListWrapper(Account_Allocation__c accAlloc){
            accAllocRecord = accAlloc;
        }
    }
    
    public UNILAB_PAL_PDFGenerator_Controller(ApexPages.StandardController controller){
        
        	
		String recordId = ApexPages.currentPage().getParameters().get('recordId');     
        
        accAllocList = [SELECT Account__r.Channel__c,Account__r.Team__c,Account__r.Account_Group__c,
                        Account__r.Name, Allocation__r.Total_Account_Allocation__c, Final_Allocation__c,
                        Allocation__r.Start_Date__c, Allocation__r.End_Date__c,Account__r.Owner.Name, Allocation__r.Promo_Name__c 
                        FROM Account_Allocation__c 
                        WHERE Allocation__c =: recordId
                        ORDER BY Account__r.Channel__c,Account__r.Team__c,Account__r.Account_Group__c,
                        Account__r.Name];
        
        if(accAllocList !=null && !accAllocList.isEmpty()){
            accAllocWrapList = new List<accAllocListWrapper>();
            for(Account_Allocation__c accAlloc : accAllocList){
                accAllocWrapList.add(new accAllocListWrapper(accAlloc));
            }
        }else{
            accAllocWrapList = null;
        }
    }
}