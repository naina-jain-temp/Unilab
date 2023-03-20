@isTest
private class SurveyInventoryAvailabilityCXTest{
    
    //DATA FACTORY INITIALIZATION
    @testSetup static void setup(){
        //Account creation
        Set<String> accIdSet = new Set<String>();
        List<Account> accList = TestDataFactory.createAccount(1);
        insert accList;
        
        for(Account acc : accList){
            accIdSet.add(acc.Id);
        }
        
        // Activity Junction creation
        List<Activity_Junction__c> ajList = TestDataFactory.createActivityJunction(1, accIdSet);
        insert ajList;
        
        // Survey Summary form creation
        List<Survey_Summary_Form__c> ssfList = TestDataFactory.createSurveySummaryForm(1, 'Inventory Availability');
        insert ssfList;
        
        // SubActivity creation
        List<Sub_Activity__c> saList = new List<Sub_Activity__c>();
        for(Activity_Junction__c aj : ajList){
            for(Survey_Summary_Form__c ssf : ssfList){
                List<Sub_Activity__c> saListTemp = TestDataFactory.createSubActivtiy(1, ssf.Id, aj.Id);
                saList.addAll(saListTemp);
            }
        }
        insert saList;
        
        // product creation
        List<Product2> prodList = TestDataFactory.createProducts(3);
        insert prodList;
        
        //survey form creation
        List<Survey_Form__c> sfList = new List<Survey_Form__c>();
        for(Survey_Summary_Form__c ssf : ssfList){
            for(Product2 p : prodList){
                Survey_Form__c sf = TestDataFactory.createSurveyForm(1, ssf.Id, p.Id, null, 'Inventory Availability');
                sfList.add(sf);
            }
        }
        insert sfList;
    }

    //SCENARIO : Successfully updated Survey Form
    @isTest static void testSurveyInventoryAvailabilityCX(){
        List<Survey_Summary_Form__c> ssfList = [SELECT Id , Name, Start_Date__c, End_Date__c, RecordTypeId
                                                FROM Survey_Summary_Form__c];
        
        List<Survey_Form__c> sfList = [SELECT Id, Survey_Summary_Form__c,Survey_Question__c,Product__c,RecordTypeId
                                       FROM Survey_Form__c];
        
        
        PageReference tpageRef = Page.SurveyInventoryAvailability;
        Test.setCurrentPage(tpageRef);
        
        Apexpages.currentpage().getparameters().put('id' , ssfList[0].Id);
     //   system.Debug('***paramId: '+ApexPages.currentPage().getParameters().get('id'));
     //   system.Debug('***sf: '+sfList);
        
        SurveyInventoryAvailabilityCX sia = new SurveyInventoryAvailabilityCX();  
        
        
        List<Survey_Form__c> updateSfList = new List<Survey_Form__c>();
        for(Survey_Form__c sf : sfList){
            sf.Status__c = 'Available';
            sf.Feedback__c = 'Ok';
            updateSfList.add(sf);
        }
        
        
        Test.startTest();
        sia.getStatusList();
        sia.btnSave();
        Test.stopTest();
        
        List<Survey_Form__c> insertedForms = [SELECT Name, Account__c, Product__c, Backroom__c, 
                                              Product__r.Name, Shelf__c,Status__c, Feedback__c
                                              FROM Survey_Form__c];
        
        System.assertEquals(true, sia.showProductList);
        System.assertEquals(false, sia.addProductItems);
        
        for (integer i = 0; i<sia.ilItemList.size();i++){
            System.assertEquals(sia.ilItemList[i].Name, insertedForms[i].Name);
            System.assertEquals(sia.ilItemList[i].Account__c, insertedForms[i].Account__c);
            System.assertEquals(sia.ilItemList[i].Backroom__c, insertedForms[i].Backroom__c);
            System.assertEquals(sia.ilItemList[i].Product__r.Name, insertedForms[i].Product__r.Name);
            System.assertEquals(sia.ilItemList[i].Status__c, insertedForms[i].Status__c);
            System.assertEquals(sia.ilItemList[i].Feedback__c, insertedForms[i].Feedback__c);
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
        system.Debug('***paramId: '+ApexPages.currentPage().getParameters().get('id'));
        system.Debug('***sf: '+sfList);
        
        SurveyInventoryAvailabilityCX sia = new SurveyInventoryAvailabilityCX();  
        
        
        List<Survey_Form__c> updateSfList = new List<Survey_Form__c>();
        for(Survey_Form__c sf : sfList){
            sf.Status__c = 'Available';
            sf.Feedback__c = 'Ok';
            updateSfList.add(sf);
        }
        
        
        Test.startTest();
        sia.ilItemList = updateSfList;
        sia.getStatusList();
         
         try{
             sia.btnSave();
         }catch(DmlException dmle){
             for(ApexPages.Message msg :  ApexPages.getMessages()){
                 System.assertEquals(dmle.getMessage(),msg.getSummary()); 
                 System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());       
             }
         }   
             
        Test.stopTest();
        
        
    }
}