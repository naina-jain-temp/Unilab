public class UNILAB_POC_INVENTORY {
    
    public class InventoryListWrapper {
        @AuraEnabled public Product_Availability_Item_Ref__c objProduct {get;set;}
        @AuraEnabled public Inventory__c objInventory {get;set;}
        public inventoryListWrapper(Product_Availability_Item_Ref__c objProduct, Inventory__c objInventory){
            this.objProduct = objProduct;
            this.objInventory = objInventory;
        }
    }
    
    @AuraEnabled
    public static List<InventoryListWrapper> fetch(String recordID, String pageSize, String pageNumber, String mustBrand, String period) {
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        String queryFilter = '';
        String filterPeriod = period;
       	
        List<Product_Availability_Item_Ref__c> prodList = new List<Product_Availability_Item_Ref__c>();
        List<Inventory__c> prevList = new List<Inventory__c>();
        List<Inventory__c> invList = new List<Inventory__c>();
        List<InventoryListWrapper> inventory = new List<InventoryListWrapper>();
        Set<String> setId = new Set<String>();
        Set<String> dupliId = new Set<String>();
        
        if(String.isBlank(period) || String.isEmpty(period)) {
            
            String m = String.valueOf(Date.Today().Month());
            String y = String.valueOf(Date.Today().Year());
            if(Integer.valueOf(m)<10) {
                m = '0'+m;
            }
            filterPeriod = String.valueOf(y+'01');
        }
        
        if(String.isNotBlank(mustBrand) || String.isNotEmpty(mustBrand)) {
            for(Product_Availability_Item_Ref__c prod : [SELECT Id, 
                                    Must_Brand__c,
                                    Manufacturer__c,
                                    Other_Code__c,
                                    Name,
                                    Pack_Size__c 
                                FROM Product_Availability_Item_Ref__c
                                WHERE Must_Brand__c =: mustBrand
                                    ORDER BY Name ASC
                                    LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)]) {
                prodList.add(prod);
            }
            
            if(String.isNotBlank(period) || String.isNotEmpty(period)) {
                
                for(Inventory__c inv : [SELECT Id,
                                    		Name,
                                            Product_ID__c,
                                       		Current_Inventory__c,
                                        	Current_Offtake__c,
                                        	Previous_Inventory__c,
                                        	Previous_Offtake__c,
                                        	Period__c,
                                    		Item_Name__c,
                                        	Form_Status__c,
                                        	LastModifiedBy.Name,
                                        	LastModifiedDate
                                       FROM Inventory__c
                                       WHERE Account__c =: recordID AND Period__c =: filterPeriod]) {
            		invList.add(inv);
                	dupliId.add(inv.Item_Name__c);
            	}
            } 
            /*
             else {
                for(Inventory__c inv : [SELECT Id,
                                    		Name,
                                            Product_ID__c,
                                       		Current_Inventory__c,
                                        	Current_Offtake__c,
                                        	Previous_Inventory__c,
                                        	Previous_Offtake__c,
                                        	Period__c,
                                    		Item_Name__c,
                                        	Form_Status__c,
                                        	LastModifiedBy.Name,
                                        	LastModifiedDate
                                       FROM Inventory__c WHERE Account__c =:recordID]) {
            		invList.add(inv);
                	dupliId.add(inv.Item_Name__c);
            	}
            }
			*/
        }
        
        for(Product_Availability_Item_Ref__c prod: prodList) {
            
            if(invList.size()<=0) {
                    	inventory.add(new InventoryListWrapper(prod, new Inventory__c(Item_Name__c=prod.Name,
                                                                                      Previous_Inventory__c = 0,
                                                                                      Previous_Offtake__c = 0)));
                setId.add(prod.Id);
                
            } else {
                for(Inventory__c inv: invList) {
                    if(prod.Name == inv.Item_Name__c) {
                        inventory.add(new InventoryListWrapper(prod, inv));
                    } else {
                        setId.add(prod.Name);
                    }
                }
            }
            
            if(setId.contains(prod.Name)) {
                if(!dupliId.contains(prod.Name)) {
                    inventory.add(new InventoryListWrapper(prod, new Inventory__c(Item_Name__c=prod.Name,
                                                                                  Previous_Inventory__c=0,
                                                                                  Previous_Offtake__c=0)));
                }
            }
            
        }
        return inventory;
    }
    
    @AuraEnabled
    public static Boolean formStatus(String recordID, String mustBrand, String period) {
        
        List<Inventory__c> submittedBool = [SELECT id
                                            FROM Inventory__c 
                                            WHERE Form_Status__c='Submit' 
                                            	AND Account__c= : recordID 
                                            	AND Period__c= : period 
                                            	AND Must_Brand__c= : mustBrand];
        
        return submittedBool.size()>0 ? true : false;
    }
    
    @AuraEnabled
    public static List<Inventory__c> previousInventory(String recordID, String mustBrand, String period) {
        
        List<Inventory__c> prevInventory = [SELECT id,
                                                   Name,
                                                   Current_Inventory__c,
                                                   Current_Offtake__c,
                                                   Period__c,
                                                   Item_Name__c,
                                                   Form_Status__c
                                            FROM Inventory__c 
                                            WHERE Form_Status__c='Submit' 
                                            	AND Account__c= : recordID 
                                            	AND Period__c= : period 
                                            	AND Must_Brand__c= : mustBrand];
        return prevInventory;
    }
    
    @AuraEnabled
    public static String saveForm(List<Inventory__c> inventoryData, String recordID, String mustBrand, String period, String formStatus) {
        String userId = userInfo.getUserId();
        Date todayDate = Date.today() ;
        Date prevDate = Date.today();
        Integer prevMonth = todayDate.month() - 1;
        Integer monthNow = todayDate.month();
        Integer dayNow = todayDate.day();
        Integer yearNow = todayDate.year();
        
        /*String m = String.valueOf(prevMonth);
        String y = String.valueOf(yearNow);
        if(Integer.valueOf(m)<10) {
            m = '0'+m;
        }
        
        if(prevMonth <= 0) {
            yearNow = yearNow-1;
            prevDate = Date.newInstance(yearNow, monthNow, dayNow);
        } else {
            prevDate = Date.newInstance(yearNow, prevMonth, dayNow);
        }
        
        String prevFilter = String.valueOf(y+m);*/
        
        List<Inventory__c> inventoryCheckList = new List<Inventory__c>();
        List<Inventory__c> existInventoryCheckList = new List<Inventory__c>();
        List<Inventory__c> insertInventoryCheckList = new List<Inventory__c>();
        List<Inventory__c> updateInventoryCheckList = new List<Inventory__c>();
        Set<String> setCheckList = new Set<String>();
        Inventory__c inventoryCheckListItem = new Inventory__c();
        for (Inventory__c inv : inventoryData) {
            inventoryCheckListItem = new Inventory__c(Item_Name__c = inv.Item_Name__c,
                                                      Current_Inventory__c = inv.Current_Inventory__c,
                                                      Current_Offtake__c = inv.Current_Offtake__c, 
                                                      Product_ID__c = inv.Product_ID__c,
                                                      Account__c = recordID,
                                                      Period__c = inv.Period__c,
                                                      Must_Brand__c = mustBrand,
                                                      Form_Status__c = formStatus
                                                     );
            inventoryCheckList.add(inventoryCheckListItem);
            setCheckList.add(inventoryCheckListItem.Item_Name__c);
        }
        
        for(Inventory__c exst : [SELECT id,
                                 		Account__c, 
                                     	Item_Name__c,
                                 		Form_Status__c,
                                 		Period__c,
                                 		Must_Brand__c
                                     FROM Inventory__c 
                                 	 WHERE Period__c =: period 
                                 		AND Must_Brand__c =: mustBrand]) {
            existInventoryCheckList.add(exst);
        }
        //System.debug(inventoryCheckList);
            System.debug('ENTERING>>>>>>');
        if(formStatus == 'Save as Draft') {
            System.debug('SAVE AS DRAFT');
            if(existInventoryCheckList.size() > 0) {
                Set<String> setInsertList = new Set<String>();
                for (Inventory__c inv : inventoryCheckList) {
                    for(Inventory__c updt : existInventoryCheckList) {
                        if(inv.Account__c == updt.Account__c 
                           && inv.Item_Name__c == updt.Item_Name__c) {
                            
                            System.debug('UPDATE');
                            Inventory__c updateItem = new Inventory__c(Item_Name__c = inv.Item_Name__c,
                                                              Current_Inventory__c = inv.Current_Inventory__c,
                                                              Current_Offtake__c = inv.Current_Offtake__c, 
                                                              Previous_Inventory__c = 0,
                                                              Previous_Offtake__c = 0,
                                                              Product_ID__c = inv.Product_ID__c,
                                                              Account__c = recordID,
                                                              Period__c = inv.Period__c,
                                                              Must_Brand__c = mustBrand,
                                                              Form_Status__c = formStatus,
                                                              id = updt.id
                                                             );
                            updateInventoryCheckList.add(updateItem);
                            setInsertList.add(updateItem.Item_Name__c);
                        }
                    }
                }
                
                
                for (Inventory__c inv : inventoryCheckList) {
                    for(Inventory__c updt : existInventoryCheckList) {
                        //System.debug(existInventoryCheckList);
                        if(inv.Account__c == updt.Account__c 
                           && inv.Item_Name__c != updt.Item_Name__c 
                           && !setInsertList.contains(inv.Item_Name__c)) {
                               
                            Inventory__c tempItem = new Inventory__c(Item_Name__c = inv.Item_Name__c,
                                                              Current_Inventory__c = inv.Current_Inventory__c,
                                                              Current_Offtake__c = inv.Current_Offtake__c, 
                                                              Product_ID__c = inv.Product_ID__c,
                                                              Account__c = recordID,
                                                              Period__c = inv.Period__c,
                                                              Must_Brand__c = mustBrand,
                                                              Form_Status__c = formStatus
                                                             );
                            insertInventoryCheckList.add(tempItem);
                            setInsertList.add(tempItem.Item_Name__c);
                        }
                    }
                }
                
                if(insertInventoryCheckList.size()>0) {
                    insert insertInventoryCheckList;
                   // System.debug(insertInventoryCheckList);
                }
                
                if(updateInventoryCheckList.size()>0) {
                    update updateInventoryCheckList;
                    //System.debug(updateInventoryCheckList);
                }
            } else {
                insert inventoryCheckList;
            }
        } else {
            Set<String> setInsertList = new Set<String>();
            for (Inventory__c inv : inventoryCheckList) {
                for(Inventory__c updt : existInventoryCheckList) {
                    if(inv.Account__c == updt.Account__c 
                       && inv.Item_Name__c == updt.Item_Name__c
                       && !setInsertList.contains(inv.Item_Name__c)) {
                           
                        Inventory__c updateItem = new Inventory__c(Item_Name__c = inv.Item_Name__c,
                                                                   Current_Inventory__c = inv.Current_Inventory__c,
                                                                   Current_Offtake__c = inv.Current_Offtake__c, 
                                                                   Product_ID__c = inv.Product_ID__c,
                                                                   Account__c = recordID,
                                                                   Period__c = inv.Period__c,
                                                                   Must_Brand__c = mustBrand,
                                                                   Form_Status__c = formStatus,
                                                                   id = updt.id
                                                                  );
                        updateInventoryCheckList.add(updateItem);
                        setInsertList.add(updateItem.Item_Name__c);
                    }
                }
            }
            if(updateInventoryCheckList.size()>0) {
                update updateInventoryCheckList;
                //System.debug(updateInventoryCheckList);
            }
        }
        
        
        return inventoryCheckListItem.Item_Name__c;

    }
}