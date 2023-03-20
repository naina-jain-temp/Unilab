({
	init : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Name', fieldName: 'name__c', type: 'text'}
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
        
        helper.loadEvent(component,component);
        
        /* Sub-Activity */
        component.set('v.mycolumns3', [
            {label: 'Name', fieldName: 'Show_Sub_Activity__c', type: 'url',sortable: true,typeAttributes: {label: { fieldName: 'Name'}}},
            {label: 'Learnings and Insights', fieldName: 'Learnings_Insights__c', type: 'text'},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date'}
        ]);
        
        var action = component.get("c.fetchESA");
        
        action.setParams({
            recordID : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.mydata3", response.getReturnValue());
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
    
    saveRecord : function(component, event, helper){
        var buttonName = event.getSource().get("v.name");
        
        var obj = component.get("v.mydata");
        
        var name = [];
        var len = component.find("inputComment").length;
        var comment = [];
        
        for (var i = 0; i < obj.length; i++) {
            if(component.find("inputComment")[i].get("v.value").length != 0)
                {
                    name.push(obj[i].name__c);
                    comment.push(component.find("inputComment")[i].get("v.value"));
                }
        }
        
        component.set('v.mycolumns2', name);
        
        component.set('v.inputProductComment', comment);
        
        //productComment: comment;
        
        
        helper.saveRecord(component, event, helper, buttonName);
    },
})