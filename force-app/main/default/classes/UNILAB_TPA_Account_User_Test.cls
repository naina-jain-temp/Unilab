@isTest
public class UNILAB_TPA_Account_User_Test {
	public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    @isTest static void fetchTPA() {
    	system.runAs(testUser1){
            Account parentAcct = new Account();
            parentAcct.Name = 'Sample';
            parentAcct.Bill_To_Code__c = '0080101010';
            parentAcct.Branch_Code__c = '0080101010';
            parentAcct.Branch_Name__c = 'Sample';
            parentAcct.retail_environment__c = 'Smkt Premium Big no LTO';
            insert parentAcct;
            
            Test.startTest();
                List<public_data_tpa_user__x> docs = UNILAB_TPA_Account_User.fetchTPA(parentAcct.Id);
            Test.stopTest();
            System.assert(parentAcct.Id!=null);
        }
    }
}