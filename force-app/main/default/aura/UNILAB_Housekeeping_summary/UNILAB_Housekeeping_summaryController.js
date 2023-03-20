({
	showSummary : function(component, event, helper) {
        
        var summary = component.get("v.Summary");
        console.log(JSON.stringify(summary));
        var receiving = summary[0];
        var bulk = summary[1];
        var loose = summary[2];
        var checking = summary[3];
        var packing = summary[4];
        var staging = summary[5];
        var bo = summary[6];
        var dispatch = summary[7];
        var cold = summary[8];
        var promo = summary[9];
        var ventilation = summary[10];
        var material = summary[11];
        var office = summary[12];
        var washin = summary[13];
        var others = summary[15];
        var temperature = summary[14];
        console.log(receiving);
        component.set("v.receiving", receiving);
        component.set("v.bulk", bulk);
        component.set("v.loose", loose);
        component.set("v.checking", checking);
        component.set("v.packing", packing);
        component.set("v.staging", staging);
        component.set("v.bo", bo);
        component.set("v.dispatch", dispatch);
        component.set("v.cold", cold);
        component.set("v.promo", promo);
        component.set("v.ventilation", ventilation);
        component.set("v.material", material);
        component.set("v.office", office);
        component.set("v.washin", washin);
        component.set("v.others", others);
        
        component.set("v.temperature", temperature);
        

	}
})