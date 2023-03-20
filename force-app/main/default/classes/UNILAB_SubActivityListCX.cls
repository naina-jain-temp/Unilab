/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.13.2017
Definition   :   Controller for UNILAB_SubActivityList page
History      :   07.13.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
public class UNILAB_SubActivityListCX{
    
    public List<Sub_Activity__c> subActMasterList{get;set;}
    public List<Sub_Activity__c> subActList{get;set;}
    public List<Survey_Summary_Form__c> surveyList{get;set;}
    public List<SSFWrapper> sWrapList {get;set;}
    public Event eventRec;
    public UNILAB_SubActivityListCX(ApexPages.StandardController stdController){
        this.eventRec = (Event)stdController.getRecord();
        eventRec = [SELECT Activity_Junction__c FROM Event WHERE Id=: eventRec.Id];
        subActList = new List<Sub_Activity__c>();
        surveyList = new List<Survey_Summary_Form__c>();
        sWrapList = new List<SSFWrapper>();
        subActMasterList = new List<Sub_Activity__c>();
        if(eventRec.Activity_Junction__c != null){
            subActMasterList = [SELECT Id,
                                 Name,
                                 Activity_Name__c,
                                 Survey_Summary_Form__c,
                                 Survey_Summary_Form__r.Name,
                                 Survey_Summary_Form__r.Survey_Rating_Final__c,
                                 Survey_Summary_Form__r.Answered__c,
                                 Survey_Summary_Form__r.SSF_Name_Backend__c,
                                 Survey_Summary_Form__r.Activity_Name__c,
                                 Survey_Summary_Form__r.Survey_Summary_Form_Name__c,
                                 Survey_Summary_Form__r.Inline_VF_Sort__c,
                                 Survey_Summary_Form__r.RecordTypeId
                          FROM Sub_Activity__c
                          WHERE Activity_Junction__c =: eventRec.Activity_Junction__c
                          ORDER BY Survey_Summary_Form__r.Inline_VF_Sort__c ASC];
                                         
            if(subActMasterList.size()==0){
                subActMasterList = null;
            }else{
                Map<Id, SSFWrapper> ssfMap = new Map<Id, SSFWrapper>();
                for(Sub_Activity__c sa : subActMasterList){
                    if(sa.Survey_Summary_Form__c == null){
                        subActList.add(new Sub_Activity__c(id = sa.Id,Activity_Name__c = sa.Activity_Name__c));
                    }else{
                        //surveyList.add(new Survey_Summary_Form__c(Id=sa.Survey_Summary_Form__c, Name = sa.Survey_Summary_Form__r.Survey_Summary_Form_Name__c));
                        Survey_Summary_Form__c ssForm = new Survey_Summary_Form__c(Id=sa.Survey_Summary_Form__c, Name = sa.Survey_Summary_Form__r.Survey_Summary_Form_Name__c);  
                        //SSFWrapper sw = new SSFWrapper(ssForm, sa.Survey_Summary_Form__r.Name_and_Survey_Rating__c, sa.Survey_Summary_Form__r.Answered__c); 
                        SSFWrapper sw = new SSFWrapper(ssForm, sa.Survey_Summary_Form__r.Survey_Rating_Final__c, sa.Survey_Summary_Form__r.Name, sa.Survey_Summary_Form__r.Answered__c); 

                        ssfMap.put(ssForm.Id, sw); 
                    } 
                }
                
                if(subActList.size() == 0){
                    subActList = null;
                }
                
                sWrapList = ssfMap.values();
                if(sWrapList.size() == 0){
                    sWrapList = null;
                }
            }
        }     
    }
    
    public class SSFWrapper {
    
        public Survey_Summary_Form__c ssForm {get;set;}
        public String fieldValue {get;set;}
        public String fieldValue2 {get;set;}
        public Boolean img {get;set;}
        
        public SSFWrapper(Survey_Summary_Form__c ssForm, String fieldValue, String fieldValue2, Boolean img) {
            this.ssForm = ssForm;
            this.fieldValue = fieldValue;
            this.fieldValue2 = fieldValue2;  
            this.img = img;
        }     
    
    }
    
       
}