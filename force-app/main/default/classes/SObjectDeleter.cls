public with sharing class SObjectDeleter implements Database.Batchable<sObject>{
    
    private List<String> queries;
    private String query;
    
    private DML dml;

    public SObjectDeleter(String query) {
        this.query = query;
        dml = new DML();
    }

    public SObjectDeleter(List<String> queries){
        this.query = queries.remove(0);
        this.queries = queries;
        dml = new DML();
    }

    public SObjectDeleter(String query, DML dml){
        this.query = query;
        this.dml = dml;
    }

    public SObjectDeleter(List<String> queries, DML dml){
        this.query = queries.remove(0);
        this.queries = queries;
        this.dml = dml;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<SObject> records){
       dml.doDelete(records);
    }

    public void finish(Database.BatchableContext bc){
        if (queries != null){
            if (!queries.isEmpty()){
                SObjectDeleter sObjectDeleter;
                if (queries.size() > 1){
                    sObjectDeleter = new SObjectDeleter(queries);
                }else{
                    sObjectDeleter = new SObjectDeleter(queries.get(0));
                }
                dml.executeBatch(sObjectDeleter);
            }
        }
    }
}