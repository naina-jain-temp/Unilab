import { LightningElement, api, wire, track } from 'lwc';
import getProductDetails from '@salesforce/apex/hadleBaseSelectionSheet.getProductDetails';
import getCustomerTeamValues from '@salesforce/apex/hadleBaseSelectionSheet.getCustomerTeamValues';
import getTotalSalesValues from '@salesforce/apex/hadleBaseSelectionSheet.getTotalSalesValues';
import myResource from "@salesforce/resourceUrl/custommodal";
import { loadStyle } from 'lightning/platformResourceLoader';

export default class UploadBaseSelection extends LightningElement {
    
    @api recordId;
    @track gluName;
    @track clusterName;
    @track brandName;
    @track sku;
    @track productFamily;
    @track customerTeamValues = [];
    @track value = 'twelveMonths';
    @track selectedYear = '2023';
    @track selectedMonth = '12';
    @track noOfMonths;
    @track yearSelected;
    @track monthSelected;
    @track pastMonths = [];
    @track currentMonth;
    @track currentYear;
    @track currentDate;
    @track monthEntered = 3;
    @track yearEntered = 2023;
    @track noOfMonthEntered = 3;

    connectedCallback()
    {
        this.handleMonthsList(12);
    }

    renderedCallback()
    {
        Promise.all([ loadStyle(this, myResource + '/custommodal.css') ])
    }

    @wire(getTotalSalesValues,{recordId :'$recordId',noOfMonths : '$noOfMonthEntered',choosenMonth : '$monthEntered',choosenYear : '$yearEntered'}) 
    salesData({error, data}) {
        if (data) {
            console.log('MAINTHING - '+data);       
           
        } else if (error) {
            this.error = error ;
        }
    }

    @wire( getProductDetails, { recordId: '$recordId'}) 
    productDetails({error, data}) {
        if (data) {
            console.log('PARSED - '+JSON.stringify(data));       
            this.gluName = data.glu;
            this.clusterName = data.cluster;
            this.brandName = data.brand;
            this.sku = data.sku;
            this.productFamily = data.family;
        } else if (error) {
            this.error = error ;
        }
    }

    @wire(getCustomerTeamValues) 
    customerTeamValues({error,data})
    {
        if(data)
        {
            this.customerTeamValues = data;
        }else if(error){
            this.error = error ;
        }
    };
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
            { label: 'P03', value: 'threeMonths' },
            { label: 'P06', value: 'sixMonths' },
            { label: 'P12', value: 'twelveMonths' },
        ];
    }
    // getLastMonths(yearSelected, monthSelected, noOfMonths) {
    //     let end_date = new Date(yearSelected, monthSelected - 1, 1); // create a Date object for the given year and month
    //     let start_date = new Date(end_date); // create a copy of the end_date

    //     start_date.setMonth(start_date.getMonth() - noOfMonths); // subtract 3 months to get the start date

    //     let last_three_months = [];

    //     while (end_date > start_date) {
    //         last_three_months.push([end_date.getFullYear(), end_date.getMonth() + 1]); // append the year and month to the list
    //         end_date.setMonth(end_date.getMonth() - 1); // subtract 1 month
    //     }

    //     this.lastThreeMonths = last_three_months;
    // }


    handleMonthsList(noOfMonths)
    {
        this.pastMonths = [];
        this.currentDate = new Date();
        this.currentMonth = this.currentDate.getMonth();
        this.currentYear = this.currentDate.getFullYear();
        for (let i = 0; i < noOfMonths; i++) 
        {
            let monthDetail = this.currentMonth - i;
            let year = this.currentYear;
            if (monthDetail <= 0) {
                monthDetail += 12;
                year -= 1;
            }
            let  newDate = new Date(year,monthDetail);
            let mon = newDate.toLocaleString('default', { month: 'short' });
            this.pastMonths.push(`${year}-${mon}`);
        }
        console.log("Past months:", this.pastMonths);
    }
    handleChangeYear(event)
    {
        this.yearSelected = event.detail.value;


    }
    handleChangeMonth(event)
    {
        this.monthSelected = event.detail.value

    }

    handleChange(event)
    {
        this.value = event.detail.value;
        // getLastMonths(yearSelected, monthSelected, noOfMonths );
        if(this.value!='twelveMonths' && this.value!='sixMonths')
        {
            this.handleMonthsList(3);
        }else if(this.value == 'sixMonths')
        {
            this.handleMonthsList(6);
        }else
        {
            this.handleMonthsList(12);
        }
    }

}