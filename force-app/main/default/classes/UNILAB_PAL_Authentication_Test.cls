/*-------------------------------------------------------------------------------------------
Authors      :   Mark Palacios and Mervin Dequito
Created Date :   06.13.2019
Definition   :   Test class for UNILAB_PAL Authentication
-------------------------------------------------------------------------------------------*/
@isTest
private	 class UNILAB_PAL_Authentication_Test {
    
     @isTest static void testCalloutSuccess() {   
            Test.startTest();
         		Test.setMock(HttpCalloutMock.class, new UNILAB_PAL_Authentication_Mock(true));	
                UNILAB_PAL_Authentication.getToken();
            Test.stopTest();
         	//System.assertEquals('a725d2af2ebecbe02e0606fcff12d2ce', asd);
    }
   
     @isTest static void testCalloutFailed() {   
            Test.startTest();
         		Test.setMock(HttpCalloutMock.class, new UNILAB_PAL_Authentication_Mock(false));	
            	UNILAB_PAL_Authentication.getToken();
            Test.stopTest();
         
    }    
    
}