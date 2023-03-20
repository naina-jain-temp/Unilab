public class PerDiemCSVController {
    @AuraEnabled
    public static List<Per_Diem_Item__c> fetch(String recordId){
        
        List<Per_Diem_Item__c> perdiemItemList = new List<Per_Diem_Item__c>();
        
        for(Per_Diem_Item__c perdiemItem: [SELECT 
                                           CreatedDate,
                                           Employee_ID__c,
                                           Division__c,
                                           HB_OHB__c,
                                           Place_of_Work__c,
                                           Number_of_Days__c
                                  FROM Per_Diem_Item__c 
                                  WHERE Sub_Activity_Report__c =:recordId
                                  LIMIT 1000]) {
            perdiemItemList.add(perdiemItem);
        }
        List<Per_Diem_Item__c> mergeResultList = new List<Per_Diem_Item__c>();
        
        Per_Diem_Item__c mergeResult = new Per_Diem_Item__c();
            
        for(Per_Diem_Item__c item : perdiemItemList) {
            String locationCstm = item.Place_of_Work__c;
            if(String.isEmpty(locationCstm)) {
                locationCstm = '';
            }
            mergeResult = new Per_Diem_Item__c(CreatedDate = item.CreatedDate,
                                                Employee_ID__c = item.Employee_ID__c,
                                                Division__c = item.Division__c,
                                                HB_OHB__c = item.HB_OHB__c,
                                                Place_of_Work__c = locationCstm,
                                                Number_of_Days__c = item.Number_of_Days__c);
            mergeResultList.add(mergeResult);
        }
        
        return mergeResultList;
    }
}