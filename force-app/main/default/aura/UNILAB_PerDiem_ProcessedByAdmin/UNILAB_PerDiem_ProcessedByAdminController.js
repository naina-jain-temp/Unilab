({
	doInit : function(component, event, helper) {
		helper.getApprovalStatus(component);
	},
    process : function(component, event, helper) {
        helper.tagAsProcessedByAdmin(component, event);
    }
})