// Author: Gizelle Latosa
// Company: Third Pillar
// Date Created: 2/22/2018

public class UNILAB_SurveySummaryFormController {
        
        public static void computeEventRatings(List<Survey_Summary_Form__c> sFormList) {
        
            Set<Id> ssfId = new Set<Id>();
            Set<Id> ajId = new Set<Id>();
            Set<Id> actJuncIds = new Set<Id>(); 
            Set<Id> eIds = new Set<Id>();
            Decimal questionSurveyRating = 0;
            Decimal invAvailSurveyRating = 0;
            Decimal invNumSurveyRating = 0;
            Decimal invStatSurveyRating = 0;
            Decimal questionTotalRating = 0;
            Decimal invAvailTotalRating = 0;
            Decimal invNumTotalRating = 0;   
            Decimal invStatTotalRating = 0;
            Decimal callEffCountClicked = 0;
            Decimal callEffSfCount = 0;    
            Decimal sNum = 0;
            Decimal sDenom = 0;
            Decimal callEffNum = 0;
            Decimal callEffDenom = 0;
            
            Decimal questionCallEff = 0;
            Decimal invAvailCallEff = 0;
            Decimal invNumCallEff = 0;
            Decimal invStatCallEff = 0;
            
            for(Survey_Summary_Form__c ssf : sFormList) {
                  ssfId.add(ssf.Id); 
            }    
            
            List<Survey_Summary_Form__c> ssfList = [SELECT Id, Name, Total_Questionnaire_Yes_Weight__c, Total_Questionnaire_Survey_Form__c,
                                                Total_Inventory_Availability_Yes_Weight__c, Total_Availability_Survey_Forms_Weight__c,
                                                Total_Inventory_Status_Yes_Rating__c, Total_Inventory_Status_Count__c, Backroom_Shelf_Total__c,
                                                Total_Survey_Form_Count__c, (SELECT Id, Name, Activity_Junction__c FROM Sub_Activities__r) FROM Survey_Summary_Form__c WHERE
                                                Id IN: ssfId];
                                                
            system.debug('>>ssfList>>' + ssfList);  
        
            for(Sub_Activity__c sa : ssfList[0].Sub_Activities__r) {
                ajId.add(sa.Activity_Junction__c);
            }    
         
            List<Sub_Activity__c> saList = [SELECT Id, Name, Activity_Junction__c, Survey_Summary_Form__c, Survey_Summary_Form__r.Name, Survey_Summary_Form__r.RecordType.Name, Survey_Summary_Form__r.Parent_SSF__c, 
                                        Survey_Summary_Form__r.Survey_Rating__c, Survey_Summary_Form__r.Record_View_Score__c, Survey_Summary_Form__r.Inventory_Number_Survey_Rating__c,  
                                        Survey_Summary_Form__r.Inventory_Status_Survey_Rating__c, Survey_Summary_Form__r.Inventory_Availability_Survey_Rating__c, Survey_Summary_Form__r.Questionnaire_Survey_Rating__c,
                                        Survey_Summary_Form__r.Total_Questionnaire_Survey_Form__c, Survey_Summary_Form__r.Total_Availability_Survey_Forms_Weight__c, Survey_Summary_Form__r.Total_Availability_Survey_Forms__c, Survey_Summary_Form__r.Survey_Rating_Final__c,
                                        Survey_Summary_Form__r.Total_Inventory_Number_Survey_Form__c, Survey_Summary_Form__r.Total_Inventory_Status_Survey_Form__c, Survey_Summary_Form__r.Answered__c 
                                        FROM Sub_Activity__c WHERE Activity_Junction__c IN: ajId AND Survey_Summary_Form__r.Parent_SSF__c != NULL AND Survey_Summary_Form__r.Survey_Rating__c != NULL]; 
        
            system.debug('>>saList>>' + saList);
        
            List<Event> eventList = [SELECT Id, Activity_Junction__c, Survey_Rating__c, Call_Efficiency__c FROM Event WHERE Activity_Junction__c IN:
                                 ajId];             
        
            system.debug('>>eventList>>' + eventList); 
        
            for(Sub_Activity__c sa : saList) {
             
                if(sa.Survey_Summary_Form__r.RecordType.Name == 'Questionnaire' && sa.Survey_Summary_Form__r.Answered__c) {
                    if(sa.Survey_Summary_Form__r.Survey_Rating_Final__c == 'Not Applicable') {
                        questionSurveyRating = 0;
                        questionTotalRating = 0;
                        questionCallEff += 1;
                    }
                    else {
                        questionSurveyRating = sa.Survey_Summary_Form__r.Questionnaire_Survey_Rating__c;
                        questionTotalRating = sa.Survey_Summary_Form__r.Total_Questionnaire_Survey_Form__c; 
                        questionCallEff += 1;
                    }
                
                system.debug('>>questionSurveyRating>>' + questionSurveyRating);
                system.debug('>>questionTotalRating>>' + questionTotalRating);
                }
                if(sa.Survey_Summary_Form__r.RecordType.Name == 'Inventory Availability' && sa.Survey_Summary_Form__r.Answered__c) {
                    if(sa.Survey_Summary_Form__r.Survey_Rating_Final__c == 'Not Applicable') {
                        invAvailSurveyRating = 0;
                        invAvailTotalRating = 0;
                        invAvailCallEff += 1;
                    }
                    else {
                        invAvailSurveyRating = sa.Survey_Summary_Form__r.Inventory_Availability_Survey_Rating__c;
                        invAvailTotalRating = sa.Survey_Summary_Form__r.Total_Availability_Survey_Forms__c;
                        invAvailCallEff += 1;
                    }
             
                system.debug('>>invAvailSurveyRating>>' + invAvailSurveyRating);
                system.debug('>>invAvailTotalRating>>' + invAvailTotalRating);
                }
                if(sa.Survey_Summary_Form__r.RecordType.Name == 'Inventory Number' && sa.Survey_Summary_Form__r.Answered__c) {
                    invNumSurveyRating = sa.Survey_Summary_Form__r.Inventory_Number_Survey_Rating__c;
                    invNumTotalRating = sa.Survey_Summary_Form__r.Total_Inventory_Number_Survey_Form__c;
                    invNumCallEff += 1;
                 
                    system.debug('>>invNumSurveyRating>>' + invNumSurveyRating);
                    system.debug('>>invNumTotalRating>>' + invNumTotalRating);
                } 
                if(sa.Survey_Summary_Form__r.RecordType.Name == 'Inventory Status' && sa.Survey_Summary_Form__r.Answered__c) {
                    if(sa.Survey_Summary_Form__r.Survey_Rating_Final__c == 'Not Applicable') {
                        invStatSurveyRating = 0;
                        invStatTotalRating = 0;  
                        invStatCallEff += 1;
                    }    
                    else {
                        invStatSurveyRating = sa.Survey_Summary_Form__r.Inventory_Status_Survey_Rating__c;
                        invStatTotalRating = sa.Survey_Summary_Form__r.Total_Inventory_Status_Survey_Form__c;  
                        invStatCallEff += 1;
                    }
                    
                 
                    system.debug('>>invStatSurveyRating>>' + invStatSurveyRating);
                    system.debug('>>invStatTotalRating>>' + invStatTotalRating);
                }
                
            }
                   
            callEffSfCount = saList.size();
            callEffNum = questionCallEff + invAvailCallEff + invNumCallEff + invStatCallEff;
            callEffDenom = callEffSfCount;
        
            system.debug('>>callEffNum>>' + callEffNum); 
            system.debug('>>callEffDenom>>' + callEffDenom);
             
            sNum = questionSurveyRating + invAvailSurveyRating + invNumSurveyRating + invStatSurveyRating;      
            sDenom = questionTotalRating + invAvailTotalRating + invNumTotalRating + invStatTotalRating;    
        
            system.debug('>>sNum>>' + sNum); 
            system.debug('>>sDenom>>' + sDenom);
        
            for(Event e : eventList) {
                if(sDenom > 0) {
                    e.Survey_Rating__c = sNum/sDenom;
                }
                
                if(callEffDenom > 0) {
                    e.Call_Efficiency__c = callEffNum/callEffDenom; 
                }             
            }
         
            update eventList;
            system.debug('>>eventList>>' + eventList);         
                
        }
        
        public static void computeAnsweredCount(Set<Id> ids) {
        
            List<Survey_Summary_Form__c> ssfList = new List<Survey_Summary_Form__c>();
          
            Decimal ansCount = 0;
         
            ssfList = [SELECT Id, Name, AnsweredCount__c, (SELECT Id, Name, Answered__c FROM Survey_Forms__r WHERE Answered__c = TRUE) FROM Survey_Summary_Form__c WHERE Id IN: ids];
         
            for(Survey_Summary_Form__c ssf : ssfList) {
        
                for(Survey_Form__c sf : ssf.Survey_Forms__r) {
                    ansCount = ssf.Survey_Forms__r.size();              
                }
                
                ssf.AnsweredCount__c = ansCount; 
        
            }
          
            update ssfList;
            system.debug('>>ansCount>>' + ansCount);
        
        } 
        
}