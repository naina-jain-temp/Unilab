({
    nullCheck : function(data){
        var isNull = false;
        if(data == '' || data == null || data == undefined ){
            isNull = true;
        }
        return isNull;
    },
    
    loadData : function(component,recordId) {
        debugger;
        var action = component.get("c.initAction");
        action.setParams({ rfcmId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('state:::'+state);
                var resp = response.getReturnValue();
                component.set("v.resp",resp);
                console.log('resp '+JSON.stringify(resp));
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors && errors.length > 0) {
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
    
    submitForApproval : function(component,helper,recordId){
        debugger;
        var action = component.get("c.submitForApproval");
        action.setParams({rfcmId: recordId}); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respData = response.getReturnValue();
                console.log('Resp is '+respData);
                component.set("v.resp",respData);               
                if(respData.errorFlag == false){
                    helper.showToast('Success','Record submitted for Approval.');
                    $A.get("e.force:closeQuickAction").fire();
                }
                else {
                     helper.showToast('Error',respData.message); 
                }
                $A.get('e.force:refreshView').fire(); 
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors && errors.length > 0) {
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
    showToast : function(title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message
        });
        toastEvent.fire();
    }
})