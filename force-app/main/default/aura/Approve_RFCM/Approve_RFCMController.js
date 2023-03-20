({
	doInit: function (component, event, helper) {
        var recordId = component.get('v.recordId');
        helper.loadData(component,recordId);
    },
    handleSubmit : function (component, event, helper) {
        var resp = component.get('v.resp');
        if(helper.nullCheck(resp.projectOwner)){
            return;
        }
        else{
            helper.submitForFirstApproval(component,helper,resp);
        }
    },
})