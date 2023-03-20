@isTest
public class UNILAB_BranchInfo_AcctSched_Test {
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
    public static void fetchAcctSched() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            List<Account> acctList = TestDataFactory.createAccount(10);
            
            insert acctList;
            
            Test.startTest();
                List<Account> fetch = UNILAB_BranchInfo_AcctSched.fetchAcctSched(acctList[0].Id);
            Test.stopTest();
            System.assert(fetch!=null);
        }
    }
    
}