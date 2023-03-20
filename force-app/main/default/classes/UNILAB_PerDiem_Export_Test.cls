@isTest
public class UNILAB_PerDiem_Export_Test {
	public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();	
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    
    @isTest static void fetchPDSummary() {
     	system.runAs(testUser1){
            Date startDate = Date.today().addDays(-5);
            Date endDate = Date.today();
            String overallStatus = 'For Approval';
            String divisionGroup = 'SALES & CUSTOMER DEVELOPMENT';
        	Test.startTest();
            	List<AggregateResult> PDSummary = UNILAB_PerDiem_Export.fetchPDSummary(startDate,endDate,overallStatus,divisionGroup);
            Test.stopTest();
        }
     }
    
    @isTest static void fetchPDDetails() {
     	system.runAs(testUser1){
            Date startDate = Date.today().addDays(-5);
            Date endDate = Date.today();
            String overallStatus = 'Draft';
            String divisionGroup = 'SALES & CUSTOMER DEVELOPMENT';
        	Test.startTest();
            	List<Per_Diem_Item__c> PDDetails = UNILAB_PerDiem_Export.fetchPDDetails(startDate,endDate,overallStatus,divisionGroup);
            Test.stopTest();
        }
     }
}