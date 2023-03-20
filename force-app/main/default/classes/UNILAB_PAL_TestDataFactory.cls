/*-------------------------------------------------------------------------------------------
Authors      :   Joan Bautista, Kristjan Mariano, Mark Palacios, Zeus Lopez-Dee, Katherine Roberto, Irene Hermia
Created Date :   03.01.2019
Definition   :   Test Data Factory for UNILAB_PAL Classes
-------------------------------------------------------------------------------------------*/
@isTest
public with sharing class UNILAB_PAL_TestDataFactory {
    //RECORD CREATION
    public static void createUser(){
        User userList = new User();
        userList.FirstName = '';
        userList.LastName = '';
        Map<String, Id> mapProfileId = getProfileId();
        userList.ProfileId = mapProfileId.get('System Administrator');
    }
    
    public static User createUserAdmin(String role,String username,String profile, String channel){
        UserRole chRole = [SELECT Id, Name FROM UserRole WHERE Name = :role];
        Id profileCH = [SELECT Id FROM Profile WHERE Name = :profile].Id;
        
        User userCH = new User(LastName = 'Test UserAdmin',
                               Alias = 'admin',
                               Email = 'UserAdminTEST@unilab.com',
                               FirstName ='FirstName UserAdmin',
                               Username = username,
                               ProfileId = profileCH,
                               TimeZoneSidKey = 'GMT',
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Channel__c = channel,
                               UserRoleId = chRole.Id);
        insert userCH;  
        User newUser = [SELECT Id,UserRoleId FROM User WHERE Id = :userCH.Id];
        return newUser;
    }    

    public static User createUserCMDDev(String role,String username,String profile, String channel){
        UserRole chRole = [SELECT Id, Name FROM UserRole WHERE Name = :role];
        Id profileCH = [SELECT Id FROM Profile WHERE Name = :profile].Id;
        
        User userCH = new User(LastName = 'Test CMD Dev',
                               Alias = 'cmdDev',
                               Email = 'cmdDevTEST@unilab.com',
                               FirstName ='FirstName cmdDev',
                               Username = username,
                               ProfileId = profileCH,
                               TimeZoneSidKey = 'GMT',
                               LanguageLocaleKey = 'en_US',
                               EmailEncodingKey = 'UTF-8',
                               LocaleSidKey = 'en_US',
                               Channel__c = channel,
                               UserRoleId = chRole.Id);
        insert userCH;  
        User newUser = [SELECT Id,UserRoleId FROM User WHERE Id = :userCH.Id];
        return newUser;
    }

    public static void createMultipleGTAccounts(){
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i<100; i++){
            Account acc = new Account();
            acc.Name = 'WATSONS '+i;
            acc.Channel__c = 'General Trade';
            acc.Bill_To_Code__c = '1010101010';
            acc.Team__c = 'GT-Team';
            acc.Grouping__c = 'GT-Group';
            acc.Account_Status__c = 'Active';
            accList.add(acc);
            
        }
        
        insert accList;
    }    
    
    public static void createMultipleGTAccounts1(){
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i<100; i++){
            Account acc = new Account();
            acc.Name = 'WATSONS '+i;
            acc.Channel__c = 'General Trade';
            acc.Bill_To_Code__c = '1010101010';
            acc.Team__c = 'GT-Team'+i;
            acc.Grouping__c = 'GT-Group' + i;
            acc.Account_Status__c = 'Active';
            accList.add(acc);
            
        }
        
        insert accList;
    }
    
    public static void createMultipleKAAccounts(){
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i<100; i++){
            Account acc = new Account();
            acc.Name = 'WATSONS '+i;
            acc.Channel__c = 'Key Accounts';
            acc.Bill_To_Code__c = '1010101010';
            acc.Team__c = 'KA-Team';
            acc.Grouping__c = 'KA-Group';
            acc.Account_Status__c = 'Active';
            accList.add(acc);
            
        }
        
        insert accList;
    }
    
    public static List<Account> createMultipleKAAccountsNoGroup(){
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i<100; i++){
            Account acc = new Account();
            acc.Name = 'WATSONS '+i;
            acc.Channel__c = 'Key Accounts';
            acc.Bill_To_Code__c = '1010101010';
            acc.Team__c = 'KA-Team' +i;
            acc.Grouping__c = 'KA-Group';
            acc.Account_Status__c = 'Active';
            accList.add(acc);
            
        }
        
        insert accList;
        return accList;
    }
    
    public static List<Account> createMultipleKAAccountsNoGroup2(){
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i<100; i++){
            Account acc = new Account();
            acc.Name = 'WATSONS '+i; 
            acc.Channel__c = 'Key Accounts';
            acc.Bill_To_Code__c = '1010101010';
            acc.Team__c = 'KA-Team';
            acc.Grouping__c = 'KA-Group'+i;
            acc.Account_Status__c = 'Active';
            accList.add(acc);
            
        }
        
        insert accList;
        return accList;
    }

	public static void createMultipleMDCAccounts(){
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i<100; i++){
            Account acc = new Account();
            acc.Name = 'WATSONS '+i;
            acc.Channel__c = 'Mercury';
            acc.Bill_To_Code__c = '1010101010';
            acc.Team__c = 'MDC-Team' + i;
            acc.Grouping__c = 'MDC-Group';
            acc.Account_Status__c = 'Active';
            accList.add(acc);
            
        }
        
        insert accList;
    }
    
    public static void createMultipleMDCAccounts2(){
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i<100; i++){
            Account acc = new Account();
            acc.Name = 'WATSONS '+i;
            acc.Channel__c = 'Mercury';
            acc.Bill_To_Code__c = '1010101010';
            acc.Team__c = 'MDC-Team';
            acc.Grouping__c = 'MDC-Group'+i;
            acc.Account_Status__c = 'Active';
            accList.add(acc);
            
        }
        
        insert accList;
    }
    public static void createMultipleMDCAccounts3(){
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i<100; i++){
            Account acc = new Account();
            acc.Name = 'WATSONS '+i;
            acc.Channel__c = 'Mercury';
            acc.Bill_To_Code__c = '1010101010';
            acc.Team__c = 'MDC-Team';
            acc.Grouping__c = 'MDC-Group'+i;
            acc.Account_Status__c = 'Active';
            accList.add(acc);
            
        }
        
        insert accList;
    }
    
    public static void createMultipleMTAccounts(){
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i<100; i++){
            Account acc = new Account();
            acc.Name = 'WATSONS '+i;
            acc.Channel__c = 'Modern Trade';
            acc.Bill_To_Code__c = '1010101010';
            acc.Team__c = 'MT-Team';
            acc.Grouping__c = 'MT-Group';
            acc.Account_Status__c = 'Active';
            accList.add(acc);
            
        }
        
        insert accList;
    }         
    
    public static void createMultipleMTAccounts1(){
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i<100; i++){
            Account acc = new Account();
            acc.Name = 'WATSONS '+i;
            acc.Channel__c = 'Modern Trade';
            acc.Bill_To_Code__c = '1010101010';
            acc.Team__c = 'MT-Team' +i;
            acc.Grouping__c = 'MT-Group'+i;
            acc.Account_Status__c = 'Active';
            accList.add(acc);
            
        }
        
        insert accList;
    }           
     
    public static void createAccounts(){
        List<Account>accountList = new List<Account>();
        List<String> channelList = new List<String>();
        channelList.add('General Trade');
        channelList.add('Key Accounts');
        channelList.add('Modern Trade');
        channelList.add('Mercury');
        for(String channel : channelList){
            Account acc = new Account();
            acc.Name = 'WATSONS '+channel;
            acc.Channel__c = channel;
            acc.Bill_To_Code__c = '1010101010';
            acc.Account_Status__c = 'Active';
            if(channel == 'Key Accounts'){
                acc.Team__c = 'SOUTH STAR GROUP';
                acc.Account_Group__c = 'SOUTH STAR';
            }else if(channel == 'General Trade'){
                acc.Team__c = 'NC Luzon Dist';
                acc.Account_Group__c = 'RKT MARKETING';
            }else if(channel == 'Modern Trade'){
                acc.Team__c = 'SM Group';
                acc.Account_Group__c = 'SVI';
            }else{
                acc.Team__c = 'MDC';
                acc.Account_Group__c = 'MDC';
            }
            accountList.add(acc);
        }
        insert accountList;
    }
    
    public static void createPromoAndAllocation(){
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        
        insert promoRecord;
        createAllocations(promoRecord);
        
    }
    
    public static void createGenerateColumnCustomSetting(){
        PAL_Generate_Columns__c columns = new PAL_Generate_Columns__c();
        columns.Name = 'System Admin';
        columns.ACCOUNT_NAME__c = true;
        columns.AVE_GROSS__c = true;
        columns.AVE_QTY__c = true;
        columns.COMPUTED_ALLOCATION__c = true;
        columns.FINAL__c = true;
        columns.GROWTH__c = true;
        columns.MANUAL__c = true;
        columns.STATUS__c = true;
        columns.YTDSALES_LY__c = true;
        columns.YTDSALES_TY__c = true;
        Map<String, Id> mapProfileId = getProfileId();
        columns.SetupOwnerId = mapProfileId.get('System Administrator');
        
        insert columns;
    }
    
    public static void createColumnHeader(){
        List<PAL_Column_Header__c> colHeaderList = new List<PAL_Column_Header__c>();
        for(Integer i =0; i<10; i++){
            if(i == 0){
                PAL_Column_Header__c colHeader = new PAL_Column_Header__c();
                colHeader.Column_Field_Name__c = 'ACCOUNT_NAME__c';
                colHeader.Column_Name__c = 'ACCOUNT NAME';
                colHeader.Column_Type__c = 'string';
                colHeader.Name = 'Header1';
                colHeaderList.add(colHeader);
            }else if(i == 1){
                PAL_Column_Header__c colHeader = new PAL_Column_Header__c();
                colHeader.Column_Field_Name__c = 'YTDSALES_TY__c';
                colHeader.Column_Name__c = 'YTD SALES TY';
                colHeader.Column_Type__c = 'numeric';
                colHeader.Name = 'Header2';
                colHeaderList.add(colHeader);
            }else if(i == 2){
                PAL_Column_Header__c colHeader = new PAL_Column_Header__c();
                colHeader.Column_Field_Name__c = 'YTDSALES_LY__c';
                colHeader.Column_Name__c = 'YTD SALES LY';
                colHeader.Column_Type__c = 'numeric';
                colHeader.Name = 'Header3';
                colHeaderList.add(colHeader);
            }else if(i == 3){
                PAL_Column_Header__c colHeader = new PAL_Column_Header__c();
                colHeader.Column_Field_Name__c = 'AVE_QTY__c';
                colHeader.Column_Name__c = 'AVE QTY';
                colHeader.Column_Type__c = 'numeric';
                colHeader.Name = 'Header4';
                colHeaderList.add(colHeader);
            }else if(i == 4){
                PAL_Column_Header__c colHeader = new PAL_Column_Header__c();
                colHeader.Column_Field_Name__c = 'AVE_GROSS__c';
                colHeader.Column_Name__c = 'AVE GROSS';
                colHeader.Column_Type__c = 'numeric';
                colHeader.Name = 'Header5';
                colHeaderList.add(colHeader);
            }else if(i == 5){
                PAL_Column_Header__c colHeader = new PAL_Column_Header__c();
                colHeader.Column_Field_Name__c = 'GROWTH__c';
                colHeader.Column_Name__c = '% GROWTH';
                colHeader.Column_Type__c = 'numeric';
                colHeader.Name = 'Header6';
                colHeaderList.add(colHeader);
            }else if(i == 6){
                PAL_Column_Header__c colHeader = new PAL_Column_Header__c();
                colHeader.Column_Field_Name__c = 'COMPUTED_ALLOCATION';
                colHeader.Column_Name__c = 'COMPUTED ALLOCATION';
                colHeader.Column_Type__c = 'numeric';
                colHeader.Name = 'Header7';
                colHeaderList.add(colHeader);
            }else if(i == 7){
                PAL_Column_Header__c colHeader = new PAL_Column_Header__c();
                colHeader.Column_Field_Name__c = 'MANUAL__c';
                colHeader.Column_Name__c = 'MANUAL';
                colHeader.Column_Type__c = 'numeric';
                colHeader.Name = 'Header8';
                colHeaderList.add(colHeader);
            }else if(i == 8){
                PAL_Column_Header__c colHeader = new PAL_Column_Header__c();
                colHeader.Column_Field_Name__c = 'FINAL__c';
                colHeader.Column_Name__c = 'FINAL';
                colHeader.Column_Type__c = 'numeric';
                colHeader.Name = 'Header9';
                colHeaderList.add(colHeader);
            }else if(i == 9){
                PAL_Column_Header__c colHeader = new PAL_Column_Header__c();
                colHeader.Column_Field_Name__c = 'STATUS__c';
                colHeader.Column_Name__c = 'STATUS';
                colHeader.Column_Type__c = 'string';
                colHeader.Name = 'Header10';
                colHeaderList.add(colHeader);
            }
            
        }
        
        insert colHeaderList;
        
        
    }
    
    public static void createAllocations(Promo__c promoRecord){
        List <Allocation__c> allocList = new List<Allocation__c>();
        List<String> channelList = new List<String>();
        channelList.add('General Trade');
        channelList.add('Key Accounts');
        channelList.add('Modern Trade');
        channelList.add('Mercury');
        for(Integer i = 0 ; i<4; i++){
            Allocation__c alloc = new Allocation__c();
            alloc.Allocation_Volume__c = 35000;
            alloc.Start_Date__c = Date.today();
            alloc.End_Date__c = Date.today()+30;
            if(i == 1){
                alloc.Sell_in__c = false;
                alloc.Sell_out__c = true;
                alloc.Sell_out_Data_Type__c = 'P3';
            }else{
                alloc.Sell_in__c = true;
                alloc.Sell_out__c = false;
                alloc.Sell_in_Data_Type__c = 'P3';
            }
            alloc.Promo__c = promoRecord.Id;
            alloc.Channel__c = channelList[i];
            allocList.add(alloc);
        }
        
        insert allocList;
    }
    
    //Zeus 6/14/2019
    public static void createPromoTrigger(){
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        
        insert promoRecord;
        
        List <Allocation__c> allocList = new List<Allocation__c>();
        
        Allocation__c alloc = new Allocation__c();
        alloc.Allocation_Volume__c = 35000;
        alloc.Start_Date__c = Date.today();
        alloc.End_Date__c = Date.today()+30;
        alloc.Promo__c = promoRecord.Id;
        alloc.Channel__c = 'Modern Trade';
        alloc.Status__c = 'Finalized';
        allocList.add(alloc);
        
        insert allocList;
        
        promoRecord.Status__c = 'Implemented';
        
        update promoRecord;
        
    }
    
    //Zeus 6/14/2019 
    //Updated by KC 06/19/2019
	public static void createMDCAccAllocTrigger(List<Account> accList){
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        
        insert promoRecord;
        
        List <Allocation__c> allocList = new List<Allocation__c>();
        
        Allocation__c alloc = new Allocation__c();
        alloc.Allocation_Volume__c = 35000;
        alloc.Start_Date__c = Date.today();
        alloc.End_Date__c = Date.today()+30;
        alloc.Promo__c = promoRecord.Id;
        alloc.Channel__c = 'Mercury';
        alloc.Status__c = 'Finalized';
        //alloc.Created_From_API__c;
        allocList.add(alloc);
        
        insert allocList;
        
        Promo__c promoTest = [SELECT Id FROM Promo__c];
        
        promoTest.Status__c = 'Implemented';
        
        update promoRecord;
        
        List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c> ();
        
        for(Account acc:accList){
            if(acc.Channel__c == alloc.Channel__c){
                Account_Allocation__c accAlloc = new Account_Allocation__c();	
                accAlloc.Allocation__c = alloc.Id;
                accAlloc.Account__c = acc.Id;
                accAlloc.Ave_Gross_Sales__c = 1000;
                accAlloc.Allocation_Volume__c = 300;
                accAlloc.Ave_Qty__c = 12;
                accAlloc.Manual__c = 0;
                accAlloc.Final_Allocation__c = 300;
                accAlloc.Computed_Allocation__c = 300;
                accAlloc.Business_Share__c = 0.30;
                accAlloc.YTDSales_TY__c = 3200;
                accAlloc.YTDSales_LY__c = 2200;
                accAlloc.Status__c = 'Finalized';
                
                accAllocList.add(accAlloc);
            }
        }
        
        insert accAllocList;
        
    }
    
    public static void createAccAllocTrigger(List<Account> accList){
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        
        insert promoRecord;
        
        List <Allocation__c> allocList = new List<Allocation__c>();
        
        Allocation__c alloc = new Allocation__c();
        alloc.Allocation_Volume__c = 35000;
        alloc.Start_Date__c = Date.today();
        alloc.End_Date__c = Date.today()+30;
        alloc.Promo__c = promoRecord.Id;
        alloc.Channel__c = 'Modern Trade';
        alloc.Status__c = 'Finalized';
        //alloc.Created_From_API__c;
        allocList.add(alloc);
        
        insert allocList;
        
        Promo__c promoTest = [SELECT Id FROM Promo__c];
        
        promoTest.Status__c = 'Implemented';
        
        update promoRecord;
        
        List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c> ();
        
        for(Account acc:accList){
            if(acc.Channel__c == alloc.Channel__c){
                Account_Allocation__c accAlloc = new Account_Allocation__c();	
                accAlloc.Allocation__c = alloc.Id;
                accAlloc.Account__c = acc.Id;
                accAlloc.Ave_Gross_Sales__c = 1000;
                accAlloc.Allocation_Volume__c = 300;
                accAlloc.Ave_Qty__c = 12;
                accAlloc.Manual__c = 0;
                accAlloc.Final_Allocation__c = 300;
                accAlloc.Computed_Allocation__c = 300;
                accAlloc.Business_Share__c = 0.30;
                accAlloc.YTDSales_TY__c = 3200;
                accAlloc.YTDSales_LY__c = 2200;
                accAlloc.Status__c = 'Finalized';
                
                accAllocList.add(accAlloc);
            }
        }
        
        insert accAllocList;
        
    }
    
    //Zeus 07/02/2019
    public static void createAccPostpone(){
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        
        insert promoRecord;
        
        List <Allocation__c> allocList = new List<Allocation__c>();
        
        Allocation__c alloc = new Allocation__c();
        alloc.Allocation_Volume__c = 35000;
        alloc.Start_Date__c = Date.today();
        alloc.End_Date__c = Date.today()+30;
        alloc.Promo__c = promoRecord.Id;
        alloc.Channel__c = 'Modern Trade';
        alloc.Status__c = 'Finalized';
        allocList.add(alloc);
        
        insert allocList;
        
    }
    
    //Zeus 07/02/2019
    public static void createAccPostponeNegative(){
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        
        insert promoRecord;
        
        List <Allocation__c> allocList = new List<Allocation__c>();
        
        Allocation__c alloc = new Allocation__c();
        alloc.Allocation_Volume__c = 35000;
        alloc.Start_Date__c = Date.today();
        alloc.End_Date__c = Date.today()+30;
        alloc.Promo__c = promoRecord.Id;
        alloc.Channel__c = 'Modern Trade';
        alloc.Status__c = 'Draft';
        allocList.add(alloc);
        
        insert allocList;
        
    }
    
    public static void createAccountAllocation(List<Allocation__c> allocList, List<Account> accList){
        List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c> ();
        for(Allocation__c alloc:allocList){
            for(Account acc:accList){
                if(acc.Channel__c == alloc.Channel__c){
                    Account_Allocation__c accAlloc = new Account_Allocation__c();	
                    accAlloc.Allocation__c = alloc.Id;
                    accAlloc.Account__c = acc.Id;
                    accAlloc.Ave_Gross_Sales__c = 1000;
                    accAlloc.Allocation_Volume__c = 300;
                    accAlloc.Ave_Qty__c = 12;
                    accAlloc.Manual__c = 0;
                    accAlloc.Final_Allocation__c = 300;
                    accAlloc.Computed_Allocation__c = 300;
                    accAlloc.Business_Share__c = 0.30;
                    accAlloc.YTDSales_TY__c = 3200;
                    accAlloc.YTDSales_LY__c = 2200;
                    accAlloc.Status__c = 'Not Concurred';
                    
                    accAllocList.add(accAlloc);
                }
            }
        }
        insert accAllocList;
    }
    
    public static void createManualAccountAllocation(List<Allocation__c> alloc, List<Account> acc){

        Account_Allocation__c accAlloc = new Account_Allocation__c();
        accAlloc.Allocation__c = alloc[0].Id;
        accAlloc.Account__c = acc[0].Id;
        accAlloc.Ave_Gross_Sales__c = 1000;
        accAlloc.Allocation_Volume__c = 300;
        accAlloc.Ave_Qty__c = 12;
        accAlloc.Manual__c = 0;
        accAlloc.Final_Allocation__c = 300;
        accAlloc.Computed_Allocation__c = 300;
        accAlloc.Business_Share__c = 0.30;
        accAlloc.YTDSales_TY__c = 0;
        accAlloc.YTDSales_LY__c = 0;
        accAlloc.Status__c = 'Not Concurred';
        
        insert accAlloc;

    }
    
    //USED FOR Batch Apex Test
    public static void createAccountForBatch(){
        List<Account>accountList = new List<Account>();
        List<String> channelList = new List<String>();
        channelList.add('General Trade');
        channelList.add('Key Accounts');
        channelList.add('Modern Trade');
        channelList.add('Mercury');
        for(String channel : channelList){
            for(Integer i=0;i<20;i++){
                Account acc = new Account();
                acc.Name = 'Sample Account '+i;
                acc.Channel__c = channel;
                acc.Bill_To_Code__c = '1010101010';
                if(channel == 'Key Accounts'){
                    acc.Team__c = 'SOUTH STAR GROUP';
                    acc.Grouping__c = 'SOUTH STAR';
                    acc.Account_Group__c = 'SOUTH STAR';
                }else if(channel == 'General Trade'){
                    acc.Team__c = 'NC Luzon Dist';
                    acc.Grouping__c = 'RKT MARKETING';
                    acc.Account_Group__c = 'RKT MARKETING';
                }else if(channel == 'Modern Trade'){
                    acc.Team__c = 'SM Group';
                    acc.Grouping__c = 'SVI';
                    acc.Account_Group__c = 'SVI';
                }else{
                    acc.Team__c = 'MDC';
                    acc.Grouping__c = 'MDC';
                    acc.Account_Group__c = 'MDC';
                }
                accountList.add(acc);
            }
        }
        insert accountList;
    }
    
   
    public static void createKAAccountRecords(){

        List<Account>accountList = new List<Account>();
		
            for(Integer i=0;i<25;i++){
                Account acc = new Account();
                acc.Name = 'Sample Account '+i;
                acc.Channel__c = 'Key Accounts';
                acc.Bill_To_Code__c = '1010101011';
                    if(i<5){
						acc.Team__c = 'VisMin_KA';
						acc.Grouping__c = 'CECILES';
						acc.Account_Group__c = 'CECILES';
                    }else if(i<10){
                        acc.Team__c = 'VisMin_KA';
                   	    acc.Grouping__c = 'AMESCO';
                        acc.Account_Group__c = 'AMESCO';
                    }else if(i<15){
                        acc.Team__c = 'VisMin_KA';
                   	    acc.Grouping__c = 'AMESCO';
                        acc.Account_Group__c = null;
                    }else if(i<20){
						acc.Team__c = 'GMA_And_Luzon_KA';
                   	    acc.Grouping__c = 'ST. JOSEPH';
                        acc.Account_Group__c = 'ST. JOSEPH';					
					}else{
						acc.Team__c = '';
                   	    acc.Grouping__c = 'ULTRAMART';
                        acc.Account_Group__c = 'ULTRAMART';
					}
					
                accountList.add(acc);
            } 
			
        insert accountList;
 }
    
    public static void createMDCAccountRecords(){

        List<Account>accountList = new List<Account>();
		
            for(Integer i=0;i<20;i++){
                Account acc = new Account();
                acc.Name = 'Sample Account '+i;
                acc.Channel__c = 'Mercury';
                acc.Bill_To_Code__c = '1010101010';
                    if(i<5){
						acc.Team__c = 'MDC';
						acc.Grouping__c = 'MDC';
						acc.Account_Group__c = 'MDC';
                    }else if(i<10){
                        acc.Team__c = 'GMA';
                   	    acc.Grouping__c = 'MDC';
                        acc.Account_Group__c = 'MDC';
					}else if(i<15){
                        acc.Team__c = 'NORTH LUZON	';
                   	    acc.Grouping__c = 'MDC';
                        acc.Account_Group__c = null;	
                    }else if(i<20){
                        acc.Team__c = '';
                   	    acc.Grouping__c = 'MDC';
                        acc.Account_Group__c = 'MDC';
					}
					
                accountList.add(acc);
            } 
			
        insert accountList;
    }
    
    public static void createGTAccountRecords(){

        List<Account>accountList = new List<Account>();
		
            for(Integer i=0;i<25;i++){
                Account acc = new Account();
                acc.Name = 'Sample Account '+i;
                acc.Channel__c = 'General Trade';
                acc.Bill_To_Code__c = '1010101012';
                    if(i<5){
						acc.Team__c = 'NC Luzon Dist';
						acc.Grouping__c = 'PROS MARKETING';
						acc.Account_Group__c = 'PROS MARKETING';
                    }else if(i<10){
                        acc.Team__c = 'NC Luzon Dist';
                   	    acc.Grouping__c = 'RKT MARKETING';
                        acc.Account_Group__c = 'RKT MARKETING';
                    }else if(i<15){
                        acc.Team__c = 'NC Luzon Dist';
                   	    acc.Grouping__c = null;
                        acc.Account_Group__c = null;
                    }else if(i<20){
						acc.Team__c = 'GMA & S Luzon Dist';
                   	    acc.Grouping__c = 'Milaor Trading Corporation';
                        acc.Account_Group__c = 'MTC';					
					}else{
						acc.Team__c = '';
                   	    acc.Grouping__c = 'Magna Gold Pharma, Inc.';
                        acc.Account_Group__c = 'MAGNA GOLD PHARMA';
					}
					
                accountList.add(acc);
            } 
			
        insert accountList;
    }
    
    public static void createMTAccountRecords(){

        List<Account>accountList = new List<Account>();
		
            for(Integer i=0;i<25;i++){
                Account acc = new Account();
                acc.Name = 'Sample Account '+i;
                acc.Channel__c = 'Modern Trade';
                acc.Bill_To_Code__c = '1010101013';
                    if(i<5){
						acc.Team__c = 'Modern Trade Team 2';
						acc.Grouping__c = 'SHOPWISE';
						acc.Account_Group__c = 'SHOPWISE';
                    }else if(i<10){
                        acc.Team__c = 'Modern Trade Team 2';
                   	    acc.Grouping__c = 'WELLCOME';
                        acc.Account_Group__c = 'WELLCOME';
                    }else if(i<15){
                        acc.Team__c = 'Modern Trade Team 2';
                   	    acc.Grouping__c = '';
                        acc.Account_Group__c = null;
                    }else if(i<20){
						acc.Team__c = 'Modern Trade Team 1';
                   	    acc.Grouping__c = 'PUREGOLD';
                        acc.Account_Group__c = 'PUREGOLD';					
					}else{
						acc.Team__c = '';
                   	    acc.Grouping__c = 'RUSTANS';
                        acc.Account_Group__c = 'RUSTANS';
					}
					
                accountList.add(acc);
            } 
			
        insert accountList;
    }
    
    
    

    public static List<Temporary_Allocation__c> createTempAllocForBatch(String channel, String team, String acctgroup, List<Account> accList){
        List<Temporary_Allocation__c> tempAllocList = new List <Temporary_Allocation__c>();   
        for(Integer i=0;i<accList.size();i++){
            Temporary_Allocation__c tempAlloc = new Temporary_Allocation__c();
            
            tempAlloc.Channel__c = channel;
            tempAlloc.Team__c = team;
            tempAlloc.Account_Group__c = acctgroup;
            tempAlloc.SFA_Internal_ID__c = accList[i].Id;
            tempAlloc.Branch_ID__c = '0080090430';
            tempAlloc.Item_Code__c = '151938';
            tempAlloc.Quantity__c = 100;
            tempAlloc.Amount__c = 1000;
            tempAlloc.Monthly_Supply__c = 0;
            tempAlloc.Period__c = '201812';
            tempAlloc.Measure_Category__c = 'SALES';
            tempAlloc.Measure_Type__c = 'SELLIN';
            tempAlloc.Measure_Level__c = 'P3';
            tempAllocList.add(tempAlloc);
        }
        
        return tempAllocList;
    }
    
    public static List<Temporary_Allocation__c> createTempAllocForGT(String channel, String team, String acctgroup, List<Account> accList){
        List<Temporary_Allocation__c> tempAllocList = new List <Temporary_Allocation__c>();   
        for(Integer i=0;i<accList.size();i++){
            Temporary_Allocation__c tempAlloc = new Temporary_Allocation__c();
            
            tempAlloc.Channel__c = channel;
            tempAlloc.Team__c = team;
            tempAlloc.Account_Group__c = acctgroup;
            tempAlloc.SFA_Internal_ID__c = accList[i].Id;
            tempAlloc.Branch_ID__c = '0080090430';
            tempAlloc.Item_Code__c = '151938';
            tempAlloc.Quantity__c = 100;
            tempAlloc.Amount__c = 1000;
            tempAlloc.Monthly_Supply__c = 0;
            tempAlloc.Period__c = '201812';
            tempAlloc.Measure_Category__c = 'SALES';
            tempAlloc.Measure_Type__c = 'SELLIN';
            tempAlloc.Measure_Level__c = 'P3';
            tempAllocList.add(tempAlloc);
        }
        
        return tempAllocList;
    }

	//Updated by Mark Palacios 6/17/2019 -- Used for UNILAB_PAL_ImplementedEmail_Handler_Test
	public static void createPromoForEmailHandling(){
        List<Promo__c> promoList = new List<Promo__c>();
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        promoList.add(promoRecord);
        insert promoRecord;
        
        List <Allocation__c> allocList = new List<Allocation__c>();
        
        
        
        insert allocList;
        
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Allocation__c.Channel__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry pickListVal : ple) {
            pickListValuesList.add(pickListVal.getLabel());
        }   
        
        for (Promo__c promo : promoList) {
            for(Integer i = 0; i < pickListValuesList.size(); i ++) {
                Allocation__c alloc = new Allocation__c();
                alloc.Allocation_Volume__c = 35000;
                alloc.Start_Date__c = Date.today();
                alloc.End_Date__c = Date.today()+30;
                alloc.Promo__c = promo.Id;
                alloc.Channel__c = pickListValuesList.get(i);
                alloc.Status__c = 'Finalized';
                allocList.add(alloc);
            }
        }
        
        if (allocList.size() > 0) {
            insert allocList;
        }
        List<Account> accList = getAccounts();
        List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
        for(Allocation__c allocRecord:allocList){
            for(Account accRecord:accList){
                if(allocRecord.Channel__c == accRecord.Channel__c){
                    Account_Allocation__c accAllocRecord = new Account_Allocation__c(Allocation__c = allocRecord.Id,
                                                                                     Status__c = 'Not Concurred',
                                                                                     Account__c = accRecord.Id);
                    
                    accAllocList.add(accAllocRecord);
                }
            }
            
        }
        
        insert accAllocList;
    }    

    public static Promo__c getPromoForBatchApexTest(){
        return [SELECT Id FROM Promo__c LIMIT 1];
    }
    
    //updated by KC Roberto 06/13/19
    public static List<Account> getAccounts(){
        List<Account> accList =[SELECT Id , Name, Channel__c FROM Account];
        
        return accList;
    }
    public static List<Account> getGTAccounts(){
        List<Account> accList =[SELECT Id , Channel__c FROM Account WHERE Channel__c = 'General Trade'];
        
        return accList;
    }
    
    public static List<Account> getKAAccounts(){
        List<Account> accList =[SELECT Id , Channel__c FROM Account WHERE Channel__c = 'Key Accounts' AND Grouping__c = 'KA-Group'];
        
        return accList;
    }
    
    public static List<Account> getKAAccountsNoGroup(){
        List<Account> accList =[SELECT Id , Channel__c FROM Account WHERE Channel__c = 'Key Accounts' AND Grouping__c = null];
        
        return accList;
    }
    
    public static List<Account> getMDCAccounts(){
        List<Account> accList =[SELECT Id , Channel__c FROM Account WHERE Channel__c = 'Mercury'];
        
        return accList;
    }
    
    public static List<Account> getMTAccounts(){
        List<Account> accList =[SELECT Id , Channel__c FROM Account WHERE Channel__c = 'Modern Trade'];
        
        return accList;
    }
    
    //updated by KC Roberto 06/13/19
    public static List<Account_Allocation__c> getAccountAllocs(List<Allocation__c> allocList){
        List<Account_Allocation__c> accAllocList = [SELECT Id, Manual__c,Status__c FROM Account_Allocation__c WHERE Allocation__c IN: allocList];
        
        return accAllocList;
    }
     
    public static List<Account_Allocation__c> getManualAccountAllocs(List<Allocation__c> allocList){
        List<Account_Allocation__c> accAllocList = [SELECT Id, Manual__c FROM Account_Allocation__c WHERE Allocation__c IN: allocList AND YTDSales_TY__c = 0
                                                    AND YTDSales_LY__c = 0];
        
        return accAllocList;
    }
    
    //USED FOR Batch Apex
    public static List<Account> getAccountsForBatch(String channel){
        List<Account> accList =[SELECT Id,Channel__c FROM Account WHERE Channel__c =: channel];
        
        return accList;
    }
    
    //Create Promo
    public static void insertProducts() {
        
        List<Product2> newListOfProds = new List<Product2>();
        
        for(Integer i = 0; i<10; i++){
            Product2 productRecord = new Product2(Name='NEOZEP FORTE CPL 4BOX SS PH',
                                                 Item_Code__c='15556'+i,
                                                 Brand_Name__c ='Neozep',
                                                 Sub_Brand_Name__c = 'Neozep Caplet'
                                                );
            
            newListOfProds.add(productRecord);
        }

        insert newListOfProds;
    }
    
    public static void createPromo (List<Product2> listOfProds) {
        Promo__c newPromo = new Promo__c();
        
        newPromo.Promo_Name__c = 'New Promo';
        newPromo.Promo_Type__c = 'Consumer Redemption';
        newPromo.Start_Date__c = Date.today();
        newPromo.End_Date__c = Date.today()+30;
        //newPromo.Brand__c = listOfProds[0].Brand_Name__c;
        newPromo.Reason_for_Cancelation__c = 'Sample Reason';
        insert newPromo;
    }
    
    public static Promo__c getPromos(){
        return [SELECT Id, Name, Promo_Type__c, Start_Date__c, End_Date__c FROM Promo__c].get(0);
    }
    
    public static Promo_Product__c  basePromoProd (Promo__c promoRec) {
         
        Promo_Product__c newBasePromoProd = new Promo_Product__c();
        List<Product2> listOfProds = getProducts();
        
        
        newBasePromoProd.Promo__c = promoRec.Id;
        newBasePromoProd.Product_Type__c = 'Base';
        newBasePromoProd.Product__c = listOfProds[0].Id;
        
        return newBasePromoProd;
    }
    
    public static Promo_Product__c  skuPromoProd (Promo__c promoRec) {
        
        Promo_Product__c newSkuPromoProd = new Promo_Product__c();
        List<Product2> listOfProds = getProducts();
        
        
        newSkuPromoProd.Promo__c = promoRec.Id;
        newSkuPromoProd.Product_Type__c = 'Base';
        newSkuPromoProd.Product__c = listOfProds[1].Id;
        
        return newSkuPromoProd;
    }
    
    //UNILAB_PAL_CONTROLLER TEST DATA
    public static void createSystemAdminUser(){
        Map<String, Id> profileId = getProfileId();
        User userRecord = new User(LastName='Test Last Name',
                                   Alias='TestA',
                                   Email='testemail@test.com',
                                   Username='testuser123@salesAdmin.com',
                                   ProfileId = profileId.get('System Administrator'),
                                   emailencodingkey='UTF-8',
                                   languagelocalekey='en_US',
                                   Channel__c = 'SALESOPS',
                                   localesidkey='en_US',
                                   timezonesidkey='America/Los_Angeles');
        
        insert userRecord;
    }
    
    public static void createColumns(){
        List<PAL_Column_Header__c> columnHeaderList = new List<PAL_Column_Header__c>();
        PAL_Column_Header__c accCol = new PAL_Column_Header__c(Column_Field_Name__c = 'ACCOUNT_NAME__c',
                                                                Column_Name__c = 'ACCOUNT NAME',
                                                                Column_Type__c = 'string',
                                                                Name = 'Header1');
        columnHeaderList.add(accCol);
        PAL_Column_Header__c ytdSalesTY = new PAL_Column_Header__c(Column_Field_Name__c = 'YTDSALES_TY__c',
                                                                Column_Name__c = 'YTDSALES TY',
                                                                Column_Type__c = 'numeric',
                                                                Name = 'Header10');
        columnHeaderList.add(ytdSalesTY);
        PAL_Column_Header__c ytdSalesLY = new PAL_Column_Header__c(Column_Field_Name__c = 'YTDSALES_LY__c',
                                                                Column_Name__c = 'YTDSALES LY',
                                                                Column_Type__c = 'numeric',
                                                                Name = 'Header11');
        columnHeaderList.add(ytdSalesLY);
        PAL_Column_Header__c aveQTY = new PAL_Column_Header__c(Column_Field_Name__c = 'AVE_QTY__c',
                                                                Column_Name__c = 'AVE QTY',
                                                                Column_Type__c = 'numeric',
                                                                Name = 'Header12');
        columnHeaderList.add(aveQTY);
        PAL_Column_Header__c aveGross = new PAL_Column_Header__c(Column_Field_Name__c = 'AVE_GROSS__c',
                                                                Column_Name__c = 'AVE GROSS',
                                                                Column_Type__c = 'numeric',
                                                                Name = 'Header2');
        columnHeaderList.add(aveGross);
        PAL_Column_Header__c growth = new PAL_Column_Header__c(Column_Field_Name__c = 'GROWTH__c',
                                                                Column_Name__c = '% GROWTH',
                                                                Column_Type__c = 'numeric',
                                                                Name = 'Header3');
        columnHeaderList.add(growth);
        PAL_Column_Header__c manual = new PAL_Column_Header__c(Column_Field_Name__c = 'MANUAL__c',
                                                                Column_Name__c = 'MANUAL',
                                                                Column_Type__c = 'numeric',
                                                                Name = 'Header4');
        columnHeaderList.add(manual);
        PAL_Column_Header__c finalValue = new PAL_Column_Header__c(Column_Field_Name__c = 'FINAL__c',
                                                                Column_Name__c = 'FINAL',
                                                                Column_Type__c = 'numeric',
                                                                Name = 'Header5');
        columnHeaderList.add(finalValue);
        
        PAL_Column_Header__c status = new PAL_Column_Header__c(Column_Field_Name__c = 'STATUS__c',
                                                                Column_Name__c = 'STATUS',
                                                                Column_Type__c = 'string',
                                                                Name = 'Header6');
        columnHeaderList.add(status);
        
        PAL_Column_Header__c computedAlloc = new PAL_Column_Header__c(Column_Field_Name__c = 'COMPUTED_ALLOCATION',
                                                                Column_Name__c = 'COMPUTED ALLOCATION',
                                                                Column_Type__c = 'numeric',
                                                                Name = 'Header7');
        columnHeaderList.add(computedAlloc);
        
        PAL_Column_Header__c branchAlloc = new PAL_Column_Header__c(Column_Field_Name__c = 'AllocPerBranch',
                                                                Column_Name__c = 'Branch Allocation',
                                                                Column_Type__c = 'numeric',
                                                                Name = 'Header8');
        columnHeaderList.add(branchAlloc);
        
        PAL_Column_Header__c numberOfAccounts = new PAL_Column_Header__c(Column_Field_Name__c = 'NumberOfAccounts',
                                                                Column_Name__c = '# of Accounts',
                                                                Column_Type__c = 'numeric',
                                                                Name = 'Header9');
        columnHeaderList.add(numberOfAccounts);
        
        insert columnHeaderList;
    }
    
    public static void createGenerateAdminColumns(){
        Map<String, Id> profileId = getProfileId();
        PAL_Generate_Columns__c generateColumns = new PAL_Generate_Columns__c(ACCOUNT_NAME__c = true,
                                                                              YTDSALES_TY__c = true,
                                                                              YTDSALES_LY__c = true,
                                                                              AVE_QTY__c = true,
                                                                              AVE_GROSS__c = true,
                                                                              GROWTH__c = true,
                                                                              MANUAL__c = true,
                                                                              FINAL__c = true,
                                                                              STATUS__c = true,
                                                                              COMPUTED_ALLOCATION__c = true,
                                                                              NumberOfAccounts__c = true,
                                                                              AllocPerBranch__c = true,
                                                                              SetupOwnerId = profileId.get('System Administrator'));
        
        insert generateColumns;
    }
    
    public static void createGenerateGTColumns(){
        Map<String, Id> profileId = getProfileId();
        PAL_Generate_Columns__c generateColumns = new PAL_Generate_Columns__c(ACCOUNT_NAME__c = true,
                                                                              YTDSALES_TY__c = true,
                                                                              YTDSALES_LY__c = true,
                                                                              AVE_QTY__c = true,
                                                                              AVE_GROSS__c = true,
                                                                              GROWTH__c = true,
                                                                              MANUAL__c = true,
                                                                              FINAL__c = true,
                                                                              COMPUTED_ALLOCATION__c = true,
                                                                              NumberOfAccounts__c = true,
                                                                              AllocPerBranch__c = true,
                                                                              SetupOwnerId = profileId.get('GT CDS'));
        
        insert generateColumns;
    }
    
    public static void createGTUser(){
        Map<String, Id> profileId = getProfileId();
        User userRecord = new User(LastName='Test Last Name',
                                   Alias='TestB',
                                   Email='testemail@testGT.com',
                                   Username='testuser123@salesGT.com',
                                   ProfileId = profileId.get('GT CDS'),
                                   Channel__c = 'GT',
                                   emailencodingkey='UTF-8',
                                   languagelocalekey='en_US',
                                   localesidkey='en_US',
                                   timezonesidkey='America/Los_Angeles');
        
        insert userRecord;
    }
    //Change Profile to PMOG
    public static void createPMOGUser(){
        Map<String, Id> profileId = getProfileId();
        User userRecord = new User(LastName='Test Last Name',
                                   Alias='TestB',
                                   Email='testemail@testPMOG.com',
                                   Username='testuser123@salesPMOG.com',
                                   ProfileId = profileId.get('CMD Lead'),
                                   emailencodingkey='UTF-8',
                                   languagelocalekey='en_US',
                                   localesidkey='en_US',
                                   timezonesidkey='America/Los_Angeles');
        
        insert userRecord;
    }
    
    public static void createGTCMDDevUser(){
        Map<String, Id> profileId = getProfileId();
        User userRecord = new User(LastName='Test Last Name',
                                   Alias='TestB',
                                   Email='testemail@testGTCMDDev.com',
                                   Username='testuser123@salesGTCMDDev.com',
                                   ProfileId = profileId.get('GT CMD Developer'),
                                   emailencodingkey='UTF-8',
                                   Channel__c = 'GT',
                                   languagelocalekey='en_US',
                                   localesidkey='en_US',
                                   timezonesidkey='America/Los_Angeles');
        
        insert userRecord;
    }
    
    public static void createKACMDDevUser(){
        Map<String, Id> profileId = getProfileId();
        User userRecord = new User(LastName='Test Last Name',
                                   Alias='TestB',
                                   Email='testemail@testKACMDDev.com',
                                   Username='testuser123@salesKACMDDev.com',
                                   ProfileId = profileId.get('KA CMD Developer'),
                                   emailencodingkey='UTF-8',
                                   Channel__c = 'KA',
                                   languagelocalekey='en_US',
                                   localesidkey='en_US',
                                   timezonesidkey='America/Los_Angeles');
        
        insert userRecord;
    }
    
    public static void createMTCMDDevUser(){
        Map<String, Id> profileId = getProfileId();
        User userRecord = new User(LastName='Test Last Name',
                                   Alias='TestB',
                                   Email='testemail@testMTCMDDev.com',
                                   Username='testuser123@salesMTCMDDev.com',
                                   ProfileId = profileId.get('MT CMD Developer'),
                                   emailencodingkey='UTF-8',
                                   Channel__c = 'MT',
                                   languagelocalekey='en_US',
                                   localesidkey='en_US',
                                   timezonesidkey='America/Los_Angeles');
        
        insert userRecord;
    }
    
    public static void createMDCCMDDevUser(){
        Map<String, Id> profileId = getProfileId();
        User userRecord = new User(LastName='Test Last Name',
                                   Alias='TestB',
                                   Email='testemail@testMDCCMDDev.com',
                                   Username='testuser123@salesMDCCMDDev.com',
                                   ProfileId = profileId.get('MDC CMD Developer'),
                                   emailencodingkey='UTF-8',
                                   Channel__c = 'MDC',
                                   languagelocalekey='en_US',
                                   localesidkey='en_US',
                                   timezonesidkey='America/Los_Angeles');
        
        insert userRecord;
    }
    
    public static User getAdminUser(){
        Map<String, Id> mapProfileId = getProfileId();
        return [SELECT Id FROM User WHERE Channel__c = 'SALESOPS' LIMIT 1];
    }
    
    public static User getGTUser(){
        return [SELECT Id, Email FROM User WHERE Channel__c = 'GT' LIMIT 1];
    }
    
    public static void createKAUser(){
        Map<String, Id> profileId = getProfileId();
        User userRecord = new User(LastName='Test Last Name',
                                   Alias='TestC',
                                   Email='testemail@testKA.com',
                                   Username='testuser123@salesKA.com',
                                   ProfileId = profileId.get('KA CDS'),
                                   Channel__c = 'LKA',
                                   emailencodingkey='UTF-8',
                                   languagelocalekey='en_US',
                                   localesidkey='en_US',
                                   timezonesidkey='America/Los_Angeles');
        
        insert userRecord;
    }
    
    public static User getKAUser(){
        Map<String, Id> profileId = getProfileId();
        return [SELECT Id, Email FROM User WHERE Channel__c = 'LKA' LIMIT 1];
    }
    
    public static void createMTUser(){
        Map<String, Id> profileId = getProfileId();
        User userRecord = new User(LastName='Test Last Name',
                                   Alias='TestD',
                                   Email='testemail@testMT.com',
                                   Username='testuser123@salesMT.com',
                                   ProfileId = profileId.get('MT CDS'),
                                   Channel__c = 'MT',
                                   emailencodingkey='UTF-8',
                                   languagelocalekey='en_US',
                                   localesidkey='en_US',
                                   timezonesidkey='America/Los_Angeles');
        
        insert userRecord;
    }
    
    public static User getMTUser(){
        Map<String, Id> profileId = getProfileId();
        return [SELECT Id, Email FROM User WHERE Channel__c = 'MT' LIMIT 1];
    }
    
    public static void createMDCUser(){
        Map<String, Id> profileId = getProfileId();
        User userRecord = new User(LastName='Test Last Name',
                                   Alias='TestE',
                                   Email='testemail@testMDC.com',
                                   Username='testuser123@salesMDC.com',
                                   ProfileId = profileId.get('MDC CDS'),
                                   Channel__c = 'MDC',
                                   emailencodingkey='UTF-8',
                                   languagelocalekey='en_US',
                                   localesidkey='en_US',
                                   timezonesidkey='America/Los_Angeles');
        
        insert userRecord;
    }
    
    public static User getMDCUser(){
        Map<String, Id> profileId = getProfileId();
        return [SELECT Id, Email FROM User WHERE Channel__c = 'MDC' LIMIT 1];
    }
    
    public static void createProducts() {
        
        List<Product2> newListOfProds = new List<Product2>();
        
        for(Integer i = 0; i<10; i++){
            Product2 productRecord = new Product2(Name='NEOZEP FORTE CPL 4BOX SS PH',
                                                 Item_Code__c='15556'+i,
                                                 Brand_Name__c ='Neozep',
                                                 Sub_Brand_Name__c = 'Neozep Caplet'
                                                );
            
            newListOfProds.add(productRecord);
        }

        insert newListOfProds;
    }
    
    public static void createPromoProduct(Promo__c promoRecord, Product2 productRecord){
        
        Promo_Product__c promoProductRecord = new Promo_Product__c(Product__c = productRecord.Id,
                                                                   Promo__c = promoRecord.Id,
                                                                   Product_Type__c = 'Base');
        
        insert promoProductRecord;
        
    }
    
    public static Account createAccount(){
        User userRecord = [SELECT Id FROM USER WHERE Username = 'testuser123@salesMDC.com'].get(0);
        Account accRecord = new Account(Name = 'Test Account',
                                        Account_Code__c = 'TA-001',
                                        Account_Group__c = 'GT',
                                        Account_Status__c = 'Active',
                                        Channel__c = 'GT',
                                        Team__c = 'GMA',
                                        OwnerId = userRecord.Id,
                                        Bill_To_Code__c = '0000000000');
        
        insert accRecord;
        
        return accRecord;
    }
    
    public static Promo__c createPromo(){
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        
        insert promoRecord;       
        return promoRecord;
    }
    
    public static Promo__c createSellOutPromo(){
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'SellOut Promo 1',
                                            Promo_Type__c = 'GC Promo');
        
        insert promoRecord;       
        return promoRecord;
    }
    
    public static void createErrorPromo(){
        
        
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        insert promoRecord;
    }
    
    public static List<Promo__c> getPromo(){
        return [SELECT Id FROM Promo__c];
    }
    
    public static List<Product2> getProducts(){
        return [SELECT Id, Name, Brand_Name__c, Sub_Brand_Name__c FROM Product2];
    }
    
    public static List<Promo_Product__c> getPromoProd(){
        return [SELECT Id FROM Promo_Product__c];
    }
    
    public static List<SelectOption> getChannels(){
        List<SelectOption> picklistValues = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Allocation__c.Channel__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            picklistValues.add(new SelectOption(f.getLabel(), f.getValue()));
        }  
        
        return picklistValues;
    }
    
    public static void updatePromoStatus(Id promoId){
        Promo__c promoRecord = [SELECT Id, Status__c FROM Promo__c WHERE Id =: promoId];
        
        promoRecord.Status__c = 'Implemented';
        
        update promoRecord;
    }
    
    public static Allocation__c createSingleAllocationForProcess(){
        Promo__c promoRecord = getPromo().get(0);
         
        Allocation__c allocRecord = new Allocation__c(Channel__c = 'Modern Trade',
                                                      Account_Status__c = 'Active',
                                                      Status__c = 'Draft',
                                                      Start_Date__c = Date.today(),
                                                      Sell_in__c = true,
                                                      Sell_out__c = false,
                                                      Ending_Inventory__c = false,
                                                      Sell_out_Data_Type__c  = 'P3',
                                                      Promo__c = promoRecord.Id,
                                                      Frequency_of_Visit__c = '2X',
                                                      Along_National_Highway_Residential__c = 'All',
                                                      Store_Physical_Size__c = '100',
                                                      Store_Format__c = 'All',
                                                      Self_Service_Floor_Area__c = 100.00,
                                                      RPS_Account_Class__c = 'All',
                                                      Near_a_Generics_Drugstore__c = true,
                                                      Near_or_Within_a_Supermarket__c = true,
                                                      Mall_Based__c = true,
                                                      Near_Transport_Terminal__c = true,
                                                      Near_a_Pre_School__c = true,
                                                      Near_a_University_College__c = true,
                                                      Near_Other_Drugstores__c = true,
                                                      Fronting_Near_Hospital__c = true,
                                                      Near_Clinic__c = true,
                                                      Near_Public_Market__c = true,
                                                      Near_Offices__c = true,
                                                      Near_a_Grade_High_School__c = true,
                                                      Near_a_Call_Center__c = true,
                                                      With_TPA_Coverage__c = true,
                                                      With_Lamp_Coverage__c = true);
        
        insert allocRecord;
        
        return allocRecord;
        
    }
    
    public static List<Allocation__c> createAllocRecords(Id promoId){
        List<Allocation__c> allocList = new List<Allocation__c>();
        List<SelectOption> picklistValues = getChannels();
        for(SelectOption option:picklistValues){
            String channel = option.getValue();
            if(channel == 'General Trade'){
                Allocation__c allocRecord = new Allocation__c(Channel__c = option.getValue(),
                                                              Account_Status__c = 'Active',
                                                              Status__c = 'Draft',
                                                              Start_Date__c = Date.today(),
                                                              Sell_in__c = true,
                                                              Sell_out__c = false,
                                                              Ending_Inventory__c = false,
                                                              Sell_out_Data_Type__c  = 'P3',
                                                              Promo__c = promoId,
                                                              Frequency_of_Visit__c = '2X',
                                                              Along_National_Highway_Residential__c = 'All',
                                                              Store_Physical_Size__c = '100',
                                                              Store_Format__c = 'All',
                                                              Self_Service_Floor_Area__c = 100.00,
                                                              RPS_Account_Class__c = 'All',
                                                              Near_a_Generics_Drugstore__c = true,
                                                              Near_or_Within_a_Supermarket__c = true,
                                                              Mall_Based__c = true,
                                                              Near_Transport_Terminal__c = true,
                                                              Near_a_Pre_School__c = true,
                                                              Near_a_University_College__c = true,
                                                              Near_Other_Drugstores__c = true,
                                                              Fronting_Near_Hospital__c = true,
                                                              Near_Clinic__c = true,
                                                              Near_Public_Market__c = true,
                                                              Near_Offices__c = true,
                                                              Near_a_Grade_High_School__c = true,
                                                              Near_a_Call_Center__c = true,
                                                              With_TPA_Coverage__c = true,
                                                              With_Lamp_Coverage__c = true);
                allocList.add(allocRecord);
            }else if(channel == 'Mercury'){
                Allocation__c allocRecord = new Allocation__c(Channel__c = option.getValue(),
                                                              Account_Status__c = 'Active',
                                                              Status__c = 'Draft',
                                                              Start_Date__c = Date.today(),
                                                              Sell_in__c = false,
                                                              Sell_out__c = true,
                                                              Ending_Inventory__c = false,
                                                              Sell_out_Data_Type__c  = 'P3',
                                                              Promo__c = promoId,
                                                              Frequency_of_Visit__c = '2X',
                                                              Along_National_Highway_Residential__c = 'All',
                                                              Store_Physical_Size__c = '100',
                                                              Store_Format__c = 'All',
                                                              Self_Service_Floor_Area__c = 100.00,
                                                              RPS_Account_Class__c = 'All',
                                                              Near_a_Generics_Drugstore__c = true,
                                                              Near_or_Within_a_Supermarket__c = true,
                                                              Mall_Based__c = true,
                                                              Near_Transport_Terminal__c = true,
                                                              Near_a_Pre_School__c = true,
                                                              Near_a_University_College__c = true,
                                                              Near_Other_Drugstores__c = true,
                                                              Fronting_Near_Hospital__c = true,
                                                              Near_Clinic__c = true,
                                                              Near_Public_Market__c = true,
                                                              Near_Offices__c = true,
                                                              Near_a_Grade_High_School__c = true,
                                                              Near_a_Call_Center__c = true,
                                                              With_TPA_Coverage__c = true,
                                                              With_Lamp_Coverage__c = true);
                allocList.add(allocRecord);
            }else if(channel == 'Modern Trade'){
                Allocation__c allocRecord = new Allocation__c(Channel__c = option.getValue(),
                                                              Account_Status__c = 'Active',
                                                              Status__c = 'Draft',
                                                              Sell_in__c = false,
                                                              Sell_out__c = false,
                                                              Ending_Inventory__c = true,
                                                              Sell_out_Data_Type__c  = 'P3',
                                                              Promo__c = promoId,
                                                              Frequency_of_Visit__c = '2X',
                                                              Along_National_Highway_Residential__c = 'All',
                                                              Store_Physical_Size__c = '100',
                                                              Store_Format__c = 'All',
                                                              Self_Service_Floor_Area__c = 100.00,
                                                              RPS_Account_Class__c = 'All',
                                                              Near_a_Generics_Drugstore__c = true,
                                                              Near_or_Within_a_Supermarket__c = true,
                                                              Mall_Based__c = true,
                                                              Near_Transport_Terminal__c = true,
                                                              Near_a_Pre_School__c = true,
                                                              Near_a_University_College__c = true,
                                                              Near_Other_Drugstores__c = true,
                                                              Fronting_Near_Hospital__c = true,
                                                              Near_Clinic__c = true,
                                                              Near_Public_Market__c = true,
                                                              Near_Offices__c = true,
                                                              Near_a_Grade_High_School__c = true,
                                                              Near_a_Call_Center__c = true,
                                                              With_TPA_Coverage__c = true,
                                                              With_Lamp_Coverage__c = true);
                allocList.add(allocRecord);
                
            }else if(channel == 'Key Accounts'){
                Allocation__c allocRecord = new Allocation__c(Channel__c = option.getValue(),
                                                              Account_Status__c = 'Active',
                                                              Status__c = 'Draft',
                                                              Start_Date__c = Date.today(),
                                                              Sell_in__c = false,
                                                              Sell_out__c = true,
                                                              Ending_Inventory__c = false,
                                                              Sell_out_Data_Type__c  = 'P3',
                                                              Promo__c = promoId,
                                                              Frequency_of_Visit__c = '2X',
                                                              Along_National_Highway_Residential__c = 'All',
                                                              Store_Physical_Size__c = '100',
                                                              Store_Format__c = 'All',
                                                              Self_Service_Floor_Area__c = 100.00,
                                                              RPS_Account_Class__c = 'All',
                                                              Near_a_Generics_Drugstore__c = true,
                                                              Near_or_Within_a_Supermarket__c = true,
                                                              Mall_Based__c = true,
                                                              Near_Transport_Terminal__c = true,
                                                              Near_a_Pre_School__c = true,
                                                              Near_a_University_College__c = true,
                                                              Near_Other_Drugstores__c = true,
                                                              Fronting_Near_Hospital__c = true,
                                                              Near_Clinic__c = true,
                                                              Near_Public_Market__c = true,
                                                              Near_Offices__c = true,
                                                              Near_a_Grade_High_School__c = true,
                                                              Near_a_Call_Center__c = true,
                                                              With_TPA_Coverage__c = true,
                                                              With_Lamp_Coverage__c = true);
                allocList.add(allocRecord);
            }
            
        } 
        
        insert allocList;
        return allocList;
        
    }
    
    
    public static List<Allocation__c> createAllocRecords(List<Promo__c> promoIdList){
        List<Allocation__c> allocList = new List<Allocation__c>();
        List<SelectOption> picklistValues = getChannels();
        for(Promo__c promoRecord: promoIdList){
            for(SelectOption option:picklistValues){
                Allocation__c allocRecord = new Allocation__c(Channel__c = option.getValue(),
                                                              Account_Status__c = 'Active',
                                                              Status__c = 'Draft',
                                                              Start_Date__c = Date.today(),
                                                              Sell_in__c = true,
                                                              Sell_out__c = false,
                                                              Ending_Inventory__c = false,
                                                              Sell_out_Data_Type__c  = 'P3',
                                                              Promo__c = promoRecord.Id,
                                                              Frequency_of_Visit__c = '2X',
                                                              Along_National_Highway_Residential__c = 'All',
                                                              Store_Physical_Size__c = '100',
                                                              Store_Format__c = 'All',
                                                              Self_Service_Floor_Area__c = 100.00,
                                                              RPS_Account_Class__c = 'All',
                                                              Near_a_Generics_Drugstore__c = true,
                                                              Near_or_Within_a_Supermarket__c = true,
                                                              Mall_Based__c = true,
                                                              Near_Transport_Terminal__c = true,
                                                              Near_a_Pre_School__c = true,
                                                              Near_a_University_College__c = true,
                                                              Near_Other_Drugstores__c = true,
                                                              Fronting_Near_Hospital__c = true,
                                                              Near_Clinic__c = true,
                                                              Near_Public_Market__c = true,
                                                              Near_Offices__c = true,
                                                              Near_a_Grade_High_School__c = true,
                                                              Near_a_Call_Center__c = true,
                                                              With_TPA_Coverage__c = true,
                                                              With_Lamp_Coverage__c = true);
                allocList.add(allocRecord);
            } 
        }
        
        insert allocList;
        return allocList;
        
    }
    
    public static List<Allocation__c> getSellInAllocRecord(){
        return [SELECT Id, Channel__c,Account_Status__c,Status__c,Start_Date__c,
                       Sell_in__c, Sell_out__c, Ending_Inventory__c, Sell_out_Data_Type__c,
                       Promo__c, Frequency_of_Visit__c, Along_National_Highway_Residential__c, 
                       Store_Physical_Size__c, Store_Format__c, Self_Service_Floor_Area__c, 
                       RPS_Account_Class__c, Near_a_Generics_Drugstore__c, Near_or_Within_a_Supermarket__c,
                       Mall_Based__c, Near_Transport_Terminal__c, Near_a_Pre_School__c, Near_a_University_College__c,
                       Near_Other_Drugstores__c, Fronting_Near_Hospital__c, Near_Clinic__c, Near_Public_Market__c,
                       Near_Offices__c, Near_a_Grade_High_School__c, Near_a_Call_Center__c,
                       With_TPA_Coverage__c, With_Lamp_Coverage__c FROM Allocation__c WHERE Sell_in__c = true];
    }
    
    public static List<Allocation__c> getSellOutAllocRecord(){
        return [SELECT Id, Channel__c,Account_Status__c,Status__c,Start_Date__c,
                       Sell_in__c, Sell_out__c, Ending_Inventory__c, Sell_out_Data_Type__c,
                       Promo__c, Frequency_of_Visit__c, Along_National_Highway_Residential__c, 
                       Store_Physical_Size__c, Store_Format__c, Self_Service_Floor_Area__c, 
                       RPS_Account_Class__c, Near_a_Generics_Drugstore__c, Near_or_Within_a_Supermarket__c,
                       Mall_Based__c, Near_Transport_Terminal__c, Near_a_Pre_School__c, Near_a_University_College__c,
                       Near_Other_Drugstores__c, Fronting_Near_Hospital__c, Near_Clinic__c, Near_Public_Market__c,
                       Near_Offices__c, Near_a_Grade_High_School__c, Near_a_Call_Center__c,
                       With_TPA_Coverage__c, With_Lamp_Coverage__c FROM Allocation__c 
                WHERE Sell_out__c = true LIMIT 1];
    }
    
    public static List<Allocation__c> getEndingInventAllocRecord(){
        return [SELECT Id, Channel__c,Account_Status__c,Status__c,Start_Date__c,
                       Sell_in__c, Sell_out__c, Ending_Inventory__c, Sell_out_Data_Type__c,
                       Promo__c, Frequency_of_Visit__c, Along_National_Highway_Residential__c, 
                       Store_Physical_Size__c, Store_Format__c, Self_Service_Floor_Area__c, 
                       RPS_Account_Class__c, Near_a_Generics_Drugstore__c, Near_or_Within_a_Supermarket__c,
                       Mall_Based__c, Near_Transport_Terminal__c, Near_a_Pre_School__c, Near_a_University_College__c,
                       Near_Other_Drugstores__c, Fronting_Near_Hospital__c, Near_Clinic__c, Near_Public_Market__c,
                       Near_Offices__c, Near_a_Grade_High_School__c, Near_a_Call_Center__c,
                       With_TPA_Coverage__c, With_Lamp_Coverage__c,Ending_Inventory_Operator__c,Ending_Inventory_Measure_Level__c 
                FROM Allocation__c WHERE Ending_Inventory__c = true LIMIT 1];
    }
    
    public static List<Allocation__c> createSellOutAllocRecords(Promo__c promoRecord){
        List<Allocation__c> allocList = new List<Allocation__c>();
        List<SelectOption> picklistValues = getChannels();
        for(SelectOption option:picklistValues){
            Allocation__c allocRecord = new Allocation__c(Channel__c = option.getValue(),
                                                          Account_Status__c = 'Active',
                                                          Status__c = 'Draft',
                                                          Start_Date__c = Date.today(),
                                                          Sell_in__c = false,
                                                          Sell_out__c = True,
                                                          Ending_Inventory__c = false,
                                                          Sell_out_Data_Type__c  = 'P3',
                                                          Promo__c = promoRecord.Id,
                                                          Frequency_of_Visit__c = '2X',
                                                          Along_National_Highway_Residential__c = 'All',
                                                          Store_Physical_Size__c = '100',
                                                          Store_Format__c = 'All',
                                                          Self_Service_Floor_Area__c = 100.00,
                                                          RPS_Account_Class__c = 'All',
                                                          Near_a_Generics_Drugstore__c = true,
                                                          Near_or_Within_a_Supermarket__c = true,
                                                          Mall_Based__c = true,
                                                          Near_Transport_Terminal__c = true,
                                                          Near_a_Pre_School__c = true,
                                                          Near_a_University_College__c = true,
                                                          Near_Other_Drugstores__c = true,
                                                          Fronting_Near_Hospital__c = true,
                                                          Near_Clinic__c = true,
                                                          Near_Public_Market__c = true,
                                                          Near_Offices__c = true,
                                                          Near_a_Grade_High_School__c = true,
                                                          Near_a_Call_Center__c = true,
                                                          With_TPA_Coverage__c = true,
                                                          With_Lamp_Coverage__c = true);
            allocList.add(allocRecord);
        } 
        
        insert allocList;
        return allocList;
        
    }
    
    public static List<Allocation__c> createEndingInventAllocRecords(Promo__c promoRecord){
        List<Allocation__c> allocList = new List<Allocation__c>();
        List<SelectOption> picklistValues = getChannels();
        for(SelectOption option:picklistValues){
            Allocation__c allocRecord = new Allocation__c(Channel__c = option.getValue(),
                                                          Account_Status__c = 'Active',
                                                          Status__c = 'Draft',
                                                          Sell_in__c = false,
                                                          Sell_out__c = false,
                                                          Ending_Inventory__c = true,
                                                          Sell_out_Data_Type__c  = 'P3',
                                                          Promo__c = promoRecord.Id,
                                                          Frequency_of_Visit__c = '2X',
                                                          Along_National_Highway_Residential__c = 'All',
                                                          Store_Physical_Size__c = '100',
                                                          Store_Format__c = 'All',
                                                          Self_Service_Floor_Area__c = 100.00,
                                                          RPS_Account_Class__c = 'All',
                                                          Near_a_Generics_Drugstore__c = true,
                                                          Near_or_Within_a_Supermarket__c = true,
                                                          Mall_Based__c = true,
                                                          Near_Transport_Terminal__c = true,
                                                          Near_a_Pre_School__c = true,
                                                          Near_a_University_College__c = true,
                                                          Near_Other_Drugstores__c = true,
                                                          Fronting_Near_Hospital__c = true,
                                                          Near_Clinic__c = true,
                                                          Near_Public_Market__c = true,
                                                          Near_Offices__c = true,
                                                          Near_a_Grade_High_School__c = true,
                                                          Near_a_Call_Center__c = true,
                                                          With_TPA_Coverage__c = true,
                                                          With_Lamp_Coverage__c = true);
            allocList.add(allocRecord);
        } 
        
        insert allocList;
        return allocList;
        
    }
    
    public static List<Allocation__c> getAllocations(){
        return [SELECT Id, Channel__c FROM Allocation__c WHERE Status__c = 'Draft'];
    }
    
    public static List<Allocation__c> getPromoAllocations(Id promoId){
        return [SELECT Id, Channel__c FROM Allocation__c WHERE Status__c = 'Draft' AND Promo__c =: promoId];
    }
    
    public static List<Allocation__c> getGTAllocations(){
        return [SELECT Id, Channel__c FROM Allocation__c WHERE Status__c = 'Draft' AND Channel__c = 'General Trade'];
    }
    
    public static List<Allocation__c> getKAAllocations(){
        return [SELECT Id, Channel__c FROM Allocation__c WHERE Status__c = 'Draft' AND Channel__c = 'Key Accounts'];
    }
    
    public static List<Allocation__c> getMDCAllocations(){
        return [SELECT Id, Channel__c FROM Allocation__c WHERE Status__c = 'Draft' AND Channel__c = 'Mercury'];
    }
    public static List<Allocation__c> getMTAllocations(){
        return [SELECT Id, Channel__c FROM Allocation__c WHERE Status__c = 'Draft' AND Channel__c = 'Modern Trade'];
    }
    
    //Kris - 6/20/19
    public static void finalizeAllocations(List<Allocation__c> allocList){
        for(Allocation__c allocRecord:allocList){
            allocRecord.Status__c = 'Finalized';
        }
        
        update allocList;
    }
    
    public static List<Account_Allocation__c> getMTAccAlloc(Allocation__c alloc){
        return [SELECT Id, Account__r.Name, Account_Allocation__c.Name, Account__r.Channel__c,
                                                      Account__r.Team__c,Computed_Allocation__c,Allocation_Volume__c, Final_Allocation__c, Account__r.Account_Group__c,
                                                      Ave_Gross_Sales__c, Ave_Qty__c, Growth__c, Status__c, YTDSales_LY__c, YTDSales_TY__c,
                                                      Manual__c,Created_From_API__c,Account__c , Allocation__c
                                                      FROM Account_Allocation__c 
                                                      
                                                      WHERE Allocation__c =: alloc.Id
                                                      ORDER BY Account__r.Channel__c, Account__r.Team__c, Account__r.Account_Group__c, Account__r.Name];
        
    }
    
    public static List<Account_Allocation__c> createAccAllocRecords(List<Allocation__c> allocList, Account acc){
        List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
        for(Allocation__c allocRecord:allocList){
            Account_Allocation__c accAllocRecord = new Account_Allocation__c(Allocation__c = allocRecord.Id,
                                                                             Status__c = 'Not Concurred',
                                                                             Account__c = acc.Id);
            
            accAllocList.add(accAllocRecord);
            
        }
        insert accAllocList;
        return accAllocList;
    }
    
    public static List<Account_Allocation__c> createGTAccAllocRecords(Allocation__c allocRecord, List<Account> accList){
        List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
        for(Account accountRecord:accList){
            Account_Allocation__c accAllocRecord = new Account_Allocation__c(Allocation__c = allocRecord.Id,
                                                                             Status__c = 'Not Concurred',
                                                                             Account__c = accountRecord.Id);
            
            accAllocList.add(accAllocRecord);
            
        }
        insert accAllocList;
        return accAllocList;
    }
    
    public static List<Account_Allocation__c> createKAAccAllocRecords(Allocation__c allocRecord, List<Account> accList){
        List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
        for(Account accountRecord:accList){
            Account_Allocation__c accAllocRecord = new Account_Allocation__c(Allocation__c = allocRecord.Id,
                                                                             Status__c = 'Not Concurred',
                                                                             Account__c = accountRecord.Id);
            
            accAllocList.add(accAllocRecord);
            
        }
        insert accAllocList;
        return accAllocList;
    }
    
    public static List<Account_Allocation__c> createMDCAccAllocRecords(Allocation__c allocRecord, List<Account> accList){
        List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
        for(Account accountRecord:accList){
            Account_Allocation__c accAllocRecord = new Account_Allocation__c(Allocation__c = allocRecord.Id,
                                                                             Status__c = 'Not Concurred',
                                                                             Account__c = accountRecord.Id);
            
            accAllocList.add(accAllocRecord);
            
        }
        insert accAllocList;
        return accAllocList;
    }
    
    public static List<Account_Allocation__c> createMTAccAllocRecords(Allocation__c allocRecord, List<Account> accList){
        List<Account_Allocation__c> accAllocList = new List<Account_Allocation__c>();
        for(Account accountRecord:accList){
            Account_Allocation__c accAllocRecord = new Account_Allocation__c(Allocation__c = allocRecord.Id,
                                                                             Status__c = 'Not Concurred',
                                                                             Account__c = accountRecord.Id);
            
            accAllocList.add(accAllocRecord);
            
        }
        insert accAllocList;
        return accAllocList;
    }
    
    public static Map<String, Id> getProfileId(){
        Map<String, Id> mapProfile = new Map<String, Id>();
        
        for (Profile listOfProfile : [SELECT Id, Name FROM Profile]) {
            mapProfile.put(listOfProfile.Name, listOfProfile.Id);
        }
        
        return mapProfile;
    }
    
    public static List<Account_Allocation__c> getAccAllocation(){
        return [SELECT Id, Allocation__c, Name, Manual__c, YTDSales_LY__c, YTDSales_TY__c, Growth__c,
                		Ave_Qty__c, Final_Allocation__c, Status__c, Computed_Allocation__c, Ave_Gross_Sales__c
                 		FROM Account_Allocation__c];
    }
    
    public static List<Id> getIdAccAlloc(){
        List<Account_Allocation__c> accAllocationsToDelete = [SELECT Id 
															  FROM Account_Allocation__c];
        
        List<Id> idsToDelete = new List<Id>();
        for(Account_Allocation__c accAlloc: accAllocationsToDelete){
            idsToDelete.add(accAlloc.Id);
        }
        
        return idsToDelete;
    }
    
    
    // inserted by KC
     //Zeus 6/14/2019
    public static void createPromoTriggerImplemented(){
        Promo__c promoRecord = new Promo__c(Promo_Name__c = 'Test Promo 1',
                                            Promo_Type__c = 'GC Promo');
        
        insert promoRecord;
        
        List <Allocation__c> allocList = new List<Allocation__c>();
        
        Allocation__c alloc = new Allocation__c();
        alloc.Allocation_Volume__c = 35000;
        alloc.Start_Date__c = Date.today();
        alloc.End_Date__c = Date.today()+30;
        alloc.Promo__c = promoRecord.Id;
        alloc.Channel__c = 'Modern Trade';
        alloc.Status__c = 'Draft';
        allocList.add(alloc);
        
        insert allocList;
        
        promoRecord.Status__c = 'Implemented';
        
        update promoRecord;
        
    }
}