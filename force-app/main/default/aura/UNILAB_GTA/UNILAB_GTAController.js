({
	init : function(component, event, helper) {
        /* Get Related Account */
       
        var action = component.get("c.fetch");
        
        action.setParams({
            recordID : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.relatedToAccountId", response.getReturnValue());
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
        
        /* Update GTA */
        
		var action = component.get("c.fetchAndSave");
        
        action.setParams({
            recordID : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //window.parent.location.href ="{!URLFOR($Action.Account.View,"  + component.get('v.relatedToAccountId') +  ") }";
                //sforce.one.navigateToSObject(component.get('v.relatedToAccountId'),"Account");
                //window.location.href = 'https://unilab.lightning.force.com/lightning/r/Account/' + component.get('v.relatedToAccountId') + '/view';
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  "url": 'https://unilab.lightning.force.com/lightning/r/Account/' + component.get('v.relatedToAccountId') + '/view'
                });
                urlEvent.fire();
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
		
        /*
        navigator.geolocation.getCurrentPosition(function(position) {
            var lat = position.coords.latitude;
            var lon = position.coords.longitude;
            var action = component.get("c.getCityName");
            action.setParams({
                recordID : component.get('v.recordId'),
                latitude: lat,
                longitude: lon
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var location = response.getReturnValue();
                }
            });
            $A.enqueueAction(action);
        });*/
	}
})