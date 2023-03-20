({
	 updateSummaryStatus : function (component, summary, auraid, fldstatus) {
        
        if (auraid == "" || auraid == null) return;
        
        var fldcmp = component.find(auraid);
        
        if (summary["deficit"] >= 0) {
            if (!$A.util.hasClass(fldcmp, "manpower-summary-miss")) {
                
                $A.util.removeClass(fldcmp, "manpower-summary-miss"); 
                $A.util.addClass(fldcmp, "manpower-summary-hit");                           
                component.set(fldstatus, "Hit");
                
            }
        } else {
            if (!$A.util.hasClass(fldcmp, "manpower-summary-miss")) {
                
                $A.util.removeClass(fldcmp, "manpower-summary-hit");
                $A.util.addClass(fldcmp, "manpower-summary-miss");
                component.set(fldstatus, "Miss");    
                
            }
        }
    }
})