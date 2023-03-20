({
	helperMethod : function() {
		
	},
    
    loadEvent : function(component, event){
    
        var action = component.get("c.fetchEA");
        
        action.setParams({
            recordID : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				component.set("v.currentEventId", response.getReturnValue());   
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
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    saveRecord : function(component, event, helper, buttonName) {
        
    	var recordParameters = {
            
            recordID : component.get('v.recordId'),
            mydata : component.get("v.mycolumns2"),
            productComment: component.get('v.inputProductComment'),
            journalBox : component.get('v.journal')
            
        };
        
        var action = component.get('c.submitRecord');
        
        action.setParams({
            
            recordParameters : JSON.stringify(recordParameters)
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //component.set("v.journal", "");
                //component.set("v.defaultRows", "");
                $A.get('e.force:refreshView').fire();
                //location.reload();
                alert('Successfully Saved');   
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
    }
})