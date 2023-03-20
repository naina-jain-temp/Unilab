// Author      : Gizelle Latosa
// Created     : 3/15/2018
// Description : Test class for UNILAB_SurveySummaryFormController

@isTest
public class UNILAB_SurveySummaryFormControllerTest{

     static Decimal q1 = 0;
     static Decimal q2 = 0;
     static Decimal insr = 0;  
     static Decimal tinsf = 0;  
     static Decimal issr = 0; 
     static Decimal tissf = 0;  
     static Decimal iasr = 0;  
     static Decimal tasf = 0;  
     static Decimal sNum = 0;
     static Decimal sDenom = 0;

     public static testMethod void testHundredPercent(){
    
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        testEvent.Created_from_Classic__c = true;
        insert testEvent;
        
        Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
        insert testAcc;         
        
        Activity_Junction__c aj = new Activity_Junction__c();
        aj.Event_Id__c = testEvent.Id;
        aj.Related_to_Account__c = testAcc.Id;
        insert aj;
        
        testEvent.Activity_Junction__c = aj.Id;
        update testEvent;
        
        List<Survey_Summary_Form__c> ssfList = new List<Survey_Summary_Form__c>();
        
        Survey_Summary_Form__c parentssf1 = new Survey_Summary_Form__c();    
        parentssf1.Name = 'Parent SSF1 - Questionnaire';
        parentssf1.Start_Date__c = date.Today().addDays(-3);
        parentssf1.End_Date__c = date.Today().addDays(3);
        parentssf1.Parent_SSF__c = null;
        parentssf1.Event_Sub_type__c = 'Branch Call';
        parentssf1.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf1.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Questionnaire').getRecordTypeId(); 
        parentssf1.Team__c = 'GMA'; 
        
        Survey_Summary_Form__c ssf1 = new Survey_Summary_Form__c();    
        ssf1.Name = 'SSF1 - Questionnaire';
        ssf1.Start_Date__c = date.Today().addDays(-3);
        ssf1.End_Date__c = date.Today().addDays(3);
        ssf1.Parent_SSF__c = parentssf1.Id;
        ssf1.Event_Sub_type__c = 'Branch Call';
        ssf1.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf1.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Questionnaire').getRecordTypeId(); 
        ssf1.Team__c = 'GMA';
        
        Survey_Summary_Form__c parentssf2 = new Survey_Summary_Form__c();    
        parentssf2.Name = 'Parent SSF2 - Inventory Number';
        parentssf2.Start_Date__c = date.Today().addDays(-3);
        parentssf2.End_Date__c = date.Today().addDays(3);
        parentssf2.Parent_SSF__c = null;
        parentssf2.Event_Sub_type__c = 'Branch Call';
        parentssf2.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf2.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Number').getRecordTypeId(); 
        parentssf2.Team__c = 'GMA';
        
        Survey_Summary_Form__c ssf2 = new Survey_Summary_Form__c();
        ssf2.Name = 'SSF2 - Inventory Number';
        ssf2.Start_Date__c = date.Today().addDays(-3);
        ssf2.End_Date__c = date.Today().addDays(3);
        ssf2.Parent_SSF__c = parentssf2.Id;
        ssf2.Event_Sub_type__c = 'Branch Call';
        ssf2.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf2.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Number').getRecordTypeId();
        ssf2.Team__c = 'GMA';
        
        Survey_Summary_Form__c parentssf3 = new Survey_Summary_Form__c();    
        parentssf3.Name = 'Parent SSF3 - Inventory Status';
        parentssf3.Start_Date__c = date.Today().addDays(-3);
        parentssf3.End_Date__c = date.Today().addDays(3);
        parentssf3.Parent_SSF__c = null;
        parentssf3.Event_Sub_type__c = 'Branch Call';
        parentssf3.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf3.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Status').getRecordTypeId(); 
        parentssf3.Team__c = 'GMA';
        
        Survey_Summary_Form__c ssf3 = new Survey_Summary_Form__c();
        ssf3.Name = 'SSF3 - Inventory Status';
        ssf3.Start_Date__c = date.Today().addDays(-3);
        ssf3.End_Date__c = date.Today().addDays(3);
        ssf3.Parent_SSF__c = parentssf3.Id;
        ssf3.Event_Sub_type__c = 'Branch Call';
        ssf3.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf3.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Status').getRecordTypeId();
        ssf3.Team__c = 'GMA';
        
        Survey_Summary_Form__c parentssf4 = new Survey_Summary_Form__c();    
        parentssf4.Name = 'Parent SSF4 - Inventory Availability';
        parentssf4.Start_Date__c = date.Today().addDays(-3);
        parentssf4.End_Date__c = date.Today().addDays(3);
        parentssf4.Parent_SSF__c = null;
        parentssf4.Event_Sub_type__c = 'Branch Call';
        parentssf4.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf4.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Availability').getRecordTypeId(); 
        parentssf4.Team__c = 'GMA';
        
        Survey_Summary_Form__c ssf4 = new Survey_Summary_Form__c();
        ssf4.Name = 'SSF4 - Inventory Availability';
        ssf4.Start_Date__c = date.Today().addDays(-3);
        ssf4.End_Date__c = date.Today().addDays(3);
        ssf4.Parent_SSF__c = parentssf4.Id;
        ssf4.Event_Sub_type__c = 'Branch Call';
        ssf4.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf4.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Availability').getRecordTypeId();
        ssf4.Team__c = 'GMA';
              
        ssfList.add(parentssf1);
        ssfList.add(parentssf2);
        ssfList.add(parentssf3);
        ssfList.add(parentssf4);
        ssfList.add(ssf1);
        ssfList.add(ssf2);
        ssfList.add(ssf3);
        ssfList.add(ssf4); 
        insert ssfList;
        
        List<Sub_Activity__c> subActList = new List<Sub_Activity__c>();
        Sub_Activity__c subAct1 = new Sub_Activity__c(); 
        subAct1.Activity_Junction__c = aj.Id;
        subAct1.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct1.Survey_Summary_Form__c = ssf1.Id;
          
        Sub_Activity__c subAct2 = new Sub_Activity__c(); 
        subAct2.Activity_Junction__c = aj.Id;
        subAct2.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct2.Survey_Summary_Form__c = ssf2.Id;
         
        Sub_Activity__c subAct3 = new Sub_Activity__c(); 
        subAct3.Activity_Junction__c = aj.Id;
        subAct3.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct3.Survey_Summary_Form__c = ssf3.Id;
         
        Sub_Activity__c subAct4 = new Sub_Activity__c(); 
        subAct4.Activity_Junction__c = aj.Id;
        subAct4.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct4.Survey_Summary_Form__c = ssf4.Id;
         
        subActList.add(subAct1);
        subActList.add(subAct2);
        subActList.add(subAct3);
        subActList.add(subAct4);
        
        insert subActList;
       
        Survey_Question_Choices__c sqc = new Survey_Question_Choices__c();
         
        sqc.Name = 'Question1';
        sqc.Type_of_Question__c = 'Checkbox (Yes/No)';
        insert sqc; 
         
        Product2 prod = new Product2();
        prod.Name = 'Product1';
        insert prod;
         
        List<Survey_Form__c> sfList = new List<Survey_Form__c>();
        Survey_Form__c sf1 = new Survey_Form__c();
        sf1.Survey_Summary_Form__c = ssf1.Id;
        sf1.Survey_Question__c = sqc.Id;
        sf1.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Question').getRecordTypeId();
        sf1.Answer__c = 'Yes';
        sf1.Weight__c = 100;
               
        Survey_Form__c sf2 = new Survey_Form__c();
        sf2.Survey_Summary_Form__c = ssf2.Id;
        sf2.Product__c = prod.Id;
        sf2.Shelf__c = 10;
        sf2.Backroom__c = 10;
        sf2.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Inventory Number').getRecordTypeId();
                  
        Survey_Form__c sf3 = new Survey_Form__c();
        sf3.Survey_Summary_Form__c = ssf3.Id;
        sf3.Product__c = prod.Id;
        sf3.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Inventory Status').getRecordTypeId();
        sf3.Status__c = 'With Stock';
        sf3.Feedback__c = 'Test';
             
        Survey_Form__c sf4 = new Survey_Form__c();
        sf4.Survey_Summary_Form__c = ssf4.Id;
        sf4.Product__c = prod.Id;
        sf4.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Inventory Availability').getRecordTypeId();
        sf4.Status__c = 'Yes';
        sf4.Feedback__c = 'Test';
        sf4.Weight__c = 100;
                
        sfList.add(sf1); 
        sfList.add(sf2);
        sfList.add(sf3);
        sfList.add(sf4);
        
        insert sfList;
        
        sf1.Answer_Copy__c = 'Yes';
        sf1.Status__c = '';
        sf1.Backroom__c = 0;
        sf1.Shelf__c = 0;
        sf1.Status_Copy__c = '';
         
        sf2.Answer_Copy__c = '';
        sf2.Status__c = '';
        sf2.Backroom__c = 15;
        sf2.Shelf__c = 15;
        sf2.Status_Copy__c = '';
        
        sf3.Answer_Copy__c = '';
        sf3.Status__c = 'With Stock';
        sf3.Backroom__c = 0;
        sf3.Shelf__c = 0;
        sf3.Status_Copy__c = '';
        
        sf4.Answer_Copy__c = '';
        sf4.Status__c = 'Yes';
        sf4.Backroom__c = 0;
        sf4.Shelf__c = 0;
        sf4.Status_Copy__c = 'Yes';
        
        update sfList;
        
        Survey_Form__c sf1AfterInsert = [SELECT Answered__c FROM Survey_Form__c WHERE Id =: sf1.Id];
        
        system.assertequals(true, sf1AfterInsert.Answered__c);
        
        Survey_Summary_Form__c ssf1AfterInsert = [SELECT Answered_Count__c, Parent_SSF__c, Survey_Rating__c, AnsweredCount__c, Answered__c, Survey_Rating_Final__c, Questionnaire_Survey_Rating__c, Total_Questionnaire_Survey_Forms_Weight__c
                                                 FROM Survey_Summary_Form__c WHERE Id =: ssf1.Id];
        
        ssf1AfterInsert.Parent_SSF__c = parentssf1.Id;                                         
        ssf1AfterInsert.AnsweredCount__c = 1;
        
        update ssf1AfterInsert;                                         
                                                  
        system.assertequals(1, ssf1AfterInsert.AnsweredCount__c);
        system.assertequals(true, ssf1AfterInsert.Answered__c);
        system.assertequals(parentssf1.Id, ssf1AfterInsert.Parent_SSF__c);
        system.assertequals(100, ssf1AfterInsert.Survey_Rating__c);
        system.assertequals('100%', ssf1AfterInsert.Survey_Rating_Final__c);
        system.assertequals(100, ssf1AfterInsert.Questionnaire_Survey_Rating__c);
        system.assertequals(100, ssf1AfterInsert.Total_Questionnaire_Survey_Forms_Weight__c);
        
        Survey_Form__c sf2AfterInsert = [SELECT Answered__c FROM Survey_Form__c WHERE Id =: sf2.Id];
        
        system.assertequals(true, sf2AfterInsert.Answered__c);
        
        Survey_Summary_Form__c ssf2AfterInsert = [SELECT Answered_Count__c, Parent_SSF__c, Survey_Rating__c, AnsweredCount__c, Answered__c, Survey_Rating_Final__c, Inventory_Number_Survey_Rating__c, Total_Inventory_Number_Survey_Form__c
                                                 FROM Survey_Summary_Form__c WHERE Id =: ssf2.Id];
        
        ssf2AfterInsert.Parent_SSF__c = parentssf2.Id;                                         
        ssf2AfterInsert.AnsweredCount__c = 1;
        
        update ssf2AfterInsert;                                         
                                                  
        system.assertequals(1, ssf2AfterInsert.AnsweredCount__c);
        system.assertequals(true, ssf2AfterInsert.Answered__c);
        system.assertequals(parentssf2.Id, ssf2AfterInsert.Parent_SSF__c);
        system.assertequals(100, ssf2AfterInsert.Survey_Rating__c);
        system.assertequals('100%', ssf2AfterInsert.Survey_Rating_Final__c);
        system.assertequals(100, ssf2AfterInsert.Inventory_Number_Survey_Rating__c);
        system.assertequals(100, ssf2AfterInsert.Total_Inventory_Number_Survey_Form__c);
        
        Survey_Form__c sf3AfterInsert = [SELECT Answered__c FROM Survey_Form__c WHERE Id =: sf3.Id];
        
        system.assertequals(true, sf3AfterInsert.Answered__c);
        
        Survey_Summary_Form__c ssf3AfterInsert = [SELECT Answered_Count__c, Parent_SSF__c, Survey_Rating__c, AnsweredCount__c, Answered__c, Survey_Rating_Final__c, Inventory_Status_Survey_Rating__c, Total_Inventory_Status_Survey_Form__c
                                                 FROM Survey_Summary_Form__c WHERE Id =: ssf3.Id];
        
        ssf3AfterInsert.Parent_SSF__c = parentssf3.Id;                                         
        ssf3AfterInsert.AnsweredCount__c = 1;
        
        update ssf3AfterInsert;                                         
                                                  
        system.assertequals(1, ssf3AfterInsert.AnsweredCount__c);
        system.assertequals(true, ssf3AfterInsert.Answered__c);
        system.assertequals(parentssf3.Id, ssf3AfterInsert.Parent_SSF__c);
        system.assertequals(100, ssf3AfterInsert.Survey_Rating__c);
        system.assertequals('100%', ssf3AfterInsert.Survey_Rating_Final__c);
        system.assertequals(100, ssf3AfterInsert.Inventory_Status_Survey_Rating__c);
        system.assertequals(100, ssf3AfterInsert.Total_Inventory_Status_Survey_Form__c);
        
        Survey_Form__c sf4AfterInsert = [SELECT Answered__c FROM Survey_Form__c WHERE Id =: sf4.Id];
        
        system.assertequals(true, sf4AfterInsert.Answered__c);
        
        Survey_Summary_Form__c ssf4AfterInsert = [SELECT Answered_Count__c, Parent_SSF__c, Survey_Rating__c, AnsweredCount__c, Answered__c, Survey_Rating_Final__c, Inventory_Availability_Survey_Rating__c, Total_Availability_Survey_Forms__c
                                                 FROM Survey_Summary_Form__c WHERE Id =: ssf4.Id];
        
        ssf4AfterInsert.Parent_SSF__c = parentssf4.Id;                                         
        ssf4AfterInsert.AnsweredCount__c = 1;
        
        update ssf4AfterInsert;                                         
                                                  
        system.assertequals(1, ssf4AfterInsert.AnsweredCount__c);
        system.assertequals(true, ssf4AfterInsert.Answered__c);
        system.assertequals(parentssf4.Id, ssf4AfterInsert.Parent_SSF__c);
        system.assertequals(100, ssf4AfterInsert.Survey_Rating__c);
        system.assertequals('100%', ssf4AfterInsert.Survey_Rating_Final__c);
        system.assertequals(100, ssf4AfterInsert.Inventory_Availability_Survey_Rating__c);
        system.assertequals(100, ssf4AfterInsert.Total_Availability_Survey_Forms__c);
        
        Sub_Activity__c subAct1AfterInsert = [SELECT Activity_Junction__c, Survey_Summary_Form__c, Survey_Summary_Form__r.RecordTypeId, Survey_Summary_Form__r.RecordType.Name, Survey_Summary_Form__r.AnsweredCount__c, Survey_Summary_Form__r.Answered__c, Survey_Summary_Form__r.Parent_SSF__c, Survey_Summary_Form__r.Survey_Rating__c, Survey_Summary_Form__r.Survey_Rating_Final__c, Survey_Summary_Form__r.Questionnaire_Survey_Rating__c,
                                              Survey_Summary_Form__r.Total_Questionnaire_Survey_Forms_Weight__c FROM Sub_Activity__c WHERE Activity_Junction__c =: aj.Id AND Survey_Summary_Form__r.Parent_SSF__c =: parentssf1.Id AND Survey_Summary_Form__r.Survey_Rating__c = 100 AND Survey_Summary_Form__c =: subAct1.Survey_Summary_Form__c AND Survey_Summary_Form__r.RecordType.Name =: 'Questionnaire' AND Survey_Summary_Form__r.Answered__c =: TRUE];
                                              
        subAct1AfterInsert.Survey_Summary_Form__r.AnsweredCount__c = 1;
        
        update subAct1AfterInsert;
               
        q1 += subAct1AfterInsert.Survey_Summary_Form__r.Questionnaire_Survey_Rating__c;
        q2 += subAct1AfterInsert.Survey_Summary_Form__r.Total_Questionnaire_Survey_Forms_Weight__c;
            
        system.assertequals(true, subAct1AfterInsert.Survey_Summary_Form__r.Answered__c);       
        system.assertequals('100%', subAct1AfterInsert.Survey_Summary_Form__r.Survey_Rating_Final__c); 
        system.assertequals(100, q1);       
        system.assertequals(100, q2);  
            
        Sub_Activity__c subAct2AfterInsert = [SELECT Activity_Junction__c, Survey_Summary_Form__c, Survey_Summary_Form__r.RecordTypeId, Survey_Summary_Form__r.RecordType.Name, Survey_Summary_Form__r.AnsweredCount__c, Survey_Summary_Form__r.Answered__c, Survey_Summary_Form__r.Parent_SSF__c, Survey_Summary_Form__r.Survey_Rating__c, Survey_Summary_Form__r.Survey_Rating_Final__c, Survey_Summary_Form__r.Inventory_Number_Survey_Rating__c,
                                              Survey_Summary_Form__r.Total_Inventory_Number_Survey_Form__c FROM Sub_Activity__c WHERE Activity_Junction__c =: aj.Id AND Survey_Summary_Form__r.Parent_SSF__c =: parentssf2.Id AND Survey_Summary_Form__r.Survey_Rating__c = 100 AND Survey_Summary_Form__c =: subAct2.Survey_Summary_Form__c AND Survey_Summary_Form__r.RecordType.Name =: 'Inventory Number' AND Survey_Summary_Form__r.Answered__c =: TRUE];
                                              
        subAct2AfterInsert.Survey_Summary_Form__r.AnsweredCount__c = 1;
        
        update subAct2AfterInsert;
        
        system.debug('>>subAct2AfterInsert>>' + subAct2AfterInsert);
        
               
        insr += subAct2AfterInsert.Survey_Summary_Form__r.Inventory_Number_Survey_Rating__c;
        tinsf += subAct2AfterInsert.Survey_Summary_Form__r.Total_Inventory_Number_Survey_Form__c;
            
        system.assertequals(true, subAct2AfterInsert.Survey_Summary_Form__r.Answered__c);       
        system.assertequals('100%', subAct2AfterInsert.Survey_Summary_Form__r.Survey_Rating_Final__c); 
        system.assertequals(100, insr);       
        system.assertequals(100, tinsf);  
            
        Sub_Activity__c subAct3AfterInsert = [SELECT Activity_Junction__c, Survey_Summary_Form__c, Survey_Summary_Form__r.RecordTypeId, Survey_Summary_Form__r.RecordType.Name, Survey_Summary_Form__r.AnsweredCount__c, Survey_Summary_Form__r.Answered__c, Survey_Summary_Form__r.Parent_SSF__c, Survey_Summary_Form__r.Survey_Rating__c, Survey_Summary_Form__r.Survey_Rating_Final__c, Survey_Summary_Form__r.Inventory_Status_Survey_Rating__c,
                                              Survey_Summary_Form__r.Total_Inventory_Status_Survey_Form__c FROM Sub_Activity__c WHERE Activity_Junction__c =: aj.Id AND Survey_Summary_Form__r.Parent_SSF__c =: parentssf3.Id AND Survey_Summary_Form__r.Survey_Rating__c = 100 AND Survey_Summary_Form__c =: subAct3.Survey_Summary_Form__c AND Survey_Summary_Form__r.RecordType.Name =: 'Inventory Status' AND Survey_Summary_Form__r.Answered__c =: TRUE];
                                              
        subAct3AfterInsert.Survey_Summary_Form__r.AnsweredCount__c = 1;
        
        update subAct3AfterInsert;
              
        issr += subAct3AfterInsert.Survey_Summary_Form__r.Inventory_Status_Survey_Rating__c;
        tissf += subAct3AfterInsert.Survey_Summary_Form__r.Total_Inventory_Status_Survey_Form__c;
            
        system.assertequals(true, subAct3AfterInsert.Survey_Summary_Form__r.Answered__c);       
        system.assertequals('100%', subAct3AfterInsert.Survey_Summary_Form__r.Survey_Rating_Final__c); 
        system.assertequals(100, issr);       
        system.assertequals(100, tissf);  
            
        Sub_Activity__c subAct4AfterInsert = [SELECT Activity_Junction__c, Survey_Summary_Form__c, Survey_Summary_Form__r.RecordTypeId, Survey_Summary_Form__r.RecordType.Name, Survey_Summary_Form__r.AnsweredCount__c, Survey_Summary_Form__r.Answered__c, Survey_Summary_Form__r.Parent_SSF__c, Survey_Summary_Form__r.Survey_Rating__c, Survey_Summary_Form__r.Survey_Rating_Final__c, Survey_Summary_Form__r.Inventory_Availability_Survey_Rating__c,
                                              Survey_Summary_Form__r.Total_Availability_Survey_Forms__c FROM Sub_Activity__c WHERE Activity_Junction__c =: aj.Id AND Survey_Summary_Form__r.Parent_SSF__c =: parentssf4.Id AND Survey_Summary_Form__r.Survey_Rating__c = 100 AND Survey_Summary_Form__c =: subAct4.Survey_Summary_Form__c AND Survey_Summary_Form__r.RecordType.Name =: 'Inventory Availability' AND Survey_Summary_Form__r.Answered__c =: TRUE];
                                              
        subAct4AfterInsert.Survey_Summary_Form__r.AnsweredCount__c = 1;
        
        update subAct4AfterInsert;
              
        iasr += subAct4AfterInsert.Survey_Summary_Form__r.Inventory_Availability_Survey_Rating__c;
        tasf += subAct4AfterInsert.Survey_Summary_Form__r.Total_Availability_Survey_Forms__c;
            
        system.assertequals(true, subAct4AfterInsert.Survey_Summary_Form__r.Answered__c);       
        system.assertequals('100%', subAct4AfterInsert.Survey_Summary_Form__r.Survey_Rating_Final__c); 
        system.assertequals(100, iasr);       
        system.assertequals(100, tasf);  
            
        UNILAB_SurveySummaryFormController cont = new UNILAB_SurveySummaryFormController();
     }
     
     public static testMethod void testNotApplicable(){
     
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        testEvent.Created_from_Classic__c = true;
        insert testEvent;
        
        Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
        insert testAcc;         
        
        Activity_Junction__c aj = new Activity_Junction__c();
        aj.Event_Id__c = testEvent.Id;
        aj.Related_to_Account__c = testAcc.Id;
        insert aj;
        
        testEvent.Activity_Junction__c = aj.Id;
        update testEvent;
        
        List<Survey_Summary_Form__c> ssfList = new List<Survey_Summary_Form__c>();
        
        Survey_Summary_Form__c parentssf1 = new Survey_Summary_Form__c();    
        parentssf1.Name = 'Parent SSF1 - Questionnaire';
        parentssf1.Start_Date__c = date.Today().addDays(-3);
        parentssf1.End_Date__c = date.Today().addDays(3);
        parentssf1.Parent_SSF__c = null;
        parentssf1.Event_Sub_type__c = 'Branch Call';
        parentssf1.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf1.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Questionnaire').getRecordTypeId(); 
        parentssf1.Team__c = 'GMA'; 
        
        Survey_Summary_Form__c ssf1 = new Survey_Summary_Form__c();    
        ssf1.Name = 'SSF1 - Questionnaire';
        ssf1.Start_Date__c = date.Today().addDays(-3);
        ssf1.End_Date__c = date.Today().addDays(3);
        ssf1.Parent_SSF__c = parentssf1.Id;
        ssf1.Event_Sub_type__c = 'Branch Call';
        ssf1.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf1.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Questionnaire').getRecordTypeId(); 
        ssf1.Team__c = 'GMA';
        
        Survey_Summary_Form__c parentssf3 = new Survey_Summary_Form__c();    
        parentssf3.Name = 'Parent SSF3 - Inventory Status';
        parentssf3.Start_Date__c = date.Today().addDays(-3);
        parentssf3.End_Date__c = date.Today().addDays(3);
        parentssf3.Parent_SSF__c = null;
        parentssf3.Event_Sub_type__c = 'Branch Call';
        parentssf3.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf3.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Status').getRecordTypeId(); 
        parentssf3.Team__c = 'GMA';
        
        Survey_Summary_Form__c ssf3 = new Survey_Summary_Form__c();
        ssf3.Name = 'SSF3 - Inventory Status';
        ssf3.Start_Date__c = date.Today().addDays(-3);
        ssf3.End_Date__c = date.Today().addDays(3);
        ssf3.Parent_SSF__c = parentssf3.Id;
        ssf3.Event_Sub_type__c = 'Branch Call';
        ssf3.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf3.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Status').getRecordTypeId();
        ssf3.Team__c = 'GMA';
        
        Survey_Summary_Form__c parentssf4 = new Survey_Summary_Form__c();    
        parentssf4.Name = 'Parent SSF4 - Inventory Availability';
        parentssf4.Start_Date__c = date.Today().addDays(-3);
        parentssf4.End_Date__c = date.Today().addDays(3);
        parentssf4.Parent_SSF__c = null;
        parentssf4.Event_Sub_type__c = 'Branch Call';
        parentssf4.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf4.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Availability').getRecordTypeId(); 
        parentssf4.Team__c = 'GMA';
        
        Survey_Summary_Form__c ssf4 = new Survey_Summary_Form__c();
        ssf4.Name = 'SSF4 - Inventory Availability';
        ssf4.Start_Date__c = date.Today().addDays(-3);
        ssf4.End_Date__c = date.Today().addDays(3);
        ssf4.Parent_SSF__c = parentssf4.Id;
        ssf4.Event_Sub_type__c = 'Branch Call';
        ssf4.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf4.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Availability').getRecordTypeId();
        ssf4.Team__c = 'GMA';
              
        ssfList.add(parentssf1);
        ssfList.add(parentssf3);
        ssfList.add(parentssf4);
        ssfList.add(ssf1);
        ssfList.add(ssf3);
        ssfList.add(ssf4); 
        insert ssfList;
        
        List<Sub_Activity__c> subActList = new List<Sub_Activity__c>();
        Sub_Activity__c subAct1 = new Sub_Activity__c(); 
        subAct1.Activity_Junction__c = aj.Id;
        subAct1.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct1.Survey_Summary_Form__c = ssf1.Id;
        
        Sub_Activity__c subAct3 = new Sub_Activity__c(); 
        subAct3.Activity_Junction__c = aj.Id;
        subAct3.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct3.Survey_Summary_Form__c = ssf3.Id;
          
        Sub_Activity__c subAct4 = new Sub_Activity__c(); 
        subAct4.Activity_Junction__c = aj.Id;
        subAct4.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct4.Survey_Summary_Form__c = ssf4.Id;
         
        subActList.add(subAct1);
        subActList.add(subAct3);
        subActList.add(subAct4);
        
        insert subActList;
       
        Survey_Question_Choices__c sqc = new Survey_Question_Choices__c();
         
        sqc.Name = 'Question1';
        sqc.Type_of_Question__c = 'Checkbox (Yes/No)';
        insert sqc; 
         
        Product2 prod = new Product2();
        prod.Name = 'Product1';
        insert prod;
         
        List<Survey_Form__c> sfList = new List<Survey_Form__c>();
        Survey_Form__c sf1 = new Survey_Form__c();
        sf1.Survey_Summary_Form__c = ssf1.Id;
        sf1.Survey_Question__c = sqc.Id;
        sf1.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Question').getRecordTypeId();
        sf1.Answer__c = 'N/A';
        sf1.Weight__c = 100;
        
        Survey_Form__c sf3 = new Survey_Form__c();
        sf3.Survey_Summary_Form__c = ssf3.Id;
        sf3.Product__c = prod.Id;
        sf3.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Inventory Status').getRecordTypeId();
        sf3.Status__c = 'Not Carried';
        sf3.Feedback__c = 'Test';
                            
        Survey_Form__c sf4 = new Survey_Form__c();
        sf4.Survey_Summary_Form__c = ssf4.Id;
        sf4.Product__c = prod.Id;
        sf4.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Inventory Availability').getRecordTypeId();
        sf4.Status__c = 'N/A';
        sf4.Feedback__c = 'Test';
        sf4.Weight__c = 100;
                
        sfList.add(sf1); 
        sfList.add(sf3); 
        sfList.add(sf4);
        
        insert sfList;
        
        sf1.Answer_Copy__c = 'N/A';
        sf1.Status__c = '';
        sf1.Backroom__c = 0;
        sf1.Shelf__c = 0;
        sf1.Status_Copy__c = '';
        
        sf3.Answer_Copy__c = '';
        sf3.Status__c = 'Not Carried';
        sf3.Backroom__c = 0;
        sf3.Shelf__c = 0;
        sf3.Status_Copy__c = '';
                 
        sf4.Answer_Copy__c = '';
        sf4.Status__c = 'N/A';
        sf4.Backroom__c = 0;
        sf4.Shelf__c = 0;
        sf4.Status_Copy__c = 'N/A';
        
        update sfList;
        
        Survey_Form__c sf1AfterInsert = [SELECT Answered__c FROM Survey_Form__c WHERE Id =: sf1.Id];
        
        system.assertequals(true, sf1AfterInsert.Answered__c);
        
        Survey_Summary_Form__c ssf1AfterInsert = [SELECT Answered_Count__c, Parent_SSF__c, Survey_Rating__c, AnsweredCount__c, Answered__c, Survey_Rating_Final__c, Questionnaire_Survey_Rating__c, Total_Questionnaire_Survey_Forms_Weight__c
                                                 FROM Survey_Summary_Form__c WHERE Id =: ssf1.Id];
        
        ssf1AfterInsert.Parent_SSF__c = parentssf1.Id;                                         
        ssf1AfterInsert.AnsweredCount__c = 1;
        
        update ssf1AfterInsert;                                         
                                                  
        system.assertequals(1, ssf1AfterInsert.AnsweredCount__c);
        system.assertequals(true, ssf1AfterInsert.Answered__c);
        system.assertequals(parentssf1.Id, ssf1AfterInsert.Parent_SSF__c);
        system.assertequals('Not Applicable', ssf1AfterInsert.Survey_Rating_Final__c);
        system.assertequals(0, 0);
        system.assertequals(0, 0);
        
        //ssf3
        
        Survey_Form__c sf3AfterInsert = [SELECT Answered__c FROM Survey_Form__c WHERE Id =: sf3.Id];
        
        system.assertequals(true, sf3AfterInsert.Answered__c);
        
        Survey_Summary_Form__c ssf3AfterInsert = [SELECT Answered_Count__c, Parent_SSF__c, Survey_Rating__c, AnsweredCount__c, Answered__c, Survey_Rating_Final__c, Inventory_Status_Survey_Rating__c, Total_Inventory_Status_Survey_Form__c
                                                 FROM Survey_Summary_Form__c WHERE Id =: ssf3.Id];
        
        ssf3AfterInsert.Parent_SSF__c = parentssf3.Id;                                         
        ssf3AfterInsert.AnsweredCount__c = 1;
        
        update ssf3AfterInsert;                                         
                                                  
        system.assertequals(1, ssf3AfterInsert.AnsweredCount__c);
        system.assertequals(true, ssf3AfterInsert.Answered__c);
        system.assertequals(parentssf3.Id, ssf3AfterInsert.Parent_SSF__c);
        system.assertequals('Not Applicable', ssf3AfterInsert.Survey_Rating_Final__c);
        system.assertequals(0, 0);
        system.assertequals(0, 0);
         
        Survey_Form__c sf4AfterInsert = [SELECT Answered__c FROM Survey_Form__c WHERE Id =: sf4.Id];
        
        system.assertequals(true, sf4AfterInsert.Answered__c);
        
        Survey_Summary_Form__c ssf4AfterInsert = [SELECT Answered_Count__c, Parent_SSF__c, Survey_Rating__c, AnsweredCount__c, Answered__c, Survey_Rating_Final__c, Inventory_Availability_Survey_Rating__c, Total_Availability_Survey_Forms__c
                                                 FROM Survey_Summary_Form__c WHERE Id =: ssf4.Id];
        
        ssf4AfterInsert.Parent_SSF__c = parentssf4.Id;                                         
        ssf4AfterInsert.AnsweredCount__c = 1;
        
        update ssf4AfterInsert;                                         
                                                  
        system.assertequals(1, ssf4AfterInsert.AnsweredCount__c);
        system.assertequals(true, ssf4AfterInsert.Answered__c);
        system.assertequals(parentssf4.Id, ssf4AfterInsert.Parent_SSF__c);   
        system.assertequals('Not Applicable', ssf4AfterInsert.Survey_Rating_Final__c);
        system.assertequals(0, 0);
        system.assertequals(0, 0);
        
        Sub_Activity__c subAct1AfterInsert = [SELECT Activity_Junction__c, Survey_Summary_Form__c, Survey_Summary_Form__r.RecordTypeId, Survey_Summary_Form__r.RecordType.Name, Survey_Summary_Form__r.AnsweredCount__c, Survey_Summary_Form__r.Answered__c, Survey_Summary_Form__r.Parent_SSF__c, Survey_Summary_Form__r.Survey_Rating__c, Survey_Summary_Form__r.Survey_Rating_Final__c, Survey_Summary_Form__r.Questionnaire_Survey_Rating__c,
                                              Survey_Summary_Form__r.Total_Questionnaire_Survey_Forms_Weight__c FROM Sub_Activity__c WHERE Activity_Junction__c =: aj.Id AND Survey_Summary_Form__r.Parent_SSF__c =: parentssf1.Id AND Survey_Summary_Form__r.Survey_Rating__c = 0 AND Survey_Summary_Form__c =: subAct1.Survey_Summary_Form__c AND Survey_Summary_Form__r.RecordType.Name =: 'Questionnaire' AND Survey_Summary_Form__r.Answered__c =: TRUE];
                                              
        subAct1AfterInsert.Survey_Summary_Form__r.AnsweredCount__c = 1;
        
        update subAct1AfterInsert;
        
        system.debug('>>subAct1AfterInsert>>' + subAct1AfterInsert);
        
        q1 = 0;
        q2 = 0;
            
        system.assertequals(true, subAct1AfterInsert.Survey_Summary_Form__r.Answered__c);       
        system.assertequals('Not Applicable', subAct1AfterInsert.Survey_Summary_Form__r.Survey_Rating_Final__c); 
        system.assertequals(0, q1);       
        system.assertequals(0, q2);  
            
        Sub_Activity__c subAct4AfterInsert = [SELECT Activity_Junction__c, Survey_Summary_Form__c, Survey_Summary_Form__r.RecordTypeId, Survey_Summary_Form__r.RecordType.Name, Survey_Summary_Form__r.AnsweredCount__c, Survey_Summary_Form__r.Answered__c, Survey_Summary_Form__r.Parent_SSF__c, Survey_Summary_Form__r.Survey_Rating__c, Survey_Summary_Form__r.Survey_Rating_Final__c, Survey_Summary_Form__r.Inventory_Availability_Survey_Rating__c,
                                              Survey_Summary_Form__r.Total_Availability_Survey_Forms__c FROM Sub_Activity__c WHERE Activity_Junction__c =: aj.Id AND Survey_Summary_Form__r.Parent_SSF__c =: parentssf4.Id AND Survey_Summary_Form__r.Survey_Rating__c = 0 AND Survey_Summary_Form__c =: subAct4.Survey_Summary_Form__c AND Survey_Summary_Form__r.RecordType.Name =: 'Inventory Availability' AND Survey_Summary_Form__r.Answered__c =: TRUE];
                                              
        subAct4AfterInsert.Survey_Summary_Form__r.AnsweredCount__c = 1;
        
        update subAct4AfterInsert;
              
        iasr = 0;
        tasf = 0;
            
        system.assertequals(true, subAct4AfterInsert.Survey_Summary_Form__r.Answered__c);       
        system.assertequals('Not Applicable', subAct4AfterInsert.Survey_Summary_Form__r.Survey_Rating_Final__c); 
        system.assertequals(0, iasr);       
        system.assertequals(0, tasf);  
            
        UNILAB_SurveySummaryFormController cont = new UNILAB_SurveySummaryFormController();
     }
     
     public static testMethod void testDeleteSF(){
    
        Event testEvent = new Event();
        testEvent.Subject = 'Test';
        testEvent.StartDateTime = dateTime.now(); 
        testEvent.EndDateTime = dateTime.now();
        testEvent.Created_from_Classic__c = true;
        insert testEvent;
        
        Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
        insert testAcc;        
        
        Activity_Junction__c aj = new Activity_Junction__c();
        aj.Event_Id__c = testEvent.Id;
        aj.Related_to_Account__c = testAcc.Id;
        insert aj;
        
        testEvent.Activity_Junction__c = aj.Id;
        update testEvent;
        
        List<Survey_Summary_Form__c> ssfList = new List<Survey_Summary_Form__c>();
        
        Survey_Summary_Form__c parentssf1 = new Survey_Summary_Form__c();    
        parentssf1.Name = 'Parent SSF1 - Questionnaire';
        parentssf1.Start_Date__c = date.Today().addDays(-3);
        parentssf1.End_Date__c = date.Today().addDays(3);
        parentssf1.Parent_SSF__c = null;
        parentssf1.Event_Sub_type__c = 'Branch Call';
        parentssf1.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf1.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Questionnaire').getRecordTypeId(); 
        parentssf1.Team__c = 'GMA'; 
        
        Survey_Summary_Form__c ssf1 = new Survey_Summary_Form__c();    
        ssf1.Name = 'SSF1 - Questionnaire';
        ssf1.Start_Date__c = date.Today().addDays(-3);
        ssf1.End_Date__c = date.Today().addDays(3);
        ssf1.Parent_SSF__c = parentssf1.Id;
        ssf1.Event_Sub_type__c = 'Branch Call';
        ssf1.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf1.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Questionnaire').getRecordTypeId(); 
        ssf1.Team__c = 'GMA';
        
        Survey_Summary_Form__c parentssf2 = new Survey_Summary_Form__c();    
        parentssf2.Name = 'Parent SSF2 - Inventory Number';
        parentssf2.Start_Date__c = date.Today().addDays(-3);
        parentssf2.End_Date__c = date.Today().addDays(3);
        parentssf2.Parent_SSF__c = null;
        parentssf2.Event_Sub_type__c = 'Branch Call';
        parentssf2.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf2.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Number').getRecordTypeId(); 
        parentssf2.Team__c = 'GMA';
        
        Survey_Summary_Form__c ssf2 = new Survey_Summary_Form__c();
        ssf2.Name = 'SSF2 - Inventory Number';
        ssf2.Start_Date__c = date.Today().addDays(-3);
        ssf2.End_Date__c = date.Today().addDays(3);
        ssf2.Parent_SSF__c = parentssf2.Id;
        ssf2.Event_Sub_type__c = 'Branch Call';
        ssf2.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf2.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Number').getRecordTypeId();
        ssf2.Team__c = 'GMA';
        
        Survey_Summary_Form__c parentssf3 = new Survey_Summary_Form__c();    
        parentssf3.Name = 'Parent SSF3 - Inventory Status';
        parentssf3.Start_Date__c = date.Today().addDays(-3);
        parentssf3.End_Date__c = date.Today().addDays(3);
        parentssf3.Parent_SSF__c = null;
        parentssf3.Event_Sub_type__c = 'Branch Call';
        parentssf3.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf3.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Status').getRecordTypeId(); 
        parentssf3.Team__c = 'GMA';
        
        Survey_Summary_Form__c ssf3 = new Survey_Summary_Form__c();
        ssf3.Name = 'SSF3 - Inventory Status';
        ssf3.Start_Date__c = date.Today().addDays(-3);
        ssf3.End_Date__c = date.Today().addDays(3);
        ssf3.Parent_SSF__c = parentssf3.Id;
        ssf3.Event_Sub_type__c = 'Branch Call';
        ssf3.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf3.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Status').getRecordTypeId();
        ssf3.Team__c = 'GMA';
        
        Survey_Summary_Form__c parentssf4 = new Survey_Summary_Form__c();    
        parentssf4.Name = 'Parent SSF4 - Inventory Availability';
        parentssf4.Start_Date__c = date.Today().addDays(-3);
        parentssf4.End_Date__c = date.Today().addDays(3);
        parentssf4.Parent_SSF__c = null;
        parentssf4.Event_Sub_type__c = 'Branch Call';
        parentssf4.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentssf4.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Availability').getRecordTypeId(); 
        parentssf4.Team__c = 'GMA';
        
        Survey_Summary_Form__c ssf4 = new Survey_Summary_Form__c();
        ssf4.Name = 'SSF4 - Inventory Availability';
        ssf4.Start_Date__c = date.Today().addDays(-3);
        ssf4.End_Date__c = date.Today().addDays(3);
        ssf4.Parent_SSF__c = parentssf4.Id;
        ssf4.Event_Sub_type__c = 'Branch Call';
        ssf4.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ssf4.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Inventory Availability').getRecordTypeId();
        ssf4.Team__c = 'GMA';
              
        ssfList.add(parentssf1);
        ssfList.add(parentssf2);
        ssfList.add(parentssf3);
        ssfList.add(parentssf4);
        ssfList.add(ssf1);
        ssfList.add(ssf2);
        ssfList.add(ssf3);
        ssfList.add(ssf4); 
        insert ssfList;
        
        List<Sub_Activity__c> subActList = new List<Sub_Activity__c>();
        Sub_Activity__c subAct1 = new Sub_Activity__c(); 
        subAct1.Activity_Junction__c = aj.Id;
        subAct1.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct1.Survey_Summary_Form__c = ssf1.Id;
          
        Sub_Activity__c subAct2 = new Sub_Activity__c(); 
        subAct2.Activity_Junction__c = aj.Id;
        subAct2.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct2.Survey_Summary_Form__c = ssf2.Id;
         
        Sub_Activity__c subAct3 = new Sub_Activity__c(); 
        subAct3.Activity_Junction__c = aj.Id;
        subAct3.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct3.Survey_Summary_Form__c = ssf3.Id;
         
        Sub_Activity__c subAct4 = new Sub_Activity__c(); 
        subAct4.Activity_Junction__c = aj.Id;
        subAct4.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        subAct4.Survey_Summary_Form__c = ssf4.Id;
         
        subActList.add(subAct1);
        subActList.add(subAct2);
        subActList.add(subAct3);
        subActList.add(subAct4);
        
        insert subActList;
       
        Survey_Question_Choices__c sqc = new Survey_Question_Choices__c();
         
        sqc.Name = 'Question1';
        sqc.Type_of_Question__c = 'Checkbox (Yes/No)';
        insert sqc; 
         
        Product2 prod = new Product2();
        prod.Name = 'Product1';
        insert prod;
         
        List<Survey_Form__c> sfList = new List<Survey_Form__c>();
        Survey_Form__c sf1 = new Survey_Form__c();
        sf1.Survey_Summary_Form__c = ssf1.Id;
        sf1.Survey_Question__c = sqc.Id;
        sf1.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Question').getRecordTypeId();
        sf1.Answer__c = 'Yes';
        sf1.Weight__c = 100;
               
        Survey_Form__c sf2 = new Survey_Form__c();
        sf2.Survey_Summary_Form__c = ssf2.Id;
        sf2.Product__c = prod.Id;
        sf2.Shelf__c = 10;
        sf2.Backroom__c = 10;
        sf2.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Inventory Number').getRecordTypeId();
                  
        Survey_Form__c sf3 = new Survey_Form__c();
        sf3.Survey_Summary_Form__c = ssf3.Id;
        sf3.Product__c = prod.Id;
        sf3.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Inventory Status').getRecordTypeId();
        sf3.Status__c = 'With Stock';
        sf3.Feedback__c = 'Test';
             
        Survey_Form__c sf4 = new Survey_Form__c();
        sf4.Survey_Summary_Form__c = ssf4.Id;
        sf4.Product__c = prod.Id;
        sf4.RecordTypeId = Schema.SObjectType.Survey_Form__c.getRecordTypeInfosByName().get('Inventory Availability').getRecordTypeId();
        sf4.Status__c = 'Yes';
        sf4.Feedback__c = 'Test';
        sf4.Weight__c = 100;
                
        sfList.add(sf1); 
        sfList.add(sf2);
        sfList.add(sf3);
        sfList.add(sf4);
        
        insert sfList;
        
        delete sfList; 
           
        UNILAB_SurveySummaryFormController cont = new UNILAB_SurveySummaryFormController();
        
     }   
     
}