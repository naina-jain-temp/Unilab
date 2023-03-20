public class WelcomeScreen {
    
    @AuraEnabled
    public static User getUserRecord() {
        
        return [SELECT Name,
                FullPhotoUrl
                FROM User
                WHERE (Id = :UserInfo.getUserId())
               ];
        
    }
    
}