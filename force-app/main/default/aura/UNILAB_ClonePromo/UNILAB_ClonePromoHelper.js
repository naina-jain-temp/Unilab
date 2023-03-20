({
    
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