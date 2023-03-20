/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   06.21.2017
Definition   :   Controller for Survey Inventory Status page
History      :   06.21.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
public class SurveyInventoryStatusCX {
    public Sub_Activity__c iDetails{get;set;}
    public List<Survey_Form__c> ilItemList{get;set;}
    public Boolean showProductList{get;set;}
    public Boolean addProductItems{get;set;}
    public Boolean renderTable{get;set;}
    private String SurveySummaryFormId='';
    public String selectedStatus {get;set;}
    public SurveyInventoryStatusCX(){
        system.Debug('***paramIdclass: '+ApexPages.currentPage().getParameters().get('id'));
        getInventoryLineItems();
        showProductList = true;
        renderTable = false;
        addProductItems = false;
        selectedStatus = 'Out of Stock';
    }
    
    public void getInventoryLineItems(){
        ilItemList = new List<Survey_Form__c>();
        iDetails = new Sub_Activity__c();
        iDetails = [SELECT Id, Account_ID__c, Survey_Summary_Form__c, Survey_Summary_Form__r.Name,Survey_Summary_Form__r.Account__c, Survey_Summary_Form__r.Survey_Summary_Form_Name__c, Related_ContactId__c FROM Sub_Activity__c WHERE Survey_Summary_Form__c =: ApexPages.currentPage().getParameters().get('id') LIMIT 1];
        ilItemList = [SELECT Id, Name, Account__c, Product__c, Backroom__c, Product__r.Name, Shelf__c,Status__c, Feedback__c FROM Survey_Form__c WHERE Survey_Summary_Form__c =: ApexPages.currentPage().getParameters().get('id') AND RecordType.Name='Inventory Status'];
    }
    
    public List<SelectOption> getStatusList() {
        List<SelectOption> statusOptionList = new List<SelectOption>();
        
        for(RecordType rt : [SELECT Id, Name FROM RecordType WHERE sobjectType = 'Survey_Form__c' and Name = 'Inventory Status']) {
        
            statusOptionList.add(new SelectOption('Out of Stock', 'Out of Stock'));             
            statusOptionList.add(new SelectOption('Not Carried', 'Not Carried')); 
            statusOptionList.add(new SelectOption('With Stock', 'With Stock')); 
        
        }
        
        return statusOptionList;
    }
    
    public PageReference btnSave(){
         if(!ilItemList.isEmpty()) {
             try{
                 update ilItemList;
                 showProductList = true;
                 addProductItems = false;
             }catch(Exception ex){
                 system.Debug(ex.getMessage());
                 ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0) );
                 ApexPages.addMessage(msg);
                 return null;
             }
             
         }
        //sforce.one.navigateToSObject('/{!PR_PO_ID}');
        PageReference Page = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        return Page;
    }
}