/**
    * @description : This class used to fetch and insert the values in HAT Allocation Object
*/

public with sharing class UNILAB_HAT_Allocation {
    /**
        * @description : This function used to get HAT Allocation Object Details.
        * @return      : allocationArr
    **/
    @AuraEnabled(cacheable=true)
    public static List<HAT_Allocation__c> fetchHATAllocationDetails(){
        List<HAT_Allocation__c> allocationArr = new List<HAT_Allocation__c>();
        try {
            if (Schema.sObjectType.HAT_Allocation__c.isAccessible()) {
                allocationArr = [SELECT Id, Name, Product__c, Product__r.Name, SKU_SOH_QTY__c, SKU_SOH_Amount__c, CreatedBy.Name, CreatedDate, LastModifiedDate FROM HAT_Allocation__c ORDER BY Id DESC];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return allocationArr;
    }

    /**
        * @description : This function used to get HAT Allocation ID Details.
        * @return      : allocationArr
    **/
    @AuraEnabled(cacheable=false)
    public static List<HAT_Allocation__c> getHATAllocationDetails(String recordId){
        List<HAT_Allocation__c> allocationArr = new List<HAT_Allocation__c>();
        try {
            if (Schema.sObjectType.HAT_Allocation__c.isAccessible()) {
                allocationArr = [SELECT Id, Name, Product__c, Product__r.Name, SKU_SOH_QTY__c, SKU_SOH_Amount__c, CreatedBy.Name, CreatedDate, LastModifiedDate, Account__r.Name, Account__c, Allocation_Type__c, CT_Team_Name__c, Item_Price_w_o_VAT__c FROM HAT_Allocation__c WHERE Id =: recordId];
            }
            //Allocation_Month__c, Storage_Location__c, Product_Allocation_Object_Number__c
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return allocationArr;
    }

    /**
        * @description : This function used to get Product Object Details
        * @param       : productName
        * @return      : allocationArr
    **/
    @AuraEnabled(cacheable=true)
    public static List<Product2> getProductDetails(String productName){
        List<Product2> lstProduct = new List<Product2>();
        String prodName = '%' + productName + '%';
        try {
            if (Schema.sObjectType.Product2.isAccessible()) {
                lstProduct = [SELECT Id, Name FROM Product2 WHERE Name LIKE: prodName];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return lstProduct;
    }

    /**
        * @description : This function used to get Account Object Details
        * @param       : accountName
        * @return      : accountArr
    **/
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountDetails(String accountName){
        List<Account> lstAccount = new List<Account>();
        String acctName = '%' + accountName + '%';
        try {
            if (Schema.sObjectType.Account.isAccessible()) {
                lstAccount = [SELECT Id, Name FROM Account WHERE Name LIKE: acctName];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return lstAccount;
    }

    /**
        * @description : This function used to Read CSV File and Insert Records into Account Object
        * @param       : contentDocumentId
        * @return      : allocationPlanLst
    **/
    @AuraEnabled(cacheable=false)
    public static list<HAT_Allocation_Plan__c> csvFileRead(Id contentDocumentId, Id productId){
        list<HAT_Allocation_Plan__c> allocationPlanLst = new list<HAT_Allocation_Plan__c>();
        if(contentDocumentId != null) {
            // Fetch File Data based on the basic of document id 
            if (Schema.sObjectType.ContentVersion.isAccessible()) {
                ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
                // split the file data
                list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');

                for(Integer i = 1; i < csvRecordsList.size(); i++){
                    HAT_Allocation_Plan__c allocationPlanObj = new HAT_Allocation_Plan__c();
                    list<String> csvRowData = csvRecordsList[i].split(',');
                    allocationPlanObj.Hat_Product__c = productId;
                    allocationPlanObj.CT_Customer_Team_Name__c = 'Customer Team 1';
                    allocationPlanObj.SNCD_Channel__c = csvRowData[0];
                    allocationPlanObj.OB_Target__c = Decimal.valueOf(csvRowData[1]);
                    allocationPlanObj.SOT__c = Decimal.valueOf(csvRowData[2]);
                    allocationPlanObj.Actual_Amount__c = Decimal.valueOf(csvRowData[3]);
                    allocationPlanObj.SOB__c = Decimal.valueOf(csvRowData[4]);
                    allocationPlanObj.w_Allocation__c = csvRowData[5];
                    allocationPlanObj.Initial_Allocation_Qty__c = Decimal.valueOf(csvRowData[6]);
                    allocationPlanObj.Initial_Allocation_Amount__c = Decimal.valueOf(csvRowData[7]);
                    allocationPlanObj.Final_Allocation_Qty__c = Decimal.valueOf(csvRowData[8]);
                    allocationPlanObj.Final_Allocation_Amount__c = Decimal.valueOf(csvRowData[9].trim());
                    allocationPlanLst.add(allocationPlanObj);
                }
                try {
                    if(!allocationPlanLst.isEmpty() && Schema.sObjectType.HAT_Allocation_Plan__c.isCreateable()) {
                        insert allocationPlanLst;
                    }
                } catch (Exception ex) {
                    throw new AuraHandledException(ex.getMessage());
                } 
            }
        }
        return allocationPlanLst;
    }

    /**
        * @description : This function used to Read CSV File and Insert Records into Selected Object
        * @param       : contentDocumentId
        * @param       : objectName
        * @return      : upsertObjLst
    **/
    @AuraEnabled(cacheable=false)
    public static List<sObject> csvFileUpload(Id contentDocumentId, String objectName) {
        List<sObject> upsertObjLst = new List<sObject>();
        System.debug('===conId===' + contentDocumentId);
        System.debug('===objectName===' + objectName);

        if(contentDocumentId != null) {
            // Fetch File Data based on the basic of document id 
            if (Schema.sObjectType.ContentVersion.isAccessible()) {
                ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];

                // split the file data
                List<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');

                if (objectName == 'HAT_Account__c') {
                    for(Integer i = 1; i < csvRecordsList.size(); i++) {
                        HAT_Account__c accObj = new HAT_Account__c();
                        List<String> csvRowData = csvRecordsList[i].split(',');
                        accObj.Distribution_Channel__c = String.valueOf(csvRowData[0]);
                        accObj.Customer_group__c = String.valueOf(csvRowData[1]);
                        accObj.Customer_Group_Description__c = csvRowData[2];
                        accObj.Sold_To_Party__c = String.valueOf(csvRowData[3]);
                        //accObj.Sold_To_Name__c = csvRowData[4]; //How can we handle Account Name check for Sold To Name field and upload it here ?
                        upsertObjLst.add(accObj);
                    }

                    try {
                        Schema.SObjectField externalIDField = HAT_Account__c.Fields.Sold_To_Party__c;
                        Database.UpsertResult[] upsertLst = Database.upsert(upsertObjLst, externalIDField, false);
                    } catch (Exception ex) {
                        throw new AuraHandledException(ex.getMessage());
                    }
                } else if (objectName == 'Product_Allocation__c') {//Hat_Allocation__c
                    for(Integer i = 1; i < csvRecordsList.size(); i++) {
                        Product_Allocation__c allocationObj = new Product_Allocation__c();//Hat_Allocation__c
                        List<String> csvRowData = csvRecordsList[i].split(',');
                        allocationObj.Sales_Org__c = String.valueOf(csvRowData[0]);
                        allocationObj.Material_Number__c = String.valueOf(csvRowData[1]);
                        allocationObj.Material_Description__c = csvRowData[2];
                        allocationObj.Product_Allocation_Object_Number__c = String.valueOf(csvRowData[3]);
                        
                        upsertObjLst.add(allocationObj);
                    }

                    try {
                        Schema.SObjectField externalIDField = Product_Allocation__c.Fields.Material_Number__c;//Hat_Allocation__c
                        Database.UpsertResult[] upsertLst = Database.upsert(upsertObjLst, externalIDField, false);
                        System.debug('===ddd===' + upsertLst);
                    } catch (Exception ex) {
                        throw new AuraHandledException(ex.getMessage());
                    }
                } else if (objectName == 'Storage_Location__c') {
                    for(Integer i = 1; i < csvRecordsList.size(); i++) {
                        Storage_Location__c locationObj = new Storage_Location__c();
                        List<String> csvRowData = csvRecordsList[i].split(',');
                        locationObj.Plant_Code__c = String.valueOf(csvRowData[0]);
                        locationObj.Storage_Location_Code__c = String.valueOf(csvRowData[1]);
                        upsertObjLst.add(locationObj);
                    }

                    try {
                        Schema.SObjectField externalIDField = Storage_Location__c.Fields.Plant_Code__c;
                        Database.UpsertResult[] upsertLst = Database.upsert(upsertObjLst, externalIDField, false);
                        System.debug('===ddd===' + upsertLst);
                    } catch (Exception ex) {
                        throw new AuraHandledException(ex.getMessage());
                    }
                } else if (objectName == 'Cut_Off_Compliance__c') {
                    for(Integer i = 1; i < csvRecordsList.size(); i++) {
                        Cut_Off_Compliance__c complianceObj = new Cut_Off_Compliance__c();
                        List<String> csvRowData = csvRecordsList[i].split(',');
                        complianceObj.Account_Group_Name__c = String.valueOf(csvRowData[0]);
                        complianceObj.OrderDrop__c = String.isBlank(csvRowData[1]) ? null : String.valueOf(csvRowData[1]);
                        complianceObj.Branch_Name__c = String.valueOf(csvRowData[2]);
                        String[] soDateArr = String.valueOf(csvRowData[3]).trim().split('/');
                        String[] deliveryDateArr = String.valueOf(csvRowData[4]).trim().split('/');
                        Date soDate = Date.valueOf(soDateArr[2]+'-'+soDateArr[0]+'-'+soDateArr[1]);
                        Date deliveryDate = Date.valueOf(deliveryDateArr[2]+'-'+deliveryDateArr[0]+'-'+deliveryDateArr[1]);
                        complianceObj.SO_Date__c = soDate;
                        complianceObj.Delivery_Date__c = deliveryDate;
                        upsertObjLst.add(complianceObj);
                    }

                    try {
                        System.debug('==upsertObjLst==' + upsertObjLst);
                        if(!upsertObjLst.isEmpty() && Schema.sObjectType.Cut_Off_Compliance__c.isCreateable()) {
                            insert upsertObjLst;
                        }
                    } catch (Exception ex) {
                        System.debug('===Ex====' + ex.getMessage());
                        throw new AuraHandledException(ex.getMessage());
                    }
                }
            }
        }
        return upsertObjLst;
    }

    /**
        * @description : This function used to Retrieve selected object records
        * @param       : objectName
        * @return      : recordLst
    **/
    @AuraEnabled(cacheable=true)
    public static List<sObject> fetchObjectDetail(String objectName) {
        List<sObject> recordLst = new List<sObject>();

       if (objectName == 'HAT_Account__c') {
            if (Schema.sObjectType.HAT_Account__c.isAccessible()) {
                recordLst = [SELECT Id, Name, Distribution_Channel__c, Customer_group__c, Customer_Group_Description__c, Sold_To_Party__c, Sold_To_Name__r.Name FROM HAT_Account__c ORDER BY ID ASC];
            }
        } else if (objectName == 'Product_Allocation__c') {
            if (Schema.sObjectType.Product_Allocation__c.isAccessible()) {
                recordLst = [SELECT Id, Name, Sales_Org__c, Material_Number__c, Material_Description__c, Product_Allocation_Object_Number__c FROM Product_Allocation__c ORDER BY ID ASC];
            }
        } else if (objectName == 'Storage_Location__c') {
            if (Schema.sObjectType.Storage_Location__c.isAccessible()) {
                recordLst = [SELECT Id, Name, Plant_Code__c, Storage_Location_Code__c FROM Storage_Location__c ORDER BY ID ASC];
            }
        } else if (objectName == 'Cut_Off_Compliance__c') {
            if (Schema.sObjectType.Cut_Off_Compliance__c.isAccessible()) {
                recordLst = [SELECT Id, Name, Account_Group_Name__c, OrderDrop__c, Branch_Name__c, SO_Date__c, Delivery_Date__c FROM Cut_Off_Compliance__c ORDER BY ID ASC];
            }
        }

        /*else if (objectName == 'HAT_Allocation__c') {
            if (Schema.sObjectType.HAT_Allocation__c.isAccessible()) {
                recordLst = [SELECT Id, Name, SalesOrg__c, MaterialNumber__c, MaterialDescription__c, Product_Allocation_Object_Number__c FROM HAT_Allocation__c ORDER BY ID ASC];
            }
        }*/

        return recordLst;
    }

    //Date format conversion
    public static string formatDate(Date d) {
        return d.year() + '-' + d.month() + '-' + d.day();
    }
}