public class RFCMSharing {
    
    @future
    public static void apexShareRead(Id recordId, Id userOrGroupId){
        RFCM__share rfcmShare  = new RFCM__share();
        rfcmShare.ParentId = recordId;
        rfcmShare.UserOrGroupId = userOrGroupId;
        rfcmShare.AccessLevel = 'edit';
        rfcmShare.RowCause = Schema.RFCM__share.RowCause.Manual;
        Database.SaveResult sr = Database.insert(rfcmShare,false);
    }
}