/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.20.2017
Definition   :   Test class for Event Cancellation Controller
History      :   07.20.2017 - Kiko Roberto:  Created
Modified By  :   KC Roberto
Modified Date: 	 08.20.2018
-------------------------------------------------------------------------------------------*/
@isTest
public class UNILAB_EventCancellationPageCXTest{
    
    // SCENARIO : Save records successfully, returns event status as CANCELLED   
    public static testMethod void testSaveEvent(){
        Event testEvent = new Event(Subject = 'Test',
                                    StartDateTime = dateTime.now(),
                                    EndDateTime = dateTime.now(), Created_from_Classic__c = true);
        insert testEvent;
        
        Test.startTest();
        Apexpages.currentpage().getparameters().put('id' , testEvent.Id);
        UNILAB_EventCancellationPageCX cont = new UNILAB_EventCancellationPageCX();
        cont.eventRec.Reason_for_Cancellation__c = 'Others';
        cont.eventRec.Others__c = 'Test';
        cont.saveEvent();
        Test.stopTest();
        
        System.assertEquals(testEvent.Id, cont.eventRec.Id);
        System.assertEquals('Others', cont.eventRec.Reason_for_Cancellation__c);
        System.assertEquals('Test', cont.eventRec.Others__c);
        System.assertEquals('Cancelled', cont.eventRec.Status__c);
    }
    
    /* SCENARIO :	If Reason_for_Cancellation__c is equal to 'Others', Other__c field is required
	   OUTPUT: 		Apex ERROR Message "Others field required."   */ 
    public static testMethod void testSaveEventNegative1(){
        Event testEvent = new Event(Subject = 'Test',
                                    StartDateTime = dateTime.now(),
                                    EndDateTime = dateTime.now(), Created_from_Classic__c = true);
        insert testEvent;
        
        Test.startTest();
        Apexpages.currentpage().getparameters().put('id' , testEvent.Id);
        UNILAB_EventCancellationPageCX cont = new UNILAB_EventCancellationPageCX();
        cont.eventRec.Reason_for_Cancellation__c = 'Others';
        cont.saveEvent();
        Test.stopTest();
        
        ApexPages.Message[] errorMessage = ApexPages.getMessages();
        System.assertEquals('Others field is required.', errorMessage.get(0).getSummary());
    }
    
    /* SCENARIO : If no Reason_for_Cancellation__c is selected
	   OUTPUT 	: Apex ERROR message "Please add a reason for cancellation." */
    
    public static testMethod void testSaveEventNegative2(){
        Event testEvent = new Event(Subject = 'Test',
                                    StartDateTime = dateTime.now(),
                                    EndDateTime = dateTime.now(), Created_from_Classic__c = true);
        insert testEvent;
        
        Test.startTest();
        Apexpages.currentpage().getparameters().put('id' , testEvent.Id);
        UNILAB_EventCancellationPageCX cont = new UNILAB_EventCancellationPageCX();
        cont.saveEvent();
        Test.stopTest();
        
        ApexPages.Message[] errorMessage = ApexPages.getMessages();
        System.assertEquals('Please add a reason for cancellation.', errorMessage.get(0).getSummary());
        
    }
    
    // SCENARIO :  If Subject is set to null
    public static testMethod void testSaveEventNegative3(){
        Event testEvent = new Event(Subject = 'Test',
                                    StartDateTime = dateTime.now(),
                                    EndDateTime = dateTime.now(), Created_from_Classic__c = true);
        insert testEvent;
        
        
        Test.startTest();
        Apexpages.currentpage().getparameters().put('id' , testEvent.Id);
        UNILAB_EventCancellationPageCX cont = new UNILAB_EventCancellationPageCX();
        cont.eventRec.Subject = null;
        cont.saveEvent();
        Test.stopTest();
        
        
        System.assertEquals(testEvent.Id, cont.eventRec.Id);
        System.assertEquals(null, cont.eventRec.Subject);
      
    }

}