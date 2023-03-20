({
    handleCancel : function (component, event, helper) {
        var recordId = component.get('v.recordId');
        if(!helper.handleValidation(component, event, helper)){
            helper.handleCancel(component,helper,recordId);
        }
        else{
            helper.showToast('Validation Error','Please add comments.');
        }        
    }
})