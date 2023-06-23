@istest
public with sharing class MockDMLProvider implements System.StubProvider{

    public static List<sObject> records;
    public static sObject record;

    public static List<Object> passedRecords = new List<Object>();

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs) {

        if(stubbedObject instanceof DML && returnType.getName() == 'List<SObject>'){
            passedRecords.add(listOfArgs);
            return records;
        }

        if(stubbedObject instanceof DML && returnType.getName() == 'SObject'){
            passedRecords.add(listOfArgs);
            return record;
        }

        return null;
    }
}