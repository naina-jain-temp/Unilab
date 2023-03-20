({
	cloneAllocationRecord : function(component, event, helper) {
        var action = component.get("c.cloneAllocRecord");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var result = response.getReturnValue();
            
            if (state === "SUCCESS") {
                if(result != undefined){
                    $A.get("e.force:closeQuickAction").fire();
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/"+result
                    });
                    
                    urlEvent.fire();
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "Cloning Success!"
                    });
                    toastEvent.fire();
                }else{
                    $A.get("e.force:refreshView").fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": "Cannot clone Allocation record due to an update error. Please contact your Administrator"
                    });
                    toastEvent.fire();
                }
            } else if (state === "ERROR"){
                
            }
            
        });
        $A.enqueueAction(action);
	}
})