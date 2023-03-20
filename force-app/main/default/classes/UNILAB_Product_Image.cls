public class UNILAB_Product_Image {
	@AuraEnabled 
    public static List<ContentDocumentLink> fetchContent(string recordID){
        
        //return [Select id,Title From contentVersion WHERE FirstPublishLocationId=:recordID LIMIT 1000];
        return[SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
                ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
                FROM ContentDocumentLink
              	WHERE LinkedEntityId=:recordID];
        
        /*return [
            SELECT Id, Title
            FROM contentDocument
            WHERE Id = '0691e000000KFgvAAG'
            
        ];*/
    }
}