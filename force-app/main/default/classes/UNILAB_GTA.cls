public class UNILAB_GTA {
    
    @AuraEnabled
    public static string fetch(string recordID){
        
       List<Event> oEvent = [SELECT Id, Related_To_Account__c FROM Event WHERE Id=:recordID];
        
       return oEvent[0].Related_To_Account__c;
       
        /*List<Event> oEvent = [SELECT Related_To_Account__c FROM Event WHERE Id=:recordID
                                         ];
       
       List<String> oEvent2 = new List<String>();
        
        for(Event oEvent3 : oEvent){
            oEvent2.add(oEvent3.Related_To_Account__c);
        }
        return oEvent2[0];*/
        
    }
    
	@AuraEnabled
    public static void fetchAndSave(string recordID){
        String userId = userInfo.getUserId();
        DateTime todayDate = DateTime.now() ;
        
        Event oEvent = [SELECT Id, GTA_Started_At__c FROM Event WHERE Id=:recordID
                                     		Limit 1
                                         ];
        oEvent.GTA_Started_At__c=todayDate;
        update oEvent;
        
    }
    /*
    @AuraEnabled
    public static void getCityName (string recordID, Decimal latitude, Decimal longitude) {
        
        Http h = new Http();
		HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        
		// this will fail unless you set up https://maps.googleapis.com/ in your remote site settings
        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?latlng=' + latitude + ',' + longitude + '&sensor=true');
		HttpResponse res = h.send(req);
        
         // you can either deserialize to a class type, or untyped, as I've done here. 
        Map<String,Object> gr = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
		List<Object> results = (List<Object>)gr.get('results');
        Map<String,Object> firstResult = (Map<String,Object>)results[0]; // just taking the first one for this example
        
        // initialize your street address variables
        String streetNumber;
        String streetName;
        
		List<Object> firstAddressComponents = (List<Object>)firstResult.get('address_components'); 
        Map<String,Object> streetNumberComp = (Map<String,Object>)firstAddressComponents[0];
        streetNumber = String.valueOf(streetNumberComp.get('short_name'));
        Map<String,Object> streetNameComp = (Map<String,Object>)firstAddressComponents[1];
        streetName = String.valueOf(streetNameComp.get('short_name'));
        
        Event oEvent = [SELECT Id, GTA_Location__c FROM Event WHERE Id=:recordID
                                     		Limit 1
                                         ];
        
        //oEvent.GTA_Location__c='TEST' + streetNumber + ' ' + streetName;
        oEvent.GTA_Location__c=String.valueOf(latitude);
        update oEvent;
        /*Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        String endpoint = 'https://docsample.herokuapp.com/jsonSample';
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        // The response is in JSON format.
        HttpResponse response = httpProtocol.send(request);
        
        String url = 'http://maps.googleapis.com/maps/api/geocode/json?latlng=' + latitude + ',' + longitude + '&sensor=true';
        JSONParser jsonobj = new JSONParser(url);
        String status = jsonObj.getString('status');
        System.debug(status);
        
        JsonReader addressComponentObj = null;
        String locality= null;
        String adminAreaLevel2= null;
        List<Object> types = null;
        
        for(Object obj : jsonObj.getList('results[0].address_components')) {
            addressComponentObj = new JsonReader(obj);
            types = addressComponentObj.getList('types');
            for(Object typeObj : types) {
                String type = (String) typeObj;
                if (type.equalsIgnoreCase('locality')) {
                    locality = addressComponentObj.getString('long_name');
                }
                if (type.equalsIgnoreCase('administrative_area_level_2')) {
                    adminAreaLevel2 = addressComponentObj.getString('short_name');
                }
            }
        }
        return (locality + ', ' + adminAreaLevel2);
    }*/
}