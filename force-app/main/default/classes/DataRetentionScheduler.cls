global with sharing class DataRetentionScheduler implements Schedulable{

    private Selector dataRetentionDeletionSelector;

    public DataRetentionScheduler(){
        dataRetentionDeletionSelector = new Selector(Schema.Data_Retention_Deletion__mdt.getSObjectType());
    }

    public DataRetentionScheduler(Selector dataRetentionDeletionSelector){
        this.dataRetentionDeletionSelector = dataRetentionDeletionSelector;
    }

    global void execute(SchedulableContext SC) {
        List<Data_Retention_Deletion__mdt> drds = (List<Data_Retention_Deletion__mdt>)dataRetentionDeletionSelector.queryList();
        List<String> queries = new List<String>();
        for (Data_Retention_Deletion__mdt drd : drds){
            queries.add('SELECT Id FROM ' + drd.Object__c + ' WHERE ' + drd.Filter__c);
        }
        if (queries.size() > 0){
            SObjectDeleter sObjectDeleter = new SObjectDeleter(queries);
            Database.executeBatch(sObjectDeleter);
        }
    }
}