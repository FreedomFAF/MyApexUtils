public with sharing class Selector {

    private static System.AccessLevel currentAccessLevel = AccessLevel.SYSTEM_MODE; // default it to system mode 

    public static void systemMode(){
        currentAccessLevel = AccessLevel.SYSTEM_MODE; 
    }
    public static void userMode(){
        currentAccessLevel = AccessLevel.USER_MODE; 
    }

    public SObjectType objectType;
    public String selectingOn;
    public String query;
    public String fieldList;
    public String whereClause;
    public String extras;

    private Map<String, Object> bindParams;
    private Integer bindCount = 0;

    public Selector(SObjectType objectType) {
        this.objectType = objectType;
        buildFieldList(new List<String>(), 'read');
    }

    public Selector(SObjectType objectType, List<String> extraFields){
        this.objectType = objectType;
        buildFieldList(extraFields, 'read');
    }

    public Selector(SObjectType objectType, String selectType){
        //select types values can be read or update
        this.objectType = objectType; 
        buildFieldList(new List<String>(), selectType);
    }

    private void buildFieldList(List<String> extraFields, String selectType){
        DescribeSObjectResult objectDescribe = objectType.getDescribe();
        selectingOn = objectDescribe.getName();
        Map<String, Schema.SObjectField> fieldMap = objectDescribe.fields.getMap();
        fieldList = '';
        for (String fieldName :fieldMap.keySet()){
            DescribeFieldResult fieldDescibe = fieldMap.get(fieldName).getDescribe();
            switch on selectType {
                when 'update' {
                    if (fieldDescibe.isUpdateable() && fieldDescibe.isAccessible()){
                        fieldList += fieldDescibe.getName() + ',';
                    }
                }
                when 'systemMode'{
                    fieldList += fieldDescibe.getName() + ',';
                }
                when else {
                    if (fieldDescibe.isAccessible()){
                        fieldList += fieldDescibe.getName() + ',';
                    }
                }
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
        extras = '';
        query = 'SELECT ';
    }

    private String createBind(Object value){
        // returns the bind name, to be added to the query 
        bindCount += 1;
        String bindName = 'bind' + bindCount.format();
        bindParams.put(bindName, value);
        return bindName;
    }

    public SObject querySingle(){
        query += fieldList;
        query += ' FROM '+ selectingOn;
        if (!String.isEmpty(whereClause)){
            query += ' WHERE ' + whereClause;
        }
        query += extras;
        query += ' LIMIT 1';
        SObject queryReturn = Database.queryWithBinds(query, bindParams, currentAccessLevel);
        resetQuery();
        return queryReturn;
    }

    public List<SObject> queryList(){
        query += fieldList;
        query += ' FROM ' + selectingOn;
        if (!String.isEmpty(whereClause)){
            query += ' WHERE ' + whereClause;
        }
        query += extras;
        List<SObject> queryReturn = Database.queryWithBinds(query, bindParams, currentAccessLevel);
        resetQuery();
        return queryReturn;
    }   

    public Selector wEqual(String field, Object value){
        whereClause += field + ' = :' + createBind(value);
        return this;
    }

    public Selector wNotEqual(String field, Object value){
        whereClause += field + ' != :' + createBind(value);
        return this;
    }

    public Selector wIn(String field, Set<Object> values){
        whereClause += field + ' IN :' + createBind(values);
        return this;
    }

    public Selector wIn(String field, Set<String> values){
        bindParams.put(field, values);
        whereClause += field + ' IN :' + createBind(values);
        return this;
    }

    public Selector wIn(String field, Set<Id> values){
        whereClause += field + ' IN :' + createBind(values);
        return this;
    }

    public Selector wIn(String field, Set<Integer> values){
        whereClause += field + ' IN :' + createBind(values);
        return this;
    }

    public Selector wIn(String field, Set<Decimal> values){
        whereClause += field + ' IN :' + createBind(values);
        return this;
    }
    
    public Selector wIn(String field, Set<Date> values){
        whereClause += field + ' IN :' + createBind(values);
        return this;
    }

    public Selector wIn(String field, Set<Datetime> values){
        whereClause += field + ' IN :' + createBind(values);
        return this;
    }

    // the stub provider doesn't like sets of Times 

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

    public Selector orderBy(String field){
        extras += ' ORDER BY ' + field;
        return this;
    }

    public Selector orderBy(String field, Boolean direction){
        // true direction is ASC, false direction is DESC
        extras += ' ORDER BY ' + field;
        if (direction){
            extras += ' ASC ';
        }else{
            extras += ' DESC ';
        }
        return this;
    }

    public Selector orderBy(List<String> fields){
        extras += ' ORDER BY ';
        for (String field : fields){
            extras += field + ',';
        }
        extras.removeEnd(',');
        return this;
    }

    public Selector orderBy(List<String> fields, List<Boolean> directions){
        extras += ' ORDER BY ';
        for (Integer i = 0; i < fields.size(); i+=1){
            extras += fields.get(i);
            if (directions.get(i)){
                extras += ' ASC ';
            }else{
                extras += ' DESC ';
            }
            extras += ',';
        }
        extras.removeEnd(',');
        return this;
    }

    public Selector nullsLast(){
        extras += ' NULLS LAST ';
        return this;
    }
}