({
	clearAll: function(component, event) {
   
    },
    
    loadECLAccount: function(component,event){
        
        var branchId=component.get('v.recordId');

        var action = component.get("c.fetchUserLoggedAcctEvent");
        
        action.setParams({
            branchId: branchId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var eventId = response.getReturnValue();
                //alert(dataCount);
                if (eventId === 'NONE'){
                    component.set('v.enableForm',false);
                }
                else{
                    component.set('v.enableForm2',true);
                    component.set('v.eventId',eventId);
                    
                    this.loadDataCount(component,event,eventId);
                    this.loadCategory(component,event);
                    this.loadRESTagging(component,event);
                    this.loadAcctGroup(component,event);
                    this.populateTCBSubActivity(component,event,eventId);
                    
                    this.loadTAFT(component,event);
                    this.loadPrevJournal(component);
                }
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
        
        /*
    	var branchId=component.get('v.recordId');

        var action = component.get("c.fetchECL");
        
        action.setParams({
            branchId: branchId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var eclAccount = response.getReturnValue();
               	//alert(eclAccount);
                if (eclAccount === branchId){
                    component.set('v.enableForm2',true);
                    
                    this.loadDataCount(component,event);
                    this.loadCategory(component,event);
                    this.loadRESTagging(component,event);
                    this.loadAcctGroup(component,event);
                    
                    this.loadTAFT(component,event);
                    this.loadPrevJournal(component);
                }
                else{
                    component.set('v.enableForm',false);
                }
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
        
        $A.enqueueAction(action);    */
    },
    
    loadDataCount: function(component, event, eventId){
      var recordId = component.get('v.recordId');
        var action = component.get("c.fetchTCBActivityCount");
        
        action.setParams({
            recordId,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.dataCount", response.getReturnValue());
            	//alert(response.getReturnValue());
				/*var dataCount = response.getReturnValue();
                if (dataCount === 0){
                    helper.populateInitialRentals(component,event);
                }
                else{
                	helper.populateCriteria(component,event);
                }*/
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
            
   loadCategory: function(component, event){
   		/*Category*/
        
		var action = component.get("c.fetchAcctCategory");
        
        action.setParams({
            recordId : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.categoryList", response.getReturnValue());
                /*
               	var catMap = response.getReturnValue();
                var catTag = response.getReturnValue().Category__c;
                var cat = [];
                if(catMap.length > 0){
                   for (var i = 0;i < catMap.length;i++) {
                       cat.push({value: catMap[i].Category__c,label: catMap[i].Category__c});
                   }
                                                   
                }            
                component.set("v.categoryList", cat);*/
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
            
   loadRESTagging: function(component, event){
       /*RES Tagging*/
        
        var action = component.get("c.fetchRES");
        
        action.setParams({
            recordId: component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.acctRES", response.getReturnValue());
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
   
   loadAcctGroup: function(component, event){
       /*Acct Group Tagging*/
        
        var action = component.get("c.fetchAcctGroup");
        
        action.setParams({
            recordId: component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.acctGroup", response.getReturnValue());
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
            
   loadTAFT: function(component, event) {
    	/*Trade Activity Feedback*/
        
        /*
        component.set('v.taftColumns', [
            {label: 'Activity', fieldName: 'Activity_Title__c', type: 'text'}
            
        ]);*/
        
        var action = component.get('c.fetchTAFT');
        var recordId = component.get('v.recordId');
        
        action.setParams({
            recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.taftData", response.getReturnValue());
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
            
    populateTCBSubActivity: function(component,event,eventId) {
    
        var action = component.get("c.populateTCBSubActivity");
        
        action.setParams({
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //component.set("v.data", response.getReturnValue());
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
    
    populateInitialVisibility: function(component,event,eventId) {
        var recordID = component.get('v.recordId');
        var res = component.get('v.acctRES');
        var action = component.get("c.populateInitialTCBVisibility");
        
        action.setParams({
            recordID,
            res,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //component.set("v.data", response.getReturnValue());
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
            
  	populateInitialAssortment: function(component,event,eventId) {
        var recordID = component.get('v.recordId');
        var action = component.get("c.populateInitialTCBAssortment");
        
        action.setParams({
            recordID,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //component.set("v.data", response.getReturnValue());
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
    
    populateInitialTOPPriorities: function(component,event,eventId) {
        var recordID = component.get('v.recordId');
        var acctGroup = component.get('v.acctGroup');
        var action = component.get("c.populateInitialTCBTOPPriorities");
        
        action.setParams({
            recordID,
            acctGroup,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //component.set("v.data", response.getReturnValue());
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
            
    loadVisibility: function(component, event, eventId) {
    	/*Visibility*/
        
        var action = component.get('c.fetchVisibilityData');
        //var acctRES = component.get("v.acctRES");
        var recordID = component.get('v.recordId');
        var cat = component.get("v.categorySelValue");
        
        action.setParams({
            //res : acctRES,
            recordID,
            cat,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.visibData", response.getReturnValue());
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
    
    /*
	loadAssortment: function(component, event) {    	
        
        var action = component.get('c.fetchAssortmentData');
        var recordID = component.get("v.recordId");
        var cat = component.get("v.categorySelValue");
        
        action.setParams({
            recordID,
            cat
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.assortData", response.getReturnValue());
                component.set("v.filteredAssortData", response.getReturnValue());
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
    },*/
            
    loadAssort: function(component, event, eventId) {
    	/*TOP Priorities*/
        
        var action = component.get('c.fetchAssortData');
        var recordID = component.get("v.recordId");
        var cat = component.get("v.categorySelValue");
        /*var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();*/
        
        action.setParams({
            recordID,
            cat,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var returnResp = response.getReturnValue();   
            
            	var returnedValue = response.getReturnValue();
                var returnedValueLength = returnedValue.length;
            	console.log(response.getReturnValue());
            
            	if (returnedValueLength > 0) {
        			component.set("v.assortData", response.getReturnValue());
                	//component.set("v.filteredAcctList", response.getReturnValue())
            
            		var pageSize = component.get('v.pageSize');
            
            		component.set('v.totalRecords', returnedValueLength);
                    component.set('v.startPage', 0);
                    component.set('v.endPage', pageSize - 1);
            
            		var dataTableList = [];
                    
                    for (var i = 0; i < pageSize; i++) {
                        if (component.get('v.assortData').length > i) {
                            dataTableList.push(returnedValue[i]);
                        }
                    }
            		
            		component.set("v.filteredAssortData", dataTableList)
            		component.set('v.totalPages', Math.ceil(returnedValueLength / pageSize));
        		}
            	
            	/*
            	if(returnResp.length < pageSize){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", returnResp.length);
            	component.set("v.assortData", response.getReturnValue());
              	component.set("v.filteredAssortData", response.getReturnValue());*/
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
        component.set('v.filteredAssortData', dataTableList);
        
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
        component.set('v.filteredAssortData', dataTableList);
        
    },
    
   	displayUpdatedListOfRecords : function(component, results) {
        
        var updatedListOfRecords = component.get('v.updatedListOfRecords');
        //this.saveAssortment(component);
        
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
            component.set('v.filteredAssortData', dataTableList);
            component.set('v.totalPages', Math.ceil(results.length / pageSize));
            component.set('v.currentPage', 1);
            
        }
        
    },
            
    loadTOPPriorities: function(component, event, eventId) {
    	/*TOP Priorities*/
        
        var action = component.get('c.fetchTOPPrioritiesData');
        var recordID = component.get("v.recordId");
        var cat = component.get("v.categorySelValue");
        
        action.setParams({
            recordID,
            cat,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.topData", response.getReturnValue());
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
    /*
    loadPreviousLearningsAndInsights : function(component,activityName) {
		var action = component.get('c.fetchPreviousLearningsAndInsights');
        var recordId = component.get('v.recordId');
        
        action.setParams({
            recordId,
            activityName
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.previousLearningsAndInsights", response.getReturnValue());
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
    */   
    loadPrevJournal : function(component) {
		var action = component.get('c.fetchPrevJournal');
        var recordId = component.get('v.recordId');
        var cat = component.get("v.categorySelValue"); 
        
        action.setParams({
            recordId,
            cat
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.prevJournal", response.getReturnValue());
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
            
    saveAssortment: function(component) {
        var priorityData = component.get("v.assortPriorityData");
        var recordID = component.get('v.recordId');
        //var rType = "Assortment";
        
        var action = component.get('c.updateForm');
        
        action.setParams({
            priorityData, 
            recordID
            //rType
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.assortPriorityData", "");
                //component.set("v.disableBtn", true);
                //$A.get('e.force:refreshView').fire();
                //alert('Successfully Saved');   
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
    
    saveTOPP: function(component) {
        var priorityData = component.get("v.topPriorityData");
        var recordID = component.get('v.recordId');
        //var rType = "TOP Priorities";
        
        var action = component.get('c.updateForm');
        
        action.setParams({
            priorityData, 
            recordID
            //rType
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.topPriorityData", "");
                //component.set("v.disableBtn", true);
                //$A.get('e.force:refreshView').fire();
                //alert('Successfully Saved');   
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
            
    saveVisib: function(component) {
        var priorityData = component.get("v.visibPriorityData");
        var recordID = component.get('v.recordId');
        //var rType = "Visibility";
        
        var action = component.get('c.updateForm');
        
        action.setParams({
            priorityData, 
            recordID
            //rType
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.topPriorityData", "");
                //component.set("v.disableBtn", true);
                //$A.get('e.force:refreshView').fire();
                //alert('Successfully Saved');   
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
            
    saveJournal : function(component,journal,eventId) {
		
        var action = component.get('c.saveJournal');
        var recordId = component.get('v.recordId');
        var cat = component.get("v.categorySelValue");  
        
        action.setParams({
            recordId,
            cat,
            journal,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
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
            }
        });
        
        $A.enqueueAction(action);
    },
            
    saveFiles : function(component,eventId) {
		
        var action = component.get('c.saveFiles');
        var recordId = component.get('v.recordId');
        var cat = component.get("v.categorySelValue");  
        
        action.setParams({
            recordId,
            cat,
            eventId
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
            	//alert(errors);
            }
        });
        
        $A.enqueueAction(action);
    },
    /*
 	saveLearningsAndInsights : function(component,activityName,learningAndInsights) {
		var action = component.get('c.updateLearningsAndInsights');
        var recordId = component.get('v.recordId');
        
        action.setParams({
            recordId,
            activityName,
            learningAndInsights
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
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
            }
        });
        
        $A.enqueueAction(action);
	},*/
})