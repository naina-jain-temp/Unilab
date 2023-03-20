public class UNILAB_WorkPlanApprovalCX{
    
    public List<approvalWrapper> approvalWrapperList {get; set;}
    public List<User> userUnderTLList;
    public Id userSelect1{get;set;}
    public Event userSelect2{get;set;}
    public List<Event> eventList;
    public Integer month{get;set;}
    private Integer year{get;set;}
    public Set<Id> uidSet;
    public String userStrLkup{get;set;}
    
    public List<SelectOption> pageList {get;set;}    	// List of number of pages based on total queried events
    public Integer pageNumber {get;set;}				// the current page number
    public Integer pageListCounter {get;set;}			// total page counter	
    Integer totalEvents = 0;							// total number of queried events
    public List<Event> cutoffList;
    
    public class approvalWrapper{
        public Boolean isChecked{get;set;}
        public Event eventRecord{get;set;}
        
        public approvalWrapper(Event e) {
            eventRecord = e;
            isChecked = false;
        }
    }
    
    
    public UNILAB_WorkPlanApprovalCX(){        
        
        month = date.Today().Month();
        year = date.Today().year();
        
        Integer monthDigit = date.Today().Month();
        String mt;
        String cutoff;
        if (monthDigit <= 9) {
            mt = '0' + monthDigit;
            cutoff = year + '-' + mt + '-' + '07';
        }
        else
        {
            cutoff = year + '-' + monthDigit + '-' + '07';
        }
        
        //String cutoff = year + '-' + mt + '-' + '07';
        
        eventList = new List<Event>();
        
        userSelect2 = new Event();        
        userUnderTLList = new List<User>();
        uidSet = new Set<Id>();
        userStrLkup = '';
        
        pageListCounter = 0;        
        pageNumber = 1;
        pageList = new List<SelectOption>();
        
        userUnderTLList = [SELECT Id, Name FROM User WHERE ManagerId =: UserInfo.getUserId()];
        if(userUnderTLList != null && !userUnderTLList.isEmpty()){
            
            for(User u : userUnderTLList){
                uidSet.add(u.Id);
            }
            system.debug('uidSet' + uidSet);
            /*
            if (month == 0){
                
                totalEvents = [SELECT COUNT() 
                               FROM Event
                               WHERE Work_Plan__c = true
                               AND Validated__c = false
                               AND Status__c = 'New'
                               AND OwnerId IN:uidSet];
                
                if ( math.mod(totalEvents, 10) > 0 ){
                    pageListCounter = ((totalEvents / 10) + 1);
                    
                } else {
                    pageListCounter = (totalEvents / 10);
                    
                }
                
                if (pageListCounter == 0) {
                     pageList.add(new SelectOption(0 + '',0 + ''));
                }
                
                Integer x = 1;
                for(Integer i=0; i < pageListCounter; i++)  {                
                    pageList.add(new SelectOption(x + '',x + ''));
                    x++;
                }
                
                eventList = [SELECT Id,
                             Subject,
                             StartDateTime,
                             EndDateTime,
                             OwnerId
                             FROM Event
                             WHERE Work_Plan__c = true
                             AND Validated__c = false
                             AND Status__c = 'New'
                             AND OwnerId IN:uidSet
                             ORDER BY EndDateTime ASC
                             LIMIT 10
                             OFFSET: ((pageNumber - 1) * 10)];
                
                
            } else { */
            	
                totalEvents = [SELECT COUNT()
                               FROM Event
                               WHERE Work_Plan__c = true
                               AND Validated__c = false
                               AND Status__c = 'New'
                               AND StartDateTime >=: (DateTime)JSON.deserialize('"' + cutoff + '"', DateTime.class)
                               AND CALENDAR_MONTH(EndDateTime) =: month
                               AND CALENDAR_YEAR(EndDateTime)  =: year
                               AND OwnerId IN:uidSet];
                system.debug(totalEvents);
                if ( math.mod(totalEvents, 10) > 0 ){
                    pageListCounter = ((totalEvents / 10) + 1); 
                    
                } else {
                    pageListCounter = (totalEvents / 10);
                    
                }
                
                if (pageListCounter == 0) {
                    pageList.add(new SelectOption(0 + '',0 + ''));
                }
                
                Integer x = 1;
                for(Integer i=0; i < pageListCounter; i++)  {                
                    pageList.add(new SelectOption(x + '',x + ''));
                    x++;
                }
             
                eventList = [SELECT Id,
                             Subject,
                             StartDateTime,
                             EndDateTime,
                             OwnerId
                             FROM Event
                             WHERE Work_Plan__c = true
                             AND Validated__c = false
                             AND Status__c = 'New'
                             AND CALENDAR_MONTH(EndDateTime) =: month
                             AND CALENDAR_YEAR(EndDateTime)  =: year
                             AND OwnerId IN:uidSet
                             ORDER BY EndDateTime ASC
                             LIMIT 10
                             OFFSET: ((pageNumber - 1) * 10)];
            //}
            
            if((DateTime)JSON.deserialize('"' + cutoff + '"', DateTime.class) < System.today()){
                
                eventList.clear();
                
            }
    
            
            if(eventList != null && !eventList.isEmpty()){
                approvalWrapperList = new List<approvalWrapper>();
                for(Event e : eventList) {
                    //add events to wrapper
                    approvalWrapperList.add(new approvalWrapper(e));
                }
                
            }     
            
            
        }
    }
    
    public PageReference validate(){
        
        List<Event> eventToUpdateList = new List<Event>();
        
        if(approvalWrapperList != null && !approvalWrapperList.isEmpty()){
            for(approvalWrapper aw : approvalWrapperList){
                if(aw.isChecked){
                    aw.eventRecord.Validated__c = true;
                    eventToUpdateList.add(aw.eventRecord);
                }
            }
            
            if(eventToUpdateList != null && !eventToUpdateList.isEmpty()){
                try{
                    update eventToUpdateList;
                    
                }catch(Exception ex){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
                    system.Debug(ex);
                }
                
                searchViaPicklist();
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Event/s validated.'));
            }
        }
        return null;
    }
    

    //Select option for all of the users under the logged in user
    public List<SelectOption> getAllUsersList(){
        
        List<SelectOption> AllUsersList = new List<SelectOption>();
        AllUsersList.add(new SelectOption( '','All'));
        if(userUnderTLList != null && !userUnderTLList.isEmpty()){
            for(User u : userUnderTLList)
            {
                AllUsersList.add(new SelectOption(u.Id,u.Name));
            }   
        }
        
        return AllUsersList;
    }

    // Reset the Page Number to 1 if there is change only in month and user picklist
    public void searchViaPicklist(){
        		
        pageNumber = 1;		
        
        searchEvents(userSelect1, pageNumber, month, year);
        
    }

    // Search events if there is change in page number picklist
    public void searchViaPicklist2(){
     
        searchEvents(userSelect1, pageNumber, month, year);
        
    }
    
    // Search events based on passed parameters
    public void searchEvents(Id eventOwnerId, Integer pageNum, Integer mon, Integer yr){
        
        pageList = new List<SelectOption>();
        
        Integer monthDigit = date.Today().Month();
        String mt;
        String cutoff;
        if (monthDigit <= 9) {
            mt = '0' + monthDigit;
            cutoff = year + '-' + mt + '-' + '07';
        }
        else
        {
            cutoff = year + '-' + monthDigit + '-' + '07';
        }
        
        //String cutoff = yr + '-' + mt + '-' + '07';
        
        String tod = date.today().format();
        system.debug(tod +' && '+ cutoff);
        
        
        //User selected picklist = All
        if(eventOwnerId == null){            
            
            if (mon == 0){
                
                totalEvents = [SELECT COUNT() 
                               FROM Event
                               WHERE Work_Plan__c = true
                               AND Validated__c = false
                               AND Status__c = 'New'
                               AND OwnerId IN: uidSet];
                
                if ( math.mod(totalEvents, 10) > 0 ){
                    pageListCounter = ((totalEvents / 10) + 1);
                    
                } else {
                    pageListCounter = (totalEvents / 10);
                    
                }
                
                if (pageListCounter == 0) {
                    pageList.add(new SelectOption(0 + '',0 + ''));
                }
                
                Integer x = 1;
                for(Integer i=0; i < pageListCounter; i++)  {                
                    pageList.add(new SelectOption(x + '',x + ''));
                    x++;
                }
                
                eventList = [SELECT Id,
                             Subject,
                             StartDateTime,
                             EndDateTime,
                             OwnerId
                             FROM Event
                             WHERE Work_Plan__c = true
                             AND Validated__c = false
                             AND Status__c = 'New'
                             AND OwnerId IN: uidSet
                             ORDER BY EndDateTime ASC
                             LIMIT 10
                             OFFSET: ((pageNum - 1) * 10)];
                
                if((DateTime)JSON.deserialize('"' + cutoff + '"', DateTime.class) < System.today()){
                    
                    eventList.clear();
                    
                }
                
                
            } else { 
                
                totalEvents = [SELECT COUNT() 
                               FROM Event
                               WHERE Work_Plan__c = true
                               AND Validated__c = false
                               AND Status__c = 'New'
                               AND CALENDAR_MONTH(EndDateTime) =: mon
                               AND CALENDAR_YEAR(EndDateTime)  =: yr
                               AND OwnerId IN: uidSet];
                
                if ( math.mod(totalEvents, 10) > 0 ){
                    pageListCounter = ((totalEvents / 10) + 1);
                    
                } else {
                    pageListCounter = (totalEvents / 10);
                    
                }
                
                if (pageListCounter == 0) {
                    pageList.add(new SelectOption(0 + '',0 + ''));
                }
                
                Integer x = 1;
                for(Integer i=0; i < pageListCounter; i++)  {                
                    pageList.add(new SelectOption(x + '',x + ''));
                    x++;
                }
                  
                eventList = [SELECT Id,
                             Subject,
                             StartDateTime,
                             EndDateTime,
                             OwnerId
                             FROM Event
                             WHERE Work_Plan__c = true
                             AND Validated__c = false
                             AND Status__c = 'New'
                             AND CALENDAR_MONTH(EndDateTime) =: mon
                             AND CALENDAR_YEAR(EndDateTime)  =: yr
                             AND OwnerId IN: uidSet
                             ORDER BY EndDateTime ASC
                             LIMIT 10
                             OFFSET: ((pageNum - 1) * 10)];
                
                if((DateTime)JSON.deserialize('"' + cutoff + '"', DateTime.class) < System.today()){
                    
                    eventList.clear();
                    
                }
            }
            
        } else { 
            
            //Month selected picklist = All
            if (mon == 0){

                totalEvents = [SELECT COUNT() 
                               FROM Event
                               WHERE Work_Plan__c = true
                               AND Validated__c = false
                               AND Status__c = 'New'
                               AND OwnerId =: eventOwnerId];
                
                if ( math.mod(totalEvents, 10) > 0 ){
                    pageListCounter = ((totalEvents / 10) + 1);
                    
                } else {
                    pageListCounter = (totalEvents / 10);
                    
                }
                
                if (pageListCounter == 0) {
                    pageList.add(new SelectOption(0 + '',0 + ''));
                }
                
                Integer x = 1;
                for(Integer i=0; i < pageListCounter; i++)  {                
                    pageList.add(new SelectOption(x + '',x + ''));
                    x++;
                }
                
                eventList = [SELECT Id,
                             Subject,
                             StartDateTime,
                             EndDateTime,
                             OwnerId
                             FROM Event
                             WHERE Work_Plan__c = true
                             AND Validated__c = false
                             AND Status__c = 'New'
                             AND OwnerId =: eventOwnerId
                             ORDER BY EndDateTime ASC
                             LIMIT 10
                             OFFSET: ((pageNum - 1) * 10)];
                
                if((DateTime)JSON.deserialize('"' + cutoff + '"', DateTime.class) < System.today()){
                    
                    eventList.clear();
                    
                }
                
                
            } else { 
                
                totalEvents = [SELECT COUNT() 
                               FROM Event
                               WHERE Work_Plan__c = true
                               AND Validated__c = false
                               AND Status__c = 'New'
                               AND CALENDAR_MONTH(EndDateTime) =: mon
                               AND CALENDAR_YEAR(EndDateTime)  =: yr
                               AND OwnerId =: eventOwnerId];
                
                if ( math.mod(totalEvents, 10) > 0 ){
                    pageListCounter = ((totalEvents / 10) + 1);
                    
                } else {
                    pageListCounter = (totalEvents / 10);
                    
                }
                
                if (pageListCounter == 0) {
                    pageList.add(new SelectOption(0 + '',0 + ''));
                }
                
                Integer x = 1;
                for(Integer i=0; i < pageListCounter; i++)  {                
                    pageList.add(new SelectOption(x + '',x + ''));
                    x++;
                }
                
                eventList = [SELECT Id,
                             Subject,
                             StartDateTime,
                             EndDateTime,
                             OwnerId
                             FROM Event
                             WHERE Work_Plan__c = true
                             AND Validated__c = false
                             AND Status__c = 'New'
                             AND CALENDAR_MONTH(EndDateTime) =: mon
                             AND CALENDAR_YEAR(EndDateTime)  =: yr
                             AND OwnerId =: eventOwnerId
                             ORDER BY EndDateTime ASC
                             LIMIT 10
                             OFFSET: ((pageNum - 1) * 10)];
                
                if((DateTime)JSON.deserialize('"' + cutoff + '"', DateTime.class) < System.today()){
                    
                    eventList.clear();
                    
                }
            }
            
            
        }
        
        
        //system.Debug('***eventList:'+eventList);
        
        
        if(eventList != null && !eventList.isEmpty()){
            approvalWrapperList = new List<approvalWrapper>();
            for(Event e : eventList) {
                //add events to wrapper
                approvalWrapperList.add(new approvalWrapper(e));
            }
            
        }else{
            approvalWrapperList = null;
            
        }
        
    }
    
        
    public PageReference cancel(){
        return new PageReference('/home/home.jsp');
    }
    
    
    
    
    
}