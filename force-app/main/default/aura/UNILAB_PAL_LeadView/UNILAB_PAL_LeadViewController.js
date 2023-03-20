({
    doInit: function (component, event, helper) {
        var pageReference = component.get("v.pageReference");
        
        component.set("v.idValue", pageReference.state.c__idValue);
        //alert(component.get("v.idValue"));
        helper.checkAllocation(component, event, helper);
        
        //helper.getAccAllocHierarchy(component,event,helper);
    },
    
    handleTeamCheck : function(component, event, helper) {
        console.log('calling handleCheck');
        var isChecked = component.find("accountTeamCheckBox").get("v.checked");
        component.set("v.accountTeams", isChecked);
        console.log('isChecked',isChecked);
        helper.getAccAllocHierarchy(component,event,helper);
    },
    
    handleGroupCheck : function(component, event, helper) {
        console.log('calling handleCheck');
        var isChecked = component.find("accountGroupCheckBox").get("v.checked");
        component.set("v.accountGroups", isChecked);
        console.log('isChecked',isChecked);													   
        helper.getAccAllocHierarchy(component,event,helper);
    },
    
    navigateToRecord : function(component, event){
        
        var event = $A.get( 'e.force:navigateToSObject' );
        var recId = component.get("v.idValue");
        event.setParams({
            'recordId' : recId,
            'slideDevName' : 'Detail' ,
            'isRedirect' : true
        }).fire();     
    },
})