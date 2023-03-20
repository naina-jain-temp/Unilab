({
	init : function(component, event, helper) {
        
		var assessmentItem = component.get("v.assessmentItem");
        var assessmentLocal = component.get("v.assessmentLocal");
        var assessmentLS = localStorage.getItem("assessmentLocal");
        var section = assessmentItem.Section__c;
        var category = assessmentItem.Category__c;
        var title = assessmentItem.Title__c;
        var line = assessmentItem.line;
        var period = component.get("v.period");
        var year = component.get("v.year");
        var assessment = component.get("v.assessmentResults");
        	
        //Check if the assessment atrribute doesn't have values, meaning undefined;
        //if undefined, set the assessment attribute to Object/Map {}
        if (assessment == undefined) {
            assessment = {};
        }
        
        //Check if the assessment.category atrribute doesn't have values, meaning undefined;
        //if undefined, set the assessment.category attribute to Object/Map {}
        //The category is a dynamic value, defined in the Warehouse Checklist record
        if (assessment[category] == undefined) {
            assessment[category] = {};
        }
        
        //set the total_rating key to be use for overall total rating per category
        if (assessment[category]["total_rating"] == undefined) {
            assessment[category]["total_rating"]  = 0;
        }
        
        //set the section inside category to define which section it belong.
        if (assessment[category]["section"] == undefined) {
            assessment[category]["section"] = section;
        }
        
        //Initialize the value
        if (assessment[category][line] == undefined) {
            assessment[category][line] = {
                "section": section,
                "category": category,
                "rating": 0,
                "rating_yes": false,
                "rating_no": false,
                "rating_na": false,
                "remarks": "",
                "title": title
            };
        
        }        
      
        //Check if the assessmentLocal doesn't exist in the local storage
        if (assessmentLS == null) {
            
            //Check if the assessmentLocal atrribute doesn't have values, meaning undefined;
            //if undefined, set the assessmentLocal attribute to Object/Map {}
            
            if(assessmentLocal == undefined) {
                assessmentLocal= {}
            }
            assessmentLocal[category] = {};
        } else {
            
            assessmentLocal = JSON.parse(assessmentLS);
        }
        
        
        
       	component.set("v.section", assessmentItem.Section__c );
        component.set("v.category", assessmentItem.Category__c);
        component.set("v.title", assessmentItem.Title__c);
        component.set("v.line", assessmentItem.line);
        component.set("v.assessmentResults",assessment);
        component.set("v.assessmentLocal", assessmentLocal);
        //console.log(JSON.stringify(assessment));
        //for testing purposes, with random number from 0 - 1
        //var rand = Math.floor(Math.random() * 2);
        //var checked = (rand == 1) ? true : false;
        //component.set("v.rating", checked);
  
	},
    setResults : function (component, event, helper) {
        
        var assessment = component.get("v.assessmentResults");

        var source = event.getSource();
        var localId = source.getLocalId();
        
        var category = component.get("v.category");
        var remarks = component.get("v.remarks");
        var line = component.get("v.line");
		
        var cmpCheck = component.find(localId);
        var checked = cmpCheck.get("v.checked")
        
        if (localId == "RatingYes" ) {
            
            component.set("v.RatingYes", checked);
            component.set("v.RatingNo", false);
            component.set("v.RatingNA", false);
            assessment[category][line]["rating_yes"] = true;

        } 
        else if (localId == "RatingNo") {
            
            component.set("v.RatingYes", false);
            component.set("v.RatingNo", checked);
            component.set("v.RatingNA", false);

            assessment[category][line]["rating_no"] = true;

            
        } 
        else if (localId == "RatingNA") {

            component.set("v.RatingYes", false);
            component.set("v.RatingNo", false);
            component.set("v.RatingNA", checked);
            assessment[category][line]["rating_na"] = true;
            
        }
		
        component.set("v.assessmentResults", assessment);
        //console.log(JSON.stringify(assessment));
    },
    setRemarks : function (component, event, helper) {
		var assessment = component.get("v.assessmentResults");
        var category = component.get("v.category");
        var line = component.get("v.line");
        var remarks = component.get("v.remarks");
        assessment[category][line]["remarks"] = remarks || "";
        component.set("v.assessmentResults", assessment);
    },
    clearChecklist: function (component, event, helper) {
        component.set("v.rating", false);
        component.set("v.remarks", "");
    }
})