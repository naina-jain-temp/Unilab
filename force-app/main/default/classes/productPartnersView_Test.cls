@isTest
public class productPartnersView_Test {
	public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    @isTest static void fetch() {
        system.runAs(testUser1){
            List<Product2> prod2List = TestDataFactory.createProducts(20);
            
            Test.startTest();
                String fetchProducts = productPartnersView.fetchProducts();
            Test.stopTest();
            System.assert(String.isNotBlank(fetchProducts));
        }
    }
}