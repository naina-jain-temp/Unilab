({
	fetchData : function(component){
        var action = component.get("c.fetch");
        var recordID = component.get('v.recordId');
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var filterValue = component.get("v.searchKeyword");
        
        action.setParams({
            recordID,
           	pageSize,
            pageNumber,
            filterValue
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
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
        var inventoryData = component.get("v.priorityData");
        var recordID = component.get('v.recordId');
        
        var action = component.get('c.saveForm');
        
        action.setParams({
            inventoryData, 
            recordID
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.priorityData", "");
                component.set("v.disableBtn", true);
                $A.get('e.force:refreshView').fire();
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