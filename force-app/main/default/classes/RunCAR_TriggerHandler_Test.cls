@isTest 
public class RunCAR_TriggerHandler_Test {
	public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    
    @isTest static void insertCase(){
        system.runAs(testUser1){
            Test.startTest();
            	Case newCase = new Case();
            	newCase.Type = 'Distribution Systems';
            	newCase.Sub_Type__c='PHOENIX (RFCM)';
            	newCase.Subject = 'Test';
            	newCase.Description = 'Test';
            	newCase.Priority = 'High';
            	newCase.Origin = 'N/A';
            	newCase.Status = 'New';
            	
            	insert newCase;
            Test.stopTest();
        }
    
    }
}