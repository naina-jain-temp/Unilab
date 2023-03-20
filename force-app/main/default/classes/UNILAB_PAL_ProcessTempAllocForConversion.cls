/*----------------------------------------------------------------------------------------------------
Authors      :   Joan Bautista and Mark Palacios
Created Date :   04.23.2019
Definition   :   Apex class for processing Temporary Allocation to be converted as Account Allocation
-----------------------------------------------------------------------------------------------------*/
public class UNILAB_PAL_ProcessTempAllocForConversion {
    public static List<Account_Allocation__c> processAccountAllocations (String allocId, String channel){
        
        Allocation__c alloc = UNILAB_PAL_Controller.getAllocRecs(allocId);
        List<Account_Allocation__c> accAllocFinalList = new List<Account_Allocation__c>();
        Map<Id, Account_Allocation__c> accountAllocMap = new Map<Id, Account_Allocation__c>();
        List<Account_Allocation__c> computedAllocationList = new List<Account_Allocation__c>();
        Decimal lyDiv = 1;
        
        try{
            
            //Get Average Gross and Quantity
            accountAllocMap = getAverageQtyAndGross(alloc.Channel__c);
            
            List<AggregateResult> tempAllocList = [SELECT SUM(Amount__c)Sum_Amount,AVG(Quantity__c)Ave_Qty,AVG(Amount__c)Ave_Amount,SFA_Internal_ID__c,Measure_Level__c,Channel__c
                                                   FROM Temporary_Allocation__c 
                                                   WHERE Channel__c =: alloc.Channel__c                                                  	   
                                                   GROUP BY SFA_Internal_ID__c,Measure_Level__c,Channel__c 
                                                  ];
            //Compute YTDTY and YTDLY   
            for(AggregateResult tempAlloc: tempAllocList){ 
                Id accountId = (Id) tempAlloc.get('SFA_Internal_ID__c');
                Account_Allocation__c accAlloc; 
                if(accountAllocMap.containsKey(accountId)){
                    accAlloc = accountAllocMap.get(accountId);
                }else{
                    accAlloc = new Account_Allocation__c();
                    accountAllocMap.put(accountId, accAlloc);
                }  
                
                String measureLevel = (String) tempAlloc.get('Measure_Level__c');
                if(measureLevel.equalsIgnoreCase('LYTD')){
                    accAlloc.YTDSales_LY__c = (Decimal) tempAlloc.get('Sum_Amount');
                }else if(measureLevel.equalsIgnoreCase('YTD')){
                    accAlloc.YTDSales_TY__c = (Decimal) tempAlloc.get('Sum_Amount');	
                }
                accAlloc.Account__c = accountId;
                accAlloc.Allocation__c = alloc.Id;
                accAlloc.Created_From_API__c = true;
            }   
            //Compute Growth                        
            for(AggregateResult tempAlloc: tempAllocList){
                Id accountId = (Id) tempAlloc.get('SFA_Internal_ID__c');
                Account_Allocation__c accAlloc; 
                if(accountAllocMap.containsKey(accountId)){
                    accAlloc = accountAllocMap.get(accountId);                    
                }else{
                    accAlloc = new Account_Allocation__c();
                    accountAllocMap.put(accountId, accAlloc);
                }                
                
                String measureLevel = (String) tempAlloc.get('Measure_Level__c');
                
                if(measureLevel.equalsIgnoreCase('P3') || measureLevel.equalsIgnoreCase('P6') || measureLevel.equalsIgnoreCase('P12')){
                    
                    if(accAlloc.YTDSales_LY__c == null || accAlloc.YTDSales_LY__c == 0){
                        lyDiv = 1;
                        accAlloc.YTDSales_LY__c = 0;
                    }else{
                        lyDiv = accAlloc.YTDSales_LY__c;
                    }
                    if(accAlloc.YTDSales_TY__c == null){
                        accAlloc.YTDSales_TY__c = 0;
                    }
                    
                    accAlloc.Growth__c = ((accAlloc.YTDSales_TY__c - accAlloc.YTDSales_LY__c)/lyDiv).setScale(2, RoundingMode.HALF_UP);
                }
            }
            
            List<Account_Allocation__c>  accountAllocList = new List<Account_Allocation__c>();
            
            for(Account_Allocation__c accAllocRec : accountAllocMap.values()){
                
                if(accAllocRec.Ave_Qty__c != null || accAllocRec.Ave_Qty__c > 0){
                    accountAllocList.add(accAllocRec);
                }
                
            }
            
            if(!accountAllocList.isEmpty()){
                
                computedAllocationList = computeAllFinalAllocation(alloc, accountAllocList, true);
                
                // Remove final allocation that is not in minimum                      
                accAllocFinalList = removeAccAllocNotInMinimum(alloc, computedAllocationList);
                
                //Recompute Final Allocation                         
                accAllocFinalList = computeAllFinalAllocation(alloc, accAllocFinalList, true);
                
                //insert accAllocFinalList;
            }   
            
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        return accAllocFinalList;
    }
    
    public static List<Account_Allocation__c> computeAllFinalAllocation(Allocation__c alloc, List<Account_Allocation__c> accAllocLists, Boolean isNew ){
        
        List<Account_Allocation__c> updatedAccountAllocList = new  List<Account_Allocation__c>();
        
        Decimal totalQuantity = 0;
        Integer countQuantity = 0;
        
        for(Account_Allocation__c accAlloc : accAllocLists){
            totalQuantity = totalQuantity + accAlloc.Ave_Qty__c;
            countQuantity = countQuantity + 1;
        }
        
        for(Account_Allocation__c accAllocRec : accAllocLists){
            
            accAllocRec.Business_Share__c = accAllocRec.Ave_Qty__c /  totalQuantity ;
            
            if(accAllocRec.Ave_Qty__c * 100 < 0){
                accAllocRec.Computed_Allocation__c =  Math.floor(((accAllocRec.Business_Share__c * alloc.Allocation_Volume__c) ).setScale(1, RoundingMode.DOWN));                      
            }else{
                accAllocRec.Computed_Allocation__c =  Math.floor(((accAllocRec.Business_Share__c * alloc.Allocation_Volume__c) ).setScale(1, RoundingMode.UP));                      
            }
            
            if(accAllocRec.Manual__c == null){
                accAllocRec.Manual__c = 0;
            }
            
            if(accAllocRec.Final_Allocation__c == null){
                accAllocRec.Final_Allocation__c = 0;
            }
            
            if(accAllocRec.Computed_Allocation__c == null){
                accAllocRec.Computed_Allocation__c = 0;
            }
            
            accAllocRec.Final_Allocation__c = accAllocRec.Computed_Allocation__c + accAllocRec.Manual__c;  
            updatedAccountAllocList.add(accAllocRec);
        }
        return updatedAccountAllocList;
    }
    
    public static Map<Id, Account_Allocation__c> getAverageQtyAndGross(String channel){
        Map<Id, Account_Allocation__c> averageMap = new Map<Id, Account_Allocation__c>();
        List<AggregateResult> averageList = new List<AggregateResult>();
        
        averageList = [SELECT AVG(Amount__c)Ave_Amount,AVG(Quantity__c)Ave_Qty,SFA_Internal_ID__c,Measure_Level__c,Channel__c
                       FROM Temporary_Allocation__c 
                       WHERE Channel__c =: channel AND Measure_Level__c  NOT IN ('LYTD','YTD')                                                     
                       GROUP BY SFA_Internal_ID__c,Measure_Level__c,Channel__c ];
        
        
        for(AggregateResult tempAllocAvg: averageList){
            Id accId =  (Id) tempAllocAvg.get('SFA_Internal_ID__c');
            
            Account_Allocation__c accAllocation = new Account_Allocation__c(); 
            accAllocation.Ave_Qty__c = (Decimal) tempAllocAvg.get('Ave_Qty');
            accAllocation.Ave_Gross_Sales__c = (Decimal) tempAllocAvg.get('Ave_Amount');
            
            averageMap.put(accId, accAllocation);
        }   
        
        return averageMap;
    }
    
    public static List<Account_Allocation__c> removeAccAllocNotInMinimum(Allocation__c alloc, List<Account_Allocation__c> accAllocLists){
        Decimal minimumAlloc = 0;
        List<Account_Allocation__c> finalList = new List<Account_Allocation__c>();
        
        List<PAL_Configuration__c> palConfigList = [SELECT Id, Minimum_Allocation__c, CONF_Channel__c
                                                    FROM PAL_Configuration__c 
                                                    WHERE CONF_Channel__c =: alloc.Channel__c ];
        
        if(!palConfigList.isEmpty() && palConfigList.size() > 0){
            PAL_Configuration__c palConfig = palConfigList[0]; 
            
            if(palConfig.Minimum_Allocation__c != null){
                minimumAlloc = palConfig.Minimum_Allocation__c;
            }            
        }
        
        for(Account_Allocation__c accAlloc : accAllocLists){
            if(accAlloc.Final_Allocation__c >= minimumAlloc){
                finalList.add(accAlloc);
            }
        }
        return finalList;
    }
}