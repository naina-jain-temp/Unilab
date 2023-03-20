@isTest
private class UNILAB_PerDiem_Test {
    @isTest
    private static void getEventWithoutFilter() {
        
        List<Event> evnt = new List<Event> ();
        for(Integer i=0; i<5; i++) {
            Event ev = new Event();
            ev.StartDateTime= System.now();
            ev.EndDateTime= System.now();
            ev.IsAllDayEvent= false;
            ev.Validated__c= false;
            ev.Work_Plan__c= true;
            ev.Event_Type__c= 'Special Activity/Partnering';
            ev.Event_Sub_type__c= 'HOSPITAL ACTIVITY';
            ev.Location_Based__c= 'Home Base';
            ev.Location_Custom__c= '';
            ev.Mode_of_Contact__c= 'Online';
            ev.Description= '';
            ev.Work_With_ID__c= '';
            ev.Work_With_Name__c= '';
            ev.Status__c = 'Completed';
            evnt.add(ev);
        }
        
        insert evnt;
        
        Test.startTest();
        
        List<UNILAB_PerDiem.EventListWrapper> fetchEventList = UNILAB_PerDiem.fetch(null, null, null, '10', '1');

        Test.stopTest();
        
       
        System.assert(fetchEventList.size() > 0);
        
        for (Integer i = 0; i < fetchEventList.size(); i++) {
            if (fetchEventList[i].objEvent.Id == evnt[0].Id) {
                System.assertEquals(fetchEventList[i].isChecked, false);
            }
            else {
                System.assertEquals(fetchEventList[i].isChecked, false);
            }
            System.assert(String.isNotBlank(fetchEventList[i].objEvent.Id));
        }
    }
    
    @isTest
    private static void getEventWithFilter() {
        Datetime dt = System.now();
        Date recordDate = Date.today();
        List<Event> evnt = new List<Event> ();
        for(Integer i=0; i<5; i++) {
            Event ev = new Event();
            ev.StartDateTime= recordDate;
            ev.EndDateTime= recordDate;
            ev.IsAllDayEvent= false;
            ev.Validated__c= false;
            ev.Work_Plan__c= true;
            ev.Event_Type__c= 'Special Activity/Partnering';
            ev.Event_Sub_type__c= 'HOSPITAL ACTIVITY';
            ev.Location_Based__c= 'Home Base';
            ev.Location_Custom__c= '';
            ev.Mode_of_Contact__c= 'Online';
            ev.Description= '';
            ev.Work_With_ID__c= '';
            ev.Work_With_Name__c= '';
            ev.Status__c = 'Completed';
            evnt.add(ev);
        }
        
        insert evnt;
        
        Test.startTest();
        
        List<UNILAB_PerDiem.EventListWrapper> fetchEventList = UNILAB_PerDiem.fetch(null, String.valueOf(recordDate), String.valueOf(recordDate), '10', '1');

        Test.stopTest();
        
       
        System.assert(fetchEventList.size() > 0);
        
        for (Integer i = 0; i < fetchEventList.size(); i++) {
            if (fetchEventList[i].objEvent.Id == evnt[0].Id) {
                System.assertEquals(fetchEventList[i].isChecked, false);
            }
            else {
                System.assertEquals(fetchEventList[i].isChecked, false);
            }
            System.assert(String.isNotBlank(fetchEventList[i].objEvent.Id));
        }
    }
    
    @isTest
    private static void submitPerDiem() {
        
        Datetime dt = System.now();
        Date recordDate = Date.today();
        Event evnt = new Event(StartDateTime= recordDate,
                               EndDateTime= recordDate,
                               IsAllDayEvent= false,
                               Validated__c= false,
                               Work_Plan__c= true,
                               Event_Type__c= 'Special Activity/Partnering',
                               Event_Sub_type__c= 'HOSPITAL ACTIVITY',
                               Location_Based__c= 'Home Base',
                               Location_Custom__c= 'Caloocan',
                               Mode_of_Contact__c= 'Online',
                               Description= 'Test',
                               Work_With_ID__c= '',
                               Work_With_Name__c= '',
                               Status__c = 'Completed',
                				from_Per_Diem__c= true
                              );
        insert evnt;
        
        List<UNILAB_PerDiem.EventListWrapper> fetchEventList = UNILAB_PerDiem.fetch(null, null, null, '10', '1');
        List<Per_Diem_Item__c> perdiemList = new List<Per_Diem_Item__c>();
        Per_Diem_Item__c pdList = new Per_Diem_Item__c();
        List<Event> evntList = new List<Event>();
        
        for(UNILAB_PerDiem.EventListWrapper ev: fetchEventList) {
            pdList = new Per_Diem_Item__c(Exemption_Remarks__c = '');
            perdiemList.add(pdList);
            evntList.add(ev.objEvent);
        }
        
        Test.startTest();
        
        UNILAB_PerDiem.onSubmit(evntList, perdiemList, null);
        
        Test.stopTest();
        
        Per_Diem__c perdiem = [SELECT Id, Approval_Status__c FROM Per_Diem__c];
        
        System.assert(perdiem != null);
        System.assert(perdiem.Id != null);
        System.assertEquals('Draft', perdiem.Approval_Status__c);
        
    }
    
    @isTest
    private static void submitPerDiemWithExemption() {
        
        Datetime dt = System.now();
        Date recordDate = Date.today();
        Event evnt = new Event(StartDateTime= recordDate,
                               EndDateTime= recordDate,
                               IsAllDayEvent= false,
                               Validated__c= false,
                               Work_Plan__c= true,
                               Event_Type__c= 'Special Activity/Partnering',
                               Event_Sub_type__c= 'HOSPITAL ACTIVITY',
                               Location_Based__c= 'Home Base',
                               Location_Custom__c= 'Caloocan',
                               Mode_of_Contact__c= 'Online',
                               Description= 'Test',
                               Work_With_ID__c= '',
                               Work_With_Name__c= '',
                               Status__c = 'Completed',
                			   from_Per_Diem__c= true
                              );
        insert evnt;
        
        List<UNILAB_PerDiem.EventListWrapper> fetchEventList = UNILAB_PerDiem.fetch(null, null, null, '10', '1');
        List<Per_Diem_Item__c> perdiemList = new List<Per_Diem_Item__c>();
        Per_Diem_Item__c pdList = new Per_Diem_Item__c();
        List<Event> evntList = new List<Event>();
        
        for(UNILAB_PerDiem.EventListWrapper ev: fetchEventList) {
            pdList = new Per_Diem_Item__c(Exemption_Remarks__c = 'Test');
            perdiemList.add(pdList);
            evntList.add(ev.objEvent);
        }
        
        Test.startTest();
        
        String returnId = UNILAB_PerDiem.onSubmit(evntList, perdiemList, null);
        
        Test.stopTest();
        
        Per_Diem__c perdiem = [SELECT Id, Approval_Status__c FROM Per_Diem__c];
        
        System.assert(perdiem != null);
        System.assert(perdiem.Id != null);
        System.assert(returnId != null);
        System.assertEquals('Draft', perdiem.Approval_Status__c);
    }
    
    /***EDIT TEST***/
    @isTest
    private static void getExistEvent() {
        
            Event evnt = new Event(StartDateTime= System.now(),
            EndDateTime= System.now(),
            IsAllDayEvent= false,
            Validated__c= false,
            Work_Plan__c= true,
            Event_Type__c= 'Special Activity/Partnering',
            Event_Sub_type__c= 'HOSPITAL ACTIVITY',
            Location_Based__c= 'Home Base',
            Location_Custom__c= 'MANILA',
            Mode_of_Contact__c= 'Online',
            Description= 'Test',
            Status__c = 'Completed');
            
        
        insert evnt;
        
        Per_Diem__c pd = new Per_Diem__c(Approval_Status__c='Draft');
        
        insert pd;
        
        Per_Diem_Item__c pdi = new Per_Diem_Item__c(Activity_Junction__c=evnt.Activity_Junction__c,
                                               Exemption_Remarks__c='',
                                               HB_OHB__c=evnt.Location_Based__c,
                                               Place_of_Work__c=evnt.Location_Custom__c,
                                               Number_of_Days__c=1,
                                               Sub_Activity_Report__c=pd.Id);
        insert pdi;
        
        Test.startTest();
        
        List<UNILAB_PerDiem.EventListWrapper> fetchEventList = UNILAB_PerDiem.fetchExist(pd.Id);

        Test.stopTest();
        
        System.assert(fetchEventList.size() > 0);
        
        for (Integer i = 0; i < fetchEventList.size(); i++) {
            if (fetchEventList[i].objEvent.Id == evnt.Id) {
                System.assertEquals(fetchEventList[i].isChecked, true);
            }
            System.assert(String.isNotBlank(fetchEventList[i].objEvent.Id));
        }
    }
    
    @isTest
    private static void updatePerDiem() {
        
        Datetime dt = System.now();
        Date recordDate = Date.today();
        Event evnt = new Event(StartDateTime= System.now(),
            End_Date__c= recordDate,
            DurationInMinutes=0,
            IsAllDayEvent= false,
            Validated__c= false,
            Work_Plan__c= true,
            Event_Type__c= 'Special Activity/Partnering',
            Event_Sub_type__c= 'HOSPITAL ACTIVITY',
            Location_Based__c= 'Home Base',
            Location_Custom__c= 'MANILA',
            Mode_of_Contact__c= 'Online',
            Description= 'Test',
            Status__c = 'Completed');
        insert evnt;
        
        Per_Diem__c pd = new Per_Diem__c(Approval_Status__c='Draft');
        
        insert pd;
        
        Per_Diem_Item__c pdi = new Per_Diem_Item__c (Activity_Junction__c=evnt.Activity_Junction__c,
                                               Exemption_Remarks__c='',
                                               HB_OHB__c=evnt.Location_Based__c,
                                               Place_of_Work__c=evnt.Location_Custom__c,
                                               Number_of_Days__c=1,
                                               Sub_Activity_Report__c=pd.Id);
        insert pdi;
        
        List<UNILAB_PerDiem.EventListWrapper> fetchExistEventList = UNILAB_PerDiem.fetchExist(pd.Id);
        List<UNILAB_PerDiem.EventListWrapper> fetchEventList = UNILAB_PerDiem.fetch(null, null, null, '10', '1');
       
        List<Per_Diem_Item__c> perdiemList = new List<Per_Diem_Item__c>();
        Per_Diem_Item__c pdList = new Per_Diem_Item__c();
        List<Event> evntList = new List<Event>();
        
        for(UNILAB_PerDiem.EventListWrapper ev: fetchEventList) {
            pdList = new Per_Diem_Item__c(Exemption_Remarks__c = 'test');
            perdiemList.add(pdList);
            evntList.add(ev.objEvent);
        }
        
        List<Per_Diem_Item__c> perdiemExistList = new List<Per_Diem_Item__c>();
        Per_Diem_Item__c pdExistList = new Per_Diem_Item__c();
        List<Event> evntExistList = new List<Event>();
        
        for(UNILAB_PerDiem.EventListWrapper ev: fetchExistEventList) {
            pdExistList = new Per_Diem_Item__c(Exemption_Remarks__c = 'test');
            perdiemExistList.add(pdList);
            evntExistList.add(ev.objEvent);
        }
        
        Test.startTest();
        
        UNILAB_PerDiem.onUpdate(evntList, perdiemList, evntExistList, perdiemExistList, perdiemExistList, pd.Id);
        
        Test.stopTest();
        
        Per_Diem__c perdiem = [SELECT Id, Approval_Status__c FROM Per_Diem__c];
        
        System.assert(perdiem != null);
        System.assert(perdiem.Id != null);
        System.assertEquals('Draft', perdiem.Approval_Status__c);
        
    }
}