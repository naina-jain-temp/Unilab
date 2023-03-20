({
	doInit : function(component, event, helper) {
         
         
        
		 
         var recordId = component.get("v.recordId");
        
         var action = component.get("c.massDelete");

          action.setParams({ "recordId" : recordId });

          action.setCallback(this, function(response) {

               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Line Items Deleted",
                    "type": "success"
                });
                toastEvent.fire();
              
                $A.get('e.force:refreshView').fire();
                component.find("navService").navigate({
                    "type": "standard__recordPage",
                    "attributes": {
                        "recordId": recordId,
                        "objectApiName": "RFCM__C",
                        "actionName": "view"
                    }
                });
              
             
                      
          });

          $A.enqueueAction(action);

          
        
	}
})