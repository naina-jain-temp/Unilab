({
   
    doInit : function (component, category, field) { 
        
        var action = component.get("c.loadChecklist"); 
		var asssessment = component.get("v.Assessment");        
        
        action.setParams({ 
            type : "House keeping",
            category: category 
       
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               var result = response.getReturnValue();
                
                for (var i =0; i<result.length; i++) {
                    
                    var val = result[i];
                	var categoryLine = this.categoryMap[val.Category__c];    
                    result[i]["category_map"] = categoryLine;
                    result[i]["line"] = i;
                    
                }
                component.set(field, result);
                
            } else if (state === "ERROR") {
                console.log (response.getError());
            }
         });
        
            $A.enqueueAction(action);     

    },
    
    fetchAssessment : function (component,event) { 
         
        var action = component.get("c.getWarehouseAssessment");
        var recordId = component.get("v.recordId");
        var period = component.get("v.period");
        var year = component.get("v.year");
        
        
        action.setParams({
            recordId: recordId,
            period: period,
            year: year
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
               var result = response.getReturnValue();
               component.set('v.withData',response.getReturnValue());
            	
                
            } else if (state === "ERROR") {
            	component.set('v.withData','0');
                console.log (response.getError());
            }
        });
        
        $A.enqueueAction(action);     

   },
    getThisMonthRecord: function (component, month, year) {
        
       var action = component.get('c.checkThisMonthRecords');
       var recordId = component.get("v.recordId");
        console.log({
            month: month,
            year: year,
            recordId: recordId
        });
        action.setParams({
            type : "House Keeping",
            period : month,
            year : year,
            recordId : recordId     
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log("RESULT LENGTH: " + result.length);
                if (result.length) {
                	
                    component.set("v.isSubmitted", true);
                    component.set("v.disableButton", true);
                    component.set("v.notice", true);
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
    getWarehouseAssessment : function (component, period, year ) {
        
       var action = component.get('c.loadAssessment');
       var recordId = component.get("v.recordId");
        
        action.setParams({
            type : "House Keeping",
            accountId : recordId,     
            period : period,
            year : year
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                var summary = {};
                console.log("This Month Record: " );
                console.log(JSON.stringify(result));
                
                for (var i=0; i<result.length; i++) {
                    
                	var val = result[i];
                    var numYes = (val.Yes__c) ? 1 : 0; 
                    var numNo = (val.No__c) ? 1 : 0;
                    var numNa = (val.NA__c) ? 1 : 0;
                    
                    console.log("Category: " + val.Category__c);
                    
                    var category = this.categoryMap[val.Category__c];
                    
                	if (summary[category] == undefined) {
                        summary[category] = {
                            "optYes": 0,
                            "optNo": 0,
                            "optNa": 0,
                            "total": 0
                        };
                    } 
                    
                    var totalYes = summary[category]["optYes"];
                    var totalNo = summary[category]["optNo"];
                    var totalNa = summary[category]["optNa"];
                    var total = summary[category]["total"];
                    
                    console.log("Total Yes: " + totalYes);
                    console.log("Total No: " + totalNo);
                    console.log("Total Na: " + totalNa);
                    console.log("Total: " + total);
                    
                    totalYes = parseInt(totalYes) + parseInt(numYes);
                    totalNo = parseInt(totalNo) + parseInt(numNo);
                    totalNa = parseInt(totalNa) + parseInt(numNa);
                    
                  	summary[category]["optYes"] = totalYes;
                    summary[category]["optNo"] = totalNo;
                    summary[category]["optNa"] = totalNa;
                    
                   //total = parseInt (total) + parseInt(totalYes);
                   //total = parseInt (total) - parseInt(totalNo);
                   //total = parseInt (total) + parseInt(totalNa);
                   
                    total = parseInt(totalYes) + parseInt(totalNa) - parseInt(totalNo);
                    
                    summary[category]["total"] = total;
            
           
                }
                
				component.set("v.Summary", summary);                    
                
                console.log(JSON.stringify(summary));
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
    },
    saveWarehouseAssessment : function (component, lineItem) {
        
        var action = component.get("c.saveWarehouseAssessment");
        var recordId = component.get("v.recordId");
        var period = component.get("v.period");
        var year = component.get("v.year");
        
        console.log(JSON.stringify(lineItem));
        
        action.setParams({
            checklist: lineItem,
            recordId: recordId,
            period: period,
            year: year
        });
        
        action.setCallback(this, function(response) {
             var state = response.getState();
          
            if (state === "SUCCESS") {
              	console.log(response.getReturnValue())
            	
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
                
            }
        });
        
        this.callApiRun(component,recordId, year, period);
        
        $A.enqueueAction(action);
    },
    
    callApiRun : function (component, acct, year, period) {
        var action = component.get("c.runApi");
        
        action.setParams({
            acct,
            year,
            period
        });
        
        action.setCallback(this, function(response) {
             var state = response.getState();
             alert(state);
            if (state === "SUCCESS") {
              	console.log(response.getReturnValue())
            	
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                alert(errors);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    validate : function (assessment) {
        
        var result = {
            "errors": 0,
            "success": 0
        };
        console.log(JSON.stringify(assessment));
        for (var ctgry in assessment) {
            var val = assessment[ctgry];
            
            for(var line in val) {
                var lineItem = val[line];
                
                if (lineItem["optYes"]){
                    
                    result.success++;
                } else if (lineItem["optNo"]) {
                  
                    result.success++;
                } else if (lineItem["optNa"]) {
                  
                    result.success++;
                } else {
                    result.errors++;
                }
            }
            
        }
        
        return result;
    }, getMonthString : [
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
    categoryMap : {
        "A - Receiving Area": "0",
        "B - Bulk Area": "1",
        "C - Loose-Pick Area": "2",
        "D - Checking Area": "3",
        "E - Packing Area": "4",
        "F - Staging Area": "5",
        "G - B.O. Area": "6",
        "H - Dispatch Area": "7",
        "I - Cold Storage Area (Bio-Ref)/Air-Con Room": "8",
        "K - Ventilation System": "9",
        "J - Promo Merch Area": "10",
        "L - Material Handling": "11",
        "M - Office Area": "12",
        "N - Washing Toilet Facilities": "13",
        "O - Temperature Monitoring": "14",
        "P - Others": "15"
    }

})