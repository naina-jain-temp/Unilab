({
	reconstructArray : function(component) {
        
        //var availYes = component.get("v.availYes");
        //var availNo = component.get("v.availNo");
        var dataObj = component.get("v.data");
        var prioObj = component.get("v.priorityData");
        var prioData = [...prioObj];
        
        /*if(prioObj.length>0) {
            prioObj.map((resp, key)=>{
                if(dataObj.Criteria__c === resp.Criteria__c) {
                        prioData.splice(key, 1, {
                        'Item__c': dataObj.Criteria__c,
                        'Yes__c': availYes,
                		'No__c': availNo
                    }); 
                } else {
                    if(!prioData.find(data => data.Criteria__c === dataObj.Criteria__c)){
                        prioData.push({
                            'Item__c': dataObj.Criteria__c,
                            'Yes__c': availYes,
                            'No__c': availNo
                        });
                    }
                }
            });
        } 
 		else {
            prioData.push({
                 'Item__c': dataObj.Criteria__c,
                 'Yes__c': availYes,
                 'No__c': availNo
            });
			
        }*/
        /*
        prioData.push({
                 'Item__c': dataObj.Criteria__c,
                 'Yes__c': availYes,
                 'No__c': availNo
            });
            */
        prioData.push({
            'Id':dataObj.Id,
            'Item__c': dataObj.Item__c,
            'Yes__c': dataObj.Yes__c,
            'No__c': dataObj.No__c
            });
        
        component.set("v.priorityData", prioData);
        
    }
})