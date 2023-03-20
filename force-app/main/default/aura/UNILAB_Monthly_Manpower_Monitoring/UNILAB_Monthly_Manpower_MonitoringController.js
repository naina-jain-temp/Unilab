({
    init: function(component, event, helper) {
        var date = new Date();
        var month = helper.getMonthString[date.getMonth() - 1];
        var lastmonth = helper.getMonthString[date.getMonth() - 1];
        var year = date.getFullYear(); 
        var recordId = component.get('v.recordId');
        console.log(recordId);
        component.set("v.month", month);
        component.set("v.year", year);
        component.set("v.accountId", recordId);
        
        if (lastmonth == 11 && month == 0) {
            year = year - 1;
        }
        //console.log("LastMonth: " + lastmonth);
        helper.getLastMonthRecord(component, lastmonth, year); 
        
        helper.getContacts(component, "v.backroomoptions", "Backroom Personnel");
        helper.getContacts(component, "v.warehouseoptions", "Warehouse & Logistics Personnel");
        helper.getContacts(component, "v.fieldoptions", "Field Personnel");
        
        helper.getTrucks(component, "v.truckoptions", "Truck Requirenment");
        
        helper.getThisMonthRecord(component, month, year);
        
        helper.getChecklist(component, "Backroom Personnel", "v.backroomlist", "bp",1, "v.brratings", recordId); 
      	helper.getChecklist(component, "Warehouse & Logistics Personnel", "v.warehouselist", "wh",8, "v.whratings", recordId);
		helper.getChecklist(component, "Field Personnel", "v.fieldlist", "fp",13, "v.fldratings", recordId);
        helper.getChecklist(component, "Truck Requirement", "v.trucklist", "tp",16, "v.trratings", recordId);
        
        
	},
    calculate: function (component, event, helper) {
        
        
        var backroomdata = component.get("v.backroomresult");
        var warehousedata = component.get("v.warehouseresult");
        var fieddata = component.get("v.fieldresult");
        var truckdata = component.get("v.truckresult");
        
        var backroomratings = component.get("v.brratings");
        var warehouseratings = component.get("v.whratings");
        var fieldratings = component.get("v.fldratings");
        var truckratings = component.get("v.trratings");
        
        backroomratings = helper.calcRating(backroomdata, backroomratings);
        warehouseratings = helper.calcRating(warehousedata, warehouseratings);
        fieldratings = helper.calcRating(fieddata, fieldratings);
        truckratings = helper.calcRating(truckdata, truckratings);
        
        component.set("v.brratings", backroomratings);
        component.set("v.whratings", warehouseratings);
        component.set("v.fldratings", fieldratings);
        component.set("v.trratings", truckratings);
        
    },
    

    submit : function (component, event, helper) {
        
        var backroomdata = component.get("v.backroomresult");
        var warehousedata = component.get("v.warehouseresult");
        var fieddata = component.get("v.fieldresult");
        var truckdata = component.get("v.truckresult");
        
        helper.proceedtoSave(component, helper, backroomdata);
        helper.proceedtoSave(component, helper, warehousedata);
        helper.proceedtoSave(component, helper, fieddata);
        helper.proceedtoSave(component, helper, truckdata);
        
        component.set("v.isSubmitted", true);
        component.set("v.clearChecklist", true);
        component.set("v.openConfirmationBox",false);
        component.set("v.openProgressModal",true);
        component.set("v.disableButton", true);
        component.set("v.isCopied", true);
    },
	disableSubmit: function (component, event, helper) {    
        component.set("v.disableSubmit", true);
    },
	confirm : function (component, event, helper) {    
        
      component.set("v.openConfirmationBox", true);
    },
    hideInprogressModal: function (component, event, helper) {    
        
      component.set("v.openProgressModal", false);
        
    }, 
    hideConfirmationBox: function (component, event, helper) {    
        
      component.set("v.openConfirmationBox", false);
        
    }, 
    hideCriteriaModal: function (component, event, helper) {    
        
      component.set("v.openCriteriaModal", false);
        
    }, 
    showCriteriaModal: function (component, event, helper) {    
        
      component.set("v.openCriteriaModal", true);
        
    }, 
    copyLastMonthRecord: function (component, event, helper) {    
		component.set("v.copylastmonthrecord", true);
		        
        var lmdata = component.get("v.lmData");
        //console.log(JSON.stringify(lmdata));
        if (!Object.keys(lmdata).length) {
          alert("No Last month record to copy!")
          component.set("v.isCopied", false);
        } else {
          alert("Successfully copy last month record!");
          component.set("v.isCopied", true);
        }
        
        component.set("v.disableCopy", true);
        
    }
})