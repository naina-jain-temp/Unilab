@isTest
private class UNILAB_TCR_Summary_Test {
    
    @testSetup static void setup() {
        
        // INSERT AN EVENT
        
        Event newEvent = new Event(Subject = 'Test New Event',
                                   StartDateTime = DateTime.now(),
                                   EndDateTime = DateTime.now(),
                                   Event_Type__c = 'Field Work',
                                   Event_Sub_Type__c = 'Training Contact'
                                  );
        
        insert newEvent;
        
        // INSERT ACCOUNT
        
        Set<String> acctID = new Set<String>();
        
        List<Account> acctList = TestDataFactory.createAccount(10);
        
        insert acctList;
        
        for (Account acct : acctList) {
            acctID.add(acct.Id);
        }
        
        // INSERT ACTIVITY JUNCTION
        
        List<Activity_Junction__c> actJuncList = TestDataFactory.createActivityJunction(1, acctID);
        insert actJuncList;
        
        // INSERT TCR RECORD
        
        List<Training_Contact_Report__c> tcrList = new List<Training_Contact_Report__c>();
        
        for (Integer i = 0; i < 20; i++) {
            
            Training_Contact_Report__c newTCR = new Training_Contact_Report__c();
            
            if (i < 5) {
                
                newTCR.Activity_Junction__c = actJuncList[0].Id;
                newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Account TCR').getRecordTypeId();
                
            }
            
            if (i > 5 && i < 10) {
                
                newTCR.Activity_Junction__c = actJuncList[0].Id;
                newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('T3 TCR').getRecordTypeId();
                
            }
            
            if (i > 10 && i < 15) {
                
                newTCR.Activity_Junction__c = actJuncList[0].Id;
                newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('Meeting TCR').getRecordTypeId();
                
                newTCR.Meeting_invites_ensure_attendance__c = '3';
                newTCR.Agenda_Presentation_Materials_Assess__c = '2';
                newTCR.Venue_Logistics_Preps__c = '1';
                newTCR.Review_Meeting_Agreement__c = '0';
                newTCR.Execute_Presentation_Principles_ICE__c = 'N/A';
                newTCR.Facilitate_Discussion__c = '0';
                newTCR.Facilitate_Workshop__c = '1';
                newTCR.Secure_Agreements_Commitments__c = '2';
                newTCR.Clarify_Next_Steps__c = '3';
                newTCR.Established_MOMs_send__c = '3';
                
            }
            
            if (i > 15 && i < 20) {
                
                newTCR.Activity_Junction__c = actJuncList[0].Id;
                newTCR.RecordTypeId = Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get('SUBD AUDIT TCR').getRecordTypeId();
                
                newTCR.Bank_Guarantee__c = '3';
                newTCR.Financials_Compliance__c = '2';
                newTCR.Workplan_WFAR__c = '1';
                newTCR.CDR_DFAR__c = '0';
                newTCR.PJP__c = 'N/A';
                newTCR.ICS__c = '0';
                newTCR.TCR_CDS__c = '1';
                newTCR.CDR_Evaluation_DFS__c = '2';
                newTCR.Training_Log__c = '3';
                newTCR.Seller_s_Performance_Board__c = '3';
                newTCR.BCP_Application__c = '2';
                newTCR.Housekeeping__c = '1';
                newTCR.IRA__c = '0';
                newTCR.Fillrate__c = 'N/A';
                newTCR.Returns__c = 'N/A';
                
            }
            
            tcrList.add(newTCR);
            
        }
        
        insert tcrList;
        
    }
    
    @isTest
    public static void userTheme() {
        
        Test.startTest();
        
        String userTheme = UNILAB_TCR_Summary.getUserTheme();
        
        Test.stopTest();
        
        System.assert(userTheme != NULL);
        
    }
    
    @isTest
    public static void getTCRType() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    LIMIT 1
                                                   ];
        
        Test.startTest();
        
        String tcrType = UNILAB_TCR_Summary.getTCRType(tcrList[0].Id);
        
        Test.stopTest();
        
        System.assert(tcrType == tcrList[0].RecordType.Name);
        
    }
    
    @isTest
    public static void tcrAccountValid() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'Account TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 4
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (TRADE TCR)
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        for (Integer i = 0; i < acctList.size(); i++) {
            
            Training_Contact_Report_Call__c newTCRCall = new Training_Contact_Report_Call__c();
            
            if (i == 0) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '0';
                newTCRCall.Selling_Display_Area_Activities__c = '0';
                newTCRCall.Collection_and_Settlements__c = '0';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '0';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '0';
                newTCRCall.Post_Call_Activities__c = '0';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 1) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '1';
                newTCRCall.Selling_Display_Area_Activities__c = '1';
                newTCRCall.Collection_and_Settlements__c = '1';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '1';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '1';
                newTCRCall.Post_Call_Activities__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 2) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '2';
                newTCRCall.Selling_Display_Area_Activities__c = '2';
                newTCRCall.Collection_and_Settlements__c = '2';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '2';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '2';
                newTCRCall.Post_Call_Activities__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 3) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '3';
                newTCRCall.Selling_Display_Area_Activities__c = '3';
                newTCRCall.Collection_and_Settlements__c = '3';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '3';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '2';
                newTCRCall.Post_Call_Activities__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            tcrCallList.add(newTCRCall);
            
        }
        
        insert tcrCallList;
        
        Test.startTest();
        
        String callChartAveList = UNILAB_TCR_Summary.createTCRChart(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(callChartAveList != NULL);
        
    }
    
    @isTest
    public static void tcrAccountNotApplicable() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'Account TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 4
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (TRADE TCR)
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        for (Integer i = 0; i < acctList.size(); i++) {
            
            Training_Contact_Report_Call__c newTCRCall = new Training_Contact_Report_Call__c();
            
            if (i == 0) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '0';
                newTCRCall.Selling_Display_Area_Activities__c = '0';
                newTCRCall.Collection_and_Settlements__c = '0';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '0';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '0';
                newTCRCall.Post_Call_Activities__c = '0';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 1) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '1';
                newTCRCall.Selling_Display_Area_Activities__c = '1';
                newTCRCall.Collection_and_Settlements__c = '1';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '1';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '1';
                newTCRCall.Post_Call_Activities__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 2) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '2';
                newTCRCall.Selling_Display_Area_Activities__c = '2';
                newTCRCall.Collection_and_Settlements__c = '2';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '2';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '2';
                newTCRCall.Post_Call_Activities__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 3) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = 'N/A';
                newTCRCall.Selling_Display_Area_Activities__c = 'N/A';
                newTCRCall.Collection_and_Settlements__c = 'N/A';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = 'N/A';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = 'N/A';
                newTCRCall.Post_Call_Activities__c = 'N/A';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            tcrCallList.add(newTCRCall);
            
        }
        
        insert tcrCallList;
        
        Test.startTest();
        
        String callChartAveList = UNILAB_TCR_Summary.createTCRChart(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(callChartAveList != NULL);
        
    }
    
    @isTest
    public static void tcrAccountZero() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'Account TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 4
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (TRADE TCR)
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        for (Integer i = 0; i < acctList.size(); i++) {
            
            Training_Contact_Report_Call__c newTCRCall = new Training_Contact_Report_Call__c();
            
            if (i == 0) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '0';
                newTCRCall.Selling_Display_Area_Activities__c = '0';
                newTCRCall.Collection_and_Settlements__c = '0';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '0';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '0';
                newTCRCall.Post_Call_Activities__c = '0';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 1) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '1';
                newTCRCall.Selling_Display_Area_Activities__c = '1';
                newTCRCall.Collection_and_Settlements__c = '1';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '1';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '1';
                newTCRCall.Post_Call_Activities__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 2) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '2';
                newTCRCall.Selling_Display_Area_Activities__c = '2';
                newTCRCall.Collection_and_Settlements__c = '2';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '2';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '2';
                newTCRCall.Post_Call_Activities__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 3) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            tcrCallList.add(newTCRCall);
            
        }
        
        insert tcrCallList;
        
        Test.startTest();
        
        String callChartAveList = UNILAB_TCR_Summary.createTCRChart(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(callChartAveList != NULL);
        
    }
    
    @isTest
    public static void t3TCRValid() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'T3 TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 4
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (T3 TCR)
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        for (Integer i = 0; i < acctList.size(); i++) {
            
            Training_Contact_Report_Call__c newTCRCall = new Training_Contact_Report_Call__c();
            
            if (i == 0) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '0';
                newTCRCall.Observe__c = '0';
                newTCRCall.Critique__c = '0';
                newTCRCall.Recommend__c = '0';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 1) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '1';
                newTCRCall.Observe__c = '1';
                newTCRCall.Critique__c = '1';
                newTCRCall.Recommend__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 2) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '2';
                newTCRCall.Observe__c = '2';
                newTCRCall.Critique__c = '2';
                newTCRCall.Recommend__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 3) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '3';
                newTCRCall.Observe__c = '3';
                newTCRCall.Critique__c = '2';
                newTCRCall.Recommend__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            tcrCallList.add(newTCRCall);
            
        }
        
        insert tcrCallList;
        
        Test.startTest();
        
        String callChartAveList = UNILAB_TCR_Summary.createTCRChart(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(callChartAveList != NULL);
        
    }
    
    @isTest
    public static void t3TCRNotApplicable() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'T3 TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 4
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (T3 TCR)
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        for (Integer i = 0; i < acctList.size(); i++) {
            
            Training_Contact_Report_Call__c newTCRCall = new Training_Contact_Report_Call__c();
            
            if (i == 0) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '0';
                newTCRCall.Observe__c = '0';
                newTCRCall.Critique__c = '0';
                newTCRCall.Recommend__c = '0';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 1) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '1';
                newTCRCall.Observe__c = '1';
                newTCRCall.Critique__c = '1';
                newTCRCall.Recommend__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 2) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '2';
                newTCRCall.Observe__c = '2';
                newTCRCall.Critique__c = '2';
                newTCRCall.Recommend__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 3) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = 'N/A';
                newTCRCall.Observe__c = 'N/A';
                newTCRCall.Critique__c = 'N/A';
                newTCRCall.Recommend__c = 'N/A';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            tcrCallList.add(newTCRCall);
            
        }
        
        insert tcrCallList;
        
        Test.startTest();
        
        String callChartAveList = UNILAB_TCR_Summary.createTCRChart(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(callChartAveList != NULL);
        
    }
    
    @isTest
    public static void t3TCRZero() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'T3 TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 4
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (T3 TCR)
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        for (Integer i = 0; i < acctList.size(); i++) {
            
            Training_Contact_Report_Call__c newTCRCall = new Training_Contact_Report_Call__c();
            
            if (i == 0) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '0';
                newTCRCall.Observe__c = '0';
                newTCRCall.Critique__c = '0';
                newTCRCall.Recommend__c = '0';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 1) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '1';
                newTCRCall.Observe__c = '1';
                newTCRCall.Critique__c = '1';
                newTCRCall.Recommend__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 2) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '2';
                newTCRCall.Observe__c = '2';
                newTCRCall.Critique__c = '2';
                newTCRCall.Recommend__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 3) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            tcrCallList.add(newTCRCall);
            
        }
        
        insert tcrCallList;
        
        Test.startTest();
        
        String callChartAveList = UNILAB_TCR_Summary.createTCRChart(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(callChartAveList != NULL);
        
    }
    
    @isTest
    public static void tcrAccountResult() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'Account TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 4
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (TRADE TCR)
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        for (Integer i = 0; i < acctList.size(); i++) {
            
            Training_Contact_Report_Call__c newTCRCall = new Training_Contact_Report_Call__c();
            
            if (i == 0) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '0';
                newTCRCall.Selling_Display_Area_Activities__c = '0';
                newTCRCall.Collection_and_Settlements__c = '0';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '0';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '0';
                newTCRCall.Post_Call_Activities__c = '0';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 1) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '1';
                newTCRCall.Selling_Display_Area_Activities__c = '1';
                newTCRCall.Collection_and_Settlements__c = '1';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '1';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '1';
                newTCRCall.Post_Call_Activities__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 2) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '2';
                newTCRCall.Selling_Display_Area_Activities__c = '2';
                newTCRCall.Collection_and_Settlements__c = '2';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '2';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '2';
                newTCRCall.Post_Call_Activities__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 3) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '3';
                newTCRCall.Selling_Display_Area_Activities__c = '3';
                newTCRCall.Collection_and_Settlements__c = '3';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '3';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '3';
                newTCRCall.Post_Call_Activities__c = '3';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            tcrCallList.add(newTCRCall);
            
        }
        
        insert tcrCallList;
        
        Test.startTest();
        
        List<Training_Contact_Report_Call__c> savedTCRCallList = UNILAB_TCR_Summary.getTCRResult(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(savedTCRCallList != NULL);
        
    }
    
    @isTest
    public static void t3TCRResult() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'T3 TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 4
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (T3 TCR)
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        for (Integer i = 0; i < acctList.size(); i++) {
            
            Training_Contact_Report_Call__c newTCRCall = new Training_Contact_Report_Call__c();
            
            if (i == 0) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '0';
                newTCRCall.Observe__c = '0';
                newTCRCall.Critique__c = '0';
                newTCRCall.Recommend__c = '0';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 1) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '1';
                newTCRCall.Observe__c = '1';
                newTCRCall.Critique__c = '1';
                newTCRCall.Recommend__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 2) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '2';
                newTCRCall.Observe__c = '2';
                newTCRCall.Critique__c = '2';
                newTCRCall.Recommend__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 3) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '3';
                newTCRCall.Observe__c = '3';
                newTCRCall.Critique__c = '3';
                newTCRCall.Recommend__c = '3';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            tcrCallList.add(newTCRCall);
            
        }
        
        insert tcrCallList;
        
        Test.startTest();
        
        List<Training_Contact_Report_Call__c> savedTCRCallList = UNILAB_TCR_Summary.getTCRResult(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(savedTCRCallList != NULL);
        
    }
    
    @isTest
    public static void meetingTCRResult() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name,
                                                    	   Meeting_invites_ensure_attendance__c,
                                                           Agenda_Presentation_Materials_Assess__c,
                                                           Venue_Logistics_Preps__c,
                                                           Review_Meeting_Agreement__c,
                                                           Execute_Presentation_Principles_ICE__c,
                                                           Facilitate_Discussion__c,
                                                           Facilitate_Workshop__c,
                                                           Secure_Agreements_Commitments__c,
                                                           Clarify_Next_Steps__c,
                                                           Established_MOMs_send__c
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'Meeting TCR')
                                                    LIMIT 1
                                                   ];
        
        Test.startTest();
        
        List<Training_Contact_Report__c> savedTCRCallList = UNILAB_TCR_Summary.getTCRTableResult(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(savedTCRCallList != NULL);
        
        System.assert(tcrList[0].Id == savedTCRCallList[0].Id);
        System.assert(tcrList[0].Meeting_invites_ensure_attendance__c == savedTCRCallList[0].Meeting_invites_ensure_attendance__c);
        System.assert(tcrList[0].Agenda_Presentation_Materials_Assess__c == savedTCRCallList[0].Agenda_Presentation_Materials_Assess__c);
        System.assert(tcrList[0].Venue_Logistics_Preps__c == savedTCRCallList[0].Venue_Logistics_Preps__c);
        System.assert(tcrList[0].Review_Meeting_Agreement__c == savedTCRCallList[0].Review_Meeting_Agreement__c);
        System.assert(tcrList[0].Execute_Presentation_Principles_ICE__c == savedTCRCallList[0].Execute_Presentation_Principles_ICE__c);
        System.assert(tcrList[0].Facilitate_Discussion__c == savedTCRCallList[0].Facilitate_Discussion__c);
        System.assert(tcrList[0].Facilitate_Workshop__c == savedTCRCallList[0].Facilitate_Workshop__c);
        System.assert(tcrList[0].Secure_Agreements_Commitments__c == savedTCRCallList[0].Secure_Agreements_Commitments__c);
        System.assert(tcrList[0].Clarify_Next_Steps__c == savedTCRCallList[0].Clarify_Next_Steps__c);
        System.assert(tcrList[0].Established_MOMs_send__c == savedTCRCallList[0].Established_MOMs_send__c);
        
    }
    
    @isTest
    public static void subDAuditTCRResult() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name,
                                                    	   Bank_Guarantee__c,
                                                           Financials_Compliance__c,
                                                           Workplan_WFAR__c,
                                                           CDR_DFAR__c,
                                                           PJP__c,
                                                           ICS__c,
                                                           TCR_CDS__c,
                                                           CDR_Evaluation_DFS__c,
                                                           Training_Log__c,
                                                           Seller_s_Performance_Board__c,
                                                           BCP_Application__c,
                                                           Housekeeping__c,
                                                           IRA__c,
                                                           Fillrate__c,
                                                           Returns__c
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'SUBD AUDIT TCR')
                                                    LIMIT 1
                                                   ];
        
        Test.startTest();
        
        List<Training_Contact_Report__c> savedTCRCallList = UNILAB_TCR_Summary.getTCRTableResult(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(savedTCRCallList != NULL);
        
        System.assert(tcrList[0].Id == savedTCRCallList[0].Id);
        System.assert(tcrList[0].Bank_Guarantee__c == savedTCRCallList[0].Bank_Guarantee__c);
        System.assert(tcrList[0].Financials_Compliance__c == savedTCRCallList[0].Financials_Compliance__c);
        System.assert(tcrList[0].Workplan_WFAR__c == savedTCRCallList[0].Workplan_WFAR__c);
        System.assert(tcrList[0].CDR_DFAR__c == savedTCRCallList[0].CDR_DFAR__c);
        System.assert(tcrList[0].PJP__c == savedTCRCallList[0].PJP__c);
        System.assert(tcrList[0].ICS__c == savedTCRCallList[0].ICS__c);
        System.assert(tcrList[0].TCR_CDS__c == savedTCRCallList[0].TCR_CDS__c);
        System.assert(tcrList[0].CDR_Evaluation_DFS__c == savedTCRCallList[0].CDR_Evaluation_DFS__c);
        System.assert(tcrList[0].Training_Log__c == savedTCRCallList[0].Training_Log__c);
        System.assert(tcrList[0].Seller_s_Performance_Board__c == savedTCRCallList[0].Seller_s_Performance_Board__c);
        System.assert(tcrList[0].BCP_Application__c == savedTCRCallList[0].BCP_Application__c);
        System.assert(tcrList[0].Housekeeping__c == savedTCRCallList[0].Housekeeping__c);
        System.assert(tcrList[0].IRA__c == savedTCRCallList[0].IRA__c);
        System.assert(tcrList[0].Fillrate__c == savedTCRCallList[0].Fillrate__c);
        System.assert(tcrList[0].Returns__c == savedTCRCallList[0].Returns__c);
        
    }
    
    @isTest
    public static void tcrAccountAllAve() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'Account TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 4
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (TRADE TCR)
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        for (Integer i = 0; i < acctList.size(); i++) {
            
            Training_Contact_Report_Call__c newTCRCall = new Training_Contact_Report_Call__c();
            
            if (i == 0) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '0';
                newTCRCall.Selling_Display_Area_Activities__c = '0';
                newTCRCall.Collection_and_Settlements__c = '0';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '0';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '0';
                newTCRCall.Post_Call_Activities__c = '0';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 1) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '1';
                newTCRCall.Selling_Display_Area_Activities__c = '1';
                newTCRCall.Collection_and_Settlements__c = '1';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '1';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '1';
                newTCRCall.Post_Call_Activities__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 2) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '2';
                newTCRCall.Selling_Display_Area_Activities__c = '2';
                newTCRCall.Collection_and_Settlements__c = '2';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '2';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '2';
                newTCRCall.Post_Call_Activities__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 3) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Review_Plans_Prior_to_Entering_Call__c = '3';
                newTCRCall.Selling_Display_Area_Activities__c = '3';
                newTCRCall.Collection_and_Settlements__c = '3';
                newTCRCall.Presentation_Follow_thru_Negotiations__c = '3';
                newTCRCall.Secure_Approval_and_Final_Agreements__c = '2';
                newTCRCall.Post_Call_Activities__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            tcrCallList.add(newTCRCall);
            
        }
        
        insert tcrCallList;
        
        Test.startTest();
        
        List<String> tcrAccountAveList = UNILAB_TCR_Summary.calculateTotalAverage(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(tcrAccountAveList != NULL);
        
    }
    
    @isTest
    public static void tcrAccountAllAveZero() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'Account TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 1
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (TRADE TCR)
        
        Training_Contact_Report_Call__c tcrCallList = new Training_Contact_Report_Call__c(TCR__c = tcrList[0].Id,
                                                                                          Review_Plans_Prior_to_Entering_Call__c = 'N/A',
                                                                                          Selling_Display_Area_Activities__c = 'N/A',
                                                                                          Collection_and_Settlements__c = 'N/A',
                                                                                          Presentation_Follow_thru_Negotiations__c = 'N/A',
                                                                                          Secure_Approval_and_Final_Agreements__c = 'N/A',
                                                                                          Post_Call_Activities__c = 'N/A',
                                                                                          Account__c = acctList[0].Id
                                                                                         );
        
        insert tcrCallList;
        
        Test.startTest();
        
        List<String> tcrAccountAveList = UNILAB_TCR_Summary.calculateTotalAverage(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(tcrAccountAveList != NULL);
        
    }
    
    @isTest
    public static void t3TCRAllAve() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'T3 TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 4
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (T3 TCR)
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        for (Integer i = 0; i < acctList.size(); i++) {
            
            Training_Contact_Report_Call__c newTCRCall = new Training_Contact_Report_Call__c();
            
            if (i == 0) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '0';
                newTCRCall.Observe__c = '0';
                newTCRCall.Critique__c = '0';
                newTCRCall.Recommend__c = '0';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 1) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '1';
                newTCRCall.Observe__c = '1';
                newTCRCall.Critique__c = '1';
                newTCRCall.Recommend__c = '1';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 2) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '2';
                newTCRCall.Observe__c = '2';
                newTCRCall.Critique__c = '2';
                newTCRCall.Recommend__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            if (i == 3) {
                
                newTCRCall.TCR__c = tcrList[0].Id;
                newTCRCall.Explain_training_objectives__c = '3';
                newTCRCall.Observe__c = '3';
                newTCRCall.Critique__c = '2';
                newTCRCall.Recommend__c = '2';
                newTCRCall.Account__c = acctList[i].Id;
                
            }
            
            tcrCallList.add(newTCRCall);
            
        }
        
        insert tcrCallList;
        
        Test.startTest();
        
        List<String> t3TCRAveList = UNILAB_TCR_Summary.calculateTotalAverage(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(t3TCRAveList != NULL);
        
    }
    
    @isTest
    public static void t3TCRAllAveZero() {
        
        // SELECT TRAINING CONTACT REPORT
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id,
                                                    	   RecordType.Name
                                                    FROM Training_Contact_Report__c
                                                    WHERE (RecordType.Name = 'T3 TCR')
                                                    LIMIT 1
                                                   ];
        
        // SELECT ACCOUNT
        
        List<Account> acctList = [SELECT Id
                                  FROM Account
                                  LIMIT 1
                                 ];
        
        // CREATE TRAINING CONTACT REPORT CALL (T3 TCR)
        
        Training_Contact_Report_Call__c tcrCallList = new Training_Contact_Report_Call__c(TCR__c = tcrList[0].Id,
                                                                                          Explain_training_objectives__c = 'N/A',
                                                                                          Observe__c = 'N/A',
                                                                                          Critique__c = 'N/A',
                                                                                          Recommend__c = 'N/A',
                                                                                          Account__c = acctList[0].Id
                                                                                         );
        
        insert tcrCallList;
        
        Test.startTest();
        
        List<String> t3TCRAveList = UNILAB_TCR_Summary.calculateTotalAverage(tcrList[0].Id, tcrList[0].RecordType.Name);
        
        Test.stopTest();
        
        System.assert(t3TCRAveList != NULL);
        
    }

}