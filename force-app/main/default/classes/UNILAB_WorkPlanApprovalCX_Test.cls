/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   06.14.2017
Definition   :   UNILAB_WorkPlanApprovalCX Test Class
History      :   05.05.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_WorkPlanApprovalCX_Test{
    public static User userLead;
    
    public static User userMemb;
    
    
    static{
        userLead = TestDataFactory.createUserAdmin();
        insert userLead;
        
        userMemb = TestDataFactory.createUserAdmin();
        userMemb.ManagerId = userLead.Id;
        userMemb.Username +='2';
        
        insert userMemb;
        
        system.runAs(userMemb){
            List<Event> allEventList = new List <Event> ();
            
            date startDateVar = date.Today();
            date endDateVar = date.Today();
            
            for (Integer i = 0; i < 18; i ++){
                
                Event eventTest = new Event(
                    StartDateTime = startDateVar, 
                    EndDateTime = endDateVar, 
                    OwnerId = userMemb.Id, 
                    Work_Plan__c = true, 
                    Validated__c = false,
                    Event_Type__c ='Admin Work',
                    Event_Sub_type__c ='ADMIN WORK',
                    Status__c = 'New'); 
                allEventList.add(eventTest);
                
            }      
            
            insert allEventList;
            
        }
    }
    @isTest static void validateWorkPlans1_Test(){
        Event eventTest = new Event(StartDateTime = dateTime.Now(), EndDateTime = dateTime.Now(), OwnerId = userMemb.Id, Work_Plan__c = true, Validated__c = false, Created_from_Classic__c = true);
        insert eventTest;
        
               		 
        system.runAs(userLead){
        

            UNILAB_WorkPlanApprovalCX cont = new UNILAB_WorkPlanApprovalCX();
            cont.getAllUsersList();
                        
        
            List<Event> events =  [SELECT Id,
                                Subject,
                                StartDateTime,
                                EndDateTime,
                                OwnerId
                                FROM Event];
            List<UNILAB_WorkPlanApprovalCX.approvalWrapper> approvalWrapperList = new List<UNILAB_WorkPlanApprovalCX.approvalWrapper>();
            if(events != null && !events.isEmpty()){
               
                for(Event e : events) {
                    //add events to wrapper
                    approvalWrapperList.add(new UNILAB_WorkPlanApprovalCX.approvalWrapper(e));
                }
                
            }  
            cont.approvalWrapperList = approvalWrapperList;
            for (Integer i = 0; i < cont.approvalWrapperList.size(); i++){
                cont.approvalWrapperList[i].isChecked = true;
            }
            
            cont.validate();
        }   
    }
    
    @isTest static void validateWorkPlans2_Test(){
        Event eventTest = new Event(StartDateTime = dateTime.Now(), EndDateTime = dateTime.Now(), OwnerId = userMemb.Id, Work_Plan__c = true, Validated__c = false, Created_from_Classic__c = true);
        insert eventTest;
        system.runAs(userLead){
            UNILAB_WorkPlanApprovalCX cont = new UNILAB_WorkPlanApprovalCX();
            cont.getAllUsersList();
            cont.userSelect1 = userMemb.Id;
            //cont.approvalWrapperList[0].isChecked = true;
            cont.searchViaPicklist();
        }    
    }
    
    
    // Inserted by : KC Roberto 08/22/2018
    // Cancel Method
    @istest static void testCancelMethod(){
        system.runAs(userLead){
            ApexPages.currentPage().getParameters().put('retURL','/home/home.jsp');
            test.startTest();
            UNILAB_WorkPlanApprovalCX cont = new UNILAB_WorkPlanApprovalCX();
            Pagereference result = cont.cancel();
            test.stopTest();
            
            System.assert(result.getUrl() == ApexPages.currentPage().getParameters().get('retURL'));
        }
    }
    
    
    // Positive test if month == 0
    @isTest static void validateWorkplanAll(){
        date startDateVar = date.newInstance(2018, 01, 21);
        date endDateVar = date.newInstance(2018, 01, 21);
        
        List<Event> allEventList = new List <Event> ();
        for (Integer i = 0; i < 12; i ++){
            Event eventTest = new Event(StartDateTime = startDateVar.addMonths(i), 
                                        EndDateTime = endDateVar.addMonths(i), 
                                        OwnerId = userMemb.Id, 
                                        Work_Plan__c = true, 
                                        Validated__c = false,
                                        Status__c = 'New',
                                        Created_from_Classic__c = true); 
            allEventList.add(eventTest);
        }      
        
        insert allEventList;
        
		 
        system.runAs(userLead){
        

            UNILAB_WorkPlanApprovalCX cont = new UNILAB_WorkPlanApprovalCX();
            cont.getAllUsersList();
            cont.searchEvents(allEventList.get(0).Id, 1, 0, 2018);
                        
        
            List<Event> events =  [SELECT Id,
                                Subject,
                                StartDateTime,
                                EndDateTime,
                                OwnerId
                                FROM Event];
            List<UNILAB_WorkPlanApprovalCX.approvalWrapper> approvalWrapperList = new List<UNILAB_WorkPlanApprovalCX.approvalWrapper>();
            if(events != null && !events.isEmpty()){
               
                for(Event e : events) {
                    //add events to wrapper
                    approvalWrapperList.add(new UNILAB_WorkPlanApprovalCX.approvalWrapper(e));
                }
                
            }  
            cont.approvalWrapperList = approvalWrapperList;
            for (Integer i = 0; i < cont.approvalWrapperList.size(); i++){
                cont.approvalWrapperList[i].isChecked = true;
            }
            
            cont.validate();
        }      
        
    }
    
    // Positive test if month == 0      
    @isTest static void validateWorkplanAll2(){
        
        date startDateVar = date.newInstance(2018, 01, 21);
        date endDateVar = date.newInstance(2018, 01, 21);
        
        List<Event> allEventList = new List <Event> ();
        for (Integer i = 0; i < 12; i ++){
            Event eventTest = new Event(StartDateTime = startDateVar.addMonths(i), 
                                        EndDateTime = endDateVar.addMonths(i), 
                                        OwnerId = userMemb.Id, 
                                        Work_Plan__c = true, 
                                        Validated__c = false,
                                        Status__c = 'New',
                                        Created_from_Classic__c = true); 
            allEventList.add(eventTest);
        }      
        
        insert allEventList;
		 
        system.runAs(userLead){
        

            UNILAB_WorkPlanApprovalCX cont = new UNILAB_WorkPlanApprovalCX();
            cont.getAllUsersList();
            cont.searchEvents(allEventList.get(0).Id, 1, 0, 2018);
                        
        
            List<Event> events =  [SELECT Id,
                                Subject,
                                StartDateTime,
                                EndDateTime,
                                OwnerId
                                FROM Event];
            List<UNILAB_WorkPlanApprovalCX.approvalWrapper> approvalWrapperList = new List<UNILAB_WorkPlanApprovalCX.approvalWrapper>();
            if(events != null && !events.isEmpty()){
               
                for(Event e : events) {
                    //add events to wrapper
                    approvalWrapperList.add(new UNILAB_WorkPlanApprovalCX.approvalWrapper(e));
                }
                
            }  
            cont.approvalWrapperList = approvalWrapperList;
            for (Integer i = 0; i < cont.approvalWrapperList.size(); i++){
                cont.approvalWrapperList[i].isChecked = true;
            }
            
            cont.validate();
        }   
   
        
    }
    
    
    
    @isTest static void validateWorkplanAll3(){
		 
        system.runAs(userLead){
        

            UNILAB_WorkPlanApprovalCX cont = new UNILAB_WorkPlanApprovalCX();
            cont.getAllUsersList();
            cont.searchEvents(Null, 1, 0, 2018);
                        
        
            List<Event> events =  [SELECT Id,
                                Subject,
                                StartDateTime,
                                EndDateTime,
                                OwnerId
                                FROM Event];
            List<UNILAB_WorkPlanApprovalCX.approvalWrapper> approvalWrapperList = new List<UNILAB_WorkPlanApprovalCX.approvalWrapper>();
            if(events != null && !events.isEmpty()){
               
                for(Event e : events) {
                    //add events to wrapper
                    approvalWrapperList.add(new UNILAB_WorkPlanApprovalCX.approvalWrapper(e));
                }
                
            }  
            cont.approvalWrapperList = approvalWrapperList;
            for (Integer i = 0; i < cont.approvalWrapperList.size(); i++){
                cont.approvalWrapperList[i].isChecked = true;
            }
            
            cont.validate();
        }   
   
        
    }
    

    
    @isTest static void validateWorkplanAll4(){
		 
        system.runAs(userLead){
        

            UNILAB_WorkPlanApprovalCX cont = new UNILAB_WorkPlanApprovalCX();
            cont.getAllUsersList();
            cont.searchEvents(Null, 1, 6, 2018);
                        
        
            List<Event> events =  [SELECT Id,
                                Subject,
                                StartDateTime,
                                EndDateTime,
                                OwnerId
                                FROM Event];
            List<UNILAB_WorkPlanApprovalCX.approvalWrapper> approvalWrapperList = new List<UNILAB_WorkPlanApprovalCX.approvalWrapper>();
            if(events != null && !events.isEmpty()){
               
                for(Event e : events) {
                    //add events to wrapper
                    approvalWrapperList.add(new UNILAB_WorkPlanApprovalCX.approvalWrapper(e));
                }
                
            }  
            cont.approvalWrapperList = approvalWrapperList;
            for (Integer i = 0; i < cont.approvalWrapperList.size(); i++){
                cont.approvalWrapperList[i].isChecked = true;
            }
            
            cont.validate();
        }   
   
        
    }
    
    @isTest static void validateWorkplanAll5(){
		 
        system.runAs(userLead){
        

            UNILAB_WorkPlanApprovalCX cont = new UNILAB_WorkPlanApprovalCX();
            cont.getAllUsersList();
            
                        
        
            List<Event> events =  [SELECT Id,
                                Subject,
                                StartDateTime,
                                EndDateTime,
                                OwnerId
                                FROM Event];
            List<UNILAB_WorkPlanApprovalCX.approvalWrapper> approvalWrapperList = new List<UNILAB_WorkPlanApprovalCX.approvalWrapper>();
            if(events != null && !events.isEmpty()){
               
                for(Event e : events) {
                    //add events to wrapper
                    approvalWrapperList.add(new UNILAB_WorkPlanApprovalCX.approvalWrapper(e));
                }
                
            }  
            cont.approvalWrapperList = approvalWrapperList;
            for (Integer i = 0; i < cont.approvalWrapperList.size(); i++){
                cont.approvalWrapperList[i].isChecked = true;
            }
            
            cont.validate();
        }   
   
        
    }
}