public class UNILAB_CAP {
	public class ProductListWrapper {

		@AuraEnabled public Boolean isChecked { get; set; }
		@AuraEnabled public CAP_Item_Ref__c prod2 { get; set; }

		public productListWrapper(Boolean isChecked, CAP_Item_Ref__c prod2) {
			if (isChecked != NULL && prod2 != NULL) {
				this.isChecked = isChecked;
				this.prod2 = prod2;
			}
		}

	}
    
    public class SaveRecordParameters {
        
        @AuraEnabled public String recordID { get; set; }
        @AuraEnabled public String accountID { get; set; }
        @AuraEnabled public List<String> productIDList { get; set; }
        @AuraEnabled public List<String> productRemarkList { get; set; }
        @AuraEnabled public List<String> productComment { get; set; }
        @AuraEnabled public String buttonName { get; set; }
        @AuraEnabled public Date recordDate { get; set; }
        
    }
    
    public class SARDetails {
        
        @AuraEnabled public Account acctRec { get; set; }
        @AuraEnabled public Date recordDate { get; set; }
        @AuraEnabled public String status { get; set; }
        
    }
    
    //Product List
    @AuraEnabled
    public static List<ProductListWrapper> getProducts(String recordID, String acctID, String filterSet) {
        
        System.debug('RECORD ID: ' + recordID);

        String userId = userInfo.getUserId();
        List<Account> channel = [SELECT Channel__c
                            FROM Account
                            WHERE (Id = :acctID)
                            LIMIT 1
                           ];
        String channel2;
        
        if(channel.size() == 1){
    		channel2 = channel[0].Channel__c;
    	}
    	else{
    		channel2 = null;
    	}
		
        List<CAP_Item_Ref__c> prod2List = [SELECT Id,
                                    	   Name
                                    FROM CAP_Item_Ref__c
                                    WHERE Channel__c = :channel2
                                    AND Name__c = :filterSet
                                    ORDER BY Name ASC
                                   ];
        
        List<ProductListWrapper> lstProductListWrapper = new List<ProductListWrapper>();
        
        if (String.isNotBlank(recordID)) {
            
            List<CAP_Availability_Line_Item__c> subActLineItemList = [SELECT Product__c
                                                                  FROM CAP_Availability_Line_Item__c
                                                                  WHERE (Sub_Activity_Report__c = :recordID)
                                                                 ];
            
            if (subActLineItemList.size() > 0) {
                
                List<String> subActLineItemProdIDsList = new List<String>();
                
                for (CAP_Availability_Line_Item__c subActLineItemRec : subActLineItemList) {
                    subActLineItemProdIDsList.add(subActLineItemRec.Product__c);
                    //subActLineItemProdIDsList.add(subActLineItemRec.Remarks__c);
                    //subActLineItemProdIDsList.add(subActLineItemRec.Comment__c);
                }
                
                if (subActLineItemProdIDsList.size() > 0) {
                    
                    for (CAP_Item_Ref__c prod2Rec : prod2List) {
                        
                        if (subActLineItemProdIDsList.contains(prod2Rec.Id)) {
                            System.debug('SELECTED PRODUCTS');
                            lstProductListWrapper.add(new ProductListWrapper(true, prod2Rec));
                        }
                        
                        else {
                            lstProductListWrapper.add(new ProductListWrapper(false, prod2Rec));
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        else {
            
            if (prod2List.size() > 0){
                for (CAP_Item_Ref__c prod2Rec : prod2List) {
                    lstProductListWrapper.add(new ProductListWrapper(false, prod2Rec));
                }
                
            }
            
        }
        
        System.debug('PRODUCT LIST WRAPPER SIZE: ' + lstProductListWrapper.size());
        
        return lstProductListWrapper;
        
    }
    
    //Record Submission
    @AuraEnabled
    public static String submitRecord(String recordParameters) {
        
        if (String.isNotBlank(recordParameters)) {
            
            SaveRecordParameters recordParams = (SaveRecordParameters) JSON.deserialize(recordParameters, SaveRecordParameters.class);
            
            String recordID = recordParams.recordID;
            String accountID = recordParams.accountID;
            List<String> productIDList = recordParams.productIDList;
            List<String> productRemarkList = recordParams.productRemarkList;
            List<String> productComment = recordParams.productComment;
            String buttonName = recordParams.buttonName;
            Date recordDate = recordParams.recordDate;
            
            if (String.isNotBlank(accountID) && productIDList.size() > 0) {
                
                if (String.isBlank(String.valueOf(recordDate))) {
                    recordDate = Date.today();
                }
                
                CAP_Availability__c subActivityRep = new CAP_Availability__c();
                
                if (String.isBlank(recordID)) {
                    
                    subActivityRep = new CAP_Availability__c(Account__c = accountID,
                                                                 Date__c = recordDate,
                                                                 RecordTypeId = Schema.SObjectType.CAP_Availability__c.getRecordTypeInfosByName().get('CAP Report').getRecordTypeId()
                                                                );
                    
                    if (buttonName.contains('draftRecord')) {
                        subActivityRep.Status__c = 'Draft';
                    }
                    
                    if (buttonName.contains('submittedRecord')) {
                        subActivityRep.Status__c = 'Submitted';
                    }
                    
                    insert subActivityRep;
                    
                }
                
                else {
                    
                    subActivityRep = [SELECT Id,
                                      		 Account__c,
                                      		 Date__c,
                                      		 Status__c
                                      FROM CAP_Availability__c
                                      WHERE (Id = :recordID)
                                     ];
                    
                    subActivityRep.Account__c = accountID;
                    subActivityRep.Date__c = recordDate;
                    
                    if (buttonName.contains('draftRecord')) {
                        subActivityRep.Status__c = 'Draft';
                    }
                    
                    if (buttonName.contains('submittedRecord')) {
                        subActivityRep.Status__c = 'Submitted';
                    }
                    
                    update subActivityRep;
                    
                }
                
                List<CAP_Availability_Line_Item__c> subActivityReportLineItemList = new List<CAP_Availability_Line_Item__c>();
                
                Integer count = 0;
                for (String productIDRec : productIDList) {
                    CAP_Availability_Line_Item__c subActivityReportLineItem = new CAP_Availability_Line_Item__c(Product__c = productIDRec,
                                                                                                      RecordTypeId = Schema.SObjectType.CAP_Availability_Line_Item__c.getRecordTypeInfosByName().get('CAP Report').getRecordTypeId(),
                                                                                                      Sub_Activity_Report__c = subActivityRep.Id,
                                                                                                      Remarks__c = productRemarkList[count],
                                                                                                      Comment__c = productComment[count]
                                                                                                     );
                    subActivityReportLineItemList.add(subActivityReportLineItem);
                    count = count + 1;
                }
                
                if (String.isBlank(recordID)) {
                    insert subActivityReportLineItemList;
                }
                
                else {
                    
                    List<CAP_Availability_Line_Item__c> oldSARL = [SELECT Id,
                                                               		  Sub_Activity_Report__c,
                                                               		  Product__c
                                                               FROM CAP_Availability_Line_Item__c
                                                               WHERE (Sub_Activity_Report__c = :recordID)
                                                              ];
                    
                    if(oldSARL.size() == subActivityReportLineItemList.size()){
                        Boolean proceedDelete = false;
                        for(CAP_Availability_Line_Item__c existingSARL : oldSARL){
                            if(proceedDelete == false){
                                for(CAP_Availability_Line_Item__c newSARL : subActivityReportLineItemList){
                                    if(newSARL.Product__c != existingSARL.Product__c){
                                        proceedDelete = true;
                                    }else{
                                        proceedDelete = false;
                                        break;
                                    }   
                                }
                            }else{
                                break;
                            }
                        }
                        
                        if(proceedDelete == true){
                            delete oldSARL;
                            insert subActivityReportLineItemList;
                        }
                    }else{
                        delete oldSARL;
                        insert subActivityReportLineItemList;
                    }
                    
                    
                    
                }
                
                return subActivityRep.Id;
                
            }
            
            else {
                
                return null;
                
            }
            
        }
        
        else {
            
            return null;
            
        }
        
    }
    
    //Get SAR Details
    @AuraEnabled
    public static SARDetails getSubActivityReportDetails(String recordID) {
        
        SARDetails sarDetails = new SARDetails();
        
        CAP_Availability__c saReport = [SELECT Account__c,
                                            	   Date__c,
                                            	   Status__c
                                            FROM CAP_Availability__c
                                            WHERE (Id = :recordID)
                                            LIMIT 1
                                           ];
        
        Account acctRec1 = [SELECT Id,
                            	   Name,
                            	   Branch_Code__c
                            FROM Account
                            WHERE (Id = :saReport.Account__c)
                            LIMIT 1
                           ];
        
        sarDetails.acctRec = acctRec1;
        sarDetails.recordDate = saReport.Date__c;
        sarDetails.status = saReport.Status__c;
        
        return sarDetails;
        
    }    
}