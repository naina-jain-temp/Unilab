@isTest
public class MEPL_AssignmentRuleTriggerer_Test {
    public static User testUser1;
    public static UserRole adminRole;
    static{
        //call your test data here using a test data factory
        adminRole = [SELECT Id, Name FROM UserRole WHERE Name = 'System Administrator'];
        testUser1 = TestDataFactory.createUserAdmin();
        testUser1.UserRoleId = adminRole.Id;
        insert testUser1;  
        
    }
    
	static testMethod void CSAR() {
        system.runAs(testUser1){
            Case newCase = new Case();
            newCase.Type = 'Distribution Systems';
            newCase.Sub_Type__c='PHOENIX (RFCM)';
            newCase.Subject = 'Test';
            newCase.Description = 'Test';
            newCase.Priority = 'High';
            newCase.Origin = 'N/A';
            newCase.Status = 'New';
            
            insert newCase;
            
            List<Case> caseList = [select Id from Case limit 10];
            //List<Id> idList;
            //idList.Add(newCase.Id);
            
            Set<Id> caseIds = new Set<Id>();
            for(Case objCase : caseList){
            	caseIds.Add(objCase.Id);
            }
            List<Id> idList = new List<Id>(caseIds);
            
            Test.startTest();
                MEPL_AssignmentRuleTriggerer.CaseStandardAssignmentRule(idList);
            Test.stopTest();
            //system.assert(cl != null);
        }
    }
}