@isTest
public class UNILAB_POC_INVENTORY_TEST {
    @isTest
    private static void getProductWithFilter() {
        
        List<Product_Availability_Item_Ref__c> prod = new List<Product_Availability_Item_Ref__c> ();
        for(Integer i=0; i<5; i++) {
            Product_Availability_Item_Ref__c pd = new Product_Availability_Item_Ref__c();
            pd.Other_Code__c = 'Test item code ' + i + i;
            pd.Must_Brand__c = 'Core 8';
            pd.Name = 'Test item code ' + i;
            pd.Channel__c = 'Hospitals';
           // pd.IsActive = true;
            prod.add(pd);
        }
        
        insert prod;
        
        List<Inventory__c> inventory = new List<Inventory__c>();
        Inventory__c inv = new Inventory__c();
        
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inventory.add(inv);
        
        insert inventory;
        
        Test.startTest();
        
        List<UNILAB_POC_INVENTORY.InventoryListWrapper> fetchProductList = UNILAB_POC_INVENTORY.fetch('', '10', '1', 'Core 8', '202103');

        Test.stopTest();
        
        System.assert(fetchProductList.size() > 0);
    }
    
    @isTest
    private static void saveInventory() {
        
        List<Product_Availability_Item_Ref__c> prod = new List<Product_Availability_Item_Ref__c> ();
        for(Integer i=0; i<5; i++) {
            Product_Availability_Item_Ref__c pd = new Product_Availability_Item_Ref__c();
            pd.Other_Code__c = 'Test item code' + i + i;
            pd.Must_Brand__c = 'Core 8';
            pd.Name = 'Test name ' + i;
            pd.Channel__c = 'Hospitals';
            //pd.IsActive = true;
            prod.add(pd);
        }
        
        insert prod;
        
        List<Inventory__c> inventory = new List<Inventory__c>();
        List<Inventory__c> prevInventory = new List<Inventory__c>();
        Inventory__c inv = new Inventory__c();
        
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202102';
        inv.Must_Brand__c = 'Core 8';
        prevInventory.add(inv);
        
        insert prevInventory;
            
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inv.Must_Brand__c = 'Core 8';
        inventory.add(inv);
        
        Test.startTest();
        
        String saveInventory = UNILAB_POC_INVENTORY.saveForm(inventory, null, 'Core 8', '202103', 'Save as Draft');

        Test.stopTest();
        
        System.assert(saveInventory!=null);
    }
    
    @isTest
    private static void saveWithoutPrevious() {
        
        List<Product_Availability_Item_Ref__c> prod = new List<Product_Availability_Item_Ref__c> ();
        for(Integer i=0; i<5; i++) {
            Product_Availability_Item_Ref__c pd = new Product_Availability_Item_Ref__c();
            pd.Other_Code__c = 'Test item code' + i + i;
            pd.Must_Brand__c = 'Core 8';
            pd.Name = 'Test name ' + i;
            pd.Channel__c = 'Hospitals';
            //pd.IsActive = true;
            prod.add(pd);
        }
        
        insert prod;
        
        List<Inventory__c> inventory = new List<Inventory__c>();
        List<Inventory__c> prevInventory = new List<Inventory__c>();
        Inventory__c inv = new Inventory__c();
            
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inventory.add(inv);
        
        Test.startTest();
        
        String saveInventory = UNILAB_POC_INVENTORY.saveForm(inventory, null, 'Core 8', '', 'Save as Draft');

        Test.stopTest();
        
        System.assert(saveInventory!=null);
    }
    
    @isTest
    private static void saveWithInventoryEqualPrevious() {
        
        List<Product_Availability_Item_Ref__c> prod = new List<Product_Availability_Item_Ref__c> ();
        for(Integer i=0; i<5; i++) {
            Product_Availability_Item_Ref__c pd = new Product_Availability_Item_Ref__c();
            pd.Other_Code__c = 'Test item code' + i + i;
            pd.Must_Brand__c = 'Core 8';
            pd.Name = 'Test name ' + i;
            pd.Channel__c = 'Hospitals';
            //pd.IsActive = true;
            prod.add(pd);
        }
        
        insert prod;
        
        List<Inventory__c> inventory = new List<Inventory__c>();
        List<Inventory__c> prevInventory = new List<Inventory__c>();
        Inventory__c inv = new Inventory__c();
        
        inv.Item_Name__c = 'Test item code 2';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202102';
        prevInventory.add(inv);
        
        insert prevInventory;
            
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inventory.add(inv);
        
        Test.startTest();
        
        String saveInventory = UNILAB_POC_INVENTORY.saveForm(inventory, null, 'Core 8', '202103', 'Save as Draft');

        Test.stopTest();
        
        System.assert(saveInventory!=null);
    }
    
    @isTest
    private static void submitInventory() {
        
        List<Product_Availability_Item_Ref__c> prod = new List<Product_Availability_Item_Ref__c> ();
        for(Integer i=0; i<5; i++) {
            Product_Availability_Item_Ref__c pd = new Product_Availability_Item_Ref__c();
            pd.Other_Code__c = 'Test item code' + i + i;
            pd.Must_Brand__c = 'Core 8';
            pd.Name = 'Test name ' + i;
            pd.Channel__c = 'Hospitals';
            //pd.IsActive = true;
            prod.add(pd);
        }
        
        insert prod;
        
        List<Inventory__c> inventory = new List<Inventory__c>();
        List<Inventory__c> prevInventory = new List<Inventory__c>();
        Inventory__c inv = new Inventory__c();
        
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inv.Form_Status__c = 'Save as Draft';
        prevInventory.add(inv);
        
        insert prevInventory;
            
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inv.Form_Status__c = 'Submit';
        inventory.add(inv);
        
        Test.startTest();
        
        String saveInventory = UNILAB_POC_INVENTORY.saveForm(inventory, null, 'Core 8', '202103', 'Submit');

        Test.stopTest();
        
        System.assert(saveInventory!=null);
    }
    
    @isTest
    private static void formStatusTest() {
        
        List<Inventory__c> inventory = new List<Inventory__c>();
        Inventory__c inv = new Inventory__c();
            
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inv.Must_Brand__c = 'Core 8';
        inv.Form_Status__c = 'Submit';
        inventory.add(inv);
        
        insert inventory;
        
        Test.startTest();
        
        Boolean formStatusAssrt = UNILAB_POC_INVENTORY.formStatus(null, 'Core 8', '202103');

        Test.stopTest();
        
        System.assertEquals(formStatusAssrt, true);
    }
    
     @isTest
    private static void prevInventory() {
        
        List<Inventory__c> inventory = new List<Inventory__c>();
        Inventory__c inv = new Inventory__c();
          
        inv.Account__c = '0017F000006PAkSQAW';
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Period__c = '202103';
        inv.Must_Brand__c = 'Core 8';
        inv.Form_Status__c = 'Submit';
        inventory.add(inv);
        
        insert inventory;
        
        Test.startTest();
        
        List<Inventory__c> prevInvAssrt = UNILAB_POC_INVENTORY.previousInventory('0017F000006PAkSQAW', 'Core 8', '202103');

        Test.stopTest();
        
        System.assert(prevInvAssrt.size() > 0);
    }
    
    @isTest
    private static void saveWithExistingInventory() {
        
        List<Product_Availability_Item_Ref__c> prod = new List<Product_Availability_Item_Ref__c> ();
        for(Integer i=0; i<5; i++) {
            Product_Availability_Item_Ref__c pd = new Product_Availability_Item_Ref__c();
            pd.Other_Code__c = 'Test item code' + i + i;
            pd.Must_Brand__c = 'Core 8';
            pd.Name = 'Test name ' + i;
            pd.Channel__c = 'Hospitals';
            //pd.IsActive = true;
            prod.add(pd);
        }
        
        insert prod;
        
        List<Inventory__c> inventory = new List<Inventory__c>();
        List<Inventory__c> exstInventory = new List<Inventory__c>();
        Inventory__c inv = new Inventory__c();
        
        inv.Item_Name__c = 'Test item code 2';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inv.Must_Brand__c = 'Core 8';
        inv.Form_Status__c = 'Save as Draft';
        exstInventory.add(inv);
        
        insert exstInventory;
            
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inv.Form_Status__c = 'Save as Draft';
        inventory.add(inv);
        
        Test.startTest();
        
        String saveInventory = UNILAB_POC_INVENTORY.saveForm(inventory, null, 'Core 8', '202103', 'Save as Draft');

        Test.stopTest();
        
        System.assert(saveInventory!=null);
    }
    
    @isTest
    private static void submitWithExistingInventory() {
        
        List<Product_Availability_Item_Ref__c> prod = new List<Product_Availability_Item_Ref__c> ();
        for(Integer i=0; i<5; i++) {
            Product_Availability_Item_Ref__c pd = new Product_Availability_Item_Ref__c();
            pd.Other_Code__c = 'Test item code' + i + i;
            pd.Must_Brand__c = 'Core 8';
            pd.Name = 'Test name ' + i;
            pd.Channel__c = 'Hospitals';
            //pd.IsActive = true;
            prod.add(pd);
        }
        
        insert prod;
        
        List<Inventory__c> inventory = new List<Inventory__c>();
        List<Inventory__c> exstInventory = new List<Inventory__c>();
        Inventory__c inv = new Inventory__c();
        
        inv.Item_Name__c = 'Test item code 2';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inv.Must_Brand__c = 'Core 8';
        inv.Form_Status__c = 'Save as Draft';
        exstInventory.add(inv);
        
        insert exstInventory;
            
        inv.Item_Name__c = 'Test item code 1';
        inv.Current_Inventory__c = 1;
        inv.Current_Offtake__c = 1;
        inv.Previous_Inventory__c = 2;
        inv.Previous_Offtake__c = 2;
        inv.Period__c = '202103';
        inv.Form_Status__c = 'Submit';
        inventory.add(inv);
        
        Test.startTest();
        
        String saveInventory = UNILAB_POC_INVENTORY.saveForm(inventory, null, 'Core 8', '202103', 'Submit');

        Test.stopTest();
        
        System.assert(saveInventory!=null);
    }
}