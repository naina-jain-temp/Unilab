({
    createCSVFromButton: function(component, event, helper) {
        debugger;
        var action = component.get("c.generateCSV");
        var recordId = component.get("v.recordId");
        action.setParams({ rfcmId:recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                helper.showToast('Success','CSV generation initiated.'); 
            }
            else if (state === "INCOMPLETE") {
                helper.showToast('Error','Please contact Admin.'); 
            }
                else if (state === "ERROR") {
                    helper.showToast('Error','Please contact Admin.'); 
                }
        });
        $A.enqueueAction(action);
        
    },
    
    
})