({
    getEventRecord : function(cmp,helper){
        var hbOptions = ["MANILA",
            "PROVINCIAL",
            "CAVITE"
        ];
        var ohbOptions = ["ILOCOS/CAR",
            "CENTRAL LUZON",
            "BICOL",
            "CAGAYAN VALLEY",
            "SOUTH TAGALOG",
            "CENTRAL VISAYAS",
            "WEST VISAYAS",
            "EAST VISAYAS",
            "NORTH MINDANAO",
            "SOUTH MINDANAO",
            "WEST MINDANAO",
            "CENTRAL MINDANAO"
        ];
        
        cmp.set("v.Spinner", true); 
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = cmp.get("c.getEventRecord");
        var Id = cmp.get("v.recordId");
        if(Id==''){
            Id = null;
        }/*
        if(cmp.get("v.isLightningOut")===false && cmp.get('v.isQuickAction')===false){
            Id=null;
        }
        */
        cmp.set("v.recordId",Id);
        action.setParams({ recId : Id });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                //For Validated Work Plan Validation Rule
                if(Id !== null){
                    cmp.set("v.oldEventType",StoreResponse.event.Event_Type__c);
                    cmp.set("v.oldSubEventType",StoreResponse.event.Event_Sub_type__c);
                    cmp.set("v.oldIsAlldayEvent",StoreResponse.event.IsAllDayEvent);
                }
                //bind RoleName
                cmp.set("v.roleName",StoreResponse.roleName);
                //show location if Event Type is not leave/holiday
                if(StoreResponse.event.Event_Type__c ==='Leave/Holiday'){
                    cmp.set("v.isRenderLocation",false);
                }else{
                    cmp.set("v.isRenderLocation",true);
                }
                //bind Activity Matrix
                cmp.set('v.activityMatrixList',StoreResponse.activityMatrix);
                //bind Event Type & Sub-Event Type Matrix
                helper.loadEventTypes(cmp,helper,StoreResponse.eventTypes);
                
                //bind location based option
                helper.setBasedLocationOptions(cmp,StoreResponse.locations);
                //bind mode of contact option
                helper.setModeOfContactOptions(cmp,StoreResponse.modeofcontract);
                //Bind TCR Record Types
                helper.setFieldWorkRecordTypeOptions(cmp,StoreResponse.fieldWorkRecordTypes);
                //bind event
                if(cmp.get("v.unplanned")===true){
                    StoreResponse.event.Work_Plan__c = false;
                }
                //bind the user to assigned to
                if(StoreResponse.user.Id!=undefined){
                    cmp.set("v.assignedToUser",StoreResponse.user);
                    cmp.find("userLookup").showValue();
                }
                
                //bind the account to related to
                if(StoreResponse.relatedAccount.Id!=undefined){
                    cmp.set("v.relatedAccount",StoreResponse.relatedAccount);
                    cmp.find("accountLookup").showValue();
                }
                //bind the user to work with
                if(StoreResponse.event.Event_Type__c ==='Field Work' &&
                   StoreResponse.event.Event_Sub_type__c==='Training Contact'){
                    
                    if(StoreResponse.workWith.Id!=undefined){
                        cmp.set("v.workWith",StoreResponse.workWith);
                        cmp.find("workWithLookup").showValue();
                    }
                }
                //bind the contact to name
                if(StoreResponse.contactName.Id!=undefined){
                    cmp.set("v.assignedName",StoreResponse.contactName);
                    cmp.find("nameLookup").showValue();
                }
              
                cmp.set('v.eventRecord',StoreResponse.event);
       			
          
  
                //bind whoId options
               // helper.setNameOptions(cmp,StoreResponse.nameOptions);
                if(StoreResponse.event.Id!=undefined){
                    helper.readEventType(cmp,helper,StoreResponse.event.Event_Type__c);
                    helper.readSubEventType(cmp,helper,StoreResponse.event.Event_Sub_type__c);
                    //helper.readNameOptions(cmp,helper,StoreResponse.event.Event_Sub_type__c);
                }
                //bind Sub Acitivity List
                cmp.set("v.subActivityList",StoreResponse.subActivityList);                
                //bind SubActivity
                cmp.set("v.subActivity",StoreResponse.subActivity);
                //bind actJuncRemarks
                cmp.set("v.actJuncRemarks",StoreResponse.actJuncRemarks);
				//cmp.set("v.isRenderWhoId",false);
                var eventRec = cmp.get("v.eventRecord");
                var namelayoutItem = cmp.find("nameLookupLayoutItem");
                $A.util.addClass(namelayoutItem, "hideLayout");
                var whoidlayoutItem = cmp.find("workWithLookupLayoutItem");
                $A.util.addClass(whoidlayoutItem, "hideLayout");
                if(eventRec.Event_Type__c !=='Call'){
                    
                    helper.removeDisplay(cmp,helper,"accountLookupLayout",true);
                }else{
                    helper.removeDisplay(cmp,helper,"accountLookupLayout",false);
                }
                if(eventRec.Event_Type__c ==='Field Work' && eventRec.Event_Sub_type__c ==='Training Contact' 
                  && cmp.get("v.roleName") === 'Team Lead'  ){
                 	//cmp.find("workWithLookup").showValue();
                    //var namelayoutItem = cmp.find("nameLookupLayoutItem");
                    //$A.util.addClass(namelayoutItem, "hideLayout");
                    helper.removeDisplay(cmp,helper,"nameLookupLayoutItem",true);
                    helper.removeDisplay(cmp,helper,"workWithLookupLayoutItem",false);
                    //var workWithlayoutItem = cmp.find("workWithLookupLayoutItem");
                    //$A.util.removeClass(workWithlayoutItem, "hideLayout");
                }
                
                if(eventRec.Event_Type__c ==='Field Work' && eventRec.Event_Sub_type__c ==='Training Contact' 
                   && cmp.get("v.roleName") === 'CDS'  ){
                    //cmp.find("nameLookup").showValue();
                    //var layoutItem = cmp.find("workWithLookupLayoutItem");
                    //$A.util.addClass(layoutItem, "hideLayout");
                    helper.removeDisplay(cmp,helper,"workWithLookupLayoutItem",true);
                    helper.removeDisplay(cmp,helper,"nameLookupLayoutItem",false);
                    
                }
                if(eventRec.Event_Type__c ==='Field Work' && eventRec.Event_Sub_type__c ==='Training Contact' 
                   && cmp.get("v.roleName") === 'Administrator'  ){
                    //var workWithlayoutItem = cmp.find("workWithLookupLayoutItem");
                    //$A.util.removeClass(workWithlayoutItem, "hideLayout");
                    helper.removeDisplay(cmp,helper,"workWithLookupLayoutItem",false);
                    //var namelayoutItem = cmp.find("nameLookupLayoutItem");
                    //$A.util.removeClass(namelayoutItem, "hideLayout");
                    helper.removeDisplay(cmp,helper,"nameLookupLayoutItem",false);
                    cmp.find("workWithLookup").set("v.required",false);
                }
                if(eventRec.Event_Type__c !=='Field Work' && eventRec.Event_Sub_type__c !=='Training Contact'){
                    //cmp.find("workWithLookup").showValue();
                    
                    //var namelayoutItem = cmp.find("nameLookupLayoutItem");
                    //$A.util.removeClass(namelayoutItem, "hideLayout");
                    helper.removeDisplay(cmp,helper,"nameLookupLayoutItem",true);
                    //var layoutItem = cmp.find("workWithLookupLayoutItem");
                   // $A.util.addClass(layoutItem, "hideLayout");
                    helper.removeDisplay(cmp,helper,"workWithLookupLayoutItem",true);
                    if(eventRec.Event_Sub_type__c !=='FIELD WORK' && eventRec.Event_Type__c ==='Call'){
                        cmp.find("nameLookup").set("v.required",false);
                        cmp.find("accountLookup").set("v.required",true);
                    }
                }
                
                
                
                cmp.set("v.Spinner", false); 
                
            }
            else if (state === "INCOMPLETE") {
                // do something
                
                
            }
                else if (state === "ERROR") {
                    
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            helper.locationbasedValue(cmp, event, helper);
        }); 
        
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
    loadEventTypes : function(cmp,helper,StoreResponse) {
        
        // once set #StoreResponse to depnedentFieldMap attribute 
        cmp.set("v.eventTypeFieldMap", StoreResponse);
        
        // create a empty array for store map keys(@@--->which is controller picklist values) 
        
        var listOfkeys = []; // for store all map keys (controller picklist values)
        var ControllerField = []; // for store controller picklist value to set on ui field. 
        
        // play a for loop on Return map 
        // and fill the all map key on listOfkeys variable.
        /*
        var initkey = {
            "label": "--- None ---",
            "value": "--- None ---",
        };
        listOfkeys.push(initkey);
        */
        for (var singlekey in StoreResponse) {
            
            var key = {
                "label": singlekey,
                "value": singlekey,
            };
            listOfkeys.push(key);
        }
        
        cmp.find("eventtype").set('v.options',listOfkeys);
        
        
    },
    loadSubEventTypes : function(cmp, ListOfDependentFields) {
        
        // create a empty array var for store dependent picklist values for controller field)  
        var dependentFields = [];
        /*
        if (ListOfDependentFields != undefined && ListOfDependentFields.length > 0) {
            dependentFields.push({
                "label": "--- None ---",
                "value": "--- None ---"
            });
            
        }
        */
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push({
                label: ListOfDependentFields[i],
                value: ListOfDependentFields[i]
            });
        }
        // set the dependentFields variable values to State(dependent picklist field) on ui:inputselect    
        cmp.find('eventsubtype').set("v.options", dependentFields);
        // make disable false for ui:inputselect field 
        cmp.set("v.isEventSubTypeDisable", false);
    },
    setLocationOptions : function(cmp,StoreResponse){
        
        var listOfkeys = []; // for store all map keys (controller picklist values)
        
        // play a for loop on Return map 
        // and fill the all map key on listOfkeys variable.
        // 
        for(var i = 0 ; i< StoreResponse.length;i++){
            var key = {
                "label": StoreResponse[i],
                "value": StoreResponse[i],
            };
            listOfkeys.push(key);
        }
        
        
        cmp.set('v.locationoptions',listOfkeys);
    },
    setBasedLocationOptions : function(cmp,StoreResponse){
        
        var listOfkeys = []; // for store all map keys (controller picklist values)
        
        // play a for loop on Return map 
        // and fill the all map key on listOfkeys variable.
        // 
        for(var i = 0 ; i< StoreResponse.length;i++){
            var key = {
                "label": StoreResponse[i],
                "value": StoreResponse[i],
            };
            listOfkeys.push(key);
        }
        
        
        cmp.set('v.locationbasedoptions',listOfkeys);
        //cmp.set('v.eventRecord.Location_Based__c','--- None ---');
    },
    
    setModeOfContactOptions : function(cmp,StoreResponse){
        
        var listOfkeys = []; // for store all map keys (controller picklist values)
        
        // play a for loop on Return map 
        // and fill the all map key on listOfkeys variable.
        // 
        for(var i = 0 ; i< StoreResponse.length;i++){
            var key = {
                "label": StoreResponse[i],
                "value": StoreResponse[i],
            };
            listOfkeys.push(key);
        }
        
        
        cmp.set('v.modeofcontact',listOfkeys);
        //cmp.set('v.eventRecord.Location_Based__c','--- None ---');
    },
    
    setFieldWorkRecordTypeOptions : function(cmp,StoreResponse){
        
        var listOfkeys = []; // for store all map keys (controller picklist values)
        
        // play a for loop on Return map 
        // and fill the all map key on listOfkeys variable.
        // 
        for(var i = 0 ; i< StoreResponse.length;i++){
            var key = {
                "label": StoreResponse[i].Name,
                "value": StoreResponse[i].Id,
            };
            listOfkeys.push(key);
            
        }
        
        cmp.set("v.tcrRecordTypes", listOfkeys);
        //cmp.set('v.eventRecord.Location_Based__c','--- None ---');
    },
    setNameOptions : function(cmp,StoreResponse){
        
        var listOfkeys = []; // for store all map keys (controller picklist values)
        
        // play a for loop on Return map 
        // and fill the all map key on listOfkeys variable.
        for(var i = 0 ; i< StoreResponse.length;i++){
            if(i==0){
                cmp.find("whoId").set('v.value',StoreResponse[i]); 
            }
            var key = {
                "label": StoreResponse[i],
                "value": StoreResponse[i],
            };
            listOfkeys.push(key);
        }
        
        
        cmp.find("whoId").set('v.options',listOfkeys);
        
    },
    readEventType : function(cmp,helper,eventType){
        cmp.set("v.isEventSubType", false);
        var eventRecord = cmp.get("v.eventRecord");
        eventRecord.Event_Type__c = eventType;
        cmp.set("v.eventRecord",eventRecord);
        
        // get the map values   
        var Map = cmp.get("v.eventTypeFieldMap");
        
        // check if selected value is not equal to None then call the helper function.
        // if controller field value is none then make dependent field value is none and disable field
        if (eventType != '--- None ---') {
            
            // get dependent values for controller field by using map[key].  
            // for i.e "India" is controllerValueKey so in the map give key Name for get map values like 
            // map['India'] = its return all dependent picklist values.
            var ListOfDependentFields = Map[eventType];
            helper.loadSubEventTypes(cmp, ListOfDependentFields);
            
        } else {
            var defaultVal = [{
                "label": "--- None ---",
                "value": "--- None ---",
            }];
            
            cmp.find('eventsubtype').set("v.options", defaultVal);
            cmp.set("v.isEventSubTypeDisable", true);
        }
        
        
        var selectedOptionValue = cmp.find('eventsubtype').get('v.value');
        if(eventType === "Call" ){
            cmp.set("v.isEventSubTypeCall",true);
        }
        else{
            
            cmp.set("v.isEventSubTypeCall",false);
        }
    },
    readSubEventType : function(cmp,helper,selectedOptionValue){
        cmp.set("v.isEventSubType", false);
        var eventType = cmp.find("eventtype").get("v.value");
        cmp.set("v.subActivityList",[]);
        var eventRecord = cmp.get("v.eventRecord");
        eventRecord.Event_Sub_type__c = selectedOptionValue;
        cmp.set("v.eventRecord",eventRecord);
        var eventType= cmp.find("eventtype").get("v.value");
        if((eventType==="Admin Work" || eventType === "Call" || eventType ==="Field Work" || eventType ==="Meeting"
            || eventType ==="POC Special Activity" || eventType ==="Special Activity/Partnering" ) && selectedOptionValue!== "--- None ---"){
            if(eventType === "Call" ){
                
                cmp.set("v.isEventSubTypeCall",true);
            }
            else{
                cmp.set("v.isEventSubTypeCall",false);  
            }
            
            cmp.set("v.isEventSubType", false);
            cmp.set("v.isEventSubType", true);
            
            
        }
        else{
            cmp.set("v.isEventSubTypeCall",false);
            cmp.set("v.isEventSubType", false);
        }
    },
    readNameOptions : function(cmp,helper,selectedOptionValue){
        cmp.set("v.isRenderWhoId","false");
        cmp.set("v.isRenderWhoId","true");
        cmp.set("v.whoIDOption",selectedOptionValue);
    },
    validationRule_Event_Required_Fields_on_Create_Edit : function (cmp){
        var EventType = cmp.find("eventtype");
        var SubEventType = cmp.find("eventsubtype");
        EventType.reportValidity();
        SubEventType.reportValidity();
        if(EventType.get("v.validity").valid === true && SubEventType.get("v.validity").valid === true){
            return true;
        }
        return false;
    },
    validationRule_AssignedTo : function (cmp){
        var userLookup = cmp.find("userLookup");
        var assignedUser = cmp.get("v.assignedToUser");
        if(assignedUser.Id === undefined){
            userLookup.showErrorMessage(true);
            return false;
        }  
        userLookup.showErrorMessage(false);
        return true;
    },
    validationRule_Require_Account_for_Calls : function (cmp){
        var accountLookup = cmp.find("accountLookup");
        var relatedAccount = cmp.get("v.relatedAccount");
        if(relatedAccount.Id === undefined){
            accountLookup.showErrorMessage(true);
            return false;
        }  
        accountLookup.showErrorMessage(false);
        return true;
    },
    validationRule_Require_TL_TrainingContact_workWith : function (cmp){
        var workWithLookup = cmp.find("workWithLookup");
        var workWith = cmp.get("v.workWith");
        if(workWith.Id === undefined){
            workWithLookup.showErrorMessage(true);
            return false;
        }  
        workWithLookup.showErrorMessage(false);
        return true;
    },
    validationRule_Require_CDS_TrainingContact_workWith : function (cmp){
         var WhoID = cmp.find("nameLookup");
        var assignedName = cmp.get("v.assignedName");
        if( assignedName.Id === undefined){
            WhoID.showErrorMessage(true);
            return false;
        }  
        WhoID.showErrorMessage(false);
        return true;
    },
    validationRule_Require_Contact_For_SubType_FieldWork : function (cmp){
        var WhoID = cmp.find("nameLookup");
        var assignedName = cmp.get("v.assignedName");
        if( assignedName.Id === undefined){
            WhoID.showErrorMessage(true);
            return false;
        }  
        WhoID.showErrorMessage(false);
        return true;
    },
    validationRule_Require_Remarks_Analaysis_Insights : function (cmp){
        
        if(cmp.get("v.actJuncRemarks")!==undefined){
            
            return true;
        }
        cmp.find("subEventTypeForm").requireRemarksAnalysisInsights();
        return false;
    },
    validationRule_Require_DiscussionsAgreements : function (cmp){
       return cmp.find("subEventTypeForm").requireDiscussionsAgreements();
    },
    validationRule_ActivityDate : function(cmp,eventRec){
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1; //January is 0!
        var yyyy = today.getFullYear();
        
        if(dd<10) {
            dd = '0'+dd
        } 
        
        if(mm<10) {
            mm = '0'+mm
        } 
        var activityDate = eventRec.EndDateTime.split("T");
        today = yyyy + '-' + mm + '-' + dd;
        if(activityDate[0] > today){
            
            cmp.set("v.errorMessage","This event cannot be set to completed prior to scheduled date.");
            return false;
        }
        return true;
        
    },
    validationRule_Require_LocationBased : function(cmp){
        
        //var location = cmp.find("locationcustom");
        var locationbased = cmp.find("locationbased");
       // location.reportValidity();
        locationbased.reportValidity();
        if(locationbased.get("v.validity").valid === true){
            return true;
        }
        return false;
    },
    
    validationRule_Require_Location : function(cmp){
        
        //var location = cmp.find("locationcustom");
        var locationbased = cmp.find("locationcustom");
       // location.reportValidity();
        locationbased.reportValidity();
        if(locationbased.get("v.validity").valid === true){
            return true;
        }
        return false;
    },
    
    validationRule_Require_ModeOfContact : function(cmp,eventRec){
        
        if(eventRec.Mode_of_Contact__c !== undefined){
            return true;
        }else{
            cmp.set("v.errorMessage","Complete Mode Of Contact field.");
            return false;
        }
        
       /* var modeofcontact = cmp.find("modeofcon");
        modeofcontact.reportValidity();
        if(modeofcontact.get("v.validity").valid === true){
            return true;
        }
        return false;
        
        //kc
        var modeofcontact = cmp.find("modeofcon");
        modeofcontact.reportValidity();
        if(modeofcontact.get("v.validity").valid === true){
            return true;
        }
        return false;*/
    },
    
    validationRule_Require_TCR_RecordType : function(cmp){
        var tcrRecordType = cmp.find("TCRRecordType");
        tcrRecordType.reportValidity();
        if(tcrRecordType.get("v.validity").valid === true){
            return true;
        }
        return false;
    },
    validateForm : function(cmp,eventRec,helper,type){
        
        if (type==="Cancel"){
            return true;
        }
        
        cmp.set("v.showErrorMessage",false);
        cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Message"));
        var valid = 0;
        var numberOfValidation = 3;
        
        //Check Meeting Disucussion and Agreement
        if(cmp.get("v.recordId")!=null && type==='Complete'){
            if(cmp.get("v.subActivityList").length > 0){
                if(eventRec.Event_Type__c ==='Meeting'){
                    numberOfValidation++;
                    if(helper.validationRule_Require_DiscussionsAgreements(cmp)){
                        
                        valid++;
                    }
                }
            }
        }
        //TCR requirements
        if(eventRec.Event_Type__c ==='Field Work' && eventRec.Event_Sub_type__c === 'Training Contact'){
            numberOfValidation++;
            var role = cmp.get("v.roleName");
            
            if(eventRec.Field_Work_Record_Type__c!==null || eventRec.Field_Work_Record_Type__c!==''){
                numberOfValidation++;
                
                if(helper.validationRule_Require_TCR_RecordType(cmp)){
                    valid++;
                }
            }
            if(role ==='Team Lead'){
                if(helper.validationRule_Require_TL_TrainingContact_workWith(cmp)){
                    valid++;
                }
            }else if(role==="CDS"){
                if(helper.validationRule_Require_CDS_TrainingContact_workWith(cmp)){
                    valid++;
                }
            }else if(role==="Administrator"){
                valid++;
            }
            
            
        }
        
        //Add Validation if Complete Event : Required Field: Remarks/Analysis/Insights
        if(type==="Complete"){
            
            numberOfValidation++;

            if(helper.validationRule_ActivityDate(cmp,eventRec)===true){
                valid++;
            }
            
            if(eventRec.Event_Type__c ==='Call' ){
                
                numberOfValidation++;
                if(helper.validationRule_Require_Remarks_Analaysis_Insights(cmp)===true){
                    valid++; 
                    
                }
            }
            
            numberOfValidation++;
            if(helper.validationRule_Require_ModeOfContact(cmp,eventRec) === true){
                valid++;
            }
            
            numberOfValidation++;
            if(helper.validationRule_Require_Location(cmp)===true){
                valid++;
            }
            
        }else if(type==="Cancel"){
            if(eventRec.Event_Type__c ==='Call' ){
                
                numberOfValidation++;
                if(helper.validationRule_Require_Remarks_Analaysis_Insights(cmp)===true){
                    
                    valid++; 
                    
                }
            }
        }
        
        //Check Assigned To
        if(helper.validationRule_AssignedTo(cmp) === true){
            valid++;
        }
        //Check Event Type & Sub Event Type
        if(helper.validationRule_Event_Required_Fields_on_Create_Edit(cmp)===true){
            valid++;
        }
        
        //Check Location Based & Location
        if(eventRec.Event_Type__c && eventRec.Event_Type__c!=="Leave/Holiday"){
            numberOfValidation++;
            if(helper.validationRule_Require_ModeOfContact(cmp,eventRec) === true){
                valid++;
            }
            numberOfValidation++;
            if(helper.validationRule_Require_LocationBased(cmp)===true){
                valid++;
            }
            numberOfValidation++;
            if(helper.validationRule_Require_Location(cmp)===true){
                valid++;
            }
        }
        
        //Contact is required if Sub-Event Type is Field Work
        if(eventRec.Event_Sub_type__c ==='FIELD WORK' && eventRec.Event_Type__c ==='Call'){
            if(helper.validationRule_Require_Contact_For_SubType_FieldWork(cmp) === true){
                valid++;
            }
        }
        //Account is required for Call activities.
        else if(eventRec.Event_Sub_type__c !=='FIELD WORK' && eventRec.Event_Type__c ==='Call'){
            if(helper.validationRule_Require_Account_for_Calls(cmp) === true){
                valid++;
            }
        }
            else{
                var accountLookup = cmp.find("accountLookup");
                //var WhoID = cmp.find("nameLookup");
                accountLookup.showErrorMessage(false);
               // if(WhoID==undefined){
                //    WhoID.showErrorMessage(false);
                //}
                numberOfValidation--;
            }
        
        if(valid === numberOfValidation){
            return true;
        }
        
        cmp.set("v.showErrorMessage",true);
        return false;
    },
    showSuccessToast : function(component, event, helper) {
        var showToast = $A.get("e.force:showToast"); 
        showToast.setParams({ 
            'title' : 'Save Success', 
            'message' : 'The workplan has been saved sucessfully.' 
        }); 
        showToast.fire(); 
    },
    saveEvent : function(cmp,helper,type){

        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var sobjectEvent=$A.get("e.force:navigateToSObject");
        var eventRec = cmp.get("v.eventRecord");
        var subactivityListRec = cmp.get("v.subActivityList");
        var actJuncRemarksRec = cmp.get("v.actJuncRemarks");
        var roleName = cmp.get("v.roleName");
        var status = false;
        //bind 'Contact' to eventRec
        if((eventRec.Event_Type__c === 'Field Work' && eventRec.Event_Sub_type__c  === 'Training Contact') 
           && (roleName==="CDS" || roleName==="Administrator")){
            if(cmp.get("v.assignedName").Id!==undefined){
                eventRec.WhoId = cmp.get("v.assignedName").Id;
            }else{
                eventRec.WhoId = '';
            }
        }else if(eventRec.Event_Type__c !== 'Field Work' && eventRec.Event_Sub_type__c  !== 'Training Contact'){
            
            if(cmp.get("v.assignedName").Id!==undefined){
                eventRec.WhoId = cmp.get("v.assignedName").Id;
            }else{
                eventRec.WhoId = '';
            }
        }
        //bind 'Work With' To eventRec
        if(eventRec.Event_Type__c === 'Field Work' && eventRec.Event_Sub_type__c  === 'Training Contact' && roleName==="Team Lead"){
            if(cmp.get("v.workWith").Id!==undefined){
                eventRec.Work_With_ID__c = cmp.get("v.workWith").Id;
                eventRec.Work_With_Name__c = cmp.get("v.workWith").Name;
                eventRec.WhoId = '';
            }
            else{
                eventRec.Work_With_ID__c = '';
            }
            
        }else if(eventRec.Event_Type__c === 'Field Work' && eventRec.Event_Sub_type__c  === 'Training Contact' && roleName==="Administrator"){

            if(cmp.get("v.workWith").Id!==undefined){
                eventRec.Work_With_ID__c = cmp.get("v.workWith").Id;
                eventRec.Work_With_Name__c = cmp.get("v.workWith").Name;
            }
            else{
                eventRec.Work_With_ID__c = '';
                eventRec.Work_With_Name__c = '';
            }
            
        }
        else{
            eventRec.Work_With_ID__c = '';
            eventRec.Work_With_Name__c = '';
        }
   
        //bind 'Assigned To' to eventRec
        if(cmp.get("v.assignedToUser").Id!==undefined){
            eventRec.OwnerId = cmp.get("v.assignedToUser").Id;
        }
        else{
            eventRec.OwnerId = undefined;
        }
       
        //bind 'Related To' to eventRec
        if(eventRec.Event_Type__c === 'Field Work' || eventRec.Event_Type__c === 'Call'){
            if(cmp.get("v.relatedAccount").Id!==undefined){
                eventRec.Related_To_Account__c  = cmp.get("v.relatedAccount").Id;
            }
            else{
                eventRec.Related_To_Account__c = undefined;
            }
        }else{
            eventRec.Related_To_Account__c = undefined;
        }
        
        status = helper.validateForm(cmp,eventRec,helper,type);
        if(status===true){
            cmp.set("v.showActivitySurveyRating",false); 
            cmp.set("v.showSaveAndNewTaskModal",false);
            cmp.set("v.showErrorMessage",false);
            cmp.set("v.Spinner", true); 
                    
            var action = cmp.get("c.saveEventRecord");
            
            if(type==="Complete"){
    
                action =  cmp.get("c.completeEventRecord");
            }
            else if(type==="Clone"){
                action =  cmp.get("c.cloneEventRecord");
                
                /* 
                  REMOVE EXISTING SUB ACTIVITY ID AND SET ACTIVITY JUNCTION ID TO BLANK
                  IN ORDER TO CREATE A NEW ACTIVITY JUNCTION
                */                
                for (var i = 0; i < subactivityListRec.length; i++) {
                    subactivityListRec[i]['Activity_Junction__c'] = null;
                    delete subactivityListRec[i]['Id'];
               }
            }
            else if(type==='Cancel'){
                action= cmp.get("c.cancelEventRecord");
            }
            else if(type==='New Task'){

                action= cmp.get("c.saveAndNewTask");
            }
            
            action.setParams({ eventRecord : eventRec,subActivityListString:JSON.stringify(subactivityListRec) ,actJuncRemarks :actJuncRemarksRec });
            
            // Create a callback that is executed after 
            // the server-side action returns
            action.setCallback(this, function(response) {
                cmp.set("v.showErrorMessage",false);
                var state = response.getState();
                
                if (state === "SUCCESS") {
                  	
                    var StoreResponse = response.getReturnValue();
                    /*
                    if(StoreResponse.length>20){
                        alert(StoreResponse);
                        return;
                    }
                    */
                    if(StoreResponse === 'SubActivity No Access'){
                        cmp.set("v.errorMessage",'You do not have access to this Event. Please Contact your Administrator.');
                        cmp.set("v.showErrorMessage",true);
                        return;
                    }
                    if(StoreResponse === 'Cancel Error'){
                        cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Cancelled"));
                        cmp.set("v.showErrorMessage",true);
                        return;
                    }
                    if(StoreResponse === null){
                        cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Contact_Admin_Error"));
                        cmp.set("v.showErrorMessage",true);
                        return;
                    }
                    //helper.showSuccessToast(cmp,event,helper);
                  
                    if(type==="New Task"){
                        if(cmp.get("v.isLightningOut")===true ){
                            cmp.set("v.showNotifToast",true);
                            cmp.set("v.toastMessage", $A.get("$Label.c.Work_Plan_Toast_Completed")); 
                            var updateEvent = $A.get("e.c:UNILAB_LEX_ActivityManagementVF_Event");
                            updateEvent.setParams({"recordId": StoreResponse, "actionType": type});
                            updateEvent.fire();
                        }else{
                            var createRecordEvent = $A.get("e.force:createRecord");
                            createRecordEvent.setParams({
                                "entityApiName": "Task"
                            });
                            createRecordEvent.fire();
                            cmp.set("v.Spinner", true); 
                            /*
                            $A.get("e.force:navigateToURL").setParams({ 
                                "url": '/00T/e?retURL='+StoreResponse
                            }).fire();
                            */
             
                          
                        }
                    }
                    else if(type==='Cancel'){
                        //cmp.set("v.showNotifToast",true);
                        if(cmp.get("v.isLightningOut")===true){
                            var updateEvent = $A.get("e.c:UNILAB_LEX_ActivityManagementVF_Event");
                            updateEvent.setParams({"recordId": StoreResponse, "actionType": type});
                            updateEvent.fire();
                        }else{
                            $A.get("e.force:navigateToURL").setParams({ 
                                "url": '/apex/UNILAB_EventCancellationPage?id='+StoreResponse 
                            }).fire();
                        }
                        cmp.set("v.Spinner", false); 
                    }
                        else if(type==="Save"||type==='Complete'){
                            if(type==="Complete"){
                                cmp.set("v.toastMessage", $A.get("$Label.c.Work_Plan_Toast_Completed")); 
                            }else{
                                cmp.set("v.toastMessage", $A.get("$Label.c.Work_Plan_Toast_Saved"));  
                            }
              
                            if(cmp.get("v.isLightningOut")===true ){
                                cmp.set("v.showNotifToast",true);
                                var updateEvent = $A.get("e.c:UNILAB_LEX_ActivityManagementVF_Event");
                                updateEvent.setParams({"recordId": StoreResponse, "actionType": type});
                                updateEvent.fire();
                            }else{
                                var message = '';
                                if(type==='Save'){
                                    message= $A.get("$Label.c.Work_Plan_Toast_Saved");
                                }else if(type==='Complete'){
                                    message= $A.get("$Label.c.Work_Plan_Toast_Completed");
                                }
                                if(cmp.get('v.isQuickAction')===true){
                                    $A.get("e.force:closeQuickAction").fire()
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        mode: 'sticky',
                                        type: 'success',
                                        message: message,
                                        messageTemplate: message + ', View {0}',
                                        messageTemplateData: [{
                                            url: '/'+StoreResponse,
                                            label: 'here',
                                        }
                                                             ]
                                    });
                                    toastEvent.fire();
                                }else{
                                    var navEvt = $A.get("e.force:navigateToSObject");
                                    navEvt.setParams({
                                        "recordId": StoreResponse,
                                        "slideDevName": "detail"
                                    });
                                    navEvt.fire(); 
                                    
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        mode: 'pester',
                                        type: 'success',
                                        message: message,
                                        messageTemplate: message,
                                        duration:' 3000'
                                    });
                                    toastEvent.fire();
                                }
                               
                              
                                
                            }
                            
                            
                        }else if(type==="Clone"){
                           
                            cmp.set("v.Spinner", false); 
                 
                            if(cmp.get("v.isLightningOut")===true){
                                cmp.set("v.showNotifToast",true);
                                cmp.set("v.toastMessage", $A.get("$Label.c.Work_Plan_Toast_Cloned")); 
                                setTimeout(function(){
                                    cmp.set("v.showNotifToast",false);
                                }, 5000);
                            }else{
                                $A.get("e.force:closeQuickAction").fire()
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    mode: 'sticky',
                                    type: 'success',
                                    message: $A.get("$Label.c.Work_Plan_Toast_Cloned"),
                                    messageTemplate: $A.get("$Label.c.Work_Plan_Toast_Cloned") + ', View {0}',
                                    messageTemplateData: [{
                                        url: '/'+StoreResponse,
                                        label: 'here',
                                    }
                                                         ]
                                });
                                toastEvent.fire();
                                
                            }
                        }
                            else{
                                cmp.set("v.showNotifToast",true);
                                cmp.set("v.Spinner", false); 
                                setTimeout(function(){
                                    cmp.set("v.showNotifToast",false);
                                }, 5000);
                            }
                }
                else if (state === "INCOMPLETE") {
                    // do something
                    
                    cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Contact_Admin_Error"));
                    cmp.set("v.showErrorMessage",true);
                    return;
                    
                }
                    else if (state === "ERROR") {
                        
                        cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Contact_Admin_Error"));
                        cmp.set("v.showErrorMessage",true);
                        return;
                    }
            }); 
            // optionally set storable, abortable, background flag here
            
            // A client-side action could cause multiple events, 
            // which could trigger other events and 
            // other server-side action calls.
            // $A.enqueueAction adds the server-side action to the queue.
  
            $A.enqueueAction(action);
        }
        else{
            cmp.set("v.showErrorMessage",true);
        }  
    },
    removeDisplay : function(cmp,helper,cmpName,status){
        var layoutItem = cmp.find(cmpName);
        if(status===true){
            $A.util.addClass(layoutItem, "hideLayout");
        }else{
            $A.util.removeClass(layoutItem, "hideLayout");
        }
    },
    locationbasedValue: function(component, event, helper) {
        var hbOptions = ["MANILA",
            "PROVINCIAL",
            "CAVITE"
        ];
        var ohbOptions = ["ILOCOS/CAR",
            "CENTRAL LUZON",
            "BICOL",
            "CAGAYAN VALLEY",
            "SOUTH TAGALOG",
            "CENTRAL VISAYAS",
            "WEST VISAYAS",
            "EAST VISAYAS",
            "NORTH MINDANAO",
            "SOUTH MINDANAO",
            "WEST MINDANAO",
            "CENTRAL MINDANAO"
        ];
        var locationbased = component.get("v.eventRecord.Location_Based__c");
        
        if(locationbased == "Home Base") {
            helper.setLocationOptions(component, hbOptions);
        } else if(locationbased == "Out of Home Base") {
            helper.setLocationOptions(component, ohbOptions);
        }
    }
})