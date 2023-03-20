({    
    init: function(component, event, helper) {
        
        var data = component.get("v.objectData");
    	var assessment = component.get("v.assessment");
        var category = data.Category__c;
        var title = data.Title__c;
        var type = data.Type__c;
        var rSize = data.Required_Size__c;
        
        if (assessment == undefined) {
            assessment = {};
        }
        
        if (assessment[category] == undefined) {
            assessment[category] = {};
        }
        
        if (assessment[category][title] == undefined) {
            assessment[category][title] = {
                "type": type,
                "category": category,
                "title": title,                
                "required_size": rSize,
                "actual_size": null,
                "deficit_size": 0,
                "rating": 0,
                "remarks": ""
            };
        }
        
        component.set("v.assessment", assessment);
        console.log(JSON.stringify(assessment));
	},
    calculate : function(component, event, helper) {
		
        var assessment = component.get("v.assessment");
        var aQty = component.get("v.actualSize");        
        var rQty = parseInt(component.get("v.requiredSize"));          		       
        var category = component.get("v.category");
        var title = component.get("v.title");
        var remarks = component.get("v.remarks");
        var deficit = aQty - rQty;
		var sumRating = component.get("v.sumRating");   
  		 
        component.set("v.deficit", deficit.toFixed(0));   	 
       	    
        if (sumRating == undefined) {
            sumRating = {};
        }
        if (sumRating[category] == undefined){
            sumRating[category] = {};
        }              
        if (sumRating[category][title] == undefined) {
            sumRating[category][title] = 0;
        }         
        if (category == "Functional Areas") {             
            if (title == "Bulk") {                
             //condition for Bulk (0.03)
             var bulkPercentage = rQty * (-0.03);                             
                if (deficit >= 0 || deficit >= bulkPercentage) {      
                    component.set("v.ratings", 1);             
					sumRating[category][title] = 1;
                    assessment[category][title]["rating"] = 1;
                } else {
                     component.set("v.ratings", 0);                
            		 sumRating[category][title] = 0;
                     assessment[category][title]["rating"] = 0;                    
                }                
            } else {                
                 //condition for other Functional Areas (0.1)
                 var otherAreasPercentage = rQty * (-0.1);
                if (deficit >= 0 || deficit >= otherAreasPercentage) {
                 component.set("v.ratings", 1);  
                 sumRating[category][title] = 1;
                 assessment[category][title]["rating"] = 1;
                 
                } else {
                    component.set("v.ratings", 0);
                    sumRating[category][title] = 0;
                    assessment[category][title]["rating"] = 0;
                }
            }            
        } 
        else {                
             if (deficit >= 0){                   
           		 component.set("v.ratings", 1);      
                 sumRating[category][title] = 1;
                 assessment[category][title]["rating"] = 1;
             } 
             else {                                                
                 component.set("v.ratings", 0);
                 sumRating[category][title] = 0;
                 assessment[category][title]["rating"] = 0;
             }
       	}   
        
        assessment[category][title]["deficit_size"] = deficit;
        assessment[category][title]["actual_size"] = aQty;
        
    	component.set("v.sumRating", sumRating);		
        component.set("v.assessment", assessment);
      //console.log(JSON.stringify(assessment[category]));
    },
    setRemarks: function(component, event, helper) {
        
        var assessment = component.get("v.assessment");
        var category = component.get("v.category");
        var title = component.get("v.title");
        var remarks = component.get("v.remarks");
        
        assessment[category][title]["remarks"] = remarks;
        component.set("v.assessment", assessment);
        console.log(JSON.stringify(assessment));
    },
    
    setDraft: function(component, event, helper) {
        
        var draftData = component.get("v.draftData");   
        var category = component.get("v.category");
        var title = component.get("v.title");
            
        if (draftData[category] != undefined) {
            if (draftData[category][title] != undefined) {
                
                var val = draftData[category][title];
                var actualsize = val.ActualSize__c;
                var remarks = val.Remarks__c;
                var deficit = val.Deficit__c;
                var rating = val.Rating__c;
                
                component.set("v.actualSize", actualsize);
                component.set("v.remarks", remarks);
                component.set("v.deficit", deficit);
                component.set("v.ratings", rating);
                
            
            }
        }            
        
    },
    
    clearFields : function(component, event, helper) {              	        
        
			    component.set("v.actualSize", 0);
         		component.set("v.remarks", "");
                component.set("v.deficit", 0);
                component.set("v.ratings", 0);
        		component.set("v.disabledInput", true);
      

  },
    
    setSavedData: function(component, event, helper) {
        
        var savedData = component.get("v.savedData");   
        var category = component.get("v.category");
        var title = component.get("v.title");
            
        if (savedData[category] != undefined) {
            if (savedData[category][title] != undefined) {
                
                var val = savedData[category][title];
                var actualsize = val.ActualSize__c;
                var remarks = val.Remarks__c;
                var deficit = val.Deficit__c;
                var rating = val.Rating__c;
                
                component.set("v.actualSize", actualsize);
                component.set("v.remarks", remarks);
                component.set("v.deficit", deficit);
                component.set("v.ratings", rating);
            }
        }            
        
    },

          
})