({
	getLocation : function(component) {
		var latitude;
        var longitude;
        
        navigator.geolocation.getCurrentPosition(
          function (position) {
              console.log(position.coords.latitude + ', ' + position.coords.longitude);
              latitude = position.coords.latitude;
              longitude = position.coords.longitude;
              component.set("v.lat",latitude);
              component.set("v.long",longitude);
              //alert(latitude + ' | ' + longitude);
          }.bind(this),
          function (e) {
            console.log(e.message);
            this.showToast(component,'System Message','Please enable your device location!','info');
          }.bind(this),
          {
            enableHighAccuracy: true,
          }
        );
	},
    
    getNetworkTest : function(component) {
        var userImageLink = "https://assets.unilab.com.ph/assets/assets/images/logo-unilab-meta.png";
            var time_start, end_time;
            
            // The size in bytes
            var downloadSize = 5616998;
            var downloadImgSrc = new Image();
  
            downloadImgSrc.onload = function () {
                end_time = new Date().getTime();
                var timeDuration = (end_time - time_start) / 1000;
                var loadedBits = downloadSize * 8;
                
                /* Converts a number into string
                   using toFixed(2) rounding to 2 */
                var bps = (loadedBits / timeDuration).toFixed(2);
                var speedInKbps = (bps / 1024).toFixed(2);
                var speedInMbps = (speedInKbps / 1024).toFixed(2);
                
                component.set("v.networkTest",("Your internet connection speed is: \n" 
                      + bps + " bps\n" + speedInKbps 
                     + " kbps\n" + speedInMbps + " Mbps\n"));
                //alert("Your internet connection speed is: \n" 
                //      + bps + " bps\n" + speedInKbps 
                //     + " kbps\n" + speedInMbps + " Mbps\n");
            };
            time_start = new Date().getTime();
            downloadImgSrc.src = userImageLink;
    },
    /*
    getIPAdd : function(component) {
        const Http = new XMLHttpRequest();
        const url='https://api.ipify.org/';
        Http.open("GET", url);
        Http.send();
        Http.onreadystatechange=(e)=>{
            alert(Http.responseText);
            //console.log(Http.responseText); // This prints Ip address
            //component.set("v.ipAddress", Http.responseText);
        }
    },*/
    
    submit : function(component) {
        var lat = component.get("v.lat");
        var lon = component.get("v.long");
        var networkTest = component.get("v.networkTest");
        var remarks = component.get("v.remarksVal");
        var recordId = component.get("v.recordId");
        var action = component.get('c.submitForm');

        action.setParams({
            lat,
            lon,
            networkTest,
            remarks,
            recordId
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	//component.set("v.acctGroupPriorityData", []);
                $A.get('e.force:refreshView').fire();
                alert('Successfully Saved');   
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})