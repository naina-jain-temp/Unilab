({
	doInit : function(component, event, helper) {
		helper.getTcrById(component, event, helper);
	},
    
    handleApprove : function(component, event, helper){     
        component.set('v.isShowApprovalConfirm', true);       
    },
    
    handleCancelApproval: function(component, event, helper){
        helper.cancelApproval(component, event, helper);
    },
    
    handleUpdateStatus: function(component, event, helper){
        helper.updateStatus(component, event, helper);
    },    
})