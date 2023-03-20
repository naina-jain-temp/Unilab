trigger RFCM_Trigger on RFCM__c (before insert,before Update,after insert,after update) {
    
    if(RFCMTriggerHandler.RFCMTriggerBypassFlag == true){
        return; 
    }
        if(Trigger.isBefore){
        if(Trigger.isInsert){
            Set<string> RefNum= new Set<string>();
    	for(RFCM__c acc : Trigger.new)
         {
           RefNum.add(acc.unilab_Claim_Reference_Number__c);
         }
     List<RFCM__c> duplicateRefNum = [Select unilab_Claim_Reference_Number__c From RFCM__c where unilab_Claim_Reference_Number__c = :RefNum];
     Set<string > duplicateRefNumIds= new Set<string >();
     for(RFCM__c dup: duplicateRefNum )
      {
         duplicateRefNumIds.add(dup.unilab_Claim_Reference_Number__c);
      }

       for(RFCM__c a : Trigger.new)
       {
            if(a.unilab_Claim_Reference_Number__c!=null)
            {
               if(duplicateRefNumIds.contains(a.unilab_Claim_Reference_Number__c))
               {
                   //a.addError('Trigger failed due to'+DmlException.getDMLMessage(0));
                 a.addError(System.Label.Claim_Reference_Number_Error);
               }
            
            }
       }
            for(RFCM__c objRFCM : Trigger.New){
                objRFCM.Status__c = 'New';
            }
            Unilab_RfcmNumberFormatClass.rfcm(trigger.new);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            Set<Id> setRFCMIds = new Set<Id>();
            List<RFCM__c> setCanceledRFCMs = new List<RFCM__c>();
            List<RFCM__c> resetRFCMs = new List<RFCM__c>();
            for(RFCM__c objRFCM : [Select Id,Status__c,Approval_Configuration_Identifier__c,unilab_Claimed_Amount__c from RFCM__c where Id in: Trigger.New]){
                if(objRFCM.Status__c == 'Credit Approver' && Trigger.oldMap.get(objRFCM.Id).Status__c != objRFCM.Status__c){
                    setRFCMIds.add(objRFCM.Id);
                }
                if(Trigger.oldMap.get(objRFCM.Id).Status__c != objRFCM.Status__c && objRFCM.Status__c == 'Canceled'){
                    setCanceledRFCMs.add(objRFCM);
                }
                if((Trigger.oldMap.get(objRFCM.Id).Approval_Configuration_Identifier__c  != objRFCM.Approval_Configuration_Identifier__c ) || 
                   (objRFCM.unilab_Claimed_Amount__c != Trigger.oldMap.get(objRFCM.Id).unilab_Claimed_Amount__c)){
                       resetRFCMs.add(objRFCM);
                   }
            }
            if(!setCanceledRFCMs.isEmpty()){
                RFCMTriggerHandler.rejectPendingApprovals(setCanceledRFCMs);
            }
            if(!setRFCMIds.isEmpty()){
                //RFCMGenerateCSVController.createCSV(setRFCMIds);
                RFCMTriggerHandler.sendEMailtoCredit(setRFCMIds);
            }
            if(!resetRFCMs.isEmpty()){
                RFCMTriggerHandler.setApprovalConfigAttributes(resetRFCMs);
            }                
        }
    }
}