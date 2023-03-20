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
        helper.checkThisSemesterRecord(component, semester[0], year);
        
        helper.getChecklist(component, "v.assessmentData");
        
    },
    
    constructChecklist: function (component, event, helper) {
        
        var checklist = component.get("v.assessmentData");
      	
      	
		var newChecklist = helper.reconstructArray(checklist, component);
       	//console.log(newChecklist);
       	
        component.set("v.promomatsmanagement", newChecklist.promomatsmanagement);
		
    },
    
    calculate : function (component, event, helper) {
        
        var assessmentResult = component.get("v.assessmentResults");
        var initSummary = component.get("v.initSummary");
        var year = component.get("v.year");
        var period = component.get("v.period");
        var summary = {};
        
        for (var category in assessmentResult) {
            
            var val = assessmentResult[category];
        	var cf = helper.categorymap[category];
            
            var section = val.section;
            var rating = parseInt(val.total_rating);
            
            for (var line in val ) {
                
                var lineval = val[line];
                var ratingYes = lineval.rating_yes;
                var ratingNo = lineval.rating_no;
                var ratingNa = lineval.rating_na;
                
                if (summary[category] == undefined) {
                    summary[category] = {
                        "category": lineval.category,
                        "title": lineval.title,
                        "year": year,
                        "period": period,
                        "score": 0,
                        "ratingna":0
                    };
                }
                                    
                if (ratingYes) {
                  summary[category]['score'] += 1;
                }
                
                if (ratingNa) {
                  summary[category]['ratingna'] += 1;
                } 
             
            }
            
            
        }
        

        component.set("v.assessmentSummary", summary);
        
        
        //console.log(JSON.stringify(summary));
    },
   
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
            component.set("v.disableButton", true);
            component.set("v.alreadyExist", true);
           	component.set("v.validateResult", validateResult.fail);
            component.set("v.validateFailed", false);
            component.set("v.progresstitle", "Sucess");
            component.set("v.progressmessage", "Thank you for your patience!");
            
        }else {
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
            component.set("v.clearChecklist", true);
            component.set("v.progresstitle", "Complete");
            component.set("v.progressmessage", "Save Successfully!, Thank you so much for your Patience.");
        }
		       
    }
})