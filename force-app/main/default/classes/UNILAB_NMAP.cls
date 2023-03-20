public class UNILAB_NMAP {
    
    /* wrapper class to store required properties for "lightning:map" component' */ 
    public class accountLocationWrapper{
        @AuraEnabled public string icon {get;set;} 
        @AuraEnabled public string title {get;set;} 
        @AuraEnabled public string description {get;set;} 
        @AuraEnabled public locationDetailWrapper location {get;set;} 
    }
    /* sub wrapper class to store location details for "accountLocationWrapper" location property.*/ 
    public class locationDetailWrapper{
        @AuraEnabled public string Street{get;set;}
        @AuraEnabled public string Brgy{get;set;}
        @AuraEnabled public string City{get;set;}
        @AuraEnabled public string Province{get;set;}
        @AuraEnabled public string District{get;set;}
        @AuraEnabled public string Region{get;set;}
        @AuraEnabled public string Country{get;set;}
        @AuraEnabled public string Longitude {get;set;}
        @AuraEnabled public string Latitude {get;set;}
        @AuraEnabled public string Amount {get;set;}
    }
    
    
    
    @AuraEnabled
    public static Account fetchMainAccountAddress(String acctID){
        return [Select Id,Name,Account_Address_1_Bldg_No_Street__c, Account_Address_2_District_Brgy__c, Territory_Town_City_Municipality__c, 
                               Province__c, District__c,Region__c,Area__c, Zip_Code__c,  Longitude__c, Latitude__c
                               ,sales_ave__r.amt__c
                               from Account where Id=:acctId
                               LIMIT 1
                              ];
        //System.debug('CHECKER -> ' + acctAddress);
        //return acctAddress;
        
    }  
    
    @AuraEnabled
    public static List<Account> fetchNearByAccount(String acctID, String city){
        //System.debug('Checker1: ' + city);
        // pryceRegion = pryceRegion.removeEnd(',');
        //List<Account> returnList = new List<Account>();
        return [Select Id,Name,Account_Address_1_Bldg_No_Street__c, 
                                        Account_Address_2_District_Brgy__c, 
                                        Territory_Town_City_Municipality__c, 
                                        Province__c, District__c,Region__c,Area__c, Zip_Code__c,
                                        Longitude__c, Latitude__c
                                        ,sales_ave__r.amt__c
                                        from Account 
                                        where Territory_Town_City_Municipality__c = :city
                                        AND Province__c != null
                                        AND Id != :acctID
                                        ORDER BY Longitude__c DESC
                                        LIMIT 5
                                        
                                       ];
        //System.debug('Checker :' + nearbyAcctList.size());
        //returnList.addAll(nearbyAcctList);
        //return nearbyAcctList;
        //return returnList;
        
    }    
	
    @AuraEnabled
    public static list<accountLocationWrapper> getLocation(String acctId){
    
        list<accountLocationWrapper> lstALW = new list<accountLocationWrapper>();
        
        if(String.isNotBlank(acctId)){
        Account acctMain = fetchMainAccountAddress(acctId);
        /*Account acctMain = [Select Id,Name,Account_Address_1_Bldg_No_Street__c, Account_Address_2_District_Brgy__c, Territory_Town_City_Municipality__c, 
                               Province__c, District__c,Region__c,Area__c, Zip_Code__c,  Longitude__c, Latitude__c
                               ,sales_ave__r.amt__c
                               from Account where Id=:acctId
                              ];*/
        
            accountLocationWrapper acctLocation = new accountLocationWrapper();
            locationDetailWrapper acctLocDetailWrap = new locationDetailWrapper();
            
            acctLocDetailWrap.Street =  acctMain.Account_Address_1_Bldg_No_Street__c;
            acctLocDetailWrap.Brgy = acctMain.Account_Address_2_District_Brgy__c;
            acctLocDetailWrap.City = acctMain.Territory_Town_City_Municipality__c;
            acctLocDetailWrap.Province = acctMain.Province__c;
            acctLocDetailWrap.District = acctMain.District__c;
            acctLocDetailWrap.Region = acctMain.Region__c;
            acctLocDetailWrap.Country = 'Philippines';
            acctLocDetailWrap.Longitude = String.valueOf(acctMain.Longitude__c);
            acctLocDetailWrap.Latitude = String.valueOf(acctMain.Latitude__c);
            acctLocDetailWrap.Amount = String.valueOf(acctMain.sales_ave__r.amt__c);
            
            acctLocation.icon = 'standard:account';
            acctLocation.title = acctMain.Name + ' | '+ acctMain.sales_ave__r.amt__c;
            acctLocation.description = acctMain.Account_Address_1_Bldg_No_Street__c; 

            
            acctLocation.location = acctLocDetailWrap;
            lstALW.add(acctLocation);
            
            acctLocDetailWrap=null;
            acctLocation=null;
            
            List<Account> listAcct = fetchNearByAccount(acctMain.Id,acctMain.Territory_Town_City_Municipality__c);
            /*List<Account> listAcct = [Select Id,Name,Account_Address_1_Bldg_No_Street__c, 
                                        Account_Address_2_District_Brgy__c, 
                                        Territory_Town_City_Municipality__c, 
                                        Province__c, District__c,Region__c,Area__c, Zip_Code__c,
                                        Longitude__c, Latitude__c
                                        ,sales_ave__r.amt__c
                                        from Account 
                                        where Territory_Town_City_Municipality__c = :acctMain.Territory_Town_City_Municipality__c
                                        AND Id != :acctID
                                        ORDER BY Longitude__c DESC
                                        LIMIT 3
                                       ];*/
            //if (listAcct.size() > 0) {
                //System.debug('CHEEEEEEECK List Account ' + listAcct);
                for(Account acct: listAcct){
                    //accountLocationWrapper nearAcctLocation = new accountLocationWrapper();
                    
                    //System.debug('CHEEEEEEECK>> ' + acct);
                    
                    //locationDetailWrapper nearAcctLocDetailWrap = new locationDetailWrapper();
                    acctLocDetailWrap.Street =  acct.Account_Address_1_Bldg_No_Street__c;
                    acctLocDetailWrap.Brgy = acct.Account_Address_2_District_Brgy__c;
                    acctLocDetailWrap.City = acct.Territory_Town_City_Municipality__c;
                    acctLocDetailWrap.Province = acct.Province__c;
                    acctLocDetailWrap.District = acct.District__c;
                    acctLocDetailWrap.Region = acct.Region__c;
                    acctLocDetailWrap.Country = 'Philippines';
                    acctLocDetailWrap.Longitude = String.valueOf(acct.Longitude__c);
                    acctLocDetailWrap.Latitude = String.valueOf(acct.Latitude__c);
                    acctLocDetailWrap.Amount = String.valueOf(acct.sales_ave__r.amt__c);
                    
                    
                    AcctLocation.icon = 'standard:work_order';
                    AcctLocation.title = acct.Name + ' | '+ acct.sales_ave__r.amt__c;
                    //nearAcctLocation.description = 'TOTAL SKU + SOMETHING FIELD'; 
                    AcctLocation.description = acct.Account_Address_1_Bldg_No_Street__c; 
                    
                    AcctLocation.location = AcctLocDetailWrap;
                    lstALW.add(AcctLocation);
                }
            //}
        }
        return lstALW;
    }
    
}