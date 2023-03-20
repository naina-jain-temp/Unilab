({
	doInit : function(component, event, helper) {
		helper.loadECLAccount(component,event);
        /*
        var branchId=component.get('v.recordId');

        var action = component.get("c.checkEventToday");
        
        action.setParams({
            branchId: branchId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var dataCount = response.getReturnValue();
                //alert(dataCount);
                if (dataCount === 0 || dataCount === 3){
                    component.set('v.enableForm',false);
                }
                if (dataCount === 1 || dataCount === 2){
                    helper.loadECLAccount(component,event);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
            }
        });
        
        $A.enqueueAction(action);   */ 
        
        
	},
    refresh : function (component, event, helper) { 
      // Get the new location token from the event if needed 
      //var loc = event.getParam("token"); 
      $A.get('e.force:refreshView').fire(); 
    },
    handleUploadFinished: function (component, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files"); 
        //alert("Files uploaded : " + uploadedFiles.length);
        component.set("v.fileCount",uploadedFiles.length);

        // Get the file name
        uploadedFiles.forEach(file => console.log("Rentals_"+"_"+file.name));
    },
    saveRecord : function(component, event, helper){
        var eventId = component.get("v.eventId");
        var journal = component.get("v.journal");
        var fileCount =  component.get("v.fileCount");
        
        helper.update(component);
        if(!$A.util.isEmpty(journal)){
            helper.saveJournal(component,journal,eventId);
        }
        
        if (fileCount !== 0){
            helper.saveFiles(component,eventId);
        }
        
        alert('Successfully Saved!');
    }
})