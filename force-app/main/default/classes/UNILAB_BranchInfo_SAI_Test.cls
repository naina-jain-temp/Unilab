@isTest
public class UNILAB_BranchInfo_SAI_Test {
	public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    
    @isTest
    public static void fetchSAI() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            
            List<Account> acctList = TestDataFactory.createAccount(10);
            insert acctList;
            
            Test.startTest();
                List<public_vw_data_sales_so_ob_pos_mt_s0__x> fetch = UNILAB_BranchInfo_SAI.fetchSAI(acctList[0].Id);
            Test.stopTest();
            System.assert(fetch!=null);
        }
    }
}