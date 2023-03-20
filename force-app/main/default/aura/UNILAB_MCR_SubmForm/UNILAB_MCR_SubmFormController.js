({
	doInit : function(component, event, helper) {
        helper.getLocation(component);
		helper.getNetworkTest(component);
	},
    
    submitHandleClick : function(component, event, helper) {
        helper.submit(component);
    },
})