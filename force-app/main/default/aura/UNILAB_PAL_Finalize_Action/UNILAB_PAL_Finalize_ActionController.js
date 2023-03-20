({
    doInit: function (component, event, helper) {
        helper.fetchAllocationData(component, event, helper);
        
    },
    saveAlloc : function(component, event, helper){
        var allocRecord = component.get('v.allocRec');
        
        if(!allocRecord.Over_Allocated__c && allocRecord.Total_Account_Allocation__c > 0 && allocRecord.Allocation_Volume__c != null && allocRecord.Start_Date__c != null && allocRecord.End_Date__c != null && (allocRecord.Sell_in__c != null || allocRecord.Sell_out__c != null)){
                helper.updateAllocationData(component, event, helper);
        }else{
            
            if(allocRecord.Over_Allocated__c){
                helper.showToast({'message' : 'Cannot finalize allocation because of overallocated account allocations.',
                                  'type':'error',
                                  'title':''});
            }else if(allocRecord.Total_Account_Allocation__c <= 0){
                helper.showToast({'message' : 'Cannot finalize allocation because there is no account allocation.',
                                  'type':'error',
                                  'title':''});
            }else{
                helper.showToast({'message' : 'Cannot finalize allocation.',
                                  'type':'error',
                                  'title':''});
            }
        }
    },
    
    cancelAlloc: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
})