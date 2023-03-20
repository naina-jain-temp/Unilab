({
	submitPromo : function(component, event, helper) {
        var reason = component.get("v.reasonCancel");
        
        if(reason != null){
            helper.updatePromoStatus(component, event);
            //helper.updateRelatedAllocationStatus(component, event);
        }else{
            alert('NO REASON');
        }
	},
    cancelPromo: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
})