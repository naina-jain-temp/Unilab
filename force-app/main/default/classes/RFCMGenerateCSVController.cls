public class RFCMGenerateCSVController {
    
    @AuraEnabled
    public static String generateCSV(String rfcmId){
        Set<Id> setRFCMIds = new Set<Id>();
        setRFCMIds.add(rfcmId);
        createCSV(setRFCMIds);
        return 'Success';
    }
    
    @future
    public static void createCSV(Set<Id> setRFCMIds){
        String csvColumnHeader = 'Customer Code, Customer Name, RFCM#, OR Number, OR Date, DM Number, Amount, Month/Period, Branch Name, Source Doc Type,Nature Of Deduction, Contract No, Contract Duration, Condition Type, Material, Functional Area, Sales Area, Contract Price \n';   
        List<ContentVersion> listCvs = new List<ContentVersion>();
        for(RFCM__c objRFCM : [Select id,Condition_Type__c,Status__c,Recordtype.name,Name,unilab_Claim_Reference_Number__c,unilab_Start_Date__c,unilab_End_Date__c,unilab_Claim_Description__c From RFCM__c where Id in: setRFCMIds]){
            system.debug('objRFCM::'+objRFCM);
            if(objRFCM.Status__c == 'Credit Approver'){
                // create csv
                List<String> rowList = new List<String>();
                Map<String,List<String>> rowListMap = new Map<String,List<String>>();
                Map<String,string> mapNames = new Map<String,string>();
                //system.debug('Query'+[Select Id,Company__c,Customer_Company__c,Material__r.Sales_Area__c,Customer_Name__c,PPD_Contract__c,PPD_Contract__r.Functional_Area__c,PPD_Description__c,Material__c,unilab_Amount__c,Customer_Code__c,Customer_Name__r.Name,PPD_Contract__r.Name,Material__r.Name From RFCM_line_item__c]);
                for(RFCM_line_item__c objRFCMLineItem : [Select Id,Company__c,Customer_Company__c,Material__r.Sales_Area__c,Customer_Name__c,PPD_Contract__c,PPD_Contract__r.Functional_Area__c,PPD_Description__c,Material__c,unilab_Amount__c,Customer_Code__c,Customer_Name__r.Name,PPD_Contract__r.Name,Material__r.Name From RFCM_line_item__c where RFCM__c =: objRFCM.Id order by Customer_Name__c asc ] ){ 
                    system.debug('objRFCMLineItem'+objRFCMLineItem);
                    if(objRFCMLineItem.Customer_Name__c == null || objRFCMLineItem.Company__c  == null){
                        system.debug('inside null');
                        continue;
                    }
                    if(!rowListMap.containsKey(objRFCMLineItem.Customer_Company__c)){
                        rowList = new List<String>();
                        system.debug('rowList:::'+rowList);
                    }
                    String customerName = objRFCMLineItem.Customer_Name__c != null ? objRFCMLineItem.Customer_Name__r.Name.replaceAll(',','-'): '';    
                    String customerCode = String.isBlank(objRFCMLineItem.Customer_Code__c) ? ' ' :  objRFCMLineItem.Customer_Code__c ;
                    String row  = customerCode
                        + ','
                        + customerName
                        + ','
                        + ((objRFCM.Recordtype.name == 'Multiple Customer') ? objRFCM.Name+'-'+objRFCMLineItem.Customer_Code__c : objRFCM.Name )
                        //+  objRFCM.Name
                        + ','
                        +'N/A'
                        + ',' 
                        +  'N/A'
                        + ',' 
                        + objRFCM.unilab_Claim_Reference_Number__c  
                        + ',' 
                        +  String.valueOf(objRFCMLineItem.unilab_Amount__c) 
                        + ',' 
                        +  'N/A'
                        + ',' 
                        + 'N/A'
                        + ',' 
                        + 'N/A' 
                        + ',' 
                        +  objRFCM.unilab_Claim_Description__c 
                        + ',' 
                        + (objRFCMLineItem.PPD_Contract__c != null && String.isNotBlank(objRFCMLineItem.PPD_Contract__r.Name) ? objRFCMLineItem.PPD_Contract__r.Name : '')
                        + ','
                        +  ( objRFCM.unilab_Start_Date__c.month() + '-' + objRFCM.unilab_Start_Date__c.day() +  '-' + objRFCM.unilab_End_Date__c.year()  + '-' +objRFCM.unilab_Start_Date__c.month() + '-' + objRFCM.unilab_End_Date__c.day() +  '-' + objRFCM.unilab_End_Date__c.year() )
                        //+  (String.valueOf(objRFCM.unilab_Start_Date__c).removeEnd(' 00:00:00') + '-' + String.valueOf(objRFCM.unilab_End_Date__c).removeEnd(' 00:00:00'))
                        + ',' 
                        + objRFCM.Condition_Type__c
                        +','
                        + objRFCMLineItem.Material__r.Name 
                        + ',' 
                        +  (String.isNotBlank(objRFCMLineItem.PPD_Contract__r.Functional_Area__c) ? objRFCMLineItem.PPD_Contract__r.Functional_Area__c : 'S002')
                        + ',' 
                        + objRFCMLineItem.Material__r.Sales_Area__c
                        +','
                        + objRFCMLineItem.PPD_Description__c ;
                    rowList.add(row);
                    if(rowListMap.containskey(objRFCMLineItem.Customer_Company__c)==true){
                        List<String> dummyList = rowListMap.get(objRFCMLineItem.Customer_Company__c);
                        dummyList.add(row);
                        rowListMap.put(objRFCMLineItem.Customer_Company__c,dummyList);
                    }else{
                        rowListMap.put(objRFCMLineItem.Customer_Company__c,new list<String>{row});
                    }
                    system.debug('rowList::'+rowList.size() + 'Company name::' +objRFCMLineItem.Customer_Company__c);
                    //rowListMap.put(objRFCMLineItem.Customer_Company__c,rowList);
                    mapNames.put(objRFCMLineItem.Customer_Company__c,customerName + ' ' + objRFCMLineItem.Company__c );
                    System.debug('mapNames : '+mapNames);
                }
                if(!rowListMap.isEmpty()){
                    for(String customerTeamId:rowListMap.keySet()){
                        system.debug('customerTeamId::'+customerTeamId);
                        List<String> rowListForCustomerTeam = rowListMap.get(customerTeamId);
                        system.debug('rowListForCustomerTeam::'+rowListForCustomerTeam.size());
                        String csvFile = csvColumnHeader + String.join(rowListForCustomerTeam,'\n');
                        system.debug('csvFile::'+csvFile);
                        String fileName = mapNames.get(customerTeamId);
                        fileName = fileName.replace('.', '');
                        ContentVersion cv = createFile(csvFile,'CSV '+fileName,objRFCM.Id);
                   	    listCvs.add(cv);
                    }
                    /*String csvFile = csvColumnHeader + String.join(rowList,'\n');
                    ContentVersion cv = createFile(csvFile,'CSV RFCM-Classification-Program-Mapping',objRFCM.Id);
                    listCvs.add(cv);*/
                }
            }
        }
        
        if(!listCvs.isEmpty()){
            insert listCvs;
            List<ContentDocumentLink> listCDLs = new List<ContentDocumentLink>();
            for(ContentVersion cv : [SELECT Id, ContentDocumentId,Title,Description FROM ContentVersion WHERE Id in: listCvs]){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cv.ContentDocumentId;
                cdl.LinkedEntityId = cv.Description;
                cdl.ShareType = 'V';
                listCDLs.add(cdl);
            }
            if(!listCDLs.isEmpty()){
                insert listCDLs;
            }
        }
        
    } 
    
    private static ContentVersion createFile(String versionData, String title,string description) {
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S'; //denotes it resides on Salesforce
        cv.Title = title + '.csv'; //title of the file
        cv.PathOnClient = title; // full path within Salesforce this can just be the name of file to be in the library
        cv.VersionData = Blob.valueOf(versionData); //file data
        cv.Description = description;
        //insert cv;
        return cv;
    }
}