({
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
                    
                    this.loadPriorities(component,'NEW PRODUCT SATURATION','newProductData');
                    this.loadPriorities(component,'TOP PROMO','topPromoData');
                    this.loadPriorities(component,'TOP MERCHANDISING','topMerchData');
                    this.loadPriorities(component,'PRICE INCREASE','priceIncreaseData');
                    this.loadPriorities(component,'ACCOUNT INITIATED ACTIVITIES','acctInitActivitiesData');
                    this.loadPriorities(component,'COMPETITIVE ACTIVITY','competitiveActivitiesData');
                    //this.loadPreviousLearningsAndInsights(component,'TRADE CHECK BUDDY');
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
        
        /*var branchId=component.get('v.recordId');

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
                    this.loadPriorities(component,'NEW PRODUCT SATURATION','newProductData');
                    this.loadPriorities(component,'TOP PROMO','topPromoData');
                    this.loadPriorities(component,'TOP MERCHANDISING','topMerchData');
                    this.loadPriorities(component,'PRICE INCREASE','priceIncreaseData');
                    this.loadPriorities(component,'ACCOUNT INITIATED ACTIVITIES','acctInitActivitiesData');
                    this.loadPriorities(component,'COMPETITIVE ACTIVITY','competitiveActivitiesData');
                    this.loadPreviousLearningsAndInsights(component,'TRADE CHECK BUDDY');
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
        
        $A.enqueueAction(action);*/ 
    },
    
	loadPriorities : function(component,priorityType,dataList) {
		var action = component.get('c.fetchPriorities');
        var recordId = component.get('v.recordId');
        
        action.setParams({
            recordId,
            priorityType
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v."+dataList, response.getReturnValue());
            	//component.set("v.newProductData", response.getReturnValue());
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
            
    loadPrevJournal : function(component) {
		var action = component.get('c.fetchPrevJournal');
        var recordId = component.get('v.recordId');
        
        action.setParams({
            recordId
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
          
})