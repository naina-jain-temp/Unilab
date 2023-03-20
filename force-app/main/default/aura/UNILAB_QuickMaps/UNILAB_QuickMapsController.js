({
	handleSubmit : function(component, event, helper) {
        helper.getLocation(component,event);
	},
    
    handleUploadFinished: function (component, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);

        // Get the file name
        uploadedFiles.forEach(file => console.log("store_facade_"+file.name));
    },
})