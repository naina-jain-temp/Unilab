/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.20.2017
Definition   :   Test class for UNILAB_SubActivityListCX
History      :   07.20.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
@isTest
private class UNILAB_SubActivityPdfCXTest{

     @testSetup
    public static void setup() {
        
        List<Event> newEventList = new List<Event>();
        
        for (Integer i = 0; i <= 1; i++) {
            
            Event newEvent = new Event();
            
            if (i == 0) {
                
                newEvent = new Event(Subject = 'New Event ' + i,
                                     StartDateTime = DateTime.now(),
                                     EndDateTime = DateTime.now(),
                                     Event_Type__c = 'Meeting',
                                     Event_Sub_Type__c = 'MEETING'
                                    );
                
            }
            
            if (i == 1) {
                
                newEvent = new Event(Subject = 'New Event ' + i,
                                     StartDateTime = DateTime.now(),
                                     EndDateTime = DateTime.now(),
                                     Event_Type__c = 'ADMIN WORK',
                                     Event_Sub_Type__c = 'ADMIN WORK'
                                    );
                
            }
            
            newEventList.add(newEvent);
            
        }
        
        insert newEventList;
        
        Set<String> acctID = new Set<String>();
        
        List<Account> acctList = TestDataFactory.createAccount(1);
        
        insert acctList;
        
        for (Account acct : acctList) {
            acctID.add(acct.Id);
        }
        
        List<Activity_Junction__c> actJuncList = TestDataFactory.createActivityJunction(2, acctID);
        insert actJuncList;
        
        newEventList.get(0).Activity_Junction__c = actJuncList[0].Id;
        newEventList.get(1).Activity_Junction__c = actJuncList[0].Id;
        update newEventList;
        
        List<Sub_Activity__c> subActList = new List<Sub_Activity__c>();
        
        for (Integer i = 0; i <= 5; i++) {
            
            Sub_Activity__c newSubAct = new Sub_Activity__c();
            
            if (i <= 2) {
                
                newSubAct = new Sub_Activity__c(Activity_Junction__c = actJuncList[0].Id,
                                                Activity_Name__c = 'TEAM MEETING',
                                                Agenda__c = 'Agenda ' + i,                                                        
                                                Attendees__c = 'Attendees ' + i,
                                                Discussions__c = 'Discusstions ' + i,
                                                Next_Steps_Directions__c = 'Next Step Direction ' + i
                                               );
                
            }
            
            if (i >= 3 && i <= 5) {
                
                newSubAct = new Sub_Activity__c(Activity_Junction__c = actJuncList[0].Id,
                                                Activity_Name__c = 'ADMIN WORK'
                                               );
                
            }
            
            subActList.add(newSubAct);
            
        }
        
        insert subActList;
        
    }
    
    @isTest
    public static void eventIsMeeting() {
        
        Event savedEvent = [SELECT Id,
                            	   Activity_Junction__c,
                            	   StartDateTime,
                            	   EndDateTime,
                            	   Event_Type__c,
                            	   Event_Sub_type__c
                            FROM Event
                            WHERE (Event_Type__c = 'Meeting')
                           ];
        
        List<Sub_Activity__c> savedSubAct = [SELECT Activity_Name__c,
                                             		Agenda__c,
                                             		Attendees__c,
                                             		Discussions__c,
                                             		Next_Steps_Directions__c
                                             FROM Sub_Activity__c
                                             WHERE (Activity_Junction__c = :savedEvent.Activity_Junction__c)
                                            ];
        
        PageReference pageRef = Page.UNILAB_SubActivityPdf;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', savedEvent.Id);
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(savedEvent);
        UNILAB_SubActivityPdfCX subAct = new UNILAB_SubActivityPdfCX(stdCon);
        
        System.assert(subAct.eventRec != NULL);
        System.assert(subAct.subActMasterList != NULL);
        
        System.assertEquals(subAct.eventRec.Id, savedEvent.Id);
        
        System.assertEquals(subAct.startDate, savedEvent.StartDateTime.Date().format());
        System.assertEquals(subAct.endDate,  savedEvent.EndDateTime.Date().format());
        System.assertEquals(subAct.downloadDate, Date.today().format());
        
        System.assertEquals(subAct.eventRec.Event_Type__c, savedEvent.Event_Type__c);
        System.assertEquals(subAct.eventRec.Event_Sub_type__c, savedEvent.Event_Sub_type__c);
        
        System.assertEquals(savedSubAct[0].Activity_Name__c, subAct.subActMasterList[0].Activity_Name__c);
        System.assertEquals(savedSubAct[0].Agenda__c, subAct.subActMasterList[0].Agenda__c);
        System.assertEquals(savedSubAct[0].Attendees__c, subAct.subActMasterList[0].Attendees__c);
        System.assertEquals(savedSubAct[0].Discussions__c, subAct.subActMasterList[0].Discussions__c);
        System.assertEquals(savedSubAct[0].Next_Steps_Directions__c, subAct.subActMasterList[0].Next_Steps_Directions__c);
        
    }
    
    @isTest
    public static void eventIsNotMeeting() {
        
        Event savedEvent = [SELECT Id,
                            	   Activity_Junction__c,
                            	   StartDateTime,
                            	   EndDateTime,
                            	   Event_Type__c
                            FROM Event
                            WHERE (Event_Type__c = 'ADMIN WORK')
                           ];
        
        PageReference pageRef = Page.UNILAB_SubActivityPdf;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', savedEvent.Id);
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(savedEvent);
        UNILAB_SubActivityPdfCX subAct = new UNILAB_SubActivityPdfCX(stdCon);
        
        System.assert(subAct.eventRec != NULL);
        System.assert(subAct.subActMasterList != NULL);
        
        System.assertEquals(subAct.eventRec.Id, savedEvent.Id);
        
        List<ApexPages.Message> errorMessage = ApexPages.getMessages();
        
        System.assertEquals(ApexPages.Severity.ERROR, errorMessage.get(0).getSeverity());
        System.assertEquals('Cannot Generate Report because Event Type and Event Sub Type is not Meeting',  errorMessage.get(0).getSummary());
        
    }
    
    @isTest
    public static void subActivityIsNull() {
        
        Event newEvent = new Event(Subject = 'New Event',
                                   StartDateTime = DateTime.now(),
                                   EndDateTime = DateTime.now(),
                                   Event_Type__c = 'Meeting',
                                   Event_Sub_Type__c = 'MEETING'
                                  );
        insert newEvent;
        
        Set<String> acctID = new Set<String>();
        
        List<Account> acctList = TestDataFactory.createAccount(1);
        
        insert acctList;
        
        for(Account acctRec : acctList){
            
            acctID.add(acctRec.Id);
        
        }
        
        List<Activity_Junction__c> newActJunc = TestDataFactory.createActivityJunction(2, acctID);
        insert newActJunc;
        
        newEvent.Activity_Junction__c = newActJunc[0].Id;
        
        update newEvent;
        
        Sub_Activity__c newSubAct = new Sub_Activity__c(Activity_Junction__c = newActJunc[1].Id,
                                                        Activity_Name__c = 'Meeting');
        insert newSubAct;
        
        PageReference pageRef = Page.UNILAB_SubActivityPdf;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', newEvent.Id);
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(newEvent);
        UNILAB_SubActivityPdfCX subAct = new UNILAB_SubActivityPdfCX(stdCon);
        
        System.assert(subAct.eventRec != NULL);
        System.assert(subAct.subActMasterList == NULL);
        
        System.assertEquals(subAct.eventRec.Id, newEvent.Id);
        
        System.assertEquals(subAct.startDate, newEvent.StartDateTime.Date().format());
        System.assertEquals(subAct.endDate,  newEvent.EndDateTime.Date().format());
        System.assertEquals(subAct.downloadDate, Date.today().format());
        
        System.assertEquals(subAct.eventRec.Event_Type__c, newEvent.Event_Type__c);
        System.assertEquals(subAct.eventRec.Event_Sub_type__c, newEvent.Event_Sub_type__c);
        
    }
    
}