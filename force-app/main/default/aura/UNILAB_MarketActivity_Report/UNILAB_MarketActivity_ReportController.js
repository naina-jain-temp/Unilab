({
    init : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Activity', fieldName: 'activity_name__c', type: 'text'},
            {label: 'Competitor Brand', fieldName: 'competitor_brand__c', type: 'text'},
            {label: 'Affected Brand', fieldName: 'affected_ul_brand__c', type: 'text'},
            {label: 'Price', fieldName: 'price__c', type: 'number'},
            {label: 'Seen', fieldName: 'start_date__c', type: 'date'},
            {label: 'Remarks', fieldName: 'remarks__c', type: 'text'}
        ]);
        
        var action = component.get("c.fetch");
        
        action.setParams({
            recordID : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.mydata", response.getReturnValue());
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
        $A.enqueueAction(action);
    },
})