({
    getAllocationRecord : function(component, event, helper) {
        
        $A.util.removeClass(component.find("mySpinner"), "slds-hide");
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        
        component.set('v.accountAllocColumns', [
            {label: 'Account Name', fieldName: 'accountURL', type: 'url',
             typeAttributes: { label: {fieldName: 'accountName'} }},
            {label: 'Final Allocation', fieldName: 'Final_Allocation__c', type: 'number'},
            {label: 'Status', fieldName: 'Status__c', type: 'text'}
        ]);
        
        var action = component.get("c.getAllocation");
        
        action.setParams({
            recID : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var returnValue = response.getReturnValue();
                var acctAllocRecord = [];
                
                console.log('RETURN VALUE: ' + JSON.stringify(response.getReturnValue()));
                
                for (var i = 0; i < returnValue.length; i++) {
                    acctAllocRecord.push({
                        accountURL : '/one/one.app?#/sObject/' + returnValue[i].Account__r.Id + '/view',
                        accountName : returnValue[i].Account__r.Name,
                        Final_Allocation__c : returnValue[i].Final_Allocation__c,
                        Status__c : returnValue[i].Status__c
                    });
                };
                
                component.set("v.accountAllocList", acctAllocRecord);
                
                $A.util.removeClass(component.find("mySpinner"), "slds-show");
                $A.util.addClass(component.find("mySpinner"), "slds-hide");
                
            }
        });
        
        $A.enqueueAction(action);
        
    }
})