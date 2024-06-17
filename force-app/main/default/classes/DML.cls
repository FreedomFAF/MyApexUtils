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
    
    public List<SObject> doUpsert(List<SObject> records){
        upsert records;
        return records;
    }

    /*public List<SObject> doUpsert(List<SObject> records, Schema.DescribeFieldResult upsertIdFieldDescribe, Boolean allOrNone){
        Database.upsert(records, upsertIdFieldDescribe.getSobjectField(), allOrNone);
        return records;
    }*/

    public SObject doUpsert(SObject record){
        upsert record;
        return record;
    }

    /*public SObject doUpsert(SObject record, Schema.DescribeFieldResult  upsertIdFieldDescribe, Boolean allOrNone){
        Database.upsert(record, upsertIdFieldDescribe.getSobjectField(), allOrNone);
        return record;
    }*/
    
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

    public List<Messaging.SendEmailResult> sendEmail(List<Messaging.Email> email, Boolean allOrNothing){
        //https://salesforce.stackexchange.com/questions/237458/messaging-sendemailresult-type-cannot-be-constructed
        return Messaging.sendEmail(email, allOrNothing);
    }

    public Id executeBatch(Object batchObject){
        // Test.createStub cannot handle a Paramaterised Type that isn't a Set, List or Map in a methods args, so the DataBase.Batchable has to be passed as an Object and then cast back to a DataBase.Batchable
        if (batchObject instanceOf DataBase.Batchable<SObject>){
            DataBase.Batchable<SObject> batchable = (DataBase.Batchable<SObject>)batchObject;
            return Database.executeBatch(batchable);
        }
        return null;
    }

    public Id executeBatch(Object batchObject, Integer batchSize){
        // Test.createStub cannot handle a Paramaterised Type that isn't a Set, List or Map in a methods args, so the DataBase.Batchable has to be passed as an Object and then cast back to a DataBase.Batchable
        if (batchObject instanceOf DataBase.Batchable<SObject>){
            DataBase.Batchable<SObject> batchable = (DataBase.Batchable<SObject>)batchObject;
            return Database.executeBatch(batchable, batchSize);
        }
        return null;
    }
}