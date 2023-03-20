({
    getChecklist: function (component, category, field, meta,rowNo, rtfld, recordId) {
        
       var action = component.get('c.getChecklist');
       
        action.setParams({
            type : "Manpower",
            category: category,
            accountId: recordId
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var checklist = response.getReturnValue();
                
                if (checklist.length == 0)   {
                    this.getChecklist(component, category, field, meta, rowNo, rtfld, null);
                } else {
                    var obj = component.get(rtfld);
                    var requiredsize = obj['required'];
                    
                    for (var i=0; i<checklist.length; i++) {
                        requiredsize = parseInt(requiredsize) + parseInt(checklist[i].Required_Size__c);  	
                    }
                    
                    obj['required'] = requiredsize;
                    component.set(rtfld, obj);
                    component.set(field, checklist);
                }
                            
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
    },
    getThisMonthRecord: function (component, month, year) {
       var action = component.get('c.checkThisMonthRecord');
       var recordId = component.get("v.recordId");
       
        action.setParams({
            type : "Manpower",
            month : month,
            year : year,
            recordId : recordId     
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log("RESULT LENGTH: " + result.length);
                if (result.length) {
                	component.set("v.alreadyExist", true);
                    component.set("v.isCopied", true);
                    component.set("v.isSubmitted", true);
                    component.set("v.disableButton", true);
                    alert("The checklist for this account is already submitted for this month!");
                    this.getWarehouseAssessment(component, month, year)
                    
                }else {
                    component.set("v.alreadyExist", false);    
                }
                
            
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
    },
    getContacts: function (component, field, category) {
            var action = component.get('c.getContacts');
      		var recordId = component.get("v.recordId");
        
        	action.setParams({
            	category: category,
                names: null,
                accountId: recordId
        	});
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var contacts = response.getReturnValue();
                
                
                var reContacts = [];
                
                for (var i=0; i<contacts.length; i++){
                    reContacts.push({
                        "label": contacts[i].Name,
                        "value": contacts[i].Id,
                        "position": contacts[i].Position__c
                       });
                }
				//console.log(JSON.stringify(reContacts));
                component.set(field, reContacts);
              
            
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    getTrucks: function (component, field, category) {
            var action = component.get('c.getTrucks');
      
        	action.setParams({
                platenos: null
        	});
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var trucks = response.getReturnValue();
                
                var reTrucks = [];
                
                for (var i=0; i<trucks.length; i++) {
                    reTrucks.push({
                        "label": trucks[i].Plate_No__c,
                        "value": trucks[i].Id,
                        "brand": trucks[i].Brand__c,
                        "capacity": trucks[i].Capacity__c
                       });
                }
                
				//console.log(JSON.stringify(reTrucks));
                component.set(field, reTrucks);
              
            
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    getLastMonthRecord: function (component, month, year) {
       var action = component.get('c.getLastMonthRecord');
       var recordId = component.get("v.recordId");
       
        action.setParams({
            type : "Manpower",
            month : month,
            year : year,
            recordId : recordId     
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                var data = {};
                
                for (var i=0; i<result.length; i++) {
                    
                    var val = result[i];
                    var category = this.categorymap[val.Category__c];
                    var title = val.Title__c;
                   
                    if (data[category] == undefined){
                        data[category] = {};
                    }
                    
                        data[category][title] = {
                            "required_size": val.Required_Size__c,
                            "actual_size": val.ActualSize__c,
                            "deficit": val.Deficit__c,
                            "rating": val.Rating__c,
                            "remarks": val.Remarks__c || "",
                            "object": val.selected_Value__c||""
                           
                        };
                    
                }
          		
                //console.log(JSON.stringify(data));
                component.set("v.lmData", data);
            
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
    },
	
    calcRating : function (data, ratings) {
        
        var required = parseInt(ratings['required']);
        var actual = 0;
        var deficit = 0;
        
        for (var pos in data){
            
            actual = parseInt(actual) + parseInt(data[pos]['actual']);
            
        }
        
        deficit = parseInt(actual) - parseInt(required);
        
        if (deficit > 0) {
            deficit = 0;
        }
        
        ratings['actual'] = actual;
        ratings['deficit'] = deficit;
        
        return ratings;
    },
    getWarehouseAssessment : function (component, period, year ) {
        
       var action = component.get('c.loadAssessment');
       var recordId = component.get("v.recordId");
        
        action.setParams({
            type : "Manpower",
            accountId : recordId,     
            period : period,
            year : year
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                //console.log(JSON.stringify(result));
                var summary = {};
                var totalItemCount = 0;
                
                for (var i=0; i<result.length; i++) {
                    
                	var val = result[i];
                    var actual = val.ActualSize__c;
                    var deficit = val.Deficit__c;
                    var required = val.Required_Size__c;
                    var category = this.categorymap[val.Category__c];
                    
                    
                    if (summary[category] == undefined) {
                        summary[category] = {
                            "actual": 0,
                            "deficit": 0,
                            "required": 0,
                        };
                    }
                    
                    summary[category].actual += actual;
                    summary[category].deficit += deficit;
                    summary[category].required += required;
                }
                
                    component.set("v.brratings", summary.bp);
                    component.set("v.whratings", summary.wlp);
                    component.set("v.fldratings", summary.fsp);
                    component.set("v.trratings", summary.tr);
                //console.log(JSON.stringify(summary));
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
    },
    saveWarehouseAssessment : function (component, checklist) {
        
        var action = component.get("c.saveWarehouseAssessment");
        var recordId = component.get("v.recordId");
        var year = component.get("v.year");
        var period = component.get("v.month");
        
        action.setParams({
            checklist: checklist,
            recordId: recordId,
            year: year,
            period: period
        });
        
        action.setCallback(this, function(response){
             var state = response.getState();
            
            if (state === "SUCCESS") {
              	console.log(response.getReturnValue())
            
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        
        $A.enqueueAction(action);
    },
    proceedtoSave : function (component, helper, checklistdata) {
	        
        	
          for (var pos in checklistdata) {
                
            	var checklist = checklistdata[pos];
				console.log(JSON.stringify(checklist));              	
                helper.saveWarehouseAssessment(component, checklist);
            }
    },
    getMonthString : [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ],
    categorymap: {
        "Backroom Personnel": "bp",
        "Warehouse & Logistics Personnel": "wlp",
        "Field Personnel": "fsp",
        "Truck Requirement": "tr"
    }
})