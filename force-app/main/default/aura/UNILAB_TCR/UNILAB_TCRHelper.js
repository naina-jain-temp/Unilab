({    
    // Create or Edit TCR
    getTCR: function(component, event, helper){ 
        component.set('v.spinner', true);
        var isNewTCR = false;        
        var recId = component.get('v.recordId');     
        
        var  tcrAction = component.get('c.getTcrRecord');            
        tcrAction.setParams({  recordId : recId  })            
        
        tcrAction.setCallback(this, function(tcrReponse) {     
            
            var state = tcrReponse.getState();
            
            if(state === 'SUCCESS'){                
                var tcrRec = tcrReponse.getReturnValue();
                var isDraft = component.get('v.isDraft');                
                isNewTCR = tcrRec.Id === undefined;
                
                component.set("v.tcr", tcrRec);
                helper.getTcrFielLabels(component, event, helper, tcrRec);                                           
                
                component.set('v.isWithPreviousTcr',tcrRec.isWithPreviousTcr__c || !isDraft);
                
                if(tcrRec.RecordType.Name === component.get('v.accountTcr') || tcrRec.RecordType.Name === component.get('v.t3Tcr')){                        
                    component.set('v.isWithCalls', true);
                    if(isNewTCR){                           
                        helper.getTCRcalls(component, event, helper, tcrRec);                        
                    }else{
                        var tcrCalls = tcrRec.Training_Contact_Report_Calls__r;
                        if(tcrCalls === undefined){
                            helper.getTCRcalls(component, event, helper, tcrRec);    
                        }else{
                            component.set("v.tcrCalls",tcrCalls);                                                                              
                            helper.getTcrCallFieldInfo(component, event, helper, tcrRec, tcrRec.Training_Contact_Report_Calls__r);
                        }                                                
                    }
                }                                
                
                var isStatusDraft = tcrRec.Status__c == component.get('v.Draft') || tcrRec.Status__c == component.get('v.PendingConcur') ;
                
                component.set('v.isDisabled',!isStatusDraft);
                component.set('v.isDraft',isStatusDraft);
                component.set('v.isAllowSave',isStatusDraft);                              
                
                if(tcrRec.Status__c === component.get('v.PendingConcur')){
                    component.set('v.isRequired',true);
                    helper.getRequiredFieldMap(component, event, helper, tcrRec);
                }
                component.set('v.spinner', false);
                
            }else if(state === 'ERROR'){
                var errors = tcrReponse.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    console.error(errors[0].message);
                    
                    helper.showMessage(component, errors[0].message, true);
                    // helper.showToast({'message' : errors[0].message  ,
                    //                  'type':'ERROR',
                    //                  'title':''});
                    //  helper.redirect();
                } 
                component.set('v.spinner', false);
            }                                                        
        });            
        $A.enqueueAction(tcrAction);			
    },
    //Get TCR from Quick Action
    getTcrById: function(component, event, helper){
        helper.hideMessage(component);
        
        var tcrRec = component.get('v.tcr');
        var callAction = component.get("c.getTcrRecord");
        
        callAction.setParams({ recordId : tcrRec.Id });
        
        callAction.setCallback(this, function(callActionResponse) {
            var state = callActionResponse.getState();
            
            if (state === "SUCCESS") {                
                component.set('v.tcr',callActionResponse.getReturnValue());                          
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
                            
                            helper.showMessage(component, errors[0].message, true);
                            //helper.showToast({'message' : errors[0].message  ,
                            //                  'type':'ERROR',
                            //                  'title':''});
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(callAction);   
    },
    // Get Required Fields from custom setting
    getRequiredFieldMap: function(component, event, helper, tcr){             
        helper.hideMessage(component);
      
        var getRequiredAction = component.get("c.getMapRequiredFieldsByPageNo");
        
        getRequiredAction.setParams({ tcrType : tcr.RecordType.Name });
        
        getRequiredAction.setCallback(this, function(requiredFieldResponse) {
            var state = requiredFieldResponse.getState();
            
            if (state === "SUCCESS") {             
                
                var allRequiredFieldsMap = requiredFieldResponse.getReturnValue();
                component.set('v.tcrRequiredFieldMap', allRequiredFieldsMap); 
                
                if(allRequiredFieldsMap != undefined){ 
                    var callSection = component.get('v.callsSection').toString();
                    
                    component.set('v.tcrCallRequiredFields', JSON.parse(allRequiredFieldsMap[callSection]));    
                }
                
                
                helper.validateComponent(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = requiredFieldResponse.getError();
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
        
        $A.enqueueAction(getRequiredAction);      
    },
    // Get CDS calls based on workplan
    getTCRcalls: function(component, event, helper, tcrRec){        
        helper.hideMessage(component);
        
        var callAction = component.get("c.getCdsCalls");
        
        callAction.setParams({ tcr : tcrRec });
        
        callAction.setCallback(this, function(callActionResponse) {
            var state = callActionResponse.getState();
            
            if (state === "SUCCESS") {
                component.set('v.tcrCalls',callActionResponse.getReturnValue());
                
                helper.getTcrCallFieldInfo(component, event, helper, tcrRec,callActionResponse.getReturnValue());                
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
                        component.set('v.tcr', null);
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(callAction);        
    },
    // Format options for radio group button based on fields picklist values
    populateOptions : function(optionList, optionArray) {       
        
        for(let i = 0; i< optionList.length; i++){
            optionArray.push({label: optionList[i], value: optionList[i]});
        }               
    },
    // Get TCR Object fields info
    getTcrFielLabels : function(component, event, helper, tcr) {  
        helper.hideMessage(component);
        
        var fieldLabelsAction = component.get('c.getCustomFieldInfo');
        
        fieldLabelsAction.setParams({  objectName : 'Training_Contact_Report__c',
                                     tcrType : tcr.RecordType.Name});
        
        fieldLabelsAction.setCallback(this, function(response) { 
            
            var state = response.getState();
            
            if(state === 'SUCCESS'){                
                
                var customFieldInfo = response.getReturnValue();
                
                component.set("v.tcrFieldLabelMap", customFieldInfo);   
                
                for(var apiName in customFieldInfo ){
                    
                    var fieldDetail = JSON.parse(customFieldInfo [apiName]);               
                    var cmp = component.find(apiName);
                    
                    if(cmp !== undefined){
                        cmp.set('v.label',fieldDetail.label);
                        
                        if(cmp.get('v.placeholder') !== undefined){
                            cmp.set('v.placeholder',fieldDetail.helpText);        
                        }
                        
                        var selectOptions = fieldDetail.picklistValues;
                        if(selectOptions !== undefined && selectOptions.length > 0){
                            var optionArray=[];                       
                            helper.populateOptions(selectOptions, optionArray);
                            
                            cmp.set('v.options',optionArray);
                        }
                    }                                
                } 
                
                var tcrRec = component.get('v.tcr');
                console.log(tcrRec.Closing_Skill_1__c);
                console.log(tcrRec.Closing_Skill_2__c);
                if(tcrRec.Closing_Skill_1__c != undefined){
                    helper.getSpecificSkillDev(component, helper, tcrRec.Closing_Skill_1__c, 1);
                }
                
                if(tcrRec.Closing_Skill_2__c != undefined){
                    helper.getSpecificSkillDev(component, helper, tcrRec.Closing_Skill_2__c, 2);
                }
                
            }else if(state === 'ERROR'){
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    console.error(errors[0].message);
                } 
                
                helper.showMessage(component, errors[0].message, true);
                //helper.showToast({'message' : errors[0].message  ,
                //                    'type':'ERROR',
                //                   'title':''});
                
                component.set('v.showSubmitConfirm',false);
            }              
        });  
        $A.enqueueAction(fieldLabelsAction);           
    },   
    // Get TCR Call Object fields info
    getTcrCallFieldInfo : function(component, event, helper, tcr, tcrCalls) {  
        helper.hideMessage(component);
        
        var action = component.get("c.getCustomFieldInfo");
        action.setParams({ objectName : 'Training_Contact_Report_Call__c',
                          tcrType : tcr.RecordType.Name
                         });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var tcrCallFieldInfo = response.getReturnValue();	    
                
                component.set('v.tcrCallFieldInfoMap', tcrCallFieldInfo);                                 
                component.set('v.renderTradeTcr', true);                                            
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
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
        
        $A.enqueueAction(action);
    },
    // Save TCR
    saveRecord: function(component, event, helper) {              
        helper.hideMessage(component);
        component.set('v.spinner', true);
        var tcrRec = component.get('v.tcr');
        var tcrCallsRec = component.get('v.tcrCalls');                        
        var saveTcrAction = component.get('c.saveTCR');
        
        saveTcrAction.setParams({"currentTcr" : tcrRec,
                                 "tcrCalls" : JSON.stringify(tcrCallsRec)
                                });
        
        saveTcrAction.setCallback(this, function(response) {    
            var state = response.getState();
            
            if(state === 'SUCCESS'){                
                
                var savedRecord = response.getReturnValue();
                
                component.set('v.renderTradeTcr',false);                
                component.set("v.tcr", savedRecord);   
                component.set('v.isWithUnsaved',false);
                component.set('v.showUnsaveConfirm',false);
                
                
                
                var savedTcrCalls = savedRecord.Training_Contact_Report_Calls__r;              
                
                if(savedTcrCalls == undefined && savedRecord.RecordType.Name ===  component.get('v.t3Tcr')){                   
                    helper.getTCRcalls(component, event, helper, savedRecord);
                }else{
                    component.set("v.tcrCalls", savedRecord.Training_Contact_Report_Calls__r);
                }
                
                if(component.get('v.currentStep') === component.get('v.callsSection') && component.get('v.isWithCalls')){
                    component.set('v.renderTradeTcr',true);         
                }
                console.log('end response');
                component.set('v.spinner', false);
            }else if(state === 'ERROR'){
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    console.error(errors[0].message);
                } 
                
                helper.showMessage(component, errors[0].message, true);
                //helper.showToast({'message' : errors[0].message  ,
                //                    'type':'ERROR',
                //                   'title':''});
                
                component.set('v.showSubmitConfirm',false);
                component.set('v.spinner', false);
            }                    
        });
        console.log('before enqeu');            
        $A.enqueueAction(saveTcrAction);      
    },  
    // Record Sharing           
    updateOwner: function(component, event, helper, isUPdateStatus){
        helper.hideMessage(component);
        
        var tcr = component.get('v.tcr');
        var statusAction = component.get('c.updateRecOwner');    
        
        statusAction.setParams({  tcr : tcr  })
        
        statusAction.setCallback(this, function(response) {    
            var state = response.getState();
            
            
            if(state === 'SUCCESS'){
                
                if(isUPdateStatus){
                    
                    helper.showMessage(component, 'Status has been successfully updated.', false);
                    
                    // helper.showToast({'message' : 'Status has been successfully updated.',
                    //             'type':'SUCCESS',
                    //             'title':''});
                    
                    helper.navigateToRecord(event, tcr.Id); 
                }
                
                
            }else if(state === 'ERROR'){
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    console.error(errors[0].message);
                    helper.showMessage(component, errors[0].message, true);
                    
                    // helper.showToast({'message' : errors[0].message  ,
                    //                  'type':'ERROR',
                    //                 'title':''});
                    
                    helper.navigateToRecord(event, tcr.Id); 
                } 
            }                                    
        });
        $A.enqueueAction(statusAction);    
    },    
    // Update TCR status from draft to submit
    updateStatusRecord:function(component, event, helper){  
        helper.hideMessage(component);
        
        var tcr = component.get('v.tcr');
        var statusAction = component.get('c.updateTCRStatus');    
        
        statusAction.setParams({  currentTcr : tcr  })
        
        statusAction.setCallback(this, function(response) {    
            var state = response.getState();           
            
            if(state === 'SUCCESS'){
                var updatedTcr = response.getReturnValue();
                
                component.set('v.isDisabled',true);
                component.set('v.showSubmitConfirm',false);
                component.set('v.isWithPreviousTcr',true);
                component.set('v.isAllowSave',false);
                component.set('v.isDraft',false);
                
                component.set('v.tcr',updatedTcr); 
                
                helper.showMessage(component, 'Record is successfully submitted.', true);
                
                //  helper.showToast({'message' : 'Record is successfully submitted.',
                ///              'type':'SUCCESS',
                //               'title':''});
                
                helper.updateOwner(component, event, helper, false);
                
                if(updatedTcr.Status__c === 'Pending Concurrence' || (updatedTcr.Type === component.get('v.T3Tcr') && updatedTcr.Status__c === component.get('v.pendingApproval'))){
                    var event = $A.get( 'e.force:navigateToSObject' );
                    
                    event.setParams({
                        'recordId' : updatedTcr.Id,
                        'slideDevName' : 'Detail'
                    }).fire();               
                }
                
            }else if(state === 'ERROR'){
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    console.error(errors[0].message);
                } 
                helper.showMessage(component, errors[0].message, true);
                //helper.showToast({'message' : errors[0].message  ,
                //                    'type':'ERROR',
                //                                      'title':''});
                
                component.set('v.showSubmitConfirm',false);
            }                                    
        });
        $A.enqueueAction(statusAction);         
    },
    // Start of Required Fields Validation
    validateRequiredFields: function(component, event, helper){                 
        helper.hideMessage(component);
        component.set('v.showSubmitConfirm', false);
        component.set('v.isRequired', true);
        component.set('v.spinner',true);       
        helper.getRequiredFieldMap(component, event, helper, component.get('v.tcr'));        
        component.set('v.spinner',false);
    },    
    // Check for required fields in all TCR section
    validateComponent: function(component, event, helper){         
        helper.hideMessage(component);
        
        var withEmptyRequired = 1;
        var requiredFields = component.get('v.tcrRequiredFieldMap');
        
        for(var section in requiredFields){           
            var requiredFieldList = JSON.parse(requiredFields [section]);
            for(var i = 0; i<requiredFieldList.length;i++){               
                var cmp = component.find(requiredFieldList[i]);
                if(cmp != undefined){
                    var val = cmp.get('v.value');
                    
                    if(val === undefined || (val != undefined &&
                                             val.toString().trim().length === 0)){
                        cmp.reportValidity();
                        if(withEmptyRequired === 1){
                            
                            withEmptyRequired = section;
                            
                            //if (component.get('v.currentStep') !== '10') {  
                            component.set('v.stepToValidate', withEmptyRequired);
                            //}
                            component.set('v.isSectionValid', false);                                                                                   
                        }  
                        cmp.reportValidity();
                    }
                    
                    if(cmp.get('v.required') !== undefined){                        
                        cmp.set('v.required',"{!v.isRequired}"); 
                        cmp.reportValidity();
                    }
                }
            }                  
        }
        
        var tcr = component.get('v.tcr');
        var t3 = component.get('v.t3Tcr');
        var valtcrCalls = component.get('v.tcrCalls');
        var isEmptyTcrCalls = false;
        
        if(withEmptyRequired ===  1 && tcr.RecordType.Name === t3){
            if(valtcrCalls != undefined && valtcrCalls.length > 0){
                if(valtcrCalls.length == 1 && valtcrCalls[0].Account__c === undefined){
                    isEmptyTcrCalls = true;    
                }            
            }else{
                isEmptyTcrCalls = true;
            }
            
            if(isEmptyTcrCalls){
                withEmptyRequired = component.get('v.callsSection');
                
                component.set('v.stepToValidate', withEmptyRequired);
                component.set('v.isSectionValid', false);   
                component.set('v.renderTradeTcr', true);             
            }
        }
        
        
        if(withEmptyRequired ===  1){
            if(component.get('v.isDraft') && component.get('v.currentStep') === '10'){
                component.set('v.showSubmitConfirm' , true);  
                component.set('v.stepToValidate', '0');
            }            
        }else{           
            component.set('v.currentStep', withEmptyRequired);
            helper.showMessage(component, 'Please fill-in required fields.', true); 
            
            //  helper.showToast({'message' : 'Please fill-in required fields.',
            //                 'type':'ERROR',
            //                'title':''});
        }
        
        
    },  
    // Check for required fields in the current TCR section
    validateSection : function(component, event, helper, reqMap, getCurrentStep){
        helper.hideMessage(component);
        var reqFieldsResult = reqMap[getCurrentStep.toString()];
        var isWithError = false;
        
        if(reqFieldsResult === undefined){
            component.set('v.isSectionValid', true);
        } else{
            
            var reqFields = JSON.parse(reqFieldsResult);  
            
            for(var i=0;i<reqFields.length;i++){
                
                var cmp = component.find(reqFields[i]);
                
                if(cmp != undefined){                    
                    
                    var val = cmp.get('v.value');
                    
                    if(val === undefined || (val != undefined &&
                                             val.toString().trim().length === 0)){
                        
                        if(!isWithError){
                            isWithError = true;
                            component.set('v.stepToValidate', getCurrentStep);
                        }
                        cmp.reportValidity(); 
                    }                    
                    component.set('v.isSectionValid', !isWithError);
                }                        
            }                                    
        }
    },
    // Save and Next
    moveNextPage: function(component, event, helper, nextPageNo) {                   
        helper.hideMessage(component);
        // control the next button based on 'currentStep' attribute value      
        var reqMap = component.get('v.tcrRequiredFieldMap');
        var getCurrentStep = parseInt(component.get("v.currentStep"), 10);  
        var getStepToValidate = parseInt(component.get("v.stepToValidate"), 10);  
        
        if(component.get('v.isRequired') && component.get('v.isDraft')){             
            if(component.get('v.callsSection') === getCurrentStep.toString() && component.get('v.isWithCalls')){               
                component.set('v.validateCallSection', true);
            }else{                  
                
                if(nextPageNo < getCurrentStep){                              
                    component.set('v.validateCallSection', false); 
                    helper.validateSection(component, event, helper, reqMap, nextPageNo);                    
                }else{                      
                    component.set('v.validateCallSection', false); 
                    helper.validateSection(component, event, helper, reqMap, getCurrentStep);
                }                
            }
            
        }else{
            component.set('v.isSectionValid', true);
        }
        
        
        if(component.get('v.isSectionValid')){
            if(component.get('v.isWithUnsaved')){             
                helper.saveRecord(component, event, helper, false);     
            }     
            
            if(nextPageNo.toString() == component.get('v.callsSection') && component.get('v.isWithCalls')){
                component.set('v.renderTradeTcr',true);         
            }
            
            component.set('v.currentStep', nextPageNo.toString());
            
            setTimeout(function(){
                document.getElementById('tcrForm').scrollIntoView({block: "start", inline: "nearest"});
            }, 10);
            
        }else{
            
            helper.showMessage(component, 'Please fill-in required fields.', true); 
            // helper.showToast({'message' : 'Please fill-in required fields.',
            //              'type':'ERROR',
            //              'title':''});    
        }   
        
    },
    // Show specific TCR section 
    goToPage : function(component, pageNo){
        //helper.hideMessage(component);
        
        var currentStep = parseInt(component.get("v.currentStep"), 10);     
        
        if (currentStep != 10) {                    
            component.set("v.currentStep", pageNo.toString());                    
        }                    
    },    
    // Show message
    showToast : function(alertMessage) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": alertMessage.title,
            "type": alertMessage.type,
            "message": alertMessage.message
        });
        toastEvent.fire();
    },
    
    redirect: function (){
        var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
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
        
        setTimeout(function(){
            document.getElementById('errormessage').scrollIntoView({block: "start", inline: "nearest"});
        }, 10);
    },
    
    getSpecificSkillDev: function(component, helper, skillCompetency, skillNo){
        helper.hideMessage(component);
        component.set('v.spinner', true);
        
        var callAction = component.get("c.getSpecificSkillDevelopment");            
        callAction.setParams({ skillCompetency : skillCompetency });
        
        callAction.setCallback(this, function(callActionResponse) {
            var state = callActionResponse.getState();			 
            var skillList = callActionResponse.getReturnValue();
            
            if (state === "SUCCESS") {                
                // component.set('v.specificSkillDevList',skillList);                          
                
                if(skillList !== undefined && skillList.length > 0){
                    var optionArray=[];                       
                    helper.populateOptions(skillList, optionArray);
                    
                    if(skillNo == 1){
                        component.set('v.specificSkillDev1List',optionArray);
                    }else if(skillNo == 2){
                        component.set('v.specificSkillDev2List',optionArray);
                    }                                                              
                }
                component.set('v.spinner', false);
            }
            else if (state === "INCOMPLETE") {
                // do something
                component.set('v.spinner', false);
            }
                else if (state === "ERROR") {
                    var errors = callActionResponse.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error("Error message: " + 
                                          errors[0].message);
                            
                            helper.showMessage(component, errors[0].message, true);
                            //helper.showToast({'message' : errors[0].message  ,
                            //                  'type':'ERROR',
                            //                  'title':''});
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    component.set('v.spinner', false);
                }
        });
        
        $A.enqueueAction(callAction);   
        
    },
})