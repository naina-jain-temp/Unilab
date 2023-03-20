@isTest
public class TestRFCMApprovalProcessController {
    
    @isTest
    public static void testFCMApproval1(){
        
        List<RFCM_User_Matrix__c> listUMs = new list<RFCM_User_Matrix__c>();
        RFCM_User_Matrix__c objUM = new RFCM_User_Matrix__c();
        objUM.Customer_Sub__c = 'Customer Team 5 - TMG ULSSI';
        objUM.Team__c = 'SNCD';
        objUM.Role__c = 'Team Leader';
        objUM.User__c = UserInfo.getUserId();
        listUMs.add(objUM);
        
        RFCM_User_Matrix__c objUM2 = new RFCM_User_Matrix__c();
        objUM2.Customer_Sub__c = 'Customer Team 5 - TMG ULSSI';
        objUM2.Team__c = 'SNCD';
        objUM2.Role__c = 'Channel Head';
        objUM2.User__c = UserInfo.getUserId();
        listUMs.add(objUM2);
        
        insert listUMs;
        
        RFCM_FormNumber__c rfcmForm = new RFCM_FormNumber__c();
        List<RFCM_FormNumber__c> formList = new List<RFCM_FormNumber__c>();
        rfcmForm.Name = 'test';
        rfcmForm.Number__c = 100000;
        rfcmForm.Date__c =Date.newInstance(2022, 12, 9);
        insert rfcmForm;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Main/Warehouse').getRecordTypeId();
        acc.Name = 'metacube';
        acc.Branch_Code__c = '1';
        acc.Bill_To_Code__c = '1230987654';
        insert acc;
        
        RFCM__c rfcm = new RFCM__c();
        List<RFCM__c> rfcmList = new List<RFCM__c>();
        rfcm.RecordTypeId = Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Regular RFCM').getRecordTypeId();
        rfcm.Customer_Team__c = 'Trade Marketing Group';
        rfcm.Customer_Sub_Team__c = 'Customer Team 5 - TMG ULSSI';
        rfcm.unilab_Classification__c = 'MOS Internal';
        rfcm.unilab_Program__c = 'Trade Promotions - TMG Initiated';
        rfcm.unilab_Accrued__c = 'YES';
        rfcm.unilab_Claim_Reference_Number__c = '123';
        rfcm.unilab_Claim_Description__c = 'test';
        rfcm.unilab_Start_Date__c = Date.newInstance(2022, 06, 11);
        rfcm.unilab_End_Date__c =Date.newInstance(2022, 06, 20);
        rfcm.Customer_Name__c = acc.Id;
        rfcm.unilab_Customer_Code__c = '1';
        rfcm.Project_Owner__c  = 'Customer Team 1 HO'; 
        rfcm.Validator__c = 'Customer Team 1 HO';
        rfcm.RFCM_Approver__c = userinfo.getuserid();
        rfcm.Next_Approver__c = 'SNCD;Division Head';
        rfcmList.add(rfcm);
        Insert rfcmList;
        
        Material__c mat = new Material__c();
             mat.Material_Id__c= 'dfdsfds';
             mat.Material_Name__c = 'fdfdfs';
             mat.Company_Name__c = 'dfdsfsd';
             insert mat;
        RFCM_line_item__c rl = new RFCM_line_item__c ();
        rl.RFCM__c = rfcmList[0].Id;
        rl.Material__c = mat.Id;
        rl.unilab_Amount__c   = 123123213;
        insert rl;
        Task objTask = new Task();
        objTask.whatId = rfcmList[0].Id;
        objTask.status = 'Open';
        objTask.subject = 'assigned for approval';
        Insert objTask;
        rfcm = rfcmList[0];
        
        
        
        RFCM__c rfcm1 = new RFCM__c();
        List<RFCM__c> rfcmList1 = new List<RFCM__c>();
        rfcm1.RecordTypeId = Schema.SObjectType.RFCM__c.getRecordTypeInfosByName().get('Regular RFCM').getRecordTypeId();
        rfcm1.Customer_Team__c = 'Trade Marketing Group';
        rfcm1.Customer_Sub_Team__c = 'Customer Team 5 - TMG ULSSI';
        rfcm1.unilab_Classification__c = 'MOS Internal';
        rfcm1.unilab_Program__c = 'Trade Promotions - TMG Initiated';
        rfcm1.unilab_Accrued__c = 'YES';
        rfcm1.unilab_Claim_Reference_Number__c = '123dds';
        rfcm1.unilab_Claim_Description__c = 'test';
        rfcm1.unilab_Start_Date__c = Date.newInstance(2022, 06, 11);
        rfcm1.unilab_End_Date__c =Date.newInstance(2022, 06, 20);
        rfcm1.Customer_Name__c = acc.Id;
        rfcm1.unilab_Customer_Code__c = '1';
        rfcm1.Project_Owner__c  = 'Customer Team 1 HO'; 
        rfcm1.Validator__c = 'Customer Team 1 HO';
        rfcm1.RFCM_Approver__c = userinfo.getuserid();
        rfcm1.Next_Approver__c = 'SNCD;Division Head';
        rfcm1.Rejected_Count__c = 1;
        rfcm1.Approval_Status__c = 'Rejected';
        rfcmList1.add(rfcm1);
        Insert rfcmList1;
        
        
        
        RFCMApprovalProcessController.getValidators(rfcm.Id);
        RFCMApprovalProcessController.getProjectOwners(rfcm.id);
        RFCMApprovalProcessController.getReassignList(rfcm.id);
        RFCMApprovalProcessController.getEncoder(rfcm.id);
        RFCMApprovalProcessController.initAction(rfcm.id);
        RFCMApprovalProcessController.submitForApproval(rfcm.id);
        RFCMApprovalProcessController.submitForApproval(rfcm1.id);
        RFCMApprovalProcessController.submitForNextApprovalOrReject(rfcm.id,'Approve','Test');
        RFCMApprovalProcessController.submitForNextApprovalOrReject(null,'Approve','Test');
        RFCMApprovalProcessController.getMultipleApprovers('Customer Team 4 - Vyasya','Encoder');
        RFCMApprovalProcessController.submitForNextApprovalOrReject(rfcm.id,'Reject','Test');
        RFCMApprovalProcessController.submitForNextApprovalOrReject(null,'Reject','Test');
        RFCMApprovalProcessController.getUsers();
        RFCMApprovalProcessController.RFCMApprovalProcessResponse resp = new RFCMApprovalProcessController.RFCMApprovalProcessResponse();
        resp.rfcm = rfcm;
        resp.validator = userinfo.getUserId();
        RFCMApprovalProcessController.submitToValidator(resp);
        resp.reassignTo = userinfo.getUserId();
        RFCMApprovalProcessController.reassign(resp);
        resp.projectOwner = userinfo.getUserId();
        RFCMApprovalProcessController.submitToProjectOwner(resp);
        resp.rfcm.Encoder__c = userinfo.getUserId();
        RFCMApprovalProcessController.submitToEncoder(resp);
        RFCMApprovalProcessService.nextApprover(rfcm);
        rfcm.Approval_Type__c = 'Approval Flow and Lead Time 1';
        rfcm.Current_Approver__c = 'SNCD;Team Leader';
        RFCMApprovalProcessService.nextApprover(rfcm);
        rfcm.Current_Approver__c = 'SNCD;Channel Head';
        RFCMApprovalProcessService.nextApprover(rfcm);
        rfcm.Current_Approver__c = 'SNCD;Division Head';
        RFCMApprovalProcessService.nextApprover(rfcm);
        rfcm.Current_Approver__c = 'SNCD;Division Head';
        RFCMApprovalProcessService.nextApprover(rfcm);
        rfcm.Approval_Type__c = 'Approval Flow and Lead Time 3';
        rfcm.Current_Approver__c = 'Finance;Finance Analyst';
        rfcm.unilab_Claimed_Amount__c =250000;
        RFCMApprovalProcessService.nextApprover(rfcm);
        rfcm.Current_Approver__c = 'Finance;Team Leader';
        RFCMApprovalProcessService.nextApprover(rfcm);
        rfcm.Current_Approver__c = 'Finance;FLT';
        RFCMApprovalProcessService.nextApprover(rfcm);
        rfcm.Current_Approver__c = 'Finance;CFO';
        RFCMApprovalProcessService.nextApprover(rfcm);
        rfcm.Current_Approver__c = 'Top Management;President';
        RFCMApprovalProcessService.nextApprover(rfcm);
        rfcm.Current_Approver__c = 'Top Management;CEO';
        RFCMApprovalProcessService.nextApprover(rfcm);
    }
    
}