({
	doInit : function(component, event, helper) {
       	
        /*
        var data = component.get("v.data");
        var prioData = component.get("v.priorityData");
        var availYes = component.get("v.availYes");
        var availNo = component.get("v.availNo");
        var prioDataBased = [...prioData];
        
        if(prioData.length > 0) {
            prioData.map((resp, key) => {
                let tempName = data.Criteria__c;
                if(tempName == resp.Criteria__c) {
                    resp.Yes__c == component.set("v.availYes", true);
                    resp.No__c == component.set("v.availNo", true);
            	}
           });
        }
        else{
            prioDataBased.push({
                     'Item__c': data.Criteria__c,
                     'Yes__c': availYes,
                     'No__c': availNo
                });
            
            component.set("v.priorityData", prioDataBased);
        }
        
        console.log(data);*/
        	
        
        /*
        var availYes = component.get("v.availYes");
        var availNo = component.get("v.availNo");
        var dataObj = component.get("v.data");
        var prioData = component.get("v.priorityData");    
        
        if(prioData.length > 0) {
            prioData.map((resp, key) => {
                if(dataObj.Criteria__c == resp.Criteria__c) {
                    component.set("v.availYes",resp.Yes__c);
                    component.set("v.availNo",resp.No__c);
            	}
            });
        }
        
        helper.reconstructArray(component);*/
        
    },
    optYesChange : function(component, event, helper) {
        var newCheckBoxValue = component.find("optYes");
        
        //component.set("v.availYes", newCheckBoxValue.get("v.checked"));
        //component.set("v.availNo", false);
        component.set("v.data.Yes__c", newCheckBoxValue.get("v.checked"));
        component.set("v.data.No__c", false);
        
        helper.reconstructArray(component);
    },
    optNoChange : function(component, event, helper) {
        var newCheckBoxValue = component.find("optNo");
        
        //component.set("v.availNo", newCheckBoxValue.get("v.checked"));
        //component.set("v.availYes", false);
        component.set("v.data.No__c", newCheckBoxValue.get("v.checked"));
        component.set("v.data.Yes__c", false);
        
        helper.reconstructArray(component);
    },
})