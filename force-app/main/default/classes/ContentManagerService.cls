public with sharing class ContentManagerService {
    
    @AuraEnabled
    public static String getContentDetails(String recordId) {
        List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId, LinkedEntityId 
                                                            FROM   ContentDocumentLink 
                                                            WHERE  LinkedEntityId =: recordId];
        Set<Id> contentDocumentId = new Set<Id>();
            
        for(ContentDocumentLink cdl : contentDocumentList){
            contentDocumentId.add(cdl.ContentDocumentId);
        }
            /* Remove VersionData due to 6MB limitation */
        List<ContentVersion> contentVersionList = [SELECT Id, FileType, Title, FileExtension,
                                                    ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                                    CreatedDate, ContentDocumentId, ContentDocument.FileType,
                                                    ContentDocument.Description
                                                    FROM   ContentVersion 
                                                    WHERE  ContentDocumentId IN : contentDocumentId ORDER BY Title ASC];
        return JSON.serialize(contentVersionList);
    }
    /*
    @AuraEnabled
    public static void deleteContentDocument(String recordId) {
        Database.delete(recordId);
    }
    */
    /*
    public static string ContentType(String fileType) {

        switch on fileType.toLowerCase(){
            when 'docx' {
                return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            }
            when 'csv' {
                return 'application/vnd.ms-excel';
            }
            when 'wav' {
                return 'audio/wav';
            }
            when 'wmv' {
                return 'video/x-ms-wmv';
            }
            when 'mp3' {
                return 'audio/mpeg';
            }
            when 'mp4' {
                return 'video/mp4';
            }
            when 'png' {
                return 'image/png';
                
            }
            when 'pdf' {
                return 'application/pdf';
                
            }
            when else {
                return 'image/jpeg';
            }
        }

    }*/
}