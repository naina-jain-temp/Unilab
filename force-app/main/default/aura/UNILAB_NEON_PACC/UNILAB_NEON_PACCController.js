({
	doInit : function(component, event, helper) {
        component.set('v.selectedTeams',[]);
        //component.set('v.teamOptions',[]);
        $A.get('e.force:refreshView').fire();
		helper.loadAcctGrpData(component, event);
	},
    
    loadAccountsHandleClick : function(component, event, helper) {
        helper.loadAcctGrpData(component, event);
    },
        
    applyToSelectedTeamsHandleClick : function(component, event, helper) {
		
        helper.loadAcctGrpData(component, event);
        console.log(component.get("v.acctGroupData"));
        /*
        var pVal = component.get('v.selPipelineDate');
        var sVal = component.get('v.selSaturationDate');
        component.set("v.selAcctPipelineDate",pVal);
        component.set("v.selAcctSaturationDate",sVal);
        */
        /*
        var selectedRcrds = component.get('v.selectedTeams');
        for(var i = 0; i < selectedRcrds.length; i++) {
            //alert(selectedRcrds[i]);
            
        }
        */
        
	},
    
    saveChangesHandleClick : function(component, event, helper) {
        helper.save(component);
        helper.navigate(component);
    },
    
})