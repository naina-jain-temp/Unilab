@isTest
global class UNILAB_Housekeeping_Mock implements HttpCalloutMock {
		Boolean isMockResponseSuccessful; 
    
    public UNILAB_Housekeeping_Mock(Boolean isMockResponseSuccessful){
        this.isMockResponseSuccessful = isMockResponseSuccessful;
    }
    
    global HTTPresponse respond(HTTPRequest req){
        
        //Create fake response
        HttpResponse res= new HttpResponse();
        
        if(isMockResponseSuccessful){
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setStatusCode(200);
        }else if (!isMockResponseSuccessful){
            res.setStatusCode(400);
            res.setStatus('Bad request');
            
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('Error'+e);
            throw e;
        }
        
        return res;
    }
}