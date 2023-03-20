({
	submitRecord : function(component, event, helper) {
		event.preventDefault();
        var fields = event.getParam("fields");
        fields["Account__c"] = component.get("v.recordId");
        component.find("myform").submit(fields);
	},
    handleSuccess : function(component, event, helper) {
        //helper.refresh(component,event);
        //alert('success');
    },
})