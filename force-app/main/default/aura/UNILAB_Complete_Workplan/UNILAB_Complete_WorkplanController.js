({
	doInit : function(component, event, helper) {
        
        helper.loadECLAccount(component,event);
        
        /*
        var branchId=component.get('v.recordId');

        var action = component.get("c.checkEventToday");
        
        action.setParams({
            branchId: branchId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var dataCount = response.getReturnValue();
                //alert(dataCount);
                if (dataCount === 0 || dataCount === 3){
                    component.set('v.enableForm',false);
                }
                if (dataCount === 1 || dataCount === 2){
                    helper.loadECLAccount(component,event);
                }
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
       */
	},
    
    locationBaseChange : function(component, event, helper) {
      	helper.loadLocation(component);
    },
    
    saveRecord : function(component, event, helper) {
        helper.saveWorkplan(component);
        helper.endCall(component);
        helper.navigateAccount(component);
    },
    
    submitRecord : function(component, event, helper) {
        helper.saveWorkplan(component);
        helper.submitWorkplan(component);
        helper.endCall(component);
        helper.navigateAccount(component,event);
    },
    
    handleEndCall : function(component, event, helper) {
        helper.navigateAccount(component);
    },
})