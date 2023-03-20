({
	cloneAllocation : function(component, event, helper) {
        helper.cloneAllocationRecord(component,event, helper);
	},
    cancelAllocation: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
})