({
    fetchPromoType: function(component, fieldName, targetAttribute) {
        component.set('v.spinner', true); 
        // call the apex class method and pass fieldApi  name and object type 
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.promoTypeOptions"),
            "fld": fieldName
        });
        var opts2 = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts2.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v."+targetAttribute, opts2);
                component.set('v.spinner', false); 
            }else{
                component.set("v.errorToast", 'Failed to fetch Promo Type');
                helper.fetchWarningToast(component, event, helper);
                component.set('v.spinner', false); 
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchPromoSubType: function(component, fieldName, targetAttribute) {
        component.set('v.spinner', true); 
        // call the apex class method and pass fieldApi  name and object type 
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.promoSubTypeOptions"),
            "fld": fieldName
        });
        var opts2 = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts2.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v."+targetAttribute, opts2);
                component.set('v.spinner', false); 
            }else{
                component.set("v.errorToast", 'Failed to fetch Promo Type');
                helper.fetchWarningToast(component, event, helper);
                component.set('v.spinner', false); 
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchPromoMaterial: function(component, fieldName, targetAttribute) {
        component.set('v.spinner', true); 
        // call the apex class method and pass fieldApi  name and object type 
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.promoMaterialOptions"),
            "fld": fieldName
        });
        var opts2 = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts2.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v."+targetAttribute, opts2);
                component.set('v.spinner', false); 
            }else{
                component.set("v.errorToast", 'Failed to fetch Promo Type');
                helper.fetchWarningToast(component, event, helper);
                component.set('v.spinner', false); 
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchSubBrands: function(component, event, helper) {
        
        component.set('v.spinner', true); 
        
        var action = component.get("c.getSubBrands");
        var isSBChecked = component.get("{!v.isIncludeAllChecked}");
        
        action.setParams({
            "brand": component.get("v.selectBrand").Name
        });
        
        var opts4 = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts4.push({
                        label: allValues[i].Sub_Brand_Name__c,
                        value: allValues[i].Sub_Brand_Name__c
                    });
                }
                component.set("v.selectsubBrandsOptions", opts4);
                component.set('v.spinner', false); 
            } else {
                component.set("v.errorToast", 'Failed to fetch Sub Brands');
                helper.fetchWarningToast(component, event, helper);
                component.set('v.spinner', false); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    fetchBaseProduct: function(component, event, helper) {
        
        component.set('v.spinner', true); 
        
        var action = component.get("c.getBaseProducts");
        
        action.setParams({
            "subBrandList": component.get("v.selectsubBrandsValues"),
            "brand": component.get("v.selectBrand").Name
        });
        
        var opts3 = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.debug(response.getReturnValue().length);
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts3.push({
                        label: allValues[i].Name,
                        value: allValues[i].Id
                    });
                }
                component.set("v.selectbaseProdOptions", opts3);
                component.set('v.spinner', false); 
            } else {
                component.set("v.errorToast", 'Failed to fetch Base Products');
                helper.fetchWarningToast(component, event, helper);
                component.set('v.spinner', false); 
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchProductSKU: function(component, event, helper) {
        
        component.set('v.spinner', true); 
        
        var action = component.get("c.getSKU");
        
        action.setParams({
            "baseProdList": component.get("v.selectbaseProdValues"),
            "subBrandList": component.get("v.selectsubBrandsValues"),
            "brand": component.get("v.selectBrand").Name
        });
        
        var opts5 = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.debug(response.getReturnValue().length);
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts5.push({
                        label: allValues[i].Name,
                        value: allValues[i].Id
                    });
                }
                component.set("v.selectSKUOptions", opts5);
                component.set('v.spinner', false); 
            } else {
                component.set("v.errorToast", 'Failed to fetch Product SKU');
                helper.fetchWarningToast(component, event, helper);
                component.set('v.spinner', false); 
            }
        });
        $A.enqueueAction(action);
    },
    
    includeAllSubBrand: function(component, event, helper) {
        
        component.set('v.spinner', true); 
        
        var action = component.get("c.getSubBrands");
        var isSBChecked = component.get("{!v.isIncludeAllChecked}");
        
        action.setParams({
            "brand": component.get("v.selectBrand").Name
        });
        
        var opts4 = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts4.push({
                        label: allValues[i].Sub_Brand_Name__c,
                        value: allValues[i].Sub_Brand_Name__c
                    });
                }
                component.set("v.selectsubBrandsOptions", opts4);
                helper.fetchBaseProduct(component, event, helper);
                component.set('v.spinner', false); 
            } else {
                component.set("v.errorToast", 'Failed to fetch Sub Brands');
                helper.fetchWarningToast(component, event, helper);
                component.set('v.spinner', false); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    createPromoRecord: function(component, event, helper){
        
        component.set('v.spinner', true); 
        
        var action = component.get("c.insertPromo");
        
        if(component.get("v.selectSKUValues") == '' || component.get("v.selectSKUValues") == null){
            action.setParams({
                "promo": component.get("v.promo"),
                "baseProd": component.get("v.selectbaseProdValues"),
                "skuProd": null
            });
            
        }else if(component.get("v.selectSKUValues") != '' || component.get("v.selectSKUValues") != null){
            action.setParams({
                "promo": component.get("v.promo"),
                "baseProd": component.get("v.selectbaseProdValues"),
                "skuProd": component.get("v.selectSKUValues")
            });
            
        }

        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.promoId", res);
                component.set("v.isInProgress", false);
                component.set("v.isCreateSuccess", true);
                component.set('v.spinner', false);
            } else {
                component.set("v.errorToast", 'Failed to create Promo.');
                helper.fetchErrorToast(component, event, helper);
                component.set('v.spinner', false); 
            }
        });
        $A.enqueueAction(action);
        
    },
        
    fetchErrorToast : function(component, event, helper) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'dismissible',
            type: 'error',
            message: component.get("v.errorToast"),
        });
        toastEvent.fire();
    },
    
    fetchPromotobeCloned : function(component, event, helper, clonePromoId) {
        var action = component.get('c.getPromoToBeCloned');
        
        action.setParams({
            "recordId": clonePromoId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                component.set('v.promo', response.getReturnValue());
                helper.fetchPromoProductBrandtobeCloned(component, event, helper, clonePromoId);
                helper.fetchPromoProductSubBrandtobeCloned(component, event, helper, clonePromoId);
                helper.fetchBasePromoProdtobeCloned(component, event, helper, clonePromoId);
                helper.fetchSKUPromoProductdtobeCloned(component, event, helper, clonePromoId);
            } else if (state === "ERROR") { 
                console.log("ERROR received")
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchPromoProductBrandtobeCloned : function(component, event, helper, promoRecord) {
        var action = component.get('c.getPromoProductBrandToBeCloned');
        
        action.setParams({
            "promoRecId": promoRecord
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var promoProdBrandToBeCloned = response.getReturnValue();
                component.set('v.selectBrand', promoProdBrandToBeCloned);
                component.find("userLookup").showValue();
            } else if (state === "ERROR") { 
                console.log("ERROR received")
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchPromoProductSubBrandtobeCloned : function(component, event, helper, promoRecord) {
        var action = component.get('c.getPromoProdSubBrandToBeCloned');
        
        action.setParams({
            "promoRecId": promoRecord
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var promoProdSubBrandToBeCloned = response.getReturnValue();
                component.set('v.selectsubBrandsValues', promoProdSubBrandToBeCloned);
                component.set("v.selectsubBrandsTemp", component.get("v.selectsubBrandsValues"));
                
            } else if (state === "ERROR") { 
                console.log("ERROR received")
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchBasePromoProdtobeCloned : function(component, event, helper, promoRecord){
        var action = component.get('c.getBasePromoProdToBeCloned');
        
        action.setParams({
            "promoRecId": promoRecord
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var basePromoProdToBeCloned = response.getReturnValue();                
                component.set("v.isBaseProductButtonDisabled", false);
                helper.fetchBaseProduct(component, event, helper);
                component.set('v.selectbaseProdValues', basePromoProdToBeCloned);
                component.set("v.selectbaseProdTemp", component.get("v.selectbaseProdValues"));
                
            } else if (state === "ERROR") { 
                console.log("ERROR received")
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchSKUPromoProductdtobeCloned : function(component, event, helper, promoRecord) {
        var action = component.get('c.getSKUPromoProdToBeCloned');
        
        action.setParams({
            "promoRecId": promoRecord
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var skuPromoProdToBeCloned = response.getReturnValue();
                component.set("v.isSKUButtonDisabled", false);
                helper.fetchProductSKU(component, event, helper);
                component.set('v.selectSKUValues', skuPromoProdToBeCloned);
                component.set("v.selectSKUTemp", component.get("v.selectSKUValues"));
                
            } else if (state === "ERROR") { 
                console.log("ERROR received")
            }
        });
        $A.enqueueAction(action);
    },
    
})