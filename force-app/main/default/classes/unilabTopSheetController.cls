public with sharing class unilabTopSheetController {
    // Map<String,List<TopSheetWrapper>>
    @AuraEnabled(cacheable=true)
    public static Map<String,TopSheetWrapper> getTopSheetDetails(String recordId,Integer noOfMonths,Integer choosenMonth,Integer choosenYear) 
    {
        // try {
            Hat_Allocation__c hatAlloc = [SELECT Account__r.Id,Item_Price_w_o_VAT__c FROM Hat_Allocation__c where Id=:recordId];
            Integer itemPriceVAT = Integer.valueOF(hatAlloc.Item_Price_w_o_VAT__c); 
            Id accountId = hatAlloc.Account__r.Id;
            List<String> pastMonths = new List<String>();
            Date currentDate = Date.today();
            Integer currentMonth = choosenMonth;
            Integer currentYear = choosenYear;
        
            for (Integer i = 0; i < noOfMonths; i++) 
            {
                Integer monthDetail = currentMonth - i;
                Integer year = currentYear;
                if (monthDetail <= 0) {
                    monthDetail += 12;
                    year -= 1;
                }
                Date newDate = Date.newInstance(year, monthDetail, 1);
                if(monthDetail<10){
                    String formattedDate = String.valueOf(year)+0+String.valueOf(monthDetail); 
                    pastMonths.add(formattedDate);
                }
                else{
                    String formattedDate = String.valueOf(year)+String.valueOf(monthDetail); 
                    pastMonths.add(formattedDate);
                }  
            }

            system.debug('MonthsTotal'+pastMonths);
            Map<String,TopSheetWrapper> salesDataMap = new Map<String,TopSheetWrapper>();
            TopSheetWrapper grandTotalWrapper = new TopSheetWrapper();

            for(Sales_Target__c sales : [SELECT Account_Customer_Name__c,Branch_Reg_SO_OB__c,CalMonth__c,SI_OB__c,SO_OB__c FROM Sales_Target__c where Account__r.Id=:accountId AND CalMonth__c IN: pastMonths])
            {

                if(!salesDataMap.containsKey(sales.Account_Customer_Name__c))
                {
                    TopSheetWrapper topWrap = new TopSheetWrapper();
                    topWrap.obTarget = sales.SI_OB__c;
                    topWrap.sellInActualAmount = 3556780;
                    topWrap.initialAllocQty = 8000;
                    
                    // topWrap.sot = 1;
                    // topWrap.sob = 1;
                    // topWrap.initialImpactVsActual = 1;
                    // topWrap.finalImpactVsActual = 1;

                    //itemprice * initialAllocQty
                    topWrap.initialAllocAmt = itemPriceVAT * topWrap.initialAllocQty;
                    topWrap.wAlloc = 'Y';
                    //initialAllocAmt / sellInActualAmount
                    topWrap.initialImpactVsActual = ((topWrap.initialAllocAmt / topWrap.sellInActualAmount)*100).setScale(2);
                    //Manual either 0 or 1
                    topWrap.adjustmentQty = 1;
                    // initialAllocQty + adjustmentQty
                    topWrap.finalAllocQty = topWrap.initialAllocQty + topWrap.adjustmentQty;
                    // finalAllocQty * itemPrice
                    topWrap.finalAllocAmt = topWrap.finalAllocQty * itemPriceVAT;
                    // finalAllocAmt / sellInActualAmount 
                    topWrap.finalImpactVsActual = ((topWrap.finalAllocAmt / topWrap.sellInActualAmount)*100).setScale(2);

                    salesDataMap.put(sales.Account_Customer_Name__c,topWrap);
                    system.debug('SalesDataOne'+salesDataMap);
                }
                else
                {
                    TopSheetWrapper topSheetWrap = salesDataMap.get(sales.Account_Customer_Name__c);
                    topSheetWrap.obTarget += sales.SI_OB__c;
                    salesDataMap.put(sales.Account_Customer_Name__c,topSheetWrap);
                }
            }

        
            List<TopSheetWrapper> finalWrapper = new List<TopSheetWrapper>();
            List<String> customerNameList = new List<String>();
            for(Customer_Team_List__mdt customer : [SELECT Customer_Name__c FROM Customer_Team_List__mdt ORDER BY Order__c ])
            {
                customerNameList.add(customer.Customer_Name__c);
                TopSheetWrapper wrap = salesDataMap.get(customer.Customer_Name__c);
                if(wrap!=null)
                {
                    finalWrapper.add(wrap);
                }
            }

            for(TopSheetWrapper grandValue: finalWrapper)
            {
                grandTotalWrapper.obTarget += grandValue.obTarget;
                grandTotalWrapper.sellInActualAmount += grandValue.sellInActualAmount;
                grandTotalWrapper.initialAllocQty += grandValue.initialAllocQty;
                grandTotalWrapper.initialAllocAmt += grandValue.initialAllocAmt;
                grandTotalWrapper.adjustmentQty = 1;
                grandTotalWrapper.wAlloc = '';
                grandTotalWrapper.allocationSOB = 100.0;
                grandTotalWrapper.sot = 100.0;
                grandTotalWrapper.sob = 100.0;
                grandTotalWrapper.finalAllocQty += grandValue.finalAllocQty;
                grandTotalWrapper.finalAllocAmt += grandValue.finalAllocAmt;
            }

                grandTotalWrapper.initialImpactVsActual = ((grandTotalWrapper.initialAllocAmt / grandTotalWrapper.sellInActualAmount)*100).setScale(2);
                grandTotalWrapper.finalImpactVsActual = ((grandTotalWrapper.finalAllocAmt / grandTotalWrapper.sellInActualAmount)*100).setScale(2);

            Map<String,TopSheetWrapper> finalMapToReturn = new Map<String,TopSheetWrapper>();
            for(String valUpdate : salesDataMap.keySet())     
            { 
                TopSheetWrapper updateWrapper = salesDataMap.get(valUpdate);
                updateWrapper.sot = ((updateWrapper.obTarget / grandTotalWrapper.obTarget)*100).setScale(2);
                updateWrapper.sob = ((updateWrapper.sellInActualAmount / grandTotalWrapper.sellInActualAmount)*100).setScale(2);
                updateWrapper.allocationSOB = ((updateWrapper.sellInActualAmount / grandTotalWrapper.sellInActualAmount)*100).setScale(2);
                finalMapToReturn.put(valUpdate,updateWrapper);
            }

            finalMapToReturn.put('GrandTotal >>>>>',grandTotalWrapper);     
            system.debug('FinalReturnedMap'+finalMapToReturn);   
            return finalMapToReturn;
            
        } 
        // catch (Exception e) {
        //         String response = '';
        //         response = e.getMessage();
        //         TopSheetWrapper sheet = new TopSheetWrapper();
        //         Map<String,TopSheetWrapper> resp = new Map<String,TopSheetWrapper>();
        //         resp.put(response,sheet);
        //         return resp;
        //     }
    
        

        
    public class TopSheetWrapper
    {
            @AuraEnabled
            public Decimal obTarget {get;set;}
            @AuraEnabled
            public Decimal sellInActualAmount {get;set;}
            @AuraEnabled
            public Double initialAllocQty {get;set;}
            @AuraEnabled
            public Decimal initialAllocAmt {get;set;}
            @AuraEnabled
            public Decimal initialImpactVsActual {get;set;}
            @AuraEnabled
            public Double adjustmentQty {get;set;}
            @AuraEnabled
            public Double finalAllocQty {get;set;}
            @AuraEnabled
            public Decimal finalAllocAmt {get;set;}
            @AuraEnabled
            public Decimal finalImpactVsActual {get;set;}
            
            @AuraEnabled
            public Decimal sot {get;set;}
            @AuraEnabled
            public String wAlloc {get;set;}
            @AuraEnabled
            public Double sob {get;set;}
            @AuraEnabled
            public Double allocationSOB {get;set;}

            
            public TopSheetWrapper()
            {
                this.obTarget = 0;
                this.sellInActualAmount = 0;
                this.initialAllocQty = 0;
                this.initialAllocAmt = 0;
                this.sot = 0;
                this.sob = 0;
                this.adjustmentQty = 1;
                this.finalAllocAmt = 0;
                this.finalAllocQty = 0;
                this.wAlloc = 'Y';
            }
    }


}