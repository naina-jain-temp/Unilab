({
    doInit: function (cmp, event, helper) {
        
        helper.getEventRecord(cmp,helper);
    },
    handleEventTypeChange: function (cmp, event,helper) {
        
        // get the selected value
        var eventType = event.getSource().get("v.value");
        var eventRec = cmp.get("v.eventRecord");
        helper.readEventType(cmp,helper,eventType);
        eventRec.Event_Sub_type__c ='';
        if(eventType==='Call'){
            helper.removeDisplay(cmp,helper,"accountLookupLayout",false);
        }else{
            helper.removeDisplay(cmp,helper,"accountLookupLayout",true);
        }
        var accountLookup = cmp.find("accountLookup");
        accountLookup.showErrorMessage(false);
        
        if(eventType ==='Leave/Holiday'){
            eventRec.Location_Based__c = '';
            eventRec.Location_Custom__c = '';
            cmp.set("v.isRenderLocation",false);
            
        }else{
            //eventRec.Location_Based__c = '';
            //eventRec.Location_Custom__c = '';
            cmp.set("v.isRenderLocation",true);
        }
        
        if(eventRec.Event_Type__c !== 'Field Work'){
            if(cmp.get("v.assignedName").Id!==undefined){
                cmp.find("nameLookup").showValue();
            }
        }
        cmp.set("v.eventRecord",eventRec);
        
        
    },
    handleSubEventTypeChange: function (cmp, event,helper) {
        
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        helper.readSubEventType(cmp,helper,selectedOptionValue);
        var eventRec = cmp.get("v.eventRecord");
        var roleName = cmp.get("v.roleName");
        //remove whoID value
        if((eventRec.Event_Type__c === 'Field Work' && eventRec.Event_Sub_type__c  === 'Training Contact') 
           && roleName==="CDS" ){
            
            //var layoutItem = cmp.find("nameLookupLayoutItem");
            //$A.util.removeClass(layoutItem, "hideLayout");
            helper.removeDisplay(cmp,helper,"nameLookupLayoutItem",false);
            cmp.find("nameLookup").set("v.required",true);
            if(cmp.get("v.assignedName").Id!==undefined){
                cmp.find("nameLookup").showValue();
            }
        }
        if((eventRec.Event_Type__c === 'Field Work' && eventRec.Event_Sub_type__c  === 'Training Contact') 
           && roleName==="Team Lead" ){
            
            //var workWIthlayoutItem = cmp.find("workWithLookupLayoutItem");
            //$A.util.removeClass(workWIthlayoutItem, "hideLayout");
            helper.removeDisplay(cmp,helper,"workWithLookupLayoutItem",false);
            //var namelayoutItem = cmp.find("nameLookupLayoutItem");
            //$A.util.addClass(namelayoutItem, "hideLayout");
            helper.removeDisplay(cmp,helper,"nameLookupLayoutItem",true);
            cmp.find("workWithLookup").set("v.required",true);
            if(cmp.get("v.workWith").Id!==undefined){
                cmp.find("workWithLookup").showValue();
            }
            
        }
        if((eventRec.Event_Type__c === 'Field Work' && eventRec.Event_Sub_type__c  === 'Training Contact') 
           && roleName==="Administrator" ){
            cmp.find("workWithLookup").set("v.required",false);
            cmp.find("nameLookup").set("v.required",false);
            //var workWIthlayoutItem = cmp.find("workWithLookupLayoutItem");
            //$A.util.removeClass(workWIthlayoutItem, "hideLayout");
            helper.removeDisplay(cmp,helper,"workWithLookupLayoutItem",false);
            //var namelayoutItem = cmp.find("nameLookupLayoutItem");
            //$A.util.removeClass(namelayoutItem, "hideLayout");
            helper.removeDisplay(cmp,helper,"nameLookupLayoutItem",false);
            if(cmp.get("v.assignedName").Id!==undefined){
                
                cmp.find("nameLookup").showValue();
            }
            if(cmp.get("v.workWith").Id!==undefined){
                
                cmp.find("workWithLookup").showValue();
            }
        }
        
        if(eventRec.Event_Type__c !== 'Field Work' && eventRec.Event_Sub_type__c  !== 'Training Contact'){
            
            //var layoutItem = cmp.find("nameLookupLayoutItem");
            //$A.util.removeClass(layoutItem, "hideLayout");
            helper.removeDisplay(cmp,helper,"nameLookupLayoutItem",true);
            //var workWithlayoutItem = cmp.find("workWithLookupLayoutItem");
            //$A.util.addClass(workWithlayoutItem, "hideLayout");
            helper.removeDisplay(cmp,helper,"workWithLookupLayoutItem",true);
            if(cmp.get("v.assignedName").Id!==undefined){
                cmp.find("nameLookup").showValue();
            }
            if(eventRec.Event_Sub_type__c !=='FIELD WORK' && eventRec.Event_Type__c ==='Call'){
                cmp.find("nameLookup").set("v.required",false);
                cmp.find("accountLookup").set("v.required",true);
            }
        }
        //remove error message on lookup
        if(eventRec.Event_Sub_type__c ==='FIELD WORK' && eventRec.Event_Type__c ==='Call'){
            var WhoID = cmp.find("nameLookup");
            WhoID.showErrorMessage(false);
            WhoID.set("v.required",true);
        }
        else if(eventRec.Event_Type__c !=='Field Work' && eventRec.Event_Sub_type__c !=='Training Contact'){
            var WhoID = cmp.find("nameLookup");
            WhoID.showErrorMessage(false);
            WhoID.set("v.required",false);
        }
        if(eventRec.Event_Sub_type__c !=='FIELD WORK' && eventRec.Event_Type__c ==='Call'){
            
            var accountLookup = cmp.find("accountLookup");
            //accountLookup.showErrorMessage(false);
            accountLookup.set("v.required",true);
        }
        else{
            var accountLookup = cmp.find("accountLookup");
            accountLookup.showErrorMessage(false);
            accountLookup.set("v.required",false);
            
            
        }
        
    },
    handleNameChange : function(cmp, event,helper){
        var selectedOptionValue = event.getParam("value");
        helper.readNameOptions(cmp,helper,selectedOptionValue);
        
    },
    saveEvent : function(cmp,event,helper){
        var eventRec = cmp.get("v.eventRecord");
        
        if(eventRec.Status__c ==='Completed'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Completed"));
            cmp.set("v.showErrorMessage",true);
            
        }else if(eventRec.Status__c ==='Cancelled'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Cancelled"));
            cmp.set("v.showErrorMessage",true);
            
        }
            else if((eventRec.Validated__c===true && cmp.get("v.roleName")!=='Administrator') &&(cmp.get("v.oldEventType")!==eventRec.Event_Type__c||cmp.get("v.oldSubEventType")!==eventRec.Event_Sub_type__c||cmp.get("v.oldIsAlldayEvent")!==eventRec.IsAllDayEvent)){
                cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Change_Validated_Work_Plan"));
                cmp.set("v.showErrorMessage",true);
            }else{
                
                var type = "Save";
                helper.saveEvent(cmp,helper,type);
            }
    },
    cloneEvent : function(cmp,event,helper){
        var eventRec = cmp.get("v.eventRecord");
        if(eventRec.Status__c ==='Completed'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Completed"));
            cmp.set("v.showErrorMessage",true);
            
        }else if(eventRec.Status__c ==='Cancelled'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Cancelled"));
            cmp.set("v.showErrorMessage",true);
            
        }else{        
            var type = "Clone";
            helper.saveEvent(cmp,helper,type);
        }
    },
    showActivitySurveyRating : function(cmp,event,helper){
        var eventRec = cmp.get("v.eventRecord");
        
        if(eventRec.Status__c ==='Completed'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Completed"));
            cmp.set("v.showErrorMessage",true);
         ;
        }else if((eventRec.Validated__c===true && cmp.get("v.roleName")!=='Administrator') &&(cmp.get("v.oldEventType")!==eventRec.Event_Type__c||cmp.get("v.oldSubEventType")!==eventRec.Event_Sub_type__c||cmp.get("v.oldIsAlldayEvent")!==eventRec.IsAllDayEvent)){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Change_Validated_Work_Plan"));
            cmp.set("v.showErrorMessage",true);
        }else if(eventRec.Status__c ==='Cancelled'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Cancelled"));
            cmp.set("v.showErrorMessage",true);
            
        }
        
            else{        
                var eventRec = cmp.get("v.eventRecord");
                var type="Complete";
                var status = helper.validateForm(cmp,eventRec,helper,type);
                
                if(status===true){
                    cmp.set("v.showActivitySurveyRating",true);
                }
            }
    },
    cancelShowActivitySurveyRating : function(cmp,event,helper){
        var eventRec = cmp.get("v.eventRecord");
        if(eventRec.Status__c ==='Completed'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Completed"));
            cmp.set("v.showErrorMessage",true);
            
        }else if(eventRec.Status__c ==='Cancelled'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Cancelled"));
            cmp.set("v.showErrorMessage",true);
            
        }
            else{
                cmp.set("v.showActivitySurveyRating",false); 
            }
    },
    completeEvent : function (cmp,event,helper){
        var eventRec = cmp.get("v.eventRecord");
       
        if(eventRec.Status__c ==='Completed'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Completed"));
            cmp.set("v.showErrorMessage",true);
            
        }else if((eventRec.Validated__c===true && cmp.get("v.roleName")!=='Administrator') &&(cmp.get("v.oldEventType")!==eventRec.Event_Type__c||cmp.get("v.oldSubEventType")!==eventRec.Event_Sub_type__c||cmp.get("v.oldIsAlldayEvent")!==eventRec.IsAllDayEvent)){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Change_Validated_Work_Plan"));
            cmp.set("v.showErrorMessage",true);
        }
        else if(eventRec.Status__c ==='Cancelled'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Cancelled"));
            cmp.set("v.showErrorMessage",true);
            
        }else{
                var type = "Complete";
                helper.saveEvent(cmp,helper,type);
            }
    },
    completeEventAndNewTask : function(cmp,event,helper){
        
        var eventRec = cmp.get("v.eventRecord");
        if(eventRec.Status__c ==='Completed'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Completed"));
            cmp.set("v.showErrorMessage",true);
            
        }else if((eventRec.Validated__c===true && cmp.get("v.roleName")!=='Administrator') &&(cmp.get("v.oldEventType")!==eventRec.Event_Type__c||cmp.get("v.oldSubEventType")!==eventRec.Event_Sub_type__c||cmp.get("v.oldIsAlldayEvent")!==eventRec.IsAllDayEvent)){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Change_Validated_Work_Plan"));
            cmp.set("v.showErrorMessage",true);
        }else if(eventRec.Status__c ==='Cancelled'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Cancelled"));
            cmp.set("v.showErrorMessage",true);
            
        }else{
                var type = "New Task";
                helper.saveEvent(cmp,helper,type);
            }
    },
    cancelEvent: function(cmp,event,helper){
        var eventRec = cmp.get("v.eventRecord");
        if(eventRec.Status__c ==='Completed'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Completed"));
            cmp.set("v.showErrorMessage",true);
            
        }else if((eventRec.Validated__c===true && cmp.get("v.roleName")!=='Administrator') &&(cmp.get("v.oldEventType")!==eventRec.Event_Type__c||cmp.get("v.oldSubEventType")!==eventRec.Event_Sub_type__c||cmp.get("v.oldIsAlldayEvent")!==eventRec.IsAllDayEvent)){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Change_Validated_Work_Plan"));
            cmp.set("v.showErrorMessage",true);
        }
            else if(eventRec.Status__c ==='Cancelled'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Cancelled"));
            cmp.set("v.showErrorMessage",true);
            
        }
            else{
                var type = "Cancel";
                helper.saveEvent(cmp,helper,type);
            }
        
    },
    showSaveAndNewTaskModal : function(cmp,event,helper){
        
        cmp.set("v.isCompleteModal",false);
        var eventRec = cmp.get("v.eventRecord");
        if(eventRec.Status__c ==='Completed'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Completed"));
            cmp.set("v.showErrorMessage",true);
            
        }else if((eventRec.Validated__c===true && cmp.get("v.roleName")!=='Administrator') &&(cmp.get("v.oldEventType")!==eventRec.Event_Type__c||cmp.get("v.oldSubEventType")!==eventRec.Event_Sub_type__c||cmp.get("v.oldIsAlldayEvent")!==eventRec.IsAllDayEvent)){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Change_Validated_Work_Plan"));
            cmp.set("v.showErrorMessage",true);
        }
        else if(eventRec.Status__c ==='Cancelled'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Cancelled"));
            cmp.set("v.showErrorMessage",true);
            
        }else{
            var type="Complete";
            var status = helper.validateForm(cmp,eventRec,helper,type);
            if(status===true){
                cmp.set("v.showSaveAndNewTaskModal",true);
            }
        }
    },
    showCompleteModal : function(cmp,event,helper){
        
        cmp.set("v.isCompleteModal",true);
        var eventRec = cmp.get("v.eventRecord");
        if(eventRec.Status__c ==='Completed'){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Completed"));
            cmp.set("v.showErrorMessage",true);
            
        }else if((eventRec.Validated__c===true && cmp.get("v.roleName")!=='Administrator') &&(cmp.get("v.oldEventType")!==eventRec.Event_Type__c||cmp.get("v.oldSubEventType")!==eventRec.Event_Sub_type__c||cmp.get("v.oldIsAlldayEvent")!==eventRec.IsAllDayEvent)){
            cmp.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Change_Validated_Work_Plan"));
            cmp.set("v.showErrorMessage",true);
        }else{
            var type="Complete";
            var status = helper.validateForm(cmp,eventRec,helper,type);
            if(status===true){
                cmp.set("v.showSaveAndNewTaskModal",true);
            }
        }
    },
    cancelShowSaveAndNewTaskModal : function(cmp,event,helper){
        cmp.set("v.showSaveAndNewTaskModal",false);
    },
    handleMenuSelect : function(component,event,helper){
        var eventRec = component.get("v.eventRecord");
        if(eventRec.Status__c ==='Completed'){
            component.set("v.errorMessage",$A.get("$Label.c.Work_Plan_Error_Cannot_Edit_If_Status_Completed"));
            component.set("v.showErrorMessage",true);
            
        }else{
            var selectedMenuItemValue = event.getParam("value");
            if(selectedMenuItemValue==="Save"){
                var action = component.get('c.saveEvent');
                $A.enqueueAction(action);
            }
            else if(selectedMenuItemValue==="Complete"){
                var action = component.get('c.showCompleteModal');
                $A.enqueueAction(action);
            } 
                else if(selectedMenuItemValue==="ShowSurvey"){
                    var action = component.get('c.showActivitySurveyRating');
                    $A.enqueueAction(action);
                }
                    else if(selectedMenuItemValue==="New Task"){
                        var action = component.get('c.showSaveAndNewTaskModal');
                        $A.enqueueAction(action);
                    }
                        else if(selectedMenuItemValue==="Cancel"){
                            var action = component.get('c.cancelEvent');
                            $A.enqueueAction(action);
                        }
                            else if(selectedMenuItemValue==="Clone"){
                                var action = component.get('c.cloneEvent');
                                $A.enqueueAction(action);
                            }
        }
        
    },
    onStartDateChange : function(cmp,event,helper){
        
        var selectedMenuItemValue = event.getParam("value");
        var eventRecord = cmp.get("v.eventRecord");
        var StartDate = '';
        if(eventRecord.StartDateTime >  eventRecord.EndDateTime){
            var origEndDateTime = eventRecord.EndDateTime.split("T");
            var origStartDateTime = eventRecord.StartDateTime.split("T");
            var newDateTime = origStartDateTime[0]+'T'+origEndDateTime[1];
            
            eventRecord.EndDateTime =newDateTime ;
        }
        
        var today = new Date();
        var  convertedStartDate =  new Date(newDateTime);
        cmp.set("v.eventRecord",eventRecord);
        
    },
    onEndDateChange : function(cmp,event,helper){
        var selectedMenuItemValue = event.getParam("value");
        var eventRecord = cmp.get("v.eventRecord");
        if(eventRecord.EndDateTime <   eventRecord.StartDateTime){
            var origEndDateTime = eventRecord.EndDateTime.split("T");
            var origStartDateTime = eventRecord.StartDateTime.split("T");
            var newDateTime = origEndDateTime[0]+'T'+origStartDateTime[1];
            
            eventRecord.StartDateTime =newDateTime ;
        }
        var today = new Date();
        var  convertedStartDate =  new Date(eventRecord.StartDateTime);
        
        
        cmp.set("v.eventRecord",eventRecord);
    },
    showWhoIDValue: function(cmp,event,helper){
        cmp.set("v.assignedName",StoreResponse.contactName);
        cmp.find("nameLookup").showValue();
    },
    modeofconChange: function(component, event, helper) {
        var online = ["Home Base"];
        var onsite = ["Home Base", "Out of Home Base"];
        var modeofcon = component.get("v.eventRecord.Mode_of_Contact__c");

        if(modeofcon == "Online") {
            helper.setBasedLocationOptions(component, online);
        } else if(modeofcon == "Onsite") {
            helper.setBasedLocationOptions(component, onsite);
        }
    },
    locationbasedChange: function(component, event, helper) {
        helper.locationbasedValue(component, event, helper);
    }
    
    
    
})