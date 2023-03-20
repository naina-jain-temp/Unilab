({
    init : function(component, event, helper) {
        helper.getISPLogStatus(component, event);
    },
    
	downloadOnClick : function(component, event, helper) {
		//helper.loadAccountData(component, event);
        helper.downloadTemplate(component, event);
	},
    
    CreateRecord: function (component, event, helper) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        
        if (file) {
            //console.log("File");
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                
                //console.log("EVT FN");
                var csv = evt.target.result;
                //console.log('csv file contains = '+ csv);
                var result = helper.CSV2JSON(component,csv);
                console.log('result = ' + result);
                //console.log('Result = '+JSON.parse(result));
                helper.CreateISPlan(component,result);
                
            }
            reader.onerror = function (evt) {
                //console.log("error reading file");
            }
        } else {

            helper.showToast('Error','Error','No File Selected.');
        }
        
    },
    
    showfiledata :  function (component, event, helper){        
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if (file) {
            component.set("v.showcard", true);
            //console.log("File");
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                var csv = evt.target.result;
                var table = document.createElement("table");
                var rows = csv.split("\n");
                for (var i = 0; i < rows.length; i++) {
                    var cells = rows[i].split(",");
                    if (cells.length > 1) {
                        var row = table.insertRow(-1);
                        for (var j = 0; j < cells.length; j++) {
                            var cell = row.insertCell(-1);
                            cell.innerHTML = cells[j];
                        }
                    }
                }
                var divCSV = document.getElementById("divCSV");
                divCSV.innerHTML = "";
                divCSV.appendChild(table);
            }
            reader.onerror = function (evt) {
                //console.log("error reading file");
            }
        }
    },
    
    closeModal: function(component, event, helper) {
        var url = window.location.href; 
            var value = url.substr(0,url.lastIndexOf('/') + 1);
            window.history.back();
            return false;
    },
    nextToModal: function(component, event, helper) {
        var accType = component.get("v.accountType");
        if(accType == "Head Office") {
            component.set("v.accountTypeLabel", "Total");
        } else {
            component.set("v.accountTypeLabel", "Nomination");
        }
        helper.loadAccountData(component, event);
        component.set("v.isModalOpen", false);
    },
    closeErrModal: function(component, event, helper) {
        component.set("v.errmsgModal", false);
    }
})