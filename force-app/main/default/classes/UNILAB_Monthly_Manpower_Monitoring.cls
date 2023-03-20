public class UNILAB_Monthly_Manpower_Monitoring {
	@AuraEnabled
    public static List<Warehouse_Checklist__c> getChecklist (String type, String category, String accountId) {
        
    	List<Warehouse_Checklist__c> Checklist = new List<Warehouse_Checklist__c>();
    	     
            Checklist = [
                    select Type__c, Category__c, Title__c, Required_Size__c, inactive__c, 	Summary_Included__c
                    from Warehouse_Checklist__c
                	where Type__c = :type AND Category__c = :category AND inactive__c = false AND Account__c =:accountId
                   
            ];
        
    	return Checklist;
    
    }
    
    @AuraEnabled
    public static List<Contact> getContacts (String category, List<String> names, String accountId) {
        
    	List<Contact> Contact = new List<Contact>();
    	     
        if (category != null) {
            
            Contact = [
                    select Name,Category__c,Position__c
                    from Contact
                    Where Category__c = :category AND Active__c = true AND AccountId =:accountId
            ];
        } else {
            Contact = [
                    select Name,Category__c,Position__c
                    from Contact
                    Where Active__c = true AND 	Id IN :names AND AccountId =:accountId
            ];
        }
        
    	return Contact;
    
    }
    
    @AuraEnabled
    public static List<Trucks__c> getTrucks (List<String> names) {
        
    	List<Trucks__c> trucks = new List<Trucks__c>();
    	     
        if (!names.isEmpty()) {
             trucks = [
                    select Brand__c, Plate_No__c, Capacity__c, Transport_Type__c
                    from Trucks__c
                    Where Id IN :names
            ];
            
        }else {
           trucks = [
                    select Brand__c, Plate_No__c, Capacity__c, Transport_Type__c
                    from Trucks__c
            ];
        }
            
    	return trucks;
    
    }
    
    @AuraEnabled
    public static List<WarehouseAssessment__c> getLastMonthRecord (String type, String month, String year, String recordId) {
        
    	List<WarehouseAssessment__c> wa = new List<WarehouseAssessment__c>();
    	     
            wa = [
                    select Account__c,
                		   Category__c,
                 		   Title__c,
                           Required_Size__c,
                           ActualSize__c,
                           Deficit__c,
                           Rating__c,
                           Remarks__c,
                		   selected_Value__c
                    from WarehouseAssessment__c
                    Where Type__c = :type AND Account__c = :recordId AND Period__c = :month AND Year__c = :year
                    ORDER BY Category__c
            ];
        
    	return wa;
    
    }
    
    @AuraEnabled
    public static List<WarehouseAssessment__c> checkThisMonthRecord (String type, String month, String year, String recordId) {
        
    	List<WarehouseAssessment__c> wa = new List<WarehouseAssessment__c>();
    	     
            wa = [
                    select Id
                    from WarehouseAssessment__c
                    Where Type__c = :type AND Account__c = :recordId AND Period__c = :month AND Year__c = :year
                    
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
            		Category__c,
            		Period__c,
            		ActualSize__c,
            		Deficit__c,
            		Required_Size__c,
            		Remarks__c,
            		Year__c,
            		type__c
                    from WarehouseAssessment__c
                	where type__c = :type AND Account__c = :accountId AND Period__c = :period AND Year__c = :year
                    
            ];
    	return wa;
    } 
    @AuraEnabled
    public static String saveWarehouseAssessment (Map <String, String> checklist, String recordId, String year, String period) {
        
        WarehouseAssessment__c warehouseAssessment = new WarehouseAssessment__c();
        
        warehouseAssessment = new WarehouseAssessment__c (
            Account__c = recordId,
            Title__c = checklist.get('position'),	
        	ActualSize__c = Integer.ValueOf(checklist.get('actual')),
            Required_Size__c = Integer.ValueOf(checklist.get('required')),
        	Category__c = checklist.get('category'),
            Deficit__c = Integer.ValueOf(checklist.get('deficit')),
            Period__c = period,
            Rating__c = Integer.ValueOf(checklist.get('rating')),
            Remarks__c = checklist.get('remarks'),
            Year__c = year,
            type__c = checklist.get('type'),
            selected_Value__c = String.valueOf(checklist.get('object'))
        );
        
        insert warehouseAssessment;
        return warehouseAssessment.id;
        
    }
}