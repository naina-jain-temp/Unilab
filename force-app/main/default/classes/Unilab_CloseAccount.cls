public class Unilab_CloseAccount {
    
    public Account acctRecord { get; set; }
    public Id acctID { get; set; }
    
    public Unilab_CloseAccount(ApexPages.StandardController controller) {
        
        Account acctRec = (Account) controller.getRecord();
        this.acctID = acctRec.Id;        
        this.acctRecord = getAccountClosureDate(acctID);
    
    }
    
    public PageReference saveRecord() {
        
        Account updateAcctRec = [SELECT Id,
                                 		Account_Status__c,
                                 		Account_Sub_Status__c,
                                 		Account_Closure_Date__c
                                 FROM Account
                                 WHERE Id = :acctID
                                ];
        
        updateAcctRec.Account_Status__c = 'Closed';
        updateAcctRec.Account_Sub_Status__c = 'Closed';
        updateAcctRec.Account_Closure_Date__c = acctRecord.Account_Closure_Date__c;
        
        update updateAcctRec;
        
        PageReference pageRef = new PageReference('/' + updateAcctRec.Id);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public Account getAccountClosureDate(Id acctID) {
        return [SELECT Account_Closure_Date__c
                FROM Account
                WHERE Id = :acctID
               ];
    }

}