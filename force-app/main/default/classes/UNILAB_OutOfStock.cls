public class UNILAB_OutOfStock {
    
    public class ProductListWrapper {

		@AuraEnabled public Boolean isChecked { get; set; }
		@AuraEnabled public Product2 prod2 { get; set; }

		public productListWrapper(Boolean isChecked, Product2 prod2) {
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
        @AuraEnabled public String buttonName { get; set; }
        @AuraEnabled public Date recordDate { get; set; }
        
    }
    
    public class SARDetails {
        
        @AuraEnabled public Account acctRec { get; set; }
        @AuraEnabled public Date recordDate { get; set; }
        @AuraEnabled public String status { get; set; }
        
    }
    
    @AuraEnabled
    public static List<ProductListWrapper> getProducts(String recordID) {
        
        System.debug('RECORD ID: ' + recordID);
        
        List<Product2> prod2List = [SELECT Id,
                                    	   Name
                                    FROM Product2
                                    WHERE (IsActive = true)
                                    ORDER BY Name ASC
                                   ];
        
        List<ProductListWrapper> lstProductListWrapper = new List<ProductListWrapper>();
        
        if (String.isNotBlank(recordID)) {
            
            List<Out_of_Stock_Line_Item__c> subActLineItemList = [SELECT Product__c
                                                                  FROM Out_of_Stock_Line_Item__c
                                                                  WHERE (Sub_Activity_Report__c = :recordID)
                                                                 ];
            
            if (subActLineItemList.size() > 0) {
                
                List<String> subActLineItemProdIDsList = new List<String>();
                
                for (Out_of_Stock_Line_Item__c subActLineItemRec : subActLineItemList) {
                    subActLineItemProdIDsList.add(subActLineItemRec.Product__c);
                }
                
                if (subActLineItemProdIDsList.size() > 0) {
                    
                    for (Product2 prod2Rec : prod2List) {
                        
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
            
            if (prod2List.size() > 0) {
                
                for (Product2 prod2Rec : prod2List) {
                    lstProductListWrapper.add(new ProductListWrapper(false, prod2Rec));
                }
                
            }
            
        }
        
        System.debug('PRODUCT LIST WRAPPER SIZE: ' + lstProductListWrapper.size());
        
        return lstProductListWrapper;
        
    }
    
    @AuraEnabled
    public static String submitRecord(String recordParameters) {
        
        if (String.isNotBlank(recordParameters)) {
            
            SaveRecordParameters recordParams = (SaveRecordParameters) JSON.deserialize(recordParameters, SaveRecordParameters.class);
            
            String recordID = recordParams.recordID;
            String accountID = recordParams.accountID;
            List<String> productIDList = recordParams.productIDList;
            String buttonName = recordParams.buttonName;
            Date recordDate = recordParams.recordDate;
            
            if (String.isNotBlank(accountID) && productIDList.size() > 0) {
                
                if (String.isBlank(String.valueOf(recordDate))) {
                    recordDate = Date.today();
                }
                
                Out_of_Stock_Capture__c subActivityRep = new Out_of_Stock_Capture__c();
                
                if (String.isBlank(recordID)) {
                    
                    subActivityRep = new Out_of_Stock_Capture__c(Account__c = accountID,
                                                                 Date__c = recordDate,
                                                                 RecordTypeId = Schema.SObjectType.Out_of_Stock_Capture__c.getRecordTypeInfosByName().get('Availability Report').getRecordTypeId()
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
                                      FROM Out_of_Stock_Capture__c
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
                
                List<Out_of_Stock_Line_Item__c> subActivityReportLineItemList = new List<Out_of_Stock_Line_Item__c>();
                
                for (String productIDRec : productIDList) {
                    
                    Out_of_Stock_Line_Item__c subActivityReportLineItem = new Out_of_Stock_Line_Item__c(Product__c = productIDRec,
                                                                                                                      RecordTypeId = Schema.SObjectType.Out_of_Stock_Line_Item__c.getRecordTypeInfosByName().get('Availability Report').getRecordTypeId(),
                                                                                                                      Sub_Activity_Report__c = subActivityRep.Id
                                                                                                                     );
                    
                    subActivityReportLineItemList.add(subActivityReportLineItem);
                    
                }
                
                if (String.isBlank(recordID)) {
                    insert subActivityReportLineItemList;
                }
                
                else {
                    
                    List<Out_of_Stock_Line_Item__c> oldSARL = [SELECT Id,
                                                               		  Sub_Activity_Report__c,
                                                               		  Product__c
                                                               FROM Out_of_Stock_Line_Item__c
                                                               WHERE (Sub_Activity_Report__c = :recordID)
                                                              ];
                    
                    if(oldSARL.size() == subActivityReportLineItemList.size()){
                        Boolean proceedDelete = false;
                        for(Out_of_Stock_Line_Item__c existingSARL : oldSARL){
                            if(proceedDelete == false){
                                for(Out_of_Stock_Line_Item__c newSARL : subActivityReportLineItemList){
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
    
    @AuraEnabled
    public static SARDetails getSubActivityReportDetails(String recordID) {
        
        SARDetails sarDetails = new SARDetails();
        
        Out_of_Stock_Capture__c saReport = [SELECT Account__c,
                                            	   Date__c,
                                            	   Status__c
                                            FROM Out_of_Stock_Capture__c
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