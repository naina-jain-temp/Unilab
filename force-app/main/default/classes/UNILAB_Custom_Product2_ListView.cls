public class UNILAB_Custom_Product2_ListView {
	@AuraEnabled
    public static List<Product2> fetchProducts(){
        return [Select Id, 
                ProductCode, 
                Name, 
                StockKeepingUnit,
                Brand_Name__c,
                Family,
                Generic_Name__c
                From Product2
               Where IsActive = true];
    }
}