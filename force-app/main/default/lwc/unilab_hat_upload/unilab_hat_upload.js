import { LightningElement, track, api } from 'lwc';
import saveFile1 from '@salesforce/apex/UNILAB_Hat_Upload.saveFile';
import saveFile2 from '@salesforce/apex/UNILAB_Hat_Upload.saveFile1';
//import uploadFile from '@salesforce/apex/UNILAB_Hat_Upload.handleUpload';
import { CloseActionScreenEvent } from "lightning/actions"
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
import modal from '@salesforce/resourceUrl/Unilab';
import { loadStyle} from 'lightning/platformResourceLoader';
//import getLine from '@salesforce/apex/UNILAB_Hat_Upload.getLineItems';

export default class Unilab_hat_upload extends LightningElement {
    //@api recordId;

   /** New Code  */
    @api recordId;
    @track errorMessage;
    @track keys;
    @track delimiter;
    @track responseData;
    @track readCSVData;
    @track showSpinner = false;
    @track successCount;
    @track failureCount;
    @track fileName;

    //Object Variable Declaration
    uploadObj = {};

    //Boolean Variable Declaration
    showSpinner = false;
    showDownloadButtons = false;
    showFileUpload = false;
    showDownloadUpload = false;

    //Getter Method for Upload Options
    get uploadOptions() {
        return [
            { label: 'Import', value: 'Import' },
            { label: 'Export', value: 'Export' },
        ];
    }

    //Getter Method for Object Options
    get objectOptions() {
        return [{
            label: 'Customer Master Data',
            value: 'Customer Master Data'
        }, {
            label: 'Product Allocation',
            value: 'Product Allocation'
        }, {
            label: 'Storage Location',
            value: 'Storage Location'
        }, {
            label: 'Cut-Off Compliance',
            value: 'Cut-Off Compliance'
        }];
    }

    //Handle On Change method
    handleOnChange(event) {
        let name = event.target.name;

        switch(name) {
            case 'type':
                this.uploadObj.type = event.target.checked;
                this.showFileUpload = name === 'Import' ? true : false;
                this.showDownloadUpload = false;
                break;
            case 'objectName':
                this.uploadObj.objectName = event.target.value;
                this.showFileUpload = false;
                this.showDownloadUpload = name === 'Export' ? true : false;;
                break;
        }
    }

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
}