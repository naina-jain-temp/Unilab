public class RunCAR_TriggerHandler {
	public void beforeInsertCase() {
        //Fetching the assignment rules on case
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        
        Case newCase = new Case(Status = 'New') ;
        //Setting the DMLOption on Case instance
        newCase.setOptions(dmlOpts);
        
    }
}