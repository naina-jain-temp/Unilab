/*-------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   04.16.2019
Definition   :   Apex class for retrieving authentication token from UNILAB Server
-------------------------------------------------------------------------------------------*/
public with sharing class UNILAB_PAL_Authentication {
    @AuraEnabled
    public static String getToken(){
        String tokenUrl = 'http://103.125.217.5/connect/token';
        String USERNAME = Label.PAL_Auth_Username;
        String PASSWORD = Label.PAL_Auth_Password;
        String CLIENT_ID = Label.PAL_Auth_Client_ID;
        String CLIENT_SECRET = Label.PAL_Auth_Client_Secret;
        String SCOPE = Label.PAL_Auth_Scope;
        String accessToken; 
        try{
            HttpRequest reqToken = new HttpRequest();
            
            reqToken.setMethod('POST');
            reqToken.setHeader('Content-Type','application/x-www-form-urlencoded');
            reqToken.setBody('grant_type=password' + '&client_id=' + CLIENT_ID + '&client_secret=' + CLIENT_SECRET + '&username=' + USERNAME +'&password=' + PASSWORD +'&scope=' + SCOPE );
            reqToken.setEndpoint(tokenUrl);
            
            Http http = new Http();
            HTTPResponse resp = http.send(reqToken); 
            
            JSONParser parser = JSON.createParser(resp.getBody());   
            
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    String fieldName = parser.getText();
                    parser.nextToken();
                    //System.debug('fieldName'+fieldName);
                    if (fieldName == 'access_token') {
                        accessToken = parser.getText();
                        //System.debug('TOKEN --->' + accessToken);
                    } 
                }
            }
            
        }catch(system.CalloutException e){            
            System.debug('Error '+e);
        }
        
        return accessToken;
    }
}