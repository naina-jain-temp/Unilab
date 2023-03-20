({
    nullCheck : function(data){
        var isNull = false;
        if(data == '' || data == null || data == undefined ){
            isNull = true;
        }
        return isNull;
    },
    handleCancel: function(component,helper,recordId) {
        debugger;
        var action = component.get("c.cancelRFCM");
        var comments = component.get('v.comments');
        action.setParams({ rfcmId:recordId,comments : comments   });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var respData = response.getReturnValue();
                if(respData != null && respData == true){
                    helper.showToast('Success','RFCM Record canceled successfully.'); 
                }
                else{
                    helper.showToast('Error','Unable to cancel RFCM. Please check with your Admin'); 
                }
                $A.get("e.force:closeQuickAction").fire();
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