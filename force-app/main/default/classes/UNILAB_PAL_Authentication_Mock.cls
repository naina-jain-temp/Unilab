/*-------------------------------------------------------------------------------------------
Authors      :   Mark Palacios and Mervin Dequito
Created Date :   06.13.2019
Definition   :   Mock Test class for UNILAB_PAL Authentication
-------------------------------------------------------------------------------------------*/
@isTest
global class UNILAB_PAL_Authentication_Mock implements HttpCalloutMock {
    
    
      Boolean  isMockResponseSuccessful;  // set by constructor, used to vary the mockresponse
    
      public UNILAB_PAL_Authentication_Mock(Boolean isMockResponseSuccessful) {
        this.isMockResponseSuccessful  = isMockResponseSuccessful;
      }    
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {


        // Create a fake response
        HttpResponse res = new HttpResponse();
        
        //For Positive Testing of Mock Test 
        if(isMockResponseSuccessful){
 		res.setHeader('Content-Type','application/x-www-form-urlencoded');
        res.setBody('{"access_token":"f9f3a0590bac07a992fb77de4fdfd939","expires_in":3600,"token_type":"Bearer"}');            
        res.setStatusCode(200);
        
        //For Negative Testing of Mock Test 
        }else if(!isMockResponseSuccessful){
              res.setStatusCode(400);
              res.setStatus('Bad request');
            
            //Throwing Error if the Mock has an Error Exception
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('Error '+e);
            throw e;            
                    
            }
          
		return res;
    }
}