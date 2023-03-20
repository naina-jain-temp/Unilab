({
	reconstructArray : function(component, inventoryVal, offtakeVal) {
        //var inventoryVal = component.get("v.inventoryValue");
        //var offtakeVal = component.get("v.offtakeValue");
        var prodObj = component.get("v.product");
        var invObj = component.get("v.inventory");
        var inventoryObj = component.get("v.inventoryData");
        var inventoryData = [...inventoryObj];
        var periodVal = component.get("v.periodVal");
        
        //var tempName = prodObj.Item_Code__c + '-' + prodObj.Name;
        if(inventoryObj.length>0) {
            inventoryObj.map((resp, key)=> {
                if(prodObj.Name === resp.Item_Name__c) {
                        inventoryData.splice(key, 1, {
                		'Product_ID__c': prodObj.Id,
                        'Item_Name__c': prodObj.Name,
                        'Current_Inventory__c': inventoryVal,
                        'Current_Offtake__c': offtakeVal,
                		'Period__c': periodVal
                    });
                } else {
                    if(!inventoryData.find(data => data.Item_Name__c === prodObj.Name)){
                        inventoryData.push({
                			'Product_ID__c': prodObj.Id,
                            'Item_Name__c': prodObj.Name,
                            'Current_Inventory__c': inventoryVal,
                            'Current_Offtake__c': offtakeVal,
                            'Period__c': periodVal
                        });
                    }
                }
            });
        } else {
            inventoryData.push({
                'Product_ID__c': prodObj.Id,
                'Item_Name__c': prodObj.Name,
                'Current_Inventory__c': inventoryVal,
                'Current_Offtake__c': offtakeVal,
 				'Period__c': periodVal
            });
        }
        component.set("v.inventoryData", inventoryData);
    },
    alignPrevInventory : function(component) {
    	var prevData = component.get("v.prevData");
        var inventory = component.get("v.inventory");
        console.log(inventory.Current_Inventory__c);
        
    }
})