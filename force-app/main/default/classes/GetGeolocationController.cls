public with sharing class GetGeolocationController {
   
    ApexPages.StandardController sc;

    Public decimal longT{get;set;}
    Public decimal latT{get;set;}

    
    public GetGeolocationController(ApexPages.StandardController sc){
        this.sc = sc;
    }
    
    public PageReference savePositionMethod(){
        Account acc = (Account)sc.getRecord();
        acc.Longitude__c = longT;
        acc.Latitude__c = latT;
        update acc;
        return sc.save();
        //return null;
    }

}