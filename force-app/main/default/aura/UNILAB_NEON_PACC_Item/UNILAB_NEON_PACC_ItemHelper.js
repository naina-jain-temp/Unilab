({
	reconstructArray : function(component, pipelineDateVal, saturationDateVal) {
        //var pipelineDateVal = component.get("v.pipelineValue");
        //var saturationDateVal = component.get("v.saturationValue");
        var acctObj = component.get("v.acctGroupRef");
        var prodAcctObj = component.get("v.productAcctGroupData");
		var aDataObj = component.get("v.acctGroupPriorityData");
        var aData = [...aDataObj];
        
        if(aDataObj.length>0) {
            aDataObj.map((resp, key)=> {
				if(acctObj.Account_Group__c === resp.Account_Group__c) {
                        aData.splice(key, 1, {
                		'CT_Customer_Team_Name__c': acctObj.CT_Customer_Team_Name__c,
                		'Account_Group__c': acctObj.Account_Group__c,
                        'Pipeline_Date__c': pipelineDateVal,
                        'Saturation_Date__c': saturationDateVal
                    });
                } else {
                    if(!aData.find(data => data.Account_Group__c === acctObj.Account_Group__c)){
                        aData.push({
                            'CT_Customer_Team_Name__c': acctObj.CT_Customer_Team_Name__c,
                			'Account_Group__c': acctObj.Account_Group__c,
                            'Pipeline_Date__c': pipelineDateVal,
                            'Saturation_Date__c': saturationDateVal
                        });
                    }
                }
            });
        }
        else{
            aData.push({
 				'CT_Customer_Team_Name__c': acctObj.CT_Customer_Team_Name__c,
                'Account_Group__c': acctObj.Account_Group__c,
                            'Pipeline_Date__c': pipelineDateVal,
                            'Saturation_Date__c': saturationDateVal
            });
        }
        component.set("v.acctGroupPriorityData", aData);
        
	}
})