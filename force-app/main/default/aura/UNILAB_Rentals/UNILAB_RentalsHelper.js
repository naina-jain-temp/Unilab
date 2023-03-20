({
    checkRentalCount: function(component,event,eventId){
    	var recordId = component.get('v.recordId');
        var action = component.get("c.fetchRentalTodayCount");
        
        action.setParams({
            recordId,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.dataCount", response.getReturnValue());
				var dataCount = response.getReturnValue();
                if (dataCount === 0){
                    this.populateInitialRentals(component,event,eventId);
            		this.populateCriteria(component,event,eventId);
                }
                else{
                	this.populateCriteria(component,event,eventId);
                }
            	this.loadPrevJournal(component);
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
    
    loadECLAccount: function(component,event){
        
        var branchId=component.get('v.recordId');

        var action = component.get("c.fetchUserLoggedAcctEvent");
        
        action.setParams({
            branchId: branchId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var eventId = response.getReturnValue();
                //alert(dataCount);
                if (eventId === 'NONE'){
                    component.set('v.enableForm',false);
                }
                else{
                    component.set('v.enableForm2',true);
                    component.set('v.eventId',eventId);
                    
                    this.checkRentalCount(component,event,eventId);
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
        
        /*
    	var branchId=component.get('v.recordId');

        var action = component.get("c.fetchECL");
        
        action.setParams({
            branchId: branchId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var eclAccount = response.getReturnValue();
               	//alert(eclAccount);
                if (eclAccount === branchId){
                    component.set('v.enableForm2',true);
                    this.checkRentalCount(component,event);
                }
                else{
                    component.set('v.enableForm',false);
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
        
        $A.enqueueAction(action);    */
    },
    
    populateInitialRentals: function(component,event,eventId) {
        var recordID = component.get('v.recordId');
        var action = component.get("c.populateInitialRentals");
        
        action.setParams({
            recordID,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.data", response.getReturnValue());
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
            
    populateCriteria: function(component,event,eventId) {
        var recordID = component.get('v.recordId');
        var action = component.get("c.fetchCriteria");
        
        action.setParams({
            recordID,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.data", response.getReturnValue());
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
    
    populateRentals: function(component) {
        var action = component.get("c.fetchRentalCriteria");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.data", response.getReturnValue());
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
            
   	loadPrevJournal : function(component) {
		var action = component.get('c.fetchPrevJournal');
        var recordId = component.get('v.recordId');
        
        action.setParams({
            recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.prevJournal", response.getReturnValue());
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
            
   	saveJournal : function(component,journal,eventId) {
		
        var action = component.get('c.saveJournal');
        var recordId = component.get('v.recordId');  
        
        action.setParams({
            recordId,
            journal,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
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
            
    update: function(component) {
        var priorityData = component.get("v.priorityData");
        var recordID = component.get('v.recordId');
        
        var action = component.get('c.updateForm');
        
        action.setParams({
            priorityData, 
            recordID
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" || state === "DRAFT") {
                //component.set("v.priorityData", "");
            	 // record is saved successfully
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                    "title": "Saved",
                    "message": "The record was saved."
                });
                resultsToast.fire();
                //component.set("v.disableBtn", true);
                //$A.get('e.force:refreshView').fire();
                //alert('Successfully Saved');   
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
            
    saveFiles : function(component,eventId) {
		
        var action = component.get('c.saveFiles');
        var recordId = component.get('v.recordId');
        
        action.setParams({
            recordId,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
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
            	alert(errors);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    /*
	save: function(component) {
        var priorityData = component.get("v.priorityData");
        var recordID = component.get('v.recordId');
        
        var action = component.get('c.saveForm');
        
        action.setParams({
            priorityData, 
            recordID
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" || state === "DRAFT") {
                //component.set("v.priorityData", "");
            	 // record is saved successfully
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                    "title": "Saved",
                    "message": "The record was saved."
                });
                resultsToast.fire();
                //component.set("v.disableBtn", true);
                //$A.get('e.force:refreshView').fire();
                //alert('Successfully Saved');   
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
    }      */
})