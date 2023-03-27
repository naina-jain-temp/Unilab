import { LightningElement, api, wire, track } from 'lwc';
import myResource from "@salesforce/resourceUrl/custommodal";
import { loadStyle } from 'lightning/platformResourceLoader';
import getTopSheetDetails from '@salesforce/apex/unilabTopSheetController.getTopSheetDetails';


export default class UnilabTopsheet extends LightningElement {
    @api recordId;
    @track name;
    @track value = '3';
    @track selectedYear = '2023';
    @track selectedMonth = '3';
    @track noOfMonthEntered = 3;
    @track monthEntered = 3;
    @track yearEntered = 2023;
    @track mapData = [];

    renderedCallback()
    {
        Promise.all([ loadStyle(this, myResource + '/custommodal.css') ])
    }



    @wire(getTopSheetDetails,{recordId :'$recordId',noOfMonths : '$noOfMonthEntered',choosenMonth : '$monthEntered',choosenYear : '$yearEntered'}) 
    salesData({error, data}) {
        if (data) {
            for (let key in data) {
                this.mapData.push({value:data[key], key:key});
             }
             console.log('DATA'+this.mapData);
        } else if (error) {
            this.error = error ;
        }
    }

    get yearsValue() {
        return [
            { label: '2020', value: '2020' },
            { label: '2021', value: '2021' },
            { label: '2022', value: '2022' },
            { label: '2023', value: '2023' },
        ];
    }
    get monthsValue() {
        return [
            { label: '1', value: '1' },
            { label: '2', value: '2' },
            { label: '3', value: '3' },
            { label: '4', value: '4' },
            { label: '5', value: '5' },
            { label: '6', value: '6' },
            { label: '7', value: '7' },
            { label: '8', value: '8' },
            { label: '9', value: '9' },
            { label: '10', value: '10' },
            { label: '11', value: '11' },
            { label: '12', value: '12' },
        ];
    }

    get options() {
        return [
            { label: 'P03', value: '3' },
            { label: 'P06', value: '6' },
            { label: 'P12', value: '12' },
        ];
    }

    changeYear(event)
    {
        this.yearEntered = event.detail.value;
        this.monthEntered = this.template.querySelector('[data-id="monthPicklist"]').value;
        this.noOfMonthEntered = this.template.querySelector('[data-id="numberOfMonths"]').value;

        this.mapData = [];
        getTopSheetDetails({"recordId":this.recordId,"noOfMonths":this.noOfMonthEntered,"choosenMonth":this.monthEntered,"choosenYear":this.yearEntered});
        
    }

    changeMonth(event){
        this.monthEntered = event.detail.value;
        this.yearEntered = this.template.querySelector('[data-id="yearPicklist"]').value;
        this.noOfMonthEntered = this.template.querySelector('[data-id="numberOfMonths"]').value;

        this.mapData = [];
        getTopSheetDetails({"recordId":this.recordId,"noOfMonths":this.noOfMonthEntered,"choosenMonth":this.monthEntered,"choosenYear":this.yearEntered});
        
    }

    changeNoOfMonths(event){
        this.noOfMonthEntered = event.detail.value;
        this.monthEntered = this.template.querySelector('[data-id="monthPicklist"]').value;
        this.yearEntered = this.template.querySelector('[data-id="yearPicklist"]').value;

        this.mapData = [];
        getTopSheetDetails({"recordId":this.recordId,"noOfMonths":this.noOfMonthEntered,"choosenMonth":this.monthEntered,"choosenYear":this.yearEntered});
        
    }
}