/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {
    
    public static Integer index = 0;

    public static Integer getIndex(){
        return TestDataFactory.index += 1;
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
}