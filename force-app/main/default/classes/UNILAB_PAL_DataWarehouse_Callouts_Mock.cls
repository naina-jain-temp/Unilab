/*----------------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   06.14.2019
Definition   :   Mock Test Class for UNILAB_PAL Data Warehouse Callout
-----------------------------------------------------------------------------------------------------*/
@isTest
global class UNILAB_PAL_DataWarehouse_Callouts_Mock implements HttpCalloutMock {
    
    
      Boolean  isMockResponseSuccessful;  // set by constructor, used to vary the mockresponse
    
      public UNILAB_PAL_DataWarehouse_Callouts_Mock(Boolean isMockResponseSuccessful) {
        this.isMockResponseSuccessful  = isMockResponseSuccessful;
      }   
    
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        //Initiating Fake Response to a Apex Callout Class
		String respBodyPos = '{ "data": [ { "channel": "Modern Trade", "team": "Modern Trade 1", "account_group": "7-ELEVEN", "sfa_internal_id": "0010w000005VYruAAG", "branch_id": "0030009262", "item_code": "155568", "qty": 14016, "amount": 236029.44, "ms": 0, "period": "201812", "measure_category": "SALES", "measure_type": "SELLIN", "measure_level": "P3" }, { "channel": "Modern Trade", "team": "Modern Trade 1", "account_group": "7-ELEVEN", "sfa_internal_id": "0010w000005VYruAAG", "branch_id": "0030009262", "item_code": "155568", "qty": 60288, "amount": 933861.12, "ms": 0, "period": "201812", "measure_category": "SALES", "measure_type": "SELLIN", "measure_level": "LYTD" } ], "success": 1, "errormessage": "" }'; 
        String respBodyNega = '{"data":"","success":0,"errormessage":"Oops. No available data."}'; 
       
        // Create a fake response
        HttpResponse res = new HttpResponse();
        
        
       	//For Positive Testing of Mock Test 
        if(isMockResponseSuccessful){
 		res.setHeader('Content-Type','application/json');
        res.setBody(respBodyPos);            
        res.setStatusCode(200);  
            
            
       	//For Negative Testing of Mock Test     
        }else if(!isMockResponseSuccessful){
 		res.setHeader('Content-Type','application/json');
        res.setBody(respBodyNega);            
        res.setStatusCode(200);            
            	
            	//Throwing Error if the Mock has an Error Exception
                CalloutException e = (CalloutException)CalloutException.class.newInstance();
                e.setMessage('Error '+e);
                throw e;            
                    
            }
          
		return res;
    }
}