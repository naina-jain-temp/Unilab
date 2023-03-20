({
    init : function(component, event, helper) {
        component.set('v.mycolumns', [
            //{label: 'Credit Remarks', fieldName: 'remarks__c', type: 'string'},
            {label: 'Credit Remarks', fieldName: 'show_report__c', type: 'url',sortable: true,typeAttributes: {label: { fieldName: 'remarks__c'}}},
            
            {label: 'ULI', fieldName: 'uli__c', type: 'number'},
            {label: 'UI', fieldName: 'ui__c', type: 'number'},
            {label: 'RT', fieldName: 'rt__c', type: 'number'},
            {label: 'PHX', fieldName: 'phx__c', type: 'number'},
            {label: 'ULSSI', fieldName: 'ulssi__c', type: 'number'}
            
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
        //helper.checkEvent(component,component);
        
        /* Sub-Activity */
        component.set('v.mycolumns2', [
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
                component.set("v.mydata2", response.getReturnValue());
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
        
        /* CLI As of Date */
        /*component.set('v.mycolumns3', [
            {label: 'CREDIT REPORT AS OF', fieldName: 'created_at__c', type: 'date', hideDefaultActions: true}
            
        ]);*/
        
        var action = component.get("c.fetchCLIDate");
        
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
    
    getSubActivity : function(component){
        component.set('v.mycolumns2', [
            {label: 'Id', fieldName: 'Id', type: 'url'},
            {label: 'Id', fieldName: 'Id', type: 'url',sortable: true,typeAttributes: {label: { fieldName: 'Name'}}},

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
                component.set("v.mydata2", response.getReturnValue());
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
    
    handleRowAction : function(component, event, helper){
        var selRows = event.getParam('selectedRows');
        component.set("v.keyField",selRows);
    },
    
    SaveRecord : function(component, event, helper){
        
        //var recordParameters = {
            
        //    keyFieldList : component.get('v.keyField')
            
        //};
        
        var keyFieldList = component.get("v.keyField");
        var action = component.get('c.saveForm');
        var recId = component.get('v.recordId');
        var jbox = component.get('v.journal');
        action.setParams({lstKF : keyFieldList, recordID : recId, journalBox : jbox});
        
        //action.setParams({
            
        //    recordParameters : JSON.stringify(recordParameters)
            
        //});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.journal", "");
                component.set("v.defaultRows", "");
                $A.get('e.force:refreshView').fire();
                //location.reload();
                alert('Successfully Saved');   
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