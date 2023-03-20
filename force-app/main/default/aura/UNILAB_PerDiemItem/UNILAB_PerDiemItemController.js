({
	doInit : function(component, event, helper) {
        var activity = component.get("v.activity");
        var activityList = component.get("v.perDiemData");
        var existData = component.get("v.eventData");
        var moc = activity.Mode_of_Contact__c;
        var status = activity.Status__c;
        var locBased = activity.Location_Based__c;
        var loc = activity.Location_Custom__c;
        var tempArray = [];
        
        /*if(status=="Completed") {
            component.set("v.statusBool", true);
            
            component.set("v.selectedRow", true);
        }*/
        
        if(existData.length > 0) {
            existData.map((resp, key)=> {
                if(resp.Id == activity.Id) {
                	component.set("v.selectedRow", activityList.isChecked);
                    moc = resp.Mode_of_Contact__c;
                    status = resp.Status__c;
                    locBased = resp.Location_Based__c;
                	loc = activity.Location_Custom__c;
                
            		tempArray.push(resp);
                }
                    
            });
        }
        
       
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
        console.log(locBased,component.get("v.locBasedValue"));
        helper.locationValueChange(component, event, component.get("v.locBasedValue"), component.get("v.locValue"));
	},
    selectedRowChange : function(component, event, helper) {
        var selectedRowData = component.get("v.activity");
        var selectedRow = component.get("v.selectedRow");
        var eventData = component.get("v.eventData");
        var exemptRemarks = component.get("v.exemptValue");
        var eventDataArr = [...eventData]
        helper.eventDataHelper(component, selectedRow, selectedRowData, eventDataArr, exemptRemarks);
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
        console.log(component.get("v.eventData"));
    },
    locationChange : function(component, event, helper) {
        var locBasedValue = component.get("v.locBasedValue");
        var locValue = component.get("v.locValue");
        helper.locationValueChange(component, event, locBasedValue, locValue);
        helper.valueChange(component, event);
        console.log(component.get("v.eventData"));
    },
    locValueChange: function(component, event, helper) {
        helper.valueChange(component, event);
        var locBasedValue = component.get("v.locBasedValue");
        var locValue = component.get("v.locValue");
        helper.locationValueChange(component, event, locBasedValue, locValue);
        console.log(component.get("v.eventData"));
    }
})