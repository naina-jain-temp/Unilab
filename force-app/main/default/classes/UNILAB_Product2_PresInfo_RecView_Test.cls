@isTest
public class UNILAB_Product2_PresInfo_RecView_Test {
	public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    @isTest static void fetchPPI() {
        system.runAs(testUser1){
            List<Product2> prod2List = TestDataFactory.createProducts(20);
            
            Prescribing_Info__c ppiData = new Prescribing_Info__c();
            ppiData.Product_Information__c = 'Prod Info';
            ppiData.Product__c = prod2List[0].Id;
            insert ppiData;
            
            Test.startTest();
                String fetchPPI = UNILAB_Product2_PresInfo_RecView.fetchPPI(prod2List[0].Id);
            Test.stopTest();
            System.assert(String.isNotBlank(fetchPPI));
        }
    }
}