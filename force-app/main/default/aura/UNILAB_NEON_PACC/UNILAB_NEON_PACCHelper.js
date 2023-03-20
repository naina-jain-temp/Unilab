({
	/*loadAcctGroupData: function(component, event){
      	var ct = 'Customer Team 5';
        var action = component.get("c.fetchProductAcct");
        
        action.setParams({
            ct
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.acctGroupData", response.getReturnValue());
            	
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
    },*/
            
    loadAcctGrpData: function(component, event){
      	var ct = component.get('v.selectedTeams');
        var recordId = component.get('v.recordId');
        var action = component.get("c.fetch");
        
        action.setParams({
            ct,
            recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                //console.log(response.getReturnValue());
                component.set("v.acctGroupData", response.getReturnValue());
            	
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
    },
            
   	save: function(component) {
        var acctGroupPriorityData = component.get("v.acctGroupPriorityData");
        var recordId = component.get("v.recordId");
        var action = component.get('c.saveForm');

        action.setParams({
            acctGroupPriorityData,
            recordId
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	component.set("v.acctGroupPriorityData", []);
            	component.set("v.selectedTeams", []);
            	//component.set("v.selectedTeams", "");
                component.set("v.selPipelineDate", "");
                component.set("v.selSaturationDate", "");
            	console.log(component.get("v.selectedTeams"));
            
            	component.clearReference('v.selectedTeams');
                $A.get('e.force:refreshView').fire();
                //alert('Successfully Saved');   
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Account record has been saved successfully."
                });
                toastEvent.fire();
        
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
    },
            
   navigate: function(component){
        var abId='NEON_Product__c';
        //alert(this.tabName);
       	
       	var recordId = component.get("v.recordId");
        component.find("navigation")
        .navigate({
            "type" : "standard__recordPage",
            "attributes": {
                "objectApiName" : abId,
                "recordId"	   	: recordId,
                "actionName"	: 'view'
            }
        }, true);
    },
})