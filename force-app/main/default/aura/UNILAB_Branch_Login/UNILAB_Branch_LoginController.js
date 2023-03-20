({
	doInit: function(component, event, helper) {
       	helper.loadPage(component,event,'0','0');
        
        /*
        if(navigator.geolocation){
            navigator.geolocation.getCurrentPosition(function(e) {
                console.log(e.coords.latitude + ', ' + e.coords.longitude);
                latitude = e.coords.latitude;
                longitude = e.coords.longitude;
                
                component.set("v.lat",latitude);
                component.set("v.long",longitude);
                
                alert(latitude);
                
                //if(latitude != 0){
                //    helper.fetchActJuncAccounts(component,helper);
                //}
               
                
            }, function() {
                console.log('There was an error.');
                
            },{maximumAge:600000});
        }
        else
        {
            alert('Votre navigateur ne supporte pas la géolocalisation');
        }
		*/
        
    },
    
    
    /*
    searchFilter: function(component, event, helper) {
        var searchVal = component.find("searchBox").get("v.value");
        if (event.which == 13){
            try {
                var data = component.get("v.acctList"),
                term = searchVal,//event.getParam("value"),//component.get("v.filter"),
                results = data, regex;
                regex = new RegExp(term, "i");
                // filter checks each row, constructs new array where function returns true
                results = data.filter(row=>regex.test(row.acct.Name));
            } catch(e) {
                // invalid regex, use full list
            }
            component.set("v.filteredAcctList", results);
        }    
    },
    */
    handleClick: function(component, event, helper) {
		var branchId=event.getSource('').get('v.ariaLabel').substring(0, 18);
        var eventId=event.getSource('').get('v.ariaLabel').substring(19, 37);
        var actJunctionId=event.getSource('').get('v.ariaLabel').substring(39, 57);
        
        //var branchId=event.getSource('').get('v.title');
        component.set('v.branchId',branchId);
        
        var latitude = component.get("v.lat");
        var longitude = component.get("v.long");
        
        var action = component.get("c.checkEventToday");
        //helper.insertEventRecord(component,event);
        
        action.setParams({
            branchId,
            eventId
        });
        
        /*
        action.setParams({
            branchId: branchId
        });*/
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.callEventCheck", response.getReturnValue());
				var dataCount = response.getReturnValue();
                //alert(dataCount);
                if (dataCount === 0){
                    //alert('Walang Event');
                    helper.insertEventRecord(component,event);
                    //helper.fetchActJuncAccounts(component,helper);
            		//helper.updateUserLogged(component,branchId,eventId,actJunctionId);
            		//helper.fetchActJuncAccounts(component,event,'1','0');
            		//helper.fetchActJuncAccounts(component,event,'0','1');
                    helper.insertEventCallLog(component,latitude,longitude);
                    helper.navigateAccount(component,event);
                }
                else if(dataCount === 1){
                    //alert('May Laman ang Event');
                    //helper.endCallDraftEvent(component); //for decision
                    helper.updateUserLogged(component,branchId,eventId,actJunctionId);
                    helper.insertEventCallLog(component,latitude,longitude);
                    helper.navigateAccount(component,event);
                } 
                else if(dataCount === 2){
                    //alert('May Laman ang Event at may hindi ka na logout');
                    helper.endCallDraftEvent(component);
            		helper.updateUserLogged(component,branchId,eventId,actJunctionId);
            		helper.insertEventCallLog(component,latitude,longitude);
                    helper.navigateAccount(component,event);
                } 
                else if(dataCount === 3){
                    alert('Completed Event');
                    helper.navigateAccount(component,event);
                }
                else{
                    alert('Please contact your Salesforce Sales Cloud Administrator!');
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
    }, 
    
    testClick: function(component, event, helper) {
        
        var branchId=event.getSource('').get('v.ariaLabel').substring(0, 18);
        var eventId=event.getSource('').get('v.ariaLabel').substring(19, 37);
        var actJunctionId=event.getSource('').get('v.ariaLabel').substring(39, 57);
        //alert(actJunctionId);
        
        var action = component.get("c.checkEventToday");
        //helper.insertEventRecord(component,event);
        
        action.setParams({
            branchId,
            eventId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.callEventCheck", response.getReturnValue());
				var dataCount = response.getReturnValue();
                
                if (dataCount === 0){
                    alert('Walang Event');
                }
                else if(dataCount === 1){
                    alert('May Laman ang Event');
                } 
                else if(dataCount === 2){
                    alert('May Laman ang Event at may hindi ka na logout');
                } 
                else if(dataCount === 3){
                    alert('Completed Event');
                }
                else{
                    alert('Please contact your Salesforce Sales Cloud Administrator!');
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
    },
    /*
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        //helper.loadPage(component,event);
        helper.fetchActJuncAccounts(component,event);
    },
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
       	//helper.loadPage(component,event);
       	helper.fetchActJuncAccounts(component,event);
    },
    */
    pageNavigation : function(component, event, helper) {
    	var defaultData = component.get('v.acctList');
        var updatedListOfRecords = component.get('v.updatedListOfRecords');
        
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var buttonName = event.getSource().get("v.name");
        
        if (buttonName == 'next') {
        	component.set('v.currentPage', component.get('v.currentPage') + 1);
            
            if (updatedListOfRecords.length > 0) {
                helper.nextPage(component, event, updatedListOfRecords, end, start, pageSize);
            }
            else {
                helper.nextPage(component, event, defaultData, end, start, pageSize);
            }
        }
        else if (buttonName == 'previous') {
            component.set('v.currentPage', component.get('v.currentPage') - 1);
            
            if (updatedListOfRecords.length > 0) {
                helper.previousPage(component, event, updatedListOfRecords, end, start, pageSize);
            }
            else {
                helper.previousPage(component, event, defaultData, end, start, pageSize);
            }
        }
    },
    
    filterByKeyword : function(component, event, helper) {
        
        if (event.which == 13){
            var data = component.get('v.acctList');
            var term = component.find("searchBox").get("v.value");
            
            var results = data;
            var regex;
            
            regex = new RegExp(term, "i");
            results = data.filter(row=>regex.test(row.acct.Name));
            
            component.set('v.updatedListOfRecords', results);
            helper.displayUpdatedListOfRecords(component, results);
        }
        
    },
    
    filterByWorkplanType : function(component, event, helper) {
        var buttonName = component.get("v.acctEventCallValue");
               
        if(buttonName === 'With Workplan (Today)'){
            //helper.loadPage(component,event,'0');
            helper.fetchActJuncAccounts(component,event,'0','0');
        }
        else if (buttonName === 'With Workplan (Yesterday)'){
            //helper.loadPage(component,event,'-1');
            helper.fetchActJuncAccounts(component,event,'-1','0');
        }
       	else if (buttonName === 'Without Workplan'){
            helper.fetchActJuncAccounts(component,event,'0','1');
        }
    },
})