({
	getLocation : function(component, event) {
        var latitude;
        var longitude;
        navigator.geolocation.getCurrentPosition(function(e) {
            console.log(e.coords.latitude + ', ' + e.coords.longitude);
            latitude = e.coords.latitude;
            longitude = e.coords.longitude;
            
            component.set("v.lat",latitude);
            component.set("v.long",longitude);
            
            if(latitude != 0){
                component.set('v.showSpinner', true);
                component.find("quickMapsForm").submit();
                alert('Record has been updated!');
                component.set('v.showSpinner', false); 
            }
            
            //alert('Lat:'+ latitude);
            //alert('Long:'+ longitude);   
            
        }, function() {
            console.log('There was an error.');
        },{maximumAge:600000});
	}
})