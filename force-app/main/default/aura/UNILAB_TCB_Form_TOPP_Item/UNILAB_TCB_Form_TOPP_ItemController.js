({
	optYesChange : function(component, event, helper) {
        var newCheckBoxValue = component.find("optYes");
        
        component.set("v.tData.Yes__c", newCheckBoxValue.get("v.checked"));
        component.set("v.tData.No__c", false);
        
        helper.reconstructArray(component);
    },
    optNoChange : function(component, event, helper) {
        var newCheckBoxValue = component.find("optNo");
        
        component.set("v.tData.No__c", newCheckBoxValue.get("v.checked"));
        component.set("v.tData.Yes__c", false);
        
        helper.reconstructArray(component);
    },
})