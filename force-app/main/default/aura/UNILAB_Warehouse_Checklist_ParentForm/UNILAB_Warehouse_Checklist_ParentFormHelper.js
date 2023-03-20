({    
    
    doInit : function (component, category, field) { 
        var action = component.get("c.loadChecklist"); 
        var accountId = component.get("v.recordId");
        action.setParams({ 
            type : "Warehouse Assessment",
            category : category,
            accountId : accountId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               var result = response.getReturnValue();				                
               var totalLine1 = 0;
               var totalLine2 = 0;
               var totalLine3 = 0;
               var totalLine4 = 0;
               var totalLine5 = 0;
               var totalLine6 = 0;
         	  
                
                for (var i = 0; i < result.length; i++){                   
                    var category = result[i].Category__c;  
				
                     if (category == "Functional Areas") {                       
                    	totalLine1++;                             
                        component.set("v.totalLine1",totalLine1);

                     } else if (category == "Material Handling Equipment") {                          
                    	totalLine2++;
                        component.set("v.totalLine2",totalLine2);
                         
                     } else if (category == "Storage Equipment") {                          
                    	totalLine3++;
                        component.set("v.totalLine3",totalLine3);
                         
                     } else if (category == "Personal Protective Equipment (PPEs)") {                          
                    	totalLine4++;
                        component.set("v.totalLine4",totalLine4);
                         
                     } else if (category == "Thermometers") {                          
                    	totalLine5++;
                        component.set("v.totalLine5",totalLine5);
                         
                     } else if (category == "Others") {                          
                    	totalLine6++;
                        component.set("v.totalLine6",totalLine6);
                     }
           
                }     
                component.set(field, result);  

            	} else if (state === "ERROR") {             
              	console.log(reponse.getError());
            }
                  
            
         });
        
            $A.enqueueAction(action);     
        
        

    },
    
    validate : function(assessment) {
        var result = {
            errors: 0,
            success: 0
        };
        
        for (var category in assessment) {
            var val = assessment[category];
            
            for (var title in val) {
                
        		var lineitem = val[title];
                var actualSize = lineitem.actual_size;
                
                if (actualSize == null || actualSize == "") {
                    result.errors++;
                } else {
                    result.success++;
                }
            }
        }
        
        return result;
    },
    saveAssessment : function (component, lineitem, year, period, isDraft){
    	component.set("v.openConfirmationBox", false);
        var action = component.get("c.saveAssessment");        
    	var recordId = component.get("v.recordId");
  		var title = lineitem.title;
        var actualSize = lineitem.actual_size;
        var requiredSize = lineitem.required_size;
        var deficit = lineitem.deficit_size;
        var isDraft = false;
        var ratings = lineitem.rating;
        var remarks = lineitem.remarks;
        var category = lineitem.category;
        var type = lineitem.type;
        
        console.log({            
            recordId: recordId,
            title: title,
            actualSize: actualSize,
            requiredSize: requiredSize,
            deficit: deficit,
           	ratings: ratings,
            isDraft: isDraft,
            remarks: remarks,
            period: period,
            year: year,
            category: category,
            type: type
        });
        
        action.setParams({            
            recordId: recordId,
            title: title,
            actualSize: actualSize,
            requiredSize: requiredSize,
            deficit: deficit,
           	ratings: ratings,
            remarks: remarks,
            isDraft : isDraft,
            period: period,
            year: year,
            category: category,
            type: type

        });
        
        action.setCallback(this, function(response){
             var state = response.getState();
            
            if (state === "SUCCESS") {                                
                console.log("Save Record");
              	console.log(response.getReturnValue());          
            
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));        
            }
            
        });
        
        $A.enqueueAction(action);
    
	},
    
    helperSaveDraft : function (component, lineitem, year, period, isDraft){
          
        var action = component.get("c.saveDraftData");        
    	var recordId = component.get("v.recordId");
  		var title = lineitem.title;
        var actualSize = lineitem.actual_size;
        var requiredSize = lineitem.required_size;
        var deficit = lineitem.deficit_size;
        var ratings = lineitem.rating;
        var remarks = lineitem.remarks;
        var category = lineitem.category;
        var type = lineitem.type;
        
        console.log({

            isDraft: isDraft,            
            recordId: recordId,
            title: title,
            actualSize: actualSize,
            requiredSize: requiredSize,
            deficit: deficit,
           	ratings: ratings,
            remarks: remarks,
            period: period,
            year: year,
            category: category,
            type: type
        });
        
        action.setParams({     
            
            isDraft: isDraft,   
            recordId: recordId,
            title: title,
            actualSize: actualSize,
            requiredSize: requiredSize,
            deficit: deficit,
           	ratings: ratings,
            remarks: remarks,
            period: period,
            year: year,
            category: category,
            type: type
			
        });
        
        action.setCallback(this, function(response){
             var state = response.getState();
            
            if (state === "SUCCESS") {             
              	console.log(response.getReturnValue());

            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));        
            }
            
        });
        
        $A.enqueueAction(action);
    
    },
    
    getRetrieveAssessment : function (component, field, isDraft){ 
    	
    	var action = component.get("c.retrieveAssessment");
        var period = component.get("v.period");
        var year = component.get("v.year");
        var recordId = component.get("v.recordId");
        
        action.setParams({ 
            type : "Warehouse Assessment",
            period: period,
            year: year,
            isDraft: isDraft,
            recordId: recordId
            
        });
        
        action.setCallback(this, function(response) {
            
        var state = response.getState();
            
        if (state === "SUCCESS") {
            
            var result = response.getReturnValue(); 
            console.log("Assessment:");
            console.log(JSON.stringify(result));
            var newResult = {};
            
            for (var i = 0; i<result.length; i++) {
                
                var val = result[i];
                var category = val.Category__c;
                var title = val.Title__c;

                if (newResult[category] == undefined) {
                    newResult[category] = {};
                }
                if (newResult[category][title] == undefined) {
                    newResult[category][title] = val;
                }            
                    
   	         }

            console.log(JSON.stringify(newResult));
            component.set("v.draftData", newResult);
            
            
         } else if (state === "ERROR") {
            console.log(response.getReturnValue());
              	
         }
                  
         });
        
        $A.enqueueAction(action);     
        
    },
    
    checkThisSemesterRecord: function (component, semester, year) {
       
        
       var action = component.get('c.checkThisSemesterRecord');
       var recordId = component.get("v.recordId");
       console.log("Semester: " + semester);
        console.log("year: " + year);
        console.log("recordId: " + recordId);
        action.setParams({
            type : "Warehouse Assessment",
            semester : semester,
            year : year,
            recordId : recordId	
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log("RESULT LENGTH: " + result.length);
                console.log(JSON.stringify(result));
                if (result.length) {
                	component.set("v.alreadyExist", true);
                    component.set("v.isSubmitted", true);
                    component.set("v.disableButton", true);                  
                    component.set("v.clearData",0);
                    component.set("v.disabledInput", true);
                    component.set("v.isdisabled", true);
                    component.set("v.isdisabled2", true);
                    component.set("v.isdisabled3", true);
                    component.set("v.disablePeriod", true);
                    component.set("v.disableYear", true);
                    component.set("v.notice", true);
                    this.getRetrieveAssessment(component, "v.draftData", false);   
				
                } else {
                    component.set("v.alreadyExist", false);
                    
                }
                
            
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    
      getSavedData : function (component, field, period, year, isDraft){ 
    	
    	var action = component.get("c.retrieveSavedAssessment");       
        var recordId = component.get("v.recordId");
          
        action.setParams({ 
            type : "Warehouse Assessment",
            period: period,
            year: year,     
            recordId: recordId,
            isDraft : isDraft

        });
        
        action.setCallback(this, function(response) {
            
        var state = response.getState();
            
        if (state === "SUCCESS") {
            
            var result = response.getReturnValue(); 
            var newSavedResult = {};
            
            for (var i = 0; i<result.length; i++) {        
                
                var val = result[i];
                var category = val.Category__c;
                var title = val.Title__c;

                if (newSavedResult[category] == undefined) {
                    newSavedResult[category] = {};
                }
                if (newSavedResult[category][title] == undefined) {
                    newSavedResult[category][title] = val;
                }            
                    
   	         }
            
            //console.log(JSON.stringify(newSavedResult));
            component.set("v.savedData", newSavedResult);
            
            
         } else if (state === "ERROR") {
            console.log(response.getReturnValue());
              	
         }
                  
         });
        
        $A.enqueueAction(action);     
        
      },
    calculateRating : function (component, sumRating) {
        //console.log(JSON.stringify(sumRating));
       var functionalAreas = 0;
       var materialHandlingEquipment = 0;
       var storageEquipment = 0;             
       var ppEquipment = 0;
       var thermometer = 0;
       var others = 0;
	   var sumActualRating1 = component.get("v.sumActualRating1")||0;
       var overallRating1 = component.get("v.overallRating1");      
	   var totalLine1 = component.get("v.totalLine1");
       var sumActualRating2 = component.get("v.sumActualRating2")||0;
       var overallRating2 = component.get("v.overallRating2");      
	   var totalLine2 = component.get("v.totalLine2");
       var sumActualRating3 = component.get("v.sumActualRating3")||0;
       var overallRating3 = component.get("v.overallRating3");      
	   var totalLine3 = component.get("v.totalLine3");
       var sumActualRating4 = component.get("v.sumActualRating4")||0;
       var overallRating4 = component.get("v.overallRating4");      
	   var totalLine4 = component.get("v.totalLine4");
       var sumActualRating5 = component.get("v.sumActualRating5")||0;
       var overallRating5 = component.get("v.overallRating5");      
	   var totalLine5 = component.get("v.totalLine5");
       var sumActualRating6 = component.get("v.sumActualRating6")||0;
       var overallRating6 = component.get("v.overallRating6");      
	   var totalLine6 = component.get("v.totalLine6");
	   var totalRequired = totalLine1 + totalLine2 + totalLine3 + totalLine4 + totalLine5 + totalLine6;
        
        for (var category in sumRating){
            for (var title in sumRating[category]){          
            if (category == "Functional Areas"){              
                	functionalAreas = parseInt(functionalAreas) + parseInt(sumRating[category][title]);               
                	component.set("v.sumActualRating1",functionalAreas);  
                	var overallRating1 = (functionalAreas/totalLine1)*100;
			        component.set("v.overallRating1",overallRating1.toFixed(0)+'%');   
                	//console.log(sumRating)
            } else if (category == "Material Handling Equipment") {
                    materialHandlingEquipment = parseInt(materialHandlingEquipment) + parseInt(sumRating[category][title]);
                    component.set("v.sumActualRating2",materialHandlingEquipment);  
                    var overallRating2 = (materialHandlingEquipment/totalLine2)*100;
                    component.set("v.overallRating2", overallRating2.toFixed(0)+'%'); 
                               
            } else if (category == "Storage Equipment"){
                storageEquipment = parseInt(storageEquipment) + parseInt(sumRating[category][title]);
                component.set("v.sumActualRating3",storageEquipment);
                var overallRating3 = (storageEquipment/totalLine3)*100;
                component.set("v.overallRating3", overallRating3.toFixed(0)+'%');                 
                
            } else if (category == "Personal Protective Equipment (PPEs)"){
                ppEquipment = parseInt(ppEquipment) + parseInt(sumRating[category][title]);
           		component.set("v.sumActualRating4",ppEquipment);
                var overallRating4 = (ppEquipment/totalLine4)*100;
                component.set("v.overallRating4", overallRating4.toFixed(0)+'%'); 
                
            } else if (category == "Thermometers"){
                thermometer = parseInt(thermometer) + parseInt(sumRating[category][title]);
             	component.set("v.sumActualRating5",thermometer);
                var overallRating5 = (thermometer/totalLine5)*100;
                component.set("v.overallRating5", overallRating5.toFixed(0)+'%'); 
                
            } else if(category == "Others"){
                others = parseInt(others) + parseInt(sumRating[category][title]);
              	component.set("v.sumActualRating6",others);
                var overallRating6 = (others/totalLine6)*100;
                component.set("v.overallRating6", overallRating6.toFixed(0)+'%'); 
				
            }
          } 
        }
        
        var totalSumActualRating = functionalAreas + materialHandlingEquipment + storageEquipment + ppEquipment + thermometer + others;		
        component.set("v.totalSumActualRating", totalSumActualRating);
        component.set("v.totalRequired",totalRequired);  
        var totalOverallRating = (totalSumActualRating/totalRequired)*100;
        component.set("v.totalOverallRating",totalOverallRating.toFixed(0)+'%');
        
        if (totalOverallRating <= 50){
            component.set("v.totalScore",1);
            
        } else if (totalOverallRating >= 51 && totalOverallRating <= 74){
            component.set("v.totalScore",2);
            
        } else if (totalOverallRating >= 75 && totalOverallRating <= 95){
            component.set("v.totalScore",3);
            
        } else if (totalOverallRating >= 96) {
            component.set("v.totalScore",4);  
        }
    }

})