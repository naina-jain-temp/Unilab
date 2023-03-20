({
    doInit:function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();      
        
        /*var urlEvent = $A.get("e.force:navigateToComponent");
        urlEvent.setParams({
            componentDef: "c:UNILAB_PAL_LeadView",
            componentAttributes: {
            contactName : component.get("v.recordId")
        }
        });
        urlEvent.fire();*/
        
        helper.launchComponent(component, event);
        
         
    },
})