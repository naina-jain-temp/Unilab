({
    doInit : function(component, event, helper) {
        var action = component.get("c.getPromoDetails");
        var recordId = component.get("v.recordId");
        
        action.setParams({
            recordId: recordId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                //alert("SUCCESS");
                //var promo = response.getReturnValue();
                //console.log('PROMO ----->'+promo);
                component.set('v.promoRec', response.getReturnValue());
                //alert('CLONING.........' +response.getReturnValue());
            } else if (state === "ERROR") { 
                console.log("ERROR received")
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    console.error(errors[0].message);
                    
                    helper.showToast({'message' : errors[0].message  ,
                                      'type':'ERROR',
                                      'title':''});
                    
                    helper.navigateToRecord(event, recordId); 
                } 
            }
        });
        $A.enqueueAction(action);
    },
    
    clonePromo : function(component, event, helper) {
        var cloneRecordId = component.get("v.recordId");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:UNILAB_CreatePromo",
            componentAttributes: {
                promoTobeCloned : cloneRecordId
            }
        });
        evt.fire();
    },
    
    cancelCloning: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
})