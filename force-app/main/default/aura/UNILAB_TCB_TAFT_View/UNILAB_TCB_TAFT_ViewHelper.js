({
	refresh : function(component, event) {
        var event = component.getEvent("lightningEvent");
        event.setParam("message", "Record has been deleted!" );
        event.fire();
    },
})