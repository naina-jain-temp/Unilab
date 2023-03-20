({
    doInit: function (component, event, helper) {
        //var recordId = component.get('v.recordId');
        //helper.loadData(component,recordId);
    },
    handleApprove : function (component, event, helper) {
        var recordId = component.get('v.recordId');
        if(!helper.handleValidation(component, event, helper)){
            helper.handleApproveReject(component,helper,recordId,'Approve');
        }
        else{
            helper.showToast('Validation Error','Please add comments.');
        }        
    },
    handleReject : function (component, event, helper) {
        var recordId = component.get('v.recordId');
        if(!helper.handleValidation(component, event, helper)){
            helper.handleApproveReject(component,helper,recordId,'Reject');
        }
        else{
            helper.showToast('Validation Error','Please add comments.');
        }
    },
})