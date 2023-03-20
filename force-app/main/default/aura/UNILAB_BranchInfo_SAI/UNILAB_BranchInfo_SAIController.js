({
	doInit : function(component, event, helper) {
		component.set('v.columns', [
            {label: 'Measure Type', fieldName: 'measure_type__c', type: 'text'},
            {label: 'Amount', fieldName: 'amt__c', type: 'number', typeAttributes: { maximumFractionDigits: '2' }},
            {label: 'Indices', fieldName: 'indices__c', type: 'percent'}
        ]);
        
        var action = component.get("c.fetchSAI");
        
        action.setParams({
            recordId : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.data", response.getReturnValue());
                //component.set("v.filteredData", response.getReturnValue());
                var data = component.get("v.data"),
                    results = data, regex;
                try {
                    regex = new RegExp("Unilab, Inc. Group", "i");
                    // filter checks each row, constructs new array where function returns true
                    results = data.filter(row=>regex.test(row.bu_company__c));
                } catch(e) {
                    // invalid regex, use full list
                }
                component.set("v.filteredData", results);
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
    filter: function(component, event, helper) {
        
        var data = component.get("v.data"),
            term = event.getParam("value"),//component.get("v.filter"),
            results = data, regex;
        try {
            regex = new RegExp(term, "i");
            // filter checks each row, constructs new array where function returns true
            results = data.filter(row=>regex.test(row.bu_company__c));
        } catch(e) {
            // invalid regex, use full list
        }
        component.set("v.filteredData", results);
    }
})