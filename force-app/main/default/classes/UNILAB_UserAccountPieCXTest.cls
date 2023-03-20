/*-------------------------------------------------------------------------------------------
Author       :   Kimiko Roberto
Created Date :   07.20.2017
Definition   :   Test class for UNILAB_UserAccountPieCX
History      :   07.20.2017 - Kiko Roberto:  Created
-------------------------------------------------------------------------------------------*/
@isTest
public class UNILAB_UserAccountPieCXTest{
    
    public static testMethod void testGetPieData(){
        Account testAccount = new Account(Name = 'Test', Area__c = 'Test Area',Bill_To_Code__c = '1234567890');
        insert testAccount;
        
        AccountTeamMember testAcctTeamMem = new AccountTeamMember(UserId = Userinfo.getUserId(), AccountId = testAccount.Id);
        insert testAcctTeamMem;
        
        UNILAB_UserAccountPieCX cont = new UNILAB_UserAccountPieCX();
        cont.getPieData();
    }
}