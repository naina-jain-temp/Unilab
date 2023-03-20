({
    doInit : function(component, event, helper) {
        
        var newDate = new Date();
        
        var todayDate = new Date().toISOString().slice(0, 10);
        var yearSelected = newDate.getFullYear();
        
        component.set('v.startDateRecord', todayDate);
        component.set('v.endDateRecord', todayDate);
        component.set('v.yearSelected', yearSelected.toString());
        
        helper.getPicklistValues(component, {
            "objectName" : "Competitive_Activity__c",
            "fieldName" : "Channel_Group__c",
            "componentName" : "v.channelGroupOptions"
        });
        
        helper.getDependentPicklistValue(component, {
            "objectName" : "Competitive_Activity__c",
            "controllingAPIField" : "Channel_Group__c",
            "dependentAPIField" : "Channel__c",
            "componentName" : "v.channelDepList"
        });
        
        helper.getPicklistValues(component, {
            "objectName" : "Competitive_Activity__c",
            "fieldName" : "BU__c",
            "componentName" : "v.buOptions"
        });
        
        helper.getDependentPicklistValue(component, {
            "objectName" : "Competitive_Activity__c",
            "controllingAPIField" : "BU__c",
            "dependentAPIField" : "Division__c",
            "componentName" : "v.divisionDepList"
        });
        
        helper.getDependentPicklistValue(component, {
            "objectName" : "Competitive_Activity__c",
            "controllingAPIField" : "Division__c",
            "dependentAPIField" : "Brand__c",
            "componentName" : "v.brandDepList"
        });
        
        helper.displayMonths(component, event, helper);
        helper.getYear(component, event, helper);
        
    },
    
    handleChange : function(component, event, helper) {
        
        var comboboxName = event.getSource().getLocalId();
        var eventValue = event.getParam("value");
        
        // filterDateBy
        
        if (comboboxName == 'filterDateBy') {
            component.set('v.filterDateBySelected', eventValue);
            
            if (eventValue != null || eventValue != '') {
                helper.disableEnable(component, 'channelGroupName', false);
                helper.disableEnable(component, 'buName', false);
                helper.disableEnable(component, 'exportButton', false);
            }
            
            if (eventValue == 'dateRangeByDateField' || eventValue == 'dateRangeByDateImplementedField') {
                // Start Date and End Date
                helper.disableEnable(component, 'startDateRecord', false);
                helper.disableEnable(component, 'endDateRecord', false);
                // Month and Year
                helper.disableEnable(component, 'monthDate', true);
                helper.disableEnable(component, 'yearDate', true);
            }
            
            if (eventValue == 'monthAndYear') {
                // Start Date and End Date
                helper.disableEnable(component, 'startDateRecord', true);
                helper.disableEnable(component, 'endDateRecord', true);
                // Month and Year
                helper.disableEnable(component, 'monthDate', false);
                helper.disableEnable(component, 'yearDate', false);
            }
            
        }
        
        // monthDate
        
        if (comboboxName == 'monthDate') {
            component.set('v.monthSelected', eventValue);
        }
        
        // yearDate
        
        if (comboboxName == 'yearDate') {
            component.set('v.yearSelected', eventValue);
        }
        
        // channelGroupName
        
        if (comboboxName == 'channelGroupName') {
            component.set('v.channelGroupName', eventValue);
            
            if (eventValue == 'All') {
                helper.disableEnable(component, 'channelName', true);
                helper.disableEnable(component, 'buName', false);
            }
            else {
                helper.filterPicklistForDependent(component, {
                    "dependentPicklistValue" : component.get('v.channelDepList'),
                    "filterBy" : eventValue,
                    "attributeName" : 'v.channelName', // reference for Filter Export
                    "componentName" : 'v.channelOptions',
                    "comboboxAuraID" : 'channelName',
                    "disablePicklistAuraID" : 'buName'
                });
                helper.disableEnable(component, 'channelName', false);
            }
            
        }
        
        // channelName
        
        if (comboboxName == 'channelName') {
            component.set('v.channelName', eventValue);
            
            if (eventValue != null || eventValue != '') {
                helper.disableEnable(component, 'buName', false);
            }
            else {
                helper.disableEnable(component, 'buName', true);
            }
            
        }
        
        // buName
        
        if (comboboxName == 'buName') {
            component.set('v.buName', eventValue);
            
            if ((eventValue != null || eventValue != '') && eventValue != 'None') {
                helper.filterPicklistForDependent(component, {
                    "dependentPicklistValue" : component.get('v.divisionDepList'),
                    "filterBy" : eventValue,
                    "attributeName" : 'v.divisionName', // reference for Filter Export
                    "componentName" : 'v.divisionOptions',
                    "comboboxAuraID" : 'divisionName',
                    "disablePicklistAuraID" : 'divisionName'
                });
                
                component.set('v.brandList', []);
                
                helper.disableEnable(component, 'divisionName', false);
                helper.disableEnable(component, 'brandList', true);
                component.set('v.brandOptions', []);
                component.find('brandList').set("v.value", []);
            }
            else {                
                helper.disableEnable(component, 'divisionName', true);
                helper.disableEnable(component, 'brandList', true);
                component.set('v.brandOptions', []);
                component.find('brandList').set("v.value", []);
            }
            
        }
        
        // divisionName
        
        if (comboboxName == 'divisionName') {
            component.set('v.divisionName', eventValue);
            
            if (eventValue != null || eventValue != '') {
                helper.filterPicklistForDependent(component, {
                    "dependentPicklistValue" : component.get('v.brandDepList'),
                    "filterBy" : eventValue,
                    "attributeName" : 'v.brandList', // reference for Filter Export
                    "componentName" : 'v.brandOptions',
                    "comboboxAuraID" : 'brandList',
                    "disablePicklistAuraID" : 'brandList'
                });
                helper.disableEnable(component, 'brandList', false);
                component.find('brandList').set("v.value", []);
            }
            else {                
                helper.disableEnable(component, 'brandList', true);
            }
            
            
        }
        
        // brandList
        
        if (comboboxName == 'brandList') {
            component.set('v.brandList', eventValue);
        }
        
    },

    callExportHelper : function(component, event, helper) {
        
        helper.exportData(component, event, helper);
        
    }
    
})