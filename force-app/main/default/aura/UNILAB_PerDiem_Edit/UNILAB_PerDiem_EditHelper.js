({
    fetchData : function(component) {
        var action = component.get("c.fetch");
        var startDate = component.get("v.startDate");
        var endDate = component.get("v.endDate");
        var recordID = component.get("v.recordId");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        
        component.set("v.showSpinner", true);
        action.setParams({
            recordID,
            startDate,
            endDate,
            pageSize,
            pageNumber
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var returnResp = response.getReturnValue();
                if(returnResp.length > 0) {
                    /*returnResp.map((resp, key) => {
                        if(resp.objEvent.OwnerId){
                        	resp.objEvent.OwnerIdURL = '/' + resp.objEvent.OwnerId;
                        }
                        if(resp.objEvent.Related_To_Account__c){
                        	resp.objEvent.Related_To_AccountURL__c = '/' + resp.objEvent.Related_To_Account__c;
                    	}
                    })*/
            
                    component.set("v.activityJuncData", returnResp);
                    component.set("v.bNoRecordsFound" , false);
                    component.set("v.showSpinner", false);
                }else {
                    component.set("v.bNoRecordsFound" , true);
                    component.set("v.showSpinner", false);
                }
            } else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log("ERROR MESSAGE: " +
                                   errors[0].message);
                    }
                } else {
                    console.log("Unknown Error");
                }
            	component.set("v.showSpinner", false);
            }
        });
        
        $A.enqueueAction(action);  
    },
	fetchExistData : function(component) {
		var action = component.get("c.fetchExist");
        var recordID = component.get("v.recordId");
        
        action.setParams({
            recordID
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var returnResp = response.getReturnValue();
                if(returnResp.length > 0) {
            		/*var respArr = [];
                    returnResp.map((resp, key) => {
                        if(resp.objEvent.OwnerId){
                        	resp.objEvent.OwnerIdURL = '/' + resp.objEvent.OwnerId;
                        }
                        if(resp.objEvent.Related_To_Account__c){
                        	resp.objEvent.Related_To_AccountURL__c = '/' + resp.objEvent.Related_To_Account__c;
                    	}
            			respArr.push(resp.objEvent);
                    })*/
            
                    component.set("v.existPerDiemData", returnResp);
                    component.set("v.exNoRecordsFound" , false);
                }else {
                    console.log("No existing data.");
                    component.set("v.exNoRecordsFound", true);
                }
            } else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log("ERROR MESSAGE: " +
                                   errors[0].message);
                    }
                } else {
                    console.log("Unknown Error");
                }
            }
        });
        
        $A.enqueueAction(action);
	},
    onUpdate : function(component) {
        
        var action = component.get("c.onUpdate");
        
        component.set("v.showSpinner", true);
        
        action.setParams({
            eventData : component.get("v.eventData"),
            perdiemData : component.get("v.eventData"),
            existEventData : component.get("v.existEventData"),
            existPerdiemData : component.get("v.existEventData"),
            removeEventData : component.get("v.removeEventData"),
            recordID : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var navEvt = $A.get("e.force:navigateToSObject");

            if(state === "SUCCESS") {
                component.set("v.eventData", "");
        		component.set("v.showSpinner", false);
                navEvt.setParams({
                    "recordId": component.get("v.recordId"),
                    "slideDevName": "detail"
                });
                navEvt.fire();
                $A.get('e.force:refreshView').fire();  
            } else if (state === "ERROR") {
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
                
        		component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
        
    },
    selectAll : function(component, event) {
        var selectAllCheck = component.get("v.selectAll");
    	var activityJuncData = component.get("v.activityJuncData");
        var updatedActivity = [];
        
        activityJuncData.map((resp, index)=>{
            if(selectAllCheck) {
                updatedActivity.push({
                    isChecked: true,
                    objEvent: resp.objEvent
                });
        	} else {
                updatedActivity.push({
                    isChecked: false,
                    objEvent: resp.objEvent
                });             
            }
        });
        component.set("v.activityJuncData", updatedActivity);
    },
    selectAllExist : function(component, event) {
        var selectAllCheck = component.get("v.selectAllExist");
    	var perDiemData = component.get("v.existPerDiemData");
        var updatedActivity = [];
        
        perDiemData.map((resp, index)=>{
            if(selectAllCheck) {
                updatedActivity.push({
                    isChecked: true,
                    objEvent: resp.objEvent
                });
        	} else {
                updatedActivity.push({
                    isChecked: false,
                    objEvent: resp.objEvent
                });             
            }
        });
        component.set("v.existPerDiemData", updatedActivity);
    },
    checkIsEditable : function(component) {
        var action = component.get("c.getApprovalStatus");
        var recordID = component.get("v.recordId");
        
        action.setParams({
            recordID
        });
            
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
            	var returnResp = response.getReturnValue();
                if(returnResp.Approval_Status__c == 'Draft' || returnResp.Approval_Status__c == 'Rejected') {
                	component.set("v.isEdit", true);
                } else {
                 	component.set("v.isEdit", false);   
                }
        	} else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log("ERROR MESSAGE: " +
                        errors[0].message);
                    }
        		} else {
            		console.log("Unknown Error");
        		}
        	}
        });
            
    	$A.enqueueAction(action);  
	}
})