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
                var resp = response.getReturnValue();
                console.log('Resp is '+JSON.stringify(resp));
                component.set("v.resp",resp);
                component.set("v.showForm",true);
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
    
    submitForFirstApproval : function(component,helper,resp){
        debugger;
        var action = component.get("c.submitForFirstApproval");
        action.setParams({responseData: resp});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respData = response.getReturnValue();
                console.log('Resp is '+respData);
                component.set("v.resp",respData);
                helper.showToast('Success','Record submitted for Approval.'); 
                $A.get("e.force:closeQuickAction").fire();
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