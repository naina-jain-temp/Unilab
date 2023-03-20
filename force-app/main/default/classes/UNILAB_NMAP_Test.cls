@isTest
public class UNILAB_NMAP_Test {
    
    @isTest static void fetchMainAccountAddress() {
        String acctId='0019D00000836HiQAI';
        
        Account parentAcct = new Account();
        parentAcct.Name = 'Sample';
        parentAcct.Bill_To_Code__c = '0080101010';
        parentAcct.Branch_Code__c = '0080101010';
        parentAcct.Branch_Name__c = 'Sample';
        insert parentAcct;

        Test.startTest();
        	Account acc = UNILAB_NMAP.fetchMainAccountAddress(parentAcct.Id);
        Test.stopTest();
        System.assert(acc!=null);
         
    }
    
    @isTest static void fetchNearByAccount() {
        String acctId='0019D00000836HiQAI';
        String city='Highway Hills, Mandaluyong City';
        Test.startTest();
        	List<Account> acc = UNILAB_NMAP.fetchNearByAccount(acctId,city);
        Test.stopTest();
        System.assert(acctId!=null);
        
    }
    
    @isTest static void getLocation() {
		String acctId='0019D00000836HiQAI';
        //list<UNILAB_NMAP.accountLocationWrapper> lstALW = new list<UNILAB_NMAP.accountLocationWrapper>();
        Account parentAcct = new Account();
        parentAcct.Name = 'Sample';
        parentAcct.Bill_To_Code__c = '0080101010';
        parentAcct.Branch_Code__c = '0080101010';
        parentAcct.Branch_Name__c = 'Sample';
        insert parentAcct;

        Test.startTest();
        	List<UNILAB_NMAP.accountLocationWrapper> acc = UNILAB_NMAP.getLocation(parentAcct.Id);
        	/*
            Account acctMain = UNILAB_NMAP.fetchMainAccountAddress(acctId);
         
            
                UNILAB_NMAP.accountLocationWrapper acctLocation = new UNILAB_NMAP.accountLocationWrapper();
                UNILAB_NMAP.locationDetailWrapper acctLocDetailWrap = new UNILAB_NMAP.locationDetailWrapper();
                
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
                
                
                List<Account> listAcct = UNILAB_NMAP.fetchNearByAccount(acctMain.Id,acctMain.Territory_Town_City_Municipality__c);
                
                    //System.debug('CHEEEEEEECK List Account ' + listAcct);
                    for(Account acct: listAcct){
                        UNILAB_NMAP.accountLocationWrapper nearAcctLocation = new UNILAB_NMAP.accountLocationWrapper();
                        
                        //System.debug('CHEEEEEEECK>> ' + acct);
                        
                        UNILAB_NMAP.locationDetailWrapper nearAcctLocDetailWrap = new UNILAB_NMAP.locationDetailWrapper();
                        nearAcctLocDetailWrap.Street =  acct.Account_Address_1_Bldg_No_Street__c;
                        nearAcctLocDetailWrap.Brgy = acct.Account_Address_2_District_Brgy__c;
                        nearAcctLocDetailWrap.City = acct.Territory_Town_City_Municipality__c;
                        nearAcctLocDetailWrap.Province = acct.Province__c;
                        nearAcctLocDetailWrap.District = acct.District__c;
                        nearAcctLocDetailWrap.Region = acct.Region__c;
                        nearAcctLocDetailWrap.Country = 'Philippines';
                        nearAcctLocDetailWrap.Longitude = String.valueOf(acct.Longitude__c);
                        nearAcctLocDetailWrap.Latitude = String.valueOf(acct.Latitude__c);
                        nearAcctLocDetailWrap.Amount = String.valueOf(acct.sales_ave__r.amt__c);
                        
                        
                        nearAcctLocation.icon = 'standard:work_order';
                        nearAcctLocation.title = acct.Name + ' | '+ acct.sales_ave__r.amt__c;
                        //nearAcctLocation.description = 'TOTAL SKU + SOMETHING FIELD'; 
                        nearAcctLocation.description = acct.Account_Address_1_Bldg_No_Street__c; 
                        
                        nearAcctLocation.location = nearAcctLocDetailWrap;
                        lstALW.add(nearAcctLocation);
                    }*/
                
            
        Test.stopTest();
        System.assert(parentAcct!=null);
    }
}