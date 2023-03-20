({
    doInit: function (component, event, helper) {
        var recordId = component.get('v.recordId');
        helper.getEncoder(component,recordId);
    },
    handleSubmit : function (component, event, helper) {
        var resp = component.get('v.resp');
         if(helper.nullCheck(resp.projectOwnerComments)){
            helper.showToast('Error','Please input your comments.');
            return;
        }
        else{
            helper.submitToEncoder(component,helper,resp);
        }
    },
})