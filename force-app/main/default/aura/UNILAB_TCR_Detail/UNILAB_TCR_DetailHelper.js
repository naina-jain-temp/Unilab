({  
    getTCRType : function(component, recordId) {
        
        var action = component.get("c.getTCRType");
        
        action.setParams({
            'tcrID' : recordId
        });
        
        action.setCallback(this, function(response){
            
            if (response.getState() === 'SUCCESS'){
                
                component.set("v.tcrType", response.getReturnValue());
                
                this.getTCRResult(component, recordId, component.get("v.tcrType"));
                
                this.getTotalCallAve(component, recordId, component.get("v.tcrType"));
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    getTCRResult : function(component, recordId, tcrType) {
        
        var action = component.get("c.getTCRResult");
        
        action.setParams({
            'tcrID' : recordId,
            'tcrType' : tcrType
        });
        
        action.setCallback(this, function(response){
            
            if (response.getState() === 'SUCCESS'){
                
                component.set("v.tcrResult", response.getReturnValue());
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    getTotalCallAve : function(component, recordId, tcrType) {
        
        var action = component.get("c.calculateTotalAverage");
        
        action.setParams({
            'tcrID' : recordId,
            'tcrType' : tcrType
        });
        
        action.setCallback(this, function(response){
            
            if (response.getState() === 'SUCCESS'){
                
                component.set("v.totalCallAve", response.getReturnValue());
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    }
    
})