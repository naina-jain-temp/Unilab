({
    doInit: function (component, event, helper) {
        
             
        if(component.get("v.recordId") != null){
            
            helper.fetchUserInfo(component, event, helper);
            
            helper.fetchColumns(component, event, helper);
            
            helper.fetchDateToday(component, event, helper);
            
            helper.fetchAllocationData(component, event, helper);
            
            helper.fetchPALConfigurations(component, event, helper);
            
            helper.fetchAccountStatus(component, event, helper);
            
            helper.fetchFrequencyofVisitPicklist(component, event, helper);
            
            helper.fetchAlongNationalHighwayResidentialPicklist(component, event, helper);
            
            helper.fetchStoreFormatPicklist(component, event, helper);
            
            helper.fetchRPSAccountClassPicklist(component, event, helper);
            
            helper.fetchSellinDataTypePicklist(component, event, helper);
            
            helper.fetchEndingInventoryDataTypeAndOperatorPicklist(component, event, helper);
            
            helper.fetchSelloutDataTypePicklist(component, event, helper);
            
            helper.fetchEndingInventoryMeasureLevelPicklist(component, event, helper);
            
        } else {
            component.set("v.spinner",true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "message": "Cannot Create Allocation in this Panel."
            });
            toastEvent.fire();
        }
       
    },
    
    //------------------------------START ALLOCATION PHASE TRANSITION---------------------------------
    
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: THIS PART NAVIGATES THE PATH TO SETUP PHASE
    goToSection1 : function(component, event, helper) {
        var saved = component.get("v.isSaved");
        var status = component.get("v.allocRec.Status__c");
        if(status != "Draft"){
            component.set('v.isDisabled',true);
            component.set('v.SIdisable',true);
            component.set('v.SOdisable',true);
        }
        
        if(saved == true){
            component.set("v.currentStep", '2');
            
        }else{
            component.set("v.currentStep", '1');
        }
        
        
    },
    
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: THIS PART NAVIGATES THE PATH TO GENERATE PHASE
    goToSection2 : function(component, event, helper) {
        
        var retAlloc = component.get("v.allocRec");
        var palConfigRec = component.get("v.palConfigData");
        var vRule_Checker = helper.validationRule_Checker(component, event, helper, retAlloc, palConfigRec);
        var val = event.getSource().get("v.value");
        if(!vRule_Checker){
            if(val == 'nextButtonClicked'){
                helper.retrieveAllocationData(component, event, retAlloc ,helper);
                component.set("v.currentStep", '2');
            } else if (val == '2'){
                helper.getAccAllocHierarchy(component,event,helper);
                component.set("v.currentStep", '2');
            }
        }
        
        
    },
    
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: THIS PART NAVIGATES THE PATH TO EXPORT PHASE
    goToSection3 : function(component, event, helper) {
        var retAlloc = component.get("v.allocRec");
        var palConfigRec = component.get("v.palConfigData");
        var isOverAllocated = component.get("v.IsOverAllocated");
        var vRule_Checker = helper.validationRule_Checker(component, event, helper, retAlloc, palConfigRec);
        var vRule_Export = helper.validationRule_Export_Path_Button(component,retAlloc);
        var val = event.getSource().get("v.value");
        var error = [];
        if(!vRule_Checker && !vRule_Export && !isOverAllocated){ 
                component.set("v.currentStep", '3');
        } else{
            component.set("v.currentStep", '1');
            if((val == 'generateNextButtonClicked' && isOverAllocated) || (val == '3' && isOverAllocated)){
                error.push('Cannot proceed because maximum allocation has been exceeded.');
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
                component.set("v.currentStep", '2');
            }else if(val == 'generateNextButtonClicked' && vRule_Export){
                error.push('Cannot proceed to Export if Status is not Finalized');
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
                component.set("v.currentStep", '2');
            }else if(vRule_Export && retAlloc.Status__c == 'Adjustment'){
                error.push('Cannot proceed to Export if Status is not Finalized');
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
                component.set("v.currentStep", '2');
            }else if(vRule_Export){
                error.push('Cannot proceed to Export if Status is not Finalized');
                component.set("v.listOfAllocError",error);
                helper.handleErrors(component, error);
            }
        }
    },
    
    //------------------------------END ALLOCATION PHASE TRANSITION---------------------------------
    
    //Saves Allocation record as Draft when editing is not yet done
    saveAsDraft : function(component, event, helper) {
        var retAlloc = component.get("v.allocRec");
        helper.updateDraftRec(component, event, retAlloc, helper);
    },
    
    
    // ---------------------------START OF MODAL CODES------------------------------
    
    openDeleteModal : function(component, event, helper) {
        console.log('openDeleteModal');
        var selectedData = component.get("v.data");
        
        if(selectedData !== null){ //Validates whether user selected a valid data
            
            var isInvalid = false;
            for(var i = 0; i<selectedData.length; i++){
                if(selectedData[i].Id == null){
                    isInvalid = true;
                    break;
                }else{
                    isInvalid = false;
                }
            }
            if(isInvalid == true){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" : "error",
                    "message": "Cannot delete Account groups, teams nor channels"
                });
                toastEvent.fire();
            }else{
                component.set("v.deleteModal", true);            
            }
        }
        else{
            console.log('In Else openEditModal');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "message": "Please select records to delete"
            });
            toastEvent.fire();
        } 
    },
    
    closeDeleteModal : function(component, event, helper) {
        
        component.set("v.deleteModal", false);
        
    },
    
    closeErrorModal : function(component, event, helper) {
    
        var errorModal = document.getElementById("errorDiv");
        $A.util.removeClass(errorModal, 'slds-show');
        $A.util.addClass(errorModal, 'slds-hide');
    },
    
    openEditModal : function(component, event, helper) {
        console.log('Inside openEditModal');
        var selectedData = component.get("v.data");
        console.log('selectedData - openEditModal:',JSON.stringify(selectedData));
        
        
        
        if(selectedData == null || selectedData.length < 1){
            
            console.log('In Else openEditModal');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "message": "Please select records to edit"
            });
            toastEvent.fire();
            
            
        }
        else{
            
            var editModal = document.getElementById("editDiv");
            $A.util.removeClass(editModal, 'slds-hide');
            $A.util.addClass(editModal, 'slds-show');
            helper.editAccAllocationData(component, event, helper);
        }
        
        
    },  
    
    closeEditModal : function(component, event, helper) {
        var editModal = document.getElementById("editDiv");
        $A.util.removeClass(editModal, 'slds-show');
        $A.util.addClass(editModal, 'slds-hide');
    },
    
    openAddModal: function(component, event, helper) {
        
        component.set("v.addModal", true);
        
        var letters = [];
        letters.push("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "All");
        component.set("v.alphabetPageList", letters);
        var selectedAlphabet = "All";
        
        component.set("v.spinner", true);
        
        helper.resetData(component);
        
        helper.addEditAccountData(component, event);
        
    },
    
    closeAddModal: function(component, event, helper) {
        
        helper.resetData(component);
        
        component.set("v.addModal", false);
        
    },   
    
    closeEditAddModal : function(component, event, helper) {
        
        helper.resetData(component);
        
        component.set("v.spinner", true);
        
        helper.addEditAccountData(component, event);
        
        var editAddManualModal = document.getElementById("editAddManualModal");
        $A.util.removeClass(editAddManualModal, 'slds-show');
        $A.util.addClass(editAddManualModal, 'slds-hide');
        
    },
    
    //-------------------------------END OF MODAL CODES-----------------------------------
    
    //AUTHOR: KRIS MARIANO
    //DESCRIPTION: THIS PART GETS THE SELECTED DATA FROM THE TREE GRID
    getSelectedName: function(cmp, event, helper) {
        
        var selectedRows = event.getParam('selectedRows');
        var listofRows= [];
        console.log('SELECTED ROWS - getSelectedName: '+ JSON.stringify(selectedRows));
        for (var i = 0; i < selectedRows.length; i++){
            
            listofRows.push({
                Id: selectedRows[i].Id,
                name: selectedRows[i].name,
                Manual: selectedRows[i].Manual,
                Computed_Allocation: selectedRows[i].Computed_Allocation,
                Final_Allocation: selectedRows[i].Final_Allocation,
                YTD_Sales_TY: selectedRows[i].YTDSales_TY,
                YTD_Sales_LY: selectedRows[i].YTDSales_LY
            });
            // alert("You selected: " + JSON.stringify(selectedRows[i]));
        }
        
        cmp.set('v.data',listofRows); 

        console.log("You selected - getSelectedName: " + JSON.stringify(listofRows));
        
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: FETCH DATA TO BE ADDED TO THE TREE GRID
    getAddedName: function(cmp, event, helper) {
        var addedAcc = event.getParam('addedAcc');								  
        var listofRows= [];
        for (var i = 0; i < addedAcc.length; i++){
            listofRows.push({
                Id: addedAcc[i].accAllocMain.Id,
                name: addedAcc[i].name
            });
        } 
    },
    
    //------------------------START HANDLING SETUP ACTIONS--------------------------
    //AUTHOR: MARK PALACIOS
    
    handleMeasureTypeChange : function(component, event) {
        
        var sellInVal = component.get("v.allocRec.Sell_in__c");
        var sellOutVal = component.get("v.allocRec.Sell_out__c");
        var eIVal = component.get("v.allocRec.Ending_Inventory__c");
        
        if(sellInVal == true || sellOutVal == true || eIVal == true){
            component.set("v.measureTypeHasValue",true);
        } else {
            component.set("v.measureTypeHasValue",false);
        }
        
        if(sellInVal == true){ 
            component.set("v.enabledSellInDataType",true);
            //component.set("v.measureTypeLabel","SELL-IN DATA TYPE");
            component.set("v.SOdisable", true);
        } else if (sellInVal == false) {
            component.set("v.enabledSellInDataType",false);
            component.set("v.SOdisable", false);
        } 
        
        if (sellOutVal == true){ 
            component.set("v.enabledSellOutDataType",true);
            //component.set("v.measureTypeLabel","SELL-OUT DATA TYPE");
            component.set("v.SIdisable", true);
        } else if (sellOutVal == false) {
            component.set("v.enabledSellOutDataType",false);
            component.set("v.SIdisable", false);
        }
        
        if(eIVal == true){
            component.set("v.enabledEndingInventoryDataType",true);
        } else if(eIVal == false){
            component.set("v.enabledEndingInventoryDataType",false);
        }
    },
    
    handleInputAllocation : function(component, event){
        var allocVol = event.getSource().get("v.value");
        if(allocVol != null){
            if(allocVol < 0){
                component.find("inputAllocationVolume").setCustomValidity("Invalid input value.");
                component.find("inputAllocationVolume").reportValidity();
            } else {
                component.find("inputAllocationVolume").setCustomValidity("");
                component.find("inputAllocationVolume").reportValidity();
            }
        } 
    },
    
    handleAllocStartDate : function(component, event){
        var startDate = event.getSource().get("v.value");
        if(startDate != null){
            component.find("allocStartDate").setCustomValidity("");
            component.find("allocStartDate").reportValidity();
        }
    },
    
    handleAllocEndDate : function(component, event){
        var endDate = event.getSource().get("v.value");
        if(endDate != null || endDate == ''){
            component.find("allocEndDate").setCustomValidity("");
            component.find("allocEndDate").reportValidity();
        }
    },
    
    handleEndingInventoryDataTypeChange : function(component, event) {
        var endingInventoryDataType = event.getSource().get("v.value");
        var configRec = component.get('v.palConfigData');
        
        if(endingInventoryDataType == 'Months Supply' && endingInventoryDataType == configRec.Ending_Inventory_Data_Type__c){
            component.find("eIOperator").set("v.value", configRec.Ending_Inventory_Operator__c);
            component.find("eIValue").set("v.value", configRec.Ending_Inventory_Value__c);
        }
        if(endingInventoryDataType != null){
            component.find("eIDataType").setCustomValidity("");
            component.find("eIDataType").reportValidity();
            
            component.find("eIOperator").setCustomValidity("");
            component.find("eIOperator").reportValidity();
            
            component.find("eIValue").setCustomValidity("");
            component.find("eIValue").reportValidity();
        }
    },
    
    handleEndingInventoryOperatorChange : function(component, event) {
        var endingInventoryOperator = event.getSource().get("v.value");
        if(endingInventoryOperator != null){
            component.find("eIOperator").setCustomValidity("");
            component.find("eIOperator").reportValidity();
        }
    },
    
    handleEndingInventoryValueChange : function(component, event) {
        var endingInventoryValue = event.getSource().get("v.value");
        var configRec = component.get('v.palConfigData');
        
        if(endingInventoryValue != null){
            component.find("eIValue").setCustomValidity("");
            component.find("eIValue").reportValidity();
        }
        if(endingInventoryValue > configRec.Ending_Inventory_Value__c){
            component.find("eIValue").setCustomValidity("Ending Inventory Value must not be greater than "+configRec.Ending_Inventory_Value__c);
            component.find("eIValue").reportValidity();
        }else if(endingInventoryValue < 0){
            component.find("eIValue").setCustomValidity("Ending Inventory Value must not be less than 0");
            component.find("eIValue").reportValidity();
        }else if(endingInventoryValue.length  > 4){
            component.find("eIValue").setCustomValidity("Ending Inventory Value must only have 2 decimal places.");
            component.find("eIValue").reportValidity();
        }
        
    },
    //------------------------END HANDLING SETUP ACTIONS--------------------------
    
    getSelectedID : function(component, event, helper){ 
        console.log('Inside getSelectedID');
        var selectedRecords = [];
        var selectedRows = event.getParam("selectedRows");
        
        selectedRows.forEach(function(selectedRow){
            selectedRecords.push(selectedRow);
        })
        
        component.set("v.selectedRows", selectedRecords);
        component.set("v.addedAcc", selectedRecords);
        
    },
    //------------------------START DELETE FUNCTION IN GENERATE PHASE------------------------
    
    //AUTHOR: KRIS MARIANO
    //DESCRIPTION: THIS PART DELETES THE SELECTED ACCOUNT ALLOCATION RECORD FROM THE TREE GRID
    deleteTableRow : function(component, event, helper) {
        
        console.log('Inside deleteTableRows');
        var selectedData = component.get("v.data");
        var deleteData = [];
        var isInvalid = false;
        
        for(var i =0; i<selectedData.length; i++){
            deleteData.push({
                Id: selectedData[i].Id,
                Name: selectedData[i].name,
                Manual__c: selectedData[i].Manual,
                YTDSales_LY__c: selectedData[i].YTD_Sales_LY,
                YTDSales_TY__c: selectedData[i].YTD_Sales_TY
            });
        }
        
        if(deleteData.length !== 0){
            var action = component.get("c.deleteAccountAllocations");
            action.setParams({
                "toDeleteList": deleteData
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    
                    if(result == true){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Successfully Deleted",
                            "type" : "success",
                            "message": "Delete Success"
                        });
                        component.set("v.deleteModal", false);
                        toastEvent.fire();
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Delete",
                            "type" : "error",
                            "message": "Only manually added accounts can be deleted"
                        });
                        component.set("v.deleteModal", false);
                        toastEvent.fire();
                    }
                    
                }
            }),
                
                component.set("v.deleteModal", false);
            $A.enqueueAction(action);
            
            helper.getAccAllocHierarchy(component, event, helper);
            $A.get('e.force:refreshView').fire();
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Delete",
                "type" : "error",
                "message": "Please select records to delete"
            });
            component.set("v.deleteModal", false);
            toastEvent.fire();
            
        }
        
    },
    //------------------------END DELETE FUNCTION IN GENERATE PHASE------------------------
    
    //------------------------START EDIT FUNCTION IN GENERATE PHASE------------------------
    
    //AUTHOR: KRIS MARIANO
    //DESCRIPTION: THIS PART UPDATES THE ACCOUNT ALLOCATION RECORD WITH THE PROVIDED MANUAL
    saveTable: function(component, event, helper) {
        var draftValues = event.getParam('draftValues');
        var tableData = component.get("v.data");
        var masterData = component.get("v.masterData");
        var isAccountShown = component.get("v.accountGroups");
        var isTeamShown = component.get("v.accountTeams");
        var updateData = [];
        var errors = [];
        var filteredData = [];
        var isTeamSelected = false;
        var isGroupSelected = false;
        var isAccountSelected = false;
        var dataResults = [];
        var dataResults1 = [];
        var childCount = [];
        
        if((isAccountShown && isTeamShown) || (!isAccountShown && !isTeamShown)){ //CHECK FILTERS
            if(!isTeamSelected){ 
                //----------------------START OF IF SELECTED DATA IS TEAM-----------------------
                
                //----------------------CHECK IF SELECTED DATA IS TEAM-----------------------
                for(var i =0; i<tableData.length; i++){
                    var regex;
                    var results;
                    if(isTeamSelected){
                        break;
                    }else{
                        regex = new RegExp(tableData[i].name, "i");
                        for(var j=0; j<masterData.length; j++){
                            if(tableData[i].name == masterData[j].name){
                                isTeamSelected = true;
                                break;
                            }else{
                                results = masterData[j]['_children'].filter(row=>regex.test(row.name));
                                dataResults.push(results);
                            }
                        } 
                    }
                }
                
                
                
                for(var i =0; i<tableData.length; i++){
                    for(var j = 0; j<dataResults.length; j++){
                        for(var k = 0; k<dataResults[j].length; k++){
                            if(isGroupSelected && isAccountSelected){
                                break;
                            }else{
                                if(dataResults[j][k].name == tableData[i].name && dataResults[j][k]['_children'] != null){
                                    isGroupSelected = true;
                                    
                                }else if(tableData[i].Id != null){
                                    isAccountSelected = true;
                                }   
                            }
                        }
                    }
                }
                if(isGroupSelected && !isAccountSelected){//----------------------START OF OUTER IF STATEMENT----------------------
                    for(var i = 0; i<tableData.length; i++){//------------------------START OF FIRST FOR LOOP------------------------
                        for(var j = 0; j<dataResults.length; j++){//--------------------START OF SECOND FOR LOOP-----------------------
                            for(var k = 0; k<dataResults[j].length; k++){//------------------START OF THIRD FOR LOOP---------------------
                                if(tableData[i].name == dataResults[j][k].name){//----START OF TABLEDATA == DATARESULTS IF STATEMENT-------
                                    var childNodes = dataResults[j][k]['_children'];
                                    
                                    if(draftValues[i] == undefined){
                                        continue;
                                    }else{//----------------START OF FIRST ELSE-----------------
                                        if(draftValues[i].Manual == ""){
                                            errors.push({name: tableData[i].name, 
                                                         errorMessage:"Value of Manual field cannot be empty"});
                                            
                                        }else{//----------------START OF SECOND ELSE-----------------
                                            if(draftValues[i].Manual != Math.floor(draftValues[i].Manual)){
                                                errors.push({name : tableData[i].name, 
                                                             errorMessage: "Value of Manual cannot be decimal"});
                                            }else{//----------------START OF THIRD ELSE-----------------
                                                if(draftValues[i].Manual < 0){
                                                    errors.push({name : tableData[i].name,
                                                                 errorMessage: "Value for Final Allocation cannot be negative"});
                                                }else{//----------------START OF FOURTH ELSE-----------------
                                                    for(var k = 0; k<childNodes.length; k++){
                                                        updateData.push({
                                                            Id: childNodes[k].Id,
                                                            Manual__c: Math.floor(draftValues[i].Manual / childNodes.length)
                                                        });
                                                    }
                                                    
                                                }//-----------------END OF FOURTH ELSE-----------------
                                            }//-----------------END OF THIRD ELSE--------------------
                                        }//---------------END OF SECOND ELSE-----------------------
                                    }//---------------------END OF FIRST ELSE--------------------
                                }//-----END OF TABLEDATA == DATARESULTS IF STATEMENT-----------
                            }//------------------END OF THIRD FOR LOOP-----------------------
                        }//----------------------END OF SECOND FOR LOOP--------------------
                    }//-----------------------END OF FIRST FOR LOOP----------------------
                    //---------------------END OF OUTER IF STATEMENT-------------------
                }else{
                    for(var i = 0; i<tableData.length; i++){
                        if(draftValues[i] == undefined){
                            continue;
                        }else{
                            if(draftValues[i].Manual == ""){
                                errors.push({name: tableData[i].name, 
                                             errorMessage:"Value of Manual field cannot be empty"});
                                
                            }else{
                                if(draftValues[i].Manual != Math.floor(draftValues[i].Manual)){
                                    errors.push({name : tableData[i].name, 
                                                 errorMessage: "Value of Manual cannot be decimal"});
                                }else{
                                    if(draftValues[i].Manual < 0){
                                        errors.push({name : tableData[i].name,
                                                     errorMessage: "Value for Final Allocation cannot be negative"});
                                    }else{
                                        updateData.push({
                                            Id: draftValues[i].Id,
                                            Manual__c: Math.floor(draftValues[i].Manual)
                                        });
                                    }
                                }
                            }
                        }
                    }
                }
                //--------------------END OF ISTEAMSELECTED IF STATEMENT--------------------------
            }
        }else if(isAccountShown && !isTeamShown){
            
            for(var i =0; i<tableData.length; i++){
                for(var j = 0; j<masterData.length; j++){
                    if(masterData[i].name == tableData[i].name){
                        isGroupSelected = true;
                        
                    }else{
                        isAccountSelected = true;
                        
                    }
                }
            }
            
            if(isGroupSelected && !isAccountSelected){
                for(var i = 0; i<tableData.length; i++){
                    for(var j = 0; j<masterData.length; j++){
                        if(tableData[i].name == masterData[j].name){
                            var childNodes = masterData[j]['_children'];
                            
                            if(draftValues[i] == undefined){
                                continue;
                            }else{
                                if(draftValues[i].Manual == ""){
                                    errors.push({name: tableData[i].name, 
                                                 errorMessage:"Value of Manual field cannot be empty"});
                                    
                                }else{
                                    if(draftValues[i].Manual != Math.floor(draftValues[i].Manual)){
                                        errors.push({name : tableData[i].name, 
                                                     errorMessage: "Value of Manual cannot be decimal"});
                                    }else{
                                        if(draftValues[i].Manual < 0){
                                            errors.push({name : tableData[i].name,
                                                         errorMessage: "Value for Final Allocation cannot be negative"});
                                        }else{
                                            
                                            for(var k = 0; k<childNodes.length; k++){
                                                updateData.push({
                                                    Id: childNodes[k].Id,
                                                    Manual__c: Math.floor(draftValues[i].Manual / childNodes.length)
                                                });
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                for(var i = 0; i<tableData.length; i++){
                    if(draftValues[i] == undefined){
                        continue;
                    }else{
                        if(draftValues[i].Manual == ""){
                            errors.push({name: tableData[i].name, 
                                         errorMessage:"Value of Manual field cannot be empty"});
                            
                        }else{
                            if(draftValues[i].Manual != Math.floor(draftValues[i].Manual)){
                                errors.push({name : tableData[i].name, 
                                             errorMessage: "Value of Manual cannot be decimal"});
                            }else{
                                if(draftValues[i].Manual < 0){
                                    errors.push({name : tableData[i].name,
                                                 errorMessage: "Value for Final Allocation cannot be negative"});
                                }else{
                                    updateData.push({
                                        Id: draftValues[i].Id,
                                        Manual__c: Math.floor(draftValues[i].Manual)
                                    });
                                }
                            }
                        }
                    }
                }
            }
            
        }else if(!isAccountShown && isTeamShown){
            if(!isTeamSelected){
                
                for(var i =0; i<tableData.length; i++){
                    var regex;
                    var results;
                    if(isTeamSelected){
                        break;
                    }else{
                        regex = new RegExp(tableData[i].name, "i");
                        for(var j=0; j<masterData.length; j++){
                            if(tableData[i].name == masterData[j].name){
                                isTeamSelected = true;
                                break;
                            }else{
                                results = masterData[j]['_children'].filter(row=>regex.test(row.name));
                                dataResults.push(results);
                            }
                        } 
                    }
                }
                
                
                
                for(var i =0; i<tableData.length; i++){
                    for(var j = 0; j<dataResults.length; j++){
                        for(var k = 0; k<dataResults[j].length; k++){
                            if(isGroupSelected && isAccountSelected){
                                break;
                            }else{
                                if(dataResults[j][k].name == tableData[i].name && dataResults[j][k]['_children'] != null){
                                    isGroupSelected = true;
                                    
                                }else if(tableData[i].Id != null){
                                    isAccountSelected = true;
                                }   
                            }
                        }
                    }
                }
                if(isGroupSelected && !isAccountSelected){
                    for(var i = 0; i<tableData.length; i++){
                        for(var j = 0; j<dataResults.length; j++){
                            for(var k = 0; k<dataResults[j].length; k++){
                                if(tableData[i].name == dataResults[j][k].name){
                                    var childNodes = dataResults[j][k]['_children'];
                                    
                                    if(draftValues[i] == undefined){
                                        continue;
                                    }else{
                                        if(draftValues[i].Manual == ""){
                                            errors.push({name: tableData[i].name, 
                                                         errorMessage:"Value of Manual field cannot be empty"});
                                            
                                        }else{
                                            if(draftValues[i].Manual != Math.floor(draftValues[i].Manual)){
                                                errors.push({name : tableData[i].name, 
                                                             errorMessage: "Value of Manual cannot be decimal"});
                                            }else{
                                                if(draftValues[i].Manual < 0){
                                                    errors.push({name : tableData[i].name,
                                                                 errorMessage: "Value for Final Allocation cannot be negative"});
                                                }else{
                                                    
                                                    for(var k = 0; k<childNodes.length; k++){
                                                        updateData.push({
                                                            Id: childNodes[k].Id,
                                                            Manual__c: Math.floor(draftValues[i].Manual / childNodes.length)
                                                        });
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else{
                    for(var i = 0; i<tableData.length; i++){
                        if(draftValues[i] == undefined){
                            continue;
                        }else{
                            if(draftValues[i].Manual == ""){
                                errors.push({name: tableData[i].name, 
                                             errorMessage:"Value of Manual field cannot be empty"});
                                
                            }else{
                                if(draftValues[i].Manual != Math.floor(draftValues[i].Manual)){
                                    errors.push({name : tableData[i].name, 
                                                 errorMessage: "Value of Manual cannot be decimal"});
                                }else{
                                    if(draftValues[i].Manual < 0){
                                        errors.push({name : tableData[i].name,
                                                     errorMessage: "Value for Final Allocation cannot be negative"});
                                    }else{
                                        updateData.push({
                                            Id: draftValues[i].Id,
                                            Manual__c: Math.floor(draftValues[i].Manual)
                                        });
                                    }
                                }
                            }
                        }
                    }
                }   
                
            }
        }else{
                if(!isTeamSelected){
                    for(var i = 0; i<draftValues.length; i++){
                        if(draftValues[i].Manual == ""){
                            errors.push({name: tableData[i].name, 
                                         errorMessage:"Value of Manual field cannot be empty"});
                            
                        }else{
                            if(draftValues[i].Manual != Math.floor(draftValues[i].Manual)){
                                errors.push({name : tableData[i].name, 
                                             errorMessage: "Value of Manual cannot be decimal"});
                            }else{
                                if(draftValues[i].Manual < 0){
                                    errors.push({name : tableData[i].name,
                                                 errorMessage: "Value for Final Allocation cannot be negative"});
                                }else{
                                    
                                    updateData.push({
                                        Id: draftValues[i].Id,
                                        Manual__c: draftValues[i].Manual
                                    });
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
        if(isGroupSelected && isAccountSelected){
            var editModal = document.getElementById("editDiv");
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "message": "Cannot edit Groups and Accounts at the same time"
            });
            toastEvent.fire();
        }else if(isTeamSelected){
            var editModal = document.getElementById("editDiv");
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "message": "Cannot edit Teams"
            });
            toastEvent.fire();
            
            $A.util.removeClass(editModal, 'slds-hide');
            $A.util.addClass(editModal, 'slds-show');
        }else{
            if(updateData.length !== 0 && errors.length !==0){
                var action = component.get("c.updateAccountAllocation");
                action.setParams({ accAlloc : updateData });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var editModal = document.getElementById("editDiv");
                        helper.getAccAllocHierarchy(component, event, helper);
                        console.log('In Else Edit');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type" : "success",
                            "message": "Edit Success"
                        });
                        toastEvent.fire();
                        helper.checkAllocationSuccess(component, event, helper);
                        $A.get('e.force:refreshView').fire();
                        
                        $A.util.removeClass(editModal, 'slds-show');
                        $A.util.addClass(editModal, 'slds-hide');
                        
                        $A.get('e.force:refreshView').fire();
                        
                        $A.util.removeClass(editModal, 'slds-show');
                        $A.util.addClass(editModal, 'slds-hide');
                        
                    }else if(state === 'ERROR'){
                        var editModal = document.getElementById("editDiv");
                        console.log('In Else Edit');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "error",
                            "message": "Something went wrong. Please contact your administrator"
                        });
                        toastEvent.fire();
                        
                        $A.util.removeClass(editModal, 'slds-hide');
                        $A.util.addClass(editModal, 'slds-show');
                    }
                    
                });
                
                var errorModal = document.getElementById("errorDiv");
                
                component.set('v.columns', [
                    { label: 'Account Name', fieldName: 'name', type: 'text'},
                    { label: 'Error Message', fieldName: 'errorMessage', type: 'text'}
                ]);
                
                component.set('v.data', errors);
                
                $A.util.removeClass(editModal, 'slds-show');
                $A.util.addClass(editModal, 'slds-hide');
                
                $A.util.removeClass(errorModal, 'slds-show');
                $A.util.addClass(errorModal, 'slds-hide');
                
                $A.enqueueAction(action);
            }else if(updateData.length !== 0 && errors.length ==0){
                var action = component.get("c.updateAccountAllocation");
                action.setParams({ accAlloc : updateData });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var editModal = document.getElementById("editDiv");
                        helper.getAccAllocHierarchy(component, event, helper);
                        console.log('In Else Edit');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type" : "success",
                            "message": "Edit Success"
                        });
                        toastEvent.fire();
                        helper.checkAllocationSuccess(component, event, helper);
                        $A.get('e.force:refreshView').fire();
                        
                        $A.util.removeClass(editModal, 'slds-show');
                        $A.util.addClass(editModal, 'slds-hide');
                        
                        $A.get('e.force:refreshView').fire();
                        
                        $A.util.removeClass(editModal, 'slds-show');
                        $A.util.addClass(editModal, 'slds-hide');
                        
                    }else if(state === 'ERROR'){
                        var editModal = document.getElementById("editDiv");
                        console.log('In Else Edit');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "error",
                            "message": "Something went wrong. Please contact your administrator"
                        });
                        toastEvent.fire();
                        
                        $A.util.removeClass(editModal, 'slds-hide');
                        $A.util.addClass(editModal, 'slds-show');
                    }
                    
                });
                
                $A.enqueueAction(action);
            }else if(updateData.length == 0 && errors.length !==0){
                var editModal = document.getElementById("editDiv");
                $A.util.removeClass(editModal, 'slds-show');
                $A.util.addClass(editModal, 'slds-hide');
                
                var errorModal = document.getElementById("errorDiv");
                
                component.set('v.columns', [
                    { label: 'Account Name', fieldName: 'name', type: 'text'},
                    { label: 'Error Message', fieldName: 'errorMessage', type: 'text'}
                ]);
                
                component.set('v.data', errors);
                
                $A.util.removeClass(errorModal, 'slds-hide');
                $A.util.addClass(errorModal, 'slds-show');
                
            }else{
                var editModal = document.getElementById("editDiv");
                console.log('In Else Edit');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" : "error",
                    "message": "Please select records to edit"
                });
                toastEvent.fire();
            }
        }
        
        
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: THIS PART SAVES THE SELECTED ACCOUNT AS AN ACCOUNT ALLOCATION
    addNewAccount: function(component, event, helper) {
        
        var data = component.get("v.listOfAllAccounts");
        var term = "true";
        var results = data;
        var regex;
        
        var selectedRecords = [];
        var selectedCount = component.get("v.selectedCount");
        
        regex = new RegExp(term, "i");
        results = data.filter(row=>regex.test(row.isChecked));
        
        for (var i = 0; i < results.length; i++) {
            selectedRecords.push(results[i].objAccount);
        }
        
        if (selectedCount == 0) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "message": "Please select one Account record!!"
            });
            toastEvent.fire();
        }
        else {
            helper.addAccAllocationData(component, event, helper, selectedRecords);
        }
        
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: FILTERS DATA TO BE ADDED ON THE TREE GRID
    filter: function(component, event, helper) {
        
        var data = component.get("v.listOfAllAccounts");
        var term = component.get("v.filter");
        var results = data;
        var regex;
        
        regex = new RegExp(term, "i");
        results = data.filter(row=>regex.test(row.objAccount.Name));
        
        component.set("v.updatedListOfAccounts", results);
        
        helper.displayListData(component, results);
        
    },
    
    //AUTHOR: KRIS MARIANO
    //DESCRIPTION: CLOSES THE EDIT MODAL
    cancelTable: function(component, event, helper){
        var editModal = document.getElementById("editDiv");
        $A.util.removeClass(editModal, 'slds-show');
        $A.util.addClass(editModal, 'slds-hide');
    },
    
    //-------------------------START FUNCTIONS OF ADD FUNCTION IN GENERATE PHASE----------------------------
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: THIS PART IS FOR THE NAVIGATION OF ADD FUNCTION
    navigate: function(component, event, helper) { 
        console.log('navigate');
        console.log(component.get("v.allocRec").Channel__c);
        var channel = component.get("v.allocRec").Channel__c;
        var currentPage = component.get("v.page");
        var page;
        var direction = event.getSource().get("v.label"); 
        var recordToDisply = component.find("recordSize").get("v.value");
        var selectedLetter = component.get("v.currentAlphabet");
        if(direction == "Next Page"){
            page = currentPage + 1;
            component.set("v.page",page);
        } else if(direction == "Previous Page"){
            page = currentPage - 1;
            component.set("v.page",page);
        }
        helper.getAllAccounts(component, page, recordToDisply, selectedLetter, channel, helper);
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: THIS PART WILL FILTER THE DATA SHOWN IN THE DATA TABLE 
    //BASED ON THE SELECTED LETTER OF THE USER
    onSelectChange: function(component, event, helper) {
        
        var selectedLetter = component.get("v.currentAlphabet");
        var filterAccount = component.get("v.filter");
        var data = component.get("v.listOfAllAccounts");
        var term = "^" + selectedLetter;
        var results = data;
        var regex;
        
        if (selectedLetter == 'All') {
            if (filterAccount == '') {
                regex = new RegExp();
                results = data.filter(row=>regex.test(row.objAccount.Name));
            }
            else {
                regex = new RegExp(filterAccount, "i");
                results = data.filter(row=>regex.test(row.objAccount.Name));
            }            
        }
        else {
            if (filterAccount == '') {
                regex = new RegExp(term, "g");
                results = data.filter(row=>regex.test(row.objAccount.Name));
            }
            else {
                regex = new RegExp(filterAccount, "i");
                results = data.filter(row=>regex.test(row.objAccount.Name));
            }            
        }
        
        component.set("v.updatedListOfAccounts", results);
        
        helper.displayListData(component, results);
        
    },
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: THIS PART WILL FILTER THE DATA SHOWN IN THE DATA TABLE 
    //BASED ON THE SELECTED LETTER OF THE USER
    filterByLetter : function(component, event, helper){
        
        component.set("v.currentAlphabet", (String)(event.target.name));
        var selectedLetter = component.get("v.currentAlphabet");
        
        var data = component.get("v.listOfAllAccounts");
        var term = "^" + selectedLetter;
        var results = data;
        var regex;
        
        if (selectedLetter == 'All') {
            regex = new RegExp();
            results = data.filter(row=>regex.test(row.objAccount.Name));
        }
        else {
            regex = new RegExp(term, "g");
            results = data.filter(row=>regex.test(row.objAccount.Name));
            
        }
        
        component.set("v.updatedListOfAccounts", results);
        
        helper.displayListData(component, results);
        
    },
    //-------------------------END FUNCTIONS OF ADD FUNCTION IN GENERATE PHASE----------------------------
    
    //--------------------START OF HANDLE ONCHANGE OF DATA FILTER CHECKBOX--------------------
    
    //AUTHOR: KRIS MARIANO
    //DESCRIPTION: THIS PART HANDLES WHETHER THE SHOW ACCOUNT TEAM CHECKBOX VALUE HAS CHANGE
    handleTeamCheck : function(component, event, helper) {
        console.log('calling handleCheck');
        var isChecked = component.find("accountTeamCheckBox").get("v.checked");
        component.set("v.accountTeams", isChecked);
        console.log('isChecked',isChecked);
        helper.getAccAllocHierarchy(component,event,helper);
    },
    
    //AUTHOR: KRIS MARIANO
    //DESCRIPTION: THIS PART HANDLES WHETHER THE SHOW ACCOUNTS CHECKBOX VALUE HAS CHANGE
    handleGroupCheck : function(component, event, helper) {
        console.log('calling handleCheck');
        var isChecked = component.find("accountGroupCheckBox").get("v.checked");
        component.set("v.accountGroups", isChecked);
        console.log('isChecked',isChecked);													   
        helper.getAccAllocHierarchy(component,event,helper);
    },
    //--------------------END OF HANDLE ONCHANGE OF DATA FILTER CHECKBOX--------------------
    
    //-----------------------GET ACCOUNT DATA TO BE ADDED TO TREE GRID---------------------
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: GETS THE SELECTED ACCOUNT THAT WILL BE ADDED
    getSelectedAccount : function(component, event, helper) {
        
        helper.resetData(component);
        
        var addedAcc = component.get("v.addedAcc");
        var allocationId = component.get("v.recordId");
        
        var addList = [];
        var draftValues = event.getParam('draftValues');
        
        var x1 = 0, x2 = 0;
        
        for(var i = 0; i < draftValues.length; i++ ){
            
            if (draftValues[i].Manual__c < 0) {
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "type" : "error",
                    "message": "Allocation cannot be less than 0 or a negative value."
                });
                
                toastEvent.fire();
                
                x1 = x1 + 1;
                
            }
            else if (draftValues[i].Manual__c == 0) {
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "type" : "error",
                    "message": "Allocation cannot be 0."
                });
                
                toastEvent.fire();
                
                x1 = x1 + 1;
                
            }
            else if (draftValues[i].Manual__c % 1 != 0) {
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "type" : "error",
                    "message": "Allocation cannot be have decimal values."
                });
                
                toastEvent.fire();
                
                x1 = x1 + 1;
                
            }
            else{
                
                x2 = 1;
                
                addList.push({
                    Account__c: addedAcc[i].Id,
                    Allocation__c: allocationId,
                    Name: draftValues[i].Name,
                    Manual__c: draftValues[i].Manual__c
                });
                
            }
            
        }
        
        if (x1 <= 0 && x2 == 1) {
            
            var action = component.get("c.createAccountAllocation");
            
            action.setParams({
                "accAllocList": addList
            });
            
            $A.enqueueAction(action);
            
            var editAddManualModal = document.getElementById("editAddManualModal");
            $A.util.removeClass(editAddManualModal, 'slds-show');
            $A.util.addClass(editAddManualModal, 'slds-hide');
            
            component.set("v.addModal", false);
            
            helper.getAccAllocHierarchy(component, event, helper);
            helper.checkAllocationSuccess(component, event, helper);
            
        }
        
    }, 
    
    //-----------------REDIRECT TO ALLOCATION RECORD--------------
    
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: NAVIGATES TO ALLOCATION RECORD AFTER COMPLETING SETUP PHASE
    navigateToRecord : function(component, event){
        
        var event = $A.get( 'e.force:navigateToSObject' );
        var recId = component.get("v.recordId");
        event.setParams({
            'recordId' : recId,
            'slideDevName' : 'Detail' ,
            'isRedirect' : true
        }).fire();     
    },
    
    //-------------------------START OF HANDLING EXPORT ACTIONS------------------------------
    
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: THIS PART WILL CREATE A CSV FILE USED IN EXPORT
    downloadCsv : function(component,event,helper){
        console.log('Inside Download CSV');
        var csvFileName = component.get("v.allocRec.Name")+'_'+'Account_Allocations';
        // get the Records list from apex controller
        var action = component.get("c.getAccAllocForConversion");
        var respData;
        var csv; 
        var hiddenElement;
        console.log("action--:",action);
        action.setParams({
            allocId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('values',response.getReturnValue());
                var respData = response.getReturnValue();
                
                csv = helper.convertArrayOfObjectsToCSV(component,respData);  
                if (csv == null){return;} 
                
                // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
                var hiddenElement = document.createElement('a');
                hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                hiddenElement.target = '_self'; // 
                hiddenElement.download = csvFileName;  // CSV file Name* you can change it.[only name not .csv] 
                document.body.appendChild(hiddenElement); // Required for FireFox browser
                hiddenElement.click(); // using click() js function to download csv file
                console.log('CONVERTED');
            } else if (state === "ERROR") {
                console.log('values',response.getReturnValue());
            } 
        });  
        $A.enqueueAction(action);
    },
    
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: THIS PART WILL CREATE AN XLS FILE USED IN EXPORT
    downloadXLS : function(component,event,helper) {
        var xlsFileName = component.get("v.allocRec.Name")+'_'+'Account_Allocations';
        var action = component.get("c.getAccAllocForConversion");
        var respData;
        var csv;
        var hiddenElement;
        console.log("action--:",action);
        action.setParams({
            allocId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('values',response.getReturnValue());
                var respData = response.getReturnValue();
                
                csv = helper.convertArrayOfObjectsToXLS(component,respData);  
                if (csv == null){
                    console.log('CSV VALUE -->'+csv)
                    return;
                } 
                //Generate a file name
                var fileName = xlsFileName;
                //this will remove the blank-spaces from the title and replace it with an underscore
                //fileName += PositionTitle.replace(/ /g,"_");   
                fileName += ".xls";
                //Initialize file format you want csv or xls
                var uri = 'data:text/xls;charset=utf-8,' + encodeURIComponent(csv);
                
                if (navigator.msSaveBlob) { // IE 10+
                    console.log('----------------if-----------');
                    var blob = new Blob([csv],{type: "text/xls;charset=utf-8;"});
                    console.log('----------------if-----------'+blob);
                    navigator.msSaveBlob(blob, fileName);
                }
                else{
                    // Download file
                    // you can use either>> window.open(uri);
                    // but this will not work in some browsers
                    // or you will not get the correct file extension    
                    var link = document.createElement("a");
                    
                    //link.download to give filename with extension
                    //link.download = fileName;
                    link.setAttribute('download',fileName);
                    //To set the content of the file
                    link.href = uri;
                    
                    //set the visibility hidden so it will not effect on your web-layout
                    link.style = "visibility:hidden";
                    
                    //this part will append the anchor tag and remove it after automatic click
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                    
                }
            } else if (state === "ERROR") {
                console.log('values',response.getReturnValue());
            } 
        });  
        $A.enqueueAction(action);
    }, 
    
    //AUTHOR: MARK PALACIOS
    //DESCRIPTION: THIS PART WILL CREATE A PDF FILE USED IN EXPORT
    downloadPDF : function(component,event,helper) {
        var recordId = component.get("v.recordId");
        window.open( "/apex/UNILAB_PAL_PDFGenerator?recordId="+recordId);
        
    },
    //--------------------------END OF HANDLING EXPORT ACTIONS------------------------------
    
    //----------------------START OF Navigation (Custom DataTable For Add Account)-------------------
    
    //AUTHOR: IAN MICHAEL CRUZ
    //DESCRIPTION: NAVIGATION METHOD (PAGINATION) FOR ADD MODAL
    navigation: function(component, event, helper) {
        
        var sObjectList = component.get("v.listOfAllAccounts");
        var updatedListOfAccounts = component.get("v.updatedListOfAccounts");
        
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            if (updatedListOfAccounts.length > 0) {
                helper.next(component, event, updatedListOfAccounts, end, start, pageSize);
            }
            else {
                helper.next(component, event, sObjectList, end, start, pageSize);
            }            
        }
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            if (updatedListOfAccounts.length > 0) {
                helper.previous(component, event, updatedListOfAccounts, end, start, pageSize);
            }
            else {
                helper.previous(component, event, sObjectList, end, start, pageSize);
            }
        }
        
    },
    //----------------------END OF Navigation (Custom DataTable For Add Account)-------------------
    
    // Checkbox Select (Custom DataTable For Add Account)
    
    checkboxSelect: function(component, event, helper) {
        
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.selectedCount");
        
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
        }
        
        component.set("v.selectedCount", getSelectedNumber);
        
    }
})