({
    onClickCT : function(component, event, helper) {
        helper.reconstructArray(component);
        var ctData = component.get("v.ctData");
        if(ctData.length>0) {
            component.set("v.disabled", false);
        } else {
            component.set("v.disabled", true);
        }
        console.log(component.get("v.ctData"));
    }
})