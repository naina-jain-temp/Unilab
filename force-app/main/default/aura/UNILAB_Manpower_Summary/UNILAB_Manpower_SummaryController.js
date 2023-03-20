({
	executesummary : function(component, event, helper) {
        
        	var manpowertotal = component.get("v.manpowertotal");
            var brratings = component.get("v.brratings");
            var whratings = component.get("v.whratings");
            var fldratings = component.get("v.fldratings");
            var trratings = component.get("v.trratings");
        	var truckrating = component.get("v.truckrating") || 0;
        
        
        	manpowertotal["required"] = parseInt(brratings.required) + parseInt(whratings.required) + parseInt(fldratings.required);
            manpowertotal["actual"] = parseInt(brratings.actual) + parseInt(whratings.actual) + parseInt(fldratings.actual);
            manpowertotal["deficit"] = parseInt(brratings.deficit) + parseInt(whratings.deficit) + parseInt(fldratings.deficit);        
        	manpowertotal["rating"] = Math.floor((manpowertotal.actual / manpowertotal.required) * 100);
			        	
        
        	truckrating = Math.floor((trratings.actual / trratings.required) * 100);
           	component.set("v.manpowertotal", manpowertotal);
        	component.set("v.truckrating", truckrating);
                	
	},
})