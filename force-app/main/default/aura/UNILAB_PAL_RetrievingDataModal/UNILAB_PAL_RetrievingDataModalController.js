({
    navigateToRecPage : function(component, event){
        //alert("recordId"+component.get("v.recordId"));
        var recId = component.get("v.recordId");
        var navEvent = $A.get( 'e.force:navigateToSObject' );
        navEvent.setParams({
            'recordId' : recId,
            'slideDevName' : 'Detail' ,
            'isRedirect' : true
        }).fire();     
    },
})