public class UNILAB_PerDiem_Export {
     @AuraEnabled
    public static List<AggregateResult> fetchPDSummary(date startDate, date endDate, string overallStatus, string divisionGroup){
    	AggregateResult[] agResultsPDIName = [
            SELECT MAX(MAX_Key__c), Event_Start_Date__c, Employee_Id__c
            FROM Per_Diem_Item__c
            WHERE (Event_Start_Date__c >= :startDate AND Event_Start_Date__c <= :endDate+1)
            AND Overall_Status__c = :overallStatus
            AND Created_By_Division__c = :divisionGroup
            AND Rate_Sort__c <> 0
            GROUP by Event_Start_Date__c, Employee_Id__c];
        
        List<String> aggId = new List<String>();
        for (AggregateResult a: agResultsPDIName){
            aggId.Add((String)a.get('expr0'));

        }
        
        List<Per_Diem_Item__c> PDIIdGet = [
            SELECT Id
            FROM Per_Diem_Item__c
            WHERE MAX_Key__c IN :aggId
        ];
        
        
        List<String> aggId2 = new List<String>();
        for (Per_Diem_Item__c a: PDIIdGet){
            aggId2.Add((String)a.get('Id'));

        }
        
        AggregateResult[] result = [
        	SELECT Actual_Month__c,
                    Employee_ID__c, 
                    Division__c,
                    HB_OHB__c,
                    Place_of_Work__c,
            		COUNT_DISTINCT(MAX_Key__c) ddays
                	//COUNT_DISTINCT(Unique_No_of_Days__c) ddays
                	//SUM(Number_of_Days__c) ddays
                FROM Per_Diem_Item__c
                WHERE Id IN :aggId2
                GROUP BY
                    Actual_Month__c,
                    Employee_ID__c,
                    Division__c,
                    HB_OHB__c,
                    Place_of_Work__c

        ];
        
        return result;
    }
    
    
    @AuraEnabled
    public static List<Per_Diem_Item__c> fetchPDDetails(date startDate, date endDate, string overallStatus, string divisionGroup){
      
        return [SELECT 
                    Actual_Month__c,
                    Event_Start_Date__c,
                    Event_End_Date__c,
                    Employee_ID__c, 
                    Division__c,
                    HB_OHB__c,
                    Place_of_Work__c,
                    Event_Title__c,
                    Exemption_Remarks__c,
                    Created_By_Name__c,
                    Overall_Status__c
                FROM Per_Diem_Item__c
                WHERE (Event_Start_Date__c >= :startDate AND Event_Start_Date__c <= :endDate)
                    AND Overall_Status__c = :overallStatus
                    AND Created_By_Division__c = :divisionGroup
                ];
        
    }
    
    /*
    public class pdi {
        @AuraEnabled public String empId {get; set;}
        @AuraEnabled public Integer uDays {get; set;}
        @AuraEnabled public Date eventEndDate {get; set;}
        public pdi(String a, Integer b, Date c) {
            this.empId = a;
            this.uDays = b;
            this.eventEndDate = c;
        }
    }
    
    
    @AuraEnabled
    public static List<pdi> fetchPDDetailss(){
        //List<AggregateResult> plist = new List<AggregateResult>();
         //List<DelSum> PDI = new List<DelSum>();
         List<AggregateResult> agrResults = [SELECT Employee_ID__c,
                 Event_End_Date__c, 
                 COUNT_DISTINCT(Unique_No_of_Days__c) udays
                 FROM Per_Diem_Item__c
                 GROUP BY Employee_ID__c, Event_End_Date__c
                ];
        
        List<pdi> results = new List<pdi>();
        
        for (AggregateResult ar: agrResults){
            results.add(new pdi(
                    (String) ar.get('Employee_ID__c'),
                    (Integer) ar.get('udays'),
                    (Date) ar.get('Event_End_Date__c')
                    ));
        }
        
         return results;
    }*/
    
}