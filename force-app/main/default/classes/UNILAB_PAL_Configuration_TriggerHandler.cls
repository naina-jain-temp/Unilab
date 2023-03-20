/*-------------------------------------------------------------------------------------------
Author       :   Irene Hermia
Created Date :   07.04.2019
Definition   :   Trigger Handler for UNILAB_PAL_Configuration
-------------------------------------------------------------------------------------------*/
public class UNILAB_PAL_Configuration_TriggerHandler {
    
    //update Ending Inventory Operator & Ending Inventory Value when 
    //Ending Inventory Data Type is set to --None-- 
    public static void doBeforeUpdate(List<Pal_Configuration__c> newConfigRecords){
        
        List<Pal_Configuration__c> newPalConfigRecs = new List<Pal_Configuration__c>();
          
        
        for(Pal_Configuration__c configRec : newConfigRecords){ 
            
      		 if((configRec.Ending_Inventory_Data_Type__c == null) || (configRec.Ending_Inventory_Data_Type__c == '')){
        
               configRec.Ending_Inventory_Operator__c = null;
               configRec.Ending_Inventory_Value__c = null;
               newPalConfigRecs.add(configRec);   
       		 }
        }
    }

}