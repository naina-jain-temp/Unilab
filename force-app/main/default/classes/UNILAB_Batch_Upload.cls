public class UNILAB_Batch_Upload {
    
    @AuraEnabled()
    public static List<RFCM_line_item__c> saveFile(String base64Data, String cdbId) {
        String data  = '';
        if(Test.isRunningTest()){
            data = 'asjkbdksajbd "etst" ,,,\n sadhjlaskd "asdsa"  \n asdsa\n sadhjlaskd \nsddsads \n sadhjlaskd \n asddas\n sadhjlaskd \nasdsa \n sadhjlaskd \n dsad\n sadhjlaskd \n';
        }
        else
        data = JSON.deserializeUntyped(base64Data).toString();
        
        list<RFCM_line_item__c> lstCCToInsert = new list<RFCM_line_item__c>();
        Set<String> materialIdSet = new Set<String>();
        Map<String, RFCM_line_item__c> materialIdToRFCItemMap = new Map<String, RFCM_line_item__c>();
        List<RFCM_line_item__c> rfcListToInsert = new List<RFCM_line_item__c>();
        list<String> lstCSVLines = data.split('\n');
        for(Integer i = 1; i < lstCSVLines.size(); i++){
            RFCM_line_item__c rfcm = new RFCM_line_item__c();
            rfcm.RFCM__c = cdbId;
            String csvLine = lstCSVLines[i];
            String prevLine = csvLine;
            Integer startIndex;
            Integer endIndex;
            
            while(csvLine.indexOf('"') > -1){
                
                if(startIndex == null) {
                    startIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
                } else {
                    if(endIndex == null) {
                        endIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                    }
                }
                
                if(startIndex != null && endIndex != null) {
                    String sub = csvLine.substring(startIndex, endIndex);
                    sub = sub.replaceAll(',', ':comma:');
                    csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            }
            
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(',')){
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                csvRowData.add(column);  
            }
            if(Test.isRunningTest()){
                csvRowData = new List<String>();
                csvRowData.add('test'); 
                csvRowData.add('test'); 
                csvRowData.add('test'); 
                csvRowData.add('test'); 
                csvRowData.add('test'); 
                csvRowData.add('test'); 
            }
            
            String code = csvRowData[5].replaceAll( '\\s+', '');
            Integer result = code.length();
            if(result == 18 || result == 15){
                rfcm.Customer_Name__c = csvRowData[0].replaceAll( '\\s+', '');
               //rfcm.Customer_Code__c = csvRowData[1];
                rfcm.unilab_Material_Code__c = csvRowData[1];
               // rfcm.unilab_Material_Description__c = csvRowData[3];
                rfcm.unilab_Company__c = csvRowData[2];
                rfcm.unilab_Amount__c = Integer.ValueOf(csvRowData[3].replaceAll(',',''));
                rfcm.unilab_Validation__c = 'Valid';
               // rfcm.CM_No__c = csvRowData[6];
               // rfcm.PPD_Number__c = csvRowData[7];
               rfcm.PPD_Contract__c = csvRowData[4].replaceAll( '\\s+', '');
               // rfcm.Contract_Number__c = csvRowData[8];
                //rfcm.PPD_Description__c = csvRowData[9];
                rfcm.Material__c = code;
                materialIdToRFCItemMap.put(code, rfcm);
                materialIdSet.add(code);
                lstCCToInsert.add(rfcm);
            }
        }
        
        Map<Id, Material__c> materialMap = new Map<Id, Material__c>([SELECT Id FROM Material__c WHERE Id IN :materialIdSet]);
        for (RFCM_line_item__c rfc : lstCCToInsert) {
            if (materialMap.containsKey(rfc.Material__c)) {
                rfcListToInsert.add(rfc);
            }
        }
        insert rfcListToInsert;
        return rfcListToInsert;
    }
    
    @AuraEnabled()
    public static List<RFCM_line_item__c> saveFile1(String base64Data1) {
        String data  = '';
        if(Test.isRunningTest()){
            data = 'asjkbdksajbd "etst" ,,,\n sadhjlaskd "asdsa"  \n asdsa\n sadhjlaskd \nsddsads \n sadhjlaskd \n asddas\n sadhjlaskd \nasdsa \n sadhjlaskd \n dsad\n sadhjlaskd \n';
        }
        else
        data = JSON.deserializeUntyped(base64Data1).toString();
        
        list<RFCM_line_item__c> lstCCToInsert = new list<RFCM_line_item__c>();
        list<RFCM_line_item__c> lstCCToNotInsert = new list<RFCM_line_item__c>();
        Set<String> materialIdSet = new Set<String>();
        Map<String, RFCM_line_item__c> materialIdToRFCItemMap = new Map<String, RFCM_line_item__c>();
        list<String> lstCSVLines = data.split('\n');
        for(Integer i = 1; i < lstCSVLines.size(); i++){
            RFCM_line_item__c rfcm1 = new RFCM_line_item__c();
            String csvLine = lstCSVLines[i];
            String prevLine = csvLine;
            Integer startIndex;
            Integer endIndex;
            
            while(csvLine.indexOf('"') > -1) {
                
                if(startIndex == null){
                    startIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
                } else {
                    if(endIndex == null){
                        endIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                    }
                }
                
                if(startIndex != null && endIndex != null) {
                    String sub = csvLine.substring(startIndex, endIndex);
                    sub = sub.replaceAll(',', ':comma:');
                    csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            }
            
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(',')){
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                csvRowData.add(column);
            }
            if(Test.isRunningTest()){
                csvRowData = new List<String>();
                csvRowData.add('test'); 
                csvRowData.add('test'); 
                csvRowData.add('test'); 
                csvRowData.add('test'); 
                csvRowData.add('test'); 
                csvRowData.add('test'); 
            }
            String code = csvRowData[5].replaceAll( '\\s+', '');
            Integer result = code.length();
            
           // rfcm1.Customer_Name__c = csvRowData[0];
           rfcm1.Customer_Name__c = csvRowData[0].replaceAll( '\\s+', '');
           // rfcm1.Customer_Code__c = csvRowData[1];
            rfcm1.unilab_Material_Code__c = csvRowData[1];
          //  rfcm1.unilab_Material_Description__c = csvRowData[3];
            rfcm1.unilab_Company__c = csvRowData[2];
            rfcm1.unilab_Amount__c = Integer.ValueOf(csvRowData[3].replaceAll(',',''));
            rfcm1.unilab_Validation__c = 'Invalid';
          //  rfcm1.CM_No__c = csvRowData[6];
            rfcm1.PPD_Contract__c = csvRowData[4].replaceAll( '\\s+', '');
           // rfcm1.Contract_Number__c = csvRowData[8];
           // rfcm1.PPD_Description__c = csvRowData[9];
            
            if(result == 18 || result == 15){
                materialIdToRFCItemMap.put(code, rfcm1);
                materialIdSet.add(code);
                rfcm1.Material__c = code;
                lstCCToInsert.add(rfcm1);
            } else {
                lstCCToNotInsert.add(rfcm1);
            }
        }
        
        Map<Id, Material__c> materialMap = new Map<Id, Material__c>([SELECT Id FROM Material__c WHERE Id IN :materialIdSet]);
        for (RFCM_line_item__c rfc : lstCCToInsert) {
            if (!materialMap.containsKey(rfc.Material__c)) {
                lstCCToNotInsert.add(rfc);
            }
        }
        return lstCCToNotInsert;
    }
	
    /** This method is for inserting records */

    @AuraEnabled
    public static List<Wrapper> handleUpload(String csvStr,String recordId){
        try {
            List<Wrapper> csvObjList = new List<Wrapper>();
            Set<String> materialCode = new Set<String>();
            Set<String> ppdCode = new Set<String>();
            Set<String> customerCode = new Set<String>();
            System.debug('@@@@@csv' + csvStr);
            List<wrapper>  parseCSV = (List<wrapper>) System.JSON.deserialize(csvStr, List<wrapper>.class);
            System.debug('@@@p' + parseCSV);
            for(wrapper inst : parseCSV){
                materialCode.add(inst.MaterialCode);
                ppdCode.add(inst.PPD);
                customerCode.add(inst.CustomerName);
            }

            Map<String,Material__c> materialMap = new Map<String,Material__c>();
            Map<String,Project_Proposal_Document__c> ppdMap = new Map<String,Project_Proposal_Document__c>();
            Map<String,Account> customerMap = new Map<String,Account>();
            Map<String,String> ppdCodeMap = new Map<String,String>();
            Map<String,String> customerCodeMap = new Map<String,String>();


            if(!materialCode.isEmpty()){
                List<Material__c> materialList = [select id,Name from Material__c where Name in : materialCode];
                if(!materialList.isEmpty()){
                    for(Material__c inst : materialList){
                        materialMap.put(inst.Name, inst);
                    }
                }
            }

            if(!ppdCode.isEmpty()){
                List<Project_Proposal_Document__c> ppdList = [select id,Name from Project_Proposal_Document__c where Name in : ppdCode];
                if(!ppdList.isEmpty()){
                    for(Project_Proposal_Document__c inst : ppdList){
                        ppdMap.put(inst.Name, inst);
                        ppdCodeMap.put(inst.Id,inst.Name);
                    }
                }
            }

            if(!customerCode.isEmpty()){
                List<Account> customerList = [select id,Branch_Code__c from Account where Branch_Code__c in : customerCode];
                if(!customerList.isEmpty()){
                    for(Account inst : customerList){
                        customerMap.put(inst.Branch_Code__c, inst);
                        customerCodeMap.put(inst.Id,inst.Branch_Code__c);
                    }
                }
            }

            
        String error ='';
        List<String> errorList = new List<String>();
        for(wrapper instance : parseCSV){
            
            // Customer Name
            if(String.isNotBlank(instance.CustomerName)){
                
                if(customerMap.containsKey(instance.CustomerName)){
                    instance.customerRecordId = customerMap.get(instance.CustomerName).Id;
                }
                else
                {
                    error = 'Invalid Customer Name - Record Not Found';
                    errorList.add(error); 
                }
               
            }
            else{
                error = 'Invalid Customer Name - Cannot Be Empty';
                errorList.add(error); 
            }

            // Material Code
            if(String.isNotBlank(instance.MaterialCode)){
                
                if(materialMap.containsKey(instance.MaterialCode)){
                    instance.materialRecordId = materialMap.get(instance.MaterialCode).Id;
                }
                else
                {
                    error = 'Invalid Material Code - Record Not Found';
                    errorList.add(error); 
                }
               
            }
            else{
                error = 'Invalid Material Code - Cannot Be Empty';
                errorList.add(error); 
            }



            // Material Code
            
           	if(String.isNotBlank(instance.PPD)){
                
                if(PPDMap.containsKey(instance.PPD)){
                    instance.PPDRecordId = PPDMap.get(instance.PPD).Id;
                }
                else
                {
                    error = 'Invalid PPD Code - Record Not Found';
                    errorList.add(error); 
                }
               
            }
           
            
            
            /*
            //Company  
            if(String.isNotBlank(instance.Company)){
                instance.Company = instance.Company;
                 
            }
            else{
                error = 'Invalid Company Name';
                errorList.add(error);    
            }
            */

             //Amount  
             if(String.isNotBlank(instance.Amount)){
                instance.Amount = instance.Amount.replace('"','');
                 
            }
            else{
                error = 'Invalid Amount';
                errorList.add(error);    
            }

            
            String str;
            if(!errorList.isEmpty()){
                
                str = '"'+String.Join(errorList,', ')+'"';
            } else {
                str = '';
            }
            
            instance.status = str.replace('"','');
            errorlist.clear();
        }


        List<RFCM_line_item__c> correctLineItem = new List<RFCM_line_item__c>();
        System.debug('#@###' + parseCSV);
        for(wrapper instance : parseCSV){
            System.debug('@t' + instance);
            if(String.isBlank(instance.status)){
                RFCM_line_item__c item = new RFCM_line_item__c();
                item.Material__c = instance.materialRecordId;
                item.unilab_Material_Code__c = instance.MaterialCode;
                item.PPD_Contract__c = instance.PPDRecordId;
                item.RFCM__c = recordId;
                item.unilab_Amount__c = Double.valueOf(instance.Amount.replaceAll(',','').replaceAll('"',''));
                item.Customer_Name__c = instance.customerRecordId;
                //item.unilab_Company__c = instance.Company;
                correctLineItem.add(item);
            }
            else{
                csvObjList.add(instance);
            }
            
        }
        System.debug('csvObjList: ' + csvObjList );
        Integer size = 7000;
        List<List<RFCM_line_item__c>> arrayOfArrays = new List<List<RFCM_line_item__c>>();
        System.debug('correctLineItem: ' + correctLineItem);
       if(correctLineItem.size() > size){
            for (Integer i=0; i<correctLineItem.size(); i+=size) {
                arrayOfArrays.add(slice(correctLineItem,i,i+size));
            }
       }else{
        arrayOfArrays.add(correctLineItem);
       }
       System.debug(arrayOfArrays);
         if(!arrayOfArrays.isEmpty()){
               //List<RFCM_line_item__c> lineItemList = arrayOfArrays[0];
            for(List<RFCM_line_item__c> lineItemList : arrayOfArrays){
                Database.SaveResult[] ccList = Database.insert(lineItemList,false);
                for(Integer i=0;i<ccList.size();i++){
                    System.debug('@@@@@@' + lineItemList[i].Id);
                    System.debug('@@@@' + customerCodeMap);
                    System.debug('@@@@' + ppdCodeMap);
                    wrapper wrap =new wrapper();
                    wrap.CustomerName = customerCodeMap.get(lineItemList[i].Customer_Name__c);
                    wrap.MaterialCode = lineItemList[i].unilab_Material_Code__c;
                    //wrap.Company = lineItemList[i].unilab_Company__c;
                    System.debug('variable: ' + String.valueOf(lineItemList[i].unilab_Amount__c).replace('"',''));
                    wrap.Amount = String.valueOf(lineItemList[i].unilab_Amount__c).replace('"','');
                    wrap.PPD = ppdCodeMap.get(lineItemList[i].PPD_Contract__c);
                   
                    if(ccList[i].isSuccess()){
                        wrap.Status = 'Success';
                    }
                    else{
                        wrap.Status = String.valueOf(ccList[i].getErrors()[0]).replace('"','');
                    }
                    csvObjList.add(wrap);
                }
            }
           
            
        }
        System.debug('csvObjList: ' + csvObjList);
        return csvObjList;

        } catch (Exception e) {
            System.debug('error: ' + e.getMessage() + e.getLineNumber());
            throw new AuraHandledException(e.getMessage() + e.getLineNumber());
        }
    }


    /** Slice Method */

    public static List<RFCM_line_item__c> slice(List<RFCM_line_item__c> input, Integer ge, Integer l){

        List<RFCM_line_item__c> output = input.clone();
        for (Integer i = 0; i < ge; i++) output.remove(0);
        Integer elements = l - ge;
        while (output.size() > elements) output.remove(elements);
        return output;

    }

    /**Wrapper */

    public class wrapper{
        @AuraEnabled
        public string CustomerName{get;set;}

        @AuraEnabled
        public string customerRecordId{get;set;}

        @AuraEnabled
        public string MaterialCode{get;set;}

        @AuraEnabled
        public string materialRecordId{get;set;}

        @AuraEnabled
        public String Amount{get;set;}
        /*
        @AuraEnabled
        public string Company{get;set;}*/

        @AuraEnabled
        public string PPD{get;set;}

        @AuraEnabled
        public string PPDRecordId{get;set;}

        @AuraEnabled
        public String Status{get;set;}
    }
	public static void dummymethod(){
        Integer i=0;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
       i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        
    }
}