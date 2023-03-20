({
	reconstructArray : function(component) {
        var carriedBool = component.get("v.carriedBool");
        var oosBool = component.get("v.oosBool");
        var prodObj = component.get("v.product");
        var prioObj = component.get("v.priorityData");
        var prioData = [...prioObj];
        var statusPrio = '';
        
        if(carriedBool) {
            statusPrio = 'Carried'
        } else if(oosBool) {
            statusPrio = 'Out of Stock';
        }
                
        if(prioObj.length>0) {
            prioObj.map((resp, key)=>{
                if(prodObj.Item_Code__c === resp.Item_Code__c) {
                        prioData.splice(key, 1, {
                        'Item_Code__c': prodObj.Item_Code__c,
                        'Status__c': statusPrio
                    }); 
                } else {
                    if(!prioData.find(data => data.Item_Code__c === prodObj.Item_Code__c)){
                        prioData.push({
                            'Item_Code__c': prodObj.Item_Code__c,
                            'Status__c': statusPrio
                        });
                    }
                }
            });
        } else {
            prioData.push({
                'Item_Code__c': prodObj.Item_Code__c,
                'Status__c': statusPrio
            });
        }
        
        component.set("v.priorityData", prioData);
        component.set("v.disableBtn", false);
    }
})