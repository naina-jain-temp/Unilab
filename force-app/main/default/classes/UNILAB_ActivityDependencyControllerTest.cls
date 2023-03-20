@isTest
public class UNILAB_ActivityDependencyControllerTest {
    private static testMethod void InsertRecord() {
        
        List<Activity_Dependency__c> actDepList = new List<Activity_Dependency__c>();
        List<UNILAB_ActivityDependencyController.SurveyWrapper> sWrapper = new List<UNILAB_ActivityDependencyController.SurveyWrapper>();
        Integer rowToRemove = 0;
        String selectedRole;
        
        UNILAB_ActivityDependencyController con = new UNILAB_ActivityDependencyController(new ApexPages.StandardController(new Activity_Dependency__c()));
     
        con.getUserRoleList();
        con.getEventSubTypeList();
        con.getActivityNameList();
        con.getChannelList();
        con.getEventTypeList();
        
        UserRole ur;
        System.runAs(new User(Id=UserInfo.getUserId())) {
            ur = new UserRole();
            ur.Name = 'POS-KA Team Lead (VisMin)';
            insert ur;
        }
        
        selectedRole = ur.Id;
        
        //System.assertequals(ur.Id + ' ', 'ur');
        
        
        List<Survey_Summary_Form__c> ssfList = new List<Survey_Summary_Form__c>();
        Survey_Summary_Form__c parentSSF = new Survey_Summary_Form__c();
        parentSSF.Name = 'Visibility SSF';
        parentSSF.Start_Date__c = date.Today().addDays(-3);
        parentSSF.End_Date__c = date.Today().addDays(3);
        parentSSF.Event_Sub_type__c = 'Branch Call';
        parentSSF.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        parentSSF.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Questionnaire').getRecordTypeId();
        parentSSF.Team__c = 'GMA';
        
        Survey_Summary_Form__c childSSF = new Survey_Summary_Form__c();
        childSSF.Name = 'Visibility SSF';
        childSSF.Parent_SSF__c = parentSSF.Id;
        parentSSF.Start_Date__c = date.Today().addDays(-3);
        childSSF.End_Date__c = date.Today().addDays(3);
        childSSF.Event_Sub_type__c = 'Branch Call';
        childSSF.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        childSSF.RecordTypeId = Schema.SObjectType.Survey_Summary_Form__c.getRecordTypeInfosByName().get('Questionnaire').getRecordTypeId();
        childSSF.Team__c = 'GMA';
        
        ssfList.add(parentSSF);
        ssfList.add(childSSF);
        
        insert ssfList;
         
        Test.startTest();
        
        Activity_Dependency__c ad = new Activity_Dependency__c();
        ad.Name = '1';
        ad.Activity_Name__c = 'AVAILABILITY CHECK / INVTY REPORT (MUST 20)';
        ad.Event_Sub_Type__c = 'BRANCH CALL';
        ad.External_ID__c = '00E7F000001C8w7UACAVAILABILITY CHECK / INVTY REPORT (MUST 20)BRANCH CALL';
        ad.Number__c = 1;
        //ad.Role_ID__c = ur.Id;
        ad.Role_ID__c = selectedRole;
        ad.Role_Name__c = ur.Name;
        ad.Channel__c = 'NKA';
        ad.Event_Type__c = 'CALL';  
        actDepList.add(ad);
           
        insert actDepList;   
        
        PageReference pg = Page.ActivityDependencyPage;
        Test.setCurrentPage(pg);
        ApexPages.StandardController pgCon = new ApexPages.StandardController(ad); 
        UNILAB_ActivityDependencyController uadc = new UNILAB_ActivityDependencyController(pgCon);
        
        uadc.addNewRowToSfList(); 
        uadc.rowToRemove = 1;
        uadc.removeRowFromSfList();
        uadc.cancel(); 
        
        UNILAB_ActivityDependencyController.SurveyWrapper svWrapper = new UNILAB_ActivityDependencyController.SurveyWrapper();
         
        for(Integer i=0; i<200; i++) {
            Summary_Form_Item__c sfItem = new Summary_Form_Item__c();
            sfItem.Survey_Summary_Form__c = childSSF.Id;
            sfItem.Activity_Dependency__c = ad.Id;    
            svWrapper.sfi = sfItem;
            svWrapper.index = 0;
            System.debug('svWrapper>>' + svWrapper); 
            sWrapper.add(svWrapper);
        }
         
        PageReference pg1 = Page.ActivityDependencyPage;
        Test.setCurrentPage(pg1); 
        ApexPages.StandardController pgCon1 = new ApexPages.StandardController(ad);
        UNILAB_ActivityDependencyController uadc2 = new UNILAB_ActivityDependencyController(pgCon1);
        
        for(UNILAB_ActivityDependencyController.SurveyWrapper swrap : sWrapper) {
            System.debug('uadc2.sfList>>' + uadc2.sfList);
            uadc2.sfList.remove(0);
            uadc2.sfList.add(swrap);
        }
        
        uadc2.save(); 
        
        //Activity_Dependency__c actDeptAfterInsert = [SELECT Id, Name FROM Activity_Dependency__c WHERE ID =: ad.Id];
        
        Test.stopTest();
    }   
    
}