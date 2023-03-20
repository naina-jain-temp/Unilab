({
	listOfAlphabet : function(component) {
        
        var letters = [];
        
        letters.push("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
                     "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", 
                     "All");
        
        component.set("v.listOfAlphabet", letters);
        component.set("v.listOfAlphabetWithProduct", letters);
		
	},
    
    defaultDateToday : function(component) {
        
        var todayDate = new Date().toISOString().slice(0, 10);
        
        component.set('v.recordDate', todayDate);
        
    },
    /*
    getInitProducts : function(component, event, helper) {
        component.set("v.showSpinner", true);
        
        var action = component.get('c.getProducts');
        
        action.setParams({
            recordID : component.get('v.recordId'),
            acctID : '0019D000008kRjfQAE'
            //acctID: '0019D000008UTbYQAW'
        });
        
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS")  {
                
                var returnedValue = response.getReturnValue();
                var returnedValueLength = returnedValue.length;
                
                if (returnedValueLength > 0) {
                    
                    this.defaultDateToday(component);
                    
                    component.set('v.noRecordsFound', false);
                    component.set('v.defaultData', returnedValue);
                    
                    //this.loadProducts(component);
                    
                    
                    var pageSize = component.get('v.pageSize');
                    
                    component.set('v.totalRecords', returnedValueLength);
                    component.set('v.startPage', 0);
                    component.set('v.endPage', pageSize - 1);
                    
                    var dataTableList = [];
                    
                    for (var i = 0; i < pageSize; i++) {
                        if (component.get('v.defaultData').length > i) {
                            dataTableList.push(returnedValue[i]);
                        }
                    }
                    
                    component.set('v.dataTableList', dataTableList);                    
                    component.set('v.selectedCount', component.get('v.selectedProductsList').length);
                    component.set('v.totalPages', Math.ceil(returnedValueLength / pageSize));
                    component.set('v.showSpinner', false);
                    component.set('v.recordLoaded', false);
                    
                }
                
                else {
                    
                    component.set("v.noRecordsFound" , true);
                    component.set("v.showSpinner", false);
                    component.set('v.recordLoaded', false);
                    
                }
                
                
            }
            
            else {
                
                var errors = response.getError();
                
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    
                    this.showToastDisplay({
                        "title" : "Something went wrong",
                        "message" : errors[0].message,
                        "type" : "error"
                    });
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    */
    getProducts : function(component, event, helper) {
        
        component.set("v.showSpinner", true);
        
        var action = component.get('c.getProducts');
        var selectedFilterSet=  component.find("filterSet").get("v.value");
        
        action.setParams({
            recordID : component.get('v.recordId'),
            acctID : component.get('v.selectedAccount').Id,
            filterSet: selectedFilterSet
        });
        
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS")  {
                
                var returnedValue = response.getReturnValue();
                var returnedValueLength = returnedValue.length;
                
                if (returnedValueLength > 0) {
                    
                    this.defaultDateToday(component);
                    
                    component.set('v.noRecordsFound', false);
                    component.set('v.defaultData', returnedValue);
                    
                    //this.loadProducts(component);
                    this.loadCustomProducts(component);
                    
                    
                    var pageSize = component.get('v.pageSize');
                    
                    component.set('v.totalRecords', returnedValueLength);
                    component.set('v.startPage', 0);
                    component.set('v.endPage', pageSize - 1);
                    
                    var dataTableList = [];
                    
                    for (var i = 0; i < pageSize; i++) {
                        if (component.get('v.defaultData').length > i) {
                            dataTableList.push(returnedValue[i]);
                        }
                    }
                    
                    component.set('v.dataTableList', dataTableList);                    
                    component.set('v.selectedCount', component.get('v.selectedProductsList').length);
                    component.set('v.totalPages', Math.ceil(returnedValueLength / pageSize));
                    component.set('v.showSpinner', false);
                    component.set('v.recordLoaded', false);
                    
                }
                
                else {
                    
                    component.set("v.noRecordsFound" , true);
                    component.set("v.showSpinner", false);
                    component.set('v.recordLoaded', false);
                    
                }
                
                
            }
            
            else {
                
                var errors = response.getError();
                
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    
                    this.showToastDisplay({
                        "title" : "Something went wrong",
                        "message" : errors[0].message,
                        "type" : "error"
                    });
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
        
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
            component.set('v.dataTableList', dataTableList);
            component.set('v.totalPages', Math.ceil(results.length / pageSize));
            component.set('v.currentPage', 1);
            
        }
        
        else {
            
            component.set('v.noRecordsFound', true);
            
        }
        
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
        component.set('v.dataTableList', dataTableList);
        
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
        component.set('v.dataTableList', dataTableList);
        
    },
    
    saveRecord : function(component, event, helper, buttonName) {
        
        var recordParameters = {
            
            recordID : component.get('v.recordId'),
            accountID : component.get('v.selectedAccount').Id,
            productIDList : component.get('v.selectedProductsIDList'),
            productRemarkList: component.get('v.pickListProductRemark'),
            productComment: component.get('v.inputProductComment'),
            buttonName : buttonName,
            recordDate : component.get('v.recordDate')
            
        };
        
        var action = component.get('c.submitRecord');
        
        action.setParams({
            
            recordParameters : JSON.stringify(recordParameters)
            
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var recordID = response.getReturnValue();
                
                if (recordID != null) {
                    
                    if ($A.get("$Browser.formFactor") == 'DESKTOP') {
                        window.location = '/' + recordID;
                    }
                    
                    else {
                        
                        var event = $A.get('e.force:navigateToSObject');
                        
                        event.setParams({
                            'recordId' : recordID,
                            'slideDevName' : 'Detail'
                        }).fire();
                        
                    }
                    
                }
                
            }
            
            else {
                
                var errors = response.getError();
                
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    
                    this.showToastDisplay({
                        "title" : "Something went wrong",
                        "message" : errors[0].message,
                        "type" : "error"
                    });
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    loadProducts : function(component) {
        
        var data = component.get('v.defaultData');
        var term = "true";
        var results = data;
        var regex;
        
        var selectedProductsIDList = [];
        var selectedProductsList = [];
        
        regex = new RegExp(term, "i");
        results = data.filter(row=>regex.test(row.isChecked));
        
        for (var i = 0; i < results.length; i++) {
            
            selectedProductsIDList.push(
                results[i].prod2.Id
            );
            
            selectedProductsList.push(
                results[i]
            );
            
        }
        
        component.set('v.selectedCount', selectedProductsList.length);
        component.set('v.selectedProductsIDList', selectedProductsIDList);
        component.set('v.selectedProductsList', selectedProductsList);
        //component.set('v.selectedAccount',  component.get('v.selectedAccount').Id);
        
    },
    
    loadCustomProducts : function(component) {
        
        var data = component.get('v.defaultData');
        var term = "true";
        var results = data;
        var regex;
        
        var selectedProductsIDList = [];
        var selectedProductsList = [];
        
        regex = new RegExp(term, "i");
        //results = data.filter(row=>regex.test(row.isChecked));
        
        for (var i = 0; i < results.length; i++) {
            
            selectedProductsIDList.push(
                results[i].prod2.Id
            );
            
            selectedProductsList.push(
                results[i]
            );
            
        }
        
        component.set('v.selectedCount', selectedProductsList.length);
        component.set('v.selectedProductsIDList', selectedProductsIDList);
        component.set('v.selectedProductsList', selectedProductsList);
        //component.set('v.selectedAccount',  component.get('v.selectedAccount').Id);
        
    },
    
    getSubActivityReportDetails : function(component) {
        
        var action = component.get('c.getSubActivityReportDetails');
        
        action.setParams({
            recordID : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var returnedValue = response.getReturnValue();
                
                component.set('v.selectedAccount', returnedValue.acctRec);
                component.find('nameLookup').showValue();
                component.set('v.recordDate', returnedValue.recordDate);
                component.set('v.recordStatus', returnedValue.status);
                
            }
            
            else {
                
                var errors = response.getError();
                
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    
                    this.showToastDisplay({
                        "title" : "Something went wrong",
                        "message" : errors[0].message,
                        "type" : "error"
                    });
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    showToastDisplay : function(alertMessage) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            
            "title": alertMessage.title,
            "message": alertMessage.message,
            "type": alertMessage.type            
            
        });
        
        toastEvent.fire();
        
    }    
    
})