/*-------------------------------------------------------------------------------------------
Author       :   Mark Palacios
Created Date :   04.16.2019
Definition   :   Web Service Callout for retrieving UNILAB Sales Data
-------------------------------------------------------------------------------------------*/
global with sharing class UNILAB_PAL_DataWarehouse_Callouts {
    
    @AuraEnabled
    public static List<Temporary_Allocation__c> getAPIResponse(String accessToken, String jsonString, String allocId){
        
        String respCode;
        String endpointURL = 'https://apidev.pals.sncd-bsdg.com/api/WebApiServices/getAllSosi';
        String token = accessToken;
        String jsonRespData;
        
        JSONResponse response = new JSONResponse();
        
        List<Temporary_Allocation__c> lisOfTempAlloc = new List<Temporary_Allocation__c>();
        
        try{
            //REQUEST DATA FROM CALLOUT
            HttpRequest reqData = new HttpRequest();
            
            reqData.setMethod('POST');
            reqData.setHeader('Authorization','Bearer '+token);
            reqData.setHeader('Content-Type','application/json');
            reqData.setEndpoint(endpointURL);
            reqData.setTimeout(100000);
            reqData.setBody(jsonString);
            
            Http http  = new Http();
            HTTPResponse resp = http.send(reqData); 
            
            jsonRespData = resp.getBody();
            
			String errorMessage;
            Integer successInt;
            
            //PARSE TO GET THE SUCCESS VALUE
            JSONParser parser = JSON.createParser(resp.getBody());       
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    String fieldName = parser.getText();
                    parser.nextToken();
                    //System.debug('fieldName'+fieldName);
                    if (fieldName == 'errormessage') {
                        errorMessage = parser.getText();
                        //System.debug('errorMessage --->' + errorMessage);
                    } else if(fieldName == 'success'){
                        successInt = parser.getIntegerValue();
                        //System.debug('successInt --->' + successInt);
                    }
                }
            }
            
            //DESERIALIZE DATA FROM RESPONSE
            if(successInt == 1){
                response = (JSONResponse)JSON.deserialize(jsonRespData,JSONResponse.class);
                lisOfTempAlloc = response.getlisOfTempAlloc();
                respCode = 'SUCCESS';
            }else if(successInt == 0){
                respCode = errorMessage;
            }
            
        }catch(system.CalloutException e){  
            System.debug('Error '+e);
        }
        
        return lisOfTempAlloc;
        
    }
    
    public class JSONDataItems {
        public String channel;
        public String team;
        public String account_group;
        public String sfa_internal_id;
        public String branch_id;
        public String item_code;
        public Double qty;
        public Double amount;
        public Double ms;
        public String period;
        public String measure_category;
        public String measure_type;
        public String measure_level;
        
        public Temporary_Allocation__c getTempAlloc(){
            
            Temporary_Allocation__c tempAlloc = new Temporary_Allocation__c();
            
            tempAlloc.Channel__c = this.channel;
            tempAlloc.Team__c = this.team;
            tempAlloc.Account_Group__c = this.account_group;
            tempAlloc.SFA_Internal_ID__c = this.sfa_internal_id;
            tempAlloc.Branch_ID__c = this.branch_id;
            tempAlloc.Item_Code__c = this.item_code;
            tempAlloc.Quantity__c = this.qty;
            tempAlloc.Amount__c = this.amount;
            tempAlloc.Monthly_Supply__c = this.ms;
            tempAlloc.Period__c = this.period;
            tempAlloc.Measure_Category__c = this.measure_category;
            tempAlloc.Measure_Type__c = this.measure_type;
            tempAlloc.Measure_Level__c = this.measure_level;
            
            return tempAlloc;
        }
        
    }
    
    public class JSONResponse{
        public List<JSONDataItems> data;
        public String success;
        public String errormessage;
        
        public List<Temporary_Allocation__c> getlisOfTempAlloc(){
            
            List<Temporary_Allocation__c> lisOfTempAlloc = new List<Temporary_Allocation__c>();
            for(JSONDataItems items : data){
                lisOfTempAlloc.add(items.getTempAlloc());
            }
            return lisOfTempAlloc;
        }
    }
}