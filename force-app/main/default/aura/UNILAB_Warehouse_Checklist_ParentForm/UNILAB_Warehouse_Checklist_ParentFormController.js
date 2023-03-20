({    
            
     init: function(component, event, helper) {     
         
         helper.doInit(component, "Functional Areas","v.functionalAreas"); 
         helper.doInit(component, "Material Handling Equipment","v.materialHandlingEquipment"); 
         helper.doInit(component, "Storage Equipment","v.storageEquipment"); 
         helper.doInit(component, "Personal Protective Equipment (PPEs)","v.ppEquipment");                   
		 helper.doInit(component, "Thermometers","v.thermometer");        
         helper.doInit(component, "Others","v.others");

        var date = new Date();
		var year = date.getFullYear();
        var currentMonth = date.getMonth() + 1;
        var semester = [];
        
        //Sem 1, only available on May to June.
        if (currentMonth >= 1 && currentMonth <= 5){
            semester.push("Sem 1");    
        } else if (currentMonth >= 6 && currentMonth <= 12) { // Sem2, only available on September to October.
            semester.push("Sem 2");    
        } else {
            component.set("v.disableSubmit", true);
        }                
        component.set("v.years",  [year]);
        component.set("v.semester", semester);      
		
         
   		helper.checkThisSemesterRecord(component, semester[0], year);
        helper.getSavedData(component, "v.savedData");  
        
                  
    },
    
     retrieveDraft : function(component, event, helper) {
         
         helper.getRetrieveAssessment(component, "v.draftData", true);       	        
    },
    
    
    showModal : function(component, event, helper) {
     	component.set("v.openModal", true);        
    },
    
    hideModal : function(component, event, helper) {
        component.set("v.openModal", false);
    },
        
    saveDraftConfirmation : function(component, event, helper, isDraft) {

        component.set("v.saveDraftConfirmation", true);
        
       
    },
    
    hideSaveDraftConfirmation : function(component, event, helper) {
        component.set("v.saveDraftConfirmation", false);
    },
    
    showModal2 : function(component, event, helper) {
     	component.set("v.openModal2", true);        
    },
    
    hideModal2 : function(component, event, helper) {
        component.set("v.openModal2", false);
    },
           
    saveRecord : function(component, event, helper) {	  
        
        component.set("v.openConfirmationBox",false);
        component.set("v.openProgressModal",true);
        
        var assessment = component.get("v.assessment");        
        var isDraft = component.get("v.isDraft");
        var year = component.get("v.year");
        var period = component.get("v.period");        
        var vResult = helper.validate(assessment);
        
        
        if (vResult.errors == 0 ) {
            
        	for (var category in assessment) {
                var val = assessment[category];
                
                for (var title in val) {
                    
                    var lineitem = val[title];                 
                   
                    helper.saveAssessment(component, lineitem, year, period, isDraft);
                    
                }
            }   
            
            component.set("v.progressbar", 100);
            component.set("v.progresstitle", "Completed");
            component.set("v.progressmessage", "Saved Successfully!")
            component.set("v.validatemessage", "No Errors Found.");
            component.set("v.isdisabled", true);
            component.set("v.isdisabled2", true);
            component.set("v.isdisabled3", true);
            component.set("v.disablePeriod", true);
            component.set("v.disableYear", true);
            component.set("v.notice", true);                     
			component.set("v.clearData",0);
                       
        } else {
            var total = parseInt(vResult.errors) + parseInt(vResult.success);
            var progress = Math.floor((vResult.success/total) * 100);
            component.set("v.progressbar", progress);
            component.set("v.progresstitle", "Failed");
            component.set("v.progressmessage", "Please fill-up the empty rows in checklist!");
            component.set("v.validatemessage", "Error Found: " + vResult.errors + " checklists are empty");           
        }
                     

    },
    
    saveDraft : function(component, event, helper) {	  
        
        component.set("v.saveDraftConfirmation",false);
		
		var isDraft = true;        
        var assessment = component.get("v.assessment");
        var year = component.get("v.year");
        var period = component.get("v.period");
        
       	for (var category in assessment) {
                var val = assessment[category];
                
                for (var title in val) {
                    
                    var lineitem = val[title];
                    lineitem.actual_size = lineitem.actual_size || 0;              		

                    helper.helperSaveDraft(component, lineitem, year, period, isDraft);
                    
                }
            }           
                
        alert ("Draft saved!");
   
       
    },
    
    hideConfirmationBox : function(component, event, helper) {
        component.set("v.openConfirmationBox", false);
    },
    hideInprogressModal : function(component, event, helper) {
        component.set("v.openProgressModal", false);
    
    },
    showConfirmationBox : function(component, event, helper) {
        component.set("v.openConfirmationBox", true);
    },
    
    calculate : function(component, event, helper){	   
       var sumRating = component.get("v.sumRating");
       helper.calculateRating(component, sumRating)
        
    },

                                          
})