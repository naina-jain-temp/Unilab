({
    doInit: function(component, event, helper){
        
        helper.fetchPromoType(component, 'Promo_Type__c', 'promoTypeOptions');
        helper.fetchPromoSubType(component, 'Promo_Sub_Type__c', 'promoSubTypeOptions');
        helper.fetchPromoMaterial(component, 'Promo_Materials__c', 'promoMaterialOptions');
        var clonePromo = component.get('v.promoTobeCloned');
        if(clonePromo != null){
            helper.fetchPromotobeCloned(component, event, helper, clonePromo);
        }
    },
    
    dofetchSubBrands: function(component, event, helper){
        if(component.get("{!v.selectBrand}").Name == undefined){
            
            component.set("v.isIncludeAllDisabled", true);
            component.set("v.isSubBrandButtonDisabled", true);
            component.set("v.isBaseProductButtonDisabled", true);
            component.set("v.isSKUButtonDisabled", true);
            component.set("v.isIncludeAllChecked", false);
            component.set("v.selectsubBrandsValues", "");
            component.set("v.selectsubBrandsTemp", "");
            component.set("v.selectbaseProdValues", "");
            component.set("v.selectbaseProdTemp", "");
            component.set("v.selectSKUValues", "");
            component.set("v.selectSKUTemp", "");
            
            
        }else if(component.get("{!v.selectBrand}").Name != undefined){
            
            helper.fetchSubBrands(component, event, helper);
            component.set("v.isIncludeAllDisabled", false);
            component.set("v.isSubBrandButtonDisabled", false);
            component.set("v.isBaseProductButtonDisabled", true);
            component.set("v.isSKUButtonDisabled", true);
            component.set("v.isIncludeAllChecked", false);
            //component.set("v.selectsubBrandsValues", "");
            //component.set("v.selectsubBrandsTemp", "");
            //component.set("v.selectbaseProdValues", "");
            //component.set("v.selectbaseProdTemp", "");
            //component.set("v.selectSKUValues", "");
            //component.set("v.selectSKUTemp", "");
            
        }
        
    },
    
    doFetchBaseProd: function(component, event, helper){
        
        if((component.get("v.selectsubBrandsValues") == "" || component.get("v.selectsubBrandsValues") == null)){
            
            component.set("v.isBaseProductButtonDisabled", true);
            component.set("v.isSKUButtonDisabled", true);
            component.set("v.selectbaseProdValues", "");
            component.set("v.selectbaseProdTemp", "");
            component.set("v.selectSKUValues", "");
            component.set("v.selectSKUTemp", "");
            component.set("v.isSubBrandModalOpen", false);
            
        }else{
            
            helper.fetchBaseProduct(component, event, helper);
            component.set("v.selectsubBrandsTemp", component.get("v.selectsubBrandsValues"));
            component.set("v.isSubBrandModalOpen", false);
            component.set("v.isBaseProductButtonDisabled", false);
            component.set("v.selectbaseProdValues", "");
            component.set("v.selectbaseProdTemp", "");
            
        }
        
        
    },
    
    doFetchProdSKU: function(component, event, helper){
        
        if((component.get("v.selectbaseProdValues") == "" || component.get("v.selectbaseProdValues") == null)){
            
            component.set("v.selectSKUValues", "");
            component.set("v.selectSKUTemp", "");
            component.set("v.isBaseProductModalOpen", false);
            component.set("v.isSKUButtonDisabled", true);
            
        }else{
            
            helper.fetchProductSKU(component, event, helper);
            component.set("v.selectbaseProdTemp", component.get("v.selectbaseProdValues"));
            component.set("v.isBaseProductModalOpen", false);
            component.set("v.isSKUButtonDisabled", false);
            
        }
        
        
        
    },
    
    doIncludeAllSubBrand: function(component, event, helper){
        
        var isSBChecked = component.get("v.isIncludeAllChecked");
        var allSubBrand = component.get("v.selectsubBrandsValues");
        
        if(isSBChecked == true){
            helper.includeAllSubBrand(component, event, helper);
            component.set("v.isSubBrandButtonDisabled", true);
            component.set("v.isBaseProductButtonDisabled", false);
            
            for(var i = 0; i < component.get("v.selectsubBrandsOptions").length; i++){
                allSubBrand.push(component.get("v.selectsubBrandsOptions")[i].value);
            }
            
        }else{
            component.set("v.isSubBrandButtonDisabled", false);
            component.set("v.isBaseProductButtonDisabled", true);
            component.set("v.isSKUButtonDisabled", true);
            component.set("v.selectbaseProdValues", "");
            component.set("v.selectbaseProdTemp", "");
            component.set("v.selectSKUValues", "");
            component.set("v.selectSKUTemp", "");
            
            for(var i = 0; i < component.get("v.selectsubBrandsOptions").length; i++){
                allSubBrand.pop();
            }
        }
        
    },
    
    saveAndSubmit: function(component, event, helper){
        
        helper.createPromoRecord(component, event, helper);
        component.set("v.isSubmitModalOpen", false);
        
    },
    
    goToRecordPage : function(component, event, helper){
        var recordId = component.get("v.promoId");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/" + recordId
        });
        urlEvent.fire();
    },
    
    openBaseProductModal : function(component, event, helper) {
        component.set("v.isBaseProductModalOpen",true);
    },
    
    closeBaseProductModal : function(component, event, helper){
        component.set("v.selectbaseProdValues", component.get("v.selectbaseProdTemp"));
        component.set("v.isBaseProductModalOpen", false);
    },
    
    openSubBrandModal : function(component, event, helper) {
        component.set("v.isSubBrandModalOpen",true);        
    },
    
    closeSubBrandModal : function(component, event, helper){
        component.set("v.selectsubBrandsValues", component.get("v.selectsubBrandsTemp"));
        component.set("v.isSubBrandModalOpen", false);
    },
    
    openSKUModal : function(component, event, helper) {
        component.set("v.isSKUModalOpen",true);
    },
    
    closeSKUModal : function(component, event, helper){
        component.set("v.selectSKUValues", component.get("v.selectSKUTemp"));
        component.set("v.isSKUModalOpen", false);
    },
    
    saveSKUModal : function(component, event, helper){
        component.set("v.selectSKUTemp", component.get("v.selectSKUValues"));
        component.set("v.isSKUModalOpen", false);
    },
    
    openSubmitModal : function(component, event, helper) {
        
        var PN, PT, PS, PE, PB, BP;
        var today = new Date();
        var monthDigit = today.getMonth() + 1;
        if (monthDigit <= 9) {
            monthDigit = '0' + monthDigit;
        }
        
        var dateDigit = today.getDate();
        if (dateDigit <= 9) {
            dateDigit = '0' + dateDigit;
        }
        
        var td = today.getFullYear() + "-" + monthDigit + "-" + dateDigit;
        
        if(component.find("promoName").get("v.value") == '' || component.find("promoName").get("v.value") == null){
            
            PN = 0;
            component.set("v.errorToast", 'Please complete all required fields.');
            helper.fetchErrorToast(component, event, helper);
            component.set("v.isSubmitModalOpen", false);
            component.find("promoName").showHelpMessageIfInvalid();
            
        }else{
            
            PN = 1;
            
        }
        
        if(component.find("promoType").get("v.value") == '' || component.find("promoType").get("v.value") == null){
            
            PT = 0;
            component.set("v.errorToast", 'Please complete all required fields.');
            helper.fetchErrorToast(component, event, helper);
            component.set("v.isSubmitModalOpen", false);
            component.find("promoType").showHelpMessageIfInvalid();
            
        }else{
            
            PT = 1;
            
        }
        
        if(component.find("promoStartDate").get("v.value") == '' || component.find("promoStartDate").get("v.value") == null){
            
            PS = 0;
            component.set("v.errorToast", 'Please complete all required fields.');
            helper.fetchErrorToast(component, event, helper);
            component.set("v.isSubmitModalOpen", false);
            component.find("promoStartDate").showHelpMessageIfInvalid();
            
        }else if(component.find("promoStartDate").get("v.value") < td){
            
            PS = 0;
            component.set("v.errorToast", 'Start Date must not be previous than current date.');
            helper.fetchErrorToast(component, event, helper);
            component.set("v.isSubmitModalOpen", false);
            component.find("promoStartDate").showHelpMessageIfInvalid();
            
        }else{
            
            PS = 1;
            
        }
        
        if(component.find("promoEndDate").get("v.value") == '' || component.find("promoEndDate").get("v.value") == null){
            
            PE = 0;
            component.set("v.errorToast", 'Please complete all required fields.');
            helper.fetchErrorToast(component, event, helper);
            component.set("v.isSubmitModalOpen", false);
            component.find("promoEndDate").showHelpMessageIfInvalid();
            
        }else if(component.find("promoStartDate").get("v.value") >= component.find("promoEndDate").get("v.value")){
            
            PE = 0;
            component.set("v.errorToast", "Promo End Date must not be earlier or same as Start Date.");
            helper.fetchErrorToast(component, event, helper);
            component.set("v.isSubmitModalOpen", false);
            component.find("promoEndDate").showHelpMessageIfInvalid();
            
        }else{
            
            PE = 1;
            
        }
        
        if(component.get("{!v.selectBrand}").Name == undefined || component.get("{!v.selectBrand}").Name == null){
            
            PB = 0;
            component.set("v.errorToast", 'Please complete all required fields.');
            helper.fetchErrorToast(component, event, helper);
            component.set("v.isSubmitModalOpen", false);
            
        }else{
            
            PB = 1;
            
        }
        
        if((component.get("{!v.selectsubBrandsValues}") == '' && component.get("{!v.isIncludeAllChecked}") == false) || 
           (component.get("{!v.selectsubBrandsValues}") == null && component.get("{!v.isIncludeAllChecked}") == false)){
            
            component.set("v.errorToast", 'Please complete all required fields.');
            helper.fetchErrorToast(component, event, helper);
            component.set("v.isSubmitModalOpen", false);
            
        }
        
        if(component.get("{!v.selectbaseProdValues}") == '' || component.get("{!v.selectbaseProdValues}") == null){
            
            BP = 0;
            component.set("v.errorToast", 'Please complete all required fields.');
            helper.fetchErrorToast(component, event, helper);
            component.set("v.isSubmitModalOpen", false);
            
        }else if(component.get("{!v.selectbaseProdValues}") != '' || component.get("{!v.selectbaseProdValues}") != null){
            
            BP = 1;
            
        }
        
        if(PN == "1" && PT == "1" && PS == "1" && PE == "1" && PB == "1" && BP == "1"){
            
            component.set("v.isSubmitModalOpen",true);
            
        }
        
    },
    
    closeSubmitModal : function(component, event, helper){
        component.set("v.isSubmitModalOpen", false);
    },
    
    successSubmitModal : function(component, event, helper){
        component.set("v.isRecordSubmit", false);
    },
    
})