({
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: NAVIGATE PATH TO EXPORT PHASE
    goToPage : function(component, pageNo) {
        var currentStep = parseInt(component.get("v.currentStep"), 10);     
        
        if (currentStep != 3) {                    
            component.set("v.currentStep", pageNo);                    
        }      
    },
    
    //AUTHOR: MARK PALACIOS
    fetchUserInfo : function (component, event, helper){
        //Used for fetching Logged User
        var action = component.get("c.getUserInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
                if(storeResponse.UserRole.Name == 'CMD Lead'){
                    component.set('v.disableGenerateActions',true);
                    component.set('v.isDisabled',true);
                    component.set('v.SIdisable',true);
                    component.set('v.SOdisable',true);
                }
                
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(action);
        
    },
    
    //AUTHOR: MARK PALACIOS
    fetchDateToday : function(component, event, helper){
        //Used for fetching Date Today
        var action = component.get("c.dateToday");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.dateToday',response.getReturnValue())
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    updateDraftRec : function(component, event, retAlloc, helper){
        var action = component.get("c.saveDraftAllocRec");
        var recordId = component.get("v.recordId");
        action.setParams({
            retallocRec : retAlloc
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.spinner",true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" : "success",
                    "message": "Allocation has been saved."
                });
                toastEvent.fire();
                var event = $A.get( 'e.force:navigateToSObject' );
                event.setParams({
                    'recordId' : recordId,
                    'slideDevName' : 'Detail' ,
                    'isRedirect' : true
                }).fire(); 

            } else if (state === "ERROR") { 
                helper.handleErrors(component,response.getError());  
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    fetchAllocationData : function(component, event, helper){
        //Used for fetching Allocation Data
        component.set('v.spinner',true);
        var action = component.get("c.getAllocRecs");
        
        action.setParams({
            recordId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set('v.spinner',false); 
                component.set('v.allocRec', response.getReturnValue());
                var status = component.get("v.allocRec.Status__c");
                var promoStatus = component.get("v.allocRec.Promo__r.Status__c");
                if(status != "Draft" || promoStatus == 'Not Implemented'){
                    component.set('v.isDisabled',true);
                    component.set('v.SIdisable',true);
                    component.set('v.SOdisable',true);
                    component.set('v.isDraft',false);
                } 
                
                if(status == 'Finalized' || promoStatus == 'Not Implemented'){
                    component.set('v.disableGenerateActions',true);
                }
                
                if(status == "Draft" || status == "Canceled" || status == "Finalized"){
                    component.set("v.currentStep", '1');
                    
                } else if(status == "Retrieving Data" || status == "Adjustment"){
                    component.set("v.currentStep", '2');
                    helper.getAccAllocHierarchy(component,event,helper);
                }
                
                if(component.get("v.allocRec.Sell_in__c") == true){
                    component.set("v.enabledSellInDataType",true);
                    component.set("v.measureTypeHasValue",true);
                    component.set("v.SOdisable", true);
                } else if(component.get("v.allocRec.Sell_out__c") == true){
                    component.set("v.enabledSellOutDataType",true);
                    component.set("v.measureTypeHasValue",true);
                    component.set("v.SIdisable", true);
                }
                
                if (component.get("v.allocRec.Ending_Inventory__c") == true){
                    component.set("v.enabledEndingInventoryDataType",true);
                    component.set("v.measureTypeHasValue",true);
                }
                
                if(component.get("v.allocRec.Data_Retrieved__c")){
                    component.set("v.ProcessingData",false);
                }
            }  else if (state === "ERROR") {             
                helper.handleErrors(response.getError());  
            }
            
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    fetchPALConfigurations : function(component, event, helper){
        //Used for fetching Admin Pal Configurations
        var getConfigRecs = component.get("c.getConfigRecs");
        getConfigRecs.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    if(component.get('v.allocRec').Channel__c == allValues[i].CONF_Channel__c){
                        component.set('v.palConfigData',allValues[i]);
                    }
                }
            }else if (state === "ERROR") {            
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(getConfigRecs);
    },
    
    //AUTHOR: MARK PALACIOS
    retrieveAllocationData : function(component, event, retAlloc, helper){
        //Used for retrieving and updating Allocation Record
        var action = component.get("c.updateAllocRecAndGetPALApiParameter");
        action.setParams({
            retallocRec : retAlloc
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.apiParamRec',response.getReturnValue());
                var apiParamRec = component.get('v.apiParamRec');
                var jsonString = JSON.stringify(apiParamRec);
                if(apiParamRec != null){
                    helper.fetchAccessToken(component, event, helper, jsonString);
                }
                
            } else if (state === "ERROR") { 
                helper.handleErrors(component,response.getError());  
            }
        });
        $A.enqueueAction(action);
        
    },
    
    //AUTHOR: MARK PALACIOS
    fetchAccessToken : function(component, event, helper, jsonString){
        var action = component.get("c.getAccessToken");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {             
                var token = response.getReturnValue();
                
                if(token != null){
                    helper.invokeCallout(component, event, token, helper, jsonString);
                }else{
                    var serverDown = true;
                    var nullCalloutValue = false;
                    helper.updateAllocRecToDraft(component, event, helper, serverDown, nullCalloutValue);
                }
                
            } else if (state === "ERROR") { 
                helper.handleErrors(component,response.getError());  
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    invokeCallout : function(component, event, token, helper, jsonString){
        //Used for retrieving and updating Allocation Record
        var allocId = component.get("v.recordId");
        var action = component.get("c.invokeCallout");
        action.setParams({
            accessToken : token,
            jsonString : jsonString,
            allocId : allocId,
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set('v.tempAllocations', response.getReturnValue());
                var tempAlloc = component.get('v.tempAllocations');
                
                if(tempAlloc.length > 0){
                    helper.invokeBatchApex(component, event, helper,tempAlloc);
                }else{
                    var serverDown = false;
                    var nullCalloutValue = true;
                    helper.updateAllocRecToDraft(component, event, helper, serverDown, nullCalloutValue);
                }
            } else if (state === "ERROR") { 
                var serverDown = true;
                var nullCalloutValue = false;
                helper.updateAllocRecToDraft(component, event, helper, serverDown, nullCalloutValue);
                helper.handleErrors(component,response.getError());  
            }
        });
        $A.enqueueAction(action);
        
    },
    
    //AUTHOR: MARK PALACIOS
    invokeBatchApex : function(component, event, helper, tempAlloc){
        //Used for retrieving and updating Allocation Record
        var allocId = component.get("v.recordId");
        var channel = component.get('v.allocRec.Channel__c');
        var action = component.get("c.invokeBatchApex");
        
        action.setParams({
            allocId : allocId,
            tempAlloc : tempAlloc,
            channel : channel
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.spinner',false);
            } else if (state === "ERROR") { 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    //AUTHOR: MARK PALACIOS
    updateAllocRecToDraft : function(component, event, helper, serverDown, nullCalloutValue){
        var allocId = component.get("v.recordId");
        var action = component.get("c.updateAllocRecToDraft");
        action.setParams({
            recordId : allocId,
            serverDown : serverDown,
            nullCalloutValue : nullCalloutValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            } else if (state === "ERROR") { 
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    retrieveAccountAllocationData : function(component, event, retAlloc, helper){
        
        component.set('v.spinner',true);
        
        var action = component.get("c.getAccAllocations");
        action.setParams({
            alloc : retAlloc
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accAllocList = response.getReturnValue();
                component.set("v.accAllocations", accAllocList);
                component.set('v.spinner',false);                   
            } else if (state === "ERROR") { 
                helper.handleErrors(component,response.getError());  
                component.set('v.spinner',false);
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    fetchAccountStatus : function (component, event, helper){
        //Used for fetching Account Status Picklist Values
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            objectName: component.get("v.ObjectName"),
            field_apiname: "Account_Status__c",
            nullRequired: false // includes --None--
        });
        var arrayVal = [];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var allValues = a.getReturnValue()
                
                for (var i = 0; i < allValues.length; i++) {
                    arrayVal.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                    
                    component.set("v.accountStatusPicklist", arrayVal);
                }
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    fetchFrequencyofVisitPicklist : function (component, event, helper) {
        //Used for fetching Frequency of Visit Picklist Values
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            objectName: component.get("v.ObjectName"),
            field_apiname: "Frequency_of_Visit__c",
            nullRequired: true // includes --None--
        });
        var arrayVal = [];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var allValues = a.getReturnValue()
                for (var i = 0; i < allValues.length; i++) {
                    arrayVal.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                    
                    component.set("v.frequencyOfVisitPicklist", arrayVal);
                }
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    fetchAlongNationalHighwayResidentialPicklist : function (component, event, helper) {
        //Used for fetching Along National Highway or Residential Picklist Values
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            objectName: component.get("v.ObjectName"),
            field_apiname: "Along_National_Highway_Residential__c",
            nullRequired: true // includes --None--
        });
        var arrayVal = [];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var allValues = a.getReturnValue()
                
                for (var i = 0; i < allValues.length; i++) {
                    arrayVal.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                    
                    component.set("v.alongNationalHighwayResidentialPicklist", arrayVal);
                }
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(action);
        
    },
    
    //AUTHOR: MARK PALACIOS
    fetchStoreFormatPicklist : function (component, event, helper) {
        //Used for fetching Store Format Picklist Values
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            objectName: component.get("v.ObjectName"),
            field_apiname: "Store_Format__c",
            nullRequired: true // includes --None--
        });
        var arrayVal = [];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var allValues = a.getReturnValue()
                
                for (var i = 0; i < allValues.length; i++) {
                    arrayVal.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                    
                    component.set("v.storeFormatPicklist", arrayVal);
                }
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(action);
        
    },
    
    //AUTHOR: MARK PALACIOS
    fetchRPSAccountClassPicklist : function (component, event, helper) {
        //Used for fetching RPS Account Class Picklist Values
        var action = component.get("c.getDependentVal");
        action.setParams({
            sObjectName: component.get("v.ObjectName"),
            fieldName: "RPS_Account_Class__c"
        });
        var arrayVal = [];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var allValues = a.getReturnValue()
                
                component.set("v.rpsAccountList",a.getReturnValue());
                
                var allocRecChannel = component.get("v.allocRec.Channel__c");
                if(allocRecChannel == 'General Trade'){
                    var genTradeVal = component.get("v.rpsAccountList.General Trade");
                    for (var i = 0; i < genTradeVal.length; i++) {
                        arrayVal.push({
                            label: genTradeVal[i],
                            value: genTradeVal[i]
                        });
                        component.set("v.rpsAccountClassPicklist",arrayVal);
                    } 
                } else if(allocRecChannel == 'Key Accounts'){
                    var keyAcctVal = component.get("v.rpsAccountList.Key Accounts");
                    for (var i = 0; i < keyAcctVal.length; i++) {
                        arrayVal.push({
                            label: keyAcctVal[i],
                            value: keyAcctVal[i]
                        });
                        component.set("v.rpsAccountClassPicklist",arrayVal);
                    } 
                } else if(allocRecChannel == 'Mercury'){
                    var mrcryVal = component.get("v.rpsAccountList.Mercury");
                    for (var i = 0; i < mrcryVal.length; i++) {
                        arrayVal.push({
                            label: mrcryVal[i],
                            value: mrcryVal[i]
                        });
                        component.set("v.rpsAccountClassPicklist",arrayVal);
                    } 
                } else if(allocRecChannel == 'Modern Trade'){
                    var mdrnTradeVal = component.get("v.rpsAccountList.Modern Trade");
                    for (var i = 0; i < mdrnTradeVal.length; i++) {
                        arrayVal.push({
                            label: mdrnTradeVal[i],
                            value: mdrnTradeVal[i]
                        });
                        component.set("v.rpsAccountClassPicklist",arrayVal);
                    } 
                }
                
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    fetchSellinDataTypePicklist : function (component, event, helper) {
        //Used for fetching Sell-In Data Type Picklist Values
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            objectName: component.get("v.ObjectName"),
            field_apiname: "Sell_in_Data_Type__c",
            nullRequired: false // includes --None--
        });
        var arrayVal = [];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var allValues = a.getReturnValue()
                
                for (var i = 0; i < allValues.length; i++) {
                    arrayVal.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                    
                    component.set("v.sellInDataTypePicklist", arrayVal);
                }
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    fetchSelloutDataTypePicklist : function (component, event, helper) {
        //Used for fetching Sell-Out Data Type Picklist Values
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            objectName: component.get("v.ObjectName"),
            field_apiname: "Sell_out_Data_Type__c",
            nullRequired: false // includes --None--
        });
        var arrayVal = [];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var allValues = a.getReturnValue()
                
                for (var i = 0; i < allValues.length; i++) {
                    arrayVal.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                    
                    component.set("v.sellOutDataTypePicklist", arrayVal);
                }
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    fetchEndingInventoryMeasureLevelPicklist : function (component, event, helper) {
        //Used for fetching Ending Inventory Measure Level Picklist Values
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            objectName: component.get("v.ObjectName"),
            field_apiname: "Ending_Inventory_Measure_Level__c",
            nullRequired: false // includes --None--
        });
        var arrayVal = [];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var allValues = a.getReturnValue()
                
                for (var i = 0; i < allValues.length; i++) {
                    arrayVal.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v.endingInventoryMeasureLevelPicklist", arrayVal);
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    fetchEndingInventoryDataTypeAndOperatorPicklist : function (component, event, helper) {
        //Used for fetching Ending Inventory Data Type and Operator Picklist Values
        var getDataType = component.get("c.getPicklistvalues");
        getDataType.setParams({
            objectName: component.get("v.ObjectName"),
            field_apiname: "Ending_Inventory_Data_Type__c",
            nullRequired: false // includes --None--
        });
        var dataTypeArrayVal = [];
        getDataType.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var allValues = a.getReturnValue()
                
                for (var i = 0; i < allValues.length; i++) {
                    dataTypeArrayVal.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                    
                    component.set("v.endingInventoryDataTypePicklist", dataTypeArrayVal);
                }
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(getDataType); 
        
        var getOperator = component.get("c.getPicklistvalues");
        getOperator.setParams({
            objectName: component.get("v.ObjectName"),
            field_apiname: "Ending_Inventory_Operator__c",
            nullRequired: false // includes --None--
        });
        var operatorArrayVal = [];
        getOperator.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var allValues = a.getReturnValue()
                
                for (var i = 0; i < allValues.length; i++) {
                    operatorArrayVal.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                    
                    component.set("v.endingInventoryOperatorPicklist", operatorArrayVal);
                }
            } else if (state === "ERROR") {          
                helper.handleErrors(response.getError());  
            }
        });
        $A.enqueueAction(getOperator); 
    },
    
    //AUTHOR: MARK PALACIOS
    handleErrors : function(component, errors) {
        //Used for Handling Error and Showing toast
        component.set('v.spinner',false); 
        // Configure error toast
        let toastParams = {
            mode: "dismissible",
            message: "Unknown Error", 
            type: "error"
        };
        // Pass the error message if any
        var listOfValidationErr = component.get("v.listOfAllocError");
        
        var fieldMessage = '';
        if(listOfValidationErr != null){
            
            for(var i=0;i<listOfValidationErr.length;i++){
                fieldMessage += listOfValidationErr[i] + "\n";											 
            }
            //toastParams.mode='sticky';
            toastParams.message = fieldMessage;
        }else if (errors && Array.isArray(errors) && errors.length > 0) {
            toastParams.message = errors[0].message;
        }
        // Fire error toast
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },
    
    //AUTHOR: MARK PALACIOS
    validationRule_EndingInventoryValue : function(component,allocRec,palConfigRec) {
        
        var retAlloc = allocRec;
        var configRec = palConfigRec;
        var eIHasError = true;
        var eIVal = retAlloc.Ending_Inventory_Value__c;
        if(retAlloc.Ending_Inventory__c){
            if(retAlloc.Ending_Inventory_Value__c > 0){
                if(retAlloc.Ending_Inventory_Value__c > configRec.Ending_Inventory_Value__c){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'dismissible',
                        type: 'error',
                        message: 'Ending Inventory Value must not be greater than '+configRec.Ending_Inventory_Value__c,
                    });
                    toastEvent.fire();
                    component.set('v.hasError',true);
                    return true;
                }else if(retAlloc.Ending_Inventory_Value__c < 0 || (retAlloc.Ending_Inventory_Operator__c == "less than" && (retAlloc.Ending_Inventory_Value__c == 0 || retAlloc.Ending_Inventory_Value__c == null))){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'dismissible',
                        type: 'error',
                        message: 'Ending Inventory Value must not be less than 0',
                    });
                    toastEvent.fire();
                    component.set('v.hasError',true);
                    return true;
                } else if(retAlloc.Ending_Inventory_Value__c.length  > 4){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'dismissible',
                        type: 'error',
                        message: 'Ending Inventory Value must only have 2 decimal places.',
                    });
                    toastEvent.fire();
                    component.set('v.hasError',true);
                    return true;
                }else if(retAlloc.Ending_Inventory_Measure_Level__c == null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'dismissible',
                        type: 'error',
                        message: 'Ending Inventory Measure Level must have a value',
                    });
                    toastEvent.fire();
                    component.set('v.hasError',true);
                    return true;
                }
            }else if(retAlloc.Ending_Inventory_Data_Type__c == null || retAlloc.Ending_Inventory_Value__c < 0 || retAlloc.Ending_Inventory_Value__c == "" ){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'dismissible',
                    type: 'error',
                    message: 'Ending Inventory Value must have a value.',
                });
                toastEvent.fire();
                component.set('v.hasError',true);
                return true;
            }
        }
        return false;
    },
    
    //AUTHOR: MARK PALACIOS
    validationRule_PeriodDate_StartDate : function (component,allocRec) {
        var retAlloc = allocRec;
        var dateToday = component.get('v.dateToday');
        return false;				 
    },
    
    //AUTHOR: MARK PALACIOS
    validationRule_PeriodDates : function(component,allocRec) {
        
        var retAlloc = allocRec;  
        var dateToday = component.get('v.dateToday');
        var error = [];
        if(retAlloc.End_Date__c < retAlloc.Start_Date__c ){		   
            component.set('v.hasError',true);
            return true;
        } 
        return false;					 
    },
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: VALIDATION FOR ALL REQUIRED FIELDS
    validationRule_Required_Fields : function(component,allocRec) {
        var retAlloc = allocRec;
        var error = [];
        var allocVol = retAlloc.Allocation_Volume__c;
        var allocEndDate = retAlloc.End_Date__c;
        var allocStartDate = retAlloc.Start_Date__c;
        var allocMeasureTypeHasVal = component.get("v.measureTypeHasValue");
        var allocSI = retAlloc.Sell_in__c;
        var allocSO = retAlloc.Sell_out__c;
        var allocSIMeasureLevel = retAlloc.Sell_in_Data_Type__c;
        var allocSOMeasureLevel = retAlloc.Sell_out_Data_Type__c;
        var eIVal = retAlloc.Ending_Inventory__c;
        var allocEIDataType = retAlloc.Ending_Inventory_Data_Type__c;
        var allocEIOp =retAlloc.Ending_Inventory_Operator__c;
        var allocEIVal = retAlloc.Ending_Inventory_Value__c;
        var allocMeasureLevelHasVal;
        if(allocSIMeasureLevel != null && allocSI){
            allocMeasureLevelHasVal = allocSIMeasureLevel;
        }if(allocSOMeasureLevel != null && allocSO){
            allocMeasureLevelHasVal = allocSOMeasureLevel;
        } 
        
        if(allocVol == null || allocVol < 0 || allocEndDate == null || allocStartDate == null || !allocMeasureTypeHasVal || ((allocSI || allocSO)&& allocMeasureLevelHasVal == null) || (eIVal && (allocEIDataType == null || allocEIOp == null || allocEIVal == null))){
            
            component.set('v.hasError',true);
            if(allocVol == null){
                component.find("inputAllocationVolume").setCustomValidity("Please complete this field.");
                component.find("inputAllocationVolume").reportValidity();
            }if(allocVol < 0){
                component.find("inputAllocationVolume").setCustomValidity("Invalid input value.");
                component.find("inputAllocationVolume").reportValidity();
            }if(allocStartDate == null){
                component.find("allocStartDate").setCustomValidity("Please complete this field.");
                component.find("allocStartDate").reportValidity();
            }if(allocEndDate == null){
                component.find("allocEndDate").setCustomValidity("Please complete this field.");
                component.find("allocEndDate").reportValidity();
            } 
            if(eIVal){
                if(allocEIDataType == null){
                    component.find("eIDataType").setCustomValidity("Please complete this field.");
                    component.find("eIDataType").reportValidity();
                }if(allocEIOp == null){
                    component.find("eIOperator").setCustomValidity("Please complete this field.");
                    component.find("eIOperator").reportValidity();
                }if(allocEIVal == null){
                    component.find("eIValue").setCustomValidity("Please complete this field.");
                    component.find("eIValue").reportValidity();
                }
            }
            
            return true;
        }
        return false;
        
    },
    //AUTHOR: MARK PALACIOS
    validationRule_Export_Path_Button : function(component,allocRec){
        var retAlloc = allocRec;
        var error = [];
        if(retAlloc.Status__c != 'Finalized'){
            return true;
        }
        return false;
    },
    
    //AUTHOR: MARK PALACIOS
    validationRule_Checker : function (component, event, helper, retAlloc, palConfigRec){
        var vRule_Req_Flds = helper.validationRule_Required_Fields(component,retAlloc);
        var vRule_PrdDts = helper.validationRule_PeriodDates(component,retAlloc);
        var vrule_StrtDt = helper.validationRule_PeriodDate_StartDate(component,retAlloc);
        var vRule_EIValue = helper.validationRule_EndingInventoryValue(component,retAlloc,palConfigRec);
        var rqd_Error = $A.get("{!$Label.c.PAL_Required_Fields_Error_Message}");
        var prd_Error = $A.get("{!$Label.c.PAL_Period_Dates_Error_Message}");
        var stDt_Error = 'Start date must not be previous than current date.';
        var error = [];
        
        if(vRule_Req_Flds || vRule_PrdDts || vrule_StrtDt || vRule_EIValue){
            if(vRule_Req_Flds && vRule_PrdDts && vrule_StrtDt){
                error.push(rqd_Error,prd_Error,stDt_Error);
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
                return true;            
            }else if(vRule_Req_Flds && vRule_PrdDts && !vrule_StrtDt){
                error.push(rqd_Error,prd_Error);
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
                return true;
            }else if(vRule_Req_Flds && !vRule_PrdDts && vrule_StrtDt){
                error.push(rqd_Error,stDt_Error);
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
                return true;
            }else if(!vRule_Req_Flds && vRule_PrdDts && vrule_StrtDt){
                error.push(prd_Error,stDt_Error);
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
                return true;
            }else if(vRule_Req_Flds && !vRule_PrdDts && !vrule_StrtDt){
                error.push(rqd_Error);
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
                return true;
            } else if (!vRule_Req_Flds &&vRule_PrdDts&& !vrule_StrtDt) {
                error.push(prd_Error);
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
                return true;
            } else if (!vRule_Req_Flds && !vRule_PrdDts && vrule_StrtDt){
                error.push(stDt_Error);
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
                return true;
            } else if (vRule_EIValue){
                return true;
            }
        }
        return false;
    }, 
    
    //AUTHOR: KRIS MARIANO
    //DESCRIPTION: FETCH COLUMNS TO BE SET ON THE TREE GRID
    fetchColumns: function(component, event, helper){
        var columns = [];
        var action = component.get("c.getColumns");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if(state === "SUCCESS"){
                
                var allValues = response.getReturnValue();
                var columns = [];
                for(var i=0;i<allValues.length;i++){
                    var column = {label: allValues[i]['columnName'], 
                                  fieldName: allValues[i]['columnFieldName'], 
                                  type:allValues[i]['columnType'],
                                  initialWidth:allValues[i]['initialWidth']};
                    columns.push(column);
                }
                component.set('v.gridColumns', columns);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: KRIS MARIANO
    //DESCRIPTION: SET SELECTED DATA FROM TREE GRID TO EDIT MODAL DATA TABLE
    editAccAllocationData: function(component,event,helper){
        component.set('v.columns', [
            { label: 'Account Name', fieldName: 'name', type: 'text'},
            { label: 'Computed Allocation', fieldName: 'Computed_Allocation', type: 'number', typeAttributes: {maximumFractionDigits:0}},
            { label: 'Manual', type: 'number', fieldName: 'Manual', editable:'true'}
        ]);
        var isIdNull = false;
        var selectedData = component.get("v.data");
        component.set('v.data', selectedData);
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: GET ALL ACCOUNTS TO BE DISPLAYED ACCORDING TO FILTER SET
    addAccAllocationData: function(component,event,helper, selectedRecords){
        
        var editAddManualModal = document.getElementById("editAddManualModal");
        $A.util.removeClass(editAddManualModal, 'slds-hide');
        $A.util.addClass(editAddManualModal, 'slds-show');
        
        component.set('v.columns', [
            { label: 'Account Name', fieldName: 'Name', type: 'text'},
            { label: 'Manual', type: 'number', fieldName: 'Manual__c', editable:'true'}
        ]);
        
        var selectedData = component.get("v.selectedRows");
        component.set('v.addedAcc', selectedRecords);
        var sample = component.get("v.addedAcc");
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: GET ALL ACCOUNTS TO BE DISPLAYED ACCORDING TO FILTER SET
    getAllAccounts : function(component, page, recordToDisply , currentLetter, channel, helper) {    		
                
        var page = component.get("v.page") || 1;
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchField = component.find("searchAccount").get("v.value");
        
        component.set('v.accColumns', [
            { label: 'Account Name', fieldName: 'Name', type: 'text'},
            { label: 'Account Status', fieldName: 'Status', type: 'text'},
            { label: 'Account Owner', fieldName: 'Owner', type: 'text'}
        ]);
        
        var action =  component.get("c.getAllAccounts");
        action.setParams({
            "pageNumber": page,
            "recordToDisply" : recordToDisply,
            "selectedLetter" : currentLetter,
            "channel" : channel,
            "allocationId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.page", result.page);
                component.set("v.total", result.total);
                
                component.set("v.pages", Math.ceil(result.total / recordToDisply));
                component.set('v.accData', result.accounts);
                helper.searchBar(component, event, helper);
                
            }
            
        }),
            
            $A.enqueueAction(action);
    },  
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: GET SELECTED ACCOUNTS TO BE DISPLAYED ACCORDING TO FILTER SET
    getSelectedAccount : function(component, event, helper) {
        var allocationId = component.get("v.recordId");
        var selectedData = component.get("v.selectedRows");
        var insertData = component.get("v.addedAcc");
        if(selectedData.length === 1){
            var action = component.get("c.createAccountAllocation");
            action.setParams({
                "accountId": selectedData[0].Id,
                "allocationId": allocationId
            });
            
            $A.enqueueAction(action);
            helper.getAccountAllocations(component, event, helper);
            
            component.set("v.addModal", false);
        }else if(insertData.length === 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "message": "Please select one Account record"
            });
            toastEvent.fire();
        }else if(selectedData.length > 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "message": "Please select single Account record"
            });
            toastEvent.fire();
        }
    },
    
    getAllocationDetails : function(component, event, helper) {
        var allocationId = component.get("v.recordId");
        var action = component.get("c.getAllocationDetails");
        action.setParams({
            "allocationId": allocationId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.allocationStatus",result.Status);   
                component.set("v.promoName",result.PromoName);   
            }
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS AND KRIS MARIANO
    //DESCRIPTION: FETCH DATA FOR TREE GRID
    getAccAllocHierarchy : function (component,event,helper) {
        component.set('v.spinner',true);
        var allocationId = component.get("v.recordId");
        var action = component.get("c.getTreeGridData");
        action.setParams({
            "allocationId": allocationId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accountTeamcheck = component.get("v.accountTeams");
                var accountGroupcheck = component.get("v.accountGroups");
                
                var data = response.getReturnValue();
                var temojson = JSON.parse(JSON.stringify(data.channelWrapper).split('items').join('_children'));
                var temojson1 = JSON.parse(JSON.stringify(temojson).split('items').join('_children'));
                var temojson2 = JSON.parse(JSON.stringify(temojson1).split('items').join('_children'));
                
                var gridAllocDataTeam =  JSON.parse(temojson1); 
                var gridAllocDataGroup =  JSON.parse(temojson2); 
                var gridAllocData = JSON.parse(temojson1);
                
                var tempArray = [];
                var tempArray2 = [];
                var tempArray3 = [];
                var children = [];
                var k = 0;
                var l = 0;
                var m = 0;
                //LIST FOR ONLY GROUP AND TEAMS WITH CHILDREN NODES
                for(var i=0; i<gridAllocDataTeam.length; i++){
                    if(gridAllocDataTeam[i]['_children'] != undefined){
                        for(var j=0; j<gridAllocDataTeam[i]['_children'].length; j++){
                            tempArray[k] = gridAllocDataTeam[i]['_children'][j];
                            k++;
                        }
                    }
                }
                gridAllocDataTeam = [];
                for(var i = 0; i< tempArray.length; i++){
                    gridAllocDataTeam[i] = tempArray[i];
                    
                }
                //LIST FOR DATA WITH NO CHILDREN NODES
                for(var i=0; i<gridAllocData.length; i++){
                    if(gridAllocData[i]['_children'] != undefined){
                        for(var j=0; j<gridAllocData[i]['_children'].length; j++){
                            tempArray3[m] = gridAllocData[i]['_children'][j];
                            m++;
                        }
                    }
                }
                gridAllocData = [];
                for(var i = 0; i< tempArray3.length; i++){
                    gridAllocData[i] = tempArray3[i];
                    
                }
                
                for(var i = 0; i<gridAllocData.length; i++){
                    if(gridAllocData[i]['_children'] != undefined){
                        for(var j = 0; j<gridAllocData[i]['_children'].length; j++){
                            if(j<gridAllocData[i]['_children'][j]['_children'] != undefined){
                                gridAllocData[i] ['_children'][j]['_children'] = null;
                            }
                        }
                    }
                }
                for(var i=0; i<tempArray.length; i++){
                    if(tempArray[i]['_children'] != undefined){
                        for(var j=0; j<tempArray[i]['_children'].length; j++){
                            tempArray2[l] = tempArray[i]['_children'][j];
                            l++;
                        }
                    }
                }
                gridAllocDataGroup = [];
                for(var i = 0; i< tempArray2.length; i++){
                    gridAllocDataGroup[i] = tempArray2[i];
                }
                //END FOR GROUP WITH CHILDREN NODES
                
                if(accountTeamcheck && !accountGroupcheck){
                    component.set('v.gridData',gridAllocData);
                    component.set('v.masterData', gridAllocDataTeam);
                }
                else if(accountGroupcheck && !accountTeamcheck){
                    component.set('v.gridData',gridAllocDataGroup);
                   	component.set('v.masterData', gridAllocDataGroup);
                }else if(accountGroupcheck && accountTeamcheck){
                    component.set('v.gridData',gridAllocDataTeam);
                    component.set('v.masterData', gridAllocDataTeam);
                }else{
                    component.set('v.gridData',gridAllocDataTeam);
                    component.set('v.masterData', gridAllocDataTeam);
                }
                var tempHolder = JSON.parse(temojson);
                var totalAllocVolume = 0;
                for(var i = 0; i<tempHolder.length; i++){
                    totalAllocVolume += tempHolder[i].Final_Allocation;
                }
                component.set("v.totalAccAllocVolume",totalAllocVolume);
                component.set("v.totalNumberOfRows", data.totalAccounts);
                component.set("v.totalAccountTeam", data.totalTeams);
                component.set("v.totalAccountGroup", data.totalGroups);
                component.set('v.spinner',false);
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
        helper.checkOverAllocationStatus(component, event, helper);
        
    },
    
    //AUTHOR: KRIS MARIANO
    //DESCRIPTION: CHECK IF ALLOCATION IS OVERALLOCATED
    checkAllocationSuccess : function (component, event, helper){
        
        var allocationVolume = component.get('v.allocRec.Allocation_Volume__c');
        var action = component.get("c.getTotalAllocation");
        action.setParams({
            "allocationId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var totalVolume = response.getReturnValue();
                
                if(totalVolume[0].allocVolume > allocationVolume){
                    component.set("v.IsOverAllocated", true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "error",
                        "message": "Cannot proceed because maximum allocation has been exceeded."
                    });
                    toastEvent.fire();
                    
                }else{
                    component.set("v.IsOverAllocated", false);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Record was allocated successfully",
                        "type" : "success",
                        "message": "Allocation data will now be saved."
                    });
                    toastEvent.fire();
                }
                
            }
                
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: KRIS MARIANO
    //DESCRIPTION: CHECK IF ALLOCATION IS OVERALLOCATED
    checkOverAllocationStatus : function (component, event, helper){
        
        var allocationVolume = component.get('v.allocRec.Allocation_Volume__c');
        var action = component.get("c.getTotalAllocation");
        action.setParams({
            "allocationId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var totalVolume = response.getReturnValue();
                
                if(totalVolume[0].allocVolume > allocationVolume){
                    component.set("v.IsOverAllocated", true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "error",
                        "message": "Cannot proceed because maximum allocation has been exceeded."
                    });
                    toastEvent.fire();
                    
                }
                
            }
                
        });
        $A.enqueueAction(action);
        
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: FINDS ACCOUNT ACCORDING TO WHAT WAS ENTERED ON THE SEARCH BAR
    searchBar : function (component, event, helper){
        
        component.set('v.accColumns', [
            { label: 'Account Name', fieldName: 'Name', type: 'text'},
            { label: 'Account Status', fieldName: 'Status', type: 'text'},
            { label: 'Account Owner', fieldName: 'Owner', type: 'text'}
        ]);
        
        var action = component.get("c.getAccFilter");
        action.setParams({
            "allocationId": component.get("v.recordId"),
            "channel" : component.get("v.allocRec").Channel__c
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var dataColumn = [];
                for(var i =0; i<result.length; i++){
                    dataColumn.push({
                        Name: result[i].Name,
                        Status: result[i].Account_Status__c,
                        Owner: result[i].Owner.Name
                    });
                }
				component.set('v.backingdata', dataColumn);
            } 
                
        });
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: CONVERSION OF DATA TO CSV
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // Declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        // Check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // Store ,[comma] in columnDivider variabel for sparate CSV values and 
        // For start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // In the keys valirable store fields API Names as a key 
        // This labels use in CSV file header  
        keys = ['Promo_Name', 'Account_Channel','Account_Final_Allocation','Account_Group','Account_Name','Account_Team','CDS'];
        
        //keys = ['Ave_Gross_Sales__c', 'Ave_Qty__c','Id','Name','YTDSales_LY__c','YTDSales_TY__c'];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                
                // Add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    if(csvStringResult.includes("undefined")){
                        csvStringResult = csvStringResult.replace(/undefined/g, '');
                    }
                    csvStringResult += columnDivider; 
                }   
                
                csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                
                counter++;
                
            } // Inner for loop close 
            csvStringResult += lineDivider;
        }// Outer main for loop close 
        
        // Return the CSV formate String 
        return csvStringResult;        
    },
    
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: CONVERSION OF DATA TO XLS
    convertArrayOfObjectsToXLS : function(component,objectRecords){
        
        
        var data = [];
        var headerArray = [];
        var csvContentArray = [];
        //Provide the title 
        var CSV = '';
        
        //Fill out the Header of CSV
        headerArray.push('Promo Title');
        headerArray.push('Account Channel');
        headerArray.push('Account Team');
        headerArray.push('Account Group');
        headerArray.push('Account Name');
        headerArray.push('Final Allocation');
        headerArray.push('CDS');
        data.push(headerArray);
        
        var sno = 0;
        for(var i=0;i<objectRecords.length;i++){
            
            var tempArray = [];
            //use parseInt to perform math operation
            sno = parseInt(sno) + parseInt(1);
            tempArray.push('"'+objectRecords[i].Promo_Name+'"');
            tempArray.push('"'+objectRecords[i].Account_Channel+'"');
            tempArray.push('"'+objectRecords[i].Account_Team+'"');
            tempArray.push('"'+objectRecords[i].Account_Group+'"');
            tempArray.push('"'+objectRecords[i].Account_Name+'"');
            tempArray.push('"'+objectRecords[i].Account_Final_Allocation+'"');
            tempArray.push('"'+objectRecords[i].CDS+'"');
            data.push(tempArray);
            
        }
        
        for(var j=0;j<data.length;j++){
            var dataString = data[j].join(",");
            csvContentArray.push(dataString);
        }
        var csvContent = CSV + csvContentArray.join("/r/n");
        
        return csvContent;
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: Retrive Data (Custom DataTable For Add Account)
    addEditAccountData: function(component, event) {
        
        var action = component.get("c.fetchAccountWrapper");
        
        action.setParams({
            "channel" : component.get("v.allocRec").Channel__c,
            "allocationId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var returnedValue = response.getReturnValue();
                var returnedValueLength = returnedValue.length;
                
                if (returnedValueLength > 0) {
                    
                    component.set("v.bNoRecordsFound" , false);
                    component.set("v.listOfAllAccounts", returnedValue);
                    
                    var pageSize = component.find("recordSize").get("v.value");
                    
                    component.set("v.totalRecordsCount", returnedValueLength);
                    component.set("v.startPage", 0);
                    component.set("v.endPage", pageSize - 1);
                    
                    var PaginationLst = [];
                    
                    for (var i = 0; i < pageSize; i++) {
                        if (component.get("v.listOfAllAccounts").length > i) {
                            PaginationLst.push(returnedValue[i]);    
                        } 
                    }
                    
                    component.set("v.PaginationList", PaginationLst);
                    component.set("v.selectedCount" , 0);
                    component.set("v.totalPagesCount", Math.ceil(returnedValueLength / pageSize));
                    component.set("v.spinner", false);
                    component.set("v.recordLoaded", false);
                    
                }
                else {
                    
                    component.set("v.bNoRecordsFound" , true);
                    component.set("v.spinner", false);
                
                }
            
            }
            else {
            }
        
        });
        
        $A.enqueueAction(action);
        
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION:Next Page (Custom DataTable For Add Account)
    next: function(component, event, sObjectList, end, start, pageSize) {
        
        var Paginationlist = [];
        var counter = 0;
        
        for (var i = end + 1; i < end + pageSize + 1; i++) {
            if (sObjectList.length > i) {
                Paginationlist.push(sObjectList[i]); 
            }
            counter ++ ;
        }
        
        start = start + counter;
        end = end + counter;
        
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION:Previous Page (Custom DataTable For Add Account)
    previous: function(component, event, sObjectList, end, start, pageSize) {
        
        var Paginationlist = [];
        var counter = 0;
        
        for (var i= start-pageSize; i < start ; i++) {
            if (i > -1) {
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }
            else {
                start++;
            }
        }
        
        start = start - counter;
        end = end - counter;
        
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION:Reset Attribute Data (Custom DataTable For Add Account)
    resetData: function(component) {
        
        var updatedListOfAccounts = [];
        var listOfAllAccounts = [];
        var PaginationList = [];
        
        component.set("v.filter", '');
        component.set("v.updatedListOfAccounts", updatedListOfAccounts);
        component.set("v.listOfAllAccounts", listOfAllAccounts);
        component.set("v.PaginationList", PaginationList);
        component.set("v.currentAlphabet", 'All');        
        component.set("v.currentPage", 1);
        component.set("v.pageSize", 10);
        component.set("v.selectedCount", 0);
        component.set("v.recordLoaded", true);
        
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: Setting Value of List for Display (Custom DataTable For Add Account)
    displayListData: function(component, results) {
        
        var updatedListOfAccounts = component.get("v.updatedListOfAccounts");
        
        if (results.length > 0) {
            
            component.set("v.bNoRecordsFound" , false);
            
            var pageSize = component.find("recordSize").get("v.value");
            
            component.set("v.totalRecordsCount", results.length);
            component.set("v.startPage",0);
            component.set("v.endPage",pageSize-1);
            
            var PaginationList = [];
            
            for (var i = 0; i < pageSize; i++) {
                if (updatedListOfAccounts.length > i) {
                    PaginationList.push(results[i]);    
                } 
            }
            
            component.set("v.pageSize", parseInt(component.find("recordSize").get("v.value")));
            component.set('v.PaginationList', PaginationList);        
            component.set("v.totalPagesCount", Math.ceil(results.length / pageSize));
            component.set("v.currentPage", 1);
            
        }
        else {
            component.set("v.bNoRecordsFound" , true);
        }
        
    }
    
})