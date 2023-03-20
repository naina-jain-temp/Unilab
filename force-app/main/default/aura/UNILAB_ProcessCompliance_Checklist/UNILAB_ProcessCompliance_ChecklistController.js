({
	init: function (component, event, helper) {
        
        var date = new Date();
		var year = date.getFullYear();
        var currentMonth = date.getMonth() + 1;
        var semester = [];
        
        //Sem 1, only available on May to June.
        if (currentMonth >= 0 && currentMonth <= 5){
            semester.push("Sem 1");    
        } else if (currentMonth >= 6 && currentMonth <= 11) { // Sem2, only available on September to October.
            semester.push("Sem 2");    
        } else {
            component.set("v.disableSubmit", true);
        }
        
        
        component.set("v.years",  [year]);
        component.set("v.semester", semester);
        
        helper.getChecklist(component, "v.assessmentData");
        helper.checkThisSemesterRecord(component, semester[0], year);
    },
    constructChecklist: function (component, event, helper) {
        
        var checklist = component.get("v.assessmentData");
      	
      
		var newChecklist = helper.reconstructArray(checklist, component);
       	//console.log(newChecklist);
       	
        component.set("v.ordermanagement", newChecklist.ordermanagement);
        
        //console.log(newChecklist.ordermanagement);
        
        component.set("v.inventorymanagement", newChecklist.im);
        //console.log(newChecklist.inventorymanagement);
        
        component.set("v.accountsreceivable", newChecklist.ar);
        //console.log(newChecklist.accountsreceivable);
        
        component.set("v.formsanddocuments", newChecklist.formsanddocuments);
        //console.log(newChecklist.formsanddocuments);

    },
    calculate : function (component, event, helper) {
        
        var assessmentResult = component.get("v.assessmentResults");
        var year = component.get("v.year");
        var period = component.get("v.period");
        var summary = {};
        var sectionmap = helper.sectionmap;
        
        for (var category in assessmentResult) {
            var val = assessmentResult[category];
            var section = val.section;
            var rating = parseInt(val.total_rating);
            
            var sf = sectionmap[section];
            
            if (summary[sf] == undefined) {
                summary[sf] = {
                    "category": val.category,
                    "title": val.title,
                    "year": year,
                    "period": period,
                    "score": 0
                };
            }
            
            var totalScore = parseInt(summary[sf]['score']);
            totalScore += rating;
            
            summary[sf]['score'] = totalScore;
            
        }
        
        component.set("v.assessmentSummary", summary);
        
        
        //console.log(JSON.stringify(summary));
    },
    /* showSummary : function (component) {
        var assessmentSummary = component.get("v.assessmentSummary");
        var period = component.get("v.period");
        var initSummary = component.get("v.initSummary");
       
        
        //Show Modal
        var modalBody;
        
        $A.createComponent("c:UNILAB_ProcessCompliance_Summary", {
            "summary" : initSummary,
            "assessmentSummary" : assessmentSummary,
            "period" : period
        },
           function(content, status) {
               if (status === "SUCCESS"){
                   
                   modalBody = content;
                   var modalcmp = component.find('summary-modal');
             
                   modalcmp.showCustomModal({
                       header: "Summary",
                       body: modalBody,
                       showCloseButton: true,
                       cssClass: "summary-modal"
                   });
                   
               }
           });
    },*/
    submit : function (component, event, helper) {
      
        var assessmentResult = component.get("v.assessmentResults");
        var year = component.get("v.year");
        var period = component.get("v.period");
        var validateResult = helper.validate(component, assessmentResult);
        console.log(JSON.stringify(validateResult));
        if (!validateResult.fail.length) {
            for (var category in assessmentResult) {
                
                var val = assessmentResult[category];
                
                for (var line in val) {
                    
                    if (line == "total_rating" || line == "section") continue;
                    var lineItem  = val[line];
                        helper.saveWarehouseAssessment(component, lineItem, line);
                }
                
            }
            component.set("v.isSubmitted", true);
            component.set("v.alreadyExist", true);
            component.set("v.disableButton", true);
            component.set("v.validateResult", validateResult.fail);
            component.set("v.validateFailed", true);
        } else {
            component.set("v.validateResult", validateResult.fail);
            component.set("v.validateFailed", true);
            component.set("v.progresstitle", "Failed");
            component.set("v.progressmessage", "Failed to save due to following "+validateResult.fail.length+" error:");
        }
      
        component.set("v.openConfirmationBox", false);
        component.set("v.openProgressModal", true);
        
    },
    setLocalStorage : function (component, event, helper) {
        var assessmentLocal = component.get("v.assessmentLocal");
        var period = component.get("v.period");
        var year = component.get("v.year");
        
        assessmentLocal["period"] = period;
        assessmentLocal["year"] = year;
        //console.log(JSON.stringify(assessmentLocal));
       	localStorage.setItem('assessmentLocal',JSON.stringify(assessmentLocal));
        //console.log(JSON.parse(localStorage.getItem('assessmentLocal')));
    },
	confirm : function (component, event, helper) {    
        
      component.set("v.openConfirmationBox", true);
    },
    hideInprogressModal: function (component, event, helper) {    
        
      component.set("v.openProgressModal", false);
        
    }, 
     hideCriteriaModal: function (component, event, helper) {    
        
      component.set("v.openCriteriaModal", false);
        
    },
     hideRatingScaleModal: function (component, event, helper) {    
        
      component.set("v.openRatingScaleModal", false);
        
    },
    hideConfirmationBox: function (component, event, helper) {    
        
      component.set("v.openConfirmationBox", false);
        
    }, 
    disableSubmit: function (component, event, helper) {    
        component.set("v.disableSubmit", true);
    },
    showCriteria: function (component, event, helper) {    
        component.set("v.openCriteriaModal", true);
    },
    showRatingScale: function (component, event, helper) {    
        component.set("v.openRatingScaleModal", true);
    },
    updateProgressbar : function (component, event, helper) {   
        
        var initSummary = component.get("v.initSummary");
        var itemCount = parseInt(initSummary["total"]["itemcount"])
     	var progress = parseInt(component.get("v.progress")) || 0;
        progress++;
        
        var progressbar =  Math.floor((progress/itemCount) * 100);
       	component.set("v.progressbar", progressbar);
        component.set("v.progress", progress);
        
        if (progressbar == 100){
            
            component.set("v.progresstitle", "Complete");
            component.set("v.progressmessage", "Save Successfully!, Thank you so much for your Patience.");
            component.set("v.clearChecklist", true);
        }
		       
    }
})