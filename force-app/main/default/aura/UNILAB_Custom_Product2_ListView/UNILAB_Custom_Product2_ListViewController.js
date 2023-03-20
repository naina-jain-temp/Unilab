({
	doInit : function(component, event, helper) {
		/*component.set('v.productDataColumns', [
            {label: 'Product Code', fieldName: 'ProductCode', type: 'text', initialWidth: 100},
            {label: 'Product Name', fieldName: 'Name', type: 'text', initialWidth: 300},
            {label: 'Product Barcode', fieldName: 'StockKeepingUnit', type: 'text', initialWidth: 300},
            {label: 'Brand', fieldName: 'Brand_Name__c', type: 'text', initialWidth: 150},
            {label: 'Product Family', fieldName: 'Family', type: 'text', initialWidth: 150},
            {label: 'Generic Description', fieldName: 'Generic_Name__c', type: 'text', initialWidth: 300}
        ]);*/
		helper.fetchProductData(component);
        
	},
    downloadCsv : function(component, event, helper) {
    	//get today's date
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + dd + mm;
        
        // get the Records Product2 list 
        var prod2Data = component.get("v.productData");
	        
        // call the helper function which "return" the CSV data as a String
        var csv = helper.convertArrayOfObjectsToCsv(component, prod2Data);
        if (csv == null){return;}
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //
        hiddenElement.download = 'UNILAB Brandbank Product List ' + today + '.csv';  // CSV file Name* you can change it.[only name not .csv]
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
})