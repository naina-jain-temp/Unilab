({
	fetchPBStandard : function(component) {
        var action = component.get("c.fetchPrice");
        var pbName = 'Standard Price Book';
        action.setParams({
            recordID : component.get('v.recordId'),
            pricebookName: pbName
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.pricePBStandard', response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);  
    },
    
    fetchPBSRPBox : function(component) {
        var action = component.get("c.fetchPrice");
        var pbName = 'Suggested Retail Price (Box)';
        action.setParams({
            recordID : component.get('v.recordId'),
            pricebookName: pbName
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.pricePBSRPBox', response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);  
    },
    
    fetchPBSRPPcs : function(component) {
        var action = component.get("c.fetchPrice");
        var pbName = 'Suggested Retail Price (Pcs)';
        action.setParams({
            recordID : component.get('v.recordId'),
            pricebookName: pbName
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.pricePBSRPPcs', response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);  
    },
})