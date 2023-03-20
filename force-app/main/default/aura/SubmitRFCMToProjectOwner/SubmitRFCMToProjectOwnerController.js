({
    doInit: function (component, event, helper) {
        var recordId = component.get('v.recordId');
        helper.getProjectOwners(component,recordId);
    },
    handleSubmit : function (component, event, helper) {
        var resp = component.get('v.resp');
        if(helper.nullCheck(resp.projectOwner)){
            helper.showToast('Error','Please select Project Owner.');
            return;
        }
         if(helper.nullCheck(resp.encoderComments)){
            helper.showToast('Error','Please input your comments.');
            return;
        }
        else{
            helper.submitToProjectOwner(component,helper,resp);
        }
    },
})