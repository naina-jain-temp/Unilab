/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.12.2017
Definition   :   Controller for UNILAB_UserAccountPie Page
History      :   07.12.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
public with sharing class UNILAB_UserAccountPieCX{
    
    public List<PieData> getPieData(){
        List<PieData> data = new List<PieData>();
        List<Account> acctList = [SELECT Id, Area__c FROM Account WHERE OwnerId = : Userinfo.getUserId()];
        List<AccountTeamMember> acctTeamMemList = [SELECT Id, Account.Area__c FROM AccountTeamMember WHERE UserId =: Userinfo.getUserId()];
        Map<String, Decimal> areaAccountCountMap = new Map<String, Decimal>();
        //map all area and count of accts
        for(Account a : acctList){
            
            if(areaAccountCountMap.containsKey(a.Area__c)){
                Decimal x = areaAccountCountMap.get(a.Area__c);
                areaAccountCountMap.put(a.Area__c, x+1);
            }else{
                areaAccountCountMap.put(a.Area__c,1);
            }
            
        }
        
        for(AccountTeamMember atm : acctTeamMemList){
            if(areaAccountCountMap.containsKey(atm.Account.Area__c)){
                Decimal x = areaAccountCountMap.get(atm.Account.Area__c);
                areaAccountCountMap.put(atm.Account.Area__c,x+1);
            }else{
                areaAccountCountMap.put(atm.Account.Area__c,1);
            }
        }
        
        for(String s : areaAccountCountMap.keySet()){
            data.add(new PieData(s+':'+String.valueOf(areaAccountCountMap.get(s)),areaAccountCountMap.get(s)));
        }
        return data;
    }
    public class PieData {

        public String name { get; set; }
        public Decimal data { get; set; }
    
        public PieData(String namevalue, Decimal datavalue) {
            name = namevalue;
            data = datavalue;
        }
    }
}