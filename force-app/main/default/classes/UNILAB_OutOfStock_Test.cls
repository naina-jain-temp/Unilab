@isTest
private class UNILAB_OutOfStock_Test {
    
    @isTest
    private static void getAllProducts() {
        
        List<Product2> prod2List = TestDataFactory.createProducts(20);
        
        insert prod2List;
        
        Test.startTest();
        
        List<UNILAB_OutOfStock.ProductListWrapper> productWrapperList = UNILAB_OutOfStock.getProducts(null);
        
        Test.stopTest();
        
        System.assert(productWrapperList.size() > 0);
        
        for (Integer i = 0; i < productWrapperList.size(); i++) {
            System.assertEquals(productWrapperList[i].isChecked, false);
            System.assert(String.isNotBlank(productWrapperList[i].prod2.Name));
        }
        
    }
    
    @isTest
    private static void getSubActivityLineItemWithProduct() {
        
        Account accountRec =  TestDataFactory.createSingleAccount('Test Account');
        
        insert accountRec;
        
        Date recordDate = Date.today();
        
        List<Product2> prod2List = TestDataFactory.createProducts(20);
        
        insert prod2List;
        
        Out_of_Stock_Capture__c subActivityRep = new Out_of_Stock_Capture__c(Account__c = accountRec.Id,
                                                                           Date__c = recordDate,
                                                                           RecordTypeId = Schema.SObjectType.Out_of_Stock_Capture__c.getRecordTypeInfosByName().get('Availability Report').getRecordTypeId()
                                                                          );
        
        insert subActivityRep;
        
        Out_of_Stock_Line_Item__c subActivityReportLineItem = new Out_of_Stock_Line_Item__c(Product__c = prod2List[0].Id,
                                                                                                          RecordTypeId = Schema.SObjectType.Out_of_Stock_Line_Item__c.getRecordTypeInfosByName().get('Availability Report').getRecordTypeId(),
                                                                                                          Sub_Activity_Report__c = subActivityRep.Id
                                                                                                         );
        
        insert subActivityReportLineItem;
        
        Test.startTest();
        
        List<UNILAB_OutOfStock.ProductListWrapper> productWrapperList = UNILAB_OutOfStock.getProducts(subActivityRep.Id);
        
        Test.stopTest();
        
        System.assert(productWrapperList.size() > 0);
        
        for (Integer i = 0; i < productWrapperList.size(); i++) {
            if (productWrapperList[i].prod2.Id == prod2List[0].Id) {
                System.assertEquals(productWrapperList[i].isChecked, true);
            }
            else {
                System.assertEquals(productWrapperList[i].isChecked, false);
            }
            System.assert(String.isNotBlank(productWrapperList[i].prod2.Name));
        }
        
    }
    
    @isTest
    private static void getSARDetails() {
        
        Account accountRec =  TestDataFactory.createSingleAccount('Test Account');
        
        insert accountRec;
        
        Date recordDate = Date.today();
        
        List<Product2> prod2List = TestDataFactory.createProducts(20);
        
        insert prod2List;
        
        Out_of_Stock_Capture__c subActivityRep = new Out_of_Stock_Capture__c(Account__c = accountRec.Id,
                                                                           Date__c = recordDate,
                                                                           RecordTypeId = Schema.SObjectType.Out_of_Stock_Capture__c.getRecordTypeInfosByName().get('Availability Report').getRecordTypeId(),
                                                                           Status__c = 'Submitted'
                                                                          );
        
        insert subActivityRep;
        
        Out_of_Stock_Line_Item__c subActivityReportLineItem = new Out_of_Stock_Line_Item__c(Product__c = prod2List[0].Id,
                                                                                                          RecordTypeId = Schema.SObjectType.Out_of_Stock_Line_Item__c.getRecordTypeInfosByName().get('Availability Report').getRecordTypeId(),
                                                                                                          Sub_Activity_Report__c = subActivityRep.Id
                                                                                                         );
        
        insert subActivityReportLineItem;
        
        Test.startTest();
        
        UNILAB_OutOfStock.SARDetails sarDetailsList = UNILAB_OutOfStock.getSubActivityReportDetails(subActivityRep.Id);
        
        Test.stopTest();
        
        System.assert(sarDetailsList != null);
        System.assert(sarDetailsList.acctRec.Id == subActivityRep.Account__c);
        System.assert(sarDetailsList.recordDate == subActivityRep.Date__c);
        System.assert(sarDetailsList.status == subActivityRep.Status__c);
        
    }
    
    @isTest
    private static void submitRecordWithoutRecordIDDraft() {
        
        Account accountRec =  TestDataFactory.createSingleAccount('Test Account');
        
        insert accountRec;
        
        Date recordDate = Date.today();
        
        List<Product2> prod2List = TestDataFactory.createProducts(20);
        
        insert prod2List;
        
        List<String> prod2IDList = new List<String>();
        
        for (Product2 prod2Rec : prod2List) {
            prod2IDList.add(prod2Rec.Id);
        }
        
        UNILAB_OutOfStock.SaveRecordParameters saveParameters = new UNILAB_OutOfStock.SaveRecordParameters();
        
        saveParameters.recordID = null;
        saveParameters.accountID = accountRec.Id;
        saveParameters.productIDList = prod2IDList;
        saveParameters.buttonName = 'draftRecord';
        saveParameters.recordDate = recordDate;
        
        Test.startTest();
        
        String recordID = UNILAB_OutOfStock.submitRecord(JSON.serialize(saveParameters));
        
        Test.stopTest();
        
        Out_of_Stock_Capture__c subActRepID = [SELECT Id,
                                              		 Account__c,
                                              		 Date__c,
                                              		 Status__c
                                              FROM Out_of_Stock_Capture__c
                                              LIMIT 1
                                             ];
        
        List<Out_of_Stock_Line_Item__c> subActRepLineList = [SELECT Product__c
                                                                    FROM Out_of_Stock_Line_Item__c
                                                                    WHERE (Sub_Activity_Report__c = :subActRepID.Id)
                                                                   ];
        
        System.assert(subActRepID != null);
        System.assert(String.isNotBlank(recordID));
        System.assert(recordID == subActRepID.Id);
        System.assert(subActRepID.Account__c == accountRec.Id);
        System.assert(subActRepID.Date__c == recordDate);
        System.assert(subActRepID.Status__c == 'Draft');
        
        System.assert(subActRepLineList.size() > 0);
        
        for (Integer i = 0; i < subActRepLineList.size(); i++) {
            System.assert(prod2IDList.contains(subActRepLineList[i].Product__c));
        }
        
    }
    
    @isTest
    private static void submitRecordWithoutRecordIDSubmitted() {
        
        Account accountRec =  TestDataFactory.createSingleAccount('Test Account');
        
        insert accountRec;
        
        Date recordDate = Date.today();
        
        List<Product2> prod2List = TestDataFactory.createProducts(20);
        
        insert prod2List;
        
        List<String> prod2IDList = new List<String>();
        
        for (Product2 prod2Rec : prod2List) {
            prod2IDList.add(prod2Rec.Id);
        }
        
        UNILAB_OutOfStock.SaveRecordParameters saveParameters = new UNILAB_OutOfStock.SaveRecordParameters();
        
        saveParameters.recordID = null;
        saveParameters.accountID = accountRec.Id;
        saveParameters.productIDList = prod2IDList;
        saveParameters.buttonName = 'submittedRecord';
        saveParameters.recordDate = recordDate;
        
        Test.startTest();
        
        String recordID = UNILAB_OutOfStock.submitRecord(JSON.serialize(saveParameters));
        
        Test.stopTest();
        
        Out_of_Stock_Capture__c subActRepID = [SELECT Id,
                                              		 Account__c,
                                              		 Date__c,
                                              		 Status__c
                                              FROM Out_of_Stock_Capture__c
                                              LIMIT 1
                                             ];
        
        List<Out_of_Stock_Line_Item__c> subActRepLineList = [SELECT Product__c
                                                                    FROM Out_of_Stock_Line_Item__c
                                                                    WHERE (Sub_Activity_Report__c = :subActRepID.Id)
                                                                   ];
        
        System.assert(subActRepID != null);
        System.assert(String.isNotBlank(recordID));
        System.assert(recordID == subActRepID.Id);
        System.assert(subActRepID.Account__c == accountRec.Id);
        System.assert(subActRepID.Date__c == recordDate);
        System.assert(subActRepID.Status__c == 'Submitted');
        
        System.assert(subActRepLineList.size() > 0);
        
        for (Integer i = 0; i < subActRepLineList.size(); i++) {
            System.assert(prod2IDList.contains(subActRepLineList[i].Product__c));
        }
        
    }
    
    @isTest
    private static void submitRecordWithRecordIDDraft() {
        
        Account accountRec =  TestDataFactory.createSingleAccount('Test Account');
        
        insert accountRec;
        
        Date recordDate = Date.today();
        
        List<Product2> prod2List = TestDataFactory.createProducts(20);
        
        insert prod2List;
        
        List<String> prod2IDList = new List<String>();
        
        for (Product2 prod2Rec : prod2List) {
            prod2IDList.add(prod2Rec.Id);
        }
        
        Out_of_Stock_Capture__c subActivityRep = new Out_of_Stock_Capture__c(Account__c = accountRec.Id,
                                                                           Date__c = recordDate,
                                                                           RecordTypeId = Schema.SObjectType.Out_of_Stock_Capture__c.getRecordTypeInfosByName().get('Availability Report').getRecordTypeId()
                                                                          );
        
        insert subActivityRep;
        
        UNILAB_OutOfStock.SaveRecordParameters saveParameters = new UNILAB_OutOfStock.SaveRecordParameters();
        
        saveParameters.recordID = subActivityRep.Id;
        saveParameters.accountID = accountRec.Id;
        saveParameters.productIDList = prod2IDList;
        saveParameters.buttonName = 'draftRecord';
        saveParameters.recordDate = recordDate;
        
        Test.startTest();
        
        String recordID = UNILAB_OutOfStock.submitRecord(JSON.serialize(saveParameters));
        
        Test.stopTest();
        
        Out_of_Stock_Capture__c subActRepID = [SELECT Id,
                                              		 Account__c,
                                              		 Date__c,
                                              		 Status__c
                                              FROM Out_of_Stock_Capture__c
                                              LIMIT 1
                                             ];
        
        List<Out_of_Stock_Line_Item__c> subActRepLineList = [SELECT Product__c
                                                                    FROM Out_of_Stock_Line_Item__c
                                                                    WHERE (Sub_Activity_Report__c = :subActRepID.Id)
                                                                   ];
        
        System.assert(subActRepID != null);
        System.assert(String.isNotBlank(recordID));
        System.assert(recordID == subActRepID.Id);
        System.assert(subActRepID.Account__c == accountRec.Id);
        System.assert(subActRepID.Date__c == recordDate);
        System.assert(subActRepID.Status__c == 'Draft');
        
        System.assert(subActRepLineList.size() > 0);
        
        for (Integer i = 0; i < subActRepLineList.size(); i++) {
            System.assert(prod2IDList.contains(subActRepLineList[i].Product__c));
        }
        
    }
    
    @isTest
    private static void submitRecordWithRecordIDSubmitted() {
        
        Account accountRec =  TestDataFactory.createSingleAccount('Test Account');
        
        insert accountRec;
        
        Date recordDate = Date.today();
        
        List<Product2> prod2List = TestDataFactory.createProducts(20);
        
        insert prod2List;
        
        List<String> prod2IDList = new List<String>();
        
        for (Product2 prod2Rec : prod2List) {
            prod2IDList.add(prod2Rec.Id);
        }
        
        Out_of_Stock_Capture__c subActivityRep = new Out_of_Stock_Capture__c(Account__c = accountRec.Id,
                                                                           Date__c = recordDate,
                                                                           RecordTypeId = Schema.SObjectType.Out_of_Stock_Capture__c.getRecordTypeInfosByName().get('Availability Report').getRecordTypeId()
                                                                          );
        
        insert subActivityRep;
        
        UNILAB_OutOfStock.SaveRecordParameters saveParameters = new UNILAB_OutOfStock.SaveRecordParameters();
        
        saveParameters.recordID = subActivityRep.Id;
        saveParameters.accountID = accountRec.Id;
        saveParameters.productIDList = prod2IDList;
        saveParameters.buttonName = 'submittedRecord';
        saveParameters.recordDate = recordDate;
        
        Test.startTest();
        
        String recordID = UNILAB_OutOfStock.submitRecord(JSON.serialize(saveParameters));
        
        Test.stopTest();
        
        Out_of_Stock_Capture__c subActRepID = [SELECT Id,
                                              		 Account__c,
                                              		 Date__c,
                                              		 Status__c
                                              FROM Out_of_Stock_Capture__c
                                              LIMIT 1
                                             ];
        
        List<Out_of_Stock_Line_Item__c> subActRepLineList = [SELECT Product__c
                                                                    FROM Out_of_Stock_Line_Item__c
                                                                    WHERE (Sub_Activity_Report__c = :subActRepID.Id)
                                                                   ];
        
        System.assert(subActRepID != null);
        System.assert(String.isNotBlank(recordID));
        System.assert(recordID == subActRepID.Id);
        System.assert(subActRepID.Account__c == accountRec.Id);
        System.assert(subActRepID.Date__c == recordDate);
        System.assert(subActRepID.Status__c == 'Submitted');
        
        System.assert(subActRepLineList.size() > 0);
        
        for (Integer i = 0; i < subActRepLineList.size(); i++) {
            System.assert(prod2IDList.contains(subActRepLineList[i].Product__c));
        }
        
    }
    
    @isTest
    private static void submitRecordNull() {
        
        Test.startTest();
        
        String recordID = UNILAB_OutOfStock.submitRecord(null);
        
        Test.stopTest();
        
        System.assert(String.isBlank(recordID));
        
    }
    
    @isTest
    private static void submitRecordWithoutDateSubmitted() {
        
        Account accountRec =  TestDataFactory.createSingleAccount('Test Account');
        
        insert accountRec;
        
        Date recordDate = Date.today();
        
        List<Product2> prod2List = TestDataFactory.createProducts(20);
        
        insert prod2List;
        
        List<String> prod2IDList = new List<String>();
        
        for (Product2 prod2Rec : prod2List) {
            prod2IDList.add(prod2Rec.Id);
        }
        
        Out_of_Stock_Capture__c subActivityRep = new Out_of_Stock_Capture__c(Account__c = accountRec.Id,
                                                                             Date__c = null,
                                                                             RecordTypeId = Schema.SObjectType.Out_of_Stock_Capture__c.getRecordTypeInfosByName().get('Availability Report').getRecordTypeId()
                                                                            );
        
        insert subActivityRep;
        
        UNILAB_OutOfStock.SaveRecordParameters saveParameters = new UNILAB_OutOfStock.SaveRecordParameters();
        
        saveParameters.recordID = subActivityRep.Id;
        saveParameters.accountID = accountRec.Id;
        saveParameters.productIDList = prod2IDList;
        saveParameters.buttonName = 'submittedRecord';
        saveParameters.recordDate = null;
        
        Test.startTest();
        
        String recordID = UNILAB_OutOfStock.submitRecord(JSON.serialize(saveParameters));
        
        Test.stopTest();
        
        Out_of_Stock_Capture__c subActRepID = [SELECT Id,
                                              		 Account__c,
                                              		 Date__c,
                                              		 Status__c
                                              FROM Out_of_Stock_Capture__c
                                              LIMIT 1
                                             ];
        
        List<Out_of_Stock_Line_Item__c> subActRepLineList = [SELECT Product__c
                                                             FROM Out_of_Stock_Line_Item__c
                                                             WHERE (Sub_Activity_Report__c = :subActRepID.Id)
                                                            ];
        
        System.assert(subActRepID != null);
        System.assert(String.isNotBlank(recordID));
        System.assert(recordID == subActRepID.Id);
        System.assert(subActRepID.Account__c == accountRec.Id);
        System.assert(subActRepID.Date__c == recordDate);
        System.assert(subActRepID.Status__c == 'Submitted');
        
        System.assert(subActRepLineList.size() > 0);
        
        for (Integer i = 0; i < subActRepLineList.size(); i++) {
            System.assert(prod2IDList.contains(subActRepLineList[i].Product__c));
        }
        
    }
    
    @isTest
    private static void submitRecordAccountAndProductNull() {
        
        Account accountRec =  TestDataFactory.createSingleAccount('Test Account');
        
        insert accountRec;
        
        Date recordDate = Date.today();
        
        List<Product2> prod2List = TestDataFactory.createProducts(20);
        
        insert prod2List;
        
        List<String> prod2IDList = new List<String>();
        
        for (Product2 prod2Rec : prod2List) {
            prod2IDList.add(prod2Rec.Id);
        }
        
        UNILAB_OutOfStock.SaveRecordParameters saveParameters = new UNILAB_OutOfStock.SaveRecordParameters();
        
        saveParameters.recordID = null;
        saveParameters.accountID = null;
        saveParameters.productIDList = null;
        saveParameters.buttonName = 'draftRecord';
        saveParameters.recordDate = recordDate;
        
        Test.startTest();
        
        String recordID = UNILAB_OutOfStock.submitRecord(JSON.serialize(saveParameters));
        
        Test.stopTest();
        
        System.assert(String.isBlank(recordID));
        
    }

}