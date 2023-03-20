({
    doInit : function(component, event, helper) {   
        console.log("call init")
        console.log(component.get('v.tcrCalls'));
        //if(component.get('v.tcr').Type__c === component.get('v.t3Tcr')){
        //   var calls = component.get('v.tcrCalls');
        //    console.log(calls);
        //  }
        
        helper.setCallFieldMap(component, helper, component.get('v.callFieldLabels'));                                              
    },
    
    handleValidateSection: function(component, event, helper) {
        
        if(component.get('v.validateCallSection')){
            helper.validateSection(component, event, helper);
        }
    },
    
    handleChangeTcrCalls: function(component, event, helper) {
        component.set('v.isWithUnsaved', true);
    },   
    
    tcrCallsChange: function(component, event, helper) {  
        helper.setCallFieldMap(component, helper, component.get('v.callFieldLabels'));
    },   
    
    handleAddAccount : function(component,event, helper){
        helper.addAccount(component, event, helper);
    },
    
    handleSaveCall: function(component){       
        component.set('v.isDisabled',false); 
        
        var calls = component.get('v.tcrCalls');
        
        for(var i = 0; i<calls.length;i++){
            var call = calls[i];
            
            if(calls[i].Id == null){
                call.Account__r = component.get('v.selectedRecord');
                call.Account__c = component.get('v.selectedRecord').Id;                
            }
        }   
    },
    
    handleCancelSave: function(component){
        component.find('accountLookup').clear();   
        component.set('v.isDisabled',true);
        component.set('v.selectedRecord','[object Object]');
    },   
    
    handleSetAccount:  function(component, event, helper){       
        helper.setAccount(component, event, helper);    
    }, 
    
    handleDeleteAccount:  function(component, event, helper){        
        component.set('v.callToDeleteId', event.getSource().get('v.name'))
        var isDisable = component.get('v.isDisabled');
        
        if(!isDisable){
            component.set('v.isShowDelete',true);
        }     
    }, 
    
    handleConfirmDelete:  function(component, event, helper){      
        helper.deleteCall(component, event, helper);    
    }, 
    
    handleCancelDelete:  function(component, event, helper){
        component.set('v.isShowDelete',false);        
    },
    
    handleShowNotice:  function(component, event, helper){
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "Something has gone wrong!",
            "message": "Unfortunately, there was a problem updating the record.",
            closeCallback: function() {
                alert('You closed the alert!');
            }
        });
    }, 
    
})