@isTest
public class TestRFCMSharing {
    @isTest
    public static void testRFCMSharing(){
        RFCM_line_item__c rfcmlineitem = new RFCM_line_item__c();
        List<RFCM_line_item__c> RFCMList = new List<RFCM_line_item__c>();
        rfcmlineitem.unilab_Amount__c= 1000;
        rfcmlineitem.unilab_Company__c = 'Appistoki'; 
        RFCMList.add(rfcmlineitem);
        RFCMSharing.apexShareRead(rfcmlineitem.Id,rfcmlineitem.Id);
    }

}