public without sharing class UNILAB_CompetitiveActivity_Export {
    
    public List<CompetitiveActivity> competitiveActivityList { get; set; }
    
    public class CompetitiveActivity {
        
        public String competitiveID { get; set; }
        public String competitiveName { get; set; }
        public List<String> photoID { get; set; }
        public String buName { get; set; }
        public String divisionName { get; set; }
        public List<String> brandName { get; set; }
        public String activityType { get; set; }
        public String activitySubType { get; set; }
        public String channelName { get; set; }
        public String channelGroup { get; set; }
        public Date dateValue { get; set; }
        public Date dateImplementedValue { get; set; }
        public String description { get; set; }
        public String accountName { get; set; }
        public String contactName { get; set; }
        public String reportedBy { get; set; }
        
    }
    
    public class FilterParameters {
        
        public String filterDateBySelected { get; set; }
        public String startDate { get; set; }
        public String endDate { get; set; }
        public Integer monthDate { get; set; }
        public Integer yearDate { get; set; }
        
    }
    
    public UNILAB_CompetitiveActivity_Export(ApexPages.StandardController controller) {
        
        String filterOptions = ApexPages.currentPage().getParameters().get('filterOptions');
        
        List<String> competitveActivityString = new List<String>();
        
        List<CompetitiveActivity> competitiveActivityList = new List<CompetitiveActivity>();
        
        if (String.isNotBlank(filterOptions)) {
            
            competitveActivityString = (List<String>) JSON.deserialize(filterOptions, List<String>.class);
            
            competitiveActivityList = displayDataInVFPage(competitveActivityString);
            
        }
        
        this.competitiveActivityList = competitiveActivityList;
        
        if (competitiveActivityList.size() > 0) {
            
            DateTime dateTimeNow = DateTime.now();
            String formattedDateTime = dateTimeNow.format('MMMM') + '-' + dateTimeNow.format('dd') + '-' + dateTimeNow.format('yyyy');
            
            String fileName = formattedDateTime + ' - ' + 'Trade Activity Feedback Report.pdf';        
            ApexPages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + fileName);
            
        }
        
    }
    
    @AuraEnabled
    public static String getCompetitiveActivity(String filterParameters) {
        
        if (filterParameters != null) {
            
            FilterParameters filterParam = (FilterParameters) JSON.deserialize(filterParameters, FilterParameters.class);
            String filterDateBySelected = filterParam.filterDateBySelected;
            String startDate = filterParam.startDate;
            String endDate = filterParam.endDate;
            Integer monthDate = filterParam.monthDate;
            Integer yearDate = filterParam.yearDate;
            
            String competitivaActivityQuery = 'SELECT Id, Name, Brand__c, BU__c, Division__c, Channel__c, ' +
                							  'Channel_Group__c, Competitive_Type__c, Competitive_Activity_Sub_Type__c, ' +
                							  'Date__c, Date_Implemented__c, Description__c, Account__r.Name, Owner.Name,' +
                							  'Contact__r.Name, (SELECT ContentDocumentId FROM ContentDocumentLinks LIMIT 3) ' +
                							  'FROM Competitive_Activity__c';
            
            if (String.isNotBlank(filterDateBySelected)) {
                
                if (filterDateBySelected.containsIgnoreCase('dateRangeByDateField')) {
                    
                    if (String.isNotBlank(startDate) && String.isNotBlank(endDate)) {
                        competitivaActivityQuery += ' WHERE Date__c >= ' + startDate + ' AND Date__c <= ' + endDate;
                    }
                    
                }
                
                if (filterDateBySelected.containsIgnoreCase('dateRangeByDateImplementedField')) {
                    
                    if (String.isNotBlank(startDate) && String.isNotBlank(endDate)) {
                        competitivaActivityQuery += ' WHERE Date_Implemented__c >= ' + startDate + ' AND Date_Implemented__c <= ' + endDate;
                    }
                    
                }
                
                if (filterDateBySelected.containsIgnoreCase('monthAndYear')) {
                    
                    if (monthDate == 0) {
                        competitivaActivityQuery += ' WHERE CALENDAR_YEAR(Date__c) = ' + yearDate;
                    }
                    
                    else {
                        competitivaActivityQuery += ' WHERE CALENDAR_MONTH(Date__c) = ' + monthDate + ' AND CALENDAR_YEAR(Date__c) = ' + yearDate;
                    }
                    
                }
                
                competitivaActivityQuery += ' ORDER BY Name ASC';
                
                System.debug(competitivaActivityQuery);
                
                List<CompetitiveActivity> newCompetitiveActivityWrapperList = new List<CompetitiveActivity>();
                
                List<Competitive_Activity__c> competitiveActivityList = Database.query(competitivaActivityQuery);
                
                List<String> contentDocumentIDList = new List<String>();
                
                for (Competitive_Activity__c competitiveActivityRec : competitiveActivityList) {
                    for (ContentDocumentLink contentDocumentLinkRec : competitiveActivityRec.ContentDocumentLinks) {
                        contentDocumentIDList.add(contentDocumentLinkRec.ContentDocumentId);
                    }
                }
                
                List<ContentVersion> contentVersionList = [SELECT Id,
                                                           		  ContentDocumentId
                                                           FROM ContentVersion
                                                           WHERE (ContentDocumentId IN :contentDocumentIDList)
                                                          ];
                
                Map<String, List<String>> contentVersionMap = new Map<String, List<String>>();
                
                for (ContentVersion contentVersionRec : contentVersionList) {
                    if (contentVersionMap.containsKey(contentVersionRec.ContentDocumentId)) {
                        contentVersionMap.get(contentVersionRec.ContentDocumentId).add(contentVersionRec.Id);
                    }
                    else {
                        contentVersionMap.put(contentVersionRec.ContentDocumentId, new List<String>{contentVersionRec.Id});
                    }
                }
                
                for (Competitive_Activity__c competitiveActivityRec : competitiveActivityList) {
                    
                    List<String> brands = new List<String>();
                    
                    if (!String.isEmpty(competitiveActivityRec.Brand__c)) {
                        
                        brands = competitiveActivityRec.Brand__c.split(';');
                        
                    }
                    
                    CompetitiveActivity compActivity = new CompetitiveActivity();
                    
                    compActivity.competitiveID = competitiveActivityRec.Id;
                    compActivity.competitiveName = competitiveActivityRec.Name;
                    compActivity.buName = competitiveActivityRec.BU__c;
                    compActivity.divisionName = competitiveActivityRec.Division__c;
                    compActivity.activityType = competitiveActivityRec.Competitive_Type__c;
                    compActivity.activitySubType = competitiveActivityRec.Competitive_Activity_Sub_Type__c;
                    compActivity.channelName = competitiveActivityRec.Channel__c;
                    compActivity.channelGroup = competitiveActivityRec.Channel_Group__c;
                    compActivity.dateValue = competitiveActivityRec.Date__c;
                    compActivity.dateImplementedValue = competitiveActivityRec.Date_Implemented__c;
                    compActivity.description = competitiveActivityRec.Description__c;
                    compActivity.brandName = brands;
                    compActivity.accountName = competitiveActivityRec.Account__r.Name;
                    compActivity.contactName = competitiveActivityRec.Contact__r.Name;
                    compActivity.reportedBy = competitiveActivityRec.Owner.Name;
                    
                    List<String> photoIDList = new List<String>();
                    
                    for (ContentDocumentLink contentDocumentLinkRec : competitiveActivityRec.ContentDocumentLinks) {
                        photoIDList.addAll(contentVersionMap.get(contentDocumentLinkRec.ContentDocumentId));
                    }
                    
                    compActivity.photoID = photoIDList;
                    
                    newCompetitiveActivityWrapperList.add(compActivity);
                    
                }
                
                return JSON.serialize(newCompetitiveActivityWrapperList);
                
            }
            
            else {
                
                return null;
                
            }
            
            
        }
        
        else {
            
            return null;
            
        }
        
    }
    
    public static List<CompetitiveActivity> displayDataInVFPage(List<String> competitiveIDList) {
        
        if (competitiveIDList.size() > 0) {
            
            List<CompetitiveActivity> newCompetitiveActivityWrapperList = new List<CompetitiveActivity>();
            
            List<Competitive_Activity__c> competitiveActivityList = [SELECT Id, 
                                                                     		Name, 
                                                                     		Brand__c, 
                                                                     		BU__c, 
                                                                     		Division__c,
                                                                     		Channel__c,
                                                                     		Channel_Group__c, 
                                                                     		Competitive_Type__c, 
                                                                     		Competitive_Activity_Sub_Type__c,
                                                                     		Date__c, 
                                                                     		Date_Implemented__c, 
                                                                     		Description__c, 
                                                                     		Account__r.Name,
                                                                     		Contact__r.Name,
                                                                     		Owner.Name,
                                                                     		(SELECT ContentDocumentId 
                                                                             FROM ContentDocumentLinks
                                                                             LIMIT 3
                                                                            )
                                                                            FROM Competitive_Activity__c 
                                                                     WHERE (Id IN  :competitiveIDList) 
                                                                     ORDER BY Name ASC
                                                                    ];
            
            List<String> contentDocumentIDList = new List<String>();
            
            for (Competitive_Activity__c competitiveActivityRec : competitiveActivityList) {
                for (ContentDocumentLink contentDocumentLinkRec : competitiveActivityRec.ContentDocumentLinks) {
                    contentDocumentIDList.add(contentDocumentLinkRec.ContentDocumentId);
                }
            }
            
            List<ContentVersion> contentVersionList = [SELECT Id,
                                                       ContentDocumentId
                                                       FROM ContentVersion
                                                       WHERE (ContentDocumentId IN :contentDocumentIDList)
                                                      ];
            
            Map<String, List<String>> contentVersionMap = new Map<String, List<String>>();
            
            for (ContentVersion contentVersionRec : contentVersionList) {
                if (contentVersionMap.containsKey(contentVersionRec.ContentDocumentId)) {
                    contentVersionMap.get(contentVersionRec.ContentDocumentId).add(contentVersionRec.Id);
                }
                else {
                    contentVersionMap.put(contentVersionRec.ContentDocumentId, new List<String>{contentVersionRec.Id});
                }
            }
            
            for (Competitive_Activity__c competitiveActivityRec : competitiveActivityList) {
                
                List<String> brands = new List<String>();
                
                if (!String.isEmpty(competitiveActivityRec.Brand__c)) {
                    
                    brands = competitiveActivityRec.Brand__c.split(';');
                    
                }
                
                CompetitiveActivity compActivity = new CompetitiveActivity();
                
                compActivity.competitiveID = competitiveActivityRec.Id;
                compActivity.competitiveName = competitiveActivityRec.Name;
                compActivity.buName = competitiveActivityRec.BU__c;
                compActivity.divisionName = competitiveActivityRec.Division__c;
                compActivity.activityType = competitiveActivityRec.Competitive_Type__c;
                compActivity.activitySubType = competitiveActivityRec.Competitive_Activity_Sub_Type__c;
                compActivity.channelName = competitiveActivityRec.Channel__c;
                compActivity.channelGroup = competitiveActivityRec.Channel_Group__c;
                compActivity.dateValue = competitiveActivityRec.Date__c;
                compActivity.dateImplementedValue = competitiveActivityRec.Date_Implemented__c;
                compActivity.description = competitiveActivityRec.Description__c;
                compActivity.brandName = brands;
                compActivity.accountName = competitiveActivityRec.Account__r.Name;
                compActivity.contactName = competitiveActivityRec.Contact__r.Name;
                compActivity.reportedBy = competitiveActivityRec.Owner.Name;
                
                List<String> photoIDList = new List<String>();
                
                for (ContentDocumentLink contentDocumentLinkRec : competitiveActivityRec.ContentDocumentLinks) {
                    photoIDList.addAll(contentVersionMap.get(contentDocumentLinkRec.ContentDocumentId));
                }
                
                compActivity.photoID = photoIDList;
                
                newCompetitiveActivityWrapperList.add(compActivity);
                
            }
            
            return newCompetitiveActivityWrapperList;
            
        }
        
        else {
            
            return null;
            
        }
        
        
    }
    
    @AuraEnabled
    public static List<String> getDateYear() {
        
        List<AggregateResult> competitiveActivityList = [SELECT CALENDAR_YEAR(Date__c) yearOfDate
                                                         FROM Competitive_Activity__c
                                                         WHERE (Date__c != null)
                                                         GROUP BY CALENDAR_YEAR(Date__c)
                                                         ORDER BY CALENDAR_YEAR(Date__c) DESC
                                                        ];
        
        List<String> yearList = new List<String>();
        
        for (AggregateResult aggResult : competitiveActivityList) {
            yearList.add(String.valueOf(aggResult.get('yearOfDate')));
        }
        
        return yearList;
        
    }    
    
    @AuraEnabled
    public static Map<String, String> getPicklistFields(String objectName, String fieldName) {
        return UNILAB_Utility.getPickilistFields(objectName, fieldName);
    }
    
    @AuraEnabled    
    public static Map<String, List<String>> getPicklistDependency(String objectName, String controllingFieldName, String dependentFieldName) {
        return UNILAB_CompetitiveActivity_Export_Util.getDependentPicklist(objectName, controllingFieldName, dependentFieldName);
    }
    

}