// Author      : John Michael B. Mahaguay
// Created     : 05.29.2017
// Description : Test class for SurveyInventoryControllerCX

@isTest
public class SurveyInventoryControllerCXTest{
    @testSetup static void setup(){
        Set<String> accIdSet = new Set<String>();
        List<Account> accList = TestDataFactory.createAccount(1);
        insert accList;
        
        for(Account acc : accList){
            accIdSet.add(acc.Id);
        }
        
        List<Activity_Junction__c> ajList = TestDataFactory.createActivityJunction(1, accIdSet);
        insert ajList;
        
        List<Survey_Summary_Form__c> ssfList = TestDataFactory.createSurveySummaryForm(1, 'Inventory Number');
        insert ssfList;
        
        List<Sub_Activity__c> saList = new List<Sub_Activity__c>();
        for(Activity_Junction__c aj : ajList){
            for(Survey_Summary_Form__c ssf : ssfList){
                List<Sub_Activity__c> saListTemp = TestDataFactory.createSubActivtiy(1, ssf.Id, aj.Id);
                saList.addAll(saListTemp);
            }
        }
        insert saList;
        
        List<Product2> prodList = TestDataFactory.createProducts(3);
        insert prodList;
        
        List<Survey_Form__c> sfList = new List<Survey_Form__c>();
        for(Survey_Summary_Form__c ssf : ssfList){
            for(Product2 p : prodList){
                Survey_Form__c sf = TestDataFactory.createSurveyForm(1, ssf.Id, p.Id, null, 'Inventory Number');
                sfList.add(sf);
            }
        }
        insert sfList;
    }
    
    //successfull
    public static testMethod void testSurveyInventoryControllerCX(){
        
        List<Survey_Summary_Form__c> ssfList = [SELECT Id , Name, Start_Date__c, End_Date__c, RecordTypeId
                                                FROM Survey_Summary_Form__c];
        
        List<Survey_Form__c> sfList = [SELECT Id, Survey_Summary_Form__c,Survey_Question__c,Product__c,RecordTypeId
                                       FROM Survey_Form__c];
        
        PageReference tpageRef = Page.SurveyInventory;
        Test.setCurrentPage(tpageRef);
        Apexpages.currentpage().getparameters().put('id' , ssfList[0].Id);
        SurveyInventoryControllerCX sic = new SurveyInventoryControllerCX();
        
        List<Survey_Form__c> updateSfList = new List<Survey_Form__c>();
        for(Survey_Form__c sf : sfList){
            sf.Backroom__c = 10;
            sf.Shelf__c = 20;
            updateSfList.add(sf);
        }
        
        Test.startTest();
        sic.getReasonList();
        sic.btnSave();  
        Test.stopTest();
        
        List<Survey_Form__c> insertedForms = [SELECT Name, Account__c, Product__c, Backroom__c, 
                                              Product__r.Name, Shelf__c,Status__c, Feedback__c
                                              FROM Survey_Form__c];
        
        System.assertEquals(true, sic.showProductList);
        System.assertEquals(false, sic.addProductItems);
        
        for (integer i = 0; i<sic.ilItemList.size();i++){
            System.assertEquals(sic.ilItemList[i].Name, insertedForms[i].Name);
            System.assertEquals(sic.ilItemList[i].Account__c, insertedForms[i].Account__c);
            System.assertEquals(sic.ilItemList[i].Backroom__c, insertedForms[i].Backroom__c);
            System.assertEquals(sic.ilItemList[i].Shelf__c, insertedForms[i].Shelf__c);
            System.assertEquals(sic.ilItemList[i].Product__r.Name, insertedForms[i].Product__r.Name);
        }
    }
    
    //SCENARIO : Throws exception returns apex error message
    @isTest static void testNegativeSurveyInventoryAvailabilityCX(){
        
        List<Survey_Summary_Form__c> ssfList = [SELECT Id , Name, Start_Date__c, End_Date__c, RecordTypeId
                                                FROM Survey_Summary_Form__c];
        
        List<Survey_Form__c> sfList = [SELECT Id, Survey_Summary_Form__c,Survey_Question__c,Product__c,RecordTypeId
                                       FROM Survey_Form__c];
        
        
        PageReference tpageRef = Page.SurveyInventoryAvailability;
        Test.setCurrentPage(tpageRef);
        
        Apexpages.currentpage().getparameters().put('id' , ssfList[0].Id);
        SurveyInventoryControllerCX sic = new SurveyInventoryControllerCX();
        
        List<Survey_Form__c> updateSfList = new List<Survey_Form__c>();
        for(Survey_Form__c sf : sfList){
            sf.Backroom__c = 20;
            sf.Shelf__c = 10;
            sf.Status__c = 'Availablesss';
            
            updateSfList.add(sf);
        }
        
        Test.startTest();
        sic.getReasonList();
        sic.ilItemList = updateSfList;         
        try{
            sic.btnSave();
        }catch(DmlException dmle){
            for(ApexPages.Message msg :  ApexPages.getMessages()){
                System.assertEquals(dmle.getMessage(),msg.getSummary()); 
                System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());       
            }
        }   
        
        Test.stopTest();
        
        
    }
}