({
	updateRecordStatus : function(component, event, helper) {
		var recordId = component.get("v.recordId");
        var action = component.get("c.updateAccAllocStatusConcurred");
        
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //component.set('v.spinner',false);
                helper.showToast({'message' : 'Allocation has been concurred.',
                                  'type':'SUCCESS',
                                  'title':''});
                helper.navigateToRecord(event, recordId);
                $A.get("e.force:closeQuickAction").fire();
                
            }
        });
        $A.enqueueAction(action);
        //$A.get('e.force:refreshView').fire();
	},
    navigateToRecord : function(event, recordId){
        
        var event = $A.get( 'e.force:navigateToSObject' );
        
        event.setParams({
            'recordId' : recordId,
            'slideDevName' : 'Detail' ,
            'isRedirect' : true
        }).fire();     
    },
    showToast : function(alertMessage) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": alertMessage.title,
            "type": alertMessage.type,
            "message": alertMessage.message
        });
        toastEvent.fire();
    },
})