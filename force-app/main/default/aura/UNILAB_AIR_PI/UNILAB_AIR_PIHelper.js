({
	helperMethod : function() {
		
	},
    
    loadEvent : function(component, event){
    
        var action = component.get("c.fetchEA");
        
        action.setParams({
            recordID : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				component.set("v.currentEventId", response.getReturnValue());   
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
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
})