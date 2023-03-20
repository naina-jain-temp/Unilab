({
    doInit : function(component, event, helper) {
        helper.fetchData(component);
    },
    dateFilter : function(component, event, helper) {
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
    submit : function(component, event, helper) {
       helper.onSubmit(component);
    },
    selectAllChange : function(component, event, helper) {
        helper.selectAll(component, event);
    }
})