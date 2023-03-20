({
	concurRecord : function(component, event, helper) {
		helper.updateRecordStatus(component,event, helper);
	},
    cancelRecord: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
})