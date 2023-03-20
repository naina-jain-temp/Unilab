public class UNILAB_CDS_Warehouse_Checklist {
    
       @AuraEnabled
    public static List<Warehouse_Checklist__c> loadChecklist (String type, String category, String accountId)

    {        
    	List<Warehouse_Checklist__c> Checklist = new List<Warehouse_Checklist__c>();        
            Checklist = [
                    select Type__c, Category__c, Title__c, Required_Size__c, inactive__c
                    from Warehouse_Checklist__c
                	where Type__c = :type AND Category__c = :category AND inactive__c = false AND Account__c =:accountId
                    limit 20
            ];
                
    	return Checklist;
    }
    
     
    @AuraEnabled
    public static String saveAssessment(String recordId, String year, String period, String actualSize, String requiredSize, String deficit,
									 String title, String category, String ratings, String remarks, String type, Boolean isDraft) {
        
        WarehouseAssessment__c warehouseAssessment = new WarehouseAssessment__c();
        
        warehouseAssessment = new WarehouseAssessment__c (
            Account__c = recordId,
            Title__c = title,	
        	ActualSize__c = Integer.ValueOf(actualSize),
            Required_Size__c = Integer.ValueOf(requiredSize),
        	Category__c = category,
            Deficit__c = Integer.ValueOf(deficit),
            Period__c = period,
            Rating__c = Integer.ValueOf(ratings),
            Remarks__c = remarks,
            Year__c = year,
            type__c = type,
            is_Draft__c = Boolean.ValueOf(isDraft)
        );
        
        insert warehouseAssessment;
        return warehouseAssessment.id;
        
    }
    
 @AuraEnabled
    public static String saveDraftData (String recordId, String year, String period, String actualSize, String requiredSize, String deficit,
									 String title, String category, String ratings, String remarks, String type, Boolean isDraft) {
        
        WarehouseAssessment__c warehouseAssessment = new WarehouseAssessment__c();
        
        warehouseAssessment = new WarehouseAssessment__c (
            
            is_Draft__c = Boolean.ValueOf(isDraft),
            Account__c = recordId,
            Title__c = title,	
        	ActualSize__c = Integer.ValueOf(actualSize),
            Required_Size__c = Integer.ValueOf(requiredSize),
        	Category__c = category,
            Deficit__c = Integer.ValueOf(deficit),
            Period__c = period,
            Rating__c = Integer.ValueOf(ratings),
            Remarks__c = remarks,
            Year__c = year,
            type__c = type
        );
        
        insert warehouseAssessment;
        return warehouseAssessment.id;
        
    }
    
    @AuraEnabled
    public static List<WarehouseAssessment__c> retrieveAssessment (String type, String period, String year, String recordId, Boolean isDraft) {
        
    	List<WarehouseAssessment__c> Assessment = new List<WarehouseAssessment__c>();
    	     
            Assessment = [
                    select Account__c,
                		Type__c, Category__c,
                        Title__c,
                        Year__c,
                        Period__c,
                        Remarks__c,
                        ActualSize__c,
                        is_Draft__c,
                		Rating__c,
                        Required_Size__c,
                		Deficit__c
                    from WarehouseAssessment__c
                	where Type__c = :type AND is_Draft__c = :isDraft AND Year__c = :year AND Period__c = :period AND Account__c = :recordId          	
                    
            ];
        
    	return Assessment;
    
    }
    
     @AuraEnabled
    public static List<WarehouseAssessment__c> checkThisSemesterRecord (String type, String semester, String year, String recordId) {
        
    	List<WarehouseAssessment__c> wa = new List<WarehouseAssessment__c>();
    	     
            wa = [
                    select Id
                    from WarehouseAssessment__c
                    Where Type__c = :type AND Account__c = :recordId AND Period__c = :semester AND Year__c = :year AND is_Draft__c = :false
                    
            ];
        
    	return wa;
    }
    
    
 
    @AuraEnabled
    public static List<WarehouseAssessment__c> retrieveSavedAssessment (String type, String period, String year, String recordId) {
        
    	List<WarehouseAssessment__c> savedAssessment = new List<WarehouseAssessment__c>();
    	     
            savedAssessment = [
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
                		Deficit__c
                    from WarehouseAssessment__c
                	where Type__c = :type AND is_Draft__c = false AND Year__c = :year AND Period__c = :period AND Account__c = :recordId          	
                    
            ];
        
    	return savedAssessment;
    
    }
    
    
}