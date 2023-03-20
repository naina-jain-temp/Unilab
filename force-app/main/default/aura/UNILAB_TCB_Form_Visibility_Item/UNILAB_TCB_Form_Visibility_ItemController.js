({
	optYesChange : function(component, event, helper) {
        var newCheckBoxValue = component.find("optYes");
        
        component.set("v.vData.Yes__c", newCheckBoxValue.get("v.checked"));
        component.set("v.vData.No__c", false);
        
        helper.reconstructArray(component);
    },
    optNoChange : function(component, event, helper) {
        var newCheckBoxValue = component.find("optNo");
        
        component.set("v.vData.No__c", newCheckBoxValue.get("v.checked"));
        component.set("v.vData.Yes__c", false);
        
        helper.reconstructArray(component);
    },
})