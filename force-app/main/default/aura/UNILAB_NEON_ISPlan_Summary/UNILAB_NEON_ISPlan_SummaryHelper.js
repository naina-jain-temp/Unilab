({
	fetchISSummaryData: function (component,event) {
      	var action = component.get("c.fetchISSummary");
        var recordId = component.get("v.recordId");
        //component.set("v.showSpinner", true);
        action.setParams({
            recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.isSummarydata", response.getReturnValue());
           
                //component.set("v.showSpinner", false);
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
                //component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);    
    },
})