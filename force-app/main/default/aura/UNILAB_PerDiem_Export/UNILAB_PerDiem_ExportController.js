({
	init : function(component, event, helper) {
		//helper.loadSummaryData(component, event);
        //helper.loadDetailsData(component, event);
        
	},
    
    dateFilter : function(component, event, helper) {
        helper.loadSummaryData(component, event);
        helper.loadDetailsData(component, event);
    },
    
    overallStatusFilter : function(component, event, helper) {
        helper.loadSummaryData(component, event);
        helper.loadDetailsData(component, event);
    },
    
    divisionGroupFilter : function(component, event, helper) {
        helper.loadSummaryData(component, event);
        helper.loadDetailsData(component, event);
    },
    
    downloadNow : function(component, event, helper){
        //get today's date
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + dd + mm;
        
        var downloadTypeValue = component.get("v.downloadTypeValue");
        if(downloadTypeValue == "Summary"){
            // load Data
            helper.loadSummaryData(component, event);
            
            // get the Records [Per Diem Item] list from 'perDiemDataSummary' attribute
            var stockData = component.get("v.perDiemDataSummary");
            
            // call the helper function which "return" the CSV data as a String
            var csv = helper.convertArrayOfObjectsToCSV2(component, stockData);
            if (csv == null){return;}
            
            // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
            var hiddenElement = document.createElement('a');
            hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
            hiddenElement.target = '_self'; //
            hiddenElement.download = 'Per Diem Summary Report ' + today + '.csv';  // CSV file Name* you can change it.[only name not .csv]
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file
        }
        if(downloadTypeValue == "Details"){
            // load Data
            helper.loadDetailsData(component, event);
            
            // get the Records [Per Diem Item] list from 'perDiemDataDetails' attribute
            var stockData = component.get("v.perDiemDataDetails");
    
            // call the helper function which "return" the CSV data as a String
            var csv = helper.convertArrayOfObjectsToCSV3(component, stockData);
            if (csv == null){return;}
    
            // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
            var hiddenElement = document.createElement('a');
            hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
            hiddenElement.target = '_self'; //
            hiddenElement.download = 'Per Diem Details Report ' + today + '.csv';  // CSV file Name* you can change it.[only name not .csv]
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file
        }
    },
    /*
    downloadSummaryCsv : function(component, event, helper){
        
        // load Data
        helper.loadSummaryData(component, event);
        
        // get the Records [Per Diem Item] list from 'perDiemDataSummary' attribute
        var stockData = component.get("v.perDiemDataSummary");
        
        // call the helper function which "return" the CSV data as a String
        var csv = helper.convertArrayOfObjectsToCSV2(component, stockData);
        if (csv == null){return;}
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //
        hiddenElement.download = 'Per Diem Summary Report.csv';  // CSV file Name* you can change it.[only name not .csv]
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        
    },
    
    downloadDetailsCsv : function(component, event, helper){
        
        // load Data
        helper.loadDetailsData(component, event);
        
        // get the Records [Per Diem Item] list from 'perDiemDataDetails' attribute
        var stockData = component.get("v.perDiemDataDetails");

        // call the helper function which "return" the CSV data as a String
        var csv = helper.convertArrayOfObjectsToCSV3(component, stockData);
        if (csv == null){return;}

        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //
        hiddenElement.download = 'Per Diem Details Report.csv';  // CSV file Name* you can change it.[only name not .csv]
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },*/
})