public class UNILAB_Housekeeping {

    public static string param1;
     public static string param2;
     public static string param3;
   
   	@AuraEnabled
    public static List<Warehouse_Checklist__c> loadChecklist (String type, String category) {
        
        List<Warehouse_Checklist__c> Checklist = new List<Warehouse_Checklist__c>();
             
            Checklist = [
                    select Type__c, Category__c, Title__c , inactive__c
                    from Warehouse_Checklist__c
                    where Type__c = :type AND Category__c = :category AND inactive__c = false
                    ORDER BY Category__c ASC
                    // ORDER BY Title__c //  
           			   ];
        
        return Checklist;
    }
    
    
     @AuraEnabled
    public static List<WarehouseAssessment__c> loadAssessment (String type, String accountId, String year , String period ){
   
          List<WarehouseAssessment__c> wa = new List<WarehouseAssessment__c>();			
       wa =[
             select Id,
             Account__c,
             Title__c,
             Category__c,
             Yes__c ,
             No__c ,
             NA__c  ,
             Remarks__c ,
             type__c  ,
             Year__c  ,
             Period__c 
             from WarehouseAssessment__c
             where type__c = :type AND Account__c = :accountId AND Period__c = :period AND Year__c = :year
                    
            ];
    	return wa;

   
    }
    
    @AuraEnabled
    public static Integer getWarehouseAssessment(String recordId, String period, String year){
        return [
            select count() from WarehouseAssessment__c 
            where Period__c = :period
            and Year__c=:year
            and Account__c = :recordId];
        
    }

    @AuraEnabled
    public static String saveWarehouseAssessment (Map <String, String> checklist, String recordId, String period, String year) {
        //string submitted;
        /*WarehouseAssessment__c wa = [
            select id from WarehouseAssessment__c 
            where Period__c = :period
            and Year__c=:year
            and Account__c = :recordId
            
        ];*/
        
           WarehouseAssessment__c warehouseAssessment = new WarehouseAssessment__c();
        
        //if (wa!=null) {
                  
      
        
            warehouseAssessment = new WarehouseAssessment__c (
                Account__c = recordId,
                Title__c = checklist.get('title'),
                Category__c = checklist.get('category'),
                Yes__c = Boolean.ValueOf(checklist.get('Yes')),
                No__c = Boolean.ValueOf(checklist.get('No')),
                NA__c = Boolean.ValueOf(checklist.get('Na')),
                Remarks__c = checklist.get('remarks'),
                type__c = checklist.get('type'),
                Year__c = year,
                Period__c = period
                
                
              
            );
        
            param1=recordId;
            param2=year;
            param3=period;
        
             
            
            insert warehouseAssessment;
            //runApi();
           
            
        
            //submitted = warehouseAssessment.Id;
       // }
       // 

        return warehouseAssessment.Id;
        
    }
    
    @AuraEnabled
    public static string runApi(string acct, string year, string period)
    {
           String res = 'OK';
        try{
            
            String url = 'http://onebsdg-001-site18.itempurl.com/api/Ids/PostRefreshHouskeepingSummary/?sfaInternalId='+acct+'&Month='+period+'&Year='+year;
           /* System.debug(url); */     
        	 Http http = new Http();
 			 HttpRequest request = new HttpRequest();
 		     HttpResponse response;
   		
             request.setEndpoint(url);
            
           /*  request.setbody('sfaInternalId='+acct+'&Month='+period+'&Year='+year);*/
              
 			 request.setMethod('POST');
            
             request.setHeader('Content-Length', '4096');

 			
 			response = http.send(request);
            
            
            
      	  /* System.debug(response); */
            
            
        }
        catch(system.CalloutException e){
          /*  System.debug('Error ' + e); */
            
        }
        return res;
        
    }

    
     @AuraEnabled
    public static List<WarehouseAssessment__c> checkThisMonthRecords (String type, String period, String year, String recordId) {
        
    	List<WarehouseAssessment__c> wa = new List<WarehouseAssessment__c>();
    	     
            wa = [
                    select Id
                    from WarehouseAssessment__c
                    Where Type__c = :type AND Account__c = :recordId AND Period__c = :period AND Year__c = :year
                	limit 1
                    
            ];
        
    	return wa;
    }

}