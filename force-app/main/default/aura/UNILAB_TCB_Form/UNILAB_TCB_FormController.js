({
    doInit: function(component, event, helper) {
        
        helper.loadECLAccount(component,event);
        /*
        
        var branchId=component.get('v.recordId');

        var action = component.get("c.checkEventToday");
        
        action.setParams({
            branchId: branchId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
				var dataCount = response.getReturnValue();
                //alert(dataCount);
                if (dataCount === 0 || dataCount === 3){
                    component.set('v.enableForm',false);
                }
                if (dataCount === 1 || dataCount === 2){
                    helper.loadECLAccount(component,event);
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
        */
    },
    
 	categoryChangeHandle: function(component, event, helper) {
    	
        var selCat = component.get("v.categorySelValue");
        var eventId = component.get("v.eventId");
        var dataCount = component.get("v.dataCount");
        
        component.set("v.assortPriorityData", []);
        component.set("v.visibPriorityData", []);
        component.set("v.topPriorityData", []);
        
        //$A.get('e.force:refreshView').fire();
        
        if (dataCount === 0){
            helper.populateInitialVisibility(component, event, eventId);
            helper.populateInitialAssortment(component, event, eventId);
            helper.populateInitialTOPPriorities(component, event, eventId);
            
            helper.loadVisibility(component, event, eventId);
            //helper.loadAssortment(component, event);
            helper.loadAssort(component, event, eventId);
            helper.loadTOPPriorities(component, event, eventId);
            
            component.set("v.dataCount", 1);
        }
        else{
            helper.loadVisibility(component, event, eventId);
            //helper.loadAssortment(component, event);
            helper.loadAssort(component, event, eventId);
            helper.loadTOPPriorities(component, event, eventId);
        }
        
        /*
        helper.loadVisibility(component, event);
        helper.loadTOPPriorities(component, event);
        helper.loadAssortment(component, event);*/
        //alert(selCat);
    },
    
    handleUploadFinished: function (component, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        var cat = component.get("v.categorySelValue"); 
        //alert("Files uploaded : " + uploadedFiles.length);
		component.set("v.fileCount",uploadedFiles.length);
        // Get the file name
        uploadedFiles.forEach(file => console.log("TCB_Form_"+cat+"_"+file.name));
    },
    
    saveRecord : function(component, event, helper){
        
        var cat = component.get("v.categorySelValue"); 
        var eventId = component.get("v.eventId"); 
        var journal = component.get("v.journal");
        var fileCount =  component.get("v.fileCount");
        
        if(cat==="No Selection"){
            alert('Please Select a Category!');
        }
        else{
            if(!$A.util.isEmpty(journal)){
            	helper.saveJournal(component,journal,eventId);
            }
        }
        
        if (fileCount !== 0){
            helper.saveFiles(component,eventId);
        }
        
        helper.saveVisib(component);
        helper.saveAssortment(component);
        helper.saveTOPP(component);
        alert('Successfully Saved!');
    },
    
    /*
    searchFilter: function(component, event, helper) {
        var searchVal = component.find("searchBox").get("v.value");
        if (event.which == 13){
            try {
                helper.saveAssortment(component);
                var data = component.get("v.assortData"),
                term = searchVal,//event.getParam("value"),//component.get("v.filter"),
                results = data, regex;
                regex = new RegExp(term, "i");
                // filter checks each row, constructs new array where function returns true
                results = data.filter(row=>regex.test(row.Item_Target__c));
            } catch(e) {
                // invalid regex, use full list
            }
            component.set("v.filteredAssortData", results);
        }
    },
    
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.saveAssortment(component);
        helper.loadAssort(component, event);
    },
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.saveAssortment(component);
        helper.loadAssort(component, event);
    },*/
    
    showTAFTForm : function(component, event, helper){
        //component.set("v.showDialog", true);
        
        switch(event.getParam('value')) {
          case "New": 
                var modalBody;
                var modalFooter;
                $A.createComponents([
                    ['c:UNILAB_TCB_TAFT',{"recordId": component.get("v.recordId")}]
                
                ],
                 function(components, status){
                     if (status === 'SUCCESS') {
                         modalBody = components[0];
                         var modalPromise = component.find('overlayLib').showCustomModal({
                             header: 'Trade Activity Form',
                             body: modalBody,
                             footer: modalFooter,
                             showCloseButton: true,
                             cssClass: 'my-modal,my-custom-class,my-other-class',
                             closeCallback: function() {
                                 helper.loadTAFT(component,event);
                             }
                         });
                         component.set("v.modalPromise", modalPromise);
                     }
                 });
                break;
        }
    },
    
    
     /*
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component
        component.find("overlayLib").notifyClose();
    },
    
   
    addCompetitor : function(component, event, helper){
    	// Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        // In that component, start your flow. Reference the flow's API Name.
        flow.startFlow("TRACT");
    },*/
        
    handleTAFTDeleteEvent : function(component, event, helper){
    	helper.loadTAFT(component,event);
        //var message = event.getParam("message");
        //alert(message);
    },
    
    pageNavigation : function(component, event, helper) {
    	var defaultData = component.get('v.assortData');
        var updatedListOfRecords = component.get('v.updatedListOfRecords');
        
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var buttonName = event.getSource().get("v.name");
        
        
        if (buttonName == 'next') {
        	component.set('v.currentPage', component.get('v.currentPage') + 1);
            
            if (updatedListOfRecords.length > 0) {
                //helper.saveAssortment(component);
                helper.nextPage(component, event, updatedListOfRecords, end, start, pageSize);
            }
            else {
                helper.nextPage(component, event, defaultData, end, start, pageSize);
            }
        }
        else if (buttonName == 'previous') {
            component.set('v.currentPage', component.get('v.currentPage') - 1);
            
            if (updatedListOfRecords.length > 0) {
                //helper.saveAssortment(component);
                helper.previousPage(component, event, updatedListOfRecords, end, start, pageSize);
            }
            else {
                helper.previousPage(component, event, defaultData, end, start, pageSize);
            }
        }
    },
    
    filterByKeyword : function(component, event, helper) {
        
        if (event.which == 13){
            
            
            var data = component.get('v.assortData');
            var term = component.find("searchBox").get("v.value");
            
            var results = data;
            var regex;
            
            //helper.saveAssortment(component);
            
            regex = new RegExp(term, "i");
            results = data.filter(row=>regex.test(row.Item_Target__c));
            
            component.set('v.updatedListOfRecords', results);
            helper.displayUpdatedListOfRecords(component, results);
        }
        
    },
    
})