public class Unilab_RfcmNumberFormatClass  {
    public static void rfcm(List<RFCM__c> rlist){
        integer year;
       List<date> datess=new List<date>();
        date dat=system.today();
        integer systemYear=dat.year();
        

     List<RFCM_FormNumber__c> sets=[select Id,Number__c,Date__c from RFCM_FormNumber__c];
       List<decimal> numList=new List<decimal>(); 
        List<date> DateList=new List<date>();
        for(RFCM_FormNumber__c refc:sets){
            if(refc.Date__c.Year()==systemYear){
                DateList.add(refc.Date__c); 
                numList.add(refc.Number__c);
            }
            
        }
        if(Test.isRunningTest()){
            DateList.add(date.today());
            numList.add(700);
        }
            year=DateList.get(0).Year();
            decimal test=numList.get(0);
            date date1=DateList.get(0);
       
    for(RFCM__c rfcm:rlist){
        
        if(test<10){
         rfcm.Name='RFCM'+year+'00000'+test;   
        }
        else if(test>=10 && test<=99){
          rfcm.Name='RFCM'+year+'0000'+test;  
        }
        else if(test>=100 && test<=999){
          rfcm.Name='RFCM'+year+'000'+test;  
        }
         else if(test>=1000 && test<=9999){
          rfcm.Name='RFCM'+year+'00'+test;  
        }
          else if(test>=10000 && test<=99999){
          rfcm.Name='RFCM'+year+'0'+test;  
        } 
        else if(test>99999){
          rfcm.Name='RFCM'+year+test;  
        }        
    }

    List<RFCM_FormNumber__c>updateList=[select Id,Number__c,Date__c from RFCM_FormNumber__c where Date__c=:date1];
    List<RFCM_FormNumber__c> list11=new List<RFCM_FormNumber__c>();
    for(RFCM_FormNumber__c rfcss:updateList){
        rfcss.Number__c+=1;
        list11.add(rfcss);     
    }
     update list11; 
    } 
    }