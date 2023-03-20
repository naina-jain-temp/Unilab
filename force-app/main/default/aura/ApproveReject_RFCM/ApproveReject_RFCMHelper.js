({
    nullCheck : function(data){
        var isNull = false;
        if(data == '' || data == null || data == undefined ){
            isNull = true;
        }
        return isNull;
    },
    
   /* loadData : function(component,recordId) {
        debugger;
        var action = component.get("c.getApprovalJSON");
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
        
    },*/
    handleApproveReject: function(component,helper,recordId,approveReject) {
        debugger;
        var action = component.get("c.submitForNextApprovalOrReject");
        var comments = component.get('v.comments');
        action.setParams({ rfcmId:recordId,approveReject :approveReject, commentsFromApprover : comments   });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var respData = response.getReturnValue();
                console.log('Resp is '+JSON.stringify(respData));
                component.set("v.resp",respData);
                if(respData.errorFlag == false && approveReject == 'Approve'){
                    helper.showToast('Success','Record submitted for Approval.'); 
                    $A.get("e.force:closeQuickAction").fire();
                }
                else if(respData.errorFlag == false && approveReject == 'Reject'){
                    helper.showToast('Success',respData.message); 
                    $A.get("e.force:closeQuickAction").fire();
                }
                    else {
                        helper.showToast('Error',respData.message); 
                    }
                component.set("v.showForm",true);
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
    
    handleValidation :  function(component, event, helper){
        var comments = component.get("v.comments");
        var isError = false;
        if(comments == null || comments == '' || comments == undefined){
            isError = true;
        }
        return isError;
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