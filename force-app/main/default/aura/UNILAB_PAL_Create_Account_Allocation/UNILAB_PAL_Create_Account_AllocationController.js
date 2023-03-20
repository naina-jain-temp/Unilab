({
	goToRecordPage : function(component, event, helper){
        var navEvent = $A.get("e.force:navigateToList");
        navEvent.setParams({
            //"listViewId": listviews.Id,
            "listViewName": null,
            "scope": "Allocation__c"
        });
        navEvent.fire();
    }
})