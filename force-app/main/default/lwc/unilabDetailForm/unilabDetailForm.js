import { LightningElement,track,api } from 'lwc';
import getPickListValues from '@salesforce/apex/RFCM_Form_Creation.getPickListValues';
import saveRecords from '@salesforce/apex/RFCM_Form_Creation.saveRecords';
import getFieldDependency from '@salesforce/apex/RecordTypesOfRFCM.getFieldDependency';

export default class UnilabDetailForm extends LightningElement {
    @api recordtypeid;
    @track recordForm;
    @track sts;
    @track acc;
    @track prg;
    @track cls;
    @track record1 = false;
    @track record2 = false;
    @track record3 = false;
    @track spinnercontroller = true;
    @track projcontrol=false;
    @track safecontrol=false;
    @track customerCode=false;
    @track messagecontrol=false;
    @track msg='';
    @track classificationList=[];
    @track programList=[];
    @track subCustomerTeamList=[];
    @track customerTeamList=[];
    @track mappingMeta;
    @track selectedCustomerTeam = '';
    programDisabled = true;
    classificationDisabled = true;
    subCustomerTeamDisabled = true;
    connectedCallback(){
        this.spinnercontroller = true;
        console.log('==>@@'+JSON.stringify(this.recordtypeid));
        if( this.recordtypeid.Id == 'Multiple Customer' ){
            this.record1 = true;
            this.record2 = false;
            this.record3 = true;
        }else{
            this.record1 = true;
            this.record2 = true;
            this.record3 = true;
        }
        if( this.recordtypeid.Id == 'Multiple PPDs'){
            this.record1 = false;
            this.record2 = false;
        }
        if( this.recordtypeid.Id == 'Senior & Disc' ){
            this.record3 = false;
            this.record1 = false;
        }
        this.recordForm ={
            Id:null,
            Status__c :'',
            unilab_Accrued__c :'',
            unilab_Program__c :'',
            unilab_Classification__c :'',
            Name : '',
            unilab_CM_No__c : '',
            unilab_Claim_Reference_Number__c : '',
            unilab_Claim_Description__c: '',
            unilab_Company__c:'',
            unilab_Claimed_Amount__c:'',
            unilab_Participating_SKUs__c:'',
            unilab_Start_Date__c:'',
            unilab_End_Date__c:'',
            UNILAB_PPD_Description__c:'',
            UNILAB_Contract_Description__c:'',
            unilab_Customer_Code__c:null,
            Condition_Type__c:'',
            Customer_Sub_Team__c:'',
            Customer_Name__c:'',
            Project_Proposal_Document_No__c:'',
            Contract_No__c:'',
            RecordTypeId:this.recordtypeid.Name
        };
        console.log(JSON.stringify(this.recordtypeid));
        
        this.fetchPicklistValue( 'RFCM__c' , 'Status__c' );
        this.fetchPicklistValue( 'RFCM__c' , 'unilab_Accrued__c' );
       // this.fetchPicklistValue( 'RFCM__c' , 'unilab_Program__c' );
       // this.fetchPicklistValue( 'RFCM__c' , 'unilab_Classification__c' );
       console.log(this.recordtypeid.Id);
       getFieldDependency({recordTypeName : this.recordtypeid.Id}) 
        .then((result) => {
            var data = JSON.parse(result);
            this.mappingMeta = JSON.parse(result);

           /* for(var i=0; i<data.length;i++){
                
                if(!classificationSet.has(data[i].Classification__c)){
                    classificationSet.add(data[i].Classification__c);
                }
            }
            
            classificationSet.forEach( key =>{
                 this.classificationList.push({label: key , value: key});
               }
            )   */
            
            let customerTeamSet = new Set();
           

            for(var i=0; i<data.length;i++){
                
                if(!customerTeamSet.has(data[i].Customer_Team__c)){
                    customerTeamSet.add(data[i].Customer_Team__c);
                }
            }
            
            customerTeamSet.forEach( key =>{
                 this.customerTeamList.push({label: key , value: key});
               }
            )

        })
        .catch((error) => {
             console.log('error:', error);
        });
       this.spinnercontroller = false;    
    }

    get classificationOption(){
        return JSON.parse(JSON.stringify(this.classificationList));

    }

    fetchPicklistValue(object,type){
        getPickListValues({ objApiName : object , fieldName : type})
        .then((result) => {
                console.log(JSON.stringify(type));
                if( type=='Status__c'){ this.sts=result; }
                if( type=='unilab_Accrued__c'){ this.acc=result; }
                if( type=='unilab_Program__c'){ this.prg=result; }
                if( type=='unilab_Classification__c'){ this.cls=result; }
                //console.log(JSON.stringify(res));  
            }
        )
        .catch((error) => {
            console.log('error:', error);
        });
    }

    accountdetails(event){
        if(event.detail.Id != ''){
            this.customerCode = true;
        }else{
            this.customerCode = false;
        }
        this.recordForm.Customer_Name__c = event.detail.Id;
        this.recordForm.unilab_Customer_Code__c = event.detail.customcode;
    }

    projectdetails(event){
        if(event.detail.Id != ''){
            this.safecontrol = true;
        }else{
            this.safecontrol = false;
        }
        this.recordForm.Project_Proposal_Document_No__c = event.detail.Id;
        this.recordForm.UNILAB_PPD_Description__c = event.detail.description;
        this.recordForm.unilab_Company__c = event.detail.customcode;
    }

    contractdetails(event){
        if(event.detail.Id != ''){
            this.projcontrol = true;
        }else{
            this.projcontrol = false;
        }
        this.recordForm.Contract_No__c = event.detail.Id;
        this.recordForm.UNILAB_Contract_Description__c = event.detail.description;
        this.recordForm.unilab_Company__c = event.detail.customcode;
        console.log('after changes'+JSON.stringify(this.recordForm.UNILAB_Contract_Description__c));
    }

    updPick1(event){ this.recordForm.Status__c = event.detail.value; }

    updPick2(event){ this.recordForm.unilab_Accrued__c = event.detail.value; }

    updPick3(event){
        //this.customerTeamList=[];
        this.classificationList = [];
        this.subCustomerTeamList=[];
       // this.recordForm.unilab_Program__c = event.detail.value
       this.recordForm.Customer_Team__c = event.detail.value
        this.selectedCustomerTeam = event.detail.value;
        var newArray = this.mappingMeta.filter(function (el) {
            return el.Customer_Team__c == event.detail.value;
        });
        

        let classificationTeamSet = new Set();
        let subCustomerTeamSet = new Set();
        for(var i=0; i<newArray.length;i++){
                
            if(!classificationTeamSet.has(newArray[i].Classification__c)){
                classificationTeamSet.add(newArray[i].Classification__c);
            }

            if(!subCustomerTeamSet.has(newArray[i].Customer_Sub_Team__c)){
                subCustomerTeamSet.add(newArray[i].Customer_Sub_Team__c);
            }


        }
        

        classificationTeamSet.forEach( key =>{
                this.classificationList.push({label : key, value : key});
        })

        subCustomerTeamSet.forEach( key =>{
            this.subCustomerTeamList.push({label : key, value : key});
        })

        this.classificationDisabled = false;
        this.subCustomerTeamDisabled = false;
     }

     updPick5(event){ 
        this.recordForm.unilab_Program__c = event.detail.value
     }
     updPick6(event){
         this.recordForm.Customer_Sub_Team__c = event.detail.value
     }

    updPick4(event){ 
        this.programList = [];
        this.recordForm.unilab_Classification__c = event.detail.value;
        let selectedCustomerTeam = this.selectedCustomerTeam;
        let selectedSubCustomerTeam = this.recordForm.Customer_Sub_Team__c;
        let recordTypeName = this.recordtypeid.Id;
        console.log(JSON.parse(JSON.stringify(this.mappingMeta)));
        var newArray = this.mappingMeta.filter(function (el) {
            console.log(el.Classification__c + '@@@' + event.detail.value + '@@@' + selectedCustomerTeam);
            return el.Classification__c == event.detail.value && el.Customer_Sub_Team__c == selectedSubCustomerTeam &&  el.Record_Type__c  == recordTypeName ;
        });
        

        let programSet = new Set();
        for(var i=0; i<newArray.length;i++){
                
            if(!programSet.has(newArray[i].Programs__c)){
                programSet.add(newArray[i].Programs__c);
            }
        }
        

        programSet.forEach( key =>{
                this.programList.push({label : key, value : key});
        })


        this.programDisabled = false;

     } 

     get programOptions(){
        return JSON.parse(JSON.stringify(this.programList));
     }

     get customerTeamOptions(){
        return JSON.parse(JSON.stringify(this.customerTeamList));
     }

     get subCustomerTeamOptions(){
        return JSON.parse(JSON.stringify(this.subCustomerTeamList));
     }

    // written by leela

    nameField(event){ this.recordForm.Name = event.detail.value;}

    CMNOField(event){ this.recordForm.unilab_CM_No__c = event.detail.value;}

    clRefNumField(event){ this.recordForm.unilab_Claim_Reference_Number__c = event.detail.value;}

    clDescField(event){ this.recordForm.unilab_Claim_Description__c = event.detail.value;}

    companyField(event){ this.recordForm.unilab_Company__c = event.detail.value;}

    clAmountField(event){ this.recordForm.unilab_Claimed_Amount__c = event.detail.value;}

    custCodeField(event){this.recordForm.unilab_Customer_Code__c = event.detail.value;}

    proStartDateField(event){this.recordForm.unilab_Start_Date__c = event.detail.value;}

    proStopDateField(event){this.recordForm.unilab_End_Date__c = event.detail.value;}

    ppdDescField(event){this.recordForm.UNILAB_PPD_Description__c = event.detail.value;}

    conDescField(event){this.recordForm.UNILAB_Contract_Description__c = event.detail.value;}

    pSkusField(event){this.recordForm.unilab_Participating_SKUs__c = event.detail.value;}

    @api
    saveData(event){
        this.messagecontrol = false;

        //this.recordForm.unilab_Participating_SKUs__c == ''
        if( this.recordForm.unilab_Claim_Reference_Number__c == '' || this.recordForm.unilab_Claim_Description__c == '' ||
        this.recordForm.unilab_Start_Date__c == '' || this.recordForm.unilab_End_Date__c == ''
        )
        { this.messagecontrol = true; this.msg = 'Please fill all required fields'; return; }

        /*if( this.recordtypeid.Id == 'Multiple Customer' && ( this.recordForm.Project_Proposal_Document_No__c == '' &&
            this.recordForm.Contract_No__c == '' ) ){ 
                this.messagecontrol = true; this.msg = 'Please fill all required fields'; return;
            }*/
        
        if( ( this.recordtypeid.Id == 'Senior & Disc' ||  this.recordtypeid.Id == 'Regular RFCM' ) && (
            this.recordForm.unilab_Customer_Code__c == null || this.recordForm.Customer_Name__c == ''
        )){
            this.messagecontrol = true; this.msg = 'Please fill all required fields'; return;
        }

        /*if( this.recordtypeid.Id != 'Senior & Disc' && ( this.recordForm.unilab_Company__c == '' )){
            this.messagecontrol = true; this.msg = 'Please fill all required fields'; return;
        }*/

        console.log('recordForm' +JSON.stringify(this.recordForm) );
       
        /*
        if( this.recordForm.unilab_Classification__c != '' && this.recordForm.unilab_Program__c == '' ){
            this.messagecontrol = true; this.msg = 'Please fill Program fields'; return;
        }*/

        if ((Date.parse(this.recordForm.unilab_End_Date__c) <= Date.parse(this.recordForm.unilab_Start_Date__c))) {
            this.messagecontrol = true; this.msg = 'Please select Program Duration End Date must be greater than to Program Duration Start Date'; return;
        }


        var conditionMap = this.mappingMeta.filter((el) => {
            return el.Classification__c == this.recordForm.unilab_Classification__c
                   && el.Programs__c == this.recordForm.unilab_Program__c
                   && el.Customer_Team__c == this.recordForm.Customer_Team__c
        });
        
        if(conditionMap.length > 0){
            this.recordForm.Condition_Type__c = conditionMap[0].Condition_Type__c
        }

        saveRecords({ objRecord : this.recordForm })
        .then((result) => {
                if( result.check == true ){
                    console.log('@194'+JSON.stringify(result));
                    this.recordForm.Id = result.msg;
                    const selectedEvent = new CustomEvent("recorddetails", {
                        detail:  result.msg
                    });
                    // Dispatches the event.
                    this.dispatchEvent(selectedEvent); 

                }else{
                    this.messagecontrol = true; 
                    this.msg = result.msg;
                }
                
            }
        )
        .catch((error) => {
            console.log('error:', error);
        });
    }
}