({
	doInit : function(component, event, helper) {
		component.set('v.columns', [
            {label: 'Assigned To', fieldName: 'OwnerName', type: 'text'},
            {label: 'Start Date', fieldName: 'StartDateTime', type: 'date'},
            {label: 'End Date', fieldName: 'EndDate', type: 'date'},
            {label: 'Event Type', fieldName: 'Event_Type__c', type: 'text'},
            {label: 'Event Sub-type', fieldName: 'Event_Sub_type__c', type: 'text'},
            {label: 'Mode of Contact', fieldName: 'Mode_of_Contact__c', type: 'text'},
            {label: 'Status', fieldName: 'Status__c', type: 'text'},
            {label: 'Location Based', fieldName: 'Location_Based__c', type: 'text'},
            {label: 'Location', fieldName: 'Location_Custom__c', type: 'text'},
            {label: 'Related To Account', fieldName: 'Related_To_AccountName', type: 'text'}
        ]);
               
        helper.fetchExistData(component);
	}
})