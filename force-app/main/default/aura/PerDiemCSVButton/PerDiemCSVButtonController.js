({
	exportCSV : function(component, event, helper) {
		 var stockData = component.get("v.exportData");
        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
         if (csv == null){return;} 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	     var hiddenElement = document.createElement('a');
          hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
          hiddenElement.target = '_self'; // 
          hiddenElement.download = 'ExportData.csv';  // CSV file Name* you can change it.[only name not .csv] 
          document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  hiddenElement.click(); // using click() js function to download csv file
	},
    loadPerDiemItemList: function(component, event, helper){
       helper.onLoad(component, event);
        console.log(component.get('v.exportData'));
        component.set('v.columns', [
            {label: 'MONTH(ACTUAL)', fieldName: 'CreatedDate', type: 'text'},
            {label: 'EMPLOYEE ID', fieldName: 'Employee_ID__c', type: 'text'},
            {label: 'DIVISION', fieldName: 'Division__c', type: 'text'},
            {label: 'HB/OHB', fieldName: 'HB_OHB__c', type: 'text'},
            {label: 'LOCATION', fieldName: 'Place_of_Work__c', type: 'text'},
            {label: 'NO OF DAYS', fieldName: 'Number_of_Days__c', type: 'text'}
        ]);
    }
})