({    
    scriptsLoad : function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
        
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        
        helper.getTCRType(component, recordId);
        
    }
    
})