({
	init : function(component, event, helper) {
        var filterOptions = [
            { label: 'Jan 2022', value: '202201' },{ label: 'Feb 2022', value: '202202' },
            { label: 'Mar 2022', value: '202203' },{ label: 'Apr 2022', value: '202204' },
            { label: 'May 2022', value: '202205' },{ label: 'Jun 2022', value: '202206' },
            { label: 'Jul 2022', value: '202207' },{ label: 'Aug 2022', value: '202208' },
            { label: 'Sep 2022', value: '202209' },{ label: 'Oct 2022', value: '202210' },
            { label: 'Nov 2022', value: '202211' },{ label: 'Dec 2022', value: '202212' },
            { label: 'Jan 2021', value: '202101' },{ label: 'Feb 2021', value: '202102' },
            { label: 'Mar 2021', value: '202103' },{ label: 'Apr 2021', value: '202104' },
            { label: 'May 2021', value: '202105' },{ label: 'Jun 2021', value: '202106' },
            { label: 'Jul 2021', value: '202107' },{ label: 'Aug 2021', value: '202108' },
            { label: 'Sep 2021', value: '202109' },{ label: 'Oct 2021', value: '202110' },
            { label: 'Nov 2021', value: '202111' },{ label: 'Dec 2021', value: '202112' }
        ];
            
        var mustBrandOptions = [
            { label: 'Core 8', value: 'Core 8' },
            { label: 'Next 13', value: 'Next 13' },
            { label: 'Nutritional', value: 'Nutritional' },
            { label: 'Onco', value: 'Onco' },
            { label: 'Others', value: 'Others' },
            { label: 'Chronic 22', value: 'Chronic 22' },
            { label: 'Unclassified', value: 'Unclassified' }
        ];
        //var month = $A.localizationService.formatDate(new Date(), "MM");
    	//var year = $A.localizationService.formatDate(new Date(), "YYYY");
        component.set("v.options", filterOptions);
        component.set("v.optionsMustBrand", mustBrandOptions);
        //component.set('v.periodVal', year+month);
        
        helper.formStatus(component);
        helper.prevInventory(component);
        helper.fetchData(component);
	},
    searchProduct: function(component, event, helper) {
        component.set("v.inventoryData", []);
        component.set("v.prevData", []);
        helper.prevInventory(component);
        helper.fetchData(component);
    },
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.fetchData(component);
        //console.log(component.get("v.inventoryData"));
    },
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.fetchData(component);
        //console.log(component.get("v.inventoryData"));
    },
    closeNotif: function(component) {
        component.set("v.successMessage", false);
    },
    saveRecord : function(component, event, helper) {
        helper.save(component, "Save as Draft");
        component.set("v.submittedBtn", false);
    },
    submitRecord : function(component, event, helper) {
        helper.save(component, "Submit");
        helper.formStatus(component);
        //console.log(component.get("v.inventoryData"));
    },
    openModel: function(component, event, helper) {
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   },
})