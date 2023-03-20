public class UNILAB_TCR_Summary {
    
    @AuraEnabled
    public List<CallChartAverage> callChartAverageList;
    
    public class CallChartAverage {
        
        String chartLabel;
        
        Decimal callAverage;
        
        public CallChartAverage(String cLabel, Decimal cAverage) {
            
            this.chartLabel = cLabel;
            this.callAverage = cAverage;
            
        }
        
    }
    
    @AuraEnabled
    public static String createTCRChart(String tcrID, String tcrType) {
        
        List<CallChartAverage> averageList = new List<CallChartAverage>();
        
        List<Training_Contact_Report_Call__c> listTCRAcct = [SELECT Account__c
                                                             FROM Training_Contact_Report_Call__c
                                                             WHERE (TCR__c = :tcrID)
                                                            ];
        
        List<Id> listAcctID = new List<Id>();
        
        for (Training_Contact_Report_Call__c newTCRList : listTCRAcct) {
            
            listAcctID.add(newTCRList.Account__c);
            
        }
        
        if (tcrType.equalsIgnoreCase('ACCOUNT TCR')) {
            
            List<Training_Contact_Report_Call__c> listOfTCR = [SELECT Account__r.Name,
                                                               Review_Plans_Prior_to_Entering_Call__c,
                                                               Selling_Display_Area_Activities__c,
                                                               Collection_and_Settlements__c,
                                                               Presentation_Follow_thru_Negotiations__c,
                                                               Secure_Approval_and_Final_Agreements__c,
                                                               Post_Call_Activities__c
                                                               FROM Training_Contact_Report_Call__c
                                                               WHERE (TCR__c = :tcrID)
                                                               AND (Account__c IN :listAcctID)
                                                              ];
            
            for (Training_Contact_Report_Call__c newTCRList : listOfTCR) {
                
                Double sumOfCalls = 0;
                Double numberOfCalls = 0;
                
                if (newTCRList.Review_Plans_Prior_to_Entering_Call__c != 'N/A' && newTCRList.Review_Plans_Prior_to_Entering_Call__c != NULL) {
                    
                    sumOfCalls += Integer.valueOf(newTCRList.Review_Plans_Prior_to_Entering_Call__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Selling_Display_Area_Activities__c != 'N/A' && newTCRList.Selling_Display_Area_Activities__c != NULL) {
                    
                    sumOfCalls += Integer.valueOf(newTCRList.Selling_Display_Area_Activities__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Collection_and_Settlements__c != 'N/A' && newTCRList.Collection_and_Settlements__c != NULL) {
                    
                    sumOfCalls += Integer.valueOf(newTCRList.Collection_and_Settlements__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Presentation_Follow_thru_Negotiations__c != 'N/A' && newTCRList.Presentation_Follow_thru_Negotiations__c != NULL) {
                    
                    sumOfCalls += Integer.valueOf(newTCRList.Presentation_Follow_thru_Negotiations__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Secure_Approval_and_Final_Agreements__c != 'N/A' && newTCRList.Secure_Approval_and_Final_Agreements__c != NULL) {
                    
                    sumOfCalls += Integer.valueOf(newTCRList.Secure_Approval_and_Final_Agreements__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Post_Call_Activities__c != 'N/A' && newTCRList.Post_Call_Activities__c != NULL) {
                    
                    sumOfCalls += Integer.valueOf(newTCRList.Post_Call_Activities__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Review_Plans_Prior_to_Entering_Call__c == 'N/A' &&
                    newTCRList.Selling_Display_Area_Activities__c == 'N/A' &&
                    newTCRList.Collection_and_Settlements__c == 'N/A' &&
                    newTCRList.Presentation_Follow_thru_Negotiations__c == 'N/A' &&
                    newTCRList.Secure_Approval_and_Final_Agreements__c == 'N/A' &&
                    newTCRList.Post_Call_Activities__c == 'N/A') {
                        
                        averageList.add(new CallChartAverage(newTCRList.Account__r.Name, NULL));
                        
                    }
                
                else {
                    
                    if (sumOfCalls == 0 && numberOfCalls == 0) {
                        
                        averageList.add(new CallChartAverage(newTCRList.Account__r.Name, null));
                        
                    }
                    
                    else {
                        
                        Decimal aveList = sumOfCalls / numberOfCalls;
                        
                        averageList.add(new CallChartAverage(newTCRList.Account__r.Name, aveList.setScale(2, RoundingMode.HALF_UP)));
                        
                    }
                    
                }
                
            }
            
            return JSON.serialize(averageList);
            
        }
        
        else {
            
            List<Training_Contact_Report_Call__c> listOfTCR = [SELECT Account__r.Name,
                                                               Explain_training_objectives__c,
                                                               Observe__c,
                                                               Critique__c,
                                                               Recommend__c
                                                               FROM Training_Contact_Report_Call__c
                                                               WHERE (TCR__c = :tcrID)
                                                               AND (Account__c IN :listAcctID)
                                                              ];
            
            for (Training_Contact_Report_Call__c newTCRList : listOfTCR) {
                
                Double sumOfCalls = 0;
                Double numberOfCalls = 0;
                
                if (newTCRList.Explain_training_objectives__c != 'N/A' && newTCRList.Explain_training_objectives__c != NULL) {
                    
                    sumOfCalls += Integer.valueOf(newTCRList.Explain_training_objectives__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Observe__c != 'N/A' && newTCRList.Observe__c != NULL) {
                    
                    sumOfCalls += Integer.valueOf(newTCRList.Observe__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Critique__c != 'N/A' && newTCRList.Critique__c != NULL) {
                    
                    sumOfCalls += Integer.valueOf(newTCRList.Critique__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Recommend__c != 'N/A' && newTCRList.Recommend__c != NULL) {
                    
                    sumOfCalls += Integer.valueOf(newTCRList.Recommend__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Explain_training_objectives__c == 'N/A' && 
                    newTCRList.Observe__c == 'N/A' &&
                    newTCRList.Critique__c == 'N/A' && 
                    newTCRList.Recommend__c == 'N/A') {
                        
                        averageList.add(new CallChartAverage(newTCRList.Account__r.Name, NULL));
                        
                    }
                
                else {
                    
                    if (sumOfCalls == 0 && numberOfCalls == 0) {
                        
                        averageList.add(new CallChartAverage(newTCRList.Account__r.Name, null));
                        
                    }
                    
                    else {
                        
                        Decimal aveList = sumOfCalls / numberOfCalls;
                        
                        averageList.add(new CallChartAverage(newTCRList.Account__r.Name, aveList.setScale(2, RoundingMode.HALF_UP)));
                        
                    }
                    
                }
                
            }
            
            return JSON.serialize(averageList);
            
        }
        
    }
    
    @AuraEnabled
    public static String getUserTheme() {
        
        return UserInfo.getUiThemeDisplayed();
        
    }
    
    @AuraEnabled
    public static List<Training_Contact_Report_Call__c> getTCRResult(String tcrID, String tcrType) {
        
        List<Training_Contact_Report_Call__c> listTCRAcct = [SELECT Account__c
                                                             FROM Training_Contact_Report_Call__c
                                                             WHERE (TCR__c = :tcrID)
                                                            ];
        
        List<Id> listAcctID = new List<Id>();
        
        for (Training_Contact_Report_Call__c newTCRList : listTCRAcct) {
            
            listAcctID.add(newTCRList.Account__c);
            
        }
        
        if (tcrType.equalsIgnoreCase('ACCOUNT TCR')) {
            
            return [SELECT Account__r.Name,
                    Review_Plans_Prior_to_Entering_Call__c,
                    Selling_Display_Area_Activities__c,
                    Collection_and_Settlements__c,
                    Presentation_Follow_thru_Negotiations__c,
                    Secure_Approval_and_Final_Agreements__c,
                    Post_Call_Activities__c
                    FROM Training_Contact_Report_Call__c
                    WHERE (TCR__c = :tcrID)
                    AND (Account__c IN :listAcctID)
                   ];
            
        }
        
        else {
            
            return [SELECT Account__r.Name,
                    Explain_training_objectives__c,
                    Observe__c,
                    Critique__c,
                    Recommend__c
                    FROM Training_Contact_Report_Call__c
                    WHERE (TCR__c = :tcrID)
                    AND (Account__c IN :listAcctID)
                   ];
            
        }
        
    }
    
    @AuraEnabled
    public static String getTCRType(String tcrID) {
        
        Training_Contact_Report__c tcrType = [SELECT RecordType.Name
                                              FROM Training_Contact_Report__c
                                              WHERE (Id = :tcrID)
                                             ];
        
        return tcrType.RecordType.Name;
        
    }
    
    @AuraEnabled
    public static List<Training_Contact_Report__c> getTCRTableResult(String tcrID, String tcrType) {
        
        if (tcrType.equalsIgnoreCase('MEETING TCR')) {
            
            return [SELECT Meeting_invites_ensure_attendance__c,
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
                    WHERE (Id = :tcrID)
                   ];
            
        }
        
        else {
            
            return [SELECT Bank_Guarantee__c,
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
                    WHERE (Id = :tcrID)
                   ];
            
        }
        
    }
    
    @AuraEnabled
    public static List<String> calculateTotalAverage(String tcrID, String tcrType) {
        
        if (tcrType.equalsIgnoreCase('ACCOUNT TCR')) {
            
            List<String> tcrData = new List<String>();
            
            List<Training_Contact_Report_Call__c> listOfTCR = [SELECT Review_Plans_Prior_to_Entering_Call__c,
                                                                      Selling_Display_Area_Activities__c,
                                                                      Collection_and_Settlements__c,
                                                                      Presentation_Follow_thru_Negotiations__c,
                                                                      Secure_Approval_and_Final_Agreements__c,
                                                                      Post_Call_Activities__c
                                                               FROM Training_Contact_Report_Call__c
                                                               WHERE (TCR__c = :tcrID)
                                                              ];
            
            Double sumOfAllCalls = 0;
            Double numberOfCalls = 0;
            
            Decimal totalAverage;
            
            for (Training_Contact_Report_Call__c newTCRList : listOfTCR) {
                
                if (newTCRList.Review_Plans_Prior_to_Entering_Call__c != 'N/A' && newTCRList.Review_Plans_Prior_to_Entering_Call__c != NULL) {
                    
                    sumOfAllCalls += Integer.valueOf(newTCRList.Review_Plans_Prior_to_Entering_Call__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Selling_Display_Area_Activities__c != 'N/A' && newTCRList.Selling_Display_Area_Activities__c != NULL) {
                    
                    sumOfAllCalls += Integer.valueOf(newTCRList.Selling_Display_Area_Activities__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Collection_and_Settlements__c != 'N/A' && newTCRList.Collection_and_Settlements__c != NULL) {
                    
                    sumOfAllCalls += Integer.valueOf(newTCRList.Collection_and_Settlements__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Presentation_Follow_thru_Negotiations__c != 'N/A' && newTCRList.Presentation_Follow_thru_Negotiations__c != NULL) {
                    
                    sumOfAllCalls += Integer.valueOf(newTCRList.Presentation_Follow_thru_Negotiations__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Secure_Approval_and_Final_Agreements__c != 'N/A' && newTCRList.Secure_Approval_and_Final_Agreements__c != NULL) {
                    
                    sumOfAllCalls += Integer.valueOf(newTCRList.Secure_Approval_and_Final_Agreements__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Post_Call_Activities__c != 'N/A' && newTCRList.Post_Call_Activities__c != NULL) {
                    
                    sumOfAllCalls += Integer.valueOf(newTCRList.Post_Call_Activities__c);
                    numberOfCalls++;
                    
                }
                
            }
            
            if (sumOfAllCalls == 0 && numberOfCalls == 0) {
                
                totalAverage = NULL;
                
            }
            
            else {
                
                totalAverage = sumOfAllCalls / numberOfCalls;
                totalAverage = totalAverage.setScale(2, RoundingMode.HALF_UP);
                
            }
            
            tcrData.add(String.valueOf(Integer.valueOf(sumOfAllCalls)));
            tcrData.add(String.valueOf(Integer.valueOf(numberOfCalls)));
            tcrData.add(String.valueOf(totalAverage));
            
            return tcrData;
            
        }
        
        else {
            
            List<String> tcrData = new List<String>();
            
            List<Training_Contact_Report_Call__c> listOfTCR = [SELECT Account__r.Name,
                                                               		  Explain_training_objectives__c,
                                                               		  Observe__c,
                                                               		  Critique__c,
                                                               		  Recommend__c
                                                               FROM Training_Contact_Report_Call__c
                                                               WHERE (TCR__c = :tcrID)
                                                              ];
            
            Double sumOfAllCalls = 0;
            Double numberOfCalls = 0;
            
            Decimal totalAverage;
            
            for (Training_Contact_Report_Call__c newTCRList : listOfTCR) {
                
                if (newTCRList.Explain_training_objectives__c != 'N/A' && newTCRList.Explain_training_objectives__c != NULL) {
                    
                    sumOfAllCalls += Integer.valueOf(newTCRList.Explain_training_objectives__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Observe__c != 'N/A' && newTCRList.Observe__c != NULL) {
                    
                    sumOfAllCalls += Integer.valueOf(newTCRList.Observe__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Critique__c != 'N/A' && newTCRList.Critique__c != NULL) {
                    
                    sumOfAllCalls += Integer.valueOf(newTCRList.Critique__c);
                    numberOfCalls++;
                    
                }
                
                if (newTCRList.Recommend__c != 'N/A' && newTCRList.Recommend__c != NULL) {
                    
                    sumOfAllCalls += Integer.valueOf(newTCRList.Recommend__c);
                    numberOfCalls++;
                    
                }
                
            }
            
            if (sumOfAllCalls == 0 && numberOfCalls == 0) {
                
                totalAverage = NULL;
                
            }
            
            else {
                
                totalAverage = sumOfAllCalls / numberOfCalls;
                totalAverage = totalAverage.setScale(2, RoundingMode.HALF_UP);
                
            }
            
            tcrData.add(String.valueOf(Integer.valueOf(sumOfAllCalls)));
            tcrData.add(String.valueOf(Integer.valueOf(numberOfCalls)));
            tcrData.add(String.valueOf(totalAverage));
            
            return tcrData;
            
        }
        
    }
    
}