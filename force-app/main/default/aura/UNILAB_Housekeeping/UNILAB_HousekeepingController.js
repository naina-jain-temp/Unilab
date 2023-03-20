({    
     
     init: function(component, event, helper) {     
         
        /* helper.callApiRun(component,"0017F000006OaZcQAK", "2022", "July"); */
    
         var date = new Date();
         var lastMonth = date.getMonth() - 1;
         var monthString = helper.getMonthString[lastMonth];
         var year = date.getFullYear();
         
         	 component.set("v.month", monthString);

         	  helper.fetchAssessment(component,event);
         		
              helper.doInit(component, "A - Receiving Area","v.aaReceiving");
              helper.doInit(component, "B - Bulk Area","v.aaBulkarea");
              helper.doInit(component, "C - Loose-Pick Area","v.aaLPA");
              helper.doInit(component, "D - Checking Area","v.aaCheckingArea");
              helper.doInit(component, "E - Packing Area","v.aaPackingArea");
              helper.doInit(component, "F - Staging Area","v.aaStagingArea");
              helper.doInit(component, "G - B.O. Area","v.aaBOArea");
         	  helper.doInit(component, "H - Dispatch Area","v.aaDispatchArea"); 
              helper.doInit(component, "I - Cold Storage Area (Bio-Ref)/Air-Con Room","v.aaCSA"); 
              helper.doInit(component, "K - Ventilation System","v.aaVS");  
              helper.doInit(component, "J - Promo Merch Area","v.aaJPMA");
              helper.doInit(component, "L - Material Handling","v.aaMH");
              helper.doInit(component, "M - Office Area","v.aaOa");
              helper.doInit(component, "N - Washing Toilet Facilities","v.aaWTF");
              helper.doInit(component, "O - Temperature Monitoring","v.aaTM");     
         	  helper.doInit(component, "P - Others","v.aaOther");
        	
        	  helper.getThisMonthRecord(component, monthString, year);
       
    }, 
    
   
    
    hideConfirmationBox : function(component, event, helper) {
        component.set("v.openConfirmationBox", false);
    },
    
     hideInprogressModal : function(component, event, helper) {
        component.set("v.openProgressModal", false);
    },
    
    openConfirmationBox : function(component, event, helper) {
        component.set("v.openConfirmationBox", true);
    },
    
   
	disableSubmit: function (component, event, helper) {    
        component.set("v.disableSubmit", true);
    },
    
    calculate : function (component, event, helper) {
     	var assessment = component.get("v.Assessment");   
        var summary = {};
        
        for (var ctgry in assessment ) {
            
            var val = assessment[ctgry];
            var total = 0;
            
             if (summary == undefined) {
                    summary = {};
                }		
                
            if (summary[ctgry] == undefined) {
                summary[ctgry] = {
                    "optYes": 0,
                    "optNo": 0,
                    "optNa": 0,
                    "total": 0
                };
            }
        
            for (var line in val) {
                
                var lineItem = val[line];
                var numYes = lineItem.optYes;
                var numNo = lineItem.optNo;
                var numNa = lineItem.optNa;
        		
                var totalYes = parseInt(summary[ctgry]["optYes"]);
                var totalNo = parseInt(summary[ctgry]["optNo"]);
                var totalNa = parseInt(summary[ctgry]["optNa"]);
                
                totalYes = parseInt(totalYes) + parseInt(numYes);
                totalNo = parseInt(totalNo) + parseInt(numNo);
                totalNa = parseInt(totalNa) + parseInt(numNa);
                
                summary[ctgry]["optYes"] = totalYes;
                summary[ctgry]["optNo"] = totalNo;
                summary[ctgry]["optNa"] = totalNa;
                
            } // End of Line Item 
            
            //set the total value by ADDING "Yes" and "Na" total 
            //then LESS the "No" total
            
            total = parseInt (total) + parseInt(summary[ctgry]["optYes"]);
            total = parseInt (total) - parseInt(summary[ctgry]["optNo"]);
            total = parseInt (total) + parseInt(summary[ctgry]["optNa"]);
            
            summary[ctgry]["total"] = total;
            
           	component.set("v.Summary", summary);
            // clearsummary 

        } // End of Asssessment Category
        
    },
    
    submit : function (component, event, helper) {
           
        
        component.set("v.openConfirmationBox", false);
        component.set("v.openProgressModal", true);
        
        var assessment = component.get("v.Assessment"); 
        
        var result = helper.validate(assessment);
        
        if (result.errors == 0) {
            for (var ctgry in assessment) {
                var val = assessment[ctgry];
                
                for(var line in val) {
                    var lineItem = val[line];
                    
                    if (lineItem["optYes"]){
                        lineItem["Yes"] = true;
                        lineItem["No"] = false;
                        lineItem["Na"] = false;
                    } else if (lineItem["optNo"]) {
                        lineItem["Yes"] = false;
                        lineItem["No"] = true;
                        lineItem["Na"] = false;
                    } else if (lineItem["optNa"]) {
                        lineItem["Yes"] = false;
                        lineItem["No"] = false;
                        lineItem["Na"] = true;
                    }
                    
                    helper.saveWarehouseAssessment(component, lineItem);
                    //break; // to save only 1 record for testing purposes
                }
                //break; // to save only 1 record for testing purposes
            }
            
            
            component.set("v.progressbar", 100);
            component.set("v.progresscomplete", true);         
            component.set("v.isSubmitted", true);
            component.set("v.clearChecklist", true);
            component.set("v.progresstitle", "Completed");
            component.set("v.progressmessage", "Saved Successfully! Thank you for your patience.")
            component.set("v.validatemessage", "No Error Found.");
            component.set("v.notice", true);
            component.set("v.Summary", []);
       
            
        }else {
            var total = parseInt(result.success) + parseInt(result.errors);
            var progress = Math.floor((parseInt(result.errors) / total) *100)
            component.set("v.progressbar", progress);
            component.set("v.progresstitle", "Failed");
            component.set("v.progressmessage", "Please fill-up the empty checklist!");
            component.set("v.validatemessage", "Error Found: " + result.errors + " checklists are empty");
         
        }
        //helper.fetchAssessment(component,event);
    },
  
})