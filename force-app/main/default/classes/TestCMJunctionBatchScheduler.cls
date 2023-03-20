@isTest
public class TestCMJunctionBatchScheduler {

    testmethod static void TestCMJunctionBatchScheduler1(){
        Test.StartTest();
        CMJunctionBatchScheduler sh1 = new CMJunctionBatchScheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest(); 
    }	
}