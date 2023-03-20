@isTest
public class UNILAB_Product_Pricing_Test {
	public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    @isTest static void fetchPrice() {
        system.runAs(testUser1){
            //List<Product2> prod2List = TestDataFactory.createProducts(20);
            //
            // First, set up test price book entries.
            // Insert a test product.
            Product2 prod = new Product2(Name = 'Laptop X200', 
                Family = 'Hardware');
            insert prod;
            
            // Get standard price book ID.
            // This is available irrespective of the state of SeeAllData.
            Id pricebookId = Test.getStandardPricebookId();
            
            // 1. Insert a price book entry for the standard price book.
            // Standard price book entries require the standard price book ID we got earlier.
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prod.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            // Create a custom price book
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            
            // 2. Insert a price book entry with a custom price.
            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;
            
            Test.startTest();
                decimal fetchPrice = UNILAB_Product_Pricing.fetchPrice(prod.Id,'Custom Pricebook');
            Test.stopTest();
            System.assert(fetchPrice >= 0);
        }
    }
}