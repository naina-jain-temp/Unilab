({
    
    checkAllocation: function(component, event, helper){
        
        var action = component.get("c.allocationIsEmpty");
        action.setParams({
            recordId : component.get("v.idValue")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                helper.fetchColumns(component, event, helper);
                helper.fetchPromoData(component, event, helper);
            }else{
                var event = $A.get( 'e.force:navigateToSObject' );
                var recId = component.get("v.idValue");
                event.setParams({
                    'recordId' : recId,
                    'slideDevName' : 'Detail' ,
                    'isRedirect' : true
                }).fire();  
            }
            
        });
        
    },
    
    fetchColumns: function(component, event, helper){
        
        var action = component.get("c.getColumns");
        var columns = [];
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if(state === "SUCCESS"){
                
                
                var allValues = response.getReturnValue();
                //alert(JSON.stringify(allValues));
                var columns = [];
                for(var i=0;i<allValues.length;i++){
                    //alert(allValues[i]['columnName']);
                    var column = {label: allValues[i]['columnName'], 
                                  fieldName: allValues[i]['columnFieldName'], 
                                  type:allValues[i]['columnType'],
                                  initialWidth:allValues[i]['initialWidth']};
                    columns.push(column);
                }
                
                component.set('v.gridColumns', columns);
                // data
                
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchPromoData : function(component, event, helper){
        //Used for fetching Allocation Data
        component.set('v.spinner',true);
        var action = component.get("c.getAllocationRecords");
        
        action.setParams({
            recordId : component.get("v.idValue")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var allocList = response.getReturnValue();
                component.set('v.spinner',false); 
                component.set('v.allocList', allocList);
                var totalAlloc = 0;
                for(var i = 0; i<allocList.length; i++){
                    totalAlloc += allocList[i].Allocation_Volume__c;
                }
                
                component.set('v.totalAllocation', totalAlloc);
                //console.log('PROMO DATA - ' + JSON.stringify(allocList));
                component.set('v.promoName', allocList[0].Promo__r.Promo_Name__c);
                component.set('v.promoStatus', allocList[0].Promo__r.Status__c);
                helper.getAccAllocHierarchy(component, event, helper );
            }  else if (state === "ERROR") {        
                helper.handleErrors(response.getError());  
            }
            
        });
        $A.enqueueAction(action);
        component.set('v.spinner',false);
        
    },
    
    getAccAllocHierarchy : function (component,event,helper) {
        var allocList = component.get("v.allocList");
        //alert(JSON.stringify(allocList));
        
        component.set('v.spinner',true);
        var action = component.get("c.getTreeGridData");
        action.setParams({
            "allocList": allocList
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accountTeamcheck = component.get("v.accountTeams");
                var accountGroupcheck = component.get("v.accountGroups");
                
                var data = response.getReturnValue();
                console.log('DATA' + JSON.stringify(data));
                var temojson = JSON.parse(JSON.stringify(data.channelWrapper).split('items').join('_children'));
                var temojson1 = JSON.parse(JSON.stringify(temojson).split('items').join('_children'));
                var temojson2 = JSON.parse(JSON.stringify(temojson1).split('items').join('_children'));
                console.log(JSON.stringify(data));
                
                var gridAllocDataTeam =  JSON.parse(temojson1); 
                var gridAllocDataGroup =  JSON.parse(temojson2); 
                
                
                var tempArray = [];
                var tempArray2 = [];
                var k = 0;
                var l = 0;
                
                for(var i=0; i<gridAllocDataTeam.length; i++){
                    if(gridAllocDataTeam[i]['_children'] != undefined){
                        for(var j=0; j<gridAllocDataTeam[i]['_children'].length; j++){
                            tempArray[k] = gridAllocDataTeam[i]['_children'][j];
                            k++;
                        }
                    }
                }
                gridAllocDataTeam = [];
                for(var i = 0; i< tempArray.length; i++){
                    gridAllocDataTeam[i] = tempArray[i];
                }
                
                for(var i=0; i<tempArray.length; i++){
                    if(tempArray[i]['_children'] != undefined){
                        for(var j=0; j<tempArray[i]['_children'].length; j++){
                            tempArray2[l] = tempArray[i]['_children'][j];
                            l++;
                        }
                    }
                }
                gridAllocDataGroup = [];
                for(var i = 0; i< tempArray2.length; i++){
                    gridAllocDataGroup[i] = tempArray2[i];
                }
                //console.log('ACCOUNT GROUP: ' + JSON.stringify(gridAllocDataGroup));
                if(accountTeamcheck){
                    component.set('v.gridData',gridAllocDataTeam);
                    //alert('CHECKED!')
                }
                else if(accountGroupcheck){
                    component.set('v.gridData',gridAllocDataGroup);
                   	
                }else{
                    component.set('v.gridData',JSON.parse(temojson));
                   
                }
                
                component.set("v.totalNumberOfRows", data.totalAccounts);
                component.set("v.totalAccountTeam", data.totalTeams);
                component.set("v.totalAccountGroup", data.totalGroups);
                component.set('v.spinner',false);
                
                //component.set('v.gridData', JSON.parse(temojson));
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
        
    },
    
    handleErrors : function(component, errors) {
    },
})