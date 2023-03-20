({
    doInit : function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
        
        helper.getTCRType(component, recordId);
        
    }
    
})