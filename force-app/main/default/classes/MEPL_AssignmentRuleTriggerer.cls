public class MEPL_AssignmentRuleTriggerer {
	@InvocableMethod
    public static void CaseStandardAssignmentRule( List<Id> caseIds) {
         ID jobID = System.enqueueJob(new AssignOwnerQueue(caseIds));
       
    }
}