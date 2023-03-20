// Author: John Michael B. Mahaguay
// Company: Third Pillar
// Date Created: 05.29.2017

public with sharing class SurveyInventoryControllerCX {
    
    public Sub_Activity__c iDetails{get;set;}
    public List<Survey_Form__c> ilItemList{get;set;}
    public Boolean showProductList{get;set;}
    public Boolean addProductItems{get;set;}
    public Boolean renderTable{get;set;}
    private String SurveySummaryFormId='';
   
    public SurveyInventoryControllerCX(){
        system.Debug('***paramIdclass: '+ApexPages.currentPage().getParameters().get('id'));
        getInventoryLineItems();
        showProductList = true;
        renderTable = false;
        addProductItems = false;
    }
    
    public void getInventoryLineItems(){
        ilItemList = new List<Survey_Form__c>();
        iDetails = new Sub_Activity__c();
        iDetails = [SELECT Id, Account_ID__c, Survey_Summary_Form__c, Survey_Summary_Form__r.Name,Survey_Summary_Form__r.Account__c, Survey_Summary_Form__r.Survey_Summary_Form_Name__c,Related_ContactId__c  FROM Sub_Activity__c WHERE Survey_Summary_Form__c =: ApexPages.currentPage().getParameters().get('id') LIMIT 1];
        ilItemList = [SELECT Id, Name, Account__c, Product__c, Backroom__c, Product__r.Name, Shelf__c, N_A__c, Reason_for_Exemption__c FROM Survey_Form__c WHERE Survey_Summary_Form__c =: ApexPages.currentPage().getParameters().get('id') AND RecordType.Name='Inventory Number'];
    }
    
    public List<SelectOption> getReasonList() {
        List<SelectOption> reasonOptionList = new List<SelectOption>();
           
        reasonOptionList.add(new SelectOption('N/A', 'N/A'));  
        reasonOptionList.add(new SelectOption('A', 'A'));  
        reasonOptionList.add(new SelectOption('B', 'B'));
        reasonOptionList.add(new SelectOption('C', 'C'));
               
        return reasonOptionList;
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