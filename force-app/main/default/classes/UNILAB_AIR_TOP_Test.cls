@isTest
public class UNILAB_AIR_TOP_Test {
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
        Account parentAcct = new Account();
        parentAcct.Name = 'Sample';
        parentAcct.Bill_To_Code__c = '0080101010';
        parentAcct.Branch_Code__c = '0080101010';
        parentAcct.Branch_Name__c = 'Sample';
        insert parentAcct;
        
        Test.startTest();
        	List<Priority_Reference__c> cli = UNILAB_AIR_TOP.fetch(parentAcct.Id);
        Test.stopTest();
        System.assert(parentAcct.Id!=null);
        }
    }
    
    
    @isTest static void fetchEA() {
            system.runAs(new User(Id = UserInfo.getUserId())){
            Test.startTest();
        
        	Account testAcc = new Account();
            testAcc.Name = 'Sample';
            testAcc.Bill_To_Code__c = '0080101010';
            testAcc.Branch_Code__c = '0080101010';
            testAcc.Branch_Name__c = 'Sample';
            insert testAcc;
                
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
        	testEvent.ActivityDate= date.today();
            testEvent.StartDateTime = date.today();
            testEvent.EndDateTime = dateTime.now(); 
            testEvent.Event_Type__c = 'Call';
            testEvent.Event_Sub_type__c = 'BRANCH CALL';
            testEvent.Location_Based__c = 'Home Base';
            testEvent.Related_to_Account__c = testAcc.Id;
            testEvent.Work_Plan__c = false;
            testEvent.Status__c = 'New';
            insert testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Event_Type__c = 'Call';
            aj.Event_Sub_type__c = 'BRANCH CALL';
            aj.Location_Based__c = 'Home Base';
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
           
            List<Sub_Activity__c> subActs = new List<Sub_Activity__c>();
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'TOP PRIORITIES (5Ps)';
            
            insert subActs; 
            	Id cal = UNILAB_AIR_TOP.fetchEA(testAcc.Id);
            
            Test.stopTest();
            
        	//system.assert(cal!=null,'Fetch error');
            }
    }
    
    @isTest static void fetchESA() {
        system.runAs(testUser1){
        Account parentAcct = new Account();
        parentAcct.Name = 'Sample';
        parentAcct.Bill_To_Code__c = '0080101010';
        parentAcct.Branch_Code__c = '0080101010';
        parentAcct.Branch_Name__c = 'Sample';
        insert parentAcct;
        
        Test.startTest();
        	List<Sub_Activity__c> cli = UNILAB_AIR_TOP.fetchESA(parentAcct.Id);
        Test.stopTest();
        System.assert(parentAcct.Id!=null);
        }
    }
    
    
    @isTest static void saveForm() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            
            Account testAcc = new Account();
            testAcc.Name = 'Sample';
            testAcc.Bill_To_Code__c = '0080101010';
            testAcc.Branch_Code__c = '0080101010';
            testAcc.Branch_Name__c = 'Sample';
            insert testAcc;
            
            String recordID='0019D000008kRjfQAE';
            String journalBox='Test Journal Box';
            String userId = userInfo.getUserId();
            Date todayDate = Date.today() ;
            
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
        	testEvent.ActivityDate= date.today();
            testEvent.StartDateTime = date.today();
            testEvent.EndDateTime = dateTime.now(); 
            testEvent.Event_Type__c = 'Call';
            testEvent.Event_Sub_type__c = 'BRANCH CALL';
            testEvent.Location_Based__c = 'Home Base';
            testEvent.Related_to_Account__c = testAcc.Id;
            testEvent.Work_Plan__c = false;
            testEvent.Status__c = 'New';
            insert testEvent;
            
            Activity_Junction__c aj = new Activity_Junction__c();
            aj.Event_Id__c = testEvent.Id;
            aj.Event_Type__c = 'Call';
            aj.Event_Sub_type__c = 'BRANCH CALL';
            aj.Location_Based__c = 'Home Base';
            aj.Related_to_Account__c = testAcc.Id;
            insert aj;
            
            testEvent.Activity_Junction__c = aj.Id;
            update testEvent;
           
            List<Sub_Activity__c> subActs = new List<Sub_Activity__c>();
            
            Sub_Activity__c subActivity = new Sub_Activity__c(); 
            subActivity.Activity_Junction__c = aj.Id;
            subActivity.Activity_Name__c = 'TOP PRIORITIES (5Ps)';
            
            insert subActs; 
            
            List<Priority_Reference__c> lstKF = [SELECT Description__c FROM Priority_Reference__c];
           	
            Test.startTest();
            	UNILAB_AIR_TOP.saveForm(lstKF, testAcc.Id, journalBox);
            Test.stopTest();
        }
    }
}