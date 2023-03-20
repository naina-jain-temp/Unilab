({
    // TCR Initialization
    doInit : function(component, event, helper) {   
        console.log("init");
        
        helper.getTCR(component, event, helper);
        
    },
    // Go to start of TCR 
    handleBegin: function(component, event, helper){		
        helper.goToPage(component, 2);
    },
    // Save and Next
    handleSaveRecord:function(component, event, helper){          
        var currentStep = parseInt(component.get("v.currentStep"), 10);
        var nextPageNo = currentStep + 1;
        
        if (currentStep != 10) {                    
            helper.moveNextPage(component, event, helper, nextPageNo);               
        }            
    },
    // Save Changes // Clicking Previous Button with Changes
    handleSaveUnsaved : function(component, event, helper) {        
        var currentStep = parseInt(component.get("v.currentStep"), 10);
        helper.moveNextPage(component, event, helper, currentStep);
    },
    // Cancel Changes // Clicking Previous Button with Unsaved
    handleCancelSaveUnsaved : function(component, event, helper) {    	
        helper.getTcrById(component, event, helper);
        component.set('v.showUnsaveConfirm',false);
        component.set('v.isWithUnsaved',false);
        
    },    
    // Show TCR section via Lightning Process Indicator
    goToSection: function(component, event, helper){
        var sectionValue = parseInt(event.getSource().get('v.value'), 10); 
        var currentStep = parseInt(component.get('v.currentStep'), 10); 
        var stepToValidate = parseInt(component.get('v.stepToValidate'), 10); 
        var isRequired = component.get('v.isRequired');
        var isDraft = component.get('v.isDraft');
        
        if(sectionValue > stepToValidate && isRequired && isDraft){
            if(stepToValidate != 0  && currentStep != 10){
                helper.validateComponent(component, event, helper);
            }else{
                helper.moveNextPage(component, event, helper, sectionValue);
            }           
        }else if(sectionValue != currentStep){           
            helper.moveNextPage(component, event, helper, sectionValue); 
        }
    },    
    // Submit valid TCR
    handleUpdateStatus:function(component, event, helper){           
        helper.updateStatusRecord(component, event, helper);                    
    },    
    // Cancel submission of TCR
    handleCancelSubmit:function(component, event, helper){         
        component.set('v.showSubmitConfirm' , false);    
    },    
    // Validate required fields upon submission of TCR
    handleSubmit:function(component, event, helper){   		
        helper.validateRequiredFields(component, event, helper);         
    },
    // Go to Previous TCR Section
    moveBack : function(component, event, helper) {        
        var currentStep = parseInt(component.get("v.currentStep"), 10);
        var num = currentStep - 1;
        var withUnsaved = component.get('v.isWithUnsaved');
        var stepToValidate = parseInt(component.get('v.stepToValidate'), 10);
        if (currentStep != 1) {
            
            if(stepToValidate != currentStep){
                if(withUnsaved){                
                    component.set('v.showUnsaveConfirm', true);                
                }            
                component.set('v.currentStep', num.toString());
                setTimeout(function(){
                    document.getElementById('tcrForm').scrollIntoView({block: "start", inline: "nearest"});
                }, 10);
            }          
        }  
        
        if(component.get('v.currentStep') === component.get('v.callsSection') && component.get('v.isWithCalls')){
            component.set('v.renderTradeTcr',true);         
        }        
    },
    // handles onchange event for all values
    handleChangeValue : function(component, event, helper) {        
        component.set('v.isWithUnsaved', true);
    },
    
    handleChangeSkillValue : function(component, event, helper) {        
        component.set('v.isWithUnsaved', true);
        
        var cmp = event.getSource();
        var selectedSkill = cmp.get('v.value');
        
        if(cmp.getLocalId() == 'closing_skill_1__c'){           
            helper.getSpecificSkillDev(component, helper, selectedSkill, 1);
        } 
        
        if(cmp.getLocalId() == 'closing_skill_2__c'){           
            helper.getSpecificSkillDev(component, helper, selectedSkill, 2);
        }
    },
    
    displayLegendSectionThree : function(component, event, helper) {
        
        component.set("v.legendSectionThree", true);
        
    },
    
    closeLegendSectionThree : function(component, event, helper) {
        
        component.set("v.legendSectionThree", false);
        
    },
    
    displayLegendSectionFour : function(component, event, helper) {
        
        component.set("v.legendSectionFour", true);
        
    },
    
    closeLegendSectionFour : function(component, event, helper) {
        
        component.set("v.legendSectionFour", false);
        
    }
})