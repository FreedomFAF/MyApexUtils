@istest
public with sharing class MockSelectorProvider implements System.StubProvider {

    public static Boolean multiCall = false;

    private static integer callCountSingle = -1;
    private static integer callCountList = -1;

    public static SObject record;
    public static List<SObject> recordList;

    public static List<SObject> mcRecord;
    public static List<List<SObject>> mcRecordList;

    public static Selector mockSelector;
    
    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs) {
        
        if (multiCall){
            if (returnType.getName() == 'SObject'){
                callCountSingle += 1;
                return mcRecord.get(callCountSingle);
            }
            if (returnType.getName() == 'List<SObject>'){
                callCountList += 1;
                return mcRecordList.get(callCountList);
            }
        }else{
            if (returnType.getName() == 'SObject'){
                return record;
            }
            if (returnType.getName() == 'List<SObject>'){
                return recordList;
            }
        }

        if (returnType.getName() == 'Selector'){
            return mockSelector;
        }
        
        return null;
    }
}