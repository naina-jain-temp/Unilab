({
	getLastMonthSelected : function (component, value, apex, field) {
         var action = component.get(apex);
         value = value.split(",");
         var selectedValue = [];
        
            for (var i=0; i<value.length; i++) {
                selectedValue.push(value[i].trim());
            }
        
        	action.setParams({
            	names: selectedValue
        	});
        	console.log("Selected Value("+field+") : " + JSON.stringify(selectedValue));
        	action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                										
                var result = response.getReturnValue();
                var newResult = {};
                //console.log(JSON.stringify(result));
                for (var i=0; i<result.length; i++) {
                	var val = result[i];
                    
                    if (val.Position__c != undefined ) {
                    	if (newResult[val.Position__c] == undefined){
                    		newResult[val.Position__c] = [];
                    	}
                    
                    	newResult[val.Position__c].push(val);    
                    } else {
                        if (newResult[val.Plate_No__c] == undefined){
                    		newResult[val.Plate_No__c] = [];
                    	}
                    
                    	newResult[val.Plate_No__c].push(val);
                    }
                    
                   	
                }
                //console.log(JSON.stringify(newResult));
                component.set(field, newResult);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
        
    }
})