({
	fetchProductData : function(component) {
		var action = component.get("c.fetchProducts");
        var recordID = component.get("v.recordId");
        /*
        action.setParams({
            recordID
        });
        */
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var returnResp = response.getReturnValue();
                if(returnResp.length > 0) {
            		component.set("v.productData", response.getReturnValue());
                }else {
                    console.log("No data found!.");
                }
            } else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log("ERROR MESSAGE: " +
                                   errors[0].message);
                    }
                } else {
                    console.log("Unknown Error");
                }
            }
        });
        
        $A.enqueueAction(action);
	},
    
    convertArrayOfObjectsToCsv2 : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider, customHeader, currentDate;
        //var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
        //var todayDate = new Date();            
        //currentDate = months[todayDate.getMonth()] + '_' +  todayDate.getFullYear().toString().substr(-2);
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        keys = [0,'ProductCode', 'Name', 'StockKeepingUnit','Brand_Name__c','Family','Generic_Name__c'];
        // this labels use in CSV file header
        customHeader = ['Product Code','Product Name', 'Barcode', 'Brand', 'Product Family', 'Generic Name'];
        csvStringResult = '';
        csvStringResult += customHeader.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                //if(counter == 0) {
                //    csvStringResult += '"'+ currentDate +'"';
                //}
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
    convertArrayOfObjectsToCsv : function(component, objectRecords){
        var csvStringResult, counter, keys, customHeader, columnDivider, lineDivider;

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
        //keys = Object.keys(objectRecords[0]); // FIXME: If the first record has empty fields, then they won't appear in header.
        keys = ['ProductCode', 'Name', 'StockKeepingUnit','Brand_Name__c','Family','Generic_Name__c'];
      	console.log(keys);
		
        customHeader = ['Product Code','Product Name', 'Barcode', 'Brand', 'Product Family', 'Generic Name'];
        csvStringResult = '';
        //csvStringResult += keys.join(columnDivider);
        csvStringResult += customHeader.join(columnDivider);
        csvStringResult += lineDivider;

        for(var i=0; i < objectRecords.length; i++){
            counter = 0;

            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;

                // add , [comma] after every String value,. [except first]
                if(counter > 0){
                    csvStringResult += columnDivider;
                }
				
                //csvStringResult += '"'+ objectRecords[i][skey]+'"';
				// If the column is undefined, leave it as blank in the CSV file.
                var value = objectRecords[i][skey] === undefined ? '' : objectRecords[i][skey];
                csvStringResult += '"'+ value +'"';
                counter++;

            }

            csvStringResult += lineDivider;
        }

        return csvStringResult;
    },
})