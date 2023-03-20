({
    init: function(component, event, helper) {
        
      var contactdata = component.get("v.mpContactData");
      var truckdata = component.get("v.mpTruckData");
      var isTruck = component.get("v.isTruck");
      var position = component.get("v.position");
      var summary = component.get("v.mpDataResult");
      var category = component.get("v.category"); 
      var type = component.get("v.type");
      var recordId = component.get("v.accountId");
        
      var newContactData = [];
     
        //console.log(contactdata.length);
        if (summary == undefined) {
            summary = {};
        }
        
        if (summary[position] == undefined)   {
            summary[position] = {
                "rating": 0,
                "actual": 0,
                "deficit" : 0,
                "required": component.get("v.requiredsize"),
                "remarks" : " ",
                "position": position,
                "type": type,
                "category": category,
                "object": ""
            };
        }
        
        if (!isTruck) {
        	for (var i =0; i<contactdata.length; i++) {
           
                var val = contactdata[i];
                var pos = val.position;
                //console.log("POS: " + pos);
                
                if (pos == position) {
                    newContactData.push({
                        "label": val.label,
                        "value": val.value
                    })
                }
        	}    
        } 
        
        
        //console.log(JSON.stringify(newContactData));
        //console.log(JSON.stringify(summary));
		console.log("record ID" + recordId);
        component.set("v.mpfilteredContactData", newContactData);
        component.set("v.mpDataResult", summary);
     
    },
    setLastMonthRecord: function(component, event, helper) {
        
        var summaryIncluded = component.get("v.summaryIncluded");
        var lmdata = component.get("v.lmData");
        var position = component.get("v.position");
		var category = component.get("v.category");  
        var summary = component.get("v.mpDataResult");
        
        var actualSize = 0;
        var requiredSize = component.get("v.requiredsize");;
        var deficitSize = 0;
        var rating = 0;
        var remarks = "";
        
        if (lmdata != undefined) {
            if(lmdata[position] != undefined) {
                
           	 	helper.getLastMonthSelected(component, lmdata[position].object, "c.getContacts", "v.personnel");
                var lineVal = lmdata[position];
                var actualSize = lineVal.actual_size;
                var remarks = lineVal.remarks;
        	}
            if(category == "Truck Requirement" && lmdata[position] != undefined) {
            helper.getLastMonthSelected(component, lmdata[position].object, "c.getTrucks", "v.trucks");
            
            	var lineVal = lmdata[position];
                var actualSize = lineVal.actual_size;
                var remarks = lineVal.remarks;
                
                
        	}
        }
        
        
        
        deficitSize = parseInt(actualSize) - parseInt(requiredSize)
        deficitSize = (deficitSize >= 0 ) ? 0 : deficitSize;
        rating = (deficitSize == 0) ? 1 : 0;
        
        if (lmdata != undefined) {
            if(lmdata[position] != undefined) {
             		
                if (summaryIncluded) {
                	summary[position]["rating"] = rating;
                    summary[position]["actual"] = actualSize;
                    summary[position]["deficit"] = deficitSize;
                    summary[position]["required"] = requiredSize;
                    summary[position]["remarks"] = remarks;    
                }
                
                
                
        		//console.log(JSON.stringify(summary));
                
                component.set("v.requiredsize", requiredSize);
                component.set("v.actualsize", actualSize);
                component.set("v.deficitsize", deficitSize);
                component.set("v.rating", rating);
                component.set("v.remarks", remarks);
                component.set("v.mpDataResult", summary);
            }
        }

    },
    updateContactData: function(component, evt, helper) {
        var newContactData = component.get("v.newContactData");
        //console.log(JSON.stringify(newContactData));
        component.set("v.mpfilteredContactData", newContactData);
    },
    showTruckModal: function (component, evt, helper) {
        component.set("v.openTruckModal", true);
        var truckData = component.get("v.mpTruckData");
        var trucks = component.get("v.trucks");
        var selectedValue = component.get("v.selectedValue") || [];
        var prevSelectedValue = component.get("v.prevSelectedValue") || [];
        
        for (var plateno in trucks) {
            
            var val = trucks[plateno];
            
            for (var i = 0; i < val.length; i++){
                
            	if (selectedValue.indexOf(val[i].Id) >= 0 )  continue;
                if (prevSelectedValue.indexOf(val[i].Id) >= 0 ){
                    component.set("v.trucks",{});
                    continue;
                }
                
            	selectedValue.push(val[i].Id);    
                
            }
			
        }
        
        prevSelectedValue = selectedValue;
       	component.set("v.mpTruckData", truckData);
        component.set("v.selectedValue", selectedValue);
        component.set("v.prevSelectedValue", prevSelectedValue);
    },
    showNewContact: function (component, evt, helper) {
        component.set("v.openNewContact", true);
    },
    showNewTruck: function (component, evt, helper) {
        component.set("v.openNewTruck", true);
    },
    showContactModal: function(component, evt, helper) {
        
        component.set("v.openContactModal", true);
        
        var contactdata = component.get("v.mpfilteredContactData");
        var personnel = component.get("v.personnel");
        var selectedValue = component.get("v.selectedValue") || [];
        var prevSelectedValue = component.get("v.prevSelectedValue") || [];
        
        for (var position in personnel) {
            
            var val = personnel[position];
            
            for (var i = 0; i < val.length; i++){
                
            	if (selectedValue.indexOf(val[i].Id) >= 0 )  continue;
                if (prevSelectedValue.indexOf(val[i].Id) >= 0 ){
                    component.set("v.personnel",{});
                    continue;
                }
                
            	selectedValue.push(val[i].Id);    
                
            }
			
        }
        
        prevSelectedValue = selectedValue;
       	component.set("v.mpfilteredContactData", contactdata);
        component.set("v.selectedValue", selectedValue);
        component.set("v.prevSelectedValue", prevSelectedValue);
    },
    hideContactModal: function(component, evt, helper) {
        
        var prevSelectedValue = component.get("v.prevSelectedValue") || [];
        component.set("v.selectedValue", prevSelectedValue);
        component.set("v.openContactModal", false);
        
    },
    hideTruckModal: function(component, evt, helper) {
        
         var prevSelectedValue = component.get("v.prevSelectedValue") || [];
        component.set("v.selectedValue", prevSelectedValue);
        component.set("v.openTruckModal", false);
       
    },
    hideNewContact: function(component, evt, helper) {
        
        component.set("v.openNewContact", false);
        
    },
    hideNewTruck: function(component, evt, helper) {
        
        component.set("v.openNewTruck", false);
       
    },
    setDataToCalculate : function(component, event, helper) {
        
        var summaryIncluded = component.get("v.summaryIncluded");
		        
        var selectedValue = component.get("v.selectedValue");
        var isTruck = component.get("v.isTruck");
        var actualsize = parseInt(selectedValue.length);
        var requiredsize = parseInt(component.get("v.requiredsize"));
        var deficitsize = actualsize - requiredsize;
        var position = component.get("v.position");
        var remarks = component.get("v.remarks");
		var category = component.get("v.category");
        var type = component.get("v.type");
        var summary = component.get("v.mpDataResult");
       
        component.set("v.actualsize",actualsize);
        
          if (!summaryIncluded) {
            component.set("v.openContactModal", false);
            return;
          };
        
        var rating = 0;
        	
        if (deficitsize >= 0) {
            rating = 1;
            deficitsize = 0 ;
        }
        
        summary[position]["rating"] = rating;
        summary[position]["actual"] = actualsize;
        summary[position]["deficit"] = deficitsize;
        summary[position]["required"] = requiredsize;
        summary[position]["remarks"] = remarks;
        summary[position]["object"] = selectedValue.join(',');
               
        //console.log(JSON.stringify(summary));
        component.set("v.deficitsize", deficitsize);
        component.set("v.rating", rating);
        component.set("v.mpDataResult", summary);
        
        if (isTruck) {
            component.set("v.openTruckModal", false);
        } else {
        	component.set("v.openContactModal", false);    
        }
        
       	
    },
    disableButton: function(component, event, helper) {
        component.set("v.disableButton", true);
    },
    setRemarks: function(component, event, helper) {
        
        var summary = component.get("v.mpDataResult");
        var position = component.get("v.position");
        var remarks = component.get("v.remarks");
        summary[position]["remarks"] = remarks;
        component.set("v.mpDataResult", summary);
        //console.log(JSON.stringify(summary));
        
    },
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component
        component.set("v.openContactModal", false);
    },
  
    onContactSuccess: function(component, event, helper) {
          
    	var cData = component.get("v.mpfilteredContactData");    
        var record = event.getParam("response");
        var recordId = record.id;
        var fields = record.fields;
        var fName = fields.FirstName.value;
        var lName = fields.LastName.value;
        
        cData.push({
            "label": fName + " " +lName, 
            "value": recordId
        });
        console.log({
            "name": fName + " " +lName,
            "recordId": recordId,
            "record":JSON.stringify(record)
        });
        //console.log(JSON.stringify(cData));
        component.set("v.newContactData", cData);
        component.set("v.openNewContact", false)
    },
    onTruckSuccess: function(component, event, helper) {
          
    	var cData = component.get("v.mpTruckData");    
        var record = event.getParam("response");
        var recordId = record.id;
        var fields = record.fields;
  		
        cData.push({
            "label": fields.Plate_No__c.value, 
            "value": recordId
        });
        console.log({
            "recordId": recordId,
            "record":JSON.stringify(record)
        });
       
        //console.log(JSON.stringify(cData));
        component.set("v.mpTruckData", cData);
        
        component.set("v.openNewTruck", false);
        
    },
    onError: function(component, event, helper) {
        var errors = event.getParam("error");
        console.log(JSON.stringify(errors))
    },
    clearChecklist: function(component, event, helper) {
        
        var required = component.get("v.requiredsize");
        var actual = 0;
        var deficit =  0 - parseInt(required);
        
     	component.set("v.actualsize", 0);
        component.set("v.deficitsize", deficit);
        component.set("v.rating", 0);
        component.set("v.remarks", "");
        
    }

})