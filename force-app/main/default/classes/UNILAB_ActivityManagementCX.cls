/*-------------------------------------------------------------------------------------------
Author       :   Manuelito Ortega
Created Date :   05.24.2017
Definition   :   Controller for Activity Management page
-------------------------------------------------------------------------------------------*/
public with sharing class  UNILAB_ActivityManagementCX {

    public Event eventRecord {get; set;}
    
    public List<Sub_Activity__c> subActivityList {get; set;}
    
    public Id recordId;
    
    public String actJuncRemarks {get; set;}    
    public User userRecord {get; set;}
    public User userWorkWith {get; set;}
    public String userRole {get; set;}
    private static final String tcrObject = 'Training_Contact_Report__c';
    public UNILAB_ActivityManagementCX(){
  
    }
    public UNILAB_ActivityManagementCX(ApexPages.StandardController stndController) {
        
        recordId = apexpages.currentPage().getParameters().get('Id');
        
        userRole = getUserRole();
        
        eventRecord = new Event();
        
        subActivityList = new List<Sub_Activity__c>();
        
        if (recordId != NULL) {
            
            eventRecord = [SELECT Id,
                           OwnerId,
                           Event_Type__c,
                           Event_Sub_type__c,
                           IsAllDayEvent,
                           StartDateTime,
                           EndDateTime,
                           Location_Custom__c,
                           Mode_of_Contact__c,
                           Location_Based__c,
                           Description,
                           Work_Plan__c,
                           Validated__c,
                           Related_To_Account__c,
                           WhoId,
                           Activity_Junction__c,
                           Activity_Junction__r.Remarks_Analysis_Insights__c,
                           Target_Order__c,
                           Actual_Order__c,
                           Target_Collection__c,
                           Amount_Collection__c,
                           Work_With_ID__c,
                           TCR_Id__c,
                           TCR_Name__c,
                           TCR_Type__c
                           FROM Event
                           WHERE (Id = :recordId)
                          ];
            
            if (eventRecord != NULL) {
                
                subActivityList = [SELECT Id,
                                   Activity_Name__c,
                                   Remarks__c,
                                   Agenda__c,
                                   Attendees__c,
                                   Discussions__c,
                                   Next_Steps_Directions__c,
                                   Objectives__c,
                                   Learnings_Insights__c,
                                   Requirements_Submitted__c
                                   FROM Sub_Activity__c
                                   WHERE (Activity_Junction__c = :eventRecord.Activity_Junction__c)
                                  ];
                
                if (eventRecord.OwnerId != NULL) {
                    userRecord = [SELECT Name,
                                         SmallPhotoURL
                                  FROM User
                                  WHERE (Id = :eventRecord.OwnerId)
                                 ];
                }
                
                if (eventRecord.Work_With_ID__c != NULL) {
                    
                    userWorkWith = [SELECT Name
                                    FROM User
                                    WHERE (Id = :eventRecord.Work_With_ID__c)
                                   ];
                    
                }
                
            }
            
            actJuncRemarks = eventRecord.Activity_Junction__r.Remarks_Analysis_Insights__c;
            
        }
        
    }
    public PageReference closeButtonLightning() {
        return new PageReference('/lightning/page/home');
    }
    public static String getRecordId(){
        return ApexPages.currentPage().getParameters().get('id');
    }
    /*
    public static String getUserRole(){
        
        Id uRoleId = UserInfo.getUserRoleId();
        UserRole role = [SELECT Id,Name FROM UserRole WHERE Id = :uRoleId];
        if(role.Name.contains('Team Lead') || role.Name.contains('TL')||role.Name.contains('Nat Ops Head')){
            return 'Team Lead';
        }else if(role.Name.contains('CDS')){
            return 'CDS';
        }else if(role.Name.contains('System Administrator')){
            return 'Administrator';
        }
        return 'NA';
            
    }*/
    public static String getUserRole(){
        
        Id uRoleId = UserInfo.getUserRoleId();
        UserRole role = [SELECT Id,Name FROM UserRole WHERE Id = :uRoleId];
        if(role.Name.contains('Team Lead') || role.Name.contains('TL')||role.Name.contains('Nat Ops Head')||
           role.Name.contains('National Operations Lead')||role.Name.contains('SNCD Head')){
            return 'Team Lead';
        }else if(role.Name.contains('CDS')){
            return 'CDS';
        }else if(role.Name.contains('System Administrator')){
            return 'Administrator';
        }
        return 'NA';
            
    }
    public static Activity_Junction__c populateActJunc(Event e,String actJuncRemarks){
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
    //method for retrieving Activity Matrix mapping depending on the user's role
    public static Map<String,List<String>> getActivityMatrixMap(){
        List<Activity_Dependency__c> activityMatList = Activity_Dependency__c.getAll().values();
        Map<String,List<String>> activityMatrixMapRet = new Map<String,List<String>>();
        String myChannel = [SELECT Channel__c FROM User WHERE Id =: UserInfo.getUserId()][0].Channel__c;
        System.debug('kc' + myChannel);
        //iterate through the custom setting
        for(Activity_Dependency__c ad : activityMatList){
            //get only values where applicable to the user's role and channel (channel__c field recently applied to condition)
            //.substring(0,15)
            if(String.valueOf(UserInfo.getUserRoleId()) == ad.Role_ID__c){

                if(String.valueOf(myChannel) == ad.Channel__c) {
                     System.debug('loop kc' + activityMatrixMapRet);
                    if(!activityMatrixMapRet.containsKey(ad.Event_Sub_Type__c)){
                         System.debug('loop2 kc' + activityMatrixMapRet);
                        activityMatrixMapRet.put(ad.Event_Sub_Type__c, new List<String>{ad.Activity_Name__c});
                    }else {
                        activityMatrixMapRet.get(ad.Event_Sub_Type__c).add(ad.Activity_Name__c);
                    }   
                }
            }
        }
        System.debug('activityMatrixMapRet' + activityMatrixMapRet);
        return activityMatrixMapRet;

    }
    public static  Map<String,List<String>> getEventTypes(){
        
        return getDependentOptionsImpl('Event','Event_Type__c','Event_Sub_type__c');
    }
    public static Map<String,List<String>> getDependentOptionsImpl(String objApiName , String contrfieldApiName , String depfieldApiName){
        system.debug(objApiName + '##' + contrfieldApiName + '###' + depfieldApiName);
        
        String objectName = objApiName.toLowerCase();
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        
        if (!Schema.getGlobalDescribe().containsKey(objectName)){
            System.debug('OBJNAME NOT FOUND --.> ' + objectName);
            return null;
        }
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null){
            return objResults;
        }
        Bitset bitSetObj = new Bitset();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        //Check if picklist values exist
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            System.debug('FIELD NOT FOUND --.> ' + controllingField + ' OR ' + dependentField);
            return objResults;     
        }
        
        List<Schema.PicklistEntry> contrEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> depEntries = objFieldMap.get(dependentField).getDescribe().getPicklistValues();
        objFieldMap = null;
        List<Integer> controllingIndexes = new List<Integer>();
        for(Integer contrIndex=0; contrIndex<contrEntries.size(); contrIndex++){            
            Schema.PicklistEntry ctrlentry = contrEntries[contrIndex];
            String label = ctrlentry.getLabel();
            objResults.put(label,new List<String>());
            controllingIndexes.add(contrIndex);
        }
        List<Schema.PicklistEntry> objEntries = new List<Schema.PicklistEntry>();
        List<PicklistEntryWrapper> objJsonEntries = new List<PicklistEntryWrapper>();
        for(Integer dependentIndex=0; dependentIndex<depEntries.size(); dependentIndex++){            
            Schema.PicklistEntry depentry = depEntries[dependentIndex];
            objEntries.add(depentry);
        } 
        objJsonEntries = (List<PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objEntries), List<PicklistEntryWrapper>.class);
        List<Integer> indexes;
        for (PicklistEntryWrapper objJson : objJsonEntries){
            if (objJson.validFor==null || objJson.validFor==''){
                continue;
            }
            indexes = bitSetObj.testBits(objJson.validFor,controllingIndexes);
            for (Integer idx : indexes){                
                String contrLabel = contrEntries[idx].getLabel();
                objResults.get(contrLabel).add(objJson.label);
            }
        }
        objEntries = null;
        objJsonEntries = null;
        system.debug('objResults--->' + objResults);
        return objResults;
    }
    public static List<RecordType> getTCRTypebyTCRMatrix(){
        String uRoleId = UserInfo.getUserRoleId();
        UserRole userRole = [SELECT Id, Name FROM UserRole WHERE Id = :uRoleId];
        Set<TCR_Matrix__c> tcrMatrix = new Set<TCR_Matrix__c>([SELECT TCR_Type__c FROM TCR_Matrix__c WHERE Role__c = : userRole.Name]);
        List<String> tcrTypes = new List<String>();
        for(TCR_Matrix__c tcrType : tcrMatrix){
            tcrTypes.add(tcrType.TCR_Type__c);
        }
        
        return [SELECT Id,Name FROM RecordType WHERE  Name IN :tcrTypes] ; 
        
    }
    @AuraEnabled
    public static EventRecord getEventRecord(String recId){
        
        EventRecord eventRecord = new EventRecord();
        
        //Set Activity Matrix
        eventRecord.activityMatrix = getActivityMatrixMap();
        
        System.debug('>> kc debug' + getActivityMatrixMap());
        //Set The Event-Type & Sub-Event-Type Matrix
        eventRecord.eventTypes = getEventTypes();
        //Set Location Based picklist
        eventRecord.locations = getPicklistFieldValues('Event','Location_Based__c');
        //set TCR Field Work Record Types
        eventRecord.fieldWorkRecordTypes = getTCRTypebyTCRMatrix();
        //Set Mode of Contract picklist
        eventRecord.modeofcontract = getPicklistFieldValues('Event','Mode_of_Contact__c');
    
        //Set Name Options
        eventRecord.nameOptions.add('Contact');
        
        //Set ActJunkRemarks
        eventRecord.actJuncRemarks = '';
        //Initialize Event
        if(recId!=null){
            eventRecord.event = [SELECT Id,
                                 Subject,
                                 OwnerId,
                                 Location_Custom__c,
                                 Event_Type__c,
                                 Location_Based__c,
                                 Mode_of_Contact__c,
                                 Event_Sub_type__c,
                                 StartDateTime,
                                 EndDateTime,
                                 Status__c,
                                 IsAllDayEvent,
                                 Reason_for_Cancellation__c,
                                 Description,
                                 Others__c,
                                 Work_Plan__c,
                                 Validated__c,
                                 WhoId,
                                 Related_To_Account__c,
                                 Activity_Junction__c,
                                 Activity_Junction__r.Remarks_Analysis_Insights__c,
                                 Target_Order__c,
                                 Actual_Order__c,
                                 Survey_Rating_Percentage__c,
                                 Amount_Collection__c,
                                 Target_Collection__c,
                                 Created_from_Classic__c,
                                 Work_With_ID__c,
                                 Work_With_Name__c,
                                 ActivityDate,
                                 Field_Work_Record_Type__c
                                 FROM Event
                                 WHERE Id =:recId]; 
            if(eventRecord.event.Work_With_ID__c!=null){
                eventRecord.workWith = [SELECT Id, Name FROM User WHERE Id=:eventRecord.event.Work_With_ID__c];
            }
            if(eventRecord.event.OwnerId!=null){
                eventRecord.user = [SELECT Id, Name FROM User WHERE Id=:eventRecord.event.OwnerId];
            }
            if(eventRecord.event.Related_To_Account__c!=null){
                eventRecord.relatedAccount = [SELECT Id, Name, Branch_Code__c FROM Account WHERE Id=:eventRecord.event.Related_To_Account__c];
            }
            if(eventRecord.event.WhoId!=null){
                
                if((eventRecord.event.WhoId.getsobjecttype()+'')=='Contact'){
                    eventRecord.contactName = [SELECT Id, Name FROM Contact WHERE Id=:eventRecord.event.WhoId];
                }
                else if((eventRecord.event.WhoId.getsobjecttype()+'')=='Lead'){
                    eventRecord.contactName = [SELECT Id, Name FROM Lead WHERE Id=:eventRecord.event.WhoId];
                }
                
            }
            
            if(eventRecord.event != null){
                eventRecord.subActivityList = [SELECT Id,
                                               Activity_Name__c,
                                               Remarks__c,
                                               Notes__c,
                                               Survey_Summary_Form__c, 
                                               //Inventory__c,
                                               Analysis__c,
                                               Next_Steps_Directions__c,
                                               Learnings_Insights__c,
                                               Competitive_Activity__c,
                                               Competitor__c,
                                               Competitor_Brand__c,
                                               Competitor_Price__c,
                                               Competitive_Details__c,
                                               Target_Order__c,
                                               Actual_Order__c,
                                               Amount_Collected__c,
                                               Agenda__c,
                                               Attendees__c,
                                               Discussions__c,
                                               Agreements__c,
                                               Objectives__c,
                                               Actuals__c,
                                               Opportunities_Recommendations__c,
                                               Requirements_Submitted__c,
                                               Activity_Junction__c
                                               FROM Sub_Activity__c
                                               WHERE Activity_Junction__c =: eventRecord.event.Activity_Junction__c];
                
            }
            eventRecord.actJuncRemarks =eventRecord.event.Activity_Junction__r.Remarks_Analysis_Insights__c;
        }
        else{
            //Set Assigned To User
            eventRecord.user = [SELECT Id, Name FROM User WHERE Id=:UserInfo.getUserId()];
            eventRecord.event = new Event();
            eventRecord.event.OwnerId = UserInfo.getUserId();
            
            String dateToday = Datetime.Now().format('MM/dd/yyyy');
            List<String> dtimeSplit = String.valueOf(Datetime.Now()).split(' ');
            eventRecord.event.StartDateTime = DateTime.parse(dateToday+' '+'8:00 AM');
            eventRecord.event.EndDateTime = DateTime.parse(dateToday+' '+'6:00 PM');

            eventRecord.event.IsAllDayEvent = false;    
            eventRecord.event.Validated__c = false;   
            eventRecord.event.Work_Plan__c = true;
            /*
            if(date.today().day() > 7 && eventRecord.event.StartDateTime.month() == date.today().month()){
                eventRecord.event.Work_Plan__c = false;
            }else{
                eventRecord.event.Work_Plan__c = true;
            }
*/
         
        }
        return eventRecord;
    }
    @AuraEnabled
    public static String saveEventRecord(Event eventRecord,String subActivityListString,String actJuncRemarks){
      
        Map<String,List<String>> activityMatrixMap   = getActivityMatrixMap();
     //   System.debug(getActivityMatrixMap()+ '>> KC');
        
        List<Sub_Activity__c> subActivityList;
        if(subActivityListString==null){
            subActivityList = new List<Sub_Activity__c>();
        }
        else{
            subActivityList = (List<Sub_Activity__c>) JSON.deserialize(subActivityListString, List<Sub_Activity__c>.class);
        }
        
        if(eventRecord != null && eventRecord.Id == null){
            
            try{
                /*
                if(date.today().day() > 7 && eventRecord.StartDateTime.month() == date.today().month()){
                    eventRecord.Work_Plan__c = false;
                }else{
                    eventRecord.Work_Plan__c = true;
                }
                */
                if(eventRecord.Event_Type__c.equals('Field Work') && eventRecord.Event_Sub_Type__c.equals('Training Contact')){
                    eventRecord.TCR_Type__c = [SELECT Id, Name FROM RecordType WHERE Id = : eventRecord.Field_Work_Record_Type__c].Name;
                }
                eventRecord.ActivityDate=null;
                //create the event record
                insert eventRecord;
                
                //create new parent Activity Junction Record
                Activity_Junction__c actJunctionParent = populateActJunc(eventRecord,actJuncRemarks);
                
                actJunctionParent.Event_ID__c = eventRecord.Id;
                actJunctionParent.Validated__c = eventRecord.Validated__c;
                
                // Set Activity Junction's Status to 'New'
                actJunctionParent.Status__c = 'New';
                
                // Set Activity Junction's Subject from Event's Subject
                List<Event> getEventSubject = [SELECT Subject
                                               FROM Event
                                               WHERE (Id =: eventRecord.Id)
                                              ];
                
                if (getEventSubject.size() > 0) {
                    actJunctionParent.Subject__c = getEventSubject[0].Subject;
                }
                else {
                    actJunctionParent.Subject__c = eventRecord.Event_Sub_type__c + '-New';
                }

                String strWorkWith = eventRecord.Work_With_ID__c+'';
                
                if(!strWorkWith.equals('') && !strWorkWith.equals('null')){
                    
                    actJunctionParent.Work_With__c = eventRecord.Work_With_ID__c;
                }
                insert actJunctionParent;
                
                
                //update the event record to the parent junction
                if(actJunctionParent != null){
                    eventRecord =[SELECT Id,
                                  Subject,
                                  OwnerId,
                                  Location_Custom__c,
                                  Mode_of_Contact__c,
                                  Event_Type__c,
                                  Location_Based__c,
                                  Event_Sub_type__c,
                                  StartDateTime,
                                  EndDateTime,
                                  Status__c,
                                  IsAllDayEvent,
                                  Reason_for_Cancellation__c,
                                  Description,
                                  Others__c,
                                  Work_Plan__c,
                                  Validated__c,
                                  WhoId,
                                  Related_To_Account__c,
                                  Activity_Junction__c,
                                  Activity_Junction__r.Remarks_Analysis_Insights__c,
                                  Target_Order__c,
                                  Actual_Order__c,
                                  Survey_Rating_Percentage__c,
                                  Amount_Collection__c,
                                  Target_Collection__c,
                                  Created_from_Classic__c,
                                  Work_With_ID__c,
                                  Work_With_Name__c,
                                  ActivityDate,
                                  Field_Work_Record_Type__c
                                  FROM Event
                                  WHERE Id =:eventRecord.Id];
                    eventRecord.Activity_Junction__c = actJunctionParent.Id;
                
                    update eventRecord;
                    
                    //Check if event type = Call and do inserts for survey forms
                                      
                    if(eventRecord.Event_Type__c.equals('Call') || eventRecord.Event_Type__c.equals('Training Contact') ){
                        //Survey_Summary_Form__c
                        List<Survey_Summary_Form__c> ssfList = new List<Survey_Summary_Form__c>();
                        
                        //Related To Account
                        Account acctRec = new Account();
                        if(eventRecord.Related_To_Account__c != null){
                            acctRec = [SELECT Id, Team__c, Name FROM Account WHERE Id =: eventRecord.Related_To_Account__c];
                            
                        }
                        
                        //Related to Contact
                        Contact ContRec = new Contact();
                    
                        String strWhoID = eventRecord.WhoId+'';
                       
                        if(!strWhoID.equals('') && !strWhoID.equals('null')){
                           
                            ContRec = [SELECT Id, AccountId FROM Contact WHERE Id =: eventRecord.WhoId];
                          //  acctRec = [SELECT Id, Team__c, Name FROM Account WHERE Id =: ContRec.AccountId];
                            
                        }  
                        
                        if(acctRec.Id != null){
                            if(activityMatrixMap.get(eventRecord.Event_Sub_type__c)==null){
                                return 'SubActivity No Access';
                            }
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
                            
                        }
                        //CLONE PARENT SSF
 
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
                                if(sa.Activity_Junction__c == null){
                                    sa.Activity_Junction__c = actJunctionParent.Id;
                                }
                                subActToInsertList.add(sa);
                            }
                            
                        }
                        
                        if(subActToInsertList != null && !subActToInsertList.isEmpty()){
                            
                            upsert subActToInsertList;
                        }                                                   
                    }       
                }
                return eventRecord.Id;
            }
            catch(Exception ex){

                //ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0) );
                //ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getMessage() );
               // ApexPages.addMessage(msg);
                return ex.getMessage();
            }
            
        }
        else{
            
            try{
                
                Event oldEvent = [SELECT Id,
                                 Subject,
                                 OwnerId,
                                 Location_Custom__c,
                                 Event_Type__c,
                                 Location_Based__c,
                                  Mode_of_Contact__c,
                                 Event_Sub_type__c,
                                 StartDateTime,
                                 EndDateTime,
                                 Status__c,
                                 IsAllDayEvent,
                                 Reason_for_Cancellation__c,
                                 Description,
                                 Others__c,
                                 Work_Plan__c,
                                 Validated__c,
                                 WhoId,
                                 Related_To_Account__c,
                                 Activity_Junction__c,
                                 Activity_Junction__r.Remarks_Analysis_Insights__c,
                                 Target_Order__c,
                                 Actual_Order__c,
                                 Survey_Rating_Percentage__c,
                                 Amount_Collection__c,
                                 Target_Collection__c,
                                 Created_from_Classic__c,
                                 Work_With_ID__c,
                                 Work_With_Name__c,
                                  ActivityDate ,
                                  Field_Work_Record_Type__c 
                                 FROM Event
                                 WHERE Id =:eventRecord.Id];
                if(oldEvent.Status__c !=null && oldEvent.Status__c.equals('Cancelled')){
                    return 'Cancel Error';
                }
                if(eventRecord.Event_Type__c.equals('Field Work') && eventRecord.Event_Sub_Type__c.equals('Training Contact')){
                    eventRecord.TCR_Type__c = [SELECT Id, Name FROM RecordType WHERE Id = : eventRecord.Field_Work_Record_Type__c].Name;
                }else{
                   eventRecord.TCR_Type__c=null; 
                }
                List<Sub_Activity__c> oldSubActivityList = [SELECT Id,
                                                            Activity_Name__c,
                                                            Remarks__c,
                                                            Notes__c,
                                                            Survey_Summary_Form__c, 
                                                            //Inventory__c,
                                                            Analysis__c,
                                                            Next_Steps_Directions__c,
                                                            Learnings_Insights__c,
                                                            Competitive_Activity__c,
                                                            Competitor__c,
                                                            Competitor_Brand__c,
                                                            Competitor_Price__c,
                                                            Competitive_Details__c,
                                                            Target_Order__c,
                                                            Actual_Order__c,
                                                            Amount_Collected__c,
                                                            Agenda__c,
                                                            Attendees__c,
                                                            Discussions__c,
                                                            Agreements__c,
                                                            Objectives__c,
                                                            Actuals__c,
                                                            Opportunities_Recommendations__c,
                                                            Requirements_Submitted__c,
                                                            Activity_Junction__c
                                                            FROM Sub_Activity__c
                                               WHERE Activity_Junction__c =: oldEvent.Activity_Junction__c];
                //Delete SubActivity List if Event Type & Sub Event Type is changed
                if(!eventRecord.Event_Type__c.equals(oldEvent.Event_Type__c) && !eventRecord.Event_Sub_type__c.equals(oldEvent.Event_Sub_type__c)){
                    
                    delete oldSubActivityList;
                    
                }
                if((eventRecord.WhoId+'') == 'null'){
                    eventRecord.WhoId = null;
                }
                if((eventRecord.Related_To_Account__c+'') == 'null'){
                    eventRecord.Related_To_Account__c = null;
                }
                if((eventRecord.OwnerId+'') == 'null'){
                    eventRecord.OwnerId = null;
                }
                eventRecord.ActivityDate=null;
                update eventRecord;
                Activity_Junction__c actJunctionParent = populateActJunc(eventRecord,actJuncRemarks);
                actJunctionParent.Id = eventRecord.Activity_Junction__c;
                actJunctionParent.Validated__c = eventRecord.Validated__c;
                
                String strWorkWith = eventRecord.Work_With_ID__c+'';
                if(!strWorkWith.equals('') && !strWorkWith.equals('null')){
                    
                    actJunctionParent.Work_With__c = eventRecord.Work_With_ID__c;
                }
                upsert actJunctionParent;    //change from update to upsert : Kiko 10112017
                if(eventRecord.Activity_Junction__c == null){
                    eventRecord.Activity_Junction__c = actJunctionParent.Id;
                    update eventRecord;
                }
                
                //Check if event type = Call and do inserts for survey forms
                
                //create sub activity child records
                //system.debug('**subActivityList : '+subActivityList);
                if(subActivityList != null && !subActivityList.isEmpty()){     
                    List<Sub_Activity__c> subActToInsertList = new List<Sub_Activity__c>();
                    for(Sub_Activity__c sa : subActivityList){
                        if(sa.Activity_Name__c != null && sa.Activity_Name__c != ''){
                            if(sa.Activity_Junction__c == null){
                                sa.Activity_Junction__c = eventRecord.Activity_Junction__c;   
                            }
                            subActToInsertList.add(sa);
                        }
                    }

                    if(subActToInsertList != null && !subActToInsertList.isEmpty()){             
                        // upsert subActivityList;   
                        upsert subActToInsertList;
                    }                         
                } 
                //flag for knowing process is done without errors
                return eventRecord.Id;
            }catch(Exception ex){
               system.Debug(ex.getMessage());
                //ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0) );
                //ApexPages.addMessage(msg);
                return ex.getMessage();
            }
        }
        
        
    }
    @AuraEnabled
    public static Id completeEventRecord(Event eventRecord,String subActivityListString,String actJuncRemarks){
        Id eventID = saveEventRecord(eventRecord,subActivityListString,actJuncRemarks);
        Event oldEvent = [SELECT Id, Status__c FROM Event WHERE Id = :eventID];
        
        //oldEvent.ActivityDate = null;
        oldEvent.Status__c = 'Completed';
        update oldEvent;               
        return oldEvent.Id;
    }
    @AuraEnabled
    public static Id cloneEventRecord(Event eventRecord,String subActivityListString,String actJuncRemarks){
        eventRecord.Id = null;        
        //subActivityListString = null;
        return saveEventRecord(eventRecord,subActivityListString,actJuncRemarks);
    }
    @AuraEnabled
    public static String cancelEventRecord(Event eventRecord,String subActivityListString,String actJuncRemarks){
        
        return saveEventRecord(eventRecord,subActivityListString,actJuncRemarks);
    }
    @AuraEnabled
    public static Id saveAndNewTask(Event eventRecord,String subActivityListString,String actJuncRemarks){
        
        Id eventID = saveEventRecord(eventRecord,subActivityListString,actJuncRemarks);
        Event oldEvent = [SELECT Id, Status__c FROM Event WHERE Id = :eventID];
        oldEvent.Status__c = 'Completed';
        //OLDeVENT.ActivityDate = null;
        update oldEvent;               
        return oldEvent.Id;
    }
    //Helper
    public class EventRecord{
        @AuraEnabled public Event event {get;set;}
        @AuraEnabled public User user  {get;set;}
        @AuraEnabled public User workWith  {get;set;}
        @AuraEnabled public Account relatedAccount  {get;set;}
        @AuraEnabled public SObject contactName  {get;set;}
        @AuraEnabled public Map<String,List<String>> eventTypes{get;set;}
        @AuraEnabled public Map<String,List<String>> activityMatrix {get;set;}
        @AuraEnabled public List<String> locations {get;set;}
        @AuraEnabled public List<String> modeofcontract {get;set;}
        @AuraEnabled public List<String> nameOptions {get;set;}
        @AuraEnabled public List<Sub_Activity__c> subActivityList{get;set;}
        @AuraEnabled public String actJuncRemarks{get;set;}
        @AuraEnabled public Sub_Activity__c subActivity {get;set;}
        @AuraEnabled public String roleName {get;set;}
        @AuraEnabled Public List<RecordType> fieldWorkRecordTypes {get;set;}
        EventRecord(){
            
            event= new Event();
            user = new User();
            workWith = new User();
            relatedAccount = new Account();
            contactName = new Contact();
            nameOptions = new List<String>();
            subActivityList = new List<Sub_Activity__c>();
            subActivity = new Sub_Activity__c();
            roleName = getUserRole();
        }
    }
    
    public class BitSet {
        public Map < String, Integer > alphaNumCharCodes {
            get;
            set;
        }
        public Map < String, Integer > base64CharCodes {
            get;
            set;
        }
        
        public BitSet() {
            LoadCharCodes();
        }
        
        //Method loads the character codes for all letters
        public void LoadCharCodes() {
            alphaNumCharCodes = new Map < String, Integer > {
                'A' => 65,
                    'B' => 66,
                    'C' => 67,
                    'D' => 68,
                    'E' => 69,
                    'F' => 70,
                    'G' => 71,
                    'H' => 72,
                    'I' => 73,
                    'J' => 74,
                    'K' => 75,
                    'L' => 76,
                    'M' => 77,
                    'N' => 78,
                    'O' => 79,
                    'P' => 80,
                    'Q' => 81,
                    'R' => 82,
                    'S' => 83,
                    'T' => 84,
                    'U' => 85,
                    'V' => 86,
                    'W' => 87,
                    'X' => 88,
                    'Y' => 89,
                    'Z' => 90
                    };
                        base64CharCodes = new Map < String, Integer > ();
            //all lower cases
            Set < String > pUpperCase = alphaNumCharCodes.keySet();
            for (String pKey: pUpperCase) {
                //the difference between upper case and lower case is 32
                alphaNumCharCodes.put(pKey.toLowerCase(), alphaNumCharCodes.get(pKey) + 32);
                //Base 64 alpha starts from 0 (The ascii charcodes started from 65)
                base64CharCodes.put(pKey, alphaNumCharCodes.get(pKey) - 65);
                base64CharCodes.put(pKey.toLowerCase(), alphaNumCharCodes.get(pKey) - (65) + 26);
            }
            //numerics
            for (Integer i = 0; i <= 9; i++) {
                alphaNumCharCodes.put(string.valueOf(i), i + 48);
                //base 64 numeric starts from 52
                base64CharCodes.put(string.valueOf(i), i + 52);
            }
        }
        
        public List < Integer > testBits(String pValidFor, List < Integer > nList) {
            List < Integer > results = new List < Integer > ();
            List < Integer > pBytes = new List < Integer > ();
            Integer bytesBeingUsed = (pValidFor.length() * 6) / 8;
            Integer pFullValue = 0;
            if (bytesBeingUsed <= 1)
                return results;
            for (Integer i = 0; i < pValidFor.length(); i++) {
                pBytes.Add((base64CharCodes.get((pValidFor.Substring(i, i + 1)))));
            }
            for (Integer i = 0; i < pBytes.size(); i++) {
                Integer pShiftAmount = (pBytes.size() - (i + 1)) * 6; //used to shift by a factor 6 bits to get the value
                pFullValue = pFullValue + (pBytes[i] << (pShiftAmount));
            }
            
            Integer bit;
            Integer targetOctet;
            Integer shiftBits;
            Integer tBitVal;
            Integer n;
            Integer nListSize = nList.size();
            for (Integer i = 0; i < nListSize; i++) {
                n = nList[i];
                bit = 7 - (Math.mod(n, 8));
                targetOctet = (bytesBeingUsed - 1) - (n >> bytesBeingUsed);
                shiftBits = (targetOctet * 8) + bit;
                tBitVal = ((Integer)(2 << (shiftBits - 1)) & pFullValue) >> shiftBits;
                if (tBitVal == 1)
                    results.add(n);
            }
            return results;
        }
    }
    
    public class PicklistEntryWrapper{
        
        public PicklistEntryWrapper(){            
        }
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
    }
    
    public static List<String> getPicklistFieldValues(String objectName, String pickListFieldName){
            List<String> picklistValues = new List<String>();
            SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
            List<Schema.PicklistEntry> pick_list_values = objectType.getDescribe()
                .fields.getMap()
                .get(pickListFieldName)
                .getDescribe().getPickListValues();
            for (Schema.PicklistEntry aPickListValue : pick_list_values) {                   
                picklistValues.add(aPickListValue.getValue()); 
            }
            return picklistValues;
        }
    
    @AuraEnabled    
    public static void deleteSubActivity(String subActivityID) {
        
        List<Sub_Activity__c> subActivityRec = [SELECT Id
                                                FROM Sub_Activity__c
                                                WHERE (Id = :subActivityID)
                                               ];
        
        delete subActivityRec;
        
    }
}