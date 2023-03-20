({
    getChecklist: function (component,  cfield) {
       var action = component.get('c.getChecklist');
      
        
        action.setParams({
            type : "Promo Materials Management"
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
               
               var checklist = response.getReturnValue();
               
               
                for (var i =0; i< checklist.length; i++){
                    checklist[i]["line"] = i+1;
                
                }
                //console.log(checklist);
               component.set(cfield, checklist);
               
               
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
            
        });
        
        $A.enqueueAction(action);
    },
    checkThisSemesterRecord: function (component, semester, year) {
       var action = component.get('c.checkThisSemesterRecord');
       var recordId = component.get("v.recordId");
       
        action.setParams({
            type : "Promo Materials Management",
            semester : semester,
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
                    component.set("v.isSubmitted", true);
                    component.set("v.disableButton", true);
                    alert("The checklist for this account is already submitted for this Semester!");
                    this.getWarehouseAssessment(component, semester, year );    
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

    reconstructArray : function (checklist, component) {
        
        var initSummary = component.get("v.initSummary");
        var newChecklist = [];
        
        var categorymap = this.categorymap;
        var sectionmap = this.sectionmap;
        var totalItemCount = 0;
        
        for (var i = 0; i < checklist.length; i++) {
            
            var val = checklist[i];
     		var category = val.Category__c;
            var section = val.Section__c;
			var sf = sectionmap[section];
            var cf = categorymap[category];
            
            if (newChecklist[sf] == undefined) {
                newChecklist[sf] = []
            }
         
            var index = categorymap[category]; // Get the index number of the Category in the Category Mapping.
            
            if (newChecklist[sf][index] == undefined) {
                newChecklist[sf][index] = []; 
            }
            
            if (initSummary[cf] == undefined) {
                initSummary[cf] = {
                    "score": 0,
                    "itemcount": 0,
                    "totalitem":0,
                    "rating": 0,
                    "category": category
                };
            }
            
            var itemcount = parseInt(initSummary[cf]["itemcount"]);
            itemcount ++;
            totalItemCount++;
            initSummary[cf]["itemcount"] = itemcount;
            initSummary[cf]["totalitem"] = itemcount;
            newChecklist[sf][index].push(val)
        	
        }
        initSummary["total"] = {
                    "score": 0,
                    "itemcount": totalItemCount,
                    "rating": 0,
            		"ratingscale" : 1
                };
        component.set("v.initSummary", initSummary);
        component.set("v.categorymap", categorymap);
        return newChecklist;
    },
    getWarehouseAssessment : function (component, period, year ) {
        
       var action = component.get('c.loadAssessment');
       var recordId = component.get("v.recordId");
        
        action.setParams({
            type : "Promo Materials Management",
            accountId : recordId,     
            period : period,
            year : year
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                var summary = {};
                var totalItemCount = 0;
                
                for (var i=0; i<result.length; i++) {
                    
                	var val = result[i];
                    var category = val.Category__c;
                    var rating = val.Rating__c;
                    if (summary[category] == undefined) {
                        summary[category] = {
                            "category": category,
                            "title": val.Title__c,
                            "year": val.Year__c,
                            "period": val.Period__c,
                            "score": 0
                        };
                    }
                    if (val.Yes__c) {
                        summary[category].score += 1;
                    }
                    
                }
                
                component.set("v.assessmentSummary", summary);
                console.log(JSON.stringify(summary));
                console.log("Period: " + period);
                console.log("Year:" + year);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
    },
    saveWarehouseAssessment : function (component, lineItem, lineno) {
        
        var action = component.get("c.saveWarehouseAssessment");
        var recordId = component.get("v.recordId");
        var year = component.get("v.year");
        var period = component.get("v.period");
       
        //console.log(JSON.stringify(lineItem));
        lineItem["type"] = "Promo Materials Management";
        action.setParams({
            checklist: lineItem,
            recordId: recordId,
            lineno: lineno,
            year: year,
            period: period
        });
        
        action.setCallback(this, function(response){
             var state = response.getState();
            
            if (state === "SUCCESS") {
                try{
                     var assessmentId = response.getReturnValue();
              	 	component.set("v.AssessmentId",assessmentId);
                	
                }catch(err){
                    console.log(err.toString())
                }
               
            
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        
        $A.enqueueAction(action);
    },
     
    validate : function (component, assessmentResult) {
        var result = {
            success: 0,
            fail: [
                
            ]
        };
        for (var category in assessmentResult) {
            
            var val = assessmentResult[category];
            
            for (var line in val) {
                
                if (line == "total_rating" || line == "section") continue;
                
                var lineItem  = val[line];
                var remarks = lineItem.remarks;
                var rating = lineItem.rating;
                var ratingYes = lineItem.rating_yes;
                var ratingNo = lineItem.rating_no;
                var ratingNa = lineItem.rating_na;
                console.log(ratingNa);
                //console.log(JSON.stringify(lineItem));
                
                if (!remarks && !ratingYes) {
                    
                        result.fail.push({
                            "line": line
                        });    
                    
                }else {
                    result.success++;
                }
            }
        }
        return result;
    },
    sectionmap:{
        "Promo Materials Management" : "promomatsmanagement"
    },
    
    categorymap : {
        "PMM-01: Issue-In Process thru NetSuite": 0,
        "PMM-02: Pull-Out Process by L/AMP": 1,
        "PMM-03: iServ Redemption Process": 2,
        "PMM-04: Issue-Out Process for Warehouse Bundling": 3,
        "PMM-05: Warehouse Bundling Process": 4,
        "PMM-06: Receiving of Bundled Items": 5,
        "PMM-07: Monthly General Inventory Count": 6

    }
})