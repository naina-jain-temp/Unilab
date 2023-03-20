@isTest
public class UNILAB_PICOS_Label_Test {
    public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    
	@isTest static void fetchRES() {
    	system.runAs(testUser1){
            Account parentAcct = new Account();
            parentAcct.Name = 'Sample';
            parentAcct.Bill_To_Code__c = '0080101010';
            parentAcct.Branch_Code__c = '0080101010';
            parentAcct.Branch_Name__c = 'Sample';
            parentAcct.retail_environment__c = 'Smkt Premium Big no LTO';
            insert parentAcct;
            
            Test.startTest();
                String fetchRES = UNILAB_PICOS_Label.fetchRES(parentAcct.Id);
            Test.stopTest();
            System.assert(fetchRES!=null);
        }
    }
}