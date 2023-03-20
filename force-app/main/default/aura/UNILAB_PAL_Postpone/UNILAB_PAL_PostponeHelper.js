({
	fetchAlllocInfo : function (component, event, helper){
        //Used for fetching Logged User
        var action = component.get("c.getAllocInformation");
        var recordId = component.get("v.recordId");
        action.setParams({
            recId : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.allocation", res[0]);
            } else if (state === "ERROR") {   
                alert("ERROR");
                console.log("ERROR");
            }
        });
        $A.enqueueAction(action);
        
    },
    
    updateAllocation : function (component, event, helper){
        //Used for fetching Logged User
        var action = component.get("c.updateAllocInformation");
        var recordId = component.get("v.recordId");
        action.setParams({
            "allocation": component.get("v.allocation"),
            "recId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if(res == 'Success'){
                    $A.get("e.force:closeQuickAction").fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": "The record can't be updated."
                    });
                    toastEvent.fire();
                }
                
            } else if (state === "ERROR") {   
                alert("ERROR");
            }
        });
        $A.enqueueAction(action);
        
    },
})