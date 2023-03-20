({
    populateOptions : function(optionList, optionArray) {                
        for(let i = 0; i< optionList.length; i++){
            optionArray.push({label: optionList[i], value: optionList[i]});
        }               
    },
    
    populateCallSelection: function(component, optionCallArray){
        
        var calls = component.get('v.tcrCalls');
        
        if(calls != undefined){
            var len;
            if(calls.length == 4){
                len = 4;
            }else{
                
                if(calls[0].Account__c != undefined){
                    len = calls.length + 1;    
                }else{
                    len = calls.length;    
                }
                
            }
            
            for(let i = 1; i<= len ; i++){
                optionCallArray.push({label: 'Call ' + i.toString(), value: i.toString()});
            }                           
        }  else{
            optionCallArray.push({label: 'Call 1', value: '1'});
        }      
    },
    
    setCallFieldMap: function(component, helper, customCallFieldMap){
        helper.hideMessage(component);
        
        var isEmptyTcrCalls = false;
        var tcrCalls = component.get('v.tcrCalls');  
        
        if(tcrCalls != undefined && tcrCalls.length > 0){
            if(tcrCalls.length == 1 && tcrCalls[0].Account__c === undefined){
                isEmptyTcrCalls = true;    
            }            
        }else{
            isEmptyTcrCalls = true;
        }
        component.set('v.isEmptyCalls', isEmptyTcrCalls);
        component.set('v.isShowPill', !isEmptyTcrCalls);
        
        if(customCallFieldMap != undefined){
            
            var tcrRec = component.get('v.tcr');
           
            if(tcrRec.RecordType.Name  === component.get('v.t3Tcr')){
                
                var optionCallArray = [];
                helper.populateCallSelection(component,optionCallArray);
                
                component.find('selectCall').set('v.options', optionCallArray);
                
                component.get('v.renderT3Calls');
            } 
            
            
            for(var apiName in customCallFieldMap ){
                var fieldDetail = JSON.parse(customCallFieldMap[apiName]);              
                var allComponents = component.find(apiName);
                
                if ($A.util.isArray(allComponents)) {
                    allComponents.forEach(function(element) {
                        
                        if(element != undefined){
                            
                            if(element.get('v.options') !== undefined){
                                var selectOptions = fieldDetail.picklistValues;
                                if(selectOptions !== undefined && selectOptions.length > 0){
                                    if(!isEmptyTcrCalls){
                                        var optionArray=[];                       
                                        helper.populateOptions(selectOptions, optionArray);                                                   
                                        element.set('v.options',optionArray);                                        
                                    }
                                }    
                            }else{                                            
                                element.set('v.label',fieldDetail.label);      
                                
                                element.set('v.placeholder',fieldDetail.helpText); 
                                
                            }
                            
                            if(element.get('v.required') != undefined){
                                element.set('v.required', component.get('v.isRequired'));
                            }
                            
                        }                        
                    });         
                }
            }   
        }
    },
    
    getAccount: function(component, accId, acc){
        helper.hideMessage(component);
        var acctAction = component.get("c.getAccount");
        
        acctAction.setParams({ accountId : accId });
        
        acctAction.setCallback(this, function(acctActionResponse) {
            var state = acctActionResponse.getState();
            if (state === "SUCCESS") {
                acc = acctActionResponse.getReturnValue();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = acctActionResponse.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error("Error message: " + 
                                          errors[0].message);
                        }                        
                        helper.showMessage(component, errors[0].message, true);
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(acctAction); 
        
    },
    
    validateSection: function(component, event, helper){
        helper.hideMessage(component);
        
        component.set('v.isSectionValid',false);
        
        var tcrCallReq = component.get('v.requiredFields');
        var isValidSection = false;
        var isValidCalls = true;
      
        if(component.get('v.isEmptyCalls')){
            component.set('v.isSectionValid', false);
            component.set('v.validateCallSection',false);
            helper.showMessage(component, 'Please select Account.', true);
            isValidCalls = false;
        }
        
        if(isValidCalls){        
            if(tcrCallReq != undefined){
                for(var i=0;i<tcrCallReq.length;i++){
                    
                    var allComponents = component.find(tcrCallReq[i]);
                    
                    if ($A.util.isArray(allComponents)) {
                        allComponents.forEach(function(element) {                       
                            if(element != undefined){
                                
                                if(element.get('v.required') != undefined){                                   
                                    var val = element.get('v.value');
                                    if(val === undefined || (val != undefined &&
                                                             val.toString().trim().length === 0)){
                                        element.reportValidity();
                                        isValidSection = false;
                                                                       
                                    }else{                                       
                                        isValidSection = true;                                  
                                    } 
                                }
                            }                      
                        });         
                    }      
                }   
                component.set('v.isSectionValid', isValidSection);
                component.set('v.validateCallSection',false);
            }
        }
        
    },  
    
    addAccount: function(component, event, helper){
        helper.hideMessage(component);
        var call = component.find('selectCall');
        var acc = component.get('v.selectedAccount');
        
        if(call != undefined){
            
            var callVal = call.get('v.value');
            var tcrCalls = component.get('v.tcrCalls');
            
            var isCallExist = false;
            var isAccountExist = false;
            
            
            if(callVal != undefined){
                for(var i = 0; i<tcrCalls.length;i++){
                    
                    var call = tcrCalls[i];
                    
                    if(call.Call_No__c == callVal){
                        isCallExist = true;                        
                    }                        
                }                             
            }          
            
            if(acc != undefined &&  acc.Id != undefined){
                
                var isAccountExist = false;
                var acc = component.get('v.selectedAccount');
                for(var i = 0; i<tcrCalls.length;i++){
                    var call = tcrCalls[i];
                    
                    if(call.Account__c === acc.Id){
                        isAccountExist = true;
                    }else{
                        component.find('accountLookup').clear();
                    }                           
                }
                
                if(isAccountExist){
                    
                    helper.showMessage(component, 'Account is already selected.', true);
                    //  helper.showToast({'message' : 'Account is already selected.',
                    //                   'type':'ERROR',
                    //                    'title':''});
                }else{
                    if(isCallExist){                                   
                        helper.editCall(component, event, helper, acc.Id, callVal);      
                    }else{                      
                        helper.addToCall(component, event, helper, acc.Id, callVal);            
                    }                
                }                                                
            }else{
                helper.showMessage(component, 'Please select account.', true);
                // helper.showToast({'message' : 'Please select account.',
                //                  'type':'ERROR',
                //                  'title':''});
            }                                        
        }
    },
    
    addToCall : function(component, event, helper, accId, callNo){
        helper.hideMessage(component);
        
        var callAction = component.get("c.addTcrCallAccount");
        var tcrCalls = component.get('v.tcrCalls');
        var newTcrCalls = [];
        var callsParam;
        
        if(tcrCalls != undefined && tcrCalls.length > 0){
            if(tcrCalls.length == 1 && tcrCalls[0].Account__c === undefined){
                callsParam = JSON.stringify(newTcrCalls);            
            } else{
                callsParam = JSON.stringify(tcrCalls);
            }           
        }        
        
        callAction.setParams({ callNo : callNo,
                              accountId : accId,            
                              tcrCalls : callsParam });
        
        callAction.setCallback(this, function(callActionResponse) {
            var state = callActionResponse.getState();
            if (state === "SUCCESS") {
                var tcrCalls = callActionResponse.getReturnValue();
                
                
                if(tcrCalls != undefined){
                    component.set('v.callCount', tcrCalls.length.toString() )   
                }
                
                component.set('v.tcrCalls', callActionResponse.getReturnValue());
                component.set('v.isWithUnsaved', true);
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = callActionResponse.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error("Error message: " + 
                                          errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(callAction);  
        
    },
    
    editCall : function(component, event, helper, accId, callNo){
        helper.hideMessage(component);
        var callEditAction = component.get("c.editTcrCallAccount");
        var tcrCalls = component.get('v.tcrCalls');
        var newTcrCalls = [];
        var callsParam;
        
        if(tcrCalls != undefined && tcrCalls.length > 0){
            if(tcrCalls.length == 1 && tcrCalls[0].Account__c === undefined){
                callsParam = JSON.stringify(newTcrCalls);            
            } else{
                callsParam = JSON.stringify(tcrCalls);
            }           
        }        
        
        callEditAction.setParams({ callNo : callNo,
                                  accountId : accId,            
                                  tcrCalls : JSON.stringify(tcrCalls) });
        
        callEditAction.setCallback(this, function(callActionResponse) {
            var state = callActionResponse.getState();
            
            if (state === "SUCCESS") {
                var tcrCalls = callActionResponse.getReturnValue();
                
                if(tcrCalls != undefined){
                    component.set('v.callCount', tcrCalls.length.toString() )   
                }
                
                component.set('v.tcrCalls', callActionResponse.getReturnValue());
                component.set('v.isWithUnsaved', true);              
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = callActionResponse.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error("Error message: " + 
                                          errors[0].message);
                        }
                        
                        helper.showMessage(component, errors[0].message, true);
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(callEditAction);  
        
    },
    
    deleteCall: function(component, event, helper){
        helper.hideMessage(component);
        var isDisable = component.get('v.isDisabled');
        
        if(!isDisable){
          
            
            var callId = component.get('v.callToDeleteId');
            var calls = component.get('v.tcrCalls');
            var callsLen = calls.length;
            var isDelete = false;
            var toDelete;
            
            for(var i=0; i< callsLen; i++){
                var call = calls[i];
            
                
                if(call.Account__c == callId){
                    isDelete = true;                           
                    toDelete = call;                                    
                }
            }
            
            if(isDelete){
                var delAction = component.get("c.deleteTcrCallAccount");
                
                delAction.setParams({ tcrCalls : JSON.stringify(calls),
                                     tcrRec : toDelete});
                
                delAction.setCallback(this, function(acctActionResponse) {
                    var state = acctActionResponse.getState();
                   
                    if (state === "SUCCESS") {     
                        helper.showMessage(component, 'Record was deleted', false);
                        
                        var callList = acctActionResponse.getReturnValue();
                       
                        component.set('v.tcrCalls', callList);
                        component.set('v.isWithUnsaved', true);   
                        component.set('v.isShowDelete',false);
                    }
                    else if (state === "INCOMPLETE") {
                        // do something
                    }
                        else if (state === "ERROR") {
                            var errors = acctActionResponse.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.error("Error message: " + 
                                                  errors[0].message);            
                                }                        
                                component.set('v.errorMessage', errors[0].message);
                                component.set('v.showErrorMessage', true);
                            } else {
                                console.log("Unknown error");
                            }
                        }
                });        
                $A.enqueueAction(delAction); 
            }
        }                
    },
    
    setAccount : function(component, event, helper){
        helper.hideMessage(component);
        var callNo = event.getSource().get('v.value');
        var tcrCalls = component.get('v.tcrCalls');
        
        var isCallExist = false;
        for(var i = 0; i<tcrCalls.length;i++){
            var call = tcrCalls[i];
            if(call.Call_No__c.toString() == callNo.toString()){              
                component.set('v.selectedAccount',call.Account__r);
                
                component.find('accountLookup').showValue();
            }else{
                component.find('accountLookup').clear();
            }                           
        }
    },
    
    showToast : function(alertMessage) {
        
        var toastEvent = $A.get("e.force:showToast");
       
        toastEvent.setParams({
            "title": alertMessage.title,
            "type": alertMessage.type,
            "message": alertMessage.message
        });
        toastEvent.fire();
    },
    
    hideMessage: function(component){        
        component.set('v.showNotifToast',false);
        component.set('v.showErrorMessage',false);      
    },
    
    showMessage: function(component, message, isError){
        if(isError){
            component.set('v.errorMessage', message);
            component.set('v.showErrorMessage', true);
        }else{            
            component.set('v.toastMessage', message);
            component.set('v.showNotifToast', true);                      
        }        
    }
})