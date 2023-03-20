public class UNILAB_CompetitiveActivity_Export_Util {
    
    private static final String BASE64CHARS = '' + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' + 'abcdefghijklmnopqrstuvwxyz' + '0123456789+/';
    
    public class PicklistWrapper {
        
        @AuraEnabled public Map<String, List<String>> pickListMap;
        @AuraEnabled public String controllingFieldLabel;
        @AuraEnabled public String dependentFieldLabel;
        
    }
    
    public class PicklistEntryWrapper {
        
        public String active;
        public String defaultValue;
        public String label;
        public String value;
        public String validFor;
        
    }
    
    @AuraEnabled 
    public static Map<String, List<String>> getDependentPicklist(String objectName, String controllingFieldName, String dependentFieldName) {
        
        Map<String,List<String>> pickListMap = new Map<String,List<String>>();
        
        PicklistWrapper pw = new PicklistWrapper();
        pw.pickListMap = pickListMap;
        
        if (Schema.getGlobalDescribe().get(objectName) == null || String.isBlank(controllingFieldName) || String.isBlank(dependentFieldName)){
            return pw.pickListMap;
        }
        
        Schema.sObjectType objType = Schema.getGlobalDescribe().get(objectName).newSObject().getSObjectType();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingFieldName) || !objFieldMap.containsKey(dependentFieldName)){
            return pw.pickListMap;     
        }
        
        List<PicklistEntryWrapper> depEntries = (List<PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objFieldMap.get(dependentFieldName).getDescribe().getPicklistValues()), List<PicklistEntryWrapper>.class);
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : objFieldMap.get(controllingFieldName).getDescribe().getPicklistValues()) {
            pickListMap.put(ple.getLabel(), new List<String>());
            controllingValues.add(ple.getLabel());
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            
            String validForBits = base64ToBits(plew.validFor);
            
            for (Integer i = 0; i < validForBits.length(); i++) {
                
                String bit = validForBits.mid(i, 1);
                
                if (bit == '1') {
                    pickListMap.get(controllingValues.get(i)).add(plew.label);
                }
                
            }
            
        }
        
        pw.pickListMap = pickListMap;
        pw.controllingFieldLabel = objFieldMap.get(controllingFieldName).getDescribe().getLabel();
        pw.dependentFieldLabel = objFieldMap.get(dependentFieldName).getDescribe().getLabel();
        
        System.debug(pw.pickListMap);
        
        return pw.pickListMap;
        
    }
    
    public static String decimalToBinary(Integer val) {
        
        String bits = '';
        
        while (val > 0) {
            
            Integer remainder = Math.mod(val, 2);
            
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
            
        }
        
        return bits;
        
    }
    
    public static String base64ToBits(String validFor) {
        
        if (String.isEmpty(validFor)) {
            return '';
        } 
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            
            String thisChar = validFor.mid(i, 1);
            Integer val = BASE64CHARS.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            
            validForBits += bits;
            
        }
        
        return validForBits;
        
    }

}