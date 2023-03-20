/*----------------------------------------------------------------------------------------------------
Author       :   Kristjan Mariano
Created Date :   04.17.2019
Definition   :   Apex Class for UNILAB_PAL Lead View
-----------------------------------------------------------------------------------------------------*/
public class UNILAB_PAL_Lead_Controller {
    
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
    public static boolean allocationIsEmpty(Id recordId){
        List<Allocation__c> allocList = [SELECT Id FROM Allocation__c WHERE Promo__c=:recordId];
        
        if(allocList.size() > 0){
            return true;
        }else{
            return false;
        }
    }
    
    @AuraEnabled
    public static List <ColumnHeader> getColumns(Id recordId){
        Id profileId=userinfo.getProfileId();
        List<PAL_Generate_Columns__c> columnValuesList = new List<PAL_Generate_Columns__c>();
        
        
        
        Allocation__c allocRecord = [SELECT Id,Sell_in_Data_Type__c,Sell_out_Data_Type__c FROM Allocation__c WHERE Promo__c =: recordId LIMIT 1];
        
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
    public static List<Allocation__c> getAllocationRecords (Id recordId){
        List<Allocation__c> allocList;
        try{
            allocList = [SELECT Id, Status__c, Account_Status__c,Along_National_Highway_Residential__c,Channel__c,Ending_Inventory_Data_Type__c,
                         End_Date__c,Frequency_of_Visit__c,Fronting_Near_Hospital__c,Allocation_Volume__c,
                         Mall_Based__c,Name,Near_a_Call_Center__c,Near_a_Generics_Drugstore__c,
                         Near_a_Grade_High_School__c,Near_a_Pre_School__c,Near_a_University_College__c,Near_Clinic__c,
                         Near_Offices__c,Near_or_Within_a_Supermarket__c,Near_Other_Drugstores__c,Near_Public_Market__c,
                         Near_Transport_Terminal__c,Promo__r.Name,RPS_Account_Class__c,Self_Service_Floor_Area__c,Sell_in_Data_Type__c,
                         Sell_out_Data_Type__c,Start_Date__c,Store_Format__c,Store_Physical_Size__c,With_Lamp_Coverage__c,With_TPA_Coverage__c,
                         Sell_in__c,Sell_out__c, Ending_Inventory__c,Ending_Inventory_Operator__c,Ending_Inventory_Value__c, Promo__r.Promo_Name__c,
                         Promo__r.Status__c,Over_Allocated__c,Total_Account_Allocation__c
                         FROM Allocation__c
                         WHERE Promo__c=:recordId];
            
        }catch(Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('Error in retrieving Allocation record: '
                                           + e.getMessage());    
            
            
        }											  
        return allocList;
    }
    
    public static Integer groupCtr = 0;
    
    @AuraEnabled
    public static TreeGridDataWrapper getTreeGridData(List<Allocation__c> allocList){
        String a = 'RETURN VALUE';
        
        List<Id> allocIds = new List<Id>();
        
        for(Allocation__c allocRec : allocList){
            allocIds.add(allocRec.Id);
        }
        
        List<Account_Allocation__c> accAllocations = [SELECT Id, Account__r.Name, Account_Allocation__c.Name, Account__r.Channel__c,
                                                      Account__r.Team__c,Computed_Allocation__c,Allocation_Volume__c, Final_Allocation__c, Account__r.Account_Group__c,
                                                      Ave_Gross_Sales__c, Ave_Qty__c, Growth__c, Status__c, YTDSales_LY__c, YTDSales_TY__c,
                                                      Manual__c,Created_From_API__c,Account__c , Allocation__c
                                                      FROM Account_Allocation__c 
                                                      WHERE Allocation__c IN: allocIds
                                                      ORDER BY Account__r.Channel__c, Account__r.Team__c, Account__r.Account_Group__c, Account__r.Name];
        
        System.debug('ACC ALLOC - ' + accAllocations);
        
        List<Allocation__c> allocChannels = [SELECT Id, Channel__c FROM Allocation__c WHERE Id IN: allocIds];
        
        System.debug('Channels - ' + allocChannels);
        
        AggregateResult sumOfTeams = [SELECT COUNT_DISTINCT(Account__r.Team__c) FROM Account_Allocation__c 
                                      WHERE Allocation__c IN: allocIds];
        
        
        AggregateResult sumOfGroups = [SELECT COUNT_DISTINCT(Account__r.Account_Group__c) FROM Account_Allocation__c 
                                       WHERE Allocation__c IN: allocIds];
        TreeGridDataWrapper data = new TreeGridDataWrapper();
        List<ChannelWrapperMP> listOfChannelWrapper = new List<ChannelWrapperMP>();
        listOfChannelWrapper = mercuryChannelDataMapping(accAllocations);
        sumOfGroups = [SELECT COUNT(Account__r.Account_Group__c) FROM Account_Allocation__c 
                       WHERE Allocation__c IN: allocIds];
        data.totalGroups = groupCtr;
        data.totalTeams = (Integer)sumOfTeams.get('expr0');
        
        data.totalAccounts = accAllocations.size();
        data.channelWrapper = JSON.serializePretty(listOfChannelWrapper);
        
        //System.debug('CHANNEL WRAPPERS: ' + JSON.serializePretty(listOfChannelWrapper));
        
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
            if(accAlloc.Account__r.Channel__c == 'Mercury'){
                if(mapOfAccountTeamsWithChannelKeySet.containsKey(accAlloc.Account__r.Channel__c)){
                mapOfAccountTeamsWithChannelKeySet.get(accAlloc.Account__r.Channel__c).add(accAlloc.Account__r.Team__c);
                
                if(mapOfAccountGroupsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                    mapOfAccountGroupsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Account_Group__c);
                    //System.debug('INSIDE mapOfAccountGroupsWithTeamKeySet ');
                    
                    if(mapOfAccountDetailsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                        mapOfAccountDetailsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Name);
                        //System.debug('INSIDE mapOfAccountDetailsWithTeamKeySet ');
                        //System.debug('mapOfAccountDetailsWithTeamKeySet' + mapOfAccountDetailsWithTeamKeySet);
                        if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Team__c)){
                            System.debug('INSIDE mapOfAccAllocWithAccountWrapper ');
                            mapOfAccAlloc = mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Team__c);
                            System.debug(accAlloc.Account__r.Team__c);
                            System.debug(accAlloc.Account__c);
                            if(mapOfAccAlloc.containsKey(accAlloc.Account__c)){
                                System.debug('INSIDE mapOfAccAlloc '); 
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                                System.debug('INSIDE mapOfAccAlloc ELSE'); 
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                                //System.debug('INSIDE mapOfAccAlloc ELSE mapOfAccAlloc ' + mapOfAccAlloc); 
                            }
                        }else{
                            
                            //System.debug('INSIDE mapOfAccAllocWithAccountWrapper ELSE');
                            AccountsWrapper accountAlloc = new AccountsWrapper();
                            accountAlloc.name = accAlloc.Account__r.Name;
                            accountAlloc.Id = accAlloc.Id;
                            //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                        //System.debug('INSIDE mapOfAccountGroupsWithTeamKeySet ELSE');
                        //System.debug('mapOfAccountDetailsWithTeamKeySet' + mapOfAccountDetailsWithTeamKeySet);
                        
                        if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Team__c)){
                            //System.debug('INSIDE mapOfAccAllocWithAccountWrapper ');
                            mapOfAccAlloc = mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Team__c);
                            if(mapOfAccAlloc.containsKey(accAlloc.Account__c)){
                                //System.debug('INSIDE mapOfAccAlloc '); 
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                                //System.debug('INSIDE mapOfAccAlloc ELSE'); 
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
                                accountAlloc.Manual = accAlloc.Manual__c;
                                accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                                accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                                accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                                accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                                accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                                accountAlloc.Status = accAlloc.Status__c;
                                accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                                
                                mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                                //System.debug('INSIDE mapOfAccAlloc ELSE mapOfAccAlloc ' + mapOfAccAlloc); 
                            }
                        }else{
                            
                            //System.debug('INSIDE mapOfAccAllocWithAccountWrapper ELSE');
                            AccountsWrapper accountAlloc = new AccountsWrapper();
                            accountAlloc.name = accAlloc.Account__r.Name;
                            accountAlloc.Id = accAlloc.Id;
                            //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                        //mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                    }
                }else{
                    mapOfAccountGroupsWithTeamKeySet.put(accAlloc.Account__r.Team__c, new Set<String>{accAlloc.Account__r.Account_Group__c});
                    //System.debug('INSIDE mapOfAccountGroupsWithTeamKeySet ELSE');
                    //System.debug('mapOfAccountGroupsWithTeamKeySet '+mapOfAccountGroupsWithTeamKeySet);
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    //mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Team__c)){
                        //mapOfAccountDetailsWithGroupKeySet.get(accAlloc.Account__r.Account_Group__c).add(accAlloc.Account__r.Name);
                        //System.debug('INSIDE mapOfAccAllocWithAccountWrapper');
                        mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Team__c).put(accAlloc.Account__c, accountAlloc);
                    } else {
                        //mapOfAccountDetailsWithGroupKeySet.put(accAlloc.Account__r.Account_Group__c, new Set<String>{accAlloc.Account__r.Name});
                        //System.debug('INSIDE mapOfAccAllocWithAccountWrapper ELSE');
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Team__c, new Map<String,AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                    }
                    
                }
                
            }else{
                //System.debug('INSIDE mapOfAccountTeamsWithChannelKeySet ELSE');
                mapOfAccountTeamsWithChannelKeySet.put(accAlloc.Account__r.Channel__c, new Set<String>{accAlloc.Account__r.Team__c});
                
                if(mapOfAccountGroupsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                    mapOfAccountGroupsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Account_Group__c);
                    
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                    //System.debug('INSIDE mapOfAccountGroupsWithTeamKeySet ELSE ELSE');
                    mapOfAccountGroupsWithTeamKeySet.put(accAlloc.Account__r.Team__c, new Set<String>{accAlloc.Account__r.Account_Group__c});
                    AccountsWrapper accountAlloc = new AccountsWrapper();
                    accountAlloc.name = accAlloc.Account__r.Name;
                    accountAlloc.Id = accAlloc.Id;
                    //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
                    accountAlloc.Manual = accAlloc.Manual__c;
                    accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                    accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                    accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                    accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                    accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                    accountAlloc.Status = accAlloc.Status__c;
                    accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                    //mapOfAccAlloc.put(accAlloc.Account__c, accountAlloc);
                    
                    if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Team__c)){
                        //mapOfAccountDetailsWithGroupKeySet.get(accAlloc.Account__r.Account_Group__c).add(accAlloc.Account__r.Name);
                        mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Team__c).put(accAlloc.Account__c, accountAlloc);
                    } else {
                        //System.debug('INSIDE mapOfAccountGroupsWithTeamKeySet ELSE ELSE');
                        //mapOfAccountDetailsWithGroupKeySet.put(accAlloc.Account__r.Account_Group__c, new Set<String>{accAlloc.Account__r.Name});
                        mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Team__c, new Map<String,AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                        System.debug('INSIDE mapOfAccountGroupsWithTeamKeySet' + mapOfAccAllocWithAccountWrapper.get('ROSE_PHARMACY'));
                    }
                }
            }
                
            }else if(accAlloc.Account__r.Channel__c == 'Key Accounts'){
                
                if(mapOfAccountTeamsWithChannelKeySet.containsKey(accAlloc.Account__r.Channel__c)){
                //System.debug('INSIDE 1');
                //DO THIS IF THERE IS AN EXISTING CHANNEL
                //FOR CREATING NEW TEAM FOR EXISTING CHANNEL
                mapOfAccountTeamsWithChannelKeySet.get(accAlloc.Account__r.Channel__c).add(accAlloc.Account__r.Team__c);
                
                if(mapOfAccountGroupsWithTeamKeySet.containsKey(accAlloc.Account__r.Team__c)){
                    //System.debug('INSIDE 2');
                    //DO THIS IF THERE IS AN EXISTING TEAM
                    //FOR CREATING NEW GROUP IN AN EXISTING TEAM
                    mapOfAccountGroupsWithTeamKeySet.get(accAlloc.Account__r.Team__c).add(accAlloc.Account__r.Account_Group__c);
                    
                    if(mapOfAccountDetailsWithGroupKeySet.containsKey(accAlloc.Account__r.Account_Group__c)){
                        //System.debug('INSIDE 3');
                        //DO THIS IF THERE IS AN EXISTING GROUP
                        //FOR CREATING NEW ACCOUNT IN AN EXISTING GROUP
                        mapOfAccountDetailsWithGroupKeySet.get(accAlloc.Account__r.Account_Group__c).add(accAlloc.Account__r.Name);
                        
                        if(mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                            //System.debug('INSIDE 4');
                            //System.debug('mapOfAccAllocWithAccountWrapper'+mapOfAccAllocWithAccountWrapper);
                            mapOfAccAlloc = mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c);
                            
                            if(!mapOfAccAlloc.containsKey(accAlloc.Account__c)){
                                //System.debug('INSIDE 5');
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                            //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
                            accountAlloc.Manual = accAlloc.Manual__c;
                            accountAlloc.YTDSales_LY += accAlloc.YTDSales_LY__c!=null?accAlloc.YTDSales_LY__c:0;
                            accountAlloc.YTDSales_TY += accAlloc.YTDSales_TY__c!=null?accAlloc.YTDSales_TY__c:0;
                            accountAlloc.Ave_Qty += accAlloc.Ave_Qty__c!=null?accAlloc.Ave_Qty__c:0;
                            accountAlloc.Ave_Gross_Sales += accAlloc.Ave_Gross_Sales__c!=null?accAlloc.Ave_Gross_Sales__c:0;
                            accountAlloc.Final_Allocation += accAlloc.Final_Allocation__c!=null?accAlloc.Final_Allocation__c:0;
                            accountAlloc.Status = accAlloc.Status__c;
                            accountAlloc.Computed_Allocation = accAlloc.Computed_Allocation__c!=null?accAlloc.Computed_Allocation__c:0;
                            mapOfAccAllocWithAccountWrapper.put(accAlloc.Account__r.Account_Group__c, new Map<String, AccountsWrapper>{accAlloc.Account__c => accountAlloc});
                            
                            //System.debug('mapOfAccAllocWithAccountWrapper ELSE'+mapOfAccAllocWithAccountWrapper);
                        }
                    } else {
                        //System.debug('mapOfAccountDetailsWithGroupKeySet ELSE'+mapOfAccountDetailsWithGroupKeySet);
                        //System.debug('INSIDE 3 ELSE');
                        //CHECK IF IT DOESN'T HAVE CREATED GROUP FOR HIERARCHY
                        if(!mapOfAccAllocWithAccountWrapper.containsKey(accAlloc.Account__r.Account_Group__c)){
                            AccountsWrapper accountAlloc = new AccountsWrapper();
                            accountAlloc.name = accAlloc.Account__r.Name;
                            accountAlloc.Id = accAlloc.Id;
                            //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                            //System.debug('INSIDE 4 ELSE');
                            mapOfAccountDetailsWithGroupKeySet.put(accAlloc.Account__r.Account_Group__c, new Set<String>{accAlloc.Account__r.Name}); 
                            
                            mapOfAccAlloc = mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c);
                            
                            if(!mapOfAccAlloc.containsKey(accAlloc.Account__c)){
                                //System.debug('INSIDE 5');
                                AccountsWrapper accountAlloc = new AccountsWrapper();
                                accountAlloc.name = accAlloc.Account__r.Name;
                                accountAlloc.Id = accAlloc.Id;
                                //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                    //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                        //mapOfAccAllocWithAccountWrapper.get(accAlloc.Account__r.Account_Group__c+' - '+accAlloc.Account__r.Team__c).put(accAlloc.Account__c, accountAlloc);
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
                    //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                    //accountAlloc.Growth = (accAlloc.Growth__c).setScale(2, RoundingMode.HALF_UP);
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
                
            }else{
                
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
                        groupCtr++;
                        List<ItemsMP> accDtls = new List<ItemsMP>();
                        AccountsWrapper accountWrapper = new AccountsWrapper();
                        accountWrapper.accWrapper = mapOfAccAllocWithAccountWrapper.containsKey(teamName)?mapOfAccAllocWithAccountWrapper.get(teamName).values():New List<AccountsWrapper>();
                        
                        for(AccountsWrapper acctWrapper : accountWrapper.accWrapper){
                            
                            //Account Groups
                            accGrpWrap.YTDSales_LY += acctWrapper.YTDSales_LY;
                            accGrpWrap.YTDSales_TY += acctWrapper.YTDSales_TY;
                            
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
                            
                            Decimal lyDiv = 0;
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
                        Decimal lyDiv = 0;
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
                    Decimal lyDiv = 0;
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
            }else if(channelName == 'Key Accounts'){
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
                        groupCtr++;
                        List<ItemsMP> accDtls = new List<ItemsMP>();
                        AccountsWrapper accountWrapper = new AccountsWrapper();
                        accountWrapper.accWrapper = mapOfAccAllocWithAccountWrapper.containsKey(groupName)?mapOfAccAllocWithAccountWrapper.get(groupName).values():New List<AccountsWrapper>();
                        
                        for(AccountsWrapper acctWrapper : accountWrapper.accWrapper){
                            
                            //Account Groups
                            accGrpWrap.YTDSales_LY += acctWrapper.YTDSales_LY;
                            accGrpWrap.YTDSales_TY += acctWrapper.YTDSales_TY;
                            
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
                            
                            Decimal lyDiv = 0;
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
                        Decimal lyDiv = 0;
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
                    Decimal lyDiv = 0;
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
            }else{
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
                        groupCtr++;
                        List<ItemsMP> accDtls = new List<ItemsMP>();
                        AccountsWrapper accountWrapper = new AccountsWrapper();
                        accountWrapper.accWrapper = mapOfAccAllocWithAccountWrapper.containsKey(groupName)?mapOfAccAllocWithAccountWrapper.get(groupName).values():New List<AccountsWrapper>();
                        
                        for(AccountsWrapper acctWrapper : accountWrapper.accWrapper){
                            
                            //Account Groups
                            accGrpWrap.YTDSales_LY += acctWrapper.YTDSales_LY;
                            accGrpWrap.YTDSales_TY += acctWrapper.YTDSales_TY;
                            
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
                            
                            Decimal lyDiv = 0;
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
                        Decimal lyDiv = 0;
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
                    Decimal lyDiv = 0;
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
            Decimal lyDiv = 0;
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
    
    
}