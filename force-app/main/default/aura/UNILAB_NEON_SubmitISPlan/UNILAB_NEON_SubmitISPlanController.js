({
	init : function(component, event, helper) {
        helper.loadData(component, event);
        helper.ctOptions(component);
	},
    
    submitISP : function(component, event, helper) {
        helper.submitISP(component, event);
    }
})