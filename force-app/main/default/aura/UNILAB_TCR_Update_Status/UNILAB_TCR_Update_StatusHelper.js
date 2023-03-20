({
    getTcrById: function(component, event, helper){
        console.log('getTcrById');
        console.log( component.get('v.recordId'));
        var tcrRec = component.get('v.tcr');
        var callAction = component.get("c.getTcrRecord");
        
        callAction.setParams({ recordId : component.get('v.recordId') });
        
        callAction.setCallback(this, function(callActionResponse) {
            var state = callActionResponse.getState();
            //  console.log(state);
            if (state === "SUCCESS") {  
                var tcrRec = callActionResponse.getReturnValue(); 
                component.set('v.tcr',tcrRec);    
                console.log(tcrRec);
                
                if(tcrRec.Status__c === 'Draft'){
                    
                    helper.showToast({'message' : 'TCR status is Draft.',
                                      'type':'ERROR',
                                      'title':''});
                    helper.closeQuickAction(component, event, helper);
                    
                }else if(tcrRec.Status__c === 'Approved'){
                    console.log(tcrRec.Status__c);
                    
                    
                    helper.showToast({'message' : 'TCR status is already Approved.',
                                      'type':'ERROR',
                                      'title':''});
                    
                   helper.closeQuickAction(component, event, helper);                    /*
                    helper.handleShowNotice(component, {'message' : 'TCR status is already Approved.',
                                      'variant':'error',
                                      'header':''});
                                      */
                    
                    // helper.navigateToRecord(tcrRec.Id); 
                    
                }else{                  
                    helper.isUserValid(component, event, helper);                      
                }                                                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = callActionResponse.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            
                            helper.showToast({'message' : errors[0].message  ,
                                              'type':'ERROR',
                                              'title':''});
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });        
        $A.enqueueAction(callAction);   
    },
    
    isUserValid: function(component, event, helper){
        
        var tcrRec = component.get('v.tcr');
        var userValidation = component.get("c.isValidUser");
        
        userValidation.setParams({ tcr : tcrRec });
        
        userValidation.setCallback(this, function(callActionResponse) {
            
            var state = callActionResponse.getState();
            //  console.log(state);
            if (state === "SUCCESS") {  
                var isValidUser = callActionResponse.getReturnValue(); 
                var tcr = component.get('v.tcr');
                
                component.set('v.tcr',tcrRec);   
               // component.set('v.isValidUser',true);
                console.log(tcrRec);
                console.log(isValidUser);
                console.log(tcrRec.Status__c );
                if(isValidUser){
                    if(tcrRec.Status__c === 'Pending Concurrence'){
                        // component.set('v.isPendingConcurrence',true)
                        
                        component.set('v.isShowApprovalConfirm',true);
                        //helper.updateStatus(component, event, helper);   
                    }
                    
                    if(tcrRec.Status__c === 'Pending Approval'){
                        component.set('v.isPendingApproval',true)                     
                    }
                }               
            }else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = callActionResponse.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            helper.closeQuickAction(component, event, helper);
                            helper.showToast({'message' : errors[0].message  ,
                                              'type':'ERROR',
                                              'title':''});
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });        
        $A.enqueueAction(userValidation);          
    },
    
    updateStatus: function(component, event, helper){
        console.log('handleUpdateStatus');
        var tcr = component.get('v.tcr');
        var statusAction = component.get('c.updateTCRStatus');    
        console.log(tcr.Id);
        statusAction.setParams({  currentTcr : tcr  })
        
        statusAction.setCallback(this, function(response) {    
            var state = response.getState();
            
            console.log(state);
            if(state === 'SUCCESS'){
                var updatedTcr = response.getReturnValue();
                //  console.log('sucess submit');                
                
                component.set('v.tcr',updatedTcr); 
                
                component.set('v.showApprovalConfirm',false);         
                
                helper.updateOwner(component, event, helper, true);
                
                /*
                helper.showToast({'message' : 'Status has been successfully updated.',
                                  'type':'SUCCESS',
                                  'title':''});
                
                 helper.navigateToRecord(event, tcr.Id); 
                 */
                
            }else if(state === 'ERROR'){
                var errors = response.getError();
                console.log(errors);
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    console.error(errors[0].message);
                    
                    helper.showToast({'message' : errors[0].message  ,
                                      'type':'ERROR',
                                      'title':''});
                    
                   helper.closeQuickAction(component, event, helper); 
                } 
            }                                    
        });
        $A.enqueueAction(statusAction);    
    },
    
    updateOwner: function(component, event, helper){
        console.log('handleUpdateStatus');
        var tcr = component.get('v.tcr');
        var statusAction = component.get('c.updateRecOwner');    
        console.log(tcr.Id);
        statusAction.setParams({  tcr : tcr  })
        
        statusAction.setCallback(this, function(response) {    
            var state = response.getState();
            
            console.log(state);
            if(state === 'SUCCESS'){
                
                helper.showToast({'message' : 'Status has been successfully updated.',
                                  'type':'SUCCESS',
                                  'title':''});
                
                helper.navigateToRecord(event, tcr.Id); 
                
            }else if(state === 'ERROR'){
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    console.error(errors[0].message);
                    
                    helper.showToast({'message' : errors[0].message  ,
                                      'type':'ERROR',
                                      'title':''});
                    
                    helper.navigateToRecord(event, tcr.Id); 
                } 
            }                                    
        });
        $A.enqueueAction(statusAction);    
    },
    
    showToast : function(alertMessage) {
        console.log(alertMessage.message);
        var toastEvent = $A.get("e.force:showToast");
        console.log(toastEvent);
        toastEvent.setParams({
            "title": alertMessage.title,
            "type": alertMessage.type,
            "message": alertMessage.message
        });
        toastEvent.fire();
    },
    
    approval :function(component, event, helper){        
        handleUpdateStatus((component, event, helper));
    },
    
    cancelApproval: function(component, event, helper){
        component.set('v.showApprovalConfirm',false);        
        helper.closeQuickAction(component, event, helper);        
    },
    
     closeQuickAction: function(component, event, helper){
         $A.get("e.force:closeQuickAction").fire();
    },

    
    navigateToRecord : function(event, recordId){
        
        var event = $A.get( 'e.force:navigateToSObject' );
        
        event.setParams({
            'recordId' : recordId,
            'slideDevName' : 'Detail' ,
            'isRedirect' : true
        }).fire();     
    },
    
    handleShowNotice : function(component, alertMessage) {
        component.find('notifLib').showNotice({
            "message": alertMessage,message,
            "variant": alertMessage.variant,
            "header": alertMessage.header,   
            closeCallback: function() {
                alert('You closed the alert!');
            }
        });
    }
})