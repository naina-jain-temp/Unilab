({
	doInit : function(component, event, helper) {
        helper.fetchAlllocInfo	(component, event, helper);
        /*if(component.get("v.recordId") != null){
            	
            helper.fetchPromoInfo(component, event, helper);
        }*/
        
	},
    
    closePostponeModal : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    saveAndSubmit: function(component, event, helper){
        
        helper.updateAllocation(component, event, helper);
        component.set("v.isPostponeOpen", false);
        
    },

})