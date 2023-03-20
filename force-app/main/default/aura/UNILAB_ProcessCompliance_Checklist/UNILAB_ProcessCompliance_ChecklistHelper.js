({
    getChecklist: function (component,  cfield) {
       var action = component.get('c.getChecklist');
      
        
        action.setParams({
            typex : "Process Compliance"
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
               
               var checklist = response.getReturnValue();
               console.log(checklist);
               
                for (var i =0; i< checklist.length; i++){
                    checklist[i]["line"] = i+1;
                
                }
               
               component.set(cfield, checklist);
               
               
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
    },
   checkThisSemesterRecord: function (component, semester, year) {
       var action = component.get('c.checkThisSemesterRecord');
       var recordId = component.get("v.recordId");
       
        action.setParams({
            type : "Process Compliance",
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
                    this.getWarehouseAssessment(component, semester, year);
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
        var sectionmap = this.sectionmap;
        
        var categorymap = this.categorymap;
        
        var totalItemCount = 0;
        
        for (var i = 0; i < checklist.length; i++) {
            
            var val = checklist[i];
     		var category = val.Category__c;
            var section = val.Section__c;
			var sf = sectionmap[section];
            
            if (newChecklist[sf] == undefined) {
                newChecklist[sf] = []
            }
         
            var index = categorymap[category]; // Get the index number of the Category in the Category Mapping.
            
            if (newChecklist[sf][index] == undefined) {
                newChecklist[sf][index] = []; 
            }
            
            if (initSummary[sf] == undefined) {
                initSummary[sf] = {
                    "score": 0,
                    "itemcount": 0,
                    "rating": 0
                };
            }
            
            var itemcount = parseInt(initSummary[sf]["itemcount"]);
            itemcount ++;
            totalItemCount++;
            initSummary[sf]["itemcount"] = itemcount;
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
            type : "Process Compliance",
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
                    var section = this.sectionmap[val.Section__c];
                    var rating = val.Rating__c;
                    var category = val.Category__c;
                    if (summary[section] == undefined) {
                        summary[section] = {
                            "category": category,
                            "title": val.Title__c,
                            "year": val.Year__c,
                            "period": val.Period__c,
                            "score": 0
                        };
                    }
                    summary[section].score += rating;
                }
                
                component.set("v.assessmentSummary", summary);
                console.log(JSON.stringify(summary))
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
        lineItem["type"] = "Process Compliance";
        action.setParams({
            checklist: lineItem,
            lineno: lineno,
            recordId: recordId,
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
            fail: []
        };
        for (var category in assessmentResult) {
            
            var val = assessmentResult[category];
            
            for (var line in val) {
                
                if (line == "total_rating" || line == "section") continue;
                
                var lineItem  = val[line];
                var remarks = lineItem.remarks;
                var rating = lineItem.rating;
                
                console.log(JSON.stringify(lineItem))
                if (!remarks && !rating) {
                    result.fail.push({
                        "line": line
                    })
                }else {
                    result.success++;
                }
            }
        }
        return result;
    },
    sectionmap : {
        "I. Total Order Management" : "ordermanagement",
        "II. Inventory Management": "im",
        "III. Accounts Receivable" : "ar",
        "IV. Forms and Documents" : "formsanddocuments"
    },
    categorymap : {
        "TOM-01: Order Entry": 0,
        "TOM-02: Order Processing": 1,
        "TOM-03: Dispatch Process": 2, 
        "TOM-04: Delivery of Stocks to Customer": 3,
        "TOM-05: Post Delivery": 4,
        "TOM-06: Returns Upon Delivery Process": 5,
        "TOM-07: Trade Returns": 6,
        "IM-01: Purchase Order Creation": 0,
        "IM-02: Receiving of Stocks": 1,
        "IM-03: Returns to Unilab": 2, 
        "IM-04: Stock Adjustment Process": 3,
        "IM-05: Monthly Inventory Count Process": 4,
        "IM-06: Daily Cycle Count": 5,
        "AR-01: Collection and Payment Update": 0,
        "AR-02: Credit Memo Processing With Invoice Reference Number": 1,
        "AR-03: Credit Memo Processing Without Invoice Reference Number": 2,
        "AR-04: Debit Memo Processing": 3,
        "PMM-01: Issue-In Process thru NetSuite": 0,
        "PMM-02: Pull-Out Process by L/AMP": 1,
        "PMM-03: iServ Redemption Process": 2,
        "PMM-04: Issue-Out Process for Warehouse Bundling": 3,
        "PMM-05: Warehouse Bundling Process": 4,
        "PMM-06: Receiving of Bundled Items": 5,
        "PMM-07: Monthly General Inventory Count": 6,
        "Forms and Documents": 0

    }
})