({
	deleteRecord : function(component, event, helper) {
		//var id= event.getSource().get('v.value');
		
        var action = component.get('c.deleteTAFTRecord');        
        var recordId = component.get('v.taftData.Id');
        
        action.setParams({
            recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //alert('Record has been deleted!');
                helper.refresh(component,event);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
                
            }
        });
        
        $A.enqueueAction(action);
		//
	}
})