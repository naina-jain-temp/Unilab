({
	init : function(component, event, helper) {
		var assessmentData = component.get("v.assessmentData");
        component.set("v.assessmentItem", assessmentData);
        
        var category = assessmentData[0].Category__c;
        	
        component.set("v.category", category);
        
	}
})