({
	getPicklistValues : function(component, picklistParameters) {
        
        component.set('v.showSpinner', true);
        
        var action = component.get("c.getPicklistFields");
        
        action.setParams({
            
            objectName : picklistParameters.objectName,
            fieldName : picklistParameters.fieldName
            
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var optionData = response.getReturnValue();
                var optionArray= [];
                
                if (picklistParameters.fieldName == 'Channel_Group__c') {
                    optionArray.push({
                        value: 'All',
                        label: 'All'
                    });
                }
                
                if (picklistParameters.fieldName == 'BU__c') {
                    optionArray.push({
                        value: 'None',
                        label: 'None'
                    });
                }
                
                for (var key in optionData) {
                    optionArray.push({
                        value: key, 
                        label: optionData[key]
                    });
                }
                
                component.set(picklistParameters.componentName, optionArray);
                
                component.set('v.showSpinner', false);
                
            }
            
            else {
                
                component.set('v.showSpinner', false);
                
                var errors = response.getError();
                
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    
                    this.showToastDisplay({
                        "title" : "Something went wrong",
                        "message" : errors[0].message,
                        "type" : "error"
                    });
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
		
	},
    
    getDependentPicklistValue : function(component, picklistParameters) {
        
        component.set('v.showSpinner', true);
        
        var action = component.get("c.getPicklistDependency");
        
        action.setParams({
            
            objectName : picklistParameters.objectName,
            controllingFieldName : picklistParameters.controllingAPIField,
            dependentFieldName : picklistParameters.dependentAPIField
            
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                component.set(picklistParameters.componentName, response.getReturnValue());
                
            }
            
            else {
                
                component.set('v.showSpinner', false);
                
                var errors = response.getError();
                
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    
                    this.showToastDisplay({
                        "title" : "Something went wrong",
                        "message" : errors[0].message,
                        "type" : "error"
                    });
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    filterPicklistForDependent : function(component, picklistParameters) {
        
        var dependentPicklistValue = picklistParameters.dependentPicklistValue;
        
        if (dependentPicklistValue.length > 0 || dependentPicklistValue != null) {
            
            var recordData = [];
            
            for (var key in dependentPicklistValue) {
                recordData.push({
                    label: key,
                    value: dependentPicklistValue[key]
                });
            }
            
            var regex;
            var results = recordData;
            
            regex = new RegExp(picklistParameters.filterBy, "i");
            results = results.filter(row=>regex.test(row.label));
            
            var picklistOptions = [];
            
            if (results.length > 0 && results != null) {
                
                for (var key in results) {
                    for (var i = 0; i < results[key].value.length; i++) {
                        picklistOptions.push({
                            value: results[key].value[i],
                            label: results[key].value[i]
                        });
                    }
                }
                
                component.set(picklistParameters.componentName, picklistOptions);
                
                if (picklistParameters.disablePicklistAuraID != null || picklistParameters.disablePicklistAuraID != '') {
                    this.disableEnable(component, picklistParameters.disablePicklistAuraID, false);
                }
                
            }
            
            else {
                
                picklistOptions.push({
                    value: '-',
                    label: '-'
                });
                
                component.set(picklistParameters.componentName, picklistOptions);
                
                if (picklistParameters.attributeName != 'v.brandList') {
                    component.set(picklistParameters.attributeName, '-');
                }
                else {
                    component.set(picklistParameters.attributeName, []);
                }
                
                component.find(picklistParameters.comboboxAuraID).set("v.value", "-");
                
                if (picklistParameters.disablePicklistAuraID != null || picklistParameters.disablePicklistAuraID != '') {
                    this.disableEnable(component, picklistParameters.disablePicklistAuraID, true);
                }
                
            }
            
        }
        
    },
    
    displayMonths : function(component, event, helper) {
        
        var month= ["All", "January", "February", "March", "April", "May", "June",
                    "July", "August", "September", "October", "November", "December"
                   ];
        
        var monthOptions = [];
        
        for (var i = 0; i <= 12; i++) {
            
            monthOptions.push({
                value: i.toString(),
                label: month[i]
            });
            
        }
        
        component.set('v.monthOptions', monthOptions);
        
    },
    
    getYear : function(component, event, helper) {
        
        var action = component.get("c.getDateYear");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var optionData = response.getReturnValue();
                
                var optionArray= [];
                
                for (var i = 0; i < optionData.length; i++) {
                    optionArray.push({
                        value: optionData[i],
                        label: optionData[i]
                    });
                }
                
                component.set('v.yearOptions', optionArray);
                
            }
            
            else {
                
                var errors = response.getError();
                
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    
                    this.showToastDisplay({
                        "title" : "Something went wrong",
                        "message" : errors[0].message,
                        "type" : "error"
                    });
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    exportData : function(component, event, helper) {
        
        var filterDateBySelected = component.get('v.filterDateBySelected');
        var startDate = component.get('v.startDateRecord');
        var endDate = component.get('v.endDateRecord');
        var monthDate = parseInt(component.get('v.monthSelected'));
        var yearDate = parseInt(component.get('v.yearSelected'));
        
        var filterParameters = {
            filterDateBySelected : filterDateBySelected,
            startDate : startDate,
            endDate : endDate,
            monthDate : monthDate,
            yearDate : yearDate
        };
        
        var action = component.get('c.getCompetitiveActivity');
        
        action.setParams({
            
            filterParameters : JSON.stringify(filterParameters)
            
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === 'SUCCESS') {
                
                var recordData = JSON.parse(response.getReturnValue());
                
                this.recordDataToVFPage(component, recordData, helper);
                
            }
            
            else {
                
                var errors = response.getError();
                
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    
                    this.showToastDisplay({
                        "title" : "Something went wrong",
                        "message" : errors[0].message,
                        "type" : "error"
                    });
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    recordDataToVFPage : function(component, recordData, helper) {
        
        var regex;
        var results = recordData;
        
        if (component.get('v.channelGroupName') != 'All') {
            if (component.get('v.channelName') != null) {
                regex = new RegExp(component.get('v.channelName'), "i");
                results = results.filter(row=>regex.test(row.channelName));
            }
        }
        
        if (component.get('v.buName') != null && component.get('v.buName') != 'None') {
            regex = new RegExp(component.get('v.buName'), "i");
            results = results.filter(row=>regex.test(row.buName));
        }
        
        if (component.get('v.divisionName') != null && component.get('v.buName') != 'None') {
            regex = new RegExp(component.get('v.divisionName'), "i");
            results = results.filter(row=>regex.test(row.divisionName));
        }
        
        if (component.get('v.brandList').length > 0 && component.get('v.buName') != 'None') {
            regex = new RegExp(component.get('v.brandList'), "i");
            results = results.filter(
                function (str) { 
                    return row=>regex.test(row.brandList);
                }
            );
        }
        
        if (results.length > 0) {
            
            var filterOptions = [];
            
            for (var i = 0; i < results.length; i++) {
                filterOptions.push(results[i].competitiveID);
            }
            
            window.open( "/apex/UNILAB_CompetitiveActivity_Export?filterOptions="+ JSON.stringify(filterOptions));
            
        }
        
        else {
            
            this.showToastDisplay({
                "title" : "No Results Found",
                "message" : "No Results Returned according to your Filters",
                "type" : "error"
            });
            
        }
        
    },
    
    disableEnable : function(component, targetInputOrCombobox, isDisabled) {
      
        component.find(targetInputOrCombobox).set("v.disabled", isDisabled);
        
    },
    
    showToastDisplay : function(alertMessage) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            
            "title": alertMessage.title,
            "message": alertMessage.message,
            "type": alertMessage.type            
            
        });
        
        toastEvent.fire();
        
    }
    
})