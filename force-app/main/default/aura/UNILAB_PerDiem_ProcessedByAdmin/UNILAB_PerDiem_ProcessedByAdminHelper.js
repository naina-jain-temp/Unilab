({
	getApprovalStatus : function(component) {
		var action = component.get("c.getApprovalStatus");
        
        action.setParams({
            recordID : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {
                var returnResp = response.getReturnValue();
                    if(returnResp.Approval_Status__c == "Approved") {
                        component.set("v.isApproved", true);
                        
                        if(returnResp.Processed_by_Admin__c) {
                            component.set("v.isProcessed", true);
                        } 
                    } else {
                        component.set("v.isApproved", false);
                        component.set("v.isProcessed", false);
                    }
            } else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log("ERROR MESSAGE: " +
                        errors[0].message);
                    }
        		} else {
            		console.log("Unknown Error");
        		}
        	}
        });
        	
    	$A.enqueueAction(action);
	},
    tagAsProcessedByAdmin : function(component, event) {
        var action = component.get("c.updateProcessedByAdmin");
        
        action.setParams({
            recordID : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS") {
                var returnResp = response.getReturnValue();
                var navEvt = $A.get("e.force:navigateToSObject");
                
                navEvt.setParams({
                    "recordId": component.get("v.recordId"),
                    "slideDevName": "detail"
                });
                navEvt.fire();
                $A.get('e.force:refreshView').fire();
                
            } else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log("ERROR MESSAGE: " +
                        errors[0].message);
                    }
        		} else {
            		console.log("Unknown Error");
        		}
        	}
        });
        	
    	$A.enqueueAction(action);
    }
})