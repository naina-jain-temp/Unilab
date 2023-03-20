({
    loadPage: function(component, event, workplanDay, unplannedAcct) {
    	var latitude;
        var longitude;
        
        navigator.geolocation.getCurrentPosition(
          function (position) {
              console.log(position.coords.latitude + ', ' + position.coords.longitude);
              latitude = position.coords.latitude;
              longitude = position.coords.longitude;
              component.set("v.lat",latitude);
              component.set("v.long",longitude);
              
              this.fetchActJuncAccounts(component,event,workplanDay,unplannedAcct);
              component.set("v.enableForm",true);
          }.bind(this),
          function (e) {
            console.log(e.message);
            component.set("v.enableForm",false);
            this.showToast(component,'System Message','Please enable your device location!','info');
          }.bind(this),
          {
            enableHighAccuracy: true,
          }
        );
    },
    
    fetchActJuncAccounts: function(component, event, workplanDay, unplannedAcct) {
        var action = component.get('c.fetchActJuncAccounts');
        /*var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        
        action.setParams({
            pageSize,
            pageNumber
        });*/
        
        action.setParams({
            workplanDay,
            unplannedAcct
        });
            
       component.set("v.showSpinner",true);
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var returnResp = response.getReturnValue();  
            	
            	var returnedValue = response.getReturnValue();
                var returnedValueLength = returnedValue.length;
            	console.log(response.getReturnValue());
            	
            	if (returnedValueLength > 0) {
        			component.set("v.acctList", response.getReturnValue());
                	//component.set("v.filteredAcctList", response.getReturnValue())
            
            		var pageSize = component.get('v.pageSize');
            
            		component.set('v.totalRecords', returnedValueLength);
                    component.set('v.startPage', 0);
                    component.set('v.endPage', pageSize - 1);
            
            		var dataTableList = [];
                    
                    for (var i = 0; i < pageSize; i++) {
                        if (component.get('v.acctList').length > i) {
                            dataTableList.push(returnedValue[i]);
                        }
                    }
            		
            		component.set("v.filteredAcctList", dataTableList)
            		component.set('v.totalPages', Math.ceil(returnedValueLength / pageSize));
            		component.set("v.showSpinner",false);
            		component.set("v.bNoRecordsFound" , false);
        		}
            	else{
                    component.set("v.bNoRecordsFound" , true);
                }
            	
            
            	/*
            	if(returnResp.length < pageSize){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", returnResp.length);
                component.set("v.acctList", response.getReturnValue());
                component.set("v.filteredAcctList", response.getReturnValue());*/
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
            }
        });
            
        component.set("v.showSpinner",false);
        
        $A.enqueueAction(action);
    },
            
    nextPage : function(component, event, listOfRecord, end, start, pageSize) {
        
        var dataTableList = [];
        var counter = 0;
        
        for (var i = end + 1; i < end + pageSize + 1; i++) {
            
            if (listOfRecord.length > i) {
                dataTableList.push(listOfRecord[i]);
            }
            
            counter++;
            
        }
        
        start = start + counter;
        end = end + counter;
        
        component.set('v.startPage', start);
        component.set('v.endPage', end);
        component.set('v.filteredAcctList', dataTableList);
        
    },
    
    previousPage : function(component, event, listOfRecord, end, start, pageSize) {
        
        var dataTableList = [];
        var counter = 0;
        
        for (var i = start - pageSize; i < start; i++) {
            
            if (i > -1) {
                
                dataTableList.push(listOfRecord[i]);
                counter++;
                
            }
            
            else {
                
                start++;
                
            }
            
        }
        
        start = start - counter;
        end = end - counter;
        
        component.set('v.startPage', start);
        component.set('v.endPage', end);
        component.set('v.filteredAcctList', dataTableList);
        
    },
    
   	displayUpdatedListOfRecords : function(component, results) {
        
        var updatedListOfRecords = component.get('v.updatedListOfRecords');
        
        if (results.length > 0) {
            
            component.set('v.noRecordsFound', false);
            
            var pageSize = component.get('v.pageSize');
            
            component.set('v.totalRecords', results.length);
            component.set('v.startPage', 0);
            component.set('v.endPage', pageSize - 1);
            
            var dataTableList = [];
            
            for (var i = 0; i < pageSize; i++) {
                if (updatedListOfRecords.length > i) {
                    dataTableList.push(results[i]);
                }
            }
            
            component.set('v.pageSize', pageSize);
            component.set('v.filteredAcctList', dataTableList);
            component.set('v.totalPages', Math.ceil(results.length / pageSize));
            component.set('v.currentPage', 1);
            
        }
        
    },
    /*
	sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.records");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.records", records);
    },
    */
    insertEventCallLog: function(component, latitude, longitude) {
        var branchId = component.get('v.branchId'); 
        var action = component.get('c.insertCallEventLog');
        
        action.setParams({
            branchId,
            latitude,
            longitude
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //alert("Success Logging!");
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
            }
        });
        
        $A.enqueueAction(action);
    },
    
    insertEventRecord: function(component,event){
        var branchId = component.get('v.branchId'); 
        //alert(recordId);
        var action = component.get("c.insertCallEvent");
        
        action.setParams({
            branchId: branchId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //resp = response.getReturnValue();
                //alert(response.getReturnValue().substring(0, 18));
                var branchId=response.getReturnValue().substring(0, 18);
                var eventId=response.getReturnValue().substring(19, 37);
                var actJunctionId=response.getReturnValue().substring(39, 57);
                
                this.updateUserLogged(component,branchId,eventId,actJunctionId);
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
            	//alert(errors);
            }
        });
        
        $A.enqueueAction(action);
    },
            
    updateUserLogged: function(component,branchId,eventId,activityJunctionId){
        
        var action = component.get("c.updateUserLogged");
        
        action.setParams({
            branchId,
            eventId,
            activityJunctionId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
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
            	alert(errors);
            }
        });
        
        $A.enqueueAction(action);
    },
            
   endCallDraftEvent: function(component){
        
        var action = component.get("c.endCallDraftEvent");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
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
            	alert(errors);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    navigateAccount: function(component,event){
        var abId=component.get('v.branchId');
        component.find("navigation")
        .navigate({
            "type" : "standard__recordPage",
            "attributes": {
                "recordId"      : abId,
                "actionName"    : "view"   //clone, edit, view
            }
        }, true);
    },
    
    showToast : function(component, title, message, type) {
        component.find('notifLib').showToast({
            "title": title,
            "message": message,
            "variant": type,
            "mode": "sticky"
        });
    }, 
})