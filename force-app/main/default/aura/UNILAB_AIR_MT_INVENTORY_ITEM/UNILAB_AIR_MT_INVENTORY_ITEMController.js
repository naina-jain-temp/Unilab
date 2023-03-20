({
	doInit : function(component, event, helper) {
        var product = component.get("v.product");
        var prioData = component.get("v.priorityData");
        var availBool = component.get("v.carriedBool");
        var outOfStockBool = component.get("v.oosBool");
        
        if(prioData.length > 0) {
            prioData.map((resp, key) => {
                let tempName = product.Item_Code__c + "-" + product.Name;
                if(tempName == resp.Name) {
                resp.Status__c == "Carried" && component.set("v.carriedBool", true);
                resp.Status__c == "Out of Stock" && component.set("v.oosBool", true);
            }
                         });
        }
        
        console.log(product);
    },
    carriedChange : function(component, event, helper) {
        var newCheckBoxValue = component.find("carriedCheck");
        
        component.set("v.carriedBool", newCheckBoxValue.get("v.checked"));
        component.set("v.oosBool", false);
        helper.reconstructArray(component);
    },
    oosChange : function(component, event, helper) {
        var newCheckBoxValue = component.find("oosCheck");
        
        component.set("v.oosBool", newCheckBoxValue.get("v.checked"));
        component.set("v.carriedBool", false);
        helper.reconstructArray(component);
    }
})