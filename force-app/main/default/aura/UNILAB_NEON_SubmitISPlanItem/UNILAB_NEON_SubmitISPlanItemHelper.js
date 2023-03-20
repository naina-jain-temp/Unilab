({
	reconstructArray : function(component) {
        var option = component.get("v.option");
        var ctData = component.get("v.ctData");
        var tempData = [...ctData];
        
		if(ctData.length>0) {
            var findData = !tempData.find(data => data.Customer_Team__c === option.Customer_Team__c);
                
            ctData.map((resp, key)=> {
                //console.log(option.Customer_Team__c + 'option');
                //console.log(resp.Customer_Team__c + 'resp');
                 if(resp.Customer_Team__c === option.Customer_Team__c) {
                	console.log(findData);
            		tempData.splice(key, 1);
                    
                } else {
                    if(findData) {
                		tempData.push({
                            'Id': option.Id,
                            'Customer_Team__c': option.Customer_Team__c
                        });
            		}
                }
            });
        } else {
            tempData.push({
                'Id': option.Id,
                'Customer_Team__c': option.Customer_Team__c
            });
        }
        component.set("v.ctData", tempData);
	}
})