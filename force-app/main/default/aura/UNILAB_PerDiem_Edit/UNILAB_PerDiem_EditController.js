({
	doInit : function(component, event, helper) {
        helper.checkIsEditable(component);
		helper.fetchExistData(component);
        helper.fetchData(component);
	},
    dateFilter : function(component, event, helper) {
        helper.fetchData(component);
    },
    update : function(component, event, helper) {
       helper.onUpdate(component);
    },
    selectAllExistChange : function(component, event, helper) {
        helper.selectAllExist(component, event);
    },
    selectAllChange : function(component, event, helper) {
        helper.selectAll(component, event);
    }
})