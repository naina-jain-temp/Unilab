public class MassDeleteRFCMCont {
    public String PageID{get;set;} 
    String demo; 
    public String baseUrl{get;set;}
    public MassDeleteRFCMCont(){
        
        PageID = ApexPages.currentPage().getParameters().get('id');
        //system.assert(false, PageID);
        system.debug('kskkskskksks'+ PageID);

       // baseUrl = System.URL.getOrgDomainUrl().toExternalForm();
       
    }
     
}