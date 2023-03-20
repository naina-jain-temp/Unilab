public with sharing class ActivityManagementLookupController {

    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
    
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        // 
        if(ObjectName.equals('User')){
            ID uRoleId = UserInfo.getUserRoleId();
            Set<ID> roleiDs = new Set<ID>();
            roleiDs.add(uRoleId);
            SET<ID> subRoleIds = getAllSubRoleIds(roleiDs);
            String sQuery =  'select id, Name from ' +ObjectName + ' where UserRole.Id IN : subRoleIds AND Name LIKE: searchKey order by createdDate DESC limit 10';
            List < sObject > lstOfRecords = Database.query(sQuery);
            for (sObject obj: lstOfRecords) {
                returnList.add(obj);
            }
            //List<sObject> userList = [SELECT Id, Name FROM User WHERE  UserRole.Id IN :subRoleIds AND Name LIKE : searchKeyWord order by createdDate DESC limit 100];
            return returnList;
            
        }else if(ObjectName.equals('ProductBrand')){
            

            
            String sQuery = 'select Brand_Name__c from Product2 where Name LIKE: searchKey order by Brand_Name__c ASC limit 10';
            
            List < Product2 > lstOfRecords = Database.query(sQuery);
            List < Product2 > lstOfSetRecords = new List<Product2>();
            Set <String> brandnames = new Set<String>();
            for(Integer i=0;i<lstOfRecords.size();i++){
                if(lstOfRecords[i].Brand_Name__c !=null && lstOfRecords[i].Brand_Name__c.length() > 0){
                     brandnames.add(lstOfRecords[i].Brand_Name__c);
                }
            }
            
            for (String brandname : brandnames){
                
                Product2 prodRec = new Product2(Id = null , Name = brandname);
                lstOfSetRecords.add(prodRec);
            }
            
            return lstOfSetRecords;
        }
        
        else if (ObjectName.equals('accountWithBranchCode')){
            ObjectName = 'Account';
            String sQuery =  'select id, Name, Branch_Code__c from ' +ObjectName + ' where (Name LIKE: searchKey) OR (Branch_Code__c LIKE :searchKey) order by createdDate DESC limit 10';
            List < sObject > lstOfRecords = Database.query(sQuery);
            
            for (sObject obj: lstOfRecords) {
                returnList.add(obj);
            }
            return returnList;
        }
        
        else{
            String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 10';
            List < sObject > lstOfRecords = Database.query(sQuery);
            
            for (sObject obj: lstOfRecords) {
                returnList.add(obj);
            }
            return returnList;
        }
    }
    
    // To get all sub roles.
    public static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
        
        Set<ID> currentRoleIds = new Set<ID>();
        
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id from UserRole where ParentRoleId 
                                IN :roleIds AND ParentRoleID != null]) {
                                    currentRoleIds.add(userRole.Id);
                                }
        
        // go fetch some more rolls!
        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        
        return currentRoleIds;
    }
    /*
// To get all Parent Roles.
public static Set<ID> getParentRoleId(Set<ID> roleIds) {

Set<ID> currentRoleIds = new Set<ID>();


// get all of the parent roles.
for(UserRole ur :[select Id, ParentRoleId from UserRole where Id IN: roleIds]) {
currentRoleIds.add(ur.ParentRoleId);
}

// go fetch some more rolls!
if(currentRoleIds.size() > 0) {
currentRoleIds.addAll(getParentRoleId(currentRoleIds));
}

return currentRoleIds;
}
*/
}