({
	fetchData : function(component){
        var action = component.get("c.fetch");
        var recordID = component.get('v.recordId');
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var mustBrand = component.get("v.searchKeyword");
        var period = component.get("v.periodVal");
        //var period = periodVal-1;
        
        action.setParams({
            recordID,
           	pageSize,
            pageNumber,
            mustBrand,
            period
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	//component.set("v.inventoryData", []);
            	component.set("v.submittedBtn", false);
            	component.set("v.lastModifiedDate", '');
            	component.set("v.lastModifiedName", '');
                var returnResp = response.getReturnValue();
                if(returnResp.length > 0) {
                    if(returnResp.length < pageSize){
                        component.set("v.isLastPage", true);
                    } else{
                        component.set("v.isLastPage", false);
                    }
                    component.set("v.dataSize", returnResp.length);
                    component.set("v.mydata", returnResp);
                    component.set("v.bNoRecordsFound" , false);
            
                } else {
                    component.set("v.bNoRecordsFound" , true);
                }
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
            }
        });
        $A.enqueueAction(action);
    },
    save: function(component, formStatus) {
        var inventoryData = component.get("v.inventoryData");
        var recordID = component.get("v.recordId");
        var action = component.get('c.saveForm');
        var mustBrand = component.get("v.searchKeyword");
        var period = component.get("v.periodVal");
        action.setParams({
            inventoryData,
            recordID,
            mustBrand,
            period,
            formStatus
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	//component.set("v.inventoryData", []);
                //$A.get('e.force:refreshView').fire();
            	component.set("v.successMessage", true);
            	if(formStatus=="Save as Draft") {
                	component.set("v.successMessage", false);
            		alert('Successfully Saved');
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
    },
    formStatus : function(component) {
    	var action = component.get("c.formStatus");
        var recordID = component.get("v.recordId");
        var mustBrand = component.get("v.searchKeyword");
        var period = component.get("v.periodVal");
        
        action.setParams({
            recordID,
            mustBrand,
            period
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnResp = response.getReturnValue();
                if(returnResp != null) {
            
                    component.set("v.submittedBtn", returnResp);
                    component.set("v.bNoRecordsFound" , false);
                } else {
                    component.set("v.bNoRecordsFound" , true);
                }
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
            }
        });
        $A.enqueueAction(action);
    },
    prevInventory : function(component) {
    	var action = component.get("c.previousInventory");
        var recordID = component.get("v.recordId");
        var mustBrand = component.get("v.searchKeyword");
        var periodVal = component.get("v.periodVal");
        var period = periodVal-1;
        action.setParams({
            recordID,
            mustBrand,
            period
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnResp = response.getReturnValue();
                if(returnResp.length > 0) {
            		console.log("Prev---",returnResp);
                    component.set("v.prevData", returnResp);
                    component.set("v.bNoRecordsFound" , false);
                } else {
                    component.set("v.bNoRecordsFound" , true);
                }
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
            }
        });
        $A.enqueueAction(action);
    }
})