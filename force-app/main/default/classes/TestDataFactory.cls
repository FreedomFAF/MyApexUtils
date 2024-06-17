/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {
    
    public static Integer index = 0;

    public static Integer getIndex(){
        return TestDataFactory.index += 1;
    }

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup ccg = new CollaborationGroup();
        ccg.Name ='TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        ccg.CollaborationType = 'Public';
        return ccg;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Product2> prods = new List<Product2>();

        for (Integer i = 0; i < cnt; i += 1){
            Product2 prod = new Product2();
            prod.Name = 'TEST'+getIndex().format();
            prod.Initial_Inventory__c = 10;
            prod.IsActive = true;
            prod.Family = Constants.PRODUCT_FAMILY.get(math.mod(i, Constants.PRODUCT_FAMILY.size())).getValue();

            prods.add(prod);
        }
        return prods;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook

        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 prod : prods){
            PricebookEntry pbe = new PricebookEntry();
            pbe.IsActive = true;
            pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            pbe.Product2Id = prod.Id;
            pbe.UnitPrice = getIndex();
            pbes.add(pbe);
        }
        
        return pbes;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < cnt; i +=1){
            Account a = new Account();
            a.Name = 'Test'+getIndex().format();
            accs.add(a);
        }
        return accs;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> conts = new List<Contact>();
        for(Integer i = 0; i < cnt; i += 1){
            Contact c = new Contact();
            c.LastName = 'Test'+getIndex().format();
            c.AccountId = accts.get(Math.mod(i, accts.size())).Id;
            conts.add(c);
        }
        
        return conts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < cnt; i += 1){
            Order o = new Order();
            o.Name = 'Order' + getIndex().format();
            o.AccountId = accts.get(Math.mod(i, accts.size())).Id;
            o.OwnerId = UserInfo.getUserId();
            o.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            o.EffectiveDate = Date.today();
            o.Status = 'Draft';
            orders.add(o);
        }

        return orders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> ois = new List<OrderItem>();
        for (Integer i = 0; i < cnt; i += 1){
            OrderItem oi = new OrderItem();
            oi.OrderId = ords.get(Math.mod(i, ords.size())).Id;
            PricebookEntry pbe = pbes.get(Math.mod(i, pbes.size()));
            oi.PricebookEntryId = pbe.Id;
            oi.UnitPrice = pbe.UnitPrice;
            oi.Quantity = getIndex();

            ois.add(oi);
        }
        
        return ois;
    }

    public static void verifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
        System.assert(updatedProduct.Quantity_Ordered__c == originalProduct.Quantity_Ordered__c + qtyOrdered);
    }


    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        CollaborationGroup cgg = ConstructCollaborationGroup();
        insert cgg;

        List<Product2> prods = ConstructProducts(cnt);
        insert prods;
        List<PricebookEntry> pbes = ConstructPricebookEntries(prods);
        insert pbes;
        List<Account> accts = ConstructAccounts(cnt);
        insert accts;
        List<Contact> conts = ConstructContacts(cnt, accts);
        insert conts;
        List<Order> ords = ConstructOrders(cnt, accts);
        insert ords;
        List<OrderItem> ois = ConstructOrderItems(cnt, pbes, ords);
        insert ois;

    }

    public static list<sObject> setFields(list<sObject> records, map<string, string> fieldValues){
        return setFields(records, fieldValues, true);
    }

    public static sObject setFields(sObject record, map<string, string> fieldValues, Boolean insertRecords){
        List<sObject> records = new List<sObject>();
        records.add(record);
        return setFields(records, fieldValues, insertRecords)[0];
    }

    public static list<sObject> setFields(list<sObject> records, map<string, string> fieldValues, Boolean insertRecords){
        // takes in a list of records and a map of the fields and what to set each field too, updates the records and returns the updated records
        // doesn't handle GeoLocations, Percent Values or anytypes  
        for (sObject r: records){
            for (string field: fieldValues.keySet()){
                Schema.DisplayType fdt = r.getSObjectType().getDescribe().fields.getMap().get(field).getDescribe().getType();
                switch on fdt {
                    when BOOLEAN {
                        r.put(field,Boolean.valueOf(fieldValues.get(field)));
                    }
                    when DATE {
                        r.put(field,Date.valueOf(fieldValues.get(field)));
                    }
                    when DATETIME {
                        r.put(field,Datetime.valueOf(fieldValues.get(field)));
                    }
                    when DOUBLE {
                        r.put(field,Double.valueOf(fieldValues.get(field)));
                    }
                    when LONG {
                        r.put(field,Long.valueOf(fieldValues.get(field)));
                    }
                    when INTEGER {
                        r.put(field,Integer.valueOf(fieldValues.get(field)));
                    }
                    when CURRENCY {
                        Decimal d = Decimal.valueOf(!String.isEmpty(fieldValues.get(field)) ? fieldValues.get(field) : '0');
                        r.put(field, d.setScale(8, RoundingMode.HALF_EVEN));
                    }
                    when TIME {
                        // only does hours and minutes
                        string[] strTimeSplit = fieldValues.get(field).split(':');
                        r.put(field,Time.newInstance(Integer.valueOf(strTimeSplit[0]), integer.valueOf(strTimeSplit[1]), 0, 0));
                    }
                    when else{
                        r.put(field,fieldValues.get(field));
                    }
                }
            }
        }
        if (insertRecords){
            update records;
        }
        return records;
    }


    public static Account createAccount(String name, Account parent){
        Integer i = getIndex();
        Account a = new Account();
        a.Name = name + i.format();
        if (parent != null){
            a.ParentId = parent.Id;
        }
        
        return a;
    }

    public static Data_Retention_Deletion__mdt createDataRetentionDeletion(){
        Data_Retention_Deletion__mdt mockDrd = new Data_Retention_Deletion__mdt();
        mockDrd.Object__c = 'Lead';
        mockDrd.Filter__c = 'CreatedDate < LAST_N_DAYS:5'; 
        return mockDrd;
    }
}