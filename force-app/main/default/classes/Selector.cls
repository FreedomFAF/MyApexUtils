public with sharing class Selector {

    public SObjectType objectType;
    public String selectingOn;
    public String query;
    public String fieldList;
    public String whereClause;

    private Map<String, Object> bindParams;

    public Selector(SObjectType objectType) {
        this.objectType = objectType;
        buildFieldList(new List<String>());
    }

    public Selector(SObjectType objectType, List<String> extraFields){
        this.objectType = objectType;
        buildFieldList(extraFields);
    }

    private void buildFieldList(List<String> extraFields){
        DescribeSObjectResult objectDescribe = objectType.getDescribe();
        selectingOn = objectDescribe.getName();
        Map<String, Schema.SObjectField> fieldMap = objectDescribe.fields.getMap();
        fieldList = '';
        for (String fieldName :fieldMap.keySet()){
            DescribeFieldResult fieldDescibe = fieldMap.get(fieldName).getDescribe();
            if (fieldDescibe.isUpdateable() && fieldDescibe.isAccessible()){
                fieldList += fieldDescibe.getName() + ',';
            }
        }
        
        for (String extraField : extraFields){
            fieldList += extraField + ',';
        }
        fieldList = fieldList.removeEnd(',');
        resetQuery();
    }

    private void resetQuery(){
        bindParams = new Map<String, Object>();
        whereClause = '';
        query = 'SELECT ';
    }

    public SObject querySingle(){
        query += fieldList;
        query += ' FROM '+ selectingOn;
        query += ' WHERE ' + whereClause;
        query += ' LIMIT 1';
        SObject queryReturn = Database.queryWithBinds(query, bindParams, AccessLevel.USER_MODE);
        resetQuery();
        return queryReturn;
    }

    public List<SObject> queryList(){
        query += fieldList;
        query += ' FROM ' + selectingOn;
        query += ' WHERE ' + whereClause;
        List<SObject> queryReturn = Database.queryWithBinds(query, bindParams, AccessLevel.USER_MODE);
        resetQuery();
        return queryReturn;
    }   

    public Map<Id, SObject> queryMap(){
        query += fieldList;
        query += ' FROM ' + selectingOn;
        query += ' WHERE ' + whereClause;
        Map<Id,SObject> queryReturn = new Map<Id,SObject>(Database.queryWithBinds(query, bindParams, AccessLevel.USER_MODE));
        resetQuery();
        return queryReturn;
    }

    public Selector wEqual(String field, Object value){
        bindParams.put(field, value);
        whereClause += field + ' = :' + field;
        return this;
    }

    public Selector wNotEqual(String field, Object value){
        bindParams.put(field, value);
        whereClause += field + ' != :' + field;
        return this;
    }

    public Selector wIn(String field, Set<Object> values){
        bindParams.put(field, values);
        whereClause += field + ' IN :' + field;
        return this;
    }

    public Selector wAnd(){
        whereClause += ' AND ';
        return this;
    }

    public Selector wOr(){
        whereClause += ' OR ';
        return this;
    }

    public Selector wLBrace(){
        whereClause += ' ( ';
        return this;
    }

    public Selector wRBrace(){
        whereClause += ' ) ';
        return this;
    }
}