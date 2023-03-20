({
	loadData : function(component, event) {
		var action = component.get("c.fetchData");
        var prodId = component.get("v.recordId");
        
        action.setParams({
            prodId
        });
            
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state == "SUCCESS") {
                var returnResp = response.getReturnValue();
                component.set("v.options",returnResp);
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        this.showToast('Error','Error',errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    this.showToast('Error','Error','Unknown error');
                }
            }
        });
        
        $A.enqueueAction(action);  
	},
    
    ctOptions : function(component) {
        var options = component.get("v.options");
        component.set("v.options", options);
    },
    
    submitISP : function(component, event, helper) {
        var action = component.get("c.updateISP");
        var prodId = component.get("v.recordId");
        var ctData = component.get("v.ctData");
        
        action.setParams({
            ctData,
            prodId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
            	var result = response.getReturnValue();
            	component.set("v.ctData", []);
            	this.showToast('Success','Success','IS Plan Submitted successfully.');
            	this.handleSuccess(component, result);
        	} else if(state === "ERROR") {
            	this.showToast('Error','Error','Unknown error');
        	}
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
    
    handleSuccess: function(cmp, recordID) {
        cmp.find("navService").navigate({
            "type": "standard__recordPage",
            "attributes": {
                "recordId": recordID,
                "objectApiName": "NEON_Product__c",
                "actionName": "view"
            }
        });
	}
})