({
	doInit : function(component, event, helper) {
        
        helper.listOfAlphabet(component);
        helper.getProducts(component, event, helper);
        
        if (component.get('v.recordId') != null) {
            helper.getSubActivityReportDetails(component);
        }
        
	},
    
    showProducts : function(component) {
        
        component.set('v.showProductsModal', true);
        
    },
    
    closeProductsModal : function(component) {
        
        component.set('v.showProductsModal', false);
        
    },
    
    showSubmitConfirmationModal : function(component) {
        
        component.set('v.showSubmitConfirmationModal', true);
        
    },
    
    closeSubmitConfirmationModal : function(component) {
        
        component.set('v.showSubmitConfirmationModal', false);
        
    },
    
    goBack : function(component, event, helper) {
        
        var event = $A.get('e.force:navigateToSObject');
        
        event.setParams({
            'recordId' : component.get('v.recordId'),
            'slideDevName' : 'Detail'
        }).fire();
        
    },
    
    checkboxSelect : function(component, event) {
        
        var selectedRec = event.getSource().get('v.value');
        var getSelectedNumber = component.get('v.selectedCount');
        
        if (selectedRec == true) {
            getSelectedNumber++;
        }
        else {
            getSelectedNumber--;
        }
        
        component.set("v.selectedCount", getSelectedNumber);
        
    },
    
    filterByKeyword : function(component, event, helper) {
        
        var data = component.get('v.defaultData');
        var term = component.get('v.filterKeyword');
        
        var results = data;
        var regex;
        
        regex = new RegExp(term, "i");
        results = data.filter(row=>regex.test(row.prod2.Name));
        
        component.set('v.updatedListOfRecords', results);
        helper.displayUpdatedListOfRecords(component, results);
        
    },
    
    filterByLetter : function(component, event, helper) {
        
        component.set('v.selectedAlphabet', (String)(event.target.name));
        
        var selectedAlphabet = component.get('v.selectedAlphabet');
        
        var data = component.get('v.defaultData');
        var term = "^" + selectedAlphabet;
        var results = data;
        var regex;
        
        if (selectedAlphabet == 'All') {
            
            regex = new RegExp();
            results = data.filter(row=>regex.test(row.prod2.Name));
            
        }
        
        else {
            
            regex = new RegExp(term, "g");
            results = data.filter(row=>regex.test(row.prod2.Name));
            
        }
        
        component.set('v.updatedListOfRecords', results);
        helper.displayUpdatedListOfRecords(component, results);
        
    },
    
    pageNavigation : function(component, event, helper) {
        
        var defaultData = component.get('v.defaultData');
        var updatedListOfRecords = component.get('v.updatedListOfRecords');
        
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var buttonName = event.getSource().get("v.name");
        
        if (buttonName == 'next') {
            
            component.set('v.currentPage', component.get('v.currentPage') + 1);
            
            if (updatedListOfRecords.length > 0) {
                helper.nextPage(component, event, updatedListOfRecords, end, start, pageSize);
            }
            else {
                helper.nextPage(component, event, defaultData, end, start, pageSize);
            }
            
        }
        
        else if (buttonName == 'previous') {
            
            component.set('v.currentPage', component.get('v.currentPage') - 1);
            
            if (updatedListOfRecords.length > 0) {
                helper.previousPage(component, event, updatedListOfRecords, end, start, pageSize);
            }
            else {
                helper.previousPage(component, event, defaultData, end, start, pageSize);
            }
            
        }
        
    },
    
    addSelectedProducts : function(component, event, helper) {
        
        var data = component.get('v.defaultData');
        var term = "true";
        var results = data;
        var regex;
        
        var selectedProductsIDList = [];
        var selectedProductsList = [];
        
        var selectedCount = component.get('v.selectedCount');
        
        regex = new RegExp(term, "i");
        results = data.filter(row=>regex.test(row.isChecked));
        
        for (var i = 0; i < results.length; i++) {
            
            selectedProductsIDList.push(
                results[i].prod2.Id
            );
            
            selectedProductsList.push(
                results[i]
            );
            
        }
        
        if (selectedCount == 0) {
            
            helper.showToastDisplay({
                "title" : "Something went wrong",
                "message" : "Please select at least one product",
                "type" : "error"
            });
            
        }
        
        else {
            
            component.set('v.selectedProductsIDList', selectedProductsIDList);
            component.set('v.selectedProductsList', selectedProductsList);
            component.set('v.showProductsModal', false);
            
        }
        
    },
    
    loadCustomProducts : function(component, event, helper) {
        
        var data = component.get('v.defaultData');
        var term = "true";
        var results = data;
        var regex;
        
        var selectedProductsIDList = [];
        var selectedProductsList = [];
        
        //var selectedCount = component.get('v.selectedCount');
        
        regex = new RegExp(term, "i");
        //results = data.filter(row=>regex.test(row.isChecked));
        
        for (var i = 0; i < results.length; i++) {
            
            selectedProductsIDList.push(
                results[i].prod2.Id
            );
            
            selectedProductsList.push(
                results[i]
            );
            
        }
            
        component.set('v.selectedProductsIDList', selectedProductsIDList);
        component.set('v.selectedProductsList', selectedProductsList);
		//$A.enqueueAction(component.get('c.handleClick'));
		
        helper.getProducts(component, event, helper);
		
        
    },
    
    saveRecord : function(component, event, helper) {
        component.set("v.showSpinner", true);
        var selectedProductsIDList = component.get('v.selectedProductsIDList');
        var selectedAccount = component.get('v.selectedAccount');
        //var pickListProductRemark = component.get('v.pickListProductRemark');
        var buttonName = event.getSource().get("v.name");
		
        if (Object.keys(selectedAccount).length == 0) {
            
            helper.showToastDisplay({
                "title" : "Required Field Missing",
                "message" : "Please select an Account.",
                "type" : "error"
            });
            
        }
        
        else {
            
            if (selectedProductsIDList.length == 0) {
                
                helper.showToastDisplay({
                    "title" : "Something went wrong",
                    "message" : "Please select at least one product",
                    "type" : "error"
                });
                
            }
            
            else {
                
                var len = component.find("select").length;
                var remarks = [];
                for (var i = 0; i < len; i++) {
                    remarks.push(component.find("select")[i].get("v.value"));
                }
                
                productRemarkList: remarks;
              	component.set('v.pickListProductRemark', remarks);
                
                var len = component.find("inputComment").length;
                var comment = [];
                for (var i = 0; i < len; i++) {
                    comment.push(component.find("inputComment")[i].get("v.value"));
                }
                
                productComment: comment;
              	component.set('v.inputProductComment', comment);
                
                helper.saveRecord(component, event, helper, buttonName);
                
            }
            
        }
        component.set("v.showSpinner", false);
    }
    
})