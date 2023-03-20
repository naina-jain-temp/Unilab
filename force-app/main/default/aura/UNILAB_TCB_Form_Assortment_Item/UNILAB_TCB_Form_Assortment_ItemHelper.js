({
	reconstructArray : function(component) {
        
        var availYes = component.get("v.availYes");
        var availNo = component.get("v.availNo");
        var dataObj = component.get("v.aData");
        var prioObj = component.get("v.aPriorityData");
        var prioData = [...prioObj];
        
        
        prioData.push({
            	'Id':dataObj.Id,
                 'Item__c': dataObj.Item__c,
            	 'Item_Target__c': dataObj.Item_Target__c,
                 'Yes__c': dataObj.Yes__c,
                 'No__c': dataObj.No__c
            });
        
        component.set("v.aPriorityData", prioData);
    },
})