({
	doInit : function(component, event, helper) {
        //$A.get('e.force:refreshView').fire();
        
        var acctGroupRef = component.get("v.acctGroupRef");
        var aInitData = component.get("v.aInitData");
        //var totalAcctGroupRef = component.get("v.totalAcctGroupRef");
		var pacData = component.get("v.productAcctGroupData");
		var prioData = component.get("v.acctGroupPriorityData");
        var aData = [...prioData];
        var acctObj = component.get("v.acctGroupRef");
        
        var pVal = component.get("v.selAcctPipelineDate");
        var sVal = component.get("v.selAcctSaturationDate");
        
        if(prioData.length > 0) {
            prioData.map((resp, key) => {
                if(acctGroupRef.Account_Group__c == resp.Account_Group__c) {
                    component.set("v.pipelineValue",resp.Pipeline_Date__c);
                    component.set("v.saturationValue",resp.Saturation_Date__c);
            	}                
            });
            console.log(pacData.Pipeline_Date__c, pacData.Saturation_Date__c);
            if(pacData.Pipeline_Date__c!=null || pacData.Saturation_Date__c!=null) {
                helper.reconstructArray(component, pacData.Pipeline_Date__c, pacData.Saturation_Date__c);
                component.set("v.pipelineValue",pacData.Pipeline_Date__c);
                component.set("v.saturationValue",pacData.Saturation_Date__c);
            } else {
                helper.reconstructArray(component, pVal, sVal);
                component.set("v.pipelineValue",pVal);
                component.set("v.saturationValue",sVal);
            } 
        }
        else{
            
            if(pacData.Pipeline_Date__c!=null || pacData.Saturation_Date__c!=null) {
                helper.reconstructArray(component, pacData.Pipeline_Date__c, pacData.Saturation_Date__c);
                component.set("v.pipelineValue",pacData.Pipeline_Date__c);
                component.set("v.saturationValue",pacData.Saturation_Date__c);
            } else {
                helper.reconstructArray(component, pVal, sVal);
                component.set("v.pipelineValue",pVal);
                component.set("v.saturationValue",sVal);
            }             
        }
         
	},
    
    pipelineDateChange : function(component, event, helper) {
        var pVal = component.get("v.pipelineValue");
        var sVal = component.get("v.saturationValue");
        //var incl = component.get("v.inclOpt");
        
        //if(incl === "true"){
            helper.reconstructArray(component, pVal, sVal);
            
            var prioData = component.get("v.acctGroupPriorityData");
            console.log(prioData);
        //}
    },
    
    saturationDateChange : function(component, event, helper) {
        var pVal = component.get("v.pipelineValue");
        var sVal = component.get("v.saturationValue");
        
        helper.reconstructArray(component, pVal, sVal);
        
        var prioData = component.get("v.acctGroupPriorityData");
        console.log(prioData);
    },
    
    inclBoxChange : function(component, event, helper) {
        var incl = component.get("v.inclOpt");
        var pVal = component.get("v.pipelineValue");
        var sVal = component.get("v.saturationValue");
        
        if(incl ===false){
            helper.reconstructArray(component, "", "");
            component.set("v.pipelineValue","");
            component.set("v.saturationValue","");
        }
        else{
            helper.reconstructArray(component, pVal, sVal);
            component.set("v.pipelineValue",pVal);
            component.set("v.saturationValue",sVal);
        }
    },
})