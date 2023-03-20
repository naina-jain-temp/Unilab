({
	updatePromoStatus : function(component, event) {
        var recordId = component.get( "v.recordId" );
        var reason = component.get("v.reasonCancel");
        
        var action = component.get("c.cancelPromoStatus");
        action.setParams({
            "recordId": recordId,
            "reason": reason
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var result = response.getReturnValue();
            
            //alert(state);
            if (state === "SUCCESS") {
                
                if(result == true){
                    $A.get("e.force:refreshView").fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": "Cannot cancel Promo when Status is Implemented"
                    });
                    toastEvent.fire();
                }else{
                    
                    $A.get("e.force:refreshView").fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "Promo record canceled"
                    });
                    toastEvent.fire();
                }
                
                
            }else{
                alert('STATE = ERROR');
            }
        });
        $A.enqueueAction(action);

	},
})