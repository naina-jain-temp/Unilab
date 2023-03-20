/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   05.24.2017
Definition   :   Controller for Activity Management page for Overriden New button
History      :   05.24.2017 - Kiko Roberto:  Created
                 11.17.2017 - Angela Catimbang : Require Remarks/Analysis/Insights Field
-------------------------------------------------------------------------------------------*/
public class UNILAB_ActivityManagementOvrCX{

    public Event eventRecord{get;set;}
    public List<Sub_Activity__c> subActivityList{get;set;}
    public Sub_Activity__c subactivityRecord{get;set;}
    public Map<String,List<String>> activityMatrixMap;
    public Blob attchment{get;set;}
    private final Event eventStdRec;
    public String startDate{get;set;}
    public String startTime{get;set;}
    public String endDate{get;set;}
    public String endTime{get;set;}
    public Boolean isSucc;
    public String actJuncRemarks{get;set;}

    public UNILAB_ActivityManagementOvrCX(ApexPages.StandardController stdController){
        //initialize variables
        //String pageType = apexpages.currentpage().getparameters().get('type');
        isSucc = false;
        eventRecord = new Event();
        subactivityRecord = new Sub_Activity__c();
        subActivityList = new List<Sub_Activity__c>();
        //subActivityList.add(new Sub_Activity__c());
        //get values from Activity Dependency custom setting
        List<Activity_Dependency__c> activityMatrixList = Activity_Dependency__c.getAll().values();
        activityMatrixMap = getActivityMatrixMap(activityMatrixList);
        //this.eventStdRec = (Event)stdController.getRecord();
        eventRecord.StartDateTime = dateTime.Now();
        List<String> dtimeSplit = String.valueOf(eventRecord.StartDateTime).split(' ');
        List<String> timeSPlit = dtimeSplit[1].split(':');
        endDate = dtimeSplit[0];
        startDate = dtimeSplit[0];
        startTime = '08:30';
        endTime = '18:00';
        actJuncRemarks = '';

        eventRecord.Work_Plan__c = false;        
        eventRecord.OwnerId = UserInfo.getUserId();
        eventRecord.Created_from_Classic__c = true;
        
        system.Debug('***activityMatrixMap:'+ activityMatrixMap);
        /*eventRecord.Event_Type__c = 'Admin Work';
        eventRecord.Event_Sub_type__c = 'Operations';*/
    }
    
    //method for adding rows on repeat
    public void addRow(){
        
        subActivityList.add(new Sub_Activity__c());
        system.Debug('**subActivityList:' + subActivityList.size());
    }
    
    //method for removing rows on repeat
    public void removeRow(){
        subActivityList.remove(subActivityList.size()-1);
    }
    
    //method for retrieving Activity Matrix mapping depending on the user's role
    private Map<String,List<String>> getActivityMatrixMap(List<Activity_Dependency__c> activityMatList){
        Map<String,List<String>> activityMatrixMapRet = new Map<String,List<String>>();
        //iterate through the custom setting
        for(Activity_Dependency__c ad : activityMatList){
            //get only values where applicable to the user's role
            //.substring(0,15)
            if(String.valueOf(UserInfo.getUserRoleId()) == ad.Role_ID__c){
                if(!activityMatrixMapRet.containsKey(ad.Event_Sub_Type__c)){
                    activityMatrixMapRet.put(ad.Event_Sub_Type__c, new List<String>{ad.Activity_Name__c});
                }else {
                    activityMatrixMapRet.get(ad.Event_Sub_Type__c).add(ad.Activity_Name__c);
                }   
            }
        }
        return activityMatrixMapRet;
    }
    
    //select option for sub activity-- this dynamically changes depending on the activity matrix mappinh
    //ex. different user role will result to different values
    public List<SelectOption> getActivityMatrixList(){
        List<SelectOption> ActivityMatrixList = new List<SelectOption>();
        ActivityMatrixList.add(new SelectOption( '' ,'--None--'));
        if(eventRecord.Event_Sub_type__c != null){
            for(String s : activityMatrixMap.get(eventRecord.Event_Sub_type__c))
            {
                ActivityMatrixList.add(new SelectOption(s,s));
            }   
        }
        
        return ActivityMatrixList;
    }
    
    public PageReference save(){
     
        //create the event record and sub activities
        createEvent();
        //if succesfully created return event id
        if(eventRecord.Id != null){
            return new PageReference('/'+String.valueOf(eventRecord.Id));
        }       
        return null;
    }
    
    public PageReference saveAndNewTask(){
      //Angela: Require Remarks/Analysis/Insights'
       if(eventRecord.Event_Type__c == 'Call' && actJuncRemarks == ''){
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,'Required Field: Remarks/Analysis/Insights'));    
             return null; 
         }
        //create the event record and sub activities
        eventRecord.Status__c = 'Completed';
        createEvent();
        //if succesfully created return event id
        if(eventRecord.Id != null){
            return new PageReference('/00T/e?retURL='+String.valueOf(eventRecord.Id));
        }       
        return null;
    }

    public PageReference saveAndClone(){
        //create the event record and sub activities
        Boolean isSaved = false;
        //eventRecord.Id = null;
        createEvent();
        if(eventRecord.Id != null){
            isSaved = true;
        }
        //reset ids so we can reuse the records for cloning
        eventRecord.Id = null;
        subActivityList = new List<Sub_Activity__c>();
        /*if(subActivityList != null && !subActivityList.isEmpty()){
            for(Sub_Activity__c sa : subActivityList){
                sa.Id = null;
            }            
        }*/
        if(isSaved){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Work Plan saved'));
        }      
        return null;
    }
    
    public PageReference cancel(){
        return new PageReference('/home/home.jsp');
    }
    
    //updates event to cancelled status and redirects to page to select reason for cancellation
    public PageReference cancelStatus(){

      //Angela :  Require Remarks/Analysis/Insights Field
         if(eventRecord.Event_Type__c == 'Call' && actJuncRemarks == ''){
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,'Required Field: Remarks/Analysis/Insights'));    
             return null; 
         }
        //create the event record and sub activities
        //eventRecord.Status__c = 'Cancelled';
        createEvent();
        //if succesfully created return event id
        if(eventRecord.Id != null && isSucc){
            return new PageReference('/apex/UNILAB_EventCancellationPage?id='+String.valueOf(eventRecord.Id));
        }       
        return null;
    }
    
    //updates event to cancelled status and redirects to page to select reason for cancellation
    public PageReference completeStatus(){
       //Angela: Require Remarks/Analysis/Insights'
       if(eventRecord.Event_Type__c == 'Call' && actJuncRemarks == ''){
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,'Required Field: Remarks/Analysis/Insights'));    
             return null; 
         }
        //create the event record and sub activities
        eventRecord.Status__c = 'Completed';
        createEvent();
        //if succesfully created return event id
        if(eventRecord.Id != null && isSucc){
            return new PageReference('/'+String.valueOf(eventRecord.Id));
        }       
        return null;
    }
    
    //method that validates event creation if workplan is set to true
    private Boolean validateEvent(){
        Boolean isValid = true;
        system.Debug('**startDate: '+startDate);
        system.Debug('**startT: '+startTime);
        system.Debug('**endDate: '+endDate);
        system.Debug('**endt: '+endTime);
        if(eventRecord.Work_Plan__c && Date.today().day() > Event_Deadline__c.getOrgDefaults().Day_of_End_Date__c &&
           eventRecord.StartDateTime.Month() <= Date.today().Month()){
            isValid = false;
        }
        return isValid;
    }
    
    //method called to create an event and its sub activities
    private void createEvent(){
        isSucc = false;
        if(startDate != '' && startTime != ''){
            //List<String> dateTimeSplit = startDate.split('-');
            List<String> dateValList = startDate.split('-'); 
            List<String> timeValList = startTime.split(':');
            Date myStartDate = Date.newInstance(Integer.valueOf(dateValList[0]), Integer.valueOf(dateValList[1]), Integer.valueOf(dateValList[2]));
            Time myStartTime = Time.newInstance(Integer.valueOf(timeValList[0]), Integer.valueOf(timeValList[1]),0,0);
            eventRecord.StartDateTime = DateTime.newInstance(myStartDate,myStartTime);
        } 
        
        if(endDate != '' && endTime != ''){
            //List<String> dateTimeSplit = endDate.split('T');
            List<String> dateValList = endDate.split('-'); 
            List<String> timeValList = endTime.split(':');
            Date myEndDate = Date.newInstance(Integer.valueOf(dateValList[0]), Integer.valueOf(dateValList[1]), Integer.valueOf(dateValList[2]));
            Time myEndTime = Time.newInstance(Integer.valueOf(timeValList[0]), Integer.valueOf(timeValList[1]),0,0);
            eventRecord.EndDateTime = DateTime.newInstance(myEndDate,myEndTime);
        }      
        //validate if creation of event isn't over the deadline if Workplan = true
        if(validateEvent()){
            if(eventRecord != null){
                try{

                    
                    //create the event record
                    insert eventRecord;

                    //create new parent Activity Junction Record
                    Activity_Junction__c actJunctionParent = populateActJunc(eventRecord);
                    /*Activity_Junction__c actJunctionParent = new Activity_Junction__c(Account_ID__c = eventRecord.Related_To_Account__c,
                                                                                      Subject__c = eventRecord.Subject,
                                                                                      Start_Date__c = eventRecord.StartDateTime,
                                                                                      End_Date__c = eventRecord.EndDateTime,
                                                                                      All_Day_Event__c = eventRecord.IsAllDayEvent,
                                                                                      Location__c = eventRecord.Location,
                                                                                      Location_Based__c = eventRecord.Location_Based__c,
                                                                                      Related_to_Account__c = eventRecord.Related_To_Account__c,
                                                                                      Notes_Comments__c = eventRecord.Notes_Comments__c,
                                                                                      Event_Type__c = eventRecord.Event_Type__c,
                                                                                      Event_Sub_type__c = eventRecord.Event_Sub_Type__c,
                                                                                      OwnerId = eventRecord.OwnerId,
                                                                                      Status__c = eventRecord.Status__c,
                                                                                      Reason_for_Cancellation__c = eventRecord.Reason_for_Cancellation__c,
                                                                                      Others__c = eventRecord.Others__c,
                                                                                      Validated__c = eventRecord.Validated__c,
                                                                                      Work_Plan__c = eventRecord.Work_Plan__c,
                                                                                      Event_ID__c = eventRecord.Id,
                                                                                      Remarks_Analysis_Insights__c = actJuncRemarks,
                                                                                      Target_Order__c = eventRecord.Target_Order__c,
                                                                                      Actual_Order__c = eventRecord.Actual_Order__c,
                                                                                      Amount_Collection__c = eventRecord.Amount_Collection__c,
                                                                                      Target_Collection__c = eventRecord.Target_Collection__c);*/
                    actJunctionParent.Event_ID__c = eventRecord.Id;
                    actJunctionParent.Validated__c = eventRecord.Validated__c;
                    insert actJunctionParent;

                    //update the event record to the parent junction
                    if(actJunctionParent != null){
                        eventRecord.Activity_Junction__c = actJunctionParent.Id;
                        update eventRecord;

                        //Check if event type = Call and do inserts for survey forms
                        if(eventRecord.Event_Type__c == 'Call'){
                        //Survey_Summary_Form__c
                        List<Survey_Summary_Form__c> ssfList = new List<Survey_Summary_Form__c>();
                        Account acctRec = new Account();
                        if(eventRecord.Related_To_Account__c != null){
                            acctRec = [SELECT Id, Team__c, Name FROM Account WHERE Id =: eventRecord.Related_To_Account__c];
                        }
                        if(acctRec.Id != null){
                            ssfList = [SELECT Id,
                                          Name,
                                          Active__c,
                                          Activity_Name__c,
                                          Start_Date__c,
                                          End_Date__c,
                                          Team__c,
                                          Assign_to_Account__c,
                                          RecordTypeId,
                                          Account__c,
                                          SSF_Name_Backend__c,
                                          Survey_Summary_Form_Name__c,
                                          Event_Sub_type__c,
                                          (SELECT Id,
                                                  Account__c,
                                                  Answer__c,
                                                  Backroom__c,
                                                  Product__c,
                                                  Shelf__c,
                                                  Survey_Question__c,
                                                  Survey_Summary_Form__c,
                                                  Weight__c,
                                                  RecordTypeId
                                           FROM Survey_Forms__r)
                                   FROM Survey_Summary_Form__c 
                                   WHERE Parent_SSF__c = null
                                   AND Active__c = true 
                                   AND Activity_Name__c IN: activityMatrixMap.get(eventRecord.Event_Sub_type__c)
                                   AND Event_Sub_type__c =: eventRecord.Event_Sub_type__c
                                   AND Start_Date__c <=: Date.valueOf(eventRecord.StartDateTime)
                                   AND End_Date__c >=: Date.valueOf(eventRecord.EndDateTime)
                                   AND (Team__c =: acctRec.Team__c OR Assign_to_Account__c =: acctRec.Id)];
                            system.Debug('***ssfList: '+ssfList);
                        }
                        
                        if(ssfList != null && !ssfList.isEMpty()){
                            List<Survey_Summary_Form__c> ssfListToInsert = new List<Survey_Summary_Form__c>();
                            List<Survey_Form__c> sfListToInsert = new List<Survey_Form__c>();
                            for(Survey_Summary_Form__c ssf : ssfList){
                            
                                Survey_Summary_Form__c ssfTemp = new Survey_Summary_Form__c(Name = ssf.Name+' - '+ acctRec.Name,
                                                                                            Activity_Name__c = ssf.Activity_Name__c,
                                                                                            Start_Date__c = ssf.Start_Date__c,
                                                                                            End_Date__c = ssf.End_Date__c,
                                                                                            Team__c = ssf.Team__c,
                                                                                            Assign_to_Account__c = ssf.Assign_to_Account__c,
                                                                                            RecordTypeId = ssf.RecordTypeId,
                                                                                            Account__c = eventRecord.Related_To_Account__c,
                                                                                            Parent_SSF__c = ssf.Id,
                                                                                            Event_Sub_type__c = ssf.Event_Sub_type__c);
                                if(ssfTemp.Name.length() > 80){
                                  ssfTemp.SSF_Name_Backend__c = ssfTemp.Name;
                                  ssfTemp.Name = ssfTemp.Name.subString(0,79);
                                }

                                ssfListToInsert.add(ssfTemp);
                                /*ssfListToInsert.add(new Survey_Summary_Form__c(Name = ssf.Name+' - '+ acctRec.Name,
                                                                               Activity_Name__c = ssf.Activity_Name__c,
                                                                               Start_Date__c = ssf.Start_Date__c,
                                                                               End_Date__c = ssf.End_Date__c,
                                                                               Team__c = ssf.Team__c,
                                                                               Assign_to_Account__c = ssf.Assign_to_Account__c,
                                                                               RecordTypeId = ssf.RecordTypeId,
                                                                               Account__c = eventRecord.Related_To_Account__c,
                                                                               Parent_SSF__c = ssf.Id,
                                                                               Event_Sub_type__c = ssf.Event_Sub_type__c));*/
                                for(Survey_Form__c sf : [Select Account__c, Answer__c, Backroom__c, Product__c,Shelf__c,Survey_Question__c,Weight__c, RecordTypeId,
                                                          Survey_Summary_Form__c,Sort__c FROM Survey_Form__c WHERE Survey_Summary_Form__c =: ssf.Id ORDER BY Sort__c ASC]){

                                    sfListToInsert.add(new Survey_Form__c(Account__c = eventRecord.Related_To_Account__c,
                                                                          Answer__c = sf.Answer__c,
                                                                          Backroom__c = sf.Backroom__c,
                                                                          Product__c = sf.Product__c,
                                                                          Shelf__c = sf.Shelf__c,
                                                                          Survey_Question__c = sf.Survey_Question__c,
                                                                          Weight__c = sf.Weight__c,
                                                                          RecordTypeId = sf.RecordTypeId,
                                                                          Survey_Summary_Form__c = ssf.Id,
                                                                          Sort__c = sf.Sort__c));
                                }
                            }

                            if(ssfListToInsert != null && !ssfListToInsert.isEmpty()){
                                insert ssfListToInsert;

                                for(Survey_Summary_Form__c ssf : ssfListToInsert){
                                    for(Survey_Form__c sf : sfListToInsert){
                                        if(ssf.Parent_SSF__c == sf.Survey_Summary_Form__c){
                                            sf.Survey_Summary_Form__c = ssf.Id;
                                        }
                                    }  
                                }

                                if(sfListToInsert != null && !sfListToInsert.isEmpty()){
                                    insert sfListToInsert;
                                }
                                
                                for(Survey_Summary_Form__c ssf : ssfListToInsert){
                                    subActivityList.add(new Sub_Activity__c(Activity_Name__c = ssf.Activity_Name__c,
                                                                            Survey_Summary_Form__c = ssf.Id));
                                }
                            }                           
                        }
                    }
                        //create sub activity child records
                        if(subActivityList != null && !subActivityList.isEmpty()){
                            List<Sub_Activity__c> subActToInsertList = new List<Sub_Activity__c>();
                            for(Sub_Activity__c sa : subActivityList){
                                if(sa.Activity_Name__c != null && sa.Activity_Name__c != ''){
                                    sa.Activity_Junction__c = actJunctionParent.Id;
                                    subActToInsertList.add(sa);
                                }
                                
                            }
                            
                            if(subActToInsertList != null && !subActToInsertList.isEmpty()){
                                insert subActToInsertList;
                            }                                                   
                        }       
                    }
                    //flag for knowing process is done without errors
                    isSucc = true;
                  }
                catch(Exception ex){
                    system.Debug(ex.getMessage());
                    ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0) );
                    ApexPages.addMessage(msg);
                }                         
            }
        }else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'You can not create a work plan after the deadline. Please create this as an unplanned activity.'));
        }
    }
    
    public void getStartDate(){
        //List<String> dateTimeSplit = startDate.split('-');
        List<String> dateValList = startDate.split('-'); 
        //List<String> timeValList = dateTimeSplit[1].split(':');
        Date myStartDate = Date.newInstance(Integer.valueOf(dateValList[0]), Integer.valueOf(dateValList[1]), Integer.valueOf(dateValList[2]));
        //Time myStartTime = Time.newInstance(Integer.valueOf(timeValList[0]), Integer.valueOf(timeValList[1]),0,0);
        //eventRecord.StartDateTime = DateTime.newInstance(myStartDate,myStartTime);
        //DateTime.valueOf(startDate).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        system.Debug('**startDate: '+startDate);
    }
    
    public void getStartTime(){
        //List<String> dateTimeSplit = startDate.split('-');
        //List<String> dateValList = startDate.split('-'); 
        List<String> timeValList = startTime.split(':');
        //Date myStartDate = Date.newInstance(Integer.valueOf(dateValList[0]), Integer.valueOf(dateValList[1]), Integer.valueOf(dateValList[2]));
        Time myStartTime = Time.newInstance(Integer.valueOf(timeValList[0]), Integer.valueOf(timeValList[1]),0,0);
        //eventRecord.StartDateTime = DateTime.newInstance(myStartDate,myStartTime);
        //DateTime.valueOf(startDate).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        system.Debug('**startDate: '+startDate);
    }
    
    public void getEndDate(){
        //List<String> dateTimeSplit = endDate.split('T');
        List<String> dateValList = endDate.split('-'); 
        //List<String> timeValList = dateTimeSplit[1].split(':');
        Date myEndDate = Date.newInstance(Integer.valueOf(dateValList[0]), Integer.valueOf(dateValList[1]), Integer.valueOf(dateValList[2]));
        //Time myEndTime = Time.newInstance(Integer.valueOf(timeValList[0]), Integer.valueOf(timeValList[1]),0,0);
        //eventRecord.StartDateTime = DateTime.newInstance(myEndDate ,myEndTime);
        //DateTime.valueOf(startDate).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        system.Debug('**endDate: '+endDate);
    }
    
    public void getEndTime(){
        //List<String> dateTimeSplit = startDate.split('-');
        //List<String> dateValList = startDate.split('-'); 
        List<String> timeValList = endTime.split(':');
        //Date myStartDate = Date.newInstance(Integer.valueOf(dateValList[0]), Integer.valueOf(dateValList[1]), Integer.valueOf(dateValList[2]));
        Time myEndTime = Time.newInstance(Integer.valueOf(timeValList[0]), Integer.valueOf(timeValList[1]),0,0);
        //eventRecord.StartDateTime = DateTime.newInstance(myStartDate,myStartTime);
        //DateTime.valueOf(startDate).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        system.Debug('**startDate: '+startDate);
    }

    public Activity_Junction__c populateActJunc(Event e)
    {
        List<Event_Activity_Junction_Fields__c> eventActJuncFieldList = Event_Activity_Junction_Fields__c.getAll().values();
        Activity_Junction__c actJunctionParent = new Activity_Junction__c();
        if(eventActJuncFieldList != null && !eventActJuncFieldList.isEmpty()){
            for(Event_Activity_Junction_Fields__c eajf : eventActJuncFieldList){

                actJunctionParent.put(eajf.Target_Field_API__c, e.get(eajf.Source_Field_API__c));    
            }  
            actJunctionParent.Remarks_Analysis_Insights__c = actJuncRemarks;
        }

        return actJunctionParent;
    }
}