({
    doInit: function (component, event, helper) {
        var action = component.get("c.getLocation");	        
        action.setParams({	            
            "acctId":component.get("v.recordId")        
        });
        action.setCallback(this,function(response){	            
            var state = response.getState();	            
            if(state =='SUCCESS'){	                
                var result = response.getReturnValue();
                component.set('v.mapMarkers', result);
                console.log('Result returned: ' + JSON.stringify(result));	         
            }else{	                
                console.log('Something went wrong! ');	            
            }	        
        });	        
        $A.enqueueAction(action);	    
    }
})