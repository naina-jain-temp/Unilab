({
    launchComponent : function(component, event) {
        var navService = component.find("navService");
        var idValue = component.get("v.recordId");
        
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__UNILAB_PAL_LeadView"               
            },
            "state": {
                "c__idValue" : idValue
            }
        };
        
        //event.preventDefault();
        navService.navigate(pageReference);
	}
})