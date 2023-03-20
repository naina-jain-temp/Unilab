({
	executeSummary : function(component, event, helper) {
		
      var assessmentSummary = component.get("v.assessmentSummary");
          console.log(JSON.stringify(assessmentSummary));
        
      var summary = component.get("v.summary");
		  console.log(JSON.stringify(summary));			
    
        //Set the total score and rating to 0, to prevent the adding issue.
        	summary.total.score = 0;
       		summary.total.rating = 0;  	
        
        var categorymap = helper.categorymap;
        
        for (var category in assessmentSummary) {
            
            var cf = categorymap[category];
            var val = assessmentSummary[category];
            var itemcount = parseInt(summary[cf].itemcount);
            var score = parseInt(val.score);
            var ratingNa = val.ratingna ||0;
            var rating = Math.round((score/itemcount)  * 100); 
			
            var tscore = parseInt(summary.total.score);
            var trating = parseInt(summary.total.rating);
       		
            tscore += parseInt(score);
            trating += parseInt(rating);
        
            summary.total.score = tscore;
       		summary.total.rating = trating;
            
            summary[cf].score = score;
            summary[cf].itemcount = parseInt(summary[cf].totalitem) - parseInt(ratingNa);
            summary[cf].rating = rating;
            
        }
      
        
       var totalScore = parseInt(summary.total.score);
       var totalItemCount = parseInt(summary.total.itemcount);
     
        
       var totalRating = Math.round((totalScore/totalItemCount)  * 100);
       var ratingScale = 1;
        
        if(totalRating >= 96){
            ratingScale = 4;
        }else if (totalRating >= 75 && totalRating <= 95) {
            ratingScale = 3;
        }else if (totalRating >= 51 && totalRating <= 74) {
            ratingScale = 2;
        }
        
        summary.total.rating = totalRating;
        summary.total.ratingscale = ratingScale;
        
        
       	
        component.set("v.total", summary.total);
        
        var newSummary = [];
        for (var c in summary ){
            if (c == "total" || c== "promomatsmanagement") continue;
         	
            newSummary.push(summary[c]);
        }
        
    
        component.set("v.promomatsmanagement", newSummary);
        //console.log(JSON.stringify(newSummary));
	}
})