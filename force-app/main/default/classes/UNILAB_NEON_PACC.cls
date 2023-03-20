public class UNILAB_NEON_PACC {
    
    public class NAccountListWrapper {
        @AuraEnabled public NEON_Account_Ref__c objNAcctGroupRef {get;set;}
        @AuraEnabled public NEON_Product_Account__c objNAcctGroupData {get;set;}
        public nAccountListWrapper(NEON_Account_Ref__c objNAcctGroupRef, NEON_Product_Account__c objNAcctGroupData){
            this.objNAcctGroupRef = objNAcctGroupRef;
            this.objNAcctGroupData = objNAcctGroupData;
        }
    }
    
    @AuraEnabled
    public static List<NAccountListWrapper> fetch(List<String> ct, string recordId){
        
        List<NEON_Account_Ref__c> acctGrpRefList = new List<NEON_Account_Ref__c>();
        List<NEON_Product_Account__c> prodAcctList = new List<NEON_Product_Account__c>();
        List<NAccountListWrapper> prodAcct = new List<NAccountListWrapper>();
        Set<String> setId = new Set<String>();
        Set<String> dupliId = new Set<String>();
        
        for(NEON_Account_Ref__c acct : [SELECT Id, 
                                    CT_Customer_Team_Name__c,
                                    Account_Group__c
                                FROM NEON_Account_Ref__c
                                WHERE Is_Active__c = true
                                        AND CT_Customer_Team_Name__c in :ct //('Customer Team 1','Customer Team 5')
                                    ORDER BY Name ASC]) {
                acctGrpRefList.add(acct);
            }
        
        for(NEON_Product_Account__c prdAcc : [SELECT Id,
                                CT_Customer_Team_Name__c,
                                Account_Group__c,
                                Pipeline_Date__c,
                                Saturation_Date__c
                                FROM NEON_Product_Account__c
                                //WHERE CT_Customer_Team_Name__c =:ct AND NEON_Product__c = :prodId]) {
                                WHERE CT_Customer_Team_Name__c in :ct //('Customer Team 1','Customer Team 5') 
                                              AND NEON_Product__c = :recordId]) {
                                    prodAcctList.add(prdAcc);
                                    dupliId.add(prdAcc.Account_Group__c);
                                }
        
        for(NEON_Account_Ref__c acr: acctGrpRefList) {
            if(prodAcctList.size()<=0) {
                prodAcct.add(new NAccountListWrapper(acr, new NEON_Product_Account__c(Pipeline_Date__c = null,
                                                        Saturation_Date__c = null)));
                setId.add(acr.Id);    
            }else {
                for(NEON_Product_Account__c acd: prodAcctList) {
                    //prodAcct.add(new NAccountListWrapper(acr, acd));
                    if(acr.Account_Group__c == acd.Account_Group__c) {
                        prodAcct.add(new NAccountListWrapper(acr, acd));
                    } else {
                        setId.add(acr.Account_Group__c);
                    }
                }
            }
            
            if(setId.contains(acr.Account_Group__c)) {
                if(!dupliId.contains(acr.Account_Group__c)) {
                    prodAcct.add(new NAccountListWrapper(acr, new NEON_Product_Account__c(Pipeline_Date__c = null,
                                                            Saturation_Date__c = null)));
                }
            }
        }
        
        return prodAcct;
    }
	
    @AuraEnabled
    public static List<NEON_Account_Ref__c> fetchProductAcct(string ct){
        return[
            select CT_Account_Group__c
            from NEON_Account_Ref__c
            where CT_Customer_Team_Name__c = :ct
            and Is_Active__c = true
        ];
    }
    
    @AuraEnabled
    public static String saveForm(List<NEON_Product_Account__c> acctGroupPriorityData, String recordId) {
    	
        List<NEON_Product_Account__c> prodAcctCheckList = new List<NEON_Product_Account__c>();
        Set<String> setCheckList = new Set<String>();
        NEON_Product_Account__c prodAcctCheckListItem = new NEON_Product_Account__c();
        
        for (NEON_Product_Account__c acc : acctGroupPriorityData) {
            Integer eCount = [select count() from NEON_Product_Account__c 
                              where Account_Group__c = :acc.Account_Group__c
                             	and NEON_Product__c = :recordId];
            
            if((eCount <= 0 || eCount == null) && (acc.Pipeline_Date__c != null || acc.Saturation_Date__c != null)){
                prodAcctCheckListItem = new NEON_Product_Account__c(CT_Customer_Team_Name__c = acc.CT_Customer_Team_Name__c,
                                                          Account_Group__c = acc.Account_Group__c,
                                                          Pipeline_Date__c = acc.Pipeline_Date__c,
                                                          Saturation_Date__c = acc.Saturation_Date__c, 
                                                          NEON_Product__c = recordId
                                                         );
                prodAcctCheckList.add(prodAcctCheckListItem);
                setCheckList.add(prodAcctCheckListItem.Account_Group__c);
            }
        }
        insert prodAcctCheckList;
        return prodAcctCheckListItem.Id;
    }
    
}