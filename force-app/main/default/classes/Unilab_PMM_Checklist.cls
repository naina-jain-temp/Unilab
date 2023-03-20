public class Unilab_PMM_Checklist {
    
    @AuraEnabled
    public static List<Warehouse_Checklist__c> getChecklist (String type) {
        
    	List<Warehouse_Checklist__c> Checklist = new List<Warehouse_Checklist__c>();
    	     
            Checklist = [
                    select Type__c, Category__c, Title__c, Section__c, inactive__c 
                    from Warehouse_Checklist__c
                	where Type__c = :type AND inactive__c = false 
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
                	limit 1
                    
            ];
        
    	return wa;
    
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
            		NA__c,
            		No__c,
            		Yes__c,
            		Year__c,
            		type__c
                    from WarehouseAssessment__c
                	where type__c = :type AND Account__c = :accountId AND Period__c = :period AND Year__c = :year
                    
            ];
    	return wa;
    }
    
    @AuraEnabled
    public static String saveWarehouseAssessment (Map <String, String> checklist, String recordId, String year, String period, Integer lineno) {
        
        WarehouseAssessment__c warehouseAssessment = new WarehouseAssessment__c();
        
        Boolean ratingYes = false; 
        Boolean ratingNo = false; 
        Boolean ratingNa = false; 
        
        if (checklist.get('rating_yes') != null ) ratingYes = Boolean.valueOf(checklist.get('rating_yes')); 
        if (checklist.get('rating_no') != null ) ratingNo = Boolean.valueOf(checklist.get('rating_no')); 
        if (checklist.get('rating_na') != null ) ratingNa = Boolean.valueOf(checklist.get('rating_na')); 
        
        warehouseAssessment = new WarehouseAssessment__c (
            Account__c = recordId,
            Title__c = checklist.get('title'),
            Section__c = checklist.get('section'),
        	Category__c = checklist.get('category'),
            Period__c = period,
            Yes__c = ratingYes,
            No__c = ratingNo,
            NA__c = ratingNa,
            Remarks__c = checklist.get('remarks'),
            Year__c = year,
            type__c = checklist.get('type'),
            Line_No__c = lineno
        );
        
        insert warehouseAssessment;
        return warehouseAssessment.Id;
        
    }
    
    
}