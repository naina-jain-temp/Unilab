({
	loadChevron : function(component, event, helper) {		
        var action = component.get('c.getChevronData');
		var txt_recordId = component.get("v.recordId");
		
         action.setParams({
            recId : txt_recordId
        });
        action.setStorable();        
        action.setCallback(this, function(res) { 
            helper.handleCallback(component, event, helper,res); 
        }); 
        $A.enqueueAction(action);  
	},
    handleCallback : function(component, event, helper,res){
        console.log(res.getState());
        if (res.getState() === 'SUCCESS') {
            //alert(res.getReturnValue());
            component.set("v.records",res.getReturnValue());
        }
    }
})