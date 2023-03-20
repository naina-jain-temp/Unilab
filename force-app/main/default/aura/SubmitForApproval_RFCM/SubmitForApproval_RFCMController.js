({
	doInit: function (component, event, helper) {
        var recordId = component.get('v.recordId');
        helper.loadData(component,recordId);
    },
    handleSubmit : function (component, event, helper) {
      var recordId = component.get('v.recordId');
      helper.submitForApproval(component,helper,recordId);
    },
    handleReSubmit : function (component, event, helper) {
            var recordId = component.get('v.recordId');
            helper.submitForApproval(component,helper,recordId);
    },
})