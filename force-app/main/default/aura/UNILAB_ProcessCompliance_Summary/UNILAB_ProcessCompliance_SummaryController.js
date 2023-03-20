({
	executeSummary : function(component, event, helper) {
		
      var assessmentSummary = component.get("v.assessmentSummary");
          //console.log(JSON.stringify(assessmentSummary));
        
      var summary = component.get("v.summary");
		  console.log(JSON.stringify(summary));			
    
        
        //Set the total score and rating to 0, to prevent the adding issue.
        	summary.total.score = 0;
       		summary.total.rating = 0;  	
        
        for (var section in assessmentSummary) {
            console.log(section);
            console.log(JSON.stringify(summary[section]));
            var val = assessmentSummary[section];
            var itemcount = parseInt(summary[section].itemcount);
            var score = parseInt(val.score);
            var rating = Math.round((score/itemcount)  * 100); 
			
            var tscore = parseInt(summary.total.score);
            var trating = parseInt(summary.total.rating);
       		 
            tscore += parseInt(score);
            trating += parseInt(rating);
            
            summary.total.score = tscore;
       		summary.total.rating = trating;
            summary[section].score = score;
            summary[section].rating = rating;
       
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
        //console.log(JSON.stringify(summary));
       	component.set("v.ordermanagement", summary.ordermanagement);
        component.set("v.inventorymanagement", summary.im);
        component.set("v.accountsreceivable", summary.ar);
        component.set("v.formsanddocuments", summary.formsanddocuments);
        component.set("v.total", summary.total);
        
	}
})