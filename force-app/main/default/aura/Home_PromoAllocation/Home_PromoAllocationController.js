({
	doInit: function (component, event, helper) {
        var hostname = window.location.hostname;
        var crtPrmURL = 'https://'+ hostname + '/lightning/n/Create_Promo';
        component.set("v.createPromoURL", crtPrmURL);
        console.log("crtPrmURL --> "+crtPrmURL);
        component.set("v.UNILAB_Base_URL", hostname);
    }
})