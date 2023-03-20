public class FileUploadController {
    
    @AuraEnabled  
    public static List<ContentDocument> getFiles(String recordId, String fileName){ 
        String fileType = '%'+fileName+'%';
        Set<Id> recordIds = new Set<Id>{recordId};
            List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM 
                                                 ContentDocumentLink WHERE LinkedEntityId IN :recordIds
                                                ];                         
        Set<Id> documentIds = new Set<Id>(); 
        for(ContentDocumentLink cdl:cdlList){  
            documentIds.add(cdl.ContentDocumentId);  
        }    
        return [SELECT Id, Title, FileType FROM ContentDocument WHERE Id IN :documentIds and title like : fileType];        
    } 
    
    @AuraEnabled  
    public static String deleteFile(String contentDocumentId){
        List<ContentDocument> listDocTodel = new List<ContentDocument>([SELECT Id,Title from ContentDocument WHERE Id = :contentDocumentId]);
        String docName = listDocTodel[0].Title;
        delete listDocTodel; 
        return docName;
    } 
    
    @AuraEnabled  
    public static List<ContentDocument> updateFiles(string documentId,string title,string recordId){  
        String fileType = '%'+title+'%';
        system.debug('title: ' +title);  
        ContentDocument cd = [select id,title from ContentDocument where Id=:documentId]; // Getting files from Parent record 
        cd.Title = title;  // Changing file Title with user entered title
        try{  
            update cd;  // Update ContentDocument (File)
        }  
        catch(DMLException e){  
            system.debug('Exception has occurred! ' +e.getMessage());  
        }  
        List<ContentDocument> DocumentList = new List<ContentDocument>();  
        Set<Id> documentIds = new Set<Id>();  
        List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds and title like : fileType];  
        return DocumentList;  // Return list of files on parent record
    }  
}