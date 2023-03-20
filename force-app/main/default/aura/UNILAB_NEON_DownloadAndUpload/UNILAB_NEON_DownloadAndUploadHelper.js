({
	loadAccountData: function(component, event) {
        var action = component.get("c.fetchData");
        component.set("v.showSpinner", true);
        action.setParams({
            prodId : component.get('v.recordId'),
            accType : component.get('v.accountType')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log(response.getReturnValue());
                component.set("v.accountData", response.getReturnValue());
                component.set("v.showSpinner", false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast('Error','Error',errors[0].message);
                    }
                } 
                else {
                    this.showToast('Error','Error','Unknown error');
                }
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getISPLogStatus : function(component, event) {
        var action = component.get("c.fetchStatus");
        
        action.setParams({
            ispData : component.get("v.accountData"),
            prodId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {
                var returnVal = response.getReturnValue();
            	component.set("v.ispStatus", returnVal);
                if(returnVal.length > 0 ) {
                    if(returnVal[0].IS_Status == 'zero') {
                        component.set("v.disabledBtn", false);
                    } else if(returnVal[0].IS_Status == 'submitted') {
                        component.set("v.disabledBtn", true);
                    }
                } else {
                    component.set("v.disabledBtn", true);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast('Error','Error',errors[0].message);
                    }
                } 
                else {
                    this.showToast('Error','Error','Unknown error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    downloadTemplate : function(component, event) {
        //get today's date
        var today = new Date();
        
        // load Data
        this.loadAccountData(component, event);
       
        // get the Records [Account] list from 'accountData' attribute
        var stockData = component.get("v.accountData");
        var accountType = component.get("v.accountType");
        var csv = '';
        
        if(stockData.length==0) {
        	component.set("v.errmsgModal", true);
        }
        
        if(accountType == 'Head Office') {
            // call the helper function which "return" the CSV data as a String
            csv = this.convertArrayOfObjectsToCSV2(component, stockData);
        } else {
            // call the helper function which "return" the CSV data as a String
            csv = this.convertArrayOfObjectsToCSV1(component, stockData);
        }
        if (csv == null){return;}
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self';
        hiddenElement.download = 'NEON IS Plan Template (Forecasting Only) - with SKU (For NEON 2.0) ' + today + '.csv';  // CSV file Name* you can change it.[only name not .csv]
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
	},
    convertArrayOfObjectsToCSV1 : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider, customHeader;
               
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        keys = ['Channel__c', 
                'Team__c', 
                'Account_Group__c',
                'Id',
                'Branch_Code__c', 
                'Branch_Name__c',
               	'Account_Type__c',
                'Account_Status__c',
               
                'Account_Record_Type_Name__c',
               	'Account_Closure_Date__c',
                'IS_Term__c',
                'Foot_Traffic_Cust_Count_Per_Day__c',
                'New_Prod_IS_Ethical__c',
                'New_Prod_IS_OTC__c',
                'New_Prod_IS_PC__c',
                'New_Prod_IS_Ritemed_Ethical__c',
                'New_Prod_IS_Ritemed_OTC__c',
                'RPS_Account_Class__c',
                'Near_A_Call_Center__c',
                'Near_A_Pre_School__c',
                'Near_A_School__c',
                'Near_A_University_College__c',
                'Near_Clinic__c',
                'Near_Offices__c',
                'Near_Other_Drugstores__c',
                'Near_Public_Market__c',
                'Near_Transport_Terminal__c',
                'Near_or_Within_a_Supermarket__c',
                'Fronting_Near_Hospital__c',
                'Ave_Daily_Basket_Size_Peso__c',
                'Near_a_Generics_Drugstore__c',
                'MT_RPS_Account_Class__c',
                'For_Inclusion_in_RPS_Survey__c',
                'Retail_Environment__c'];
        // this labels use in CSV file header
        customHeader = ['is_qty', 
                        'channel', 
                        'team', 
                        'account_group', 
                        'sfa_internal_id', 
                        'branch_code', 
                        'branch_name', 
                        'account_type',
                        'account_status',
                       
                        'account_record_type_name',
                       	'account_closure_date',
                        'is_term',
                        'foot_traffic_cust_count_per_day',
                        'new_prod_is_ethical',
                        'new_prod_is_otc',
                        'new_prod_is_pc',
                        'new_prod_is_ritemed_ethical',
                        'new_prod_is_ritemed_otc',
                        'rps_account_class',
                        'near_a_call_center',
                        'near_a_pre_school',
                        'near_a_school',
                        'near_a_university_college',
                        'near_clinic',
                        'near_offices',
                        'near_other_drugstores',
                        'near_public_market',
                        'near_transport_terminal',
                        'near_or_within_a_supermarket',
                        'fronting_near_hospital',
                        'ave_daily_basket_size_peso',
                        'near_a_generics_drugstore',
                        'mt_rps_account_class',
                        'for_inclusion_in_rps_survey',
                        'retail_environment'];
        csvStringResult = '';
        csvStringResult += customHeader.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                csvStringResult += columnDivider;
                //$A.util.isUndefinedOrNull() --check for undefined  value
                //csvStringResult += '"'+ objectRecords[i][skey]+'"';
                
                var skeyValue;
                    
                if ($A.util.isUndefinedOrNull(objectRecords[i][skey]) === true){
                    skeyValue = '';
                }else{
                    skeyValue = objectRecords[i][skey];
                };
                
                
                csvStringResult += '"'+ skeyValue.replace(',','') +'"';
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        console.log(csvStringResult);
        // return the CSV formate String
        //component.set("v.csvStringResult", csvStringResult); 
        return csvStringResult;        
    },
    
    convertArrayOfObjectsToCSV2 : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider, customHeader;
               
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        keys = ['Channel__c', 
                'Team__c', 
                'Account_Group__c',
                'Id',
                'Branch_Code__c', 
                'Branch_Name__c',
               	'Account_Type__c',
               	'Account_Status__c',
                
                'Account_Record_Type_Name__c',
                'Account_Closure_Date__c',
                'IS_Term__c',
                'Foot_Traffic_Cust_Count_Per_Day__c',
                'New_Prod_IS_Ethical__c',
                'New_Prod_IS_OTC__c',
                'New_Prod_IS_PC__c',
                'New_Prod_IS_Ritemed_Ethical__c',
                'New_Prod_IS_Ritemed_OTC__c',
                'RPS_Account_Class__c',
                'Near_A_Call_Center__c',
                'Near_A_Pre_School__c',
                'Near_A_School__c',
                'Near_A_University_College__c',
                'Near_Clinic__c',
                'Near_Offices__c',
                'Near_Other_Drugstores__c',
                'Near_Public_Market__c',
                'Near_Transport_Terminal__c',
                'Near_or_Within_a_Supermarket__c',
                'Fronting_Near_Hospital__c',
                'Ave_Daily_Basket_Size_Peso__c',
                'Near_a_Generics_Drugstore__c',
                'MT_RPS_Account_Class__c',
                'For_Inclusion_in_RPS_Survey__c',
                'Retail_Environment__c'];
        // this labels use in CSV file header
        customHeader = ['is_qty', 
                        'branch_target',
                        'channel', 
                        'team', 
                        'account_group', 
                        'sfa_internal_id', 
                        'branch_code', 
                        'branch_name', 
                        'account_type',
                       	'account_status',
                        
                        'account_record_type_name',
                        'account_closure_date',
                        'is_term',
                        'foot_traffic_cust_count_per_day',
                        'new_prod_is_ethical',
                        'new_prod_is_otc',
                        'new_prod_is_pc',
                        'new_prod_is_ritemed_ethical',
                        'new_prod_is_ritemed_otc',
                        'rps_account_class',
                        'near_a_call_center',
                        'near_a_pre_school',
                        'near_a_school',
                        'near_a_university_college',
                        'near_clinic',
                        'near_offices',
                        'near_other_drugstores',
                        'near_public_market',
                        'near_transport_terminal',
                        'near_or_within_a_supermarket',
                        'fronting_near_hospital',
                        'ave_daily_basket_size_peso',
                        'near_a_generics_drugstore',
                        'mt_rps_account_class',
                        'for_inclusion_in_rps_survey',
                        'retail_environment'];
        csvStringResult = '';
        csvStringResult += customHeader.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                if(counter<1){
                   csvStringResult += columnDivider;
                }
                csvStringResult += columnDivider;
                //csvStringResult += '"'+ objectRecords[i][skey]+'"';
                var skeyValue;
                    
                if ($A.util.isUndefinedOrNull(objectRecords[i][skey]) === true){
                    skeyValue = '';
                }else{
                    skeyValue = objectRecords[i][skey];
                };
                
                
                csvStringResult += '"'+ skeyValue.replace(',','') +'"';
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        console.log(csvStringResult);
        // return the CSV formate String
        //component.set("v.csvStringResult", csvStringResult); 
        return csvStringResult;        
    },
    
    CSV2JSON: function (component,csv) {
        //  console.log('Incoming csv = ' + csv);
        
        var arr = []; 
        
        arr =  csv.split('\n');
        //console.log('Array  = '+array);
        // console.log('arr = '+arr);
        //arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                if ($A.util.isUndefinedOrNull(data[j] === false)){
                    obj[headers[j]] = '0';
                }
                else{
                   obj[headers[j]] = data[j];
                }
                //console.log('obj headers = ' + obj[headers[j].trim()]);
            }
            if(obj.is_qty != '' && obj.is_qty >= 1) {
            	jsonObj.push(obj);
            }
        }
        var json = JSON.stringify(jsonObj);
        //console.log('json = '+ json);
        
        return json;
        
    },
    
    CreateISPlan : function (component,jsonstr){
        var action = component.get('c.insertData');
        component.set("v.showSpinner", true); 
        action.setParams({
            strfromle : jsonstr,
            prodId : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var result=response.getReturnValue();
                this.showToast('Success','Success','IS Plan Uploaded successfully.');
                component.set("v.showSpinner", false);
                this.handleSuccess(component, result);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        this.showToast('Error','Error',errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    this.showToast('Error','Error','Unknown error');
                }
                component.set("v.showSpinner", false);
            }
        }); 
        
        $A.enqueueAction(action);    
        
    },
    
    showToast : function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
    
    handleSuccess: function(cmp, recordID) {
        cmp.find("navService").navigate({
            "type": "standard__recordPage",
            "attributes": {
                "recordId": recordID,
                "objectApiName": "NEON_Product__c",
                "actionName": "view"
            }
        });
	}
})