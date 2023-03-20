@isTest
public class UNILAB_MT_INVENTORY_TEST {
	@isTest
    private static void getProductWithoutFilter() {
        
        List<Product2> prod = new List<Product2> ();
        for(Integer i=0; i<5; i++) {
            Product2 pd = new Product2();
            pd.Item_Code__c = 'Test item code ' + i;
            pd.Name = 'Test name ' + i;
            pd.IsActive = true;
            prod.add(pd);
        }
        
        insert prod;
        
        Test.startTest();
        
        List<Product2> fetchProductList = UNILAB_MT_INVENTORY.fetch(null, '10', '1', null);

        Test.stopTest();
        
        System.assert(fetchProductList.size() > 0);
    }
    
    @isTest
    private static void getProductWithFilter() {
        
        List<Product2> prod = new List<Product2> ();
        for(Integer i=0; i<5; i++) {
            Product2 pd = new Product2();
            pd.Item_Code__c = 'Test item code ' + i;
            pd.Name = 'Test name ' + i;
            pd.IsActive = true;
            prod.add(pd);
        }
        
        insert prod;
        
        Test.startTest();
        
        List<Product2> fetchProductList = UNILAB_MT_INVENTORY.fetch(null, '10', '1', 'Test');

        Test.stopTest();
        
        System.assert(fetchProductList.size() > 0);
    }
    
    @isTest
    private static void saveInventory() {
        
        List<Product2> prod = new List<Product2> ();
        for(Integer i=0; i<5; i++) {
            Product2 pd = new Product2();
            pd.Item_Code__c = 'Test item code' + i + i;
            pd.Name = 'Test name ' + i;
            pd.IsActive = true;
            prod.add(pd);
        }
        
        insert prod;
        
        List<Inventory__c> inventory = new List<Inventory__c>();
        Inventory__c inv = new Inventory__c();
        
        inv.Item_Code__c = 'Test item code 1';
        inv.Status__c = 'Carried';
        inventory.add(inv);
        
        Test.startTest();
        
        String saveInventory = UNILAB_MT_INVENTORY.saveForm(inventory, null);

        Test.stopTest();
        
        System.assert(saveInventory!=null);
    }
}