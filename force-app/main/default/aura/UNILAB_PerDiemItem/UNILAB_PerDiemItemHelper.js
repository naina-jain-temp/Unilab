({
	locationValueChange : function(component, event, locBasedValue, locValue) {
        var hbOptions = [
            { value: 'MANILA', selected: false },
            { value: 'PROVINCIAL', selected: false },
            { value: 'CAVITE', selected: false }
        ];
        var ohbOptions = [
            { value: 'ILOCOS/CAR', selected: false },
            { value: 'CENTRAL LUZON', selected: false },
            { value: 'BICOL', selected: false },
            { value: 'CAGAYAN VALLEY', selected: false },
            { value: 'SOUTH TAGALOG', selected: false },
            { value: 'CENTRAL VISAYAS', selected: false },
            { value: 'WEST VISAYAS', selected: false },
            { value: 'EAST VISAYAS', selected: false },
            { value: 'NORTH MINDANAO', selected: false },
            { value: 'SOUTH MINDANAO', selected: false },
            { value: 'WEST MINDANAO', selected: false },
            { value: 'CENTRAL MINDANAO', selected: false }
        ];

        var optionVal = [];
        var moc = component.get("v.mocValue");
        if(moc=='Online') {
            component.set("v.locBasedValue", "Home Base");
            locBasedValue = 'Home Base';
        }
        
        var existLoc = '';
        if(locBasedValue=='Home Base') {
            existLoc = 'MANILA';
            if(locValue != null || locValue != '') {
                hbOptions.map((opt, id) => {
                    if(locValue == opt.value) {
                        optionVal.push({ value: opt.value, selected: true});
                		existLoc = opt.value;
                    } else {
                        optionVal.push({ value: opt.value, selected: false});
                    }
            	});
        
	            component.set("v.locValue", existLoc);
            } else {
                optionVal.push(hbOptions);
        	}
           component.set("v.locValue", existLoc);
        } 
 		if(locBasedValue=='Out of Home Base') {
            existLoc ="ILOCOS/CAR";
    		if(locValue != null || locValue != '') {
                ohbOptions.map((opt, id) => {
                    if(locValue == opt.value) {
                        optionVal.push({ value: opt.value, selected: true});
                		existLoc = opt.value;
                    } else {
                        optionVal.push({ value: opt.value, selected: false});
                    }
                });
			} else {
                optionVal.push(ohbOptions);
            }
		component.set("v.locValue", existLoc);
                
        }
        
        component.set("v.options", optionVal);
	},
    valueChange : function(component, event) {
        var selectedRowData = component.get("v.activity");
        var eventData = component.get("v.eventData");
        var mocValue = component.get("v.mocValue");
        var statusValue = component.get("v.statusValue");
        var locBasedValue = component.get("v.locBasedValue");
        var locValue = component.get("v.locValue");
        var exemptRemarks = component.get("v.exemptValue");
        var options = component.get("v.options");
        var tempEvent = [...eventData];
        
        if(tempEvent.length>0) {
            tempEvent.map((resp, key)=>{ 
                selectedRowData.Id == resp.Id &&
                tempEvent.splice(key, 1, {
                    EndDate: resp.EndDate,
                    Event_Sub_type__c: resp.Event_Sub_type__c,
                    Event_Type__c: resp.Event_Type__c,
                    Id: resp.Id,
                    Location_Based__c: locBasedValue,
                    Location_Custom__c: locValue,
                    Mode_of_Contact__c: mocValue,
                    OwnerId: resp.OwnerId,
                    Related_To_Account__c: resp.Related_To_Account__c,
                    StartDateTime: resp.StartDateTime,
                    Status__c: statusValue,
                	Activity_Junction__c: resp.Activity_Junction__c,
                	Exemption_Remarks__c: exemptRemarks,
                	CreatedById: resp.CreatedById,
                	from_Per_Diem__c: true
                });
            });
        	component.set("v.eventData", tempEvent);
        }
    },
    eventDataHelper : function(component, selectedRow, selectedRowData, eventDataArr, exemptRemarks) {
        if(selectedRow) {
            eventDataArr.push({
                EndDate: selectedRowData.EndDate,
                Event_Sub_type__c: selectedRowData.Event_Sub_type__c,
                Event_Type__c: selectedRowData.Event_Type__c,
                Id: selectedRowData.Id,
                Location_Based__c: selectedRowData.Location_Based__c,
                Location_Custom__c: selectedRowData.Location_Custom__c,
                Mode_of_Contact__c: selectedRowData.Mode_of_Contact__c,
                OwnerId: selectedRowData.OwnerId,
                Related_To_Account__c: selectedRowData.Related_To_Account__c,
                StartDateTime: selectedRowData.StartDateTime,
                Status__c: selectedRowData.Status__c,
                Activity_Junction__c: selectedRowData.Activity_Junction__c,
                Exemption_Remarks__c: exemptRemarks,
                CreatedById: selectedRowData.CreatedById,
                from_Per_Diem__c: true
            });
        } else {
            if(eventDataArr.length > 0) {
                eventDataArr.map((resp, key) => {
                    resp.Id == selectedRowData.Id &&
                    eventDataArr.splice(key,1);
                })
            }
        }
        
        component.set("v.eventData", eventDataArr);
    }
})