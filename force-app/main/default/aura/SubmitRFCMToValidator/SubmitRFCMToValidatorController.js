({
    doInit: function (component, event, helper) {
        var recordId = component.get('v.recordId');
        helper.getValidators(component,recordId);
    },
    handleSubmit : function (component, event, helper) {
        var resp = component.get('v.resp');
        if(helper.nullCheck(resp.validator)){
            helper.showToast('Error','Please select Validator.');
            return;
        }
         if(helper.nullCheck(resp.validatorComments)){
            helper.showToast('Error','Please input your comments.');
            return;
        }
        else{
            helper.submitToValidator(component,helper,resp);
        }
    },
})