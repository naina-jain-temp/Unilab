({
	optYesChange : function(component, event, helper) {
        var newCheckBoxValue = component.find("optYes");
        
        component.set("v.aData.Yes__c", newCheckBoxValue.get("v.checked"));
        component.set("v.aData.No__c", false);
        
        helper.reconstructArray(component);
    },
    optNoChange : function(component, event, helper) {
        var newCheckBoxValue = component.find("optNo");
        
        component.set("v.aData.No__c", newCheckBoxValue.get("v.checked"));
        component.set("v.aData.Yes__c", false);
        
        helper.reconstructArray(component);
    },
})