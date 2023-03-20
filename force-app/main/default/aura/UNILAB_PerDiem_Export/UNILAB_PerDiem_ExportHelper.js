({
	helperMethod : function() {
		
	},
    
    loadSummaryData: function(component, event) {
    	var action = component.get("c.fetchPDSummary");
        component.set("v.showSpinner", true);
        action.setParams({
            startDate : component.get('v.startDate'),
            endDate : component.get('v.endDate'),
            overallStatus : component.get('v.overallStatusValue'),
            divisionGroup : component.get('v.divisionGroupValue')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.perDiemDataSummary", response.getReturnValue());
                component.set("v.showSpinner", false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);    
    },
    
    loadDetailsData: function(component, event) {
        /*Details*/
        
        var action = component.get("c.fetchPDDetails");
        component.set("v.showSpinner", true);
        action.setParams({
            startDate : component.get('v.startDate'),
            endDate : component.get('v.endDate'),
            overallStatus : component.get('v.overallStatusValue'),
            divisionGroup : component.get('v.divisionGroupValue')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.perDiemDataDetails", response.getReturnValue());
                component.set("v.showSpinner", false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    convertArrayOfObjectsToCSV : function(component, objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider;

        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }

        // store ,[comma] in columnDivider variable for separate CSV values and
        // for start next line use '\n' [new line] in lineDivider variable
        columnDivider = ',';
        lineDivider =  '\n';

        // in the keys valirable store fields API Names as a key
        // this labels use in CSV file header
        keys = Object.keys(objectRecords[0]); // FIXME: If the first record has empty fields, then they won't appear in header.
        console.log(keys);

        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;

        for(var i=0; i < objectRecords.length; i++){
            counter = 0;

            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;

                // add , [comma] after every String value,. [except first]
                if(counter > 0){
                    csvStringResult += columnDivider;
                }

                csvStringResult += '"'+ objectRecords[i][skey]+'"';

                counter++;

            }

            csvStringResult += lineDivider;
        }

        return csvStringResult;
    },
    
    convertArrayOfObjectsToCSV2 : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider, customHeader, currentDate;
        var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
        var todayDate = new Date();            
        currentDate = months[todayDate.getMonth()] + '_' +  todayDate.getFullYear().toString().substr(-2);
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        keys = ['Actual_Month__c', 'Employee_ID__c', 'Division__c', 'HB_OHB__c', 'Place_of_Work__c', 'ddays'];
        // this labels use in CSV file header
        customHeader = ['UPLOAD MONTH', 'MONTH(ACTUAL)', 'EMPLOYEE ID', 'DIVISION', 'HB/OHB', 'LOCATION', 'NO OF DAYS'];
        csvStringResult = '';
        csvStringResult += customHeader.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                if(counter == 0) {
                    csvStringResult += '"'+ currentDate +'"';
                }
                    csvStringResult += columnDivider;
                /*
                if(skey == 'Event_End_Date__c') {
                    var d = new Date(objectRecords[i][skey]);
                    
                    csvStringResult += '"'+ months[d.getMonth()] + '_' +  d.getFullYear() + '"'; 
                    console.log(csvStringResult);
                } else {
                    csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                }*/
                csvStringResult += '"'+ objectRecords[i][skey]+'"';
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        console.log(csvStringResult);
        // return the CSV formate String
        //component.set("v.csvStringResult", csvStringResult); 
        return csvStringResult;        
    },
    
    convertArrayOfObjectsToCSV3 : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider, customHeader, currentDate;
        var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
        var todayDate = new Date();            
        currentDate = months[todayDate.getMonth()] + '_' +  todayDate.getFullYear().toString().substr(-2);
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        keys = ['Actual_Month__c',
                	'Event_Start_Date__c',
                	'Event_End_Date__c',
                    'Employee_ID__c',	
                    'Division__c',
                    'HB_OHB__c',
                    'Place_of_Work__c',
                	'Event_Title__c',
                	'Exemption_Remarks__c',
                	'Created_By_Name__c',
               		'Overall_Status__c'];
        // this labels use in CSV file header
        customHeader = ['UPLOAD MONTH', 'MONTH(ACTUAL)', 'EVENT START DATE', 'EVENT END DATE', 'EMPLOYEE ID', 'DIVISION', 'HB/OHB', 'LOCATION', 'EVENT TITLE', 'EXEMPTION REMARKS', 'EMPLOYEE NAME', 'OVERALL STATUS'];
        csvStringResult = '';
        csvStringResult += customHeader.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                if(counter == 0) {
                    csvStringResult += '"'+ currentDate +'"';
                }
                    csvStringResult += columnDivider;
                /*
                if(skey == 'Event_End_Date__c') {
                    var d = new Date(objectRecords[i][skey]);
                    
                    csvStringResult += '"'+ months[d.getMonth()] + '_' +  d.getFullYear() + '"'; 
                    console.log(csvStringResult);
                } else {
                    csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                }*/
                csvStringResult += '"'+ objectRecords[i][skey]+'"';
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        console.log(csvStringResult);
        // return the CSV formate String
        //component.set("v.csvStringResult", csvStringResult); 
        return csvStringResult;        
    },
})