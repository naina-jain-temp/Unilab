import { LightningElement, track, api } from 'lwc';
import saveFile1 from '@salesforce/apex/UNILAB_Batch_Upload.saveFile';
import saveFile2 from '@salesforce/apex/UNILAB_Batch_Upload.saveFile1';
import uploadFile from '@salesforce/apex/UNILAB_Batch_Upload.handleUpload';
import { CloseActionScreenEvent } from "lightning/actions"
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
import modal from '@salesforce/resourceUrl/Unilab';
import { loadStyle} from 'lightning/platformResourceLoader';
//import getLine from '@salesforce/apex/UNILAB_Batch_Upload.getLineItems';

/*const cols = [

    { label: 'Customer Name', fieldName: 'Name' },
 
    { label: 'Customer Code', fieldName: 'Customer_Code__c', type: 'text' },
 
    { label: 'Material Code', fieldName: 'unilab_Material_Code__c' },
 
    { label: 'Material Description', fieldName: 'unilab_Material_Description__c' },
 
    { label: 'Amount', fieldName: 'unilab_Amount__c' },

    { label: 'Validation', fieldName: 'unilab_Validation__c'},

    { label: 'PPD Number', fieldName: 'PPD_Number__c' },

    { label: 'Contract Number', fieldName: 'Contract_Number__c' },

    { label: 'PPD Description', fieldName: 'PPD_Description__c' }

    
 
 ];*/


export default class LwcCSVUploader extends LightningElement {

   //@api recordId;

   /*

   CloseAction(){
       
       this.dispatchEvent(new CloseActionScreenEvent());
       

   }
   closeQuickAction() {
    const closeQA = new CustomEvent('close');
        // Dispatches the event.
        this.dispatchEvent(closeQA);
}
   @api showModal = false;
   openModal() {
       this.showModal = true;
       
   }
   @api
   closeModal() {
       this.showModal = false;
   }
   */

  /* closeModalPopup(){
    this.querySelectorHelper('.modalSection').classList.remove('slds-fade-in-open');
    this.querySelectorHelper('.backdropDiv').classList.remove('slds-backdrop_open');
    
}*/
/*querySelectorHelper(element){
    return this.template.querySelector(element);
 }*/


//    @track data;

//   // @track columns = cols;

//    @track fileName = '';

//    @track UploadFile = 'Upload CSV File';

//    @track showLoadingSpinner = false;

//    @track isTrue = false;

//    selectedRecords;

//    filesUploaded = [];

//    file;

//    fileContents;

//    fileReader;

//    content;

//    MAX_FILE_SIZE = 1024*1024;

   
   

//    connectedCallback() {

//     loadStyle(this, modal);

//    }
   /*constructor() {
    super();
    this.getallLineItems();
}
   getallLineItems() {
    getLine()
    .then(result => {
        this.data = result;
        this.error = undefined;
    })
    .catch(error => {
        this.error = error;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error while getting items', 
                message: error.message, 
                variant: 'error'
            }),
        );
        this.data = undefined;
    });
}*/



//    handleFilesChange(event) {

//        if(event.target.files.length > 0) {

//            this.filesUploaded = event.target.files;

//            this.fileName = event.target.files[0].name;

//        }

//    }

 

//    handleSave() {

//        if(this.filesUploaded.length > 0) {

//            this.uploadHelper();

//            //this.closeQuickAction();

//            //this.CloseAction();

//            //this.dispatchEvent(new CloseActionScreenEvent());

//           this.openModal();

//            //this.showModal = true;

//            //this.closeAction();

//            //this.dispatchEvent(new CloseActionScreenEvent());

           

//        }

//        else {

//            this.fileName = 'Please select a CSV file to upload!!';

//        }

//    }

 

//    uploadHelper() {

//        this.file = this.filesUploaded[0];
//        console.log('@97'+JSON.stringify(this.file));

//       if (this.file.size > this.MAX_FILE_SIZE) {

//            return ;

//        }

//        this.showLoadingSpinner = true;

 

//        this.fileReader= new FileReader();
//        console.log('@111'+JSON.stringify(this.fileReader));

 

//        this.fileReader.onloadend = (() => {

//            this.fileContents = this.fileReader.result;
//            console.log('@118'+this.fileContents);

//            this.saveToFile();
//            this.saveToFile1();

//        });

 

//        this.fileReader.readAsText(this.file);
//        console.log('@127'+JSON.stringify(this.fileReader));

//    }

 

//    saveToFile() {
//        console.log('==cdbId'+this.recordId);
       
//        saveFile1({ base64Data: JSON.stringify(this.fileContents), cdbId: this.recordId})
       

//        .then(result => {


//            this.data = result;

 

//            this.fileName = this.fileName + ' - Uploaded Successfully';

//            this.isTrue = false;

           

//            //this.CloseAction();

//            //this.dispatchEvent(new CloseActionScreenEvent());

//            //window.location.reload();

//            //this.closeQuickAction();

//            this.showLoadingSpinner1 = false;

//            this.dispatchEvent(
               

//                new ShowToastEvent({

//                    title: 'Success!!',

//                    message: this.file.name + ' - Uploaded Successfully!!!',

//                    variant: 'success',

                   

//                }),

//            );

//        })

//        .catch(error => {

//         this.showLoadingSpinner1 = false;

//            this.dispatchEvent(

//                new ShowToastEvent({

//                    title: 'Error',

//                    message: error.message,

//                    variant: 'error',

//                }),

//            );

//        });
//    }
//    saveToFile1() {
//     console.log('==cdbId'+this.recordId);
    
//     saveFile2({ base64Data1: JSON.stringify(this.fileContents), cdbId: this.recordId})
    

//     .then(result => {


//         this.data1 = result;

//         this.fileName = this.fileName;

//         this.isTrue = false;

//         this.showLoadingSpinner = false;

//         //this.CloseAction();

//         //this.dispatchEvent(new CloseActionScreenEvent());

//         //window.location.reload();

        

//         this.dispatchEvent(

//             new ShowToastEvent({

//                // title: 'Success!!',

//                 //message: this.file.name + ' - Uploaded Successfully!!!',

//                // variant: 'success',

                

//             }),

//         );

//     })

//     .catch(error => {

//         this.dispatchEvent(

//             new ShowToastEvent({

//                 title: 'Error while uploading File',

//                 message: error.message,

//                 variant: 'error',

//             }),

//         );

//     });
// }
//    downloadCSVFile() {   
//     let rowEnd = '\n';
//     let csvString = '';
//     // this set elminates the duplicates if have any duplicate keys
//     let rowData = new Set();

//     // getting keys from data
//     this.data.forEach(function (record) {
//         Object.keys(record).forEach(function (key) {
//             rowData.add(key);
//         });
//     });

//     // Array.from() method returns an Array object from any object with a length property or an iterable object.
//     rowData = Array.from(rowData);
    
//     // splitting using ','
//     csvString += rowData.join(',');
//     csvString += rowEnd;

//     // main for loop to get the data based on key value
//     for(let i=0; i < this.data.length; i++){
//         let colValue = 0;

//         // validating keys in data
//         for(let key in rowData) {
//             if(rowData.hasOwnProperty(key)) {
//                 // Key value 
//                 // Ex: Id, Name
//                 let rowKey = rowData[key];
//                 // add , after every value except the first.
//                 if(colValue > 0){
//                     csvString += ',';
//                 }
//                 // If the column is undefined, it as blank in the CSV file.
//                 let value = this.data[i][rowKey] === undefined ? '' : this.data[i][rowKey];
//                 csvString += '"'+ value +'"';
//                 colValue++;
//             }
//         }
//         csvString += rowEnd;
//     }

//     // Creating anchor element to download
//     let downloadElement = document.createElement('a');

//     // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
//     downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
//     downloadElement.target = '_self';
//     // CSV File Name
//     downloadElement.download = 'LineItemsData Success File.csv';
//     // below statement is required if you are using firefox browser
//     document.body.appendChild(downloadElement);
//     // click() Javascript function to download CSV file
//     downloadElement.click(); 
// }
// downloadCSVFile1() {   
//     let rowEnd = '\n';
//     let csvString = '';
//     // this set elminates the duplicates if have any duplicate keys
//     let rowData = new Set();

//     // getting keys from data
//     this.data1.forEach(function (record) {
//         Object.keys(record).forEach(function (key) {
//             rowData.add(key);
//         });
//     });

//     // Array.from() method returns an Array object from any object with a length property or an iterable object.
//     rowData = Array.from(rowData);
    
//     // splitting using ','
//     csvString += rowData.join(',');
//     csvString += rowEnd;

//     // main for loop to get the data based on key value
//     for(let i=0; i < this.data1.length; i++){
//         let colValue = 0;

//         // validating keys in data
//         for(let key in rowData) {
//             if(rowData.hasOwnProperty(key)) {
//                 // Key value 
//                 // Ex: Id, Name
//                 let rowKey = rowData[key];
//                 // add , after every value except the first.
//                 if(colValue > 0){
//                     csvString += ',';
//                 }
//                 // If the column is undefined, it as blank in the CSV file.
//                 let value = this.data1[i][rowKey] === undefined ? '' : this.data1[i][rowKey];
//                 csvString += '"'+ value +'"';
//                 colValue++;
//             }
//         }
//         csvString += rowEnd;
//     }

//     // Creating anchor element to download
//     let downloadElement = document.createElement('a');

//     // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
//     downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
//     downloadElement.target = '_self';
//     // CSV File Name
//     downloadElement.download = 'LineItemsData Error File.csv';
//     // below statement is required if you are using firefox browser
//     document.body.appendChild(downloadElement);
//     // click() Javascript function to download CSV file
//     downloadElement.click(); 
// }


/** New Code  */
@api recordId;
@track errorMessage;
@track keys;
@track delimiter;
@track showDownloadButtons = false;
@track responseData;
@track readCSVData;
@track showSpinner = false;
@track successCount;
@track failureCount;
@track fileName;
handleUploadFinished(event) {
    debugger;
    
    this.showSpinner = true;
    // Get the list of uploaded files
    const uploadedFiles = event.detail.files;
    this.fileName = event.target.files[0].name;
    var file = uploadedFiles[0];
    if (file){
        var reader = new FileReader();
        reader.readAsText(file, "ISO-8859-4");
        //reader.onload = this.readerLoad(evt);
        reader.onload = (evt) =>{
        this.readerLoad(evt);
       
        };

        reader.onerror = function (evt) {
            console.log("error reading file");
        }
    }

}


  readerLoad(event) {
        let csv = event.target.result;
        let result = this.handleCsvsvToJson(csv);
     
        //method to create leads from the json
        if(result != undefined){
           
            this.readCSVData = result;
            this.showSpinner = false;
            //this.handleUpload(result)
           
                    // this.readCsvApex(result);
            
        }      
    }

    handleCsvsvToJson(csv) {
        this.errorMessage = '';
        this.keys = ['CustomerName','MaterialCode','Amount' ,'PPD'];
        var keysCSV = this.keys;
        //['LegalEntityName','MarketingName','FirstName','LastName','Tier','Email','PhoneNumberOne',
        // 'PhoneNumberTwo', 'StreetNameNumber', 'City', 'Zip', 'Country'];
        var arr = []; 
        let re;
        arr =  csv.split('\n');
        var jsonObj = [];
        var delimitter = ',';
        if(arr[0].includes(';')){
            delimitter = ';';
        }
        this.delimiter = delimitter;
        var headers = arr[0].split(delimitter);
        var count = 0;
        var headingCount = 0;
        for (var i = 0; i < headers.length; i++) {
            headers[i] = headers[i].trim()
            if(headers[i] != ''){
                headingCount++;
            }
        }
        for (i = 0; i < keysCSV.length; i++) {
            if(headers.includes(keysCSV[i])){
                count++;
            }
        }

        if(count != keysCSV.length){
            this.errorMessage = 'Incorrect format. Please check the file.';
            return;
        }

        
            for(var i = 1; i < arr.length  ; i++) {
                var test = arr[i];

                //Handle if first column of the csv is blank
                if(test.indexOf(delimitter) == 0){
                    test = ' '+ test;
                }

                //Handle if last column of the csv is blank
                if(test.lastIndexOf(delimitter) == test.length-2 ){
                    test =  test + ' ';
                }

                if(delimitter == ','){

                    while(test.includes(',,')){
                        test = test.replaceAll(',,',', ,');
                    }
                }

                else if(delimitter == ';'){
                   
                    while(test.includes(';;')){
                        test = test.replaceAll(';;','; ;');
                    }
                }

                var regularExpression; 
                if(delimitter == ','){
                    re = new RegExp('(".*?"|[^",]+)(?=,|$)','g');
                } else {
                    re = new RegExp('(".*?"|[^";]+)(?=;|$)','g');
                }
                
                var data = test.match(re);
                if(data != null){
                    if(data.length > headingCount){
                        this.errorMessage = 'Incorrect format. Please check the file.';
                        return; 
                    }
                
                    var obj = {};
                    for(var j = 0; j < data.length; j++) {
                        var dataCSV = data[j].trim();
                    
                        if(delimitter == ',' && dataCSV.includes(',')){
                            dataCSV = dataCSV;
                        
                        } else if(delimitter == ';' && dataCSV.includes(';')){
                            dataCSV = dataCSV.substring(1,dataCSV.length - 2);
                        }
                        obj[headers[j].trim()] = dataCSV;
                    }
                    jsonObj.push(obj);
                }
            }
        
        
        var json = JSON.stringify(jsonObj);
        return json;
    }

    handleUpload(){
        console.log(this.recordId);
        this.showSpinner = true
        uploadFile({csvStr: this.readCSVData,recordId : this.recordId})
        .then(result => {
            this.showDownloadButtons = true;
            this.responseData = result; 
            this.showSpinner = false;
            this.successCount =  this.getSuccessDataCount();
            this.failureCount = this.getFailedDataCount();
        })
        .catch(error => {
            this.error = error;
           
        })
    }

    getFailedDataCount(){
        var failedData = this.responseData.filter(function (el) {
            return el.Status != 'Success' ;
            });
        return failedData.length;
    }

    getSuccessDataCount(){
        var successData = this.responseData.filter(function (el) {
            return el.Status == 'Success' ;
            });
        return successData.length;
    }


    getFailedData(){
        
        var failedData = this.responseData.filter(function (el) {
                        return el.Status != 'Success' ;
                        });
        this.downloadCSVFile(failedData,'Error');
          
    }

    getSuccessData(){
        var successData = this.responseData.filter(function (el) {
            return el.Status == 'Success' ;
            });
        this.downloadCSVFile(successData,'Success');
    }


    // this method validates the data and creates the csv file to download
    downloadCSVFile(downloadData,fileName) {   
        let rowEnd = '\n';
        let csvString = '';
        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
       rowData =  ['CustomerName','MaterialCode','Amount','PPD','Status'];

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);
        
        // splitting using ','
        csvString += rowData.join(',');
        csvString += rowEnd;

        // main for loop to get the data based on key value
        for(let i=0; i < downloadData.length; i++){
            let colValue = 0;

            // validating keys in data
            for(let key in rowData) {
                if(rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    let rowKey = rowData[key];
                    // add , after every value except the first.
                    if(colValue > 0){
                        csvString += ',';
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = downloadData[i][rowKey] === undefined ? '' : downloadData[i][rowKey];
                    csvString += '"'+ value +'"';
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csvString);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = fileName+'.csv';
        // below statement is required if you are using firefox browser
        document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click(); 
    }




    /*
    readCsvApex(result){
        readCSV({csvStr: result})
        .then(result => {

            //this.data = result;
         
           console.log(result);
           
        })
        .catch(error => {
            this.error = error;
           
        })

    }
    */


 

}