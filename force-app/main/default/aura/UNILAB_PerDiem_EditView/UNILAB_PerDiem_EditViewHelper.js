({
	fetchExistData : function(component) {
		var action = component.get("c.fetchExist");
        var recordID = component.get("v.recordId");
        
        action.setParams({
            recordID
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var returnResp = response.getReturnValue();
                if(returnResp.length > 0) {
            		var tempArr = [];
                    returnResp.map((resp, key)=>{
                        if(resp.objEvent.Owner) {
                        	resp.objEvent.OwnerName = resp.objEvent.Owner.Name;
                    	}
			            if(resp.objEvent.Related_To_Account__r) {
                        	resp.objEvent.Related_To_AccountName = resp.objEvent.Related_To_Account__r.Name;
                    	}
            			tempArr.push(resp.objEvent);
                    });
            		component.set("v.existEventData", tempArr);
                }else {
                    console.log("No existing data.");
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
	}
})