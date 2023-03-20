({
	doInit : function(component, event, helper) {
		component.set('v.isSummarycolumns', [
            {label: 'Customer Team', fieldName: 'CT_Customer_Team_Name__c', type: 'text'},
            {label: 'IS Qty', fieldName: 'sum_is_qty', type: 'number'},
            {label: 'Nominated', fieldName: 'sum_branch_target', type: 'number'},
            {label: 'Status', fieldName: 'IS_Status__c', type: 'text'}
        ]);
        
        helper.fetchISSummaryData(component,event);
	}
})