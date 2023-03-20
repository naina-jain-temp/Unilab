({
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
                    this.loadPickList(component,'Event','Mode_of_Contact__c','modeOfContactList');
                    this.loadPickList(component,'Event','Location_Based__c','locationBaseList');
                    
                    //this.loadEventDetail(component,'fetchEventId','eventId');        
                    this.loadEventDetail(component,'fetchEventMOC','modeOfContactSelValue',eventId);
                    this.loadEventDetail(component,'fetchEventLocBase','locationBaseSelValue',eventId);
                    this.loadEventLocation(component,eventId);
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
        
    	/*var branchId=component.get('v.recordId');

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
                    this.loadPickList(component,'Event','Mode_of_Contact__c','modeOfContactList');
                    this.loadPickList(component,'Event','Location_Based__c','locationBaseList');
                    
                    this.loadEventDetail(component,'fetchEventId','eventId');        
                    this.loadEventDetail(component,'fetchEventMOC','modeOfContactSelValue');
                    this.loadEventDetail(component,'fetchEventLocBase','locationBaseSelValue');
                    this.loadEventLocation(component);
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
    
	loadPickList: function(component,object,field,aList){

        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': object,
            'field_apiname': field,
            'nullRequired': false
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var result = response.getReturnValue();
               	component.set('v.'+aList,result);
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
    
    loadEventDetail: function(component,cAction,aVar,eventId){
		
        var branchId = component.get('v.recordId');
        var action = component.get('c.' + cAction);
        action.setParams({
            branchId,
            eventId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var result = response.getReturnValue();
               	component.set('v.'+aVar,result);
            	//alert(aVar + '--' + result);
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
            
    loadEventLocation: function(component,eventId){
		
        var branchId = component.get('v.recordId');
        var action = component.get('c.fetchEventLoc');
        action.setParams({
            branchId,
            eventId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var result = response.getReturnValue();
            	this.loadLocation(component);
               	component.set('v.locationSelValue',result);
            	//alert(result);
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
    
    loadLocation: function(component){
    	var hbOptions = ["MANILA",
            "PROVINCIAL",
            "CAVITE"
        ];
        var ohbOptions = ["ILOCOS/CAR",
            "CENTRAL LUZON",
            "BICOL",
            "CAGAYAN VALLEY",
            "SOUTH TAGALOG",
            "CENTRAL VISAYAS",
            "WEST VISAYAS",
            "EAST VISAYAS",
            "NORTH MINDANAO",
            "SOUTH MINDANAO",
            "WEST MINDANAO",
            "CENTRAL MINDANAO"
        ]; 
        
        var selLocBase = component.get("v.locationBaseSelValue");
        
        if(selLocBase==='Home Base'){
            component.set('v.locationList',hbOptions);
        }
        else{
            component.set('v.locationList',ohbOptions);
        }
        
        //this.loadEventDetail(component,'fetchEventLoc','locationSelValue');
    },
            
    saveWorkplan: function(component){
        var branchId = component.get('v.recordId');
        var eventId = component.get('v.eventId');
        var modeOfContact = component.get('v.modeOfContactSelValue');
        var locationBase = component.get('v.locationBaseSelValue');
        var location = component.get('v.locationSelValue');
        var description = component.get("v.descValue");
        var action = component.get('c.saveWorkplan');
        
        //alert(modeOfContact);
        
        //alert(eventId + '|' + modeOfContact + '|' + locationBase + '|' + location + '|' + description);
        
        action.setParams({
            branchId,
            eventId,
            modeOfContact,
            locationBase,
            location,
            description
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var result = response.getReturnValue();
            	//alert('Successfully Saved!');
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
            	//alert(errors);
            }
        });
        
        $A.enqueueAction(action);    
    },
    
   	submitWorkplan: function(component){
        var branchId = component.get('v.recordId');
        var eventId = component.get('v.eventId');
        var action = component.get('c.submitWorkplan');
        
        //alert(eventId + '|' + modeOfContact + '|' + locationBase + '|' + location + '|' + description);
        
        action.setParams({
            branchId,
            eventId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var result = response.getReturnValue();
            	//alert('Workplan has been completed!');
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
            	//alert(errors);
            }
        });
        
        $A.enqueueAction(action);    
    },
            
    endCall: function(component){
        var branchId = component.get('v.recordId');
        var eventId = component.get('v.eventId');
        var action = component.get('c.endCall');

        action.setParams({
            branchId,
            eventId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				//var result = response.getReturnValue();
				this.navigateAccount(component);
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
            	//alert(errors);
            }
        });
        
        $A.enqueueAction(action);
    },
            
    navigateAccount: function(component){
        var abId='Branch_Login';
        component.find("navigation")
        .navigate({
            "type" : "standard__navItemPage",
            "attributes": {
                "apiName"      : abId
            }
        }, true);
    },
})