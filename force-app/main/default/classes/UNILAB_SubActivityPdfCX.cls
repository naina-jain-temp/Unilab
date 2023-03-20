/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.24.2017
Definition   :   Controller for UNILAB_SubActivityPdf page
History      :   07.24.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
public class UNILAB_SubActivityPdfCX{
    
    public Event eventRec {get; set;}
    public List<Sub_Activity__c> subActMasterList {get; set;}
    public String startDate {get; set;}
    public String endDate {get; set;}
    public String downloadDate {get; set;}
    
    public UNILAB_SubActivityPdfCX(ApexPages.StandardController stdController) {
        
        downloadDate = date.today().format();
        
        this.eventRec = (Event)stdController.getRecord();
        subActMasterList = new List<Sub_Activity__c>();
        
        PageReference p = Apexpages.currentPage();
        p.getHeaders().put('content-disposition', 'inline; filename=' + 'MinutesofMeeting_' + downloadDate + '.pdf');
        
        try {
            
            eventRec = [SELECT Activity_Junction__c,
                        	   StartDateTime,
                        	   EndDateTime,
                        	   Event_Type__c,
                        	   Event_Sub_type__c
                        FROM Event
                        WHERE (Id = :eventRec.Id) AND (Event_Type__c = 'Meeting')
                       ];
            
            if (eventRec.Activity_Junction__c != NULL && eventRec != NULL) {
                
                startDate = eventRec.StartDateTime.date().format();
                endDate = eventRec.EndDateTime.date().format();
                
                subActMasterList = [SELECT Id,
                                    	   Activity_Name__c,
                                    	   Agenda__c,
                                    	   Attendees__c,
                                    	   Discussions__c,
	                                       Next_Steps_Directions__c
                                    FROM Sub_Activity__c
                                    WHERE (Activity_Junction__c = :eventRec.Activity_Junction__c)
                                   ];
                
                if (subActMasterList.size() == 0) {
                    
                    subActMasterList = null;
                    
                }
                
            }
        }
        
        catch (Exception e) {
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Cannot Generate Report because Event Type and Event Sub Type is not Meeting');
            ApexPages.addMessage(msg);
        
        }
    
    }
}