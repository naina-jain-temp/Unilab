({
    doInit : function(component,event,helper){
        var subEventType = component.get("v.subEventType");
        var subActivityList = component.get("v.subActivityList");
        helper.getSubEventActivity(component,helper,subEventType); 
        var item = component.get("v.subActivity");
        var item2 = Object.assign({}, item2);
        if(component.get("v.subActivityOptions").length > 0){
            item2.Activity_Name__c = component.get("v.subActivityOptions")[0].value;
            
            //add data to item later.....
            subActivityList.push(item2);
            component.set("v.subActivityList",subActivityList);
            var subEventType = component.get("v.subEventType");
            subEventType= subEventType.toLowerCase();
            var splitSubEventType = subEventType.split(" ");
            for(var i =0;i<splitSubEventType.length;i++){
                splitSubEventType[i] =  splitSubEventType[i].charAt(0).toUpperCase() + splitSubEventType[i].substr(1);
            }
            subEventType = splitSubEventType.join(" ");
            component.set("v.UpperlowercasesubEventType",subEventType);
        }

    },
    addMoreSubEvent : function(component, event, helper) {
   
        if(component.get("v.subActivityOptions").length > 0){
            var subActivityList = component.get("v.subActivityList");
            var item = component.get("v.subActivity");
            var item2 = Object.assign({}, item);
            item2.Activity_Name__c = component.get("v.subActivityOptions")[0].value;
            //add data to item later.....
            subActivityList.push(item2);
            component.set("v.subActivityList",subActivityList);
            component.set("v.addedActivity",true);
            setTimeout(function(){
                document.getElementById('end').scrollIntoView({block: "end", inline: "nearest"});
            }, 10);
        }
        
        
    },
    handleMenuSelect : function(component,event,helper) {
        
        /* PREVIOUS CODE
        
        var subacitivities = component.get("v.subActivityList");
        
        var index = event.getParam("value");
        subacitivities.splice(index,1);
        component.set("v.subActivityList",subacitivities);
        
        */
        
        var subacitivities = component.get("v.subActivityList");
        
        var index = event.getParam("value");
        
        if (index.length == 18 && index.match(/[a-zA-Z]/i)) {
            
            component.set('v.showSpinner', true);
            
            var action = component.get("c.deleteSubActivity");
            
            action.setParams({ 
                subActivityID : index
            });
            
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    
                    var indexSplice = subacitivities.findIndex(x => x.Id == index);
                    
                    subacitivities.splice(indexSplice, 1);                    
                    component.set("v.subActivityList", subacitivities);
                    
                    component.set('v.showSpinner', false);
                    
                }
                
                else {
                    
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Please contact your System Administrator.",
                        "type": "error"
                    });
                    	
                    toastEvent.fire();
                }
                
            });
            
            
            $A.enqueueAction(action);
            
        }
        else {
            subacitivities.splice(index,1);
            component.set("v.subActivityList",subacitivities);
        }
        
    },
    requireRemarksAnalysisInsights : function(cmp,event,helper){
        var actJuncRemarks = cmp.find("actJuncRemarks");
        actJuncRemarks.set("v.required",true);
        actJuncRemarks.reportValidity();

        
    },
    requireDiscussionsAgreements : function(cmp,event,helper){
		var subActivityList = cmp.get("v.subActivityList");
        
        if(subActivityList.length >1 || cmp.get("v.addedActivity")===true){
            var allValid = cmp.find('discussionAgreement').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            
            if (allValid) {
                return true;
            }
        }else{
            var discussionAgreement = cmp.find('discussionAgreement');
            discussionAgreement.reportValidity();
            if(discussionAgreement.get("v.validity").valid){
                return true
            }
 
        }
         return false;
    }
    
})