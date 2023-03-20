@isTest
public class Test_unilab_RfcmLineItems {
    @isTest
    public static void testRfcmLineItemsAmount(){
        RFCM_line_item__c rfcmlineitem = new RFCM_line_item__c();
        List<RFCM_line_item__c> RFCMList = new List<RFCM_line_item__c>();
        rfcmlineitem.unilab_Amount__c= 1000;
        RFCMList.add(rfcmlineitem);
        unilab_RfcmLineItems.RfcmLineItemsAmount(rfcmlineitem.Id);
   
    }

}