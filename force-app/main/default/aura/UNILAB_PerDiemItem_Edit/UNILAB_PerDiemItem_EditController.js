({
	doInit : function(component, event, helper) {
        var activity = component.get("v.activity");
        var activityList = component.get("v.perDiemData");
        var existData = component.get("v.existEventData");
        var moc = activity.Mode_of_Contact__c;
        var status = activity.Status__c;
        var locBased = activity.Location_Based__c;
        var loc = activity.Location_Custom__c;
        var exempt = activity.Exemption_Remarks__c;
        var tempArray = [];
        console.log(activity);
        if(exempt) {
            component.set("v.forExemption", true);
            component.set("v.exemptValue", exempt);
        }
        /*if(status=="Completed") {
            component.set("v.statusBool", true);
            
            component.set("v.selectedRow", true);
        }*/
        /*if(existData.length > 0) {
            existData.map((resp, key)=> {
                	component.set("v.selectedRow", activityList.isChecked);
                    moc = resp.Mode_of_Contact__c;
                    //status = resp.Status__c;
                    //locBased = resp.Location_Based__c;
                	loc = activity.Location_Custom__c;
                
            		//tempArray.push(resp);
                    
            });
        }*/
		var selectedRow = component.get("v.selectedRow");
        var eventDataArr = [...existData];
        helper.eventDataHelper(component, selectedRow, activity, eventDataArr, '');
                
        if(moc) {
        	component.set("v.mocValue", moc);
        }
        if(status) {
        	component.set("v.statusValue", status);
        }
        if(locBased) {
        	component.set("v.locBasedValue", locBased);
        }
        if(loc) {
        	component.set("v.locValue", loc);
        }
        
        helper.locationValueChange(component, event, component.get("v.locBasedValue"), component.get("v.locValue"));
	},
    selectedRowChange : function(component, event, helper) {
        var selectedRowData = component.get("v.activity");
        var selectedRow = component.get("v.selectedRow");
        var existEventData = component.get("v.existEventData");
        var exemptRemarks = component.get("v.exemptValue");
        var eventDataArr = [...existEventData];
        helper.eventDataHelper(component, selectedRow, selectedRowData, eventDataArr, exemptRemarks);
        console.log(component.get("v.existEventData"));
    },
    valueChange : function(component, event, helper) {
        var mocValue = component.get("v.mocValue");
        var locBasedValue = component.get("v.locBasedValue");
        var locValue = component.get("v.locValue");
        
        if(mocValue == 'Online') {
            var hb = 'Home Base';
            var loc = 'MANILA';
            component.set("v.locBasedValue", hb);
            component.set("v.locValue", loc);
        }
        
        helper.valueChange(component, event);
        var newLocBasedValue = component.get("v.locBasedValue");
        var newLocValue = component.get("v.locValue");
        helper.locationValueChange(component, event, newLocBasedValue, newLocValue);
        console.log(component.get("v.existEventData"));
    },
    locationChange : function(component, event, helper) {
        var locBasedValue = component.get("v.locBasedValue");
        var locValue = component.get("v.locValue");
        helper.locationValueChange(component, event, locBasedValue, locValue);
        helper.valueChange(component, event);
        console.log(component.get("v.existEventData"));
    },
    locValueChange: function(component, event, helper) {
        helper.valueChange(component, event);
        var locBasedValue = component.get("v.locBasedValue");
        var locValue = component.get("v.locValue");
        helper.locationValueChange(component, event, locBasedValue, locValue);
        console.log(component.get("v.existEventData"));
    }
})