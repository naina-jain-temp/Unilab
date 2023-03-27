public with sharing class hadleBaseSelectionSheet {
    @AuraEnabled(cacheable=true)
    public static ProductDetailWrapper getProductDetails(String recordId) {
        ProductDetailWrapper productDetail = new ProductDetailWrapper();
        Hat_Allocation__c hat  =  [SELECT Product__r.GLU_Name__c,Product__r.Cluster_Name__c,Product__r.Brand_Name__c,Product__r.StockKeepingUnit,Product__r.Family FROM Hat_Allocation__c WHERE Id =: recordId];
        productDetail.glu = hat.Product__r.GLU_Name__c; 
        productDetail.cluster = hat.Product__r.Cluster_Name__c; 
        productDetail.brand = hat.Product__r.Brand_Name__c; 
        productDetail.sku = hat.Product__r.StockKeepingUnit; 
        productDetail.family = hat.Product__r.Family; 

        return productDetail;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String,Map<String,Double>> getTotalSalesValues(String recordId,Integer noOfMonths,Integer choosenMonth,Integer choosenYear)
    {
        system.debug('Entered');
        Hat_Allocation__c hatAlloc = [SELECT Product__c FROM Hat_Allocation__c where Id=:recordId];
        Id productId = hatAlloc.Product__c;
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

        Map<String,Map<String,Double>> salesDataMap = new Map<String,Map<String,Double>>();
        String pastMonthsString = '\'' + String.join(pastMonths, '\', \'') + '\'';
        String query ='SELECT calmonth__c, grossup_ty__c, ct_customer_team__c FROM Public_vw_report_ahat_siso_p6__x WHERE material_id__r.Id = \'' + productId + '\' AND calmonth__c IN (' +pastMonthsString+')';
        // 'SELECT calmonth__c,grossup_ty__c,ct_customer_team__c FROM Public_vw_report_ahat_siso_p6__x WHERE material_id__r.Id =:'+productId+'AND calmonth__c IN:'+ pastMonths;
        // Database.QueryLocator queryLocator = Database.getQueryLocator(query);

        List<Public_vw_report_ahat_siso_p6__x> extInstance = Database.query(query);
        
        for(Public_vw_report_ahat_siso_p6__x sisoData : extInstance)
        {
            if(!salesDataMap.containsKey(sisoData.ct_customer_team__c))
            {
                AvgMonthValueWrapper monValWrap = new AvgMonthValueWrapper();
                monValWrap.grossValue = sisoData.grossup_ty__c;
                monValWrap.month = sisoData.calmonth__c;

                Map<String,Double> dummyMap = new Map<String,Double>();
                dummyMap.put(monValWrap.month,monValWrap.grossValue);
                // HatSalesDetailWrapper mainWrapper = new HatSalesDetailWrapper();
                // mainWrapper.customerName = sisoData.ct_customer_team__c;
                // mainWrapper.monthValueWrap = monValWrap;

                salesDataMap.put(sisoData.ct_customer_team__c,dummyMap);
            }
            else{
                //This case suggests salesDataMap already has Customer in it.
                Map<String,Double> monthValueWrap = salesDataMap.get(sisoData.ct_customer_team__c);
                system.debug('MapofMonth'+monthValueWrap);

                Double grossSales = monthValueWrap.get(sisoData.calmonth__c); 
                grossSales += sisoData.grossup_ty__c;

                monthValueWrap.put(sisoData.calmonth__c,grossSales);
                system.debug('InnerMap'+monthValueWrap);
                // monthValueWrap.grossValue += sisoData.grossup_ty__c;

                salesDataMap.put(sisoData.ct_customer_team__c,monthValueWrap);
            }
        } 

        system.debug('Returned_Map'+salesDataMap);
        return salesDataMap;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getCustomerTeamValues(){
        List<String> customerList = new List<String>();
        List<Customer_Team_List__mdt> rowList = [SELECT Customer_Name__c FROM Customer_Team_List__mdt ORDER BY Order__c ];
        for (Customer_Team_List__mdt row : rowList){
            customerList.add(row.Customer_Name__c);
        }
        return customerList;
    }

    public class ProductDetailWrapper{
        @AuraEnabled
        public String glu{get;set;}
        @AuraEnabled
        public String cluster{get;set;}
        @AuraEnabled
        public String brand{get;set;}
        @AuraEnabled
        public string sku{get;set;}
        @AuraEnabled
        public String family{get;set;}
    }

    // public class HatSalesDetailWrapper
    // {   
    //     @AuraEnabled
    //     public String customerName {get;set;}
    //     @AuraEnabled
    //     public AvgMonthValueWrapper monthValueWrap
    // }

    public class AvgMonthValueWrapper
    {
        @AuraEnabled
        public String month {get;set;}
        @AuraEnabled
        public Double grossValue {get;set;}
    }
}