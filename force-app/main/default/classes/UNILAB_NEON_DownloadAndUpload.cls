public class UNILAB_NEON_DownloadAndUpload {
    
    @AuraEnabled
    public static List<Account> fetchData(String prodId, String accType) {
        String userId = userInfo.getUserId();
        List<String> customerType = new List<String>();
        List<String> neonAccGrp = new List<String>();
        List<Account> accDetails = new List<Account>();
        List<NEON_Product_Account__c> neonProdItem = new List<NEON_Product_Account__c>();
        NEON_Product__c neonProd = [SELECT Id,
                                            Product__c,
                                            BU__c
                                    FROM NEON_Product__c 
                                    WHERE Id =:prodId];
        
        for(NEON_User_Matrix__c um :[SELECT Customer_Team__c 
                                     FROM NEON_User_Matrix__c 
                                     WHERE User__c =: userId
                                     	AND BU__c =: neonProd.BU__c]) {
        	customerType.add(um.Customer_Team__c);
        }
        System.debug(accType);
        if(neonProd.Id != null) {
            System.debug('neonProd - not null');
            neonProdItem = [SELECT Account_Group__c 
                            FROM NEON_Product_Account__c 
                            WHERE NEON_Product__c =:neonProd.Id
                           		AND CT_Customer_Team_Name__c IN:customerType];
            System.debug(neonProdItem);
            System.debug(customerType);
            System.debug(neonProd);
            for(NEON_Product_Account__c accp: neonProdItem) {
                neonAccGrp.add(accp.Account_Group__c);
            }

            if(accType.equals('Head Office')) {
                accDetails = [SELECT Id, 
                              Channel__c, 
                              Team__c, 
                              Account_Group__c, 
                              Branch_Code__c, 
                              Branch_Name__c,
                              Account_Type__c,
                              Account_Status__c,
                              
                              Account_Record_Type_Name__c,
                              Account_Closure_Date__c,
                              IS_Term__c,
                              Foot_Traffic_Cust_Count_Per_Day__c,
                              New_Prod_IS_Ethical__c,
                              New_Prod_IS_OTC__c,
                              New_Prod_IS_PC__c,
                              New_Prod_IS_Ritemed_Ethical__c,
                              New_Prod_IS_Ritemed_OTC__c,
                              RPS_Account_Class__c,
                              Near_A_Call_Center__c,
                              Near_A_Pre_School__c,
                              Near_A_School__c,
                              Near_A_University_College__c,
                              Near_Clinic__c,
                              Near_Offices__c,
                              Near_Other_Drugstores__c,
                              Near_Public_Market__c,
                              Near_Transport_Terminal__c,
                              Near_or_Within_a_Supermarket__c,
                              Fronting_Near_Hospital__c,
                              Ave_Daily_Basket_Size_Peso__c,
                              Near_a_Generics_Drugstore__c,
                              MT_RPS_Account_Class__c,
                              For_Inclusion_in_RPS_Survey__c,
                              Retail_Environment__c
                          FROM Account
                          WHERE Account_Group__c IN:neonAccGrp 
                          		AND Account_Record_Type_Name__c = 'Main/Warehouse'
                              	//AND Account_Type__c = 'Head Office' 
                          		AND Account_Status__c = 'Open'];
            } else {
                accDetails = [SELECT Id, 
                              Channel__c, 
                              Team__c, 
                              Account_Group__c, 
                              Branch_Code__c, 
                              Branch_Name__c,
                              Account_Type__c,
                              Account_Status__c,
                              
                              Account_Record_Type_Name__c,
                              Account_Closure_Date__c,
                              IS_Term__c,
                              Foot_Traffic_Cust_Count_Per_Day__c,
                              New_Prod_IS_Ethical__c,
                              New_Prod_IS_OTC__c,
                              New_Prod_IS_PC__c,
                              New_Prod_IS_Ritemed_Ethical__c,
                              New_Prod_IS_Ritemed_OTC__c,
                              RPS_Account_Class__c,
                              Near_A_Call_Center__c,
                              Near_A_Pre_School__c,
                              Near_A_School__c,
                              Near_A_University_College__c,
                              Near_Clinic__c,
                              Near_Offices__c,
                              Near_Other_Drugstores__c,
                              Near_Public_Market__c,
                              Near_Transport_Terminal__c,
                              Near_or_Within_a_Supermarket__c,
                              Fronting_Near_Hospital__c,
                              Ave_Daily_Basket_Size_Peso__c,
                              Near_a_Generics_Drugstore__c,
                              MT_RPS_Account_Class__c,
                              For_Inclusion_in_RPS_Survey__c,
                              Retail_Environment__c
                          FROM Account
                          WHERE Account_Group__c IN:neonAccGrp 
                              	AND Account_Record_Type_Name__c = 'Branch/Single Accounts'
                              	//AND Account_Type__c <> 'Head Office'
                          		AND Account_Status__c = 'Open'];
            }
        }
        return accDetails;
    }
    
    /* for import data into sobject and insert data from csv file  */ 
    @AuraEnabled
    public static string insertData(String strfromle, String prodId) {
        NEON_Product__c neonProdId = [SELECT Id, Product__c 
                                            FROM NEON_Product__c 
                                            WHERE Id =:prodId];
        String returnresponse ='';
        List<NEON_IS_Plan__c> AccountListtoInsert = new List<NEON_IS_Plan__c>();
        List<NEON_IS_Plan__c> AccountListtoUpdate = new List<NEON_IS_Plan__c>();
        
        List<NEON_IS_Plan__c> ispData = [SELECT Id,
                                         		Account__c,
                                         		Account_Type__c,
                                         		Account_Record_Type_Name__c,
                                         		NEON_Product__c,
                                         		IS_Status__c,
		                                        CT_Customer_Team_Name__c 
                                         FROM NEON_IS_Plan__c
                                        WHERE NEON_Product__c = :prodId];
        
        //System.debug('strfromle = ' + strfromle);
        List<FieldWrapper> datalist = (List<FieldWrapper>)JSON.deserialize(strfromle, List<FieldWrapper>.class);
        //system.debug('datalist = ' + datalist);
        system.debug('datalistSize = ' + datalist.size());
        Integer counter=0;
        if(ispData.size() > 0){
        	for(FieldWrapper wrapper: datalist) {
                for(NEON_IS_Plan__c isplan: ispData) {
                    NEON_IS_Plan__c isp =new  NEON_IS_Plan__c();
                    if(wrapper.sfa_internal_id.equals(isplan.Account__c) && 
                       //wrapper.account_type.equals(isplan.Account_Type__c) &&
                       wrapper.account_record_type_name.equals(isplan.Account_Record_Type_Name__c) &&
                       neonProdId.Id.equals(isplan.NEON_Product__c) &&
                       isplan.IS_Status__c.equals('Draft')
                      ) {
                          String accId = wrapper.sfa_internal_id;
                          isp.Account__c = accId;
                          isp.IS_Qty__c = wrapper.is_qty;
                          isp.Branch_Target__c = wrapper.branch_target;
                          isp.Id = isplan.Id;                      
                          AccountListtoUpdate.add(isp); 
                          counter++;
                      }
                }           
            }
        }
        if(counter > 0) {
            if(AccountListtoUpdate.size() > 0){
                try {
                    update AccountListtoUpdate;
                    returnresponse = neonProdId.Id;
                }
                catch(Exception ex){
                    returnresponse = 'ERROR';
                }
            }
        } else {
            for(FieldWrapper wrapper: datalist) {
                NEON_IS_Plan__c isp =new  NEON_IS_Plan__c();
                if(wrapper.is_qty >= 1){
                    String accId = wrapper.sfa_internal_id;
                    isp.Account__c = accId;
                    isp.IS_Qty__c = wrapper.is_qty;
                    isp.Branch_Target__c = wrapper.branch_target;
                    isp.Account_Type__c = wrapper.account_type;
                    isp.Account_Record_Type_Name__c = wrapper.account_record_type_name;
                    isp.Product__c = neonProdId.Product__c;
                    isp.IS_Status__c = 'Draft';
                    isp.NEON_Product__c = neonProdId.Id;
                    AccountListtoInsert.add(isp); 
                }
            }
            if(AccountListtoInsert.size() > 0){
                try {
                    insert AccountListtoInsert;
                    returnresponse = neonProdId.Id;
                }
                catch(Exception ex){
                    returnresponse = 'ERROR';
                }
            }
        }
        
        return returnresponse;
    }
    
    @AuraEnabled
    public static List<fieldWrapper> fetchStatus(String prodId) {
        String userId = userInfo.getUserId();
        Set<String> customerTeam = new Set<String>();
        
        NEON_Product__c neonProdId = [SELECT Id, BU__c 
                                      FROM NEON_Product__c 
                                      WHERE Id =:prodId];
        
        for(NEON_User_Matrix__c umId : [SELECT Customer_Team__c
                                        FROM NEON_User_Matrix__c 
                                        WHERE User__c = :userId 
                                        	AND BU__c = :neonProdId.BU__c]) {
            customerTeam.add(umId.Customer_Team__c);
        }
        
        List<NEON_IS_Plan__c> ispData = [SELECT Id 
                                            FROM NEON_IS_Plan__c
                                            WHERE NEON_Product__c = :neonProdId.Id
                                         		AND CT_Customer_Team_Name__c IN :customerTeam
                                         		AND IS_Status__c = 'Draft'
                                           ];
        
        List<NEON_IS_Plan_Log__c> ispLog = [SELECT Id, NEON_IS_Plan__r.IS_Status__c, NEON_IS_Plan__r.Account__r.CT_Customer_Team_Name__c  
                                            FROM NEON_IS_Plan_Log__c
                                            WHERE NEON_IS_Plan__r.Id IN :ispData
                                            	AND Status__c = 'Draft'
                                           ];
        
        List<FieldWrapper> returnData = new List<FieldWrapper>();
        List<NEON_IS_Plan__c> ispChecker = [SELECT Id FROM NEON_IS_Plan__c WHERE NEON_Product__c = :neonProdId.Id AND CT_Customer_Team_Name__c IN :customerTeam AND CreatedById = :userId]; //added Created By 9/23/2022 JNL
        Set<String> counter = new Set<String>();
        System.debug(returnData.size());
        if(ispChecker.size()>0) {
            if(ispData.size()>0 && ispLog.size()>0) {
                for(NEON_IS_Plan_Log__c log : ispLog) {
                    if(returnData.size()>0) {
                        if(counter.contains(log.NEON_IS_Plan__c)) {
                            counter.add(log.NEON_IS_Plan__c);
                            returnData.add(new FieldWrapper(log.NEON_IS_Plan__r.Account__r.CT_Customer_Team_Name__c, 
                                                            log.NEON_IS_Plan__r.IS_Status__c));
                        }
                    } else {
                        counter.add(log.NEON_IS_Plan__c);
                        returnData.add(new FieldWrapper(log.NEON_IS_Plan__r.Account__r.CT_Customer_Team_Name__c, 
                                                        log.NEON_IS_Plan__r.IS_Status__c));
                    }
                }
            } else { 
                returnData.add(new FieldWrapper('1', 'submitted'));
            }
        } else {
            returnData.add(new FieldWrapper('0', 'zero'));
        }
        
        return returnData;
    }
    
    public class FieldWrapper{        
        public Integer is_qty;        
        public Integer branch_target;
        public String sfa_internal_id;
        public String account_type;
        public String account_record_type_name;
        
        @AuraEnabled public String Customer_Team {get;set;}
        @AuraEnabled public String IS_Status {get;set;}
        public fieldWrapper(String Customer_Team, String IS_Status) {
            this.Customer_Team = Customer_Team;
            this.IS_Status = IS_Status;
        }
    }
}