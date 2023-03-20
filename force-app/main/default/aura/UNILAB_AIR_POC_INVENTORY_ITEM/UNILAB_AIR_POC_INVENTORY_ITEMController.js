({
	doInit : function(component, event, helper) {
        var product = component.get("v.product");
        var prioData = component.get("v.inventoryData");
    	var prevData = component.get("v.prevData");
        var availBool = component.get("v.availableBool");
        var outOfStockBool = component.get("v.outofstockBool");
        var notCarriedBool = component.get("v.notcarriedBool");
        var inventoryVal = component.get("v.inventoryValue");
        var offtakeVal = component.get("v.offtakeValue");
        var inventory = component.get("v.inventory");
        var periodVal = component.get("v.periodVal");
        var tempData = [...prioData];
        var prevInv = 0;
        var prevOff = 0;
        
        if(prioData.length > 0) {
            prioData.map((resp, key) => {
                if(product.Name == resp.Item_Name__c) {
                    component.set("v.inventoryValue", resp.Current_Inventory__c);
                    component.set("v.offtakeValue", resp.Current_Offtake__c);
            	}
            });
        } else {
            component.set("v.inventoryValue", inventory.Current_Inventory__c);
        	component.set("v.offtakeValue", inventory.Current_Offtake__c);
        }
        
        
        if(inventory.Current_Inventory__c>0 || inventory.Current_Offtake__c>0) {
            helper.reconstructArray(component, inventory.Current_Inventory__c, inventory.Current_Offtake__c);
            component.set("v.lastModifiedName", inventory.LastModifiedBy.Name);
        	component.set("v.lastModifiedDate", inventory.LastModifiedDate);
        }
        if(inventory.Form_Status__c == 'Submit') {
        	component.set("v.submittedBtn", true);
        }
        
        if(prevData.length>0) {
            prevData.map((prev, key)=> {
                if(inventory.Item_Name__c == prev.Item_Name__c) {
                	prevInv = prev.Current_Inventory__c;
                	prevOff = prev.Current_Offtake__c;
            	} 
            });
    		console.log(component.get("v.prevInventoryValue"), component.get("v.prevOfftakeValue"));
        }
        
        component.set("v.prevInventoryValue", prevInv);
        component.set("v.prevOfftakeValue", prevOff);
    },
    inventoryChange : function(component, event, helper) {
        
        var inventoryVal = component.get("v.inventoryValue");
        var offtakeVal = component.get("v.offtakeValue");
        helper.reconstructArray(component, inventoryVal, offtakeVal);
        
        var prioData = component.get("v.inventoryData");
        console.log(prioData);
    },
    offtakeChange : function(component, event, helper) {
        var inventoryVal = component.get("v.inventoryValue");
        var offtakeVal = component.get("v.offtakeValue");
        helper.reconstructArray(component, inventoryVal, offtakeVal);
        
        var prioData = component.get("v.inventoryData");
        //console.log(prioData);
    }
})