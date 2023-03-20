({
	init : function(component, event, helper) {
        helper.fetchData(component);
	},
    searchProduct: function(component, event, helper) {
        helper.fetchData(component);
    },
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.fetchData(component);
    },
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.fetchData(component);
    },
    closeNotif: function(component) {
        component.set("v.successMessage", false);
    },
    saveRecord : function(component, event, helper){
        helper.save(component);
    }
})