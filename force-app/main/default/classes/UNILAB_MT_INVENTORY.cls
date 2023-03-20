public class UNILAB_MT_INVENTORY {
	@AuraEnabled
    public static List<Product2> fetch(string recordID, String pageSize, String pageNumber, String filterValue) {
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        String queryFilter = '';
        String filterKey = filterValue + '%';
        List<Product2> prod;
        
        if(filterValue!=null) {
            prod = [SELECT Id, 
                    Item_Code__c, 
                    Name 
                    FROM Product2
                    WHERE IsActive=true 
                    AND (Item_Code__c LIKE: filterKey 
                         OR Name LIKE: filterKey) 
                    ORDER BY Name ASC
                    LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)];
        } else {
            prod = [SELECT Id, 
                    Item_Code__c, 
                    Name 
                    FROM Product2
                    WHERE IsActive=true 
                    ORDER BY Name ASC
                    LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)];
        }
        
        return prod;
    }
    
    @AuraEnabled
    public static String saveForm(List<Inventory__c> inventoryData, String recordID) {
        String userId = userInfo.getUserId();
        Date todayDate = Date.today() ;
        System.debug(inventoryData);
        List<Inventory__c> inventoryCheckList = new List<Inventory__c>();
        
        Inventory__c inventoryCheckListItem = new Inventory__c();
        for (Inventory__c inv : inventoryData) {
            inventoryCheckListItem = new Inventory__c(Item_Code__c = inv.Item_Code__c,
                                                    Account__c = recordID,
                                                    Status__c = inv.Status__c
                                                    );
            
            inventoryCheckList.add(inventoryCheckListItem);
        }    
        
        insert inventoryCheckList;
        
        return inventoryCheckListItem.Id;

    }
}