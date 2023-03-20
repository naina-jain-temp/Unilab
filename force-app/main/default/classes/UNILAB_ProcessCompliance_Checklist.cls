public class UNILAB_ProcessCompliance_Checklist {

    @AuraEnabled
    public static List<Warehouse_Checklist__c> getChecklist (String typex) {
        
    	List<Warehouse_Checklist__c> Checklist = new List<Warehouse_Checklist__c>();
    	     
            Checklist = [
                    select Type__c, Category__c, Title__c, Section__c, inactive__c 
                    from Warehouse_Checklist__c
                	where Type__c = :typex
                	ORDER BY Category__c ASC
                    
            ];
        
    	return Checklist;
    
    }
     
    @AuraEnabled
    public static List<WarehouseAssessment__c> checkThisSemesterRecord (String type, String semester, String year, String recordId) {
        
    	List<WarehouseAssessment__c> wa = new List<WarehouseAssessment__c>();
    	     
            wa = [
                    select Id
                    from WarehouseAssessment__c
                    Where Type__c = :type AND Account__c = :recordId AND Period__c = :semester AND Year__c = :year
                    
            ];
        
    	return wa;
    
    }
   	@AuraEnabled
    public static List<WarehouseAssessment__c> loadAssessment (String type, String accountId, String period, String year) {
        
		List<WarehouseAssessment__c> wa = new List<WarehouseAssessment__c>();        
    	wa = [
                    select Id,
            		Account__c,
            		Title__c,
            		Section__c,
            		Category__c,
            		Period__c,
            		Rating__c,
            		Remarks__c,
            		Year__c,
            		type__c
                    from WarehouseAssessment__c
                	where type__c = :type AND Account__c = :accountId AND Period__c = :period AND Year__c = :year
                    
            ];
    	return wa;
    } 
    @AuraEnabled
    public static List<WarehouseAssessment__c> retrieveDraftAssessment (String type, String period, String year, String recordId) {
        
    	List<WarehouseAssessment__c> Assessment = new List<WarehouseAssessment__c>();
    	     
            Assessment = [
                    select Account__c,
                		Type__c, 
                		Category__c,
                        Title__c,
                        Year__c,
                        Period__c,
                        Remarks__c,
                        ActualSize__c,
                        is_Draft__c,
                		Rating__c,
                        Required_Size__c,
                		Deficit__c,
                		Section__c
                    from WarehouseAssessment__c
                	where Type__c = :type AND is_Draft__c = true AND Account__c = :recordId AND Year__c = :year AND Period__c = :period   	
                    
            ];
        
    	return Assessment;
    
    }
    
    @AuraEnabled
    public static String checkWarehouseAssessment (String period, String year) {
        
        
    	return [
                    select Id
                    from WarehouseAssessment__c
                	where Period__c = :period AND Year__c = :year
                    
            ].Id;
    
    }
    
    @AuraEnabled
    public static String saveWarehouseAssessment (Map <String, String> checklist, String recordId, String year, String period, Integer lineno) {
        
        WarehouseAssessment__c warehouseAssessment = new WarehouseAssessment__c();
        
        warehouseAssessment = new WarehouseAssessment__c (
            Account__c = recordId,
            Title__c = checklist.get('title'),
            Section__c = checklist.get('section'),
        	Category__c = checklist.get('category'),
            Period__c = period,
            Rating__c = Integer.ValueOf(checklist.get('rating')),
            Remarks__c = checklist.get('remarks'),
            Year__c = year,
            type__c = checklist.get('type'),
            Line_No__c = lineno
        );
        
        insert warehouseAssessment;
        return warehouseAssessment.Id;
        
    }
    
    
}