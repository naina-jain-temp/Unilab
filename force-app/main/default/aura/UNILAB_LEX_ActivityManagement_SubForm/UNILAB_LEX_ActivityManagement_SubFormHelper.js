({
    getSubEventActivity : function(cmp,helper,subEventType){
        // get the map values   
        var Map = cmp.get("v.activityMatrixList");
        var listofActivity = Map[subEventType];
        console.log(Map);
        // create a empty array var for store dependent picklist values for controller field)  
        var activities = [];
		/*
        if (listofActivity != undefined && listofActivity.length > 0) {
            activities.push({
                "label": "--- None ---",
                "value": "--- None ---"
            });
            
        }
        */
        if(listofActivity){
            for (var i = 0; i < listofActivity.length; i++) {
                activities.push({
                    label: listofActivity[i],
                    value: listofActivity[i]
                });
            }
        }

        // set the dependentFields variable values to State(dependent picklist field) on ui:inputselect    
        cmp.set("v.subActivityOptions", activities);
    }
})