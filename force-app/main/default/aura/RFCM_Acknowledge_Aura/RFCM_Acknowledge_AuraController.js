({
	closeWidow : function(component, event, helper) {
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "RFCM__c"
        });
        homeEvent.fire();*/
		$A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
	}
})