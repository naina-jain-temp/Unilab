@isTest
public class UNILAB_GTA_Test {

    @isTest static void fetch() {
        system.runAs(new User(Id = UserInfo.getUserId())){
            
            Account testAcc = new Account (Name = 'TestAccount',
                                        Account_Code__c = 'AcctTest1',
                                        Bill_To_Code__c = '0231312321',
                                        Branch_Code__c= 'AcctTest1',
                                        Account_Address_1_Bldg_No_Street__c = 'Rufino Tower, 6790, Ayala Avenue',
                                        Account_Address_2_District_Brgy__c = 'Makati',
                                        Territory_Town_City_Municipality__c = 'Makati',
                                        Province__c = 'NCR - National Capital Region',
                                        District__c = 'Makati',
                                        Region__c = 'Metro Manila',
                                        Area__c = 'Metro Manila',
                                        Zip_Code__c = '1229'
                                       );
        	insert testAcc;
                
            Event testEvent = new Event();
            testEvent.Subject = 'Test';
        	testEvent.ActivityDate= date.today();
            testEvent.StartDateTime = date.today();
            testEvent.EndDateTime = date.today();
            testEvent.Event_Type__c = 'Call';
            testEvent.Event_Sub_type__c = 'BRANCH CALL';
            testEvent.Location_Based__c = 'Home Base';
            testEvent.Related_to_Account__c = testAcc.Id;
            testEvent.Work_Plan__c = false;
            testEvent.Status__c = 'New';
            insert testEvent;
        
        	Test.startTest();
            	string relatedAcct = UNILAB_GTA.fetch(testEvent.Id);
            Test.stopTest();
        }
    }
    
    @isTest static void fetchAndSave() {
    	system.runAs(new User(Id = UserInfo.getUserId())){
        	
            	Account testAcc = new Account (Name = 'TestAccount',
                                        Account_Code__c = 'AcctTest1',
                                        Bill_To_Code__c = '0231312321',
                                        Branch_Code__c= 'AcctTest1',
                                        Account_Address_1_Bldg_No_Street__c = 'Rufino Tower, 6790, Ayala Avenue',
                                        Account_Address_2_District_Brgy__c = 'Makati',
                                        Territory_Town_City_Municipality__c = 'Makati',
                                        Province__c = 'NCR - National Capital Region',
                                        District__c = 'Makati',
                                        Region__c = 'Metro Manila',
                                        Area__c = 'Metro Manila',
                                        Zip_Code__c = '1229'
                                       );
        		insert testAcc;

                    
                Event testEvent = new Event();
                testEvent.Subject = 'Test';
                testEvent.ActivityDate= date.today();
                testEvent.StartDateTime = date.today();
                testEvent.EndDateTime = date.today();
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
                subActivity.Activity_Name__c = 'TRADE AUDIT (5Ps)';
                
                insert subActs; 
                Test.startTest();
                    UNILAB_GTA.fetchAndSave(testEvent.Id);
                Test.stopTest();
        }
    }
}