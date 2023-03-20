({
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider, customHeader, currentDate;
        var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
        var todayDate = new Date();            
        currentDate = months[todayDate.getMonth()] + '_' +  todayDate.getFullYear();
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        keys = ['CreatedDate', 'Employee_ID__c', 'Division__c', 'HB_OHB__c', 'Place_of_Work__c', 'Number_of_Days__c'];
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
                
                if(skey == 'CreatedDate') {
                    var d = new Date(objectRecords[i][skey]);
                    
                    csvStringResult += '"'+ months[d.getMonth()] + '_' +  d.getFullYear() + '"'; 
                    console.log(csvStringResult);
                } else {
                    csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                }
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        console.log(csvStringResult);
        // return the CSV formate String
        //component.set("v.csvStringResult", csvStringResult); 
        return csvStringResult;        
    },
    onLoad: function(component, event) {
        
        var action = component.get('c.fetch');
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.exportData', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})