({
    getUserRecord : function(component, helper) {
        
        var action = component.get('c.getUserRecord');
        
        action.setCallback(this, function(response) {
            component.set('v.userRecord', response.getReturnValue());
        });
        
        $A.enqueueAction(action);
        
    }
})