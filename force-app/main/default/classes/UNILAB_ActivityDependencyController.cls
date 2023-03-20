public class UNILAB_ActivityDependencyController {

    private ApexPages.StandardController actDepController;
    public Activity_Dependency__c actDep {get;set;}
    public List<SurveyWrapper> sfList {get;set;} 
    public Integer rowToRemove {get;set;}
    public String selectedRole {get;set;}
    public String selectedSubType {get;set;}
    public String selectedActName {get;set;}
    public String selectedChannel {get;set;}
    public String selectedeventType {get;set;}
    
    public UNILAB_ActivityDependencyController(ApexPages.StandardController controller) {
        actDepController = controller;
        this.actDep = (Activity_Dependency__c)controller.getRecord();
        sfList = new List<SurveyWrapper>();
        addNewRowToSfList();
         
    }
    public void addNewRowToSfList() {
        List<SurveyWrapper> temp_sflist = new List<SurveyWrapper>();
        SurveyWrapper newRecord = new SurveyWrapper();
      
        Summary_Form_Item__c newSfiRecord = new Summary_Form_Item__c();      
        newRecord.sfi = newSfiRecord;
        newRecord.index = temp_sflist.size();
        temp_sflist.add(newRecord);
        for(SurveyWrapper sw : temp_sflist) {
            sfList.add(sw);
        }
    }
    
    public void removeRowFromSfList() {
        List<SurveyWrapper> rem_sflist = new List<SurveyWrapper>();
        for(SurveyWrapper sw : sfList) {
            rem_sflist.add(sw);
        }
        rem_sflist.remove(rowToRemove);
        sfList.clear();
        for(SurveyWrapper sw2 : rem_sflist) {
            sfList.add(sw2);
        }
    }
    
    public List<SelectOption> getUserRoleList() {
        List<UserRole> userRoleList = [SELECT Id, Name FROM UserRole];
        List<SelectOption> uRoleOptionList = new List<SelectOption>();
        uRoleOptionList.add(new SelectOption(' ',' '));
        
        for(UserRole ur : userRoleList) {
            uRoleOptionList.add(new SelectOption(ur.Id, ur.Name));    
        }
        
        return uRoleOptionList;
    }
    
    public List<SelectOption> getEventSubTypeList() {
        List<SelectOption> subTypeOptionList = new List<SelectOption>();
        Schema.DescribeFieldResult subTypeResults = Event.Event_Sub_type__c.getDescribe();
         
        List<Schema.PicklistEntry> ple1 = subTypeResults.getPicklistValues();
        
        for(Schema.PicklistEntry f : ple1) {
            subTypeOptionList.add(new SelectOption(f.getLabel(), f.getValue()));    
        }  
        
        return subTypeOptionList;
    }
    
    public List<SelectOption> getActivityNameList() {
        List<SelectOption> actNameOptionList = new List<SelectOption>();
        Schema.DescribeFieldResult actNameResults = Sub_Activity__c.Activity_Name__c.getDescribe();
         
        List<Schema.PicklistEntry> ple2 = actNameResults.getPicklistValues();
        
        for(Schema.PicklistEntry f : ple2) {
            actNameOptionList.add(new SelectOption(f.getLabel(), f.getValue()));    
        }  
        
        return actNameOptionList;
    }
    
    public List<SelectOption> getChannelList() {
        List<SelectOption> channelOptionList = new List<SelectOption>();
        Schema.DescribeFieldResult channelResults = User.Channel__c.getDescribe();
         
        List<Schema.PicklistEntry> ple3 = channelResults.getPicklistValues();
        
        for(Schema.PicklistEntry f : ple3) {
            channelOptionList.add(new SelectOption(f.getLabel(), f.getValue()));    
        }  
        
        return channelOptionList;
    }
    
    public List<SelectOption> getEventTypeList() {
        List<SelectOption> eventTypeOptionList = new List<SelectOption>();
        Schema.DescribeFieldResult eventTypeResults = Event.Event_Type__c.getDescribe();
         
        List<Schema.PicklistEntry> ple4 = eventTypeResults.getPicklistValues();
        
        for(Schema.PicklistEntry f : ple4) {
            eventTypeOptionList.add(new SelectOption(f.getLabel(), f.getValue()));    
        }  
        
        return eventTypeOptionList;
    }
    
    public PageReference save() {
        
        List<SurveyWrapper> swList = new List<SurveyWrapper>();
        List<Summary_Form_Item__c> newsfiList = new List<Summary_Form_Item__c>();

         
        for(SurveyWrapper sw : sfList) {
            swList.add(sw);
        }
        
        List<UserRole> ur = [SELECT Id, Name FROM UserRole WHERE Id =: selectedRole];
               
        Activity_Dependency__c newActDept = new Activity_Dependency__c();
         
        newActDept.Name = actDep.Name;
        newActDept.Activity_Name__c = selectedActName;
        newActDept.Event_Sub_Type__c = selectedSubType;
        newActDept.External_ID__c = actDep.External_ID__c;
        newActDept.Number__c = actDep.Number__c;
        newActDept.Role_ID__c = selectedRole;
        newActDept.Channel__c = selectedChannel; 
        newActDept.Event_Type__c = selectedeventType;
        
        if(!ur.isEmpty()) {
            newActDept.Role_Name__c = ur[0].Name;
        }
          
        insert newActDept;
        
        if(swList !=null && !swList.isEmpty()) {
            
            for(SurveyWrapper eachRecord : swList) {
                 
                Summary_Form_Item__c sfiTemp = new Summary_Form_Item__c();
                sfiTemp.Survey_Summary_Form__c = eachRecord.sfi.Survey_Summary_Form__c; 
                sfiTemp.Activity_Dependency__c = newActDept.Id; 
                newsfiList.add(sfiTemp);
            }
        }
        
      
        if(!newsfiList.isEmpty()) {
                insert newsfiList;
        }    
        
        PageReference pageref = new PageReference('/' + newActDept.Id);
        pageref.setRedirect(true);
        return pageref;
    }
    
    public PageReference cancel() {
 
        PageReference pageref = new PageReference('/home/home.jsp');
        pageref.setRedirect(true);
        return pageref;
    }
    
    public class SurveyWrapper {
        
        public Integer index {get;set;}
        public Summary_Form_Item__c sfi {get;set;}
        
    }
        
}