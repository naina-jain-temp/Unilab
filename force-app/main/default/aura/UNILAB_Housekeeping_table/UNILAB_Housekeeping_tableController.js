({
    init : function (component, event, helper) {
        
		var assessment = component.get("v.Assessment");
        var data = component.get("v.Dataa");
        var category = data.Category__c;
        var title = data.Title__c
        var ctgry = helper.categoryMap[category];
        var line = data.line;
        var type = data.Type__c;
        
        
        if (assessment == undefined) {
            assessment = {};
        }
        
        if (assessment[ctgry] == undefined) {
            assessment[ctgry] = {};
        }
        
        if (assessment[ctgry][line] == undefined) {
            assessment[ctgry][line] = {
                "type": type,
                "category": category,
                "title": title,
                "optYes": 0,
                "optNo": 0,
                "optNa": 0,
                "remarks": ""
            };
        }
        
        component.set("v.Assessment", assessment);
        //console.log(JSON.stringify(assessment));
        
    },
	setData : function(component, event, helper) {
      	
        var assessment = component.get("v.Assessment");
        var data = component.get("v.Dataa");
        var category = data.Category__c;
        var line = data.line;
        var ctrgy = helper.categoryMap[category];
        var source = event.getSource();
        var localId = source.getLocalId();
        
        var remarks = component.get("v.remarks");
        var optYes = component.get("v.optYes");
        var optNo = component.get("v.optNo");
        var optNa = component.get("v.optNa");
        
        var cmpCheck = component.find(localId);
        var checked = cmpCheck.get("v.checked");
        
		console.log("Local Id");
        
        if (localId == "cmpYes" ) {
            
            component.set("v.optYes", checked);
            component.set("v.optNo", false);
            component.set("v.optNa", false);
            assessment[ctrgy][line]["optYes"] = 1;
            assessment[ctrgy][line]["optNo"] = 0;
            assessment[ctrgy][line]["optNa"] = 0;
        } 
        else if (localId == "cmpNo") {
            
            
            component.set("v.optYes", false);
            component.set("v.optNa", false);
            component.set("v.optNo", checked);
            assessment[ctrgy][line]["optYes"] = 0;
            assessment[ctrgy][line]["optNo"] = 1;
            assessment[ctrgy][line]["optNa"] = 0;
        } 
        else if (localId == "cmpNa") {
        
            
            component.set("v.optYes", false);
            component.set("v.optNo", false);
            component.set("v.optNa", checked);
            assessment[ctrgy][line]["optYes"] = 0;
            assessment[ctrgy][line]["optNo"] = 0;
            assessment[ctrgy][line]["optNa"] = 1;
        }
        
   		if (checked) {
          
            
        	assessment[ctrgy][line]["optYes"] = 0;
            assessment[ctrgy][line]["optNo"] = 0;
            assessment[ctrgy][line]["optNa"] = 0;

        }
        
        
        component.set("v.Assessment", assessment);
        
        console.log(JSON.stringify(assessment));
},
    setRemarks : function(component, event, helper) {
        var assessment = component.get("v.Assessment");
        var data = component.get("v.Dataa");
        var category = data.Category__c;
        var line = data.line;
        var ctrgy = helper.categoryMap[category];
        var remarks = component.get("v.remarks");
        
        assessment[ctrgy][line]["remarks"] = remarks;
        
        console.log(JSON.stringify(assessment));
        component.set("v.Assessment", assessment);
    },
    
     
    clearChecklist: function(component, event, helper) {
        
    	component.set("v.optYes",false );
        component.set("v.optNo",false);
        component.set("v.optNa", false);
        component.set("v.remarks", "");
        
    },

    
    //for disable check button// 
    disableChecklist: function(component, event, helper) {
        
    	component.set("v.optYes",false );
        component.set("v.optNo",false);
        component.set("v.optNa", false);
        component.set("v.remarks", "");
        
    }

})