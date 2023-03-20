/*-------------------------------------------------------------------------------------------
Author       :   Joan Bautista
Created Date :   08.22.2018
Definition   :   Controller for Training Contact Report Lightning Component
-------------------------------------------------------------------------------------------*/

public class UNILAB_TrainingContactController {      
    
    public static final String STATUS_DRAFT = 'Draft';
    public static final String STATUS_PENDING_CONCURRENCE = 'Pending Concurrence';    
    public static final String STATUS_PENDING_APPROVAL = 'Pending Approval';
    public static final String STATUS_APPROVED = 'Approved';
    public static final String TCR_TYPE_TRADE = 'Account TCR';
    public static final String TCR_TYPE_T3 = 'T3 TCR';
    
    public static final String ERROR_RECORD_EXIST = 'TCR already exist. ';
    public static final String ERROR_CREATING_RECORD = 'Error in creating record. ';
    public static final String ERROR_SAVING_RECORD = 'Error in saving record. ';
    public static final String ERROR_RETRIEVING_RECORD = 'Error in retrieving record. ';
    public static final String ERROR_INVALID_STATUS = 'Invalid status for TCR. ';
    public static final String ERROR_RECORD_NOT_EXIST = 'TCR Record does not exist. '; 
    public static final String ERROR_NO_WORKPLAN_FOUND = 'No workplan found to create TCR. ';
    public static final String ERROR_NO_MATRIX_CONFIG_FOUND = 'No access to create TCR. ';
    public static final String ERROR_ASSIGN_ACCOUNT = 'Error assigning account to call. ';     
    public static final String ERROR_INVALID_STATUS_UPDATE = 'User is not allowed to update TCR status. ';
    public static final String ERROR_INVALID_APPROVER = 'No approver found to approve this record. ';
    public static final String ERROR_INVALID_TCRTYPE = 'Event Type is not valid to create TCR. ';
    public static final String ERROR_TCR_RETRIEVAL = 'Error in retrieving TCR Record Type. ';
    public static final String ERROR_WORKPLAN_RETRIEVAL = 'Error in retrieving Work Plan of CDS. ';
    public static final String ERROR_NO_WORKPLAN_WORK_WITH = 'No workplan found for your CDS. ';
    public static final String ERROR_DELETING_CALL = 'Error in deleting record. ';    
    
    @AuraEnabled
    public static Map<String, String> getCustomFieldInfo(String objectName, String tcrType){
        System.debug('getCustomFieldInfo');
        Map<String, String> fieldLabelMap = new Map<String, String>();        
        Map<String, Schema.SObjectField> objFieldsMap = UNILAB_Utility.getSObjectType(objectName).getDescribe().fields.getMap();  
        
        List<String> requiredFields = new List<String>();      
        
        for(TCR_Required_Fields_Config__c config: [SELECT Required_Field__c,TCR_Type__c 
                                                   FROM TCR_Required_Fields_Config__c 
                                                   WHERE TCR_Type__c =:  tcrType]){
                                                       requiredFields.add(config.Required_Field__c.toLowerCase());                                                                                                             
                                                   }
        
        Boolean isWithRequiredConfig = (requiredFields != null && !requiredFields.isEmpty());
        
        for(String key : objFieldsMap.keySet()){                         
            DescribeFieldResult fieldDesc = objFieldsMap.get(key).getDescribe();
            
            if(fieldDesc.isCustom()){                   
                List<String> fieldPickListValues = new List<String>();
                
                if(fieldDesc.getType() == schema.DisplayType.PICKLIST){                    
                    for(Schema.PicklistEntry picklistEntry: fieldDesc.getPicklistValues()){
                        fieldPickListValues.add(picklistEntry.getValue());
                    }                     
                }                                               
                CustomFieldInfo fieldInfo = new CustomFieldInfo(fieldDesc.getLabel(), fieldDesc.getInlineHelpText(), 
                                                                fieldPickListValues, (isWithRequiredConfig && requiredFields.contains(key)));                                
                fieldLabelMap.put(key,  JSON.serializePretty(fieldInfo));        
            }                                  
        }
        
        return fieldLabelMap;
    }    
    
    private static Training_Contact_Report__c createDraftTcr(Event trainingContactEvent, User eventOwner, String tcrType){
        System.debug('createDraftTcr');
        Training_Contact_Report__c newTCR = new Training_Contact_Report__c();      
        
        if(trainingContactEvent != null){
            
            User tlUser = getUser(trainingContactEvent.OwnerId);
            
            if(trainingContactEvent.Work_With_ID__c != null){                                
                User cdsUser = getUser(trainingContactEvent.Work_With_ID__c);  
                
                newTCR.CDS_Trainee__c = cdsUser.Id;
                newTCR.CDS_Trainee__r = cdsUser;
                
                newTCR.Team_Leader_Trainer__c = tlUser.Id;
                newTCR.Team_Leader_Trainer__r = tlUser;            
                
            }else{
                
                Contact dfs = getContact(trainingContactEvent.WhoId);
                
                User tl = getApprover(tlUser);
                
                if(tl == null){
                    AuraHandledException ex = new AuraHandledException(ERROR_INVALID_APPROVER);
                    ex.setMessage(ERROR_INVALID_APPROVER);
					throw ex;		 
                }else{
                    newTCR.Team_Leader_Trainer__c = tl.Id;
                    newTCR.Team_Leader_Trainer__r = tl;                     
                }
                
                newTCR.DFS__c = dfs.Id;
                newTCR.DFS__r = dfs;            
                
                newTCR.CDS_Trainee__c = tlUser.Id;
                newTCR.CDS_Trainee__r = tlUser;
            }
            
            User approver = getApprover(newTCR.Team_Leader_Trainer__r);                
            if(approver == null){
                AuraHandledException ex = new AuraHandledException(ERROR_INVALID_APPROVER);
                ex.setMessage(ERROR_INVALID_APPROVER);
				throw ex;		 
            }else{
                newTCR.Channel_Head__c = approver.Id;
            }
            
            newTCR.RecordType = getTcrRecordTypeById(trainingContactEvent.Field_Work_Record_Type__c);                        
            newTCR.Activity_Junction__c = trainingContactEvent.Activity_Junction__c;
            newTCR.Status__c = STATUS_DRAFT;                        
            newTCR.Date__c = Date.today();                                         
            
            
            Training_Contact_Report__c prevTCR = getPreviousTCR(newTCR);
            
            if(prevTCR != null){
                newTCR.isWithPreviousTcr__c = true;
                newTCR.Skill_1__c = prevTCR.Closing_Skill_1__c;
                newTCR.Specific_Skill_Development_1__c = prevTCR.Closing_Specific_Skill_Development_1__c;
                newTCR.Skill_Remarks_1__c = prevTCR.Closing_Skill_Remarks_1__c;
                newTCR.Skill_2__c = prevTCR.Closing_Skill_2__c;
                newTCR.Specific_Skill_Development_2__c = prevTCR.Closing_Specific_Skill_Development_2__c;
                newTCR.Skill_Remarks_2__c = prevTCR.Closing_Skill_Remarks_2__c;                
            }
        }
        
        return newTCR;
    } 
    
    private static Training_Contact_Report__c getPreviousTCR(Training_Contact_Report__c currentTcr){
        System.debug('getPreviousTCR');
        
        Training_Contact_Report__c prevTcr;
        
        try{
            
            List<Training_Contact_Report__c> prevTcrList = [SELECT Id,Closing_Skill_1__c,Closing_Skill_Remarks_1__c,Closing_Skill_2__c,Closing_Skill_Remarks_2__c,
                                                            Date__c,Team_Leader_Trainer__c,CDS_Trainee__c,Closing_Specific_Skill_Development_1__c,
                                                            Closing_Specific_Skill_Development_2__c                             
                                                            FROM Training_Contact_Report__c WHERE (CDS_Trainee__c =: currentTcr.CDS_Trainee__c
                                                                                                   AND Team_Leader_Trainer__c =: currentTcr.Team_Leader_Trainer__c
                                                                                                   AND Date__c <: currentTcr.Date__c
                                                                                                   AND Status__c =: STATUS_APPROVED
                                                                                                  )
                                                            ORDER BY Date__c DESC LIMIT 1 ];
            
            
            if(prevTcrList != null && prevTcrList.size() > 0){
                prevTcr = prevTcrList[0];
            }
            
        }catch(Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('Error in creating record: '
                                           + e.getMessage());              
        }
        
        return prevTcr;
    }  
    
    private static User getUser(String userId){
        System.debug('getUser');
        User user;
        
        List<User> userList = [SELECT Name, UserRole.Name, ManagerId FROM User WHERE Id =: userId];
        
        if(userList != null && !userList.isEmpty()){
            user = userList[0];
        }    
        
        return user;
    }
    
    private static User getApprover(User tlUser){
        System.debug('getApprover');
        User approver;
        
        List<User> approverList =  [SELECT Id,ManagerId,Name FROM User WHERE Id =: tlUser.ManagerId];    
        
        if(approverList != null && !approverList.isEmpty()){
            approver = approverList[0];
        }   
        
        return approver;
    }
    
    private static Contact getContact(String contactID){
        System.debug('getContact');
        Contact contact;
        
        List<Contact> contactList = [SELECT Id, Name  FROM Contact WHERE Id =: contactID];   
        
        if(contactList != null && !contactList.isEmpty()){
            contact = contactList[0];
        }   
        
        return contact;
        
    }
    
    @AuraEnabled
    public static Boolean isValidUser(Training_Contact_Report__c tcr){
        System.debug('isValidUser');
        Boolean isValid = false;
        String loggedInUserId  = UserInfo.getUserId();
        String channelHeadId = tcr.Channel_Head__c; 
        String dfsId = tcr.DFS__c;
        String tlId = tcr.Team_Leader_Trainer__c;
        String cdsId = tcr.CDS_Trainee__c; 
        User dfs = tcr.CDS_Trainee__r; 
        Boolean showError = true;
        if(tcr.Status__c.equalsIgnoreCase(STATUS_DRAFT)){
            if(tcr.RecordType.Name.equalsIgnoreCase(TCR_TYPE_T3) && tcr.DFS__c != null){               
                if(cdsId.equalsIgnoreCase(loggedInUserId)){
                    isValid = true;
                }
            }else{
                if(tlId.equalsIgnoreCase(loggedInUserId)){
                    isValid = true;
                }else{
                    isValid = true;
                    showError = false;
                }
            }            
        }else if(tcr.Status__c.equalsIgnoreCase(STATUS_PENDING_CONCURRENCE)){
            
            if(cdsId.equalsIgnoreCase(loggedInUserId)){
                isValid = true;
            }else{
                if(tlId.equalsIgnoreCase(loggedInUserId)){
                    isValid = false;
                    showError = false;                      
                }
            }
        }else if(tcr.Status__c.equalsIgnoreCase(STATUS_PENDING_APPROVAL)){
            
            if(channelHeadId.equalsIgnoreCase(loggedInUserId) && dfsId == null){
                isValid = true;
            }else if(dfsId != null && tlId.equalsIgnoreCase(loggedInUserId)){
                isValid = true;
            }
        }
        
        if(!isValid && showError){
            AuraHandledException ex = new AuraHandledException(ERROR_INVALID_STATUS_UPDATE);
            ex.setMessage(ERROR_INVALID_STATUS_UPDATE);
            throw ex;  
        }
        
        return isValid;
    }
    
    @AuraEnabled
    public static Training_Contact_Report__c saveTCR(Training_Contact_Report__c currentTcr, String tcrCalls){
        System.debug('saveTCR');
        
        List<Training_Contact_Report_Call__c> tcrCallList;
        List<Training_Contact_Report_Call__c> tcrT3CallList;
        
        if(tcrCalls != null && tcrCalls != '[\"{}\"]'){
            tcrCallList = (List<Training_Contact_Report_Call__c>)JSON.deserialize(tcrCalls, List<Training_Contact_Report_Call__c>.class);    
        }
        
        Boolean isNew = currentTcr.Id == null;
        
        if(currentTcr != null){
            try{  
                
                if(currentTcr.Id == null){
                    currentTcr.RecordTypeId =  Schema.SObjectType.Training_Contact_Report__c.getRecordTypeInfosByName().get(currentTcr.RecordType.Name).getRecordTypeId();
                }
                
                upsert currentTcr;	                               
                
                if(tcrCallList !=null && 
                   !tcrCallList.isEmpty() && 
                   (currentTcr.RecordType.Name.equalsIgnoreCase(TCR_TYPE_TRADE) || currentTcr.RecordType.Name.equalsIgnoreCase(TCR_TYPE_T3))){
                       tcrT3CallList = new List<Training_Contact_Report_Call__c>();
                       for(Training_Contact_Report_Call__c tcrCall: tcrCallList){
                           
                           if(tcrCall.Id== null){
                               tcrCall.TCR__c = currentTcr.Id;    
                           } 
                           if(currentTcr.RecordType.Name.equalsIgnoreCase(TCR_TYPE_T3)){
                               if(tcrCall.Account__c != null){
                                   tcrT3CallList.add(tcrCall);    
                               }                                   
                           }                                                                              
                       }
                       
                       if(currentTcr.RecordType.Name.equalsIgnoreCase(TCR_TYPE_T3)){
                           upsert tcrT3CallList;
                       }else{
                           upsert tcrCallList;
                       }
                   }
                
                currentTcr =  getTcrRecord(currentTcr.Id);
                
                if(isNew){
                    
                    Event ownerEvent = getEventByActivityJunction(currentTcr.Activity_Junction__c);
                    
                    if(ownerEvent != null){
                        
                        ownerEvent.TCR_Name__c = currentTcr.Name;
                        ownerEvent.TCR_Id__c = currentTcr.Id;
                        
                        update ownerEvent;
                        
                    }                    
                }
                
            }catch(DmlException e){              
                throw new AuraHandledException(
                    ERROR_SAVING_RECORD + e.getMessage());                
            }            
        }
        
        
        return currentTcr;
    }   
    
    @AuraEnabled
    public static Training_Contact_Report__c updateTCRStatus(Training_Contact_Report__c currentTcr){
        System.debug('updateTCRStatus');
        Boolean isValid = isValidUser(currentTcr);
        
        if(isValid){
            if(currentTcr.Status__c.equalsIgnoreCase(STATUS_DRAFT)){
                if(currentTcr.DFS__c != null){
                    currentTcr.Status__c = STATUS_PENDING_APPROVAL;
                    // currentTcr.OwnerId = currentTcr.Team_Leader_Trainer__c;
                }else{
                    currentTcr.Status__c = STATUS_PENDING_CONCURRENCE;	        
                    //                    currentTcr.OwnerId = currentTcr.CDS_Trainee__c;
                }            
            }else if(currentTcr.Status__c.equalsIgnoreCase(STATUS_PENDING_CONCURRENCE)){
                currentTcr.Status__c = STATUS_PENDING_APPROVAL;
                //  currentTcr.OwnerId = currentTcr.Channel_Head__c;
            }else if(currentTcr.Status__c.equalsIgnoreCase(STATUS_PENDING_APPROVAL)){
                currentTcr.Status__c = STATUS_APPROVED;
                //  currentTcr.OwnerId = currentTcr.CDS_Trainee__c;
            }else{
                AuraHandledException ex = new AuraHandledException(ERROR_INVALID_STATUS);
                ex.setMessage(ERROR_INVALID_STATUS);
                throw ex;                       
            }   
            
            return saveTCR(currentTcr, null);  
        }
        
        return currentTcr;
    }   
    
    @AuraEnabled       
    public static void updateRecOwner(Training_Contact_Report__c tcr){
        System.debug('updateRecOwner');
        String userId;
        Boolean shareRecord = true;
        if(tcr.Status__c.equalsIgnoreCase(STATUS_PENDING_CONCURRENCE)){            
            userId = tcr.CDS_Trainee__c;            
        }else if(tcr.Status__c.equalsIgnoreCase(STATUS_PENDING_APPROVAL)){
            if(tcr.DFS__c != null){
                userId = tcr.Team_Leader_Trainer__c;
                shareRecord = false;
            }else{
                shareRecord = false;
            }                             
        }else if(tcr.Status__c.equalsIgnoreCase(STATUS_APPROVED)){            
            userId = tcr.CDS_Trainee__c;
            shareRecord = false;
        }else{
            AuraHandledException ex = new AuraHandledException(ERROR_INVALID_STATUS);
            ex.setMessage(ERROR_INVALID_STATUS);
            throw ex;                       
        }
        
        if(shareRecord){
            setSharingRecordCustom(tcr.Id, userId);        
        }        
    }
    
    public static void setSharingRecordCustom(id recordId, id userOrGroupId){
        System.debug('setSharingRecordCustom');
        try{
            Training_Contact_Report__Share recordShare = new Training_Contact_Report__Share(); 
            
            recordShare.AccessLevel = 'Edit';
            recordShare.UserOrGroupId = userOrGroupId;
            recordShare.ParentId = recordId;
            
            Database.SaveResult sr = Database.insert(recordShare);
            
            if(sr.isSuccess()){
                // Indicates success
                System.debug('SUCCESS');
            }
            else {
                // Get first save result error.
                Database.Error err = sr.getErrors()[0];
                
                if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                   err.getMessage().contains('AccessLevel')){
                       System.debug('SUCCESS');
                   }
                else{
                    System.debug('FAILED');
                }
            }        
        }catch(DmlException e){
            throw new AuraHandledException(
                ERROR_SAVING_RECORD + e.getMessage());     
        }        
    }
    
    public static RecordType getTcrRecordTypeById(String recId){
        System.debug('getTcrRecordTypeById');
        RecordType recType;
        
        try{
            List<RecordType> tcrRecTypeList = [SELECT Id,Name from RecordType where sObjectType = 'Training_Contact_Report__c' AND Id =: recId];                                                  
            System.debug(tcrRecTypeList);
            if(tcrRecTypeList != null && !tcrRecTypeList.isEmpty()){
                recType =  tcrRecTypeList[0];
            }
            
        }catch(DmlException e){
            throw new AuraHandledException(ERROR_TCR_RETRIEVAL + e.getMessage());  
        }
        
        return recType;
    }
    
    @AuraEnabled
    public static Training_Contact_Report__c getTcrRecord(String recordId) {   
        System.debug('getTcrRecord');
        Training_Contact_Report__c tcrRec;
		Boolean isNewTcr = false;						 
        
        try{            
            List<Event> eventList = [SELECT Id, Activity_Junction__c, Event_Type__c, Event_Sub_type__c, OwnerId, Owner.Name, StartDateTime, 
                                     Work_With_ID__c, WhoId, ActivityDate, Field_Work_Record_Type__c
                                     FROM Event
                                     WHERE Id =: recordId];
            
            if(eventList != null && !eventList.isEmpty()){
                Event tlEvent = eventList[0];           
                
                List<TCR_Matrix__c> tcrMatrixList = getTcrMatrix(tlEvent);
                
                if(tcrMatrixList != null && !tcrMatrixList.isEmpty()){    
                    TCR_Matrix__c tcrMatrix = tcrMatrixList[0];
                    
                    Training_Contact_Report__c existingTcr = getTcrRecordByActivityJunction(tlEvent.Activity_Junction__c); 
                    //For Testing - MSS-0005 Ticket
                    List<String> subEvntType = new List<String>();
                    for(TCR_Matrix__c tcrMatrix_Test : tcrMatrixList){
                        subEvntType.add(tcrMatrix_Test.Event_Sub_type__c);
                    }
                    
                    System.debug(subEvntType);
                    //End
                    if(existingTcr != null){
                        tcrRec = getTcrRecordById(existingTcr.Id);
                    }else{   
                        System.debug('cdsEvent');
                        //Check for event of CDS                    
                        List<Event> cdsEvent = [SELECT Id, Activity_Junction__c, Event_Type__c, Event_Sub_type__c, OwnerId, Owner.Name, StartDateTime, EndDateTime, 
                                                Related_To_Account__c, Related_To_Account__r.Name 
                                                FROM Event 
                                                WHERE (OwnerId =: tlEvent.Work_With_ID__c 
                                                       AND Event_Type__c =: tcrMatrix.Event_Type__c
                                                       AND Event_Sub_type__c IN :subEvntType
                                                       AND ActivityDate = : tlEvent.ActivityDate) 
                                               ];
                        
                        System.debug(tlEvent.Work_With_ID__c );
                         System.debug( tcrMatrix.Event_Type__c);
                         System.debug(subEvntType );
                         System.debug(tlEvent.ActivityDate );
                        
                        //AND Event_Sub_type__c =: tcrMatrix.Event_Sub_Type__c
                        //AND Event_Sub_type__c IN :subEvntType
                        
                        if(tlEvent.Work_With_ID__c != null && (cdsEvent == null || cdsEvent.isEmpty())){
                            AuraHandledException ex = new AuraHandledException(ERROR_NO_WORKPLAN_WORK_WITH);
                            ex.setMessage(ERROR_NO_WORKPLAN_WORK_WITH);
                            throw ex;   
                        }else{
							isNewTcr = true;				
                            tcrRec =  createDraftTcr(tlEvent, getUser(tlEvent.OwnerId), tcrMatrixList[0].TCR_Type__c);                                                                                
                        }
                    }                   
                }else{                   
                    AuraHandledException ex = new AuraHandledException(ERROR_NO_MATRIX_CONFIG_FOUND);
                    ex.setMessage(ERROR_NO_MATRIX_CONFIG_FOUND);
                    throw ex;                        
                }
            }else{                
                tcrRec = getTcrRecordById(recordId);                
            }                                                
        }catch(Exception e){           
            System.debug(e.getMessage());
            throw new AuraHandledException((isNewTcr ?ERROR_CREATING_RECORD:ERROR_RETRIEVING_RECORD) + e.getMessage());   
        }
        
        return tcrRec;
    }   
    
    private static List<TCR_Matrix__c> getTcrMatrix(Event tcrOwnerEvent ){
        System.debug('getTcrMatrix');
        List<TCR_Matrix__c> tcrMatrixList;
        String tcrType;
        RecordType tcrRecType = getTcrRecordTypeById(tcrOwnerEvent.Field_Work_Record_Type__c);        
        
        if(tcrRecType != null){
            tcrType = String.valueOf(tcrRecType.Name).toUpperCase();
        }else{
            AuraHandledException ex = new AuraHandledException(ERROR_INVALID_TCRTYPE);
            ex.setMessage(ERROR_INVALID_TCRTYPE);
            throw ex;                    
        }
        
        User eventOwner = getUser(tcrOwnerEvent.OwnerId);
        
        try{
            tcrMatrixList = [SELECT Id, TL_Event_Sub_Type__c,TL_Event_Type__c,Event_Sub_Type__c,Event_Type__c,Role__c,TCR_Type__c
                             FROM TCR_Matrix__c 
                             WHERE Role__c =:  eventOwner.UserRole.Name
                             AND TL_Event_Type__c =: tcrOwnerEvent.Event_Type__c
                             AND TL_Event_Sub_Type__c =: tcrOwnerEvent.Event_Sub_type__c
                             AND TCR_Type__c =: tcrType
                            ];
            
            System.debug(tcrMatrixList);
            
        }catch(DmlException e){
            throw new AuraHandledException(ERROR_WORKPLAN_RETRIEVAL + e.getMessage());   
        }
        
        return tcrMatrixList;
        
    }
    
    public static Event getEventByActivityJunction(String junctionId){
        List<Event> eventList = [SELECT Id, TCR_Id__c, TCR_Name__c FROM Event WHERE Activity_Junction__c =: junctionId];
        Event eventRec;
        
        if(eventList != null && !eventList.isEmpty()){
            eventRec = eventList[0];
        }
        
        return eventRec;
    }
    
    public static Training_Contact_Report__c getTcrRecordByActivityJunction(String junctionId){
        
        Training_Contact_Report__c tcr;
        
        List<Training_Contact_Report__c> tcrList = [SELECT Id, Activity_Junction__c 
                                                    FROM Training_Contact_Report__c 
                                                    WHERE Activity_Junction__c =: junctionId];
        
        if(tcrList != null && !tcrList.isEmpty()){
            tcr = tcrList[0];
        }
        
        return tcr;
    }
    
    private static Training_Contact_Report__c getTcrRecordById(String recordId){
        System.debug('getTcrRecordById');
        Training_Contact_Report__c tcrRec;
        
        SObjectType objectDesc = UNILAB_Utility.getSObjectType('Training_Contact_Report__c');            
        Map<String, Schema.SObjectField> a_fields = objectDesc.getDescribe().fields.getMap();
        
        String tcrFields = 'CDS_Trainee__r.Name,Team_Leader_Trainer__r.Name,DFS__r.Name,RecordType.Name';
        for(Schema.sObjectField fld:a_fields.values()){               
            tcrFields+=', ' + fld;                               
        }
        
        SObjectType tcrCallDesc = UNILAB_Utility.getSObjectType('Training_Contact_Report_Call__c');            
        Map<String, Schema.SObjectField> tcrCallFieldMap = tcrCallDesc.getDescribe().fields.getMap();
        
        String tcrCallFields = 'Account__r.Name';
        
        for(Schema.sObjectField fld:tcrCallFieldMap.values()){               
            tcrCallFields+=', ' + fld;                               
        }
        String callChildQuery = '(SELECT ' + tcrCallFields + ' FROM Training_Contact_Report_Calls__r)'; 
        
        
        System.debug('SELECT ' + tcrFields + ', ' + callChildQuery +
                     ' FROM Training_Contact_Report__c ' +
                     'WHERE Id = \'' + recordId+ '\'');
        
        
        List<Training_Contact_Report__c> tcrRecList = Database.query('SELECT ' + tcrFields + ', ' + callChildQuery +
                                                                     ' FROM Training_Contact_Report__c ' +
                                                                     'WHERE Id = \'' + recordId+ '\'');
        if(tcrRecList != null && !tcrRecList.isEmpty()){          
            tcrRec = tcrRecList[0];
            List<Training_Contact_Report_Call__c> calls = tcrRec.Training_Contact_Report_Calls__r;                                                
        }else{                                 
            AuraHandledException ex = new AuraHandledException(ERROR_RECORD_EXIST);
            ex.setMessage(ERROR_RECORD_NOT_EXIST);
            throw ex;
        } 
        return tcrRec;   
    }
    
    @AuraEnabled
    public static Map<String, String> getMapRequiredFieldsByPageNo(String tcrType){
        System.debug('getMapRequiredFieldsByPageNo');
        
        Map<String, String> requiredFieldMap = new Map<String, String>();
        
        List<TCR_Required_Fields_Config__c> requiredFieldList = [SELECT Page_No__c,Required_Field__c,TCR_Type__c 
                                                                 FROM TCR_Required_Fields_Config__c 
                                                                 WHERE TCR_Type__c =:  tcrType];
        
        for(AggregateResult ar: [SELECT Page_No__c
                                 FROM TCR_Required_Fields_Config__c 
                                 WHERE TCR_Type__c =:  tcrType GROUP BY Page_No__c ORDER BY Page_No__c]){
                                     
                                     String pageNo = (String)ar.get('Page_No__c');
                                     
                                     List<String> requiredList = new List<String>();
                                     for(TCR_Required_Fields_Config__c config: requiredFieldList){
                                         if(pageNo.equalsIgnoreCase(config.Page_No__c)){
                                             requiredList.add(config.Required_Field__c.toLowerCase());
                                         }                                
                                     }
                                     
                                     requiredFieldMap.put(pageNo, JSON.serializePretty(requiredList));
                                 }      
        
        return requiredFieldMap;
    }      
    
    @AuraEnabled
    public static List<Training_Contact_Report_Call__c> getCdsCalls(Training_Contact_Report__c tcr){
        System.debug('getCdsCalls');
        
        List<Training_Contact_Report_Call__c> cdsCallsList;
        
        try{
            
            if(tcr.Id != null){                
                SObjectType objectDesc = UNILAB_Utility.getSObjectType('Training_Contact_Report_Call__c');
                
                Map<String, Schema.SObjectField> a_fields = objectDesc.getDescribe().fields.getMap();
                
                String fields = 'Account__r.Name';
                for(Schema.sObjectField fld:a_fields.values()){               
                    fields +=', ' + fld;                               
                }
                
                cdsCallsList = Database.query('SELECT ' + fields +
                                              ' FROM Training_Contact_Report_Call__c ' +
                                              'WHERE TCR__c = \'' + tcr.Id + '\'');
                
                if(cdsCallsList == null || (cdsCallsList != null && cdsCallsList.isEmpty())){
                    Training_Contact_Report_Call__c call = new Training_Contact_Report_Call__c();       
                    call.Call_No__c = 1;
                    cdsCallsList.add(call);  
                }                
            }else{                
                if(tcr.RecordType.Name.equalsIgnoreCase(TCR_TYPE_TRADE)){
                    
                    
                    List<Event> cdsWorkPlanList = getWorkPlanCDS(tcr);
                    
                    if(cdsWorkPlanList != null && !cdsWorkPlanList.isEmpty()){                    
                        cdsCallsList = populateTCRcalls(cdsWorkPlanList);
                    }else{
                        AuraHandledException ex = new AuraHandledException(ERROR_NO_WORKPLAN_WORK_WITH);
                        ex.setMessage(ERROR_NO_WORKPLAN_WORK_WITH);
                        throw ex;  
                    }
                    
                }else if(tcr.RecordType.Name.equalsIgnoreCase(TCR_TYPE_T3)){
                    cdsCallsList = new List<Training_Contact_Report_Call__c>();
                    Training_Contact_Report_Call__c call = new Training_Contact_Report_Call__c();                                        
                    cdsCallsList.add(call);                   
                }                
            }    
        }catch(Exception e){
            throw new AuraHandledException('Error in retrieving record '
                                           + e.getMessage());   
        }
        
        return cdsCallsList; 
    }
    
    @AuraEnabled
    public static Account getAccount(String accountId){
        System.debug('getAccount');
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Id =: accountId];
        Account acc;
        
        if(accList != null && !accList.isEmpty()){
            acc = accList[0];
        }
        return acc;
    }
    
    public static List<Event> getWorkPlanCDS(Training_Contact_Report__c tcr){   
        System.debug('getWorkPlanCDS');
        Event tlEvent;
        String tcrType;
        
        
        List<Event> eventList = [SELECT Id, Activity_Junction__c, Event_Type__c, Event_Sub_type__c, OwnerId, Owner.Name, StartDateTime, 
                                 Work_With_ID__c, WhoId, ActivityDate, Field_Work_Record_Type__c
                                 FROM Event
                                 WHERE Activity_Junction__c =: tcr.Activity_Junction__c];
        
        if(eventList != null && !eventList.isEmpty()){
            tlEvent = eventList[0];
        }
        
        List<TCR_Matrix__c> tcrMatrixList = getTcrMatrix(tlEvent);       
        TCR_Matrix__c tcrMatrix =  tcrMatrixList[0];
        Date tlEventDate = tlEvent.ActivityDate;
        //For Testing - MSS-0005 Ticket
        List<String> subEvntType = new List<String>();
        for(TCR_Matrix__c tcrMatrix_Test : tcrMatrixList){
            subEvntType.add(tcrMatrix_Test.Event_Sub_type__c);
        }
        System.debug(subEvntType);
        //End
        return  [SELECT Id, Activity_Junction__c, Event_Type__c, Event_Sub_type__c, OwnerId, Owner.Name, StartDateTime, EndDateTime, 
                 Related_To_Account__c, Related_To_Account__r.Name 
                 FROM Event 
                 WHERE (OwnerId =: tcr.CDS_Trainee__c
                        AND Event_Type__c =: tcrMatrix.Event_Type__c
                        AND Event_Sub_type__c IN :subEvntType
                        AND ActivityDate = :tlEventDate) 
													  
                 ORDER BY CreatedDate ASC LIMIT 4];
        
        //AND Event_Sub_type__c =: tcrMatrix.Event_Sub_Type__c
    }
    
    public static List<Training_Contact_Report_Call__c> populateTCRcalls(List<Event> workPlanCDSlist){
        System.debug('populateTCRcalls');
        List<Training_Contact_Report_Call__c> calls = new List<Training_Contact_Report_Call__c>();
        Integer ctr = 0;
        for(Event e: workPlanCDSlist){
            
            Training_Contact_Report_Call__c call = new Training_Contact_Report_Call__c();                       
            call.Account__c = e.Related_To_Account__c;  
            call.Account__r = e.Related_To_Account__r;                 
            call.Call_No__c = ctr+=1;
            
            calls.add(call);
        }
        
        return calls;
    }  
    
    @AuraEnabled
    public static List<Training_Contact_Report_Call__c> addTcrCallAccount(String callNo, String accountId, String tcrCalls){                        
        System.debug('addTcrCallAccount');
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        try{
            if(tcrCalls != null && tcrCalls != '[\"{}\"]' && accountId != null && callNo != null){
                tcrCallList = (List<Training_Contact_Report_Call__c>)JSON.deserialize(tcrCalls, List<Training_Contact_Report_Call__c>.class);    
                
                Training_Contact_Report_Call__c call = new Training_Contact_Report_Call__c();
                call.Account__r = getAccount(accountId);
                call.Call_No__c = Integer.valueOf(callNo);
                call.Account__c = accountId;    
                tcrCallList.add(call);
            }
        }catch(Exception e){
            throw new AuraHandledException(
                ERROR_ASSIGN_ACCOUNT + e.getMessage()); 
        }
        
        return tcrCallList;
    }
    
    @AuraEnabled
    public static List<Training_Contact_Report_Call__c> editTcrCallAccount(String callNo, String accountId, String tcrCalls){                        
        System.debug('editTcrCallAccount');
        
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        try{
            if(tcrCalls != null && tcrCalls != '[\"{}\"]' && accountId != null && callNo != null){
                tcrCallList = (List<Training_Contact_Report_Call__c>)JSON.deserialize(tcrCalls, List<Training_Contact_Report_Call__c>.class);    
                
                for(Training_Contact_Report_Call__c call : tcrCallList){
                    
                    if(call.Call_No__c == Integer.valueOf(callNo)){                      
                        call.Account__c = accountId;
                        call.Account__r = getAccount(accountId);
                    }
                }               
            }
        }catch(Exception e){
            throw new AuraHandledException(
                ERROR_ASSIGN_ACCOUNT + e.getMessage()); 
        }      
        return tcrCallList;
    }
    
    @AuraEnabled
    public static List<Training_Contact_Report_Call__c>  deleteTcrCallAccount(Training_Contact_Report_Call__c tcrRec, String tcrCalls){                        
        System.debug('deleteTcrCallAccount');
        List<Training_Contact_Report_Call__c> tcrCallList = new List<Training_Contact_Report_Call__c>();
        
        try{
            if(tcrCalls != null && tcrCalls != '[\"{}\"]' && tcrRec != null){
                tcrCallList = (List<Training_Contact_Report_Call__c>)JSON.deserialize(tcrCalls, List<Training_Contact_Report_Call__c>.class);    
                
                Integer j = 0;
                while (j < tcrCallList.size())
                {
                    Training_Contact_Report_Call__c call = tcrCallList.get(j);
                    if(call.Call_No__c == tcrRec.Call_No__c)
                    {
                        tcrCallList.remove(j);
                        if(tcrRec.Id != null){
                            delete tcrRec;
                        }
                        
                    }else
                    {
                        j++;
                    }
                }
                
                if(tcrCallList.isEmpty()){
                    Training_Contact_Report_Call__c call = new Training_Contact_Report_Call__c();
                    call.Call_No__c = 1;
                    tcrCallList.add(call);
                }else{
                    Integer i =0;
                    for(Training_Contact_Report_Call__c tcrCall: tcrCallList){
                        i= i+1;
                        tcrCall.Call_No__c =i;
                    }
                }
            }
        }catch(Exception e){
            throw new AuraHandledException(
                ERROR_DELETING_CALL + e.getMessage()); 
        }
        
        return tcrCallList;
    }
    
    @AuraEnabled
    public static List<String> getSpecificSkillDevelopment(String skillCompetency){    
        System.debug('start');
        Map<String, TCR_Skill_Dependency__c> allSkillDependencyList = TCR_Skill_Dependency__c.getAll();
        System.debug(allSkillDependencyList);
        List<String> specificSkillDevList = new List<String>();
        
        for(TCR_Skill_Dependency__c skillDependency : allSkillDependencyList.values()){
            if(skillDependency.Skill_Competency__c.equalsIgnoreCase(skillCompetency)){
                specificSkillDevList.add(skillDependency.Specific_Skill_Development__c);    
            }             
        }
        return specificSkillDevList;
    }
    
    public class CustomFieldInfo{
        public String label {get; set;}
        public String helpText {get; set;} 
        public List<String> picklistValues {get; set;} 
        public Boolean isRequired {get; set;} 
        
        public CustomFieldInfo(String prLabel, String prHelpText, List<String> prPicklistValues, Boolean prIsRequired){
            label = prLabel;
            helpText = prHelpText;
            picklistValues = prPicklistValues;
            isRequired = prIsRequired;
        }
    }    
}