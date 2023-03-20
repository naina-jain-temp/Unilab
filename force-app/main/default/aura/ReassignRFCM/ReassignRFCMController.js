({
    doInit: function (component, event, helper) {
        var recordId = component.get('v.recordId');
        helper.getReassignList(component,recordId);
    },
    handleSubmit : function (component, event, helper) {
        var resp = component.get('v.resp');
        if(helper.nullCheck(resp.reassignTo)){
            helper.showToast('Error','Please select a User.');
            return;
        }
        /*if(helper.nullCheck(resp.encoderComments)){
            helper.showToast('Error','Please input your comments.');
            return;
        }
        else{
        */
            helper.reassign(component,helper,resp);
        //}
    },
})