({
	doInit : function(component, event, helper) {

        var recordId=component.get('v.recordId');

        var action = component.get("c.fetchAcctSched");
        
        action.setParams({
            recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var dataCount = response.getReturnValue();
            	component.set('v.data',response.getReturnValue());
              
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
	},
})