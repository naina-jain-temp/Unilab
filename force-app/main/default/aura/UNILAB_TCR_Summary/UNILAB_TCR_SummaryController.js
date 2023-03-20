({    
    scriptsLoad : function(component, event, helper) {
        
        helper.getUserTheme(component);
        
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        
        var results = [];
        
        var action = component.get("c.createTCRChart");
        
        action.setParams({
            'tcrID' : component.get("v.tcrID"),
            'tcrType': component.get("v.tcrType")
        });
        
        action.setCallback(this, function(response){
            
            if (response.getState() === 'SUCCESS' && response.getReturnValue()) {
                
                results = JSON.parse(response.getReturnValue());
                
                if (component.get("v.tcrType") === 'Account TCR' || component.get("v.tcrType") === 'T3 TCR') {
                    
                    helper.callAverage(component, results);
                    
                    helper.getTCRResult(component);
                    
                    helper.getTotalCallAve(component);
                    
                }
                
                if (component.get("v.tcrType") === 'Meeting TCR' || component.get("v.tcrType") === 'SUBD AUDIT TCR') {
                    
                    helper.getTCRTableResult(component);
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    }
    
})