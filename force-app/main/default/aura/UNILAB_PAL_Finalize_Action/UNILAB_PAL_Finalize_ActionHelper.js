({
    fetchAllocationData : function(component, event, helper){
        console.log('fetchAllocationData');
        //Used for fetching Allocation Data
        //component.set('v.spinner',true);
        var action = component.get("c.getAllocRecs");
        
        action.setParams({
            recordId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
           var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.allocRec', response.getReturnValue());
                var allocRec = component.get('v.allocRec');
                component.set('v.spinner',false);
            } else if (state === "ERROR"){
                
            }
            
        });
        $A.enqueueAction(action);
    },
    
    updateAllocationData : function(component, event, helper){
        component.set('v.spinner',true);
        var action = component.get("c.updateAllocRecStatus");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.log("Updated Status --->",response.getReturnValue());
                var retAlloc = response.getReturnValue();
                component.set('v.spinner',false);
                helper.showToast({'message' : 'Allocation has been finalized.',
                                  'type':'SUCCESS',
                                  'title':''});
                
                helper.navigateToRecord(event, retAlloc.Id);
                //$A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            } else if (state === "ERROR") { 
                console.log("ERROR received")
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    console.error(errors[0].message);
                    
                    helper.showToast({'message' : errors[0].message  ,
                                      'type':'ERROR',
                                      'title':''});
                    
                    helper.navigateToRecord(event, retAlloc.Id); 
                } 
            }
        });
        $A.enqueueAction(action);
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