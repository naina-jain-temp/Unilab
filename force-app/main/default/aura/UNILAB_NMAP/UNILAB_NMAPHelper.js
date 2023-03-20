({
	 loadMap : function(component,event,helper,contacts) {	        
         var mapsArray = [];	        
         for(let index=0; index < contacts.length; index++){	            	            
             var Mobj = {	                
                 location: {	                    
                     Street: contacts[index].Account_Address_1_Bldg_No_Street__c ,	                    
                     City: contacts[index].Territory_Town_City_Municipality__c,	                                        
                     State: contacts[index].Province__c	                                    
                 },	                
                 icon: 'standard:account',	                
                 title: contacts[index].Name,	                
                 description: contacts[index].Name	            
             }	            
             mapsArray.push(Mobj);	

         }	        
         component.set('v.mapMarkers', mapsArray);	        
         component.set('v.centerObj', 
                       {	            
                           location: {	                
                               State: 'Cebu City'  
                           }	        
                       });	        
         component.set('v.zoomLevel', 15);	        
         component.set('v.markersTitle', 'Near by Accounts');	        
         component.set('v.showFooter', true);	    
     },
    
 
})