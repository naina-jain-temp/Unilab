@isTest
public class UNILAB_MCR_SubmForm_Test {
   @isTest
    public static void submitForm() {
        
      	//Map<String, String> sessionAttributes;
         System.runAs(new User(Id = UserInfo.getUserId())){
            Account testAcc = TestDataFactory.createSingleAccount('TestAccount');
            insert testAcc;   
            
        	//sessionAttributes = Auth.SessionManagement.getCurrentSession();
        
            Double lat = 14.5741292;
            Double lon = 121.0542468;
            String networkTest = 'test';
            String remarks = 'test';
            
            MCR__c mcr = new MCR__c();
            mcr.Account__c = testAcc.Id;
            insert mcr;
           
             Test.startTest();
             	
            	String submitForm = UNILAB_MCR_SubmForm.submitForm(lat,lon,networkTest,remarks,mcr.Id);
           
                 Test.stopTest();
            System.assert(submitForm!=null);
         }
    }
}