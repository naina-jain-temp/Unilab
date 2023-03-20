public class UNILAB_Product_Pricing {
	@AuraEnabled 
    public static decimal fetchPrice(string recordID, string pricebookName){
        String priceBookId = [SELECT Id FROM Pricebook2 WHERE Name = :pricebookName Limit 1].Id;
        Decimal productPrice = [SELECT UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :priceBookId AND Product2Id = :recordId Limit 1].UnitPrice;
        return productPrice;
    }
}