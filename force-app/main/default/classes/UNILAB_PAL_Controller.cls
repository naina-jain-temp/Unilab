/*----------------------------------------------------------------------------------------------------
Author       :   Joan Bautista, Kristjan Mariano, Mark Palacios and Zeus Lopez-Dee
Created Date :   01.21.2019
Definition   :   Apex Controller Class for UNILAB_PAL Lightning Component 
-----------------------------------------------------------------------------------------------------*/
public with sharing class  UNILAB_PAL_Controller {
    
    public class accountListWrapper {
        
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public Account objAccount{get;set;}
        
        public accountListWrapper(boolean isChecked, Account objAccount){
            if (isChecked != NULL && objAccount != NULL) {
                this.isChecked = isChecked;
                this.objAccount = objAccount;
            }
        }
        
    }
    
    @AuraEnabled 
    public static List<accountListWrapper> fetchAccountWrapper(String channel, Id allocationId){
        
        List<Account_Allocation__c> accAllocations = [SELECT Account__c
                                                      FROM Account_Allocation__c 
                                                      WHERE Allocation__c =: allocationId
                                                      ORDER BY Account__r.Channel__c, Account__r.Team__c, Account__r.Account_Group__c, Account__r.Name
                                                     ];
        
        List<Id> newA = new List<Id>();
        
        for(Account_Allocation__c a : accAllocations) {            
            newA.add(a.Account__c);            
        }
        
        List<Account> accountList = new List<Account>();
        
        accountList = [SELECT Id,
                       Name,
                       Account_Status__c, 
                       Owner.Name,Channel__c
                       FROM Account
                       WHERE (Channel__c =: channel)
                       AND (Id NOT IN :newA)
                       AND (Account_Status__c = 'Active')
                       AND (NOT((Name like 'HO-%') AND (RecordType.Name = 'Main/Warehouse')))
                       
                       ORDER BY Name
                      ];
        
        if (accountList.size() > 0) {
            
            List<accountListWrapper> lstaccountListWrapper = new List<accountListWrapper>();
            
            for(Account acc : accountList) {
                lstaccountListWrapper.add(new accountListWrapper(false,acc));
            } 
            
            return lstaccountListWrapper;
        }
        else {
            return NULL;
        }
        
    }
    
    public class ColumnHeader{
        @AuraEnabled
        public string columnName;
        @AuraEnabled
        public string columnFieldName;
        @AuraEnabled
        public string columnType;
        @AuraEnabled
        public Integer initialWidth;
        
        ColumnHeader(){
            this.columnName = '';
            this.columnFieldName = '';
            this.columnType = '';
            this.initialWidth = 0;
        }
    }
    
    public class ApiParameter{
        
        @AuraEnabled public List<String> accounts;
        @AuraEnabled public List<String> itemCode;
        @AuraEnabled public List<String> measureType;
        @AuraEnabled public String measureLevel;
        @AuraEnabled public String period;
        @AuraEnabled public String endingInventoryOperator;
        @AuraEnabled public String endingInventoryValue;
        @AuraEnabled public String endingInventoryMeasureLevel;
    }
    
    @AuraEnabled
    public static Date dateToday() {
        Date dateToday = Date.today();
        return dateToday;
    }
    
    @AuraEnabled
    public static User getUserInfo() {
        User loggedUser;
        try{
            loggedUser = [select Id,Name,UserRole.Name from User where id =: userInfo.getUserId()];
        }catch(Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('Error in retrieving User record: '
                                           + e.getMessage());    
            
        }
        return loggedUser;
    }
    
    @AuraEnabled
    public static Allocation__c getAllocRecs (Id recordId){
        Allocation__c allocRec;
        try{
            allocRec = [SELECT Id, Status__c, Account_Status__c,Along_National_Highway_Residential__c,Channel__c,Ending_Inventory_Data_Type__c,
                        End_Date__c,Frequency_of_Visit__c,Fronting_Near_Hospital__c,Allocation_Volume__c,
                        Mall_Based__c,Name,Near_a_Call_Center__c,Near_a_Generics_Drugstore__c,
                        Near_a_Grade_High_School__c,Near_a_Pre_School__c,Near_a_University_College__c,Near_Clinic__c,
                        Near_Offices__c,Near_or_Within_a_Supermarket__c,Near_Other_Drugstores__c,Near_Public_Market__c,
                        Near_Transport_Terminal__c,Promo__r.Name,RPS_Account_Class__c,Self_Service_Floor_Area__c,Sell_in_Data_Type__c,
                        Sell_out_Data_Type__c,Start_Date__c,Store_Format__c,Store_Physical_Size__c,With_Lamp_Coverage__c,With_TPA_Coverage__c,
                        Sell_in__c,Sell_out__c, Ending_Inventory__c,Ending_Inventory_Operator__c,Ending_Inventory_Value__c, Promo__r.Promo_Name__c,Promo__r.Status__c,
                        Over_Allocated__c,Total_Account_Allocation__c, Data_Retrieved__c, Ending_Inventory_Measure_Level__c
                        FROM Allocation__c
                        WHERE Id=:recordId];
            
        }catch(Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('Error in retrieving Allocation record: '
                                           + e.getMessage());    
            
            
        }											  
        return allocRec;
    }
    
    @AuraEnabled
    public static List<PAL_Configuration__c> getConfigRecs (){
        List<PAL_Configuration__c> configRec;
        try{
            configRec = [SELECT Id, CONF_Account_Status__c,CONF_Along_National_Highway_Residential__c,CONF_Frequency_of_Visit__c,CONF_Channel__c,
                         CONF_Fronting_Near_Hospital__c,CONF_Mall_Based__c,Name,CONF_Near_a_Call_Center__c,CONF_Near_a_Generics_Drugstore__c,
                         CONF_Near_a_Grade_High_School__c,CONF_Near_a_Pre_School__c,CONF_Near_a_University_College__c,CONF_Near_Clinic__c,
                         CONF_Near_Offices__c,CONF_Near_or_Within_a_Supermarket__c,CONF_Near_Other_Drugstores__c,CONF_Near_Public_Market__c,
                         CONF_Near_Transport_Terminal__c,CONF_RPS_Account_Class__c,CONF_Self_Service_Floor_Area__c,
                         CONF_Store_Format__c,CONF_Store_Physical_Size__c,CONF_With_Lamp_Coverage__c,CONF_With_TPA_Coverage__c,
                         Ending_Inventory_Data_Type__c,Ending_Inventory_Operator__c,Ending_Inventory_Value__c
                         FROM PAL_Configuration__c];
            
        }catch(Exception e){
            System.debug(e.getMessage());           
            throw new AuraHandledException('Error in retrieving PAL Configuration record: '
                                           + e.getMessage());    
            
        }
        return configRec;
    }
    
    @AuraEnabled
    public static ApiParameter updateAllocRecAndGetPALApiParameter (Allocation__c retallocRec){
        Allocation__c allocRec = retallocRec;
        ApiParameter apiParamRec;
        String query;
        try{
            if(allocRec.Status__c == 'Draft'){
                allocRec.Status__c = 'Retrieving Data';
                
                if(!allocRec.Sell_in__c){
                    allocRec.Sell_in_Data_Type__c = '';
                }if(!allocRec.Sell_out__c){
                    allocRec.Sell_out_Data_Type__c = '';
                }if(!allocRec.Ending_Inventory__c){
                    allocRec.Ending_Inventory_Data_Type__c = '';
                    allocRec.Ending_Inventory_Operator__c = '';
                    allocRec.Ending_Inventory_Value__c = null;
                    allocRec.Ending_Inventory_Measure_Level__c = '';
                }
                update allocRec;
                query = getAccountFilteringQueryTemplate(allocRec);
                apiParamRec = getApiParamRec(allocRec,query);
            }
        }catch(Exception e){
            throw new AuraHandledException('Error in updating Allocation Record: '
                                           + e.getMessage());    
        }
        return apiParamRec;
        
    }
    
    @AuraEnabled
    public static String getAccessToken (){
        
        String accessToken;
        
        try{
            accessToken = UNILAB_PAL_Authentication.getToken();
            
        }catch(Exception e){
            throw new AuraHandledException('Error in updating Getting Token: '
                                           + e.getMessage());    
        }
        
        return accessToken;
        
    }
    
    @AuraEnabled
    public static List<Temporary_Allocation__c> invokeCallout(String accessToken, String jsonString, String allocId){
        List<Temporary_Allocation__c> resp = new List<Temporary_Allocation__c>();
        resp = UNILAB_PAL_DataWarehouse_Callouts.getAPIResponse(accessToken, jsonString, allocId);
        return resp; 
    }
    
    @AuraEnabled
    public static void invokeBatchApex(String allocId, List<Temporary_Allocation__c> tempAlloc, String channel){
        try{
            User loggedUser = getUserInfo();
            List<AsyncApexJob> listOfApexJobs = [SELECT Id,CreatedById, Status FROM AsyncApexJob WHERE Status = 'Processing' AND CreatedById =: loggedUser.Id];
            if(listOfApexJobs.size() > 0){
                Allocation__c allocRec = [SELECT Id, Status__c FROM Allocation__c WHERE Id =: allocId];
                allocRec.Status__c = 'Draft';
                update allocRec;
                Boolean serverDown = false;
                Boolean nullCalloutValue = false;
                Boolean hasOngoingApexJobs = true;
                UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(allocRec,serverDown,nullCalloutValue,hasOngoingApexJobs);
            }else{
                UNILAB_PAL_BatchInsertTempAlloc be = new UNILAB_PAL_BatchInsertTempAlloc(tempAlloc, allocId, channel);
                database.executeBatch(be);
            }
        }catch(Exception e){
            throw new AuraHandledException('Error in invoking batch apex: '
                                           + e.getMessage());    
        }
    }
    
    @AuraEnabled
    public static Allocation__c saveDraftAllocRec (Allocation__c retallocRec) {
        Allocation__c allocRec = retallocRec;
        try{
            if(allocRec.Status__c == 'Draft'){
                update allocRec;
            }
        }catch(Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('Error in updating Allocation Record: '
                                           + e.getMessage());    
        }
        return allocRec;
    }
    
    @AuraEnabled
    public static void updateAllocRecToDraft (Id recordId, Boolean serverDown, Boolean nullCalloutValue) {
        Allocation__c allocRec;
        try{
            allocRec = [SELECT Id,Name, Status__c FROM Allocation__c WHERE Id =: recordId];
            allocRec.Status__c = 'Draft';
            update allocRec;
            sendCalloutErrorEmail(allocRec,serverDown,nullCalloutValue);
            
        }catch(Exception e){
            System.debug(e.getMessage());   
        }
    }
    
    @AuraEnabled
    public static void sendCalloutErrorEmail(Allocation__c allocRecord, Boolean serverDown, Boolean nullCalloutValue){
        Boolean hasOngoingApexJobs = false;
        try{
            UNILAB_PAL_BatchInsertAccAlloc.sendUpdateEmail(allocRecord,serverDown,nullCalloutValue,hasOngoingApexJobs);
        }catch(Exception e){
            System.debug(e.getMessage());   
        }
    }
    
    @AuraEnabled
    public static Allocation__c updateAllocRecStatus (Id recordId) {
        Allocation__c allocRec; 
        try{
            allocRec = [SELECT Id, Status__c FROM Allocation__c WHERE Id =: recordId];
            allocRec.Status__c = 'Finalized';
            update allocRec;
            
        }catch(Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('Error in updating Allocation Record: '
                                           + e.getMessage());    
        }
        
        return allocRec;
    }
    
    public static String getAccountFilteringQueryTemplate (Allocation__c retallocRec) {
        
        Allocation__c allocRec = retallocRec;
        String queryTemplate;
        String hoAccount,channel,frequencyOfVisit,acctstatus,alongHighwayorResidential,storeSize,storeFormt,slfServiceFlrArea,rpsAcctClass,nearGenericsDrugStore,nearOrWithinSupermarket,mallBased,nearTransportTerminal,nearPreSchool,nearUniversityOrCollege,nearOtherDrugStores,frontingOrNearHospital,nearClinic,nearPublicMarket,nearOffices,nearAGradeorHSchool,nearCallCenter,withTPACoverage,withLampCoverage;
        List<String> listOfFilters = new List<String>();
        
        
        if(allocRec.Channel__c != null){
            channel = 'Channel__c = \''+allocRec.Channel__c+'\'';
            listOfFilters.add(channel);
        }if(allocRec.Frequency_of_Visit__c != null){
            frequencyOfVisit = 'Frequency_of_Visit__c = \''+allocRec.Frequency_of_Visit__c +'\'';
            listOfFilters.add(frequencyOfVisit);
        }if(allocRec.Account_Status__c != null){
            acctstatus = 'Account_Status__c = \''+allocRec.Account_Status__c+'\'';
            listOfFilters.add(acctstatus);
        }if(allocRec.Along_National_Highway_Residential__c != null){
            alongHighwayorResidential = 'Along_National_Highway_Residential__c = \''+allocRec.Along_National_Highway_Residential__c+'\'';
            listOfFilters.add(alongHighwayorResidential);
        }if(allocRec.Store_Physical_Size__c != null){
            storeSize = 'Store_Physical_Size__c = \''+allocRec.Store_Physical_Size__c+'\'';
            listOfFilters.add(storeSize);
        }if(allocRec.Store_Format__c != null){
            storeFormt = 'Store_Format__c = \''+allocRec.Store_Format__c+'\'';
            listOfFilters.add(storeFormt);
        }if(allocRec.Self_Service_Floor_Area__c != null){
            slfServiceFlrArea = 'Self_Service_Floor_Area__c = '+allocRec.Self_Service_Floor_Area__c;
            listOfFilters.add(slfServiceFlrArea);
        }if(allocRec.RPS_Account_Class__c != null){
            rpsAcctClass = 'RPS_Account_Class__c = \''+allocRec.RPS_Account_Class__c+'\'';
            listOfFilters.add(rpsAcctClass);
        }if(allocRec.Near_a_Generics_Drugstore__c){
            nearGenericsDrugStore = 'Near_a_Generics_Drugstore__c = \'Y\'';
            listOfFilters.add(nearGenericsDrugStore);
        }if(allocRec.Near_or_Within_a_Supermarket__c){
            nearOrWithinSupermarket = 'Near_or_Within_a_Supermarket__c = \'Y\'';
            listOfFilters.add(nearOrWithinSupermarket);
        }if(allocRec.Mall_Based__c){
            mallBased = 'Mall_Based__c = \'Y\'';
            listOfFilters.add(mallBased);
        }if(allocRec.Near_Transport_Terminal__c){
            nearTransportTerminal = 'Near_Transport_Terminal__c = \'Y\'';
            listOfFilters.add(nearTransportTerminal);
        }if(allocRec.Near_a_Pre_School__c){
            nearPreSchool = 'Near_a_Pre_School__c = \'Y\'';
            listOfFilters.add(nearPreSchool);
        }if(allocRec.Near_a_University_College__c){
            nearUniversityOrCollege = 'Near_a_University_College__c = \'Y\'';
            listOfFilters.add(nearUniversityOrCollege);
        }if(allocRec.Near_Other_Drugstores__c){
            nearOtherDrugStores = 'Near_Other_Drugstores__c = \'Y\'';
            listOfFilters.add(nearOtherDrugStores);
        }if(allocRec.Fronting_Near_Hospital__c){
            frontingOrNearHospital = 'Fronting_Near_Hospital__c = \'Y\'';
            listOfFilters.add(frontingOrNearHospital);
        }if(allocRec.Near_Clinic__c){
            nearClinic = 'Near_Clinic__c = \'Y\'';
            listOfFilters.add(nearClinic);
        }if(allocRec.Near_Public_Market__c){
            nearPublicMarket = 'Near_Public_Market__c = \'Y\'';
            listOfFilters.add(nearPublicMarket);
        }if(allocRec.Near_Offices__c){
            nearOffices = 'Near_Offices__c = \'Y\'';
            listOfFilters.add(nearOffices);
        }if(allocRec.Near_a_Grade_High_School__c){
            nearAGradeorHSchool = 'Near_A_School__c = \'Y\'';
            listOfFilters.add(nearAGradeorHSchool);
        }if(allocRec.Near_a_Call_Center__c){
            nearCallCenter = 'Near_a_Call_Center__c = \'Y\'';
            listOfFilters.add(nearCallCenter);
        }if(allocRec.With_TPA_Coverage__c){
            withTPACoverage = 'With_TPA_Coverage__c = \'Y\'';
            listOfFilters.add(withTPACoverage);
        }if(allocRec.With_Lamp_Coverage__c){
            withLampCoverage = 'LAMP_Covered__c = \'Y\'';
            listOfFilters.add(withLampCoverage);
        }
        hoAccount = '(NOT((Name like \'HO-%\') AND (RecordType.Name = \'Main/Warehouse\')))';
        listOfFilters.add(hoAccount); 
        queryTemplate = String.join(listOfFilters, ' AND ');																	 
        return queryTemplate;
    }
    
    public static ApiParameter getApiParamRec (Allocation__c allocRec, String filteredQueryTemplate){
        
        ApiParameter apiParamData = new ApiParameter();
        try{
            List<Account> filteredAccount = Database.query('SELECT Id FROM Account WHERE ' + filteredQueryTemplate); //Used to query filtered accounts
            List<String> accts= new List<String>();
            for(Account acct : filteredAccount){
                accts.add(String.valueOf(acct.Id));
            }
            List<Promo_Product__c> promoProds = [SELECT Id, Product__r.Item_Code__c FROM Promo_Product__c WHERE Promo__c  =: allocRec.Promo__c]; //Used to query Item Codes
            List<String> listOfItemCode = new List<String>();
            
            for(Promo_Product__c a : promoProds){
                listOfItemCode.add(a.Product__r.Item_Code__c);
            }
            
            List<String> listOfMeasureType = new List<String>(); //Used to store measure types
            String measureLevelData;
            String eIValue = '';
            String eIOperator = '';
            String eIMeasureLevel = '';
            if(allocRec.Sell_in__c){
                listOfMeasureType.add('SELLIN');
                measureLevelData = allocRec.Sell_in_Data_Type__c;
            }else if(allocRec.Sell_out__c){
                listOfMeasureType.add('SELLOUT');
                measureLevelData = allocRec.Sell_out_Data_Type__c;
            }
            if(allocRec.Ending_Inventory__c){
                listOfMeasureType.add('MONTH SUPPLY');
                eIValue = String.valueOf(allocRec.Ending_Inventory_Value__c);
                if(allocRec.Ending_Inventory_Operator__c == 'greater than'){
                    eIOperator = '>';
                }else if(allocRec.Ending_Inventory_Operator__c == 'less than'){
                    eIOperator = '<';
                }else if(allocRec.Ending_Inventory_Operator__c == 'equals'){
                    eIOperator = '=';
                }
                measureLevelData = allocRec.Ending_Inventory_Measure_Level__c;
            } 
            
            String periodMonth;
            String periodYear;
            String periodDate;
            
            if(allocRec.Start_Date__c != null){
                periodMonth= String.valueOf(allocRec.Start_Date__c.month());
                if(periodMonth.length() == 1){
                    periodMonth = '0'+periodMonth;
                }
                periodYear= String.valueOf(allocRec.Start_Date__c.year());
                periodDate = periodYear+periodMonth; //Used to store period date or Allocation Start Date
            } else {
                periodDate = '';
            }
            
            apiParamData.accounts = accts;
            apiParamData.itemCode = listOfItemCode;
            apiParamData.measureType = listOfMeasureType;
            apiParamData.measureLevel = measureLevelData;
            apiParamData.period = periodDate;
            apiParamData.endingInventoryOperator = eIOperator;
            apiParamData.endingInventoryValue = eIValue;
            apiParamData.endingInventoryMeasureLevel = eIMeasureLevel;
            
        }catch(Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('Error in updating ApiParameter Data: '
                                           + e.getMessage());    
            
        }
        return apiParamData;
    }
    
    public static Map<Object,List<String>> getDependentPicklistValues( Schema.sObjectField dependToken ){
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if ( controlToken == null ) return null;
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries =
            (   control.getType() == Schema.DisplayType.Boolean
             ?   null
             :   control.getPicklistValues()
            );
        
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
        for ( Schema.PicklistEntry entry : depend.getPicklistValues() ) if ( entry.isActive() )
        {
            List<String> base64chars =
                String.valueOf
                (   ((Map<String,Object>) JSON.deserializeUntyped( JSON.serialize( entry ) )).get( 'validFor' )
                ).split( '' );
            for ( Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++ )
            {
                Object controlValue =
                    (   controlEntries == null
                     ?   (Object) (index == 1)
                     :   (Object) (controlEntries[ index ].isActive() ? controlEntries[ index ].getLabel() : null)
                    );
                Integer bitIndex = index / 6, bitShift = 5 - Math.mod( index, 6 );
                if  (   controlValue == null
                     ||  (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0
                    ) continue;
                if ( !dependentPicklistValues.containsKey( controlValue ) )
                {
                    dependentPicklistValues.put( controlValue, new List<String>() );
                }
                dependentPicklistValues.get( controlValue ).add( entry.getLabel() );
            }
        }
        return dependentPicklistValues;
    }
    
    @AuraEnabled
    public static Map<Object,List<String>> getDependentVal (String sObjectName, String fieldName) {
        
        return getDependentPicklistValues(Schema.getGlobalDescribe().get( sObjectName ).getDescribe().fields.getMap().get( fieldName ));
    }
    
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired){
        
        List<String> optionlist = new List<String>();
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        
        if(nullRequired == true){
            optionlist.add('--None--');
        }
        
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        return optionlist;
        
    }
    
    @AuraEnabled
    public static List <ColumnHeader> getColumns(Id recordId){
        Id profileId=userinfo.getProfileId();
        List<PAL_Generate_Columns__c> columnValuesList = new List<PAL_Generate_Columns__c>();
        
        Allocation__c allocRecord = [SELECT Id,Sell_in_Data_Type__c,Sell_out_Data_Type__c FROM Allocation__c WHERE Id =: recordId];
        
        List<PAL_Generate_Columns__c> columnValueList = [SELECT ACCOUNT_NAME__c,AVE_GROSS__c,AVE_QTY__c,
                                                         YTDSALES_LY__c, YTDSALES_TY__c,GROWTH__c,
                                                         MANUAL__c,FINAL__c, STATUS__c, COMPUTED_ALLOCATION__c, 
                                                         NumberOfAccounts__c, AllocPerBranch__c
                                                         FROM PAL_Generate_Columns__c WHERE SetupOwnerId =:profileId];
        columnValuesList = columnValueList; 
        
        
        List<PAL_Column_Header__c> columnHeaderList = [SELECT Column_Field_Name__c,Column_Name__c,Column_Type__c FROM PAL_Column_Header__c ORDER By Name ASC];
        
        String columnPrefix = '';
        if(String.isEmpty(allocRecord.Sell_in_Data_Type__c)){
            columnPrefix = allocRecord.Sell_out_Data_Type__c;
        }else{
            columnPrefix = allocRecord.Sell_in_Data_Type__c;
        }
        
        List<ColumnHeader> colHeaders = new List<ColumnHeader>();
        for(PAL_Column_Header__c columnHeader: columnHeaderList){
            ColumnHeader colHeader = new ColumnHeader();
            
            if(columnValuesList.get(0).ACCOUNT_NAME__c == true && columnHeader.Column_Field_Name__c.equals('ACCOUNT_NAME__c')){
                
                colHeader.columnName = 'ACCOUNT NAME';
                colHeader.columnFieldName = 'name';
                colHeader.columnType = 'text';
                colHeader.initialWidth = 230;
                colHeaders.add(colHeader);
                
            }
            else if(columnValuesList.get(0).AVE_GROSS__c == true && columnHeader.Column_Field_Name__c.equals('AVE_GROSS__c')){
                
                colHeader.columnName = columnPrefix +' AVE GROSS';
                colHeader.columnFieldName = 'Ave_Gross_Sales';
                colHeader.columnType = 'currency';
                colHeader.initialWidth = null;
                colHeaders.add(colHeader);
            }
            else if(columnValuesList.get(0).AVE_QTY__c == true && columnHeader.Column_Field_Name__c.equals('AVE_QTY__c')){
                
                colHeader.columnName = columnPrefix +' AVE QTY';
                colHeader.columnFieldName = 'Ave_Qty';
                colHeader.columnType = 'number';
                colHeader.initialWidth = null;
                colHeaders.add(colHeader);
            }
            else if(columnValuesList.get(0).YTDSALES_LY__c == true && columnHeader.Column_Field_Name__c.equals('YTDSALES_LY__c')){
                
                colHeader.columnName = 'YTD SALES LY';
                colHeader.columnFieldName = 'YTDSales_LY';
                colHeader.columnType = 'number';
                colHeader.initialWidth = null;
                colHeaders.add(colHeader);
            }else if(columnValuesList.get(0).YTDSALES_TY__c == true && columnHeader.Column_Field_Name__c.equals('YTDSALES_TY__c')){
                
                colHeader.columnName = 'YTD SALES TY';
                colHeader.columnFieldName = 'YTDSales_TY';
                colHeader.columnType = 'number';
                colHeader.initialWidth = null;
                colHeaders.add(colHeader);
            }else if(columnValuesList.get(0).GROWTH__c == true && columnHeader.Column_Field_Name__c.equals('GROWTH__c')){
                
                colHeader.columnName = 'GROWTH';
                colHeader.columnFieldName = 'Growth';
                colHeader.columnType = 'percent';
                colHeader.initialWidth = null;
                colHeaders.add(colHeader);
            }else if(columnValuesList.get(0).MANUAL__c == true && columnHeader.Column_Field_Name__c.equals('MANUAL__c')){
                
                colHeader.columnName = 'MANUAL';
                colHeader.columnFieldName = 'Manual';
                colHeader.columnType = 'number';
                colHeader.initialWidth = 95;
                colHeaders.add(colHeader);
            }else if(columnValuesList.get(0).FINAL__c == true && columnHeader.Column_Field_Name__c.equals('FINAL__c')){
                colHeader.columnName = 'FINAL';
                colHeader.columnFieldName = 'Final_Allocation';
                colHeader.columnType = 'number';
                colHeader.initialWidth = null;
                colHeaders.add(colHeader);
            }else if(columnValuesList.get(0).STATUS__c == true && columnHeader.Column_Field_Name__c.equals('STATUS__c')){
                colHeader.columnName = 'STATUS';
                colHeader.columnFieldName = 'Status';
                colHeader.columnType = 'string';
                colHeader.initialWidth = null;
                colHeaders.add(colHeader);
            }else if(columnValuesList.get(0).COMPUTED_ALLOCATION__c == true && columnHeader.Column_Field_Name__c.equals('COMPUTED_ALLOCATION')){
                colHeader.columnName = 'COMPUTED ALLOCATION';
                colHeader.columnFieldName = 'Computed_Allocation';
                colHeader.columnType = 'number';
                colHeader.initialWidth = null;
                colHeaders.add(colHeader);
            }else if(columnValuesList.get(0).NumberOfAccounts__c == true && columnHeader.Column_Field_Name__c.equals('NumberOfAccounts')){
                colHeader.columnName = '# OF ACCOUNTS';
                colHeader.columnFieldName = 'NumberOfAccounts';
                colHeader.columnType = 'number';
                colHeader.initialWidth = null;
                colHeaders.add(colHeader);
            }else if(columnValuesList.get(0).AllocPerBranch__c == true && columnHeader.Column_Field_Name__c.equals('AllocPerBranch')){
                colHeader.columnName = 'AVG BRANCH ALLOCATION';
                colHeader.columnFieldName = 'AllocPerBranch';
                colHeader.columnType = 'number';
                colHeader.initialWidth = null;
                colHeaders.add(colHeader);
            }
        }
        return colHeaders;
    }
    
    @AuraEnabled
    public static List<Account_Allocation__c> getAccAllocations2 (Allocation__c alloc){        
        List<Account_Allocation__c> accAllocList;
        try{
            accAllocList = [SELECT Id, Account__r.Name,Account_Allocation__c.Name, Account__r.Channel__c, Account__r.Account_Group__c, Account__r.Team__c,
                            Ave_Gross_Sales__c, Ave_Qty__c, Growth__c, Status__c, YTDSales_LY__c, 
                            YTDSales_TY__c,Manual__c, Allocation__r.Allocation_Volume__c, Computed_Allocation__c,Business_Share__c , Allocation__r.Channel__c                                                   
                            FROM Account_Allocation__c 
                            WHERE Allocation__c =: alloc.Id 
                            ORDER BY Account__r.Channel__c, Account__r.Team__c, Account__r.Account_Group__c, Account__r.Name];
        }catch(Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('Error Retrieving Account Allocation : '
                                           + e.getMessage());    
            
        }
        
        return accAllocList;
    }    
    
    public static List<Account_Allocation__c> getComputedAllocations (Id allocId, Boolean isNew){        
        List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
        
        if(isNew){
            accAllocList = [SELECT Id, Allocation__r.Allocation_Volume__c,Account__r.Name,Account_Allocation__c.Name, Account__r.Channel__c, Account__r.Account_Group__c,
                            Account__r.Team__c,
                            Ave_Gross_Sales__c, Ave_Qty__c, Growth__c, Status__c, YTDSales_LY__c, 
                            YTDSales_TY__c,Manual__c                                                    
                            FROM Account_Allocation__c 
                            WHERE Allocation__c =: allocId 
                            ORDER BY Account__r.Channel__c, Account__r.Team__c, Account__r.Account_Group__c, Account__r.Name];
        }else{
            accAllocList = [SELECT Id, Allocation__r.Allocation_Volume__c,Account__r.Name,Account_Allocation__c.Name, 
                            Account__r.Channel__c, Account__r.Account_Group__c,
                            Account__r.Team__c,
                            Ave_Gross_Sales__c, Ave_Qty__c, Growth__c, Status__c, YTDSales_LY__c, 
                            YTDSales_TY__c,Manual__c, Created_From_API__c,
                            Final_Allocation__c, Computed_Allocation__c
                            FROM Account_Allocation__c 
                            WHERE Allocation__c =: allocId AND Final_Allocation__c > 0 AND Created_From_API__c = TRUE
                            ORDER BY Account__r.Channel__c, Account__r.Team__c, Account__r.Account_Group__c, Account__r.Name];
        }
        return accAllocList;
    }  
    
    public static Map<Id, Account_Allocation__c> getAverageQtyAndGross(String channel){
        Map<Id, Account_Allocation__c> averageMap = new Map<Id, Account_Allocation__c>();
        List<AggregateResult> averageList = new List<AggregateResult>();
        
        averageList = [SELECT AVG(Amount__c)Ave_Amount,AVG(Quantity__c)Ave_Qty,SFA_Internal_ID__c,Measure_Level__c,Channel__c
                       FROM Temporary_Allocation__c 
                       WHERE Channel__c =: channel AND Measure_Level__c  NOT IN ('LYTD','YTD')                                                     
                       GROUP BY SFA_Internal_ID__c,Measure_Level__c,Channel__c ];
        
        
        for(AggregateResult tempAllocAvg: averageList){
            Id accId =  (Id) tempAllocAvg.get('SFA_Internal_ID__c');
            
            Account_Allocation__c accAllocation = new Account_Allocation__c(); 
            accAllocation.Ave_Qty__c = (Decimal) tempAllocAvg.get('Ave_Qty');
            accAllocation.Ave_Gross_Sales__c = (Decimal) tempAllocAvg.get('Ave_Amount');
            
            averageMap.put(accId, accAllocation);
        }   
        
        return averageMap;
    }
    
    public static List<Account_Allocation__c> processAccountAllocations (Allocation__c alloc){
        
        Map<Id, Account_Allocation__c> accountAllocMap = new Map<Id, Account_Allocation__c>();
        List<Account_Allocation__c> computedAllocationList = new List<Account_Allocation__c>();
        Decimal lyDiv = 1;
        List<Account_Allocation__c> accAllocFinalList = new List<Account_Allocation__c>();  
        try{
            
            //Get Average Gross and Quantity
            accountAllocMap = getAverageQtyAndGross(alloc.Channel__c);
            
            List<AggregateResult> tempAllocList = [SELECT SUM(Amount__c)Sum_Amount,AVG(Quantity__c)Ave_Qty,AVG(Amount__c)Ave_Amount,SFA_Internal_ID__c,Measure_Level__c,Channel__c
                                                   FROM Temporary_Allocation__c 
                                                   WHERE Channel__c =: alloc.Channel__c                                                  	   
                                                   GROUP BY SFA_Internal_ID__c,Measure_Level__c,Channel__c 
                                                  ];
            
            //Compute YTDTY and YTDLY   
            for(AggregateResult tempAlloc: tempAllocList){ 
                Id accountId = (Id) tempAlloc.get('SFA_Internal_ID__c');
                Account_Allocation__c accAlloc; 
                if(accountAllocMap.containsKey(accountId)){
                    accAlloc = accountAllocMap.get(accountId);
                }else{
                    accAlloc = new Account_Allocation__c();
                    accountAllocMap.put(accountId, accAlloc);
                }   
                String measureLevel = (String) tempAlloc.get('Measure_Level__c');
                
                if(measureLevel.equalsIgnoreCase('LYTD')){
                    accAlloc.YTDSales_LY__c = (Decimal) tempAlloc.get('Sum_Amount');
                }else if(measureLevel.equalsIgnoreCase('YTD')){
                    accAlloc.YTDSales_TY__c = (Decimal) tempAlloc.get('Sum_Amount');	
                }
                accAlloc.Account__c = accountId;
                accAlloc.Allocation__c = alloc.Id;
                accAlloc.Created_From_API__c = true;
            }   
            //Compute Growth                        
            for(AggregateResult tempAlloc: tempAllocList){
                Id accountId = (Id) tempAlloc.get('SFA_Internal_ID__c');
                Account_Allocation__c accAlloc; 
                if(accountAllocMap.containsKey(accountId)){
                    accAlloc = accountAllocMap.get(accountId);                    
                }else{
                    accAlloc = new Account_Allocation__c();
                    accountAllocMap.put(accountId, accAlloc);
                }                
                
                String measureLevel = (String) tempAlloc.get('Measure_Level__c');
                
                if(measureLevel.equalsIgnoreCase('P3') || measureLevel.equalsIgnoreCase('P6') || measureLevel.equalsIgnoreCase('P12')){
                    
                    if(accAlloc.YTDSales_LY__c == null || accAlloc.YTDSales_LY__c == 0){
                        lyDiv = 1;
                        accAlloc.YTDSales_LY__c = 0;
                    }else{
                        lyDiv = accAlloc.YTDSales_LY__c;
                    }
                    if(accAlloc.YTDSales_TY__c == null){
                        accAlloc.YTDSales_TY__c = 0;
                    }
                    accAlloc.Growth__c = ((accAlloc.YTDSales_TY__c - accAlloc.YTDSales_LY__c)/lyDiv).setScale(2, RoundingMode.HALF_UP);
                }
            }
            
            List<Account_Allocation__c>  accountAllocList = new List<Account_Allocation__c>();
            
            for(Account_Allocation__c accAllocRec : accountAllocMap.values()){
                
                if(accAllocRec.Ave_Qty__c != null || accAllocRec.Ave_Qty__c > 0){
                    accountAllocList.add(accAllocRec);
                }
                
            }
            if(!accountAllocList.isEmpty()){
                computedAllocationList = computeAllFinalAllocation(alloc, accountAllocList, true);
                
                // Remove final allocation that is not in minimum                      
                //accAllocFinalList = removeAccAllocNotInMinimum(alloc, computedAllocationList);
                
                //Recompute Final Allocation                         
                accAllocFinalList = computeAllFinalAllocation(alloc, accAllocFinalList, true);
                
                //insert accAllocFinalList;
            }   
            
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        return accAllocFinalList;
    }
    
    public static List<Account_Allocation__c> computeAllFinalAllocation(Allocation__c alloc, List<Account_Allocation__c> accAllocLists, Boolean isNew ){
        
        List<Account_Allocation__c> updatedAccountAllocList = new  List<Account_Allocation__c>();
        
        Decimal totalQuantity = 0;
        Integer countQuantity = 0;
        
        for(Account_Allocation__c accAlloc : accAllocLists){
            if(isNew || (!isNew && accAlloc.Created_From_API__c && accAlloc.Final_Allocation__c > 0)){
                totalQuantity = totalQuantity + accAlloc.Ave_Qty__c;
                countQuantity = countQuantity + 1;
            }          
        }
        
        for(Account_Allocation__c accAllocRec : accAllocLists){
            
            if(isNew || (!isNew && accAllocRec.Created_From_API__c) ){
                accAllocRec.Business_Share__c = accAllocRec.Ave_Qty__c /  totalQuantity ;
                
                if(accAllocRec.Ave_Qty__c * 100 < 0){
                    accAllocRec.Computed_Allocation__c =  ((accAllocRec.Business_Share__c * alloc.Allocation_Volume__c)/ 100 ).setScale(1, RoundingMode.DOWN)*100;                      
                }else{
                    accAllocRec.Computed_Allocation__c =  ((accAllocRec.Business_Share__c * alloc.Allocation_Volume__c)/ 100 ).setScale(1, RoundingMode.UP)*100;                      
                }
                
                if(accAllocRec.Manual__c == null){
                    accAllocRec.Manual__c = 0;
                }
                
                if(accAllocRec.Final_Allocation__c == null){
                    accAllocRec.Final_Allocation__c = 0;
                }
                
                if(accAllocRec.Computed_Allocation__c == null){
                    accAllocRec.Computed_Allocation__c = 0;
                }
                accAllocRec.Final_Allocation__c = accAllocRec.Manual__c;  
            }
            updatedAccountAllocList.add(accAllocRec);
        }
        
        return updatedAccountAllocList;
    }
    
    public static List<AggregateResult> getBusinessShareParams(Id allocId, Boolean isNew){
        List<AggregateResult> resultList = new List<AggregateResult>();
        if(isNew){
            resultList = [SELECT Allocation__c,SUM(Ave_Qty__c)Total_Quantity,Count(Id)Total_Count
                          FROM Account_Allocation__c 
                          WHERE Allocation__c =: allocId GROUP BY Allocation__c] ; 
        }else{
            resultList = [SELECT Allocation__c,SUM(Ave_Qty__c)Total_Quantity,Count(Id)Total_Count
                          FROM Account_Allocation__c 
                          WHERE Allocation__c =: allocId AND Created_From_API__c = TRUE AND Final_Allocation__c != 0 GROUP BY Allocation__c] ; 
        }  
        
        return resultList;
    }
    
    @AuraEnabled
    public static void updateAccountAllocation(List<Account_Allocation__c> accAlloc ){
        Map<Id, Decimal> accAllocManualMap = new Map<Id,Decimal>();
        Map<Id, Decimal> accAllocComputedMap = new Map<Id,Decimal>();
        
        List<Id> idList = new List<Id>();
        for(Account_Allocation__c accAllocRecord: accAlloc){
            idList.add(accAllocRecord.Id);
            accAllocManualMap.put(accAllocRecord.Id, accAllocRecord.Manual__c);
        }
        Account_Allocation__c accAllocation = [SELECT Allocation__c FROM Account_Allocation__c WHERE Id =:idList.get(0)].get(0);
        Allocation__c allocRecord = [SELECT Id, Allocation_Volume__c FROM Allocation__c WHERE Id =: accAllocation.Allocation__c];
        List<Account_Allocation__c> accAllocList = [SELECT Id, Manual__c, Final_Allocation__c, Computed_Allocation__c FROM Account_Allocation__c
                                                    WHERE Id IN:idList];
        
        for(Account_Allocation__c accAllRecord: accAllocList){
            accAllocComputedMap.put(accAllRecord.Id, accAllRecord.Computed_Allocation__c);
        }        
        
        try{
            update accAlloc;
        }catch(Exception ex){
            System.debug('FIRST ERROR' + ex.getMessage());
        }
        
        List<Account_Allocation__c> updatedList = [SELECT Id, Manual__c, Final_Allocation__c, Computed_Allocation__c FROM Account_Allocation__c
                                                   WHERE Id IN:idList];
        
        for(Account_Allocation__c accAllocRecord: updatedList){
            Decimal temp = 0;
            
            if(accAllocRecord.Final_Allocation__c == null){
                accAllocRecord.Final_Allocation__c = 0;
                temp = accAllocRecord.Manual__c;
                accAllocRecord.Final_Allocation__c = temp;
                
            }else{
                temp = accAllocRecord.Manual__c;
                accAllocRecord.Final_Allocation__c = temp;
            }
        }
        
        try{
            update updatedList;
            
            List<Account_Allocation__c> updatedAccAllocList = computeAllFinalAllocation(allocRecord, getComputedAllocations(allocRecord.Id, false), false);
            
            if(!updatedAccAllocList.isEmpty()){
                //update  updatedAccAllocList;
            }
            
        }catch(Exception ex){
            System.debug('ERROR' + ex.getMessage());
        }
        
    } 
    
    @AuraEnabled
    public static void deleteAccountAllocation(List<Account_Allocation__c> accAlloc){
        delete accAlloc;
    }
    
    @AuraEnabled
    public static void cancelPromoAllocationStatus(String recordId){
        List<Allocation__c> relatedAllocRecords = new List<Allocation__c>();
        
        relatedAllocRecords = fetchRelatedAllocationRecords(recordId);
        for(Allocation__c allocRecord : relatedAllocRecords){
            allocRecord.Status__c = 'Cancelled';
        }
        
        update relatedAllocRecords;
        
    }
    
    public static List<Allocation__c> fetchRelatedAllocationRecords(String recordId){
        List<Allocation__c> relatedAllocRecords = new List<Allocation__c>();
        
        relatedAllocRecords = [SELECT Id, Status__c FROM Allocation__c
                               WHERE Promo__c =: recordId];
        
        return relatedAllocRecords;
    }
    
    public class accAllocForConversionWrapper {
        @AuraEnabled public String Promo_Name {get; set;}
        @AuraEnabled public String Account_Name {get; set;}
        @AuraEnabled public String Account_Channel {get; set;}
        @AuraEnabled public String Account_Team {get; set;}
        @AuraEnabled public String Account_Group {get; set;}
        @AuraEnabled public Double Account_Final_Allocation {get; set;}
        @AuraEnabled public String CDS {get; set;}
    }
    
    @AuraEnabled
    public static List<accAllocForConversionWrapper> getAccAllocForConversion(Id allocId){
        
        List<accAllocForConversionWrapper> accAlloc = new List<accAllocForConversionWrapper>();
        
        List<Account_Allocation__c> accAllocationsList = [SELECT Account__r.Channel__c,Account__r.Team__c,Account__r.Account_Group__c,
                                                          Account__r.Name, Final_Allocation__c,Account__r.Owner.Name, Allocation__r.Promo_Name__c
                                                          FROM Account_Allocation__c 
                                                          WHERE Allocation__c =: allocId
                                                          ORDER BY Account__r.Channel__c,Account__r.Team__c,Account__r.Account_Group__c,
                                                          Account__r.Name];
        
        for(Integer i = 0; i<accAllocationsList.size(); i++){
            accAllocForConversionWrapper allocList = new accAllocForConversionWrapper();
            allocList.Account_Name = accAllocationsList[i].Account__r.Name;
            allocList.Account_Channel = accAllocationsList[i].Account__r.Channel__c;
            allocList.Account_Team = accAllocationsList[i].Account__r.Team__c;
            allocList.Account_Group = accAllocationsList[i].Account__r.Account_Group__c;
            allocList.Account_Final_Allocation = accAllocationsList[i].Final_Allocation__c;
            allocList.CDS = accAllocationsList[i].Account__r.Owner.Name;
            allocList.Promo_Name = accAllocationsList[i].Allocation__r.Promo_Name__c;
            
            accAlloc.add(allocList);
        }
        
        return accAlloc;
    }
    
    @AuraEnabled
    public static List<Account_Allocation__c> getAccAllocationRecords(Allocation__c alloc){
        
        List<Account_Allocation__c> accAllocationsList = [SELECT Id, Name, Allocation_Volume__c, Final_Allocation__c,Ave_Gross_Sales__c, Ave_Qty__c, 
                                                          Growth__c, Status__c,YTDSales_LY__c, YTDSales_TY__c
                                                          from Account_Allocation__c
                                                          where Allocation__c In: [SELECT Id
                                                                                   FROM Allocation__c
                                                                                   WHERE Id =: alloc.Id]];           
        
        return accAllocationsList;
    }
    
    //Create new account allocation record
    @AuraEnabled
    public static void createAccountAllocation(List<Account_Allocation__c> accAllocList){
        for(Account_Allocation__c accAlloc : accAllocList){
            accAlloc.Final_Allocation__c = accAlloc.Manual__c;
            accAlloc.Computed_Allocation__c = 0;
        }
        insert accAllocList;
    }
    
    @AuraEnabled
    public static Boolean deleteAccountAllocations(List<Account_Allocation__c> toDeleteList){
        List<Id> idList = new List<Id>();
        for(Account_Allocation__c accAlloc: toDeleteList){
            if(accAlloc.YTDSales_LY__c == 0 && accAlloc.YTDSales_TY__c == 0){
                idList.add(accAlloc.Id);
            }
        }
        
        
        if(idList.size() == 0){
            return false;
        }else{
            List<Account_Allocation__c> accAllocationsToDelete = [SELECT Id 
                                                                  FROM Account_Allocation__c
                                                                  WHERE Id In: idList];
            delete accAllocationsToDelete;
            return true;
            
        }
    }
    
    @AuraEnabled
    public static boolean updateAccAllocations(String editedAccAllocationList){
        
        List<AccountsWrapper> allocationWrapList = (List<AccountsWrapper>)JSON.deserializeStrict(editedAccAllocationList, List<AccountsWrapper>.class);
        List<Account_Allocation__c> updateAllocationList = new List<Account_Allocation__c>();
        for(AccountsWrapper accWrapper : allocationWrapList){
            Account_Allocation__c accAllocationinst = new Account_Allocation__c();
            accAllocationinst.Id = accWrapper.Id;
            accAllocationinst.Manual__c = accWrapper.Manual;
            updateAllocationList.add(accAllocationinst);
        }
        
        try{
            update updateAllocationList ;
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    @AuraEnabled
    public static void updateAccAllocStatusConcurred(String recordId){
        
        List<Account_Allocation__c> accAllocationList = [SELECT Id, Name, Status__c FROM Account_Allocation__c
                                                         WHERE Allocation__c =: recordId AND
                                                         Status__c = 'Not Concurred' AND Account__r.OwnerId =: UserInfo.getUserId()];
        
        if(accAllocationList.size() >0){
            for(Account_Allocation__c accAllocation:accAllocationList){
                accAllocation.Status__c = 'Concurred';
            }        
            try{
                update accAllocationList;
                sendUpdateEmail(accAllocationList);
            }catch(Exception ex){
                System.debug(ex.getMessage());
            }
            
        }										   
    }
    
    public static void sendUpdateEmail(List<Account_Allocation__c> accAllocationList){
        Id userId = UserInfo.getUserId();
        String profileId;
        
        User userRecord = [SELECT FirstName,LastName, Email, Channel__c FROM User 
                           WHERE Id=:userId];
        
        Map<String, Id> mapProfileId = getProfileId();
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        if(userRecord.Channel__c.equals('GT')){ 
            profileId = mapProfileId.get('GT CMD Developer');
            List<User> recipientRecord = new List<User>();
            recipientRecord = [SELECT Email FROM User
                               WHERE ProfileId =: profileId];
            
            mails.add(setEmail(userRecord,recipientRecord,accAllocationList));
            Messaging.sendEmail(mails);
        }else if(userRecord.Channel__c.equals('LKA') || userRecord.Channel__c.equals('NKA')){
            profileId = mapProfileId.get('KA CMD Developer');
            //System.debug('GT CMD DEV: ' + profileId);
            List<User> recipientRecord = new List<User>();
            recipientRecord = [SELECT Email FROM User
                               WHERE ProfileId =: profileId];
            
            mails.add(setEmail(userRecord,recipientRecord,accAllocationList));
            Messaging.sendEmail(mails);
        }else if(userRecord.Channel__c.equals('MDC')){
            profileId = mapProfileId.get('MDC CMD Developer');
            //System.debug('GT CMD DEV: ' + profileId);
            List<User> recipientRecord = new List<User>();
            recipientRecord = [SELECT Email FROM User
                               WHERE ProfileId =: profileId];
            
            mails.add(setEmail(userRecord,recipientRecord,accAllocationList));
            Messaging.sendEmail(mails);
        }else if(userRecord.Channel__c.equals('MT')){
            profileId = mapProfileId.get('MT CMD Developer');
            //System.debug('GT CMD DEV: ' + profileId);
            List<User> recipientRecord = new List<User>();
            recipientRecord = [SELECT Email FROM User
                               WHERE ProfileId =: profileId];
            
            mails.add(setEmail(userRecord,recipientRecord,accAllocationList));
            Messaging.sendEmail(mails);
        }else{
            
        }
        
    }
    
    private static Messaging.SingleEmailMessage setEmail(User userRecord, List<User> recipientRecords,List<Account_Allocation__c> accAllocationList){
        String messageBody = 'Hi Dev! <br/>';
        messageBody += 'The following records has been concurred: <br/><ul>';
        for(Account_Allocation__c accAllocRecord:accAllocationList){
            messageBody += '<li><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+accAllocRecord.Id+'">'+accAllocRecord.Name+'</a></li>';
        }
        messageBody += '</ul><br/>Thanks,<br/>' + userRecord.FirstName + ' ' + userRecord.LastName;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        for(User recipientRec:recipientRecords){
            sendTo.add(recipientRec.Email);
        }
        mail.setToAddresses(sendTo);
        mail.setReplyTo(userRecord.Email);
        mail.setSenderDisplayName(userRecord.FirstName + ' ' + userRecord.LastName); 
        mail.setSubject('Account Allocations Concurred');
        mail.setHtmlBody(messageBody);
        
        
        return mail;
    }
    
    private static Map<String, Id> getProfileId(){
        Map<String, Id> mapProfile = new Map<String, Id>();
        
        for (Profile listOfProfile : [SELECT Id, Name FROM Profile]) {
            mapProfile.put(listOfProfile.Name, listOfProfile.Id);
        }
        
        return mapProfile;
    }
    //Account Pagination
    
    public class AccountDetailsWrpper{
        
        @AuraEnabled public String Name;
        @AuraEnabled public String Id;
        @AuraEnabled public String Status;
        @AuraEnabled public String Owner;
    }
    
    //create a wrapper class with @AuraEnabled Properties    
    public class AccountPagerWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer page {get;set;}
        @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public List<AccountDetailsWrpper> accounts;
    }
    
    @AuraEnabled
    public static AccountPagerWrapper getAllAccounts(Decimal pageNumber ,Integer recordToDisply, String selectedLetter, String channel, Id allocationId){
        
        List<Account_Allocation__c> accAllocations = [SELECT Id, Account__r.Name, Account_Allocation__c.Name, Account__r.Channel__c,
                                                      Account__r.Team__c,Allocation_Volume__c, Account__r.Account_Group__c,
                                                      Ave_Gross_Sales__c, Ave_Qty__c, Growth__c, Status__c, YTDSales_LY__c, YTDSales_TY__c,
                                                      Manual__c,Created_From_API__c,Account__c , Allocation__c
                                                      FROM Account_Allocation__c 
                                                      WHERE Allocation__c =: allocationId
                                                      ORDER BY Account__r.Channel__c, Account__r.Team__c, Account__r.Account_Group__c, Account__r.Name];
        
        List<Id> newA = new List<Id>();
        
        for(Account_Allocation__c a : accAllocations){
            
            newA.add(a.Account__c);
            
        }
        
        Integer pageSize = recordToDisply;
        Integer offset = ((Integer)pageNumber - 1) * pageSize;
        String searchKey = selectedLetter + '%';
        List<Account> accountList = new List<Account>();
        List<AggregateResult> accListCount = new List<AggregateResult>();
        if(selectedLetter == 'All'){
            accountList = [SELECT Id, Name, Account_Status__c, Owner.Name,Channel__c 
                           FROM Account 
                           WHERE Channel__c =: channel AND Id NOT IN :newA
                           ORDER BY Name LIMIT :recordToDisply OFFSET :offset];
            accListCount = [SELECT count(Id)listSize 
                            FROM Account 
                            WHERE Channel__c =: channel AND Id NOT IN :newA];
            
        } else {
            accountList = [SELECT Id, Name, Account_Status__c, Owner.Name,Channel__c 
                           FROM Account
                           WHERE Channel__c =: channel AND Name LIKE: searchKey
                           AND Id NOT IN :newA
                           ORDER BY Name LIMIT :recordToDisply OFFSET :offset];
            accListCount = [SELECT count(Id)listSize
                            FROM Account
                            WHERE Channel__c =: channel AND Name LIKE: searchKey
                            AND Id NOT IN :newA];
        }
        
        Integer intdata =(integer)accListCount[0].get('listSize');
        
        Integer accListSize = accountList.size();
        
        List<AccountDetailsWrpper> accWrapList= new List<AccountDetailsWrpper>();
        
        for(Account accInst : accountList){
            AccountDetailsWrpper accWrap = new AccountDetailsWrpper();
            accWrap.Name = accInst.Name;
            accWrap.Id = accInst.Id;
            accWrap.Status = accInst.Account_Status__c;
            accWrap.Owner = accInst.Owner.Name;
            accWrapList.add(accWrap);
        }
        
        AccountPagerWrapper accPageWrap =  new AccountPagerWrapper();
        accPageWrap.pageSize = pageSize;
        accPageWrap.page = (Integer) pageNumber;
        accPageWrap.total = intdata;
        accPageWrap.accounts = accWrapList;
        
        return accPageWrap;
    }
    
    //Wrapper for Account Team Row in Tree Grid
    
    public class TreeGridDataWrapper{
        @AuraEnabled public Integer totalTeams = 0;
        @AuraEnabled public Integer totalGroups = 0;
        @AuraEnabled public Integer totalAccounts = 0;
        @AuraEnabled public String channelWrapper;
    }
    
    public class AccountsWrapper{
        @AuraEnabled public String name;
        @AuraEnabled public String AllocationName;
        @AuraEnabled public String Id;
        @AuraEnabled public Decimal YTDSales_LY = 0;
        @AuraEnabled public Decimal YTDSales_TY = 0;
        @AuraEnabled public Decimal Growth= 0;
        @AuraEnabled public Decimal Manual= 0;
        @AuraEnabled public Decimal Ave_Qty= 0;
        @AuraEnabled public Decimal Ave_Gross_Sales= 0;
        @AuraEnabled public Decimal Final_Allocation= 0;
        @AuraEnabled public String Status;
        @AuraEnabled public Decimal Computed_Allocation=0;
        @AuraEnabled public List<AccountsWrapper> accWrapper;
    }
    
    public Class ChannelWrapperMP{
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public List<ItemsMP> items {get;set;}
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public Decimal YTDSales_LY = 0;
        @AuraEnabled public Decimal YTDSales_TY = 0;
        @AuraEnabled public Decimal Growth= 0;
        @AuraEnabled public Decimal Manual= 0;
        @AuraEnabled public Decimal Ave_Qty= 0;
        @AuraEnabled public Decimal Computed_Allocation=0;
        @AuraEnabled public Decimal Ave_Gross_Sales= 0;
        @AuraEnabled public Decimal Final_Allocation= 0;
        @AuraEnabled public Integer channelCount = 0;
        @AuraEnabled public Integer teamCount = 0;
        @AuraEnabled public Integer groupCount = 0;
        @AuraEnabled public Integer accCount = 0;
    }
    
    public Class ItemsMP{
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public List<ItemsMP> items {get;set;}
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public Decimal YTDSales_LY = 0;
        @AuraEnabled public Decimal YTDSales_TY = 0;
        @AuraEnabled public Decimal Growth= 0;
        @AuraEnabled public Decimal Manual= 0;
        @AuraEnabled public Decimal Ave_Qty= 0;
        @AuraEnabled public Decimal Ave_Gross_Sales= 0;
        @AuraEnabled public Decimal Final_Allocation= 0;
        @AuraEnabled public String Status;
        @AuraEnabled public Decimal Computed_Allocation=0;
        @AuraEnabled public Decimal NumberOfAccounts=0;
        @AuraEnabled public Decimal AllocPerBranch=0;
    }
    
    @AuraEnabled
    public static List<AggregateResult> getTotalAllocation (Id allocationId){
        
        List<AggregateResult> tryAlloc = [SELECT SUM(Final_Allocation__c) allocVolume FROM Account_Allocation__c WHERE Allocation__c =: allocationId];
        
        return tryAlloc;
    }
    
    public static Integer groupCtr = 0;
    
    @AuraEnabled
    public static TreeGridDataWrapper getTreeGridData(Id allocationId){
        String a = 'RETURN VALUE';
        
        List<Account_Allocation__c> accAllocations = [SELECT Id, Account__r.Name, Account_Allocation__c.Name, Account__r.Channel__c,
                                                      Account__r.Team__c,Computed_Allocation__c,Allocation_Volume__c, Final_Allocation__c, Account__r.Account_Group__c,
                                                      Ave_Gross_Sales__c, Ave_Qty__c, Growth__c, Status__c, YTDSales_LY__c, YTDSales_TY__c,
                                                      Manual__c,Created_From_API__c,Account__c , Allocation__c
                                                      FROM Account_Allocation__c 
                                                      
                                                      WHERE Allocation__c =: allocationId
                                                      ORDER BY Account__r.Channel__c, Account__r.Team__c, Account__r.Account_Group__c, Account__r.Name];
        
        Allocation__c allocChannel = [SELECT Id, Channel__c FROM Allocation__c WHERE Id =: allocationId];
        
        AggregateResult sumOfTeams = [SELECT COUNT_DISTINCT(Account__r.Team__c) FROM Account_Allocation__c 
                                      WHERE Allocation__c =: allocationId];
        
        
        AggregateResult sumOfGroups = [SELECT COUNT_DISTINCT(Account__r.Account_Group__c) FROM Account_Allocation__c 
                                       WHERE Allocation__c =: allocationId];
        TreeGridDataWrapper data = new TreeGridDataWrapper();
        List<ChannelWrapperMP> listOfChannelWrapper = new List<ChannelWrapperMP>();
        if(allocChannel.Channel__c == 'Mercury'){
            listOfChannelWrapper = mercuryChannelDataMapping(accAllocations);
            sumOfGroups = sumOfTeams;
            data.totalGroups = (Integer)sumOfTeams.get('expr0');
        } else if(allocChannel.Channel__c == 'Key Accounts'){
            listOfChannelWrapper = keyAccountChannelDataMapping(accAllocations);
            sumOfGroups = [SELECT COUNT(Account__r.Account_Group__c) FROM Account_Allocation__c 
                           WHERE Allocation__c =: allocationId];
            data.totalGroups = groupCtr;
        }else{
            listOfChannelWrapper = defaultChannelDataMapping(accAllocations);
            sumOfGroups = [SELECT COUNT(Account__r.Account_Group__c) FROM Account_Allocation__c 
                           WHERE Allocation__c =: allocationId];
            data.totalGroups = groupCtr;
        }
        data.totalTeams = (Integer)sumOfTeams.get('expr0');
        data.totalAccounts = accAllocations.size();
        data.channelWrapper = JSON.serializePretty(listOfChannelWrapper);
        
        return data ;
    }
    
    public static List<ChannelWrapperMP> mercuryChannelDataMapping(List<Account_Allocation__c> accAllocations){
        
        Map<String,Set<String>> mapOfAccountTeamsWithChannelKeySet = new Map<String,Set<String>>();
        Map<String,Set<String>> mapOfAccountGroupsWithTeamKeySet = new Map<String,Set<String>>();
        Map<String,Set<String>> mapOfAccountDetailsWithGroupKeySet = new Map<String,Set<String>>();
        Map<String,Set<String>> mapOfAccountDetailsWithTeamKeySet = new Map<String,Set<String>>();
        Map<String, AccountsWrapper> mapOfAccAlloc = new Map<String, AccountsWrapper>();
        Map<String, Map<String, AccountsWrapper>> mapOfAccAllocWithAccountWrapper = new Map<String, Map<String, AccountsWrapper>>();
        List<ChannelWrapperMP> listOfChannelWrapper = new List<ChannelWrapperMP>();
        List<ItemsMP> listOfAccountWrapper = new List<ItemsMP>();
        for(Account_Allocation__c accAlloc : accAllocations){
            if(mapOfAccountTeamsWithChannelKeySet.containsKey(accAlloc.Account__r.Channel__c)){
                mapOfAccountTeamsWithChannelKeySet.get(accAlloc.Account__r.Channel__c).add(accAlloc.Account__r.Team__c);
                
                if(mapOfAccountGroupsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                    mapOfAccountGroupsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Account_Group__c);
                    
                    if(mapOfAccountDetailsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                        mapOfAccountDetailsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Name);
                        if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Team__c)){
                            mapOfAccAlloc = mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Team__c);
                            if(mapOfAccAlloc.containsKey(accAlloc.Account__c)){
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                            }else{
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                            }
                        }else{
                            
                            AccountsWrapper accountAlloc = new AccountsWrapper();
                            accountAlloc.name = accAlloc.Account__r.Name;
                            accountAlloc.Id = accAlloc.Id;
                            accountAlloc.Manual = accAlloc.Manual__c;
                            accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                            accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                            accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                            accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                            accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                            accountAlloc.Status = accAlloc.Status__c;
                            accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                            
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Team__c, new Map<String, AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                            mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                        }
                    }else{
                        mapOfAccountDetailsWithTeamKeySet.put(accAlloc.Account__r.Team__c, new Set<String>{accAlloc.Account__r.Name});
                        
                        if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Team__c)){
                            mapOfAccAlloc = mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Team__c);
                            if(mapOfAccAlloc.containsKey(accAlloc.Account__c)){
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                            }else{
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                            }
                        }else{
                            AccountsWrapper accountAlloc = new AccountsWrapper();
                            accountAlloc.name = accAlloc.Account__r.Name;
                            accountAlloc.Id = accAlloc.Id;
                            accountAlloc.Manual = accAlloc.Manual__c;
                            accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                            accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                            accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                            accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                            accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                            accountAlloc.Status = accAlloc.Status__c;
                            accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                            
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Team__c, new Map<String, AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                            mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                        }
                    }
                }else{
                    mapOfAccountGroupsWithTeamKeySet.put(accAlloc.Account__r.Team__c, new Set<String>{accAlloc.Account__r.Account_Group__c});
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Team__c)){
                        mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Team__c).put(accAlloc.Account__c, accountAlloc);
                    } else {
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Team__c, new Map<String,AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    }
                    
                }
                
            }else{
                mapOfAccountTeamsWithChannelKeySet.put(accAlloc.Account__r.Channel__c, new Set<String>{accAlloc.Account__r.Team__c});
                
                if(mapOfAccountGroupsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                    mapOfAccountGroupsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Account_Group__c);
                    
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                        mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                        mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c).put(accAlloc.Account__c, accountAlloc);
                    }else{
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String, AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    }
                }else{
                    mapOfAccountGroupsWithTeamKeySet.put(accAlloc.Account__r.Team__c, new Set<String>{accAlloc.Account__r.Account_Group__c});
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Team__c)){
                        mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Team__c).put(accAlloc.Account__c, accountAlloc);
                    } else {
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Team__c, new Map<String,AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    }
                }
            }
        }
        for(String channelName : mapOfAccountTeamsWithChannelKeySet.keySet()){
            ChannelWrapperMP chWrapper = new ChannelWrapperMP();
            chWrapper.name = channelName;
            chWrapper.label = channelName;
            List<ItemsMP> accChannel = new List<ItemsMP>();
            if(channelName == 'Mercury'){
                
                for(String teamName : mapOfAccountTeamsWithChannelKeySet.get(channelName)){
                    ItemsMP aTWrapper = new ItemsMP();
                    aTWrapper.name = teamName;
                    aTWrapper.label = teamName;
                    Integer acctCtr = 0;
                    List<ItemsMP> accGrp = new List<ItemsMP>();
                    for(String groupName : mapOfAccountGroupsWithTeamKeySet.get(teamName)){
                        ItemsMP accGrpWrap = new ItemsMP();
                        accGrpWrap.name = groupName +' - '+ teamName;
                        accGrpWrap.label = groupName +' - '+ teamName;
                        
                        List<ItemsMP> accDtls = new List<ItemsMP>();
                        AccountsWrapper accountWrapper = new AccountsWrapper();
                        accountWrapper.accWrapper = mapOfAccAllocWithAccountWrapper.containsKey(teamName)?mapOfAccAllocWithAccountWrapper.get(teamName).values():New List<AccountsWrapper>();
                        
                        for(AccountsWrapper acctWrapper : accountWrapper.accWrapper){
                            
                            //Account Groups
                            accGrpWrap.YTDSales_LY += acctWrapper.YTDSales_LY;
                            accGrpWrap.YTDSales_TY += acctWrapper.YTDSales_TY;
                            accGrpWrap.AllocPerBranch += acctWrapper.Manual!=null?acctWrapper.Manual:0;
                            accGrpWrap.Manual += acctWrapper.Manual!=null?acctWrapper.Manual:0;
                            accGrpWrap.Ave_Qty += acctWrapper.Ave_Qty;
                            accGrpWrap.Ave_Gross_Sales += acctWrapper.Ave_Gross_Sales;
                            accGrpWrap.Final_Allocation += acctWrapper.Final_Allocation;
                            accGrpWrap.Computed_Allocation += acctWrapper.Computed_Allocation;
                            
                            //Account Alloc
                            ItemsMP accDtlWrap = new ItemsMP(); 
                            accDtlWrap.name = acctWrapper.name;
                            accDtlWrap.Id = acctWrapper.Id;
                            accDtlWrap.YTDSales_LY = acctWrapper.YTDSales_LY;
                            accDtlWrap.YTDSales_TY = acctWrapper.YTDSales_TY;
                            accDtlWrap.Manual += acctWrapper.Manual!=null?acctWrapper.Manual:0;
                            accDtlWrap.Ave_Qty = acctWrapper.Ave_Qty;
                            accDtlWrap.Ave_Gross_Sales = acctWrapper.Ave_Gross_Sales;
                            accDtlWrap.Final_Allocation = acctWrapper.Final_Allocation;
                            accDtlWrap.Status = acctWrapper.Status;
                            accDtlWrap.Computed_Allocation += acctWrapper.Computed_Allocation;
                            
                            Decimal lyDiv = 1;
                            //Account Group Growth
                            if(acctWrapper.YTDSales_LY == 0){
                                lyDiv = 1;
                            }else{
                                lyDiv = acctWrapper.YTDSales_LY;
                            }
                            accDtlWrap.Growth = ((acctWrapper.YTDSales_TY - acctWrapper.YTDSales_LY)/ lyDiv);
                            acctCtr++;
                            accDtls.add(accDtlWrap);
                        }
                        Decimal lyDiv = 1;
                        //Account Group Growth
                        if(accGrpWrap.YTDSales_LY == 0){
                            lyDiv = 1;
                        }else{
                            lyDiv = accGrpWrap.YTDSales_LY;
                        }
                        accGrpWrap.Growth = ((accGrpWrap.YTDSales_TY - accGrpWrap.YTDSales_LY)/ lyDiv);
                        accGrpWrap.NumberOfAccounts = acctCtr;
                        if(accGrpWrap.NumberOfAccounts == 0){
                            accGrpWrap.NumberOfAccounts = 1;
                        }
                        accGrpWrap.AllocPerBranch = Math.floor(accGrpWrap.AllocPerBranch / accGrpWrap.NumberOfAccounts);
                        //Account Teams
                        aTWrapper.NumberOfAccounts += accGrpWrap.NumberOfAccounts;
                        aTWrapper.YTDSales_LY += accGrpWrap.YTDSales_LY;
                        aTWrapper.YTDSales_TY += accGrpWrap.YTDSales_TY;
                        aTWrapper.AllocPerBranch += accGrpWrap.AllocPerBranch;
                        
                        aTWrapper.Manual += accGrpWrap.Manual!=null?accGrpWrap.Manual:0;
                        aTWrapper.Ave_Qty += accGrpWrap.Ave_Qty;
                        aTWrapper.Ave_Gross_Sales += accGrpWrap.Ave_Gross_Sales;
                        aTWrapper.Final_Allocation += accGrpWrap.Final_Allocation;
                        aTWrapper.Computed_Allocation += accGrpWrap.Computed_Allocation;
                        
                        accGrpWrap.items = accDtls ;
                        accGrp.add(accGrpWrap);
                    }
                    Decimal lyDiv = 1;
                    //Account Team Growth
                    if(aTWrapper.YTDSales_LY == 0){
                        lyDiv = 1;
                    }else{
                        lyDiv = aTWrapper.YTDSales_LY;
                    }
                    aTWrapper.Growth = ((aTWrapper.YTDSales_TY - aTWrapper.YTDSales_LY)/ lyDiv);
                    if(groupCtr == 0){
                        groupCtr = 1;
                    }
                    aTWrapper.AllocPerBranch = Math.floor(aTWrapper.AllocPerBranch / groupCtr);
                    //Account Channels
                    chWrapper.YTDSales_LY += aTWrapper.YTDSales_LY;
                    chWrapper.YTDSales_TY += aTWrapper.YTDSales_TY;
                    chWrapper.Manual += aTWrapper.Manual!=null?aTWrapper.Manual:0;
                    chWrapper.Ave_Qty += aTWrapper.Ave_Qty;
                    chWrapper.Ave_Gross_Sales += aTWrapper.Ave_Gross_Sales;
                    chWrapper.Final_Allocation += aTWrapper.Final_Allocation;
                    chWrapper.Computed_Allocation += aTWrapper.Computed_Allocation;
                    
                    aTWrapper.items = accGrp;
                    accChannel.add(aTWrapper);
                }
            }
            
            //Account Channel Growth
            Decimal lyDiv = 1;
            if(chWrapper.YTDSales_LY == 0){
                lyDiv = 1;
            }else{
                lyDiv = chWrapper.YTDSales_LY;
            }
            chWrapper.Growth = ((chWrapper.YTDSales_TY - chWrapper.YTDSales_LY)/ lyDiv);
            chWrapper.items = accChannel;
            listOfChannelWrapper.add(chWrapper);
            
        }
        
        return listOfChannelWrapper;
    }
    
    public static List<ChannelWrapperMP> keyAccountChannelDataMapping(List<Account_Allocation__c> accAllocations){
        //TreeGridMapsWrapper data = new TreeGridMapsWrapper();
        
        Map<String,Set<String>> mapOfAccountTeamsWithChannelKeySet = new Map<String,Set<String>>();
        Map<String,Set<String>> mapOfAccountGroupsWithTeamKeySet = new Map<String,Set<String>>();
        Map<String,Set<String>> mapOfAccountDetailsWithGroupKeySet = new Map<String,Set<String>>();
        Map<String,Set<String>> mapOfAccountDetailsWithTeamKeySet = new Map<String,Set<String>>();
        Map<String, AccountsWrapper> mapOfAccAlloc = new Map<String, AccountsWrapper>();
        Map<String, Map<String, AccountsWrapper>> mapOfAccAllocWithAccountWrapper = new Map<String, Map<String, AccountsWrapper>>();
        List<ChannelWrapperMP> listOfChannelWrapper = new List<ChannelWrapperMP>();
        List<ItemsMP> listOfAccountWrapper = new List<ItemsMP>();
        for(Account_Allocation__c accAlloc : accAllocations){
            
            accAlloc.Account__r.Account_Group__c = accAlloc.Account__r.Account_Group__c + ' - ' + accAlloc.Account__r.Team__c;
            
            if(mapOfAccountTeamsWithChannelKeySet.containsKey(accAlloc.Account__r.Channel__c)){
                //DO THIS IF THERE IS AN EXISTING CHANNEL
                //FOR CREATING NEW TEAM FOR EXISTING CHANNEL
                mapOfAccountTeamsWithChannelKeySet.get(accAlloc.Account__r.Channel__c).add(accAlloc.Account__r.Team__c);
                
                if(mapOfAccountGroupsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                    //DO THIS IF THERE IS AN EXISTING TEAM
                    //FOR CREATING NEW GROUP IN AN EXISTING TEAM
                    mapOfAccountGroupsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Account_Group__c);
                    
                    if(mapOfAccountDetailsWithGroupKeySet.containsKey(accAlloc.Account__r.Account_Group__c)){
                        //DO THIS IF THERE IS AN EXISTING GROUP
                        //FOR CREATING NEW ACCOUNT IN AN EXISTING GROUP
                        mapOfAccountDetailsWithGroupKeySet.get(accAlloc.Account__r.Account_Group__c).add(accAlloc.Account__r.Name);
                        
                        if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                            mapOfAccAlloc = mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c);
                            
                            if(!mapOfAccAlloc.containsKey(accAlloc.Account__c)){
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                            }
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c,mapOfAccAlloc);
                            
                        }else{
                            AccountsWrapper accountAlloc = new AccountsWrapper();
                            accountAlloc.name = accAlloc.Account__r.Name;
                            accountAlloc.Id = accAlloc.Id;
                            accountAlloc.Manual = accAlloc.Manual__c;
                            accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                            accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                            accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                            accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                            accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                            accountAlloc.Status = accAlloc.Status__c;
                            accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String, AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                            
                        }
                    } else {
                        //CHECK IF IT DOESN'T HAVE CREATED GROUP FOR HIERARCHY
                        if(!mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                            AccountsWrapper accountAlloc = new AccountsWrapper();
                            accountAlloc.name = accAlloc.Account__r.Name;
                            accountAlloc.Id = accAlloc.Id;
                            accountAlloc.Manual = accAlloc.Manual__c;
                            accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                            accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                            accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                            accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                            accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                            accountAlloc.Status = accAlloc.Status__c;
                            accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                            //INSERT IT THE ACCOUNT IN THE WRAPPER FOR THE HIERARCHY
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String, AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                            
                        } else {
                            //INSERT HERE ELSE STATEMENT FOR ADDING ACCOUNT IN THE HIERARCHY
                            mapOfAccountDetailsWithGroupKeySet.put(accAlloc.Account__r.Account_Group__c, new Set<String>{accAlloc.Account__r.Name}); 
                            
                            mapOfAccAlloc = mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c);
                            
                            if(!mapOfAccAlloc.containsKey(accAlloc.Account__c)){
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                            }
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c,mapOfAccAlloc);
                            
                        }
                        
                        
                    }
                    
                } else {
                    //RUN THIS IF THERE IS NO EXISTING TEAM
                    //ADD NEW TEAM INSIDE A CHANNEL
                    mapOfAccountGroupsWithTeamKeySet.put(accAlloc.Account__r.Team__c, new Set<String>{accAlloc.Account__r.Account_Group__c+' - '+accAlloc.Account__r.Team__c});
                    
                    //CREATE A NEW INSTANCE OF WRAPPER BASED ON THE ACCOUNT ALLOCATION DATA
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    //This ADDS Another Account inside other group
                    //mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                        mapOfAccountDetailsWithGroupKeySet.get(accAlloc.Account__r.Account_Group__c).add(accAlloc.Account__r.Name);
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c+' - '+accAlloc.Account__r.Team__c, new Map<String,AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    } else {
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c+' - '+accAlloc.Account__r.Team__c, new Map<String,AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    }
                    
                }
                
            } else {
                
                mapOfAccountTeamsWithChannelKeySet.put(accAlloc.Account__r.Channel__c, new Set<String>{accAlloc.Account__r.Team__c});
                
                if(mapOfAccountGroupsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                    mapOfAccountGroupsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Account_Group__c);
                    
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                        mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                        mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c).put(accAlloc.Account__c, accountAlloc);
                    }else{
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String, AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    }
                    
                }else{
                    
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                        mapOfAccountDetailsWithGroupKeySet.get(accAlloc.Account__r.Account_Group__c).add(accAlloc.Account__r.Name);
                        mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c).put(accAlloc.Account__c, accountAlloc);
                    } else {
                        mapOfAccountDetailsWithGroupKeySet.put(accAlloc.Account__r.Account_Group__c, new Set<String>{accAlloc.Account__r.Name});
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String,AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    }
                    
                    mapOfAccountGroupsWithTeamKeySet.put(accAlloc.Account__r.Team__c, new Set<String>{accAlloc.Account__r.Account_Group__c});
                }
            }
        }
        for(String channelName : mapOfAccountTeamsWithChannelKeySet.keySet()){
            ChannelWrapperMP chWrapper = new ChannelWrapperMP();
            chWrapper.name = channelName;
            chWrapper.label = channelName;
            List<ItemsMP> accChannel = new List<ItemsMP>();
            for(String teamName : mapOfAccountTeamsWithChannelKeySet.get(channelName)){
                ItemsMP aTWrapper = new ItemsMP();
                aTWrapper.name = teamName;
                aTWrapper.label = teamName;
                Integer acctCtr = 0;
                List<ItemsMP> accGrp = new List<ItemsMP>();
                
                for(String groupName : mapOfAccountGroupsWithTeamKeySet.get(teamName)){
                    ItemsMP accGrpWrap = new ItemsMP();
                    accGrpWrap.name = groupName +' - '+ teamName;
                    accGrpWrap.label = groupName +' - '+ teamName;
                    //Integer specialIndex = groupName.indexOf('-'); 
                    //accGrpWrap.name = groupName.mid(0, specialIndex-1); //Format : Account Group - Account Team
                    //accGrpWrap.label = groupName.mid(0, specialIndex-1);
                    
                    groupCtr++;
                    
                    List<ItemsMP> accDtls = new List<ItemsMP>();
                    AccountsWrapper accountWrapper = new AccountsWrapper();
                    accountWrapper.accWrapper = mapOfAccAllocWithAccountWrapper.containsKey(groupName)?mapOfAccAllocWithAccountWrapper.get(groupName).values():New List<AccountsWrapper>();
                    
                    for(AccountsWrapper acctWrapper : accountWrapper.accWrapper){
                        
                        //Account Groups
                        accGrpWrap.YTDSales_LY += acctWrapper.YTDSales_LY;
                        accGrpWrap.YTDSales_TY += acctWrapper.YTDSales_TY;
                        accGrpWrap.AllocPerBranch += acctWrapper.Manual!=null?acctWrapper.Manual:0;
                        
                        accGrpWrap.Manual += acctWrapper.Manual!=null?acctWrapper.Manual:0;
                        accGrpWrap.Ave_Qty += acctWrapper.Ave_Qty;
                        accGrpWrap.Ave_Gross_Sales += acctWrapper.Ave_Gross_Sales;
                        accGrpWrap.Final_Allocation += acctWrapper.Final_Allocation;
                        accGrpWrap.Computed_Allocation += acctWrapper.Computed_Allocation;
                        
                        //Account Alloc
                        ItemsMP accDtlWrap = new ItemsMP(); 
                        accDtlWrap.name = acctWrapper.name;
                        accDtlWrap.Id = acctWrapper.Id;
                        accDtlWrap.YTDSales_LY = acctWrapper.YTDSales_LY;
                        accDtlWrap.YTDSales_TY = acctWrapper.YTDSales_TY;
                        accDtlWrap.Manual += acctWrapper.Manual!=null?acctWrapper.Manual:0;
                        accDtlWrap.Ave_Qty = acctWrapper.Ave_Qty;
                        accDtlWrap.Ave_Gross_Sales = acctWrapper.Ave_Gross_Sales;
                        accDtlWrap.Final_Allocation = acctWrapper.Final_Allocation;
                        accDtlWrap.Status = acctWrapper.Status;
                        accDtlWrap.Computed_Allocation += acctWrapper.Computed_Allocation;
                        
                        Decimal lyDiv = 1;
                        //Account Group Growth
                        if(acctWrapper.YTDSales_LY == 0){
                            lyDiv = 1;
                        }else{
                            lyDiv = acctWrapper.YTDSales_LY;
                        }
                        accDtlWrap.Growth = ((acctWrapper.YTDSales_TY - acctWrapper.YTDSales_LY)/ lyDiv);
                        acctCtr++;
                        accDtls.add(accDtlWrap);
                    }
                    Decimal lyDiv = 1;
                    //Account Group Growth
                    if(accGrpWrap.YTDSales_LY == 0){
                        lyDiv = 1;
                    }else{
                        lyDiv = accGrpWrap.YTDSales_LY;
                    }
                    accGrpWrap.Growth = ((accGrpWrap.YTDSales_TY - accGrpWrap.YTDSales_LY)/ lyDiv);
                    accGrpWrap.NumberOfAccounts = acctCtr;
                    if(accGrpWrap.NumberOfAccounts == 0){
                        accGrpWrap.NumberOfAccounts = 1;
                    }
                    accGrpWrap.AllocPerBranch = Math.floor(accGrpWrap.AllocPerBranch / accGrpWrap.NumberOfAccounts);
                    //Account Teams
                    aTWrapper.YTDSales_LY += accGrpWrap.YTDSales_LY;
                    aTWrapper.YTDSales_TY += accGrpWrap.YTDSales_TY;
                    aTWrapper.NumberOfAccounts += accGrpWrap.NumberOfAccounts;
                    aTWrapper.AllocPerBranch += accGrpWrap.AllocPerBranch;
                    
                    aTWrapper.Manual += accGrpWrap.Manual!=null?accGrpWrap.Manual:0;
                    aTWrapper.Ave_Qty += accGrpWrap.Ave_Qty;
                    aTWrapper.Ave_Gross_Sales += accGrpWrap.Ave_Gross_Sales;
                    aTWrapper.Final_Allocation += accGrpWrap.Final_Allocation;
                    aTWrapper.Computed_Allocation += accGrpWrap.Computed_Allocation;
                    
                    accGrpWrap.items = accDtls ;
                    accGrp.add(accGrpWrap);
                }
                Decimal lyDiv = 1;
                //Account Team Growth
                if(aTWrapper.YTDSales_LY == 0){
                    lyDiv = 1;
                }else{
                    lyDiv = aTWrapper.YTDSales_LY;
                }
                aTWrapper.Growth = ((aTWrapper.YTDSales_TY - aTWrapper.YTDSales_LY)/ lyDiv);
                if(groupCtr == 0){
                    groupCtr = 1;
                }
                aTWrapper.AllocPerBranch = Math.floor(aTWrapper.AllocPerBranch / groupCtr);
                //Account Channels
                chWrapper.YTDSales_LY += aTWrapper.YTDSales_LY;
                chWrapper.YTDSales_TY += aTWrapper.YTDSales_TY;
                chWrapper.Manual += aTWrapper.Manual!=null?aTWrapper.Manual:0;
                chWrapper.Ave_Qty += aTWrapper.Ave_Qty;
                chWrapper.Ave_Gross_Sales += aTWrapper.Ave_Gross_Sales;
                chWrapper.Final_Allocation += aTWrapper.Final_Allocation;
                chWrapper.Computed_Allocation += aTWrapper.Computed_Allocation;
                
                aTWrapper.items = accGrp;
                accChannel.add(aTWrapper);
            }
            
            //Account Channel Growth
            Decimal lyDiv = 1;
            if(chWrapper.YTDSales_LY == 0){
                lyDiv = 1;
            }else{
                lyDiv = chWrapper.YTDSales_LY;
            }
            chWrapper.Growth = ((chWrapper.YTDSales_TY - chWrapper.YTDSales_LY)/ lyDiv);
            chWrapper.items = accChannel;
            listOfChannelWrapper.add(chWrapper);
            
        }
        
        return listOfChannelWrapper;
    }
    
    
    public static List<ChannelWrapperMP> defaultChannelDataMapping(List<Account_Allocation__c> accAllocations){
        //TreeGridMapsWrapper data = new TreeGridMapsWrapper();
        
        Map<String,Set<String>> mapOfAccountTeamsWithChannelKeySet = new Map<String,Set<String>>();
        Map<String,Set<String>> mapOfAccountGroupsWithTeamKeySet = new Map<String,Set<String>>();
        Map<String,Set<String>> mapOfAccountDetailsWithGroupKeySet = new Map<String,Set<String>>();
        Map<String,Set<String>> mapOfAccountDetailsWithTeamKeySet = new Map<String,Set<String>>();
        Map<String, AccountsWrapper> mapOfAccAlloc = new Map<String, AccountsWrapper>();
        Map<String, Map<String, AccountsWrapper>> mapOfAccAllocWithAccountWrapper = new Map<String, Map<String, AccountsWrapper>>();
        List<ChannelWrapperMP> listOfChannelWrapper = new List<ChannelWrapperMP>();
        List<ItemsMP> listOfAccountWrapper = new List<ItemsMP>();
        for(Account_Allocation__c accAlloc : accAllocations){
            
            accAlloc.Account__r.Account_Group__c = accAlloc.Account__r.Account_Group__c + ' - ' + accAlloc.Account__r.Team__c;
            
            if(mapOfAccountTeamsWithChannelKeySet.containsKey(accAlloc.Account__r.Channel__c)){
                
                mapOfAccountTeamsWithChannelKeySet.get(accAlloc.Account__r.Channel__c).add(accAlloc.Account__r.Team__c);
                
                if(mapOfAccountGroupsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                    
                    mapOfAccountGroupsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Account_Group__c);
                    
                    if(mapOfAccountDetailsWithGroupKeySet.containsKey(accAlloc.Account__r.Account_Group__c)){
                        mapOfAccountDetailsWithGroupKeySet.get(accAlloc.Account__r.Account_Group__c).add(accAlloc.Account__r.Name);
                        
                        if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                            mapOfAccAlloc = mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c);
                            
                            if(mapOfAccAlloc.containsKey(accAlloc.Account__c)){
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                                
                            }else{
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                            }
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c,mapOfAccAlloc);
                            
                        }else{
                            AccountsWrapper accountAlloc = new AccountsWrapper();
                            accountAlloc.name = accAlloc.Account__r.Name;
                            accountAlloc.Id = accAlloc.Id;
                            accountAlloc.Manual = accAlloc.Manual__c;
                            accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                            accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                            accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                            accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                            accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                            accountAlloc.Status = accAlloc.Status__c;
                            accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String, AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                            
                        }
                    } else {
                        mapOfAccountDetailsWithGroupKeySet.put(accAlloc.Account__r.Account_Group__c, new Set<String>{accAlloc.Account__r.Name});
                        //INSERT HERE ELSE STATEMENT FOR ADDING ACCOUNT IN THE HIERARCHY
                        if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                            mapOfAccAlloc = mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c);
                            
                            if(mapOfAccAlloc.containsKey(accAlloc.Account__c)){
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                                
                            }else{
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                            }
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c,mapOfAccAlloc);
                            
                        }else{
                            AccountsWrapper accountAlloc = new AccountsWrapper();
                            accountAlloc.name = accAlloc.Account__r.Name;
                            accountAlloc.Id = accAlloc.Id;
                            accountAlloc.Manual = accAlloc.Manual__c;
                            accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                            accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                            accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                            accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                            accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                            accountAlloc.Status = accAlloc.Status__c;
                            accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String, AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                            
                        }
                        
                    }
                    
                } else {
                    mapOfAccountGroupsWithTeamKeySet.put(accAlloc.Account__r.Team__c, new Set<String>{accAlloc.Account__r.Account_Group__c});
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                        mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c).put(accAlloc.Account__c, accountAlloc);
                    } else {
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String,AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    }
                }
                
            } else {
                
                mapOfAccountTeamsWithChannelKeySet.put(accAlloc.Account__r.Channel__c, new Set<String>{accAlloc.Account__r.Team__c});
                
                if(mapOfAccountGroupsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                    mapOfAccountGroupsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Account_Group__c);
                    
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                        mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c).put(accAlloc.Account__c, accountAlloc);
                    }else{
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String, AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    }
                    
                }else{
                    mapOfAccountGroupsWithTeamKeySet.put(accAlloc.Account__r.Team__c, new Set<String>{accAlloc.Account__r.Account_Group__c});
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                        mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c).put(accAlloc.Account__c, accountAlloc);
                    } else {
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String,AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    }
                }
            }
        }
        for(String channelName : mapOfAccountTeamsWithChannelKeySet.keySet()){
            ChannelWrapperMP chWrapper = new ChannelWrapperMP();
            chWrapper.name = channelName;
            chWrapper.label = channelName;
            List<ItemsMP> accChannel = new List<ItemsMP>();
            for(String teamName : mapOfAccountTeamsWithChannelKeySet.get(channelName)){
                ItemsMP aTWrapper = new ItemsMP();
                aTWrapper.name = teamName;
                aTWrapper.label = teamName;
                
                
                List<ItemsMP> accGrp = new List<ItemsMP>();
                
                for(String groupName : mapOfAccountGroupsWithTeamKeySet.get(teamName)){
                    ItemsMP accGrpWrap = new ItemsMP();
                    accGrpWrap.name = groupName +' - '+ teamName;
                    accGrpWrap.label = groupName +' - '+ teamName;
                    //Integer specialIndex = groupName.indexOf('-');
                    //accGrpWrap.name = groupName.mid(0, specialIndex-1);
                    //accGrpWrap.label = groupName.mid(0, specialIndex-1);
                    groupCtr++;
                    List<ItemsMP> accDtls = new List<ItemsMP>();
                    AccountsWrapper accountWrapper = new AccountsWrapper();
                    accountWrapper.accWrapper = mapOfAccAllocWithAccountWrapper.containsKey(groupName)?mapOfAccAllocWithAccountWrapper.get(groupName).values():New List<AccountsWrapper>();
                    Integer acctCtr = 0;
                    for(AccountsWrapper acctWrapper : accountWrapper.accWrapper){
                        
                        //Account Groups
                        accGrpWrap.YTDSales_LY += acctWrapper.YTDSales_LY;
                        accGrpWrap.YTDSales_TY += acctWrapper.YTDSales_TY;
                        accGrpWrap.AllocPerBranch += acctWrapper.Manual!=null?acctWrapper.Manual:0;
                        
                        accGrpWrap.Manual += acctWrapper.Manual!=null?acctWrapper.Manual:0;
                        accGrpWrap.Ave_Qty += acctWrapper.Ave_Qty;
                        accGrpWrap.Ave_Gross_Sales += acctWrapper.Ave_Gross_Sales;
                        accGrpWrap.Final_Allocation += acctWrapper.Final_Allocation;
                        accGrpWrap.Computed_Allocation += acctWrapper.Computed_Allocation;
                        
                        //Account Alloc
                        ItemsMP accDtlWrap = new ItemsMP(); 
                        accDtlWrap.name = acctWrapper.name;
                        accDtlWrap.Id = acctWrapper.Id;
                        accDtlWrap.YTDSales_LY = acctWrapper.YTDSales_LY;
                        accDtlWrap.YTDSales_TY = acctWrapper.YTDSales_TY;
                        //accDtlWrap.Growth = acctWrapper.Growth;
                        accDtlWrap.Manual += acctWrapper.Manual!=null?acctWrapper.Manual:0;
                        accDtlWrap.Ave_Qty = acctWrapper.Ave_Qty;
                        accDtlWrap.Ave_Gross_Sales = acctWrapper.Ave_Gross_Sales;
                        accDtlWrap.Final_Allocation = acctWrapper.Final_Allocation;
                        accDtlWrap.Status = acctWrapper.Status;
                        accDtlWrap.Computed_Allocation += acctWrapper.Computed_Allocation;
                        
                        Decimal lyDiv = 1;
                        //Account Group Growth
                        if(acctWrapper.YTDSales_LY == null || acctWrapper.YTDSales_LY == 0){ // updated by Joan 052419
                            lyDiv = 1;
                        }else{
                            lyDiv = acctWrapper.YTDSales_LY;
                        }
                        accDtlWrap.Growth = ((acctWrapper.YTDSales_TY - acctWrapper.YTDSales_LY)/ lyDiv);
                        acctCtr++;
                        accDtls.add(accDtlWrap);
                    }
                    Decimal lyDiv = 1;
                    //Account Group Growth
                    if(accGrpWrap.YTDSales_LY == null || accGrpWrap.YTDSales_LY == 0){
                        lyDiv = 1;
                    }else{
                        lyDiv = accGrpWrap.YTDSales_LY;
                    }
                    accGrpWrap.Growth = ((accGrpWrap.YTDSales_TY - accGrpWrap.YTDSales_LY)/ lyDiv);
                    accGrpWrap.NumberOfAccounts = acctCtr;
                    if(accGrpWrap.NumberOfAccounts == 0){
                        accGrpWrap.NumberOfAccounts = 1;
                    }
                    accGrpWrap.AllocPerBranch = Math.floor(accGrpWrap.AllocPerBranch / accGrpWrap.NumberOfAccounts);
                    //Account Teams
                    aTWrapper.YTDSales_LY += accGrpWrap.YTDSales_LY;
                    aTWrapper.YTDSales_TY += accGrpWrap.YTDSales_TY;
                    aTWrapper.NumberOfAccounts += accGrpWrap.NumberOfAccounts;
                    aTWrapper.AllocPerBranch += accGrpWrap.AllocPerBranch;
                    
                    aTWrapper.Manual += accGrpWrap.Manual!=null?accGrpWrap.Manual:0;
                    aTWrapper.Ave_Qty += accGrpWrap.Ave_Qty;
                    aTWrapper.Ave_Gross_Sales += accGrpWrap.Ave_Gross_Sales;
                    aTWrapper.Final_Allocation += accGrpWrap.Final_Allocation;
                    aTWrapper.Computed_Allocation += accGrpWrap.Computed_Allocation;
                    
                    accGrpWrap.items = accDtls ;
                    accGrp.add(accGrpWrap);
                }
                Decimal lyDiv = 1;
                //Account Team Growth
                if(aTWrapper.YTDSales_LY == null || aTWrapper.YTDSales_LY == 0){
                    lyDiv = 1;
                }else{
                    lyDiv = aTWrapper.YTDSales_LY;
                }
                aTWrapper.Growth = ((aTWrapper.YTDSales_TY - aTWrapper.YTDSales_LY)/ lyDiv);
                if(groupCtr == 0){
                    groupCtr = 1;
                }
                aTWrapper.AllocPerBranch = Math.floor(aTWrapper.AllocPerBranch / groupCtr);
                //Account Channels
                chWrapper.YTDSales_LY += aTWrapper.YTDSales_LY;
                chWrapper.YTDSales_TY += aTWrapper.YTDSales_TY;
                
                chWrapper.Manual += aTWrapper.Manual!=null?aTWrapper.Manual:0;
                chWrapper.Ave_Qty += aTWrapper.Ave_Qty;
                chWrapper.Ave_Gross_Sales += aTWrapper.Ave_Gross_Sales;
                chWrapper.Final_Allocation += aTWrapper.Final_Allocation;
                chWrapper.Computed_Allocation += aTWrapper.Computed_Allocation;
                
                aTWrapper.items = accGrp;
                accChannel.add(aTWrapper);
            }
            //Account Channel Growth
            Decimal lyDiv = 1;
            if(chWrapper.YTDSales_LY == null || chWrapper.YTDSales_LY == 0){
                lyDiv = 1;
            }else{
                lyDiv = chWrapper.YTDSales_LY;
            }
            chWrapper.Growth = ((chWrapper.YTDSales_TY - chWrapper.YTDSales_LY)/ lyDiv);
            chWrapper.items = accChannel;
            listOfChannelWrapper.add(chWrapper);
            
        }
        
        return listOfChannelWrapper;
    } 
    
    
    @AuraEnabled
    public static Integer getTotalAccAllocations(Integer count){
        return count;
    } 
    
    @AuraEnabled
    public static List<Account_Allocation__c> getAccAllocations (Allocation__c alloc){
        List<Account_Allocation__c> accAllocList = getAccAllocations2(alloc);	
        
        if(accAllocList.isEmpty()){
            accAllocList = processAccountAllocations(alloc);													  
        }
        return accAllocList;		 
    }
    
    @AuraEnabled
    public static List<Account> getAccFilter (Id allocationId, String channel){ 
        
        List<Account_Allocation__c> accAllocations = [SELECT Id, Account__r.Name, Account_Allocation__c.Name, Account__r.Channel__c,
                                                      Account__r.Team__c, Account__r.Account_Group__c,
                                                      Ave_Gross_Sales__c, Ave_Qty__c, Growth__c, Status__c, YTDSales_LY__c, YTDSales_TY__c,
                                                      Manual__c,Created_From_API__c,Account__c , Allocation__c
                                                      FROM Account_Allocation__c 
                                                      WHERE Allocation__c =: allocationId
                                                      ORDER BY Account__r.Channel__c, Account__r.Team__c, Account__r.Account_Group__c, Account__r.Name];
        
        List<Id> newA = new List<Id>();
        
        for(Account_Allocation__c a : accAllocations){
            
            newA.add(a.Account__c);
            
        }
        
        List<Account> accFilter = [SELECT Id, Name, Account_Status__c, Owner.Name
                                   FROM Account 
                                   WHERE Channel__c =: channel AND Id NOT IN :newA];
        
        return accFilter;	
        
    }  
    
    @AuraEnabled
    public static String cloneAllocRecord(String recordId){
        Allocation__c parentAlloc = [SELECT Id, Status__c, Channel__c, Promo__c
                                     FROM Allocation__c
                                     WHERE Id =: recordId];
        
        Allocation__c clonedAlloc = new Allocation__c();
        clonedAlloc.Channel__c = parentAlloc.Channel__c;
        clonedAlloc.Promo__c = parentAlloc.Promo__c;
        clonedAlloc.Status__c = 'Draft';
        try{
            insert clonedAlloc;
            parentAlloc.Status__c = 'Cancelled';
            update parentAlloc;
            return clonedAlloc.Id;
        }catch(Exception ex){
            return null;
        }
    } 
}