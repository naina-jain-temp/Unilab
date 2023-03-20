@isTest
private class UNILAB_CDS_Warehouse_Checklist_Test {
	
    @isTest static void loadchecklist () {
        
        Account newAccount = new Account(); 
       		newAccount.Name = 'Account 1';
            newAccount.Branch_Code__c = 'Branch 1';
        	newAccount.Bill_To_Code__c = '1234567890';    
        
            insert newAccount;
        
        Warehouse_Checklist__c getField = new Warehouse_Checklist__c(); 
        getField.Type__c = 'Warehouse Assessment';
        getField.Account__c = newAccount.Id;
        getField.Category__c = 'Functional Areas';
        getField.Title__c = 'Receiving';
        getField.Required_Size__c = 30;
        getField.inactive__c = false;
       	insert getField;
        
        Test.startTest();
        	List<Warehouse_Checklist__c> getLoadChecklist = UNILAB_CDS_Warehouse_Checklist.loadChecklist('Warehouse Assessment', 'Functional Areas', newAccount.Id);
        Test.stopTest();
        system.assert(getLoadChecklist.size() > 0);       
    }
    
    @isTest static void retrieveAssessment () {
    	
         Account newAccount = new Account(); 
       		newAccount.Name = 'Account 1';
            newAccount.Branch_Code__c = 'Branch 1';
        	newAccount.Bill_To_Code__c = '1234567890';    
        
            insert newAccount;
        
        WarehouseAssessment__c getField = new WarehouseAssessment__c(); 
       		getField.Account__c = newAccount.Id;
            getField.Type__c = 'Warehouse Assessment';
            getField.Category__c = 'Functional Areas';
            getField.Title__c = 'Receiving';
            getField.Year__c = '2022';
            getField.Period__c = 'Sem 1';
            getField.Remarks__c = 'Draft 1';
            getField.ActualSize__c = 30;
            getField.is_Draft__c = false;
            getField.Rating__c = 1;
            getField.Required_Size__c = 30;
            getField.Deficit__c = 0;
            insert getField;
        
        Test.startTest();
        	List<WarehouseAssessment__c> getDraftData = UNILAB_CDS_Warehouse_Checklist.retrieveAssessment('Warehouse Assessment', 'Sem 1', '2022', newAccount.Id, false);
        Test.stopTest();               
        system.assert(getDraftData.size() > 0);       

    }
        
     @isTest static void saveAssessment () {
         
           Account newAccount = new Account(); 
       		newAccount.Name = 'Account 1';
            newAccount.Branch_Code__c = 'Branch 1';
        	newAccount.Bill_To_Code__c = '1234567890';            
            insert newAccount;
        
        
        Test.startTest();
        	String savedData = UNILAB_CDS_Warehouse_Checklist.saveAssessment(newAccount.Id, '2022', 'Sem 1', '31', '30', '1', 'Receiving', 'Functional Areas', '1', 'Draft 1', 'Warehouse Assessment', false);
        Test.stopTest();               
        system.assert(savedData != null);       
                  
    }
    
       @isTest static void saveDraftData () {
           
         Account newAccount = new Account(); 
       		newAccount.Name = 'Account 1';
            newAccount.Branch_Code__c = 'Branch 1';
        	newAccount.Bill_To_Code__c = '1234567890';    
        
            insert newAccount;           
           
            Test.startTest();
        	String getDraftData = UNILAB_CDS_Warehouse_Checklist.saveDraftData(newAccount.Id, '2022', 'Sem 1', '30', '30', '0', 'Receiving', 'Functional Areas', '1', 'Draft 1', 'Warehouse Assessment', true);
            Test.stopTest();               
            system.assert(getDraftData != null);    
                                             
		}
    
    @isTest static void checkThisSemesterRecord () {
         
        Account newAccount = new Account(); 
       		newAccount.Name = 'Account 1';
            newAccount.Branch_Code__c = 'Branch 1';
        	newAccount.Bill_To_Code__c = '1234567890';    
         
        insert newAccount;
        
        WarehouseAssessment__c checkSemester = new WarehouseAssessment__c(); 
        	checkSemester.Account__c = newAccount.Id;
            checkSemester.Type__c = 'Warehouse Assessment';
          	checkSemester.Year__c = '2022';
            checkSemester.Period__c = 'Sem 1';
        	checkSemester.is_Draft__c = false;
        insert checkSemester;
        
         Test.startTest();
        	List<WarehouseAssessment__c> getSemester = UNILAB_CDS_Warehouse_Checklist.checkThisSemesterRecord('Warehouse Assessment', 'Sem 1', '2022', newAccount.Id);
        Test.stopTest();               
        system.assert(getSemester.size() > 0);       
        
        
    }
    
    @isTest static void retrieveSavedAssessment () {
         
        Account newAccount = new Account(); 
       		newAccount.Name = 'Account 1';
            newAccount.Branch_Code__c = 'Branch 1';
        	newAccount.Bill_To_Code__c = '1234567890';    
         
        insert newAccount;
        
        WarehouseAssessment__c checkSemester = new WarehouseAssessment__c(); 
        	checkSemester.Account__c = newAccount.Id;
            checkSemester.Type__c = 'Warehouse Assessment';
            checkSemester.Category__c = 'Functional Areas';
            checkSemester.Title__c = 'Receiving';
            checkSemester.Year__c = '2022';
            checkSemester.Period__c = 'Sem 1';
            checkSemester.Remarks__c = 'Draft 1';
            checkSemester.ActualSize__c = 30;
            checkSemester.is_Draft__c = false;
            checkSemester.Rating__c = 1;
            checkSemester.Required_Size__c = 30;
            checkSemester.Deficit__c = 0;
        insert checkSemester;
        
         Test.startTest();
        	List<WarehouseAssessment__c> getSemester = UNILAB_CDS_Warehouse_Checklist.retrieveSavedAssessment('Warehouse Assessment', 'Sem 1', '2022', newAccount.Id);
        Test.stopTest();               
        system.assert(getSemester.size() > 0);       
        
        
    }
            
}