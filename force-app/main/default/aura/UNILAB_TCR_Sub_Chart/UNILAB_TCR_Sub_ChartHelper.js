({
	callAverage : function(component, results) {
        
        var chartLabel = [];
        var callAverage = [];
        
        for (var a = 0; a < results.length; a++) {
            
            chartLabel.push(results[a]["chartLabel"]);
            callAverage.push(results[a]["callAverage"]);
            
        };
        
        var chart = new Highcharts.Chart({
            
            colors: ['navy'],
            
            chart: {
                renderTo: component.find("callAverageChart").getElement(),
                type: 'column'
            },
            
            title: {
                text: 'Average of All Calls'
            },
            
            xAxis: {
                categories: chartLabel
            },
            
            yAxis: {                
                title: {
                    text: 'LEGENDS'
                },
                stackLabels: {
                    enabled: true,
                    style: {
                        fontWeight: 'bold',
                        color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                    }
                }
            },
            
            legend: {
                align: 'right',
                x: -30,
                verticalAlign: 'top',
                y: 25,
                floating: true,
                backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
                borderColor: '#CCC',
                borderWidth: 1,
                shadow: false
            },
            
            tooltip: {
                headerFormat: '<b>{point.x}</b><br/>',
                pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
            },
            
            plotOptions: {
                column: {
                    stacking: 'normal',
                    dataLabels: {
                        enabled: true,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
                    }
                }
            },
            
            series: [{
                name: 'Average',
                data: callAverage
            }],
            
            credits: {
                enabled: true
            }
            
        })
        
        $A.util.removeClass(component.find("mySpinner"), "slds-show");
        $A.util.addClass(component.find("mySpinner"), "slds-hide");
        
    },
    
    getTCRType : function(component, recordId) {
        
        var action = component.get("c.getTCRType");
        
        action.setParams({
            'tcrID' : recordId
        });
        
        action.setCallback(this, function(response){
            
            if (response.getState() === 'SUCCESS'){
                
                component.set("v.tcrType", response.getReturnValue());
                
                this.getTCRChart(component, recordId, component.get("v.tcrType"));
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    getTCRChart : function(component, recordId, tcrType) {
        
        var results = [];
        
        var action = component.get("c.createTCRChart");
        
        action.setParams({
            'tcrID' : recordId,
            'tcrType': tcrType
        });
        
        action.setCallback(this, function(response){
            
            if (response.getState() === 'SUCCESS') {
                
                results = JSON.parse(response.getReturnValue());
                
                this.callAverage(component, results);
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    }

})