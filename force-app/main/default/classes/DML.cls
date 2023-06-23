public with sharing class DML {
    public DML() {}

    public List<sObject> doInsert(List<sObject> records){
        insert records;
        return records;
    }

    public sObject doInsert(sObject record){
        insert record;
        return record;
    }
    
    public List<sObject> doUpsert(List<sObject> records){
        upsert records;
        return records;
    }

    public sObject doUpsert(sObject record){
        upsert record;
        return record;
    }
    
    public List<sObject> doUpdate(List<sObject> records){
        update records;
        return records;
    }

    public sObject doUpdate(sObject record){
        update record;
        return record;
    }
    
    public List<sObject> doDelete(List<sObject> records){
        delete records;
        return records;
    }

    public sObject doDelete(sObject record){
        delete record;
        return record;
    }
}