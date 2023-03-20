public with sharing class AssignOwnerQueue implements Queueable{

   List<Id> casesIds;

   public AssignOwnerQueue(List<Id> casesIds){
      this.casesIds= casesIds;
   }

   public void execute(QueueableContext context) {
        AssignmentRule AR = new AssignmentRule();
        AR = [SELECT id from AssignmentRule WHERE sObjectType = 'Case' AND Active = true limit 1];
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.assignmentRuleId = AR.Id;
        List<Case> toUpdate = new List<Case>();
        for( Id singleId : CasesIds ) {
            toUpdate.add( new Case( id = singleId, Assign_using_active_assignment_rule__c = false ) );
            toUpdate[toUpdate.size()-1].setOptions(dmo);
        }
        Database.update(toUpdate, dmo);

   }
}