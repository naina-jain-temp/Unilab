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
            
            		if(returnResp.length < pageSize){
                        component.set("v.isLastPage", true);
                    } else{
                        component.set("v.isLastPage", false);
                    }
                    component.set("v.dataSize", returnResp.length);
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
    onSubmit : function(component) {
        var action = component.get("c.onSubmit");
        var recordID = component.get("v.recordId");
        
        component.set("v.showSpinner", true);
        
        action.setParams({
            eventData : component.get("v.eventData"),
            perdiemData : component.get("v.eventData"),
            recordID
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                
                component.set("v.eventData", "");
	            component.set("v.showSpinner", false);
                $A.get("e.force:navigateToURL").setParams({ 
                    "url": '/lightning/r/Per_Diem__c/'+resp+'/view' 
                }).fire();
                //$A.get('e.force:refreshView').fire();
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
    }
})