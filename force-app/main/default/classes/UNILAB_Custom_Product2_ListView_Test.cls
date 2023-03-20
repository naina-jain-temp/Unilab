@isTest
public class UNILAB_Custom_Product2_ListView_Test {
	public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    @isTest static void fetchProducts() {
    	system.runAs(testUser1){
            List<Product2> prod2List = TestDataFactory.createProducts(20);
            insert prod2List;      
            
            Test.startTest();
                List<Product2> fetchProductList = UNILAB_Custom_Product2_ListView.fetchProducts();
            Test.stopTest(); 
            System.assert(fetchProductList.size() > 0);
        	
        }
    }
}