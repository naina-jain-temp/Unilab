public class UNILAB_Utility {
    
    public static Map<String, String> getPickilistFields(String objectName, String picklistFieldName) {
        
        Map<String, String> picklistValues = new Map<String, String>();
        SObjectType objectType = getSObjectType(objectName);
        List<Schema.PicklistEntry> pick_list_values = objectType.getDescribe()
            .fields.getMap()
            .get(pickListFieldName)
            .getDescribe().getPickListValues();
        for (Schema.PicklistEntry aPickListValue : pick_list_values) {                   
            picklistValues.put(aPickListValue.getValue(), aPickListValue.getLabel()); 
        }
        return picklistValues;
        
    }
    
    public static List<String> getPicklistFieldValues(String objectName, String pickListFieldName){
        List<String> picklistValues = new List<String>();
        SObjectType objectType = getSObjectType(objectName);
        List<Schema.PicklistEntry> pick_list_values = objectType.getDescribe()
            .fields.getMap()
            .get(pickListFieldName)
            .getDescribe().getPickListValues();
        for (Schema.PicklistEntry aPickListValue : pick_list_values) {                   
            picklistValues.add(aPickListValue.getValue()); 
        }
        return picklistValues;
    }
    
    public static SObjectType getSObjectType(String objectName){
        return Schema.getGlobalDescribe().get(objectName);
    }
}