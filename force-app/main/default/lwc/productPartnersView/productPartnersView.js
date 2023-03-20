import { api, LightningElement, track, wire } from 'lwc';
import fetchProducts from '@salesforce/apex/productPartnersView.fetchProducts';
import { NavigationMixin } from 'lightning/navigation';

const columns = [
    { label: 'Product Name', fieldName: 'NameURL', type: 'url',
        typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}
    },
    { label: 'Product Code', fieldName: 'ProductCode',
        cellAttributes: { 
            iconName: { fieldName: 'icon' }, iconPosition: 'left' , 
        }
    },
    { label: 'Brand', fieldName: 'Brand', 
        cellAttributes: { 
            iconName: { fieldName: 'icon' }, iconPosition: 'left' , 
        }
    },
    { label: 'Product Family', fieldName: 'Family',
        cellAttributes: { 
            iconName: { fieldName: 'icon' }, iconPosition: 'left' , 
        }
    },
    { label: 'Generic Name', fieldName: 'Generic',
        cellAttributes: { 
            iconName: { fieldName: 'icon' }, iconPosition: 'left' , 
        }
    },
    { label: 'Barcode', fieldName: 'Barcode',
        cellAttributes: { 
            iconName: { fieldName: 'icon' }, iconPosition: 'left' , 
        }
    }
];

export default class ProductPartnersView extends NavigationMixin(LightningElement) {
    @api title;
    @api showDetails;
    @api showsync;
    //@api recordId;
    @api usedInCommunity; 
    @api communityName; 
    @api reportId;
    @api documentId;

    @api baseUrlValue

    @track dataList;
    @track columnsList = columns;
    isLoading = false;

    connectedCallback() {
        this.handleSync();
    }

    getUsedInCommunityValue(){
        return this.usedInCommunity == false ? 0 : 1
    }

    getBaseUrl(){
        /*
        let baseUrl = 'https://'+location.host+'/';
        return baseUrl;
        */
       let baseUrl = '';
       if(this.usedInCommunity){
        baseUrl='https://'+location.host+'/'+this.communityName+'/';
       }
       else{
        baseUrl = 'https://'+location.host+'/';
       }
       return baseUrl;
    }

    handleSync(){
        this.isLoading = true;
        
        this.baseUrlValue = this.getBaseUrl();
        fetchProducts()
        .then(result => {
            let parsedData = JSON.parse(result);
            let stringifiedData = JSON.stringify(parsedData);
            let finalData = JSON.parse(stringifiedData);
            let baseUrl = this.getBaseUrl();
            let forCommunity = this.getUsedInCommunityValue();

            finalData.forEach(dataRec => {
                dataRec.SKU = dataRec.Name + ' ; ' + dataRec.ProductCode + ' ; ' + dataRec.Generic_Name__c;
                dataRec.Name = dataRec.Name;
                //dataRec.NameURL = baseUrl + 'lightning/r/Product2/' + dataRec.Id + '/view';
                if (forCommunity == 0){
                    dataRec.NameURL = baseUrl + 'lightning/r/Product2/' + dataRec.Id + '/view';
                    
                }
                else{
                    dataRec.NameURL = baseUrl + 's/product/' + dataRec.Name.toLowerCase().trim().replaceAll('[^a-z0-9\\s]+', '').replaceAll('[\\s]+', '-').replaceAll(' ','-') + '/' + dataRec.Id;
                }
                dataRec.ProductCode = dataRec.ProductCode;
                dataRec.Brand = dataRec.Brand_Name__c;
                dataRec.Family = dataRec.Family;
                dataRec.Generic = dataRec.Generic_Name__c;
                dataRec.Barcode = dataRec.StockKeepingUnit;
            });
            
            this.dataList = finalData;
            this.databackupList = finalData; //to save the backup of data you are retriving using handleSync function
        })
        .catch(error => {
            console.error('**** error **** \n ',error)
        })
        .finally(()=>{
            this.isLoading = false;
        });
    }

    handleSearch(event){
        if (event.keyCode==13){
            let name  = event.target.name;
            let value = event.target.value;

            if( name === 'Name' ){
                this.dataList = this.databackupList.filter( dataRec => {
                    return dataRec.SKU.toLowerCase().includes(value.toLowerCase());
                });
            } 
        }
    }

    downloadProductList(event){
        //Sandbox: 00O7F00000ADtANUA1
        //Prod: 00O7F00000BB0RaUAL
        var urlString=window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/_ui"));
        var siteBaseURL = baseURL;
        var redirectUrl = siteBaseURL + '/servlet/PrintableViewDownloadServlet?isdtp=p1&reportId='+this.reportId;
        window.open(redirectUrl,'_blank').focus(); 
        /*
        let baseUrl = this.getBaseUrl();
        let redirectUrl = baseUrl + 'servlet/PrintableViewDownloadServlet?isdtp=p1&reportId='+this.reportId;
        window.open(redirectUrl,'_blank').focus(); 
        */
        
    }

    downloadResources(event){
        //Sandbox: 0691e000000KjxXAAS

        var urlString=window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/_ui"));
        var siteBaseURL = baseURL;
        var redirectUrl = siteBaseURL + '/sfc/servlet.shepherd/document/download/'+this.documentId;
        window.open(redirectUrl,'_blank').focus(); 

        /*
        let baseUrl = this.getBaseUrl();
        let redirectUrl = baseUrl + 'sfc/servlet.shepherd/document/download/'+this.documentId;
        window.open(redirectUrl,'_blank').focus(); 
        */
    }
}