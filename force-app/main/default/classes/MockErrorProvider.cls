@istest
public class MockErrorProvider implements System.StubProvider{

    public static String errorMessage = 'Process Errored';

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs) {
        throw new HandledException(errorMessage);
    }
}