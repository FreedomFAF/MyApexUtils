@istest
public with sharing class Stub implements System.StubProvider {

    public static List<String> callNames = new List<String>();
    public static List<Object> callArgs = new List<Object>();
    public Map<String, Map<String, Method>> mockedObjects = new Map<String, Map<String, Method>>(); 
    public Map<String, Method> mockedMethod = new Map<String, Method>();

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs) {
        String stubbedObjectName = String.valueOf(stubbedObject).substringBefore(':').substringBefore('__sfdc_ApexStub');
        System.debug(stubbedObjectName);
        callNames.add(stubbedMethodName);
        callArgs.add(listOfArgs);

        if (stubbedObjectName == returnType.getName()){ // builder method that returns this
            return stubbedObject;
        }

        if (mockedObjects?.get(stubbedMethodName)?.get(stubbedMethodName) != null){
            return mockedObjects.get(stubbedMethodName).get(stubbedMethodName).mock();
        }

        if (mockedMethod?.get(stubbedMethodName) != null){
            return mockedMethod.get(stubbedMethodName).mock();
        }
        return null;
    }

    public static Builder builder(){
        return new Builder();
    }

    public class Builder{
        private Stub stub;
        
        public Builder(){
            stub = new Stub();
        }

        // pass a stub.method builder class/build it in the args
        public Builder addMethodHandler(String objectName, String methodName, Stub.Method method){
            if (stub.mockedObjects?.get(objectName) == null){
                stub.mockedObjects.put(objectName, new Map<String, Stub.Method>{methodName => method});
            }else{
                Map<String, Stub.Method> objectMthods = stub.mockedObjects.get(objectName);
                objectMthods.put(methodName, method);
            }
            return this;
        }

        public Builder addMethodHandler(String methodName, Stub.Method method){
            stub.mockedMethod.put(methodName, method);
            return this;
        }

        public Object create(Type typeToMock){
            return Test.createStub(typeToMock, stub);
        }
    }

    public class Method{
        // class to store all the info for each particular method that can be called and each one that is called 
        Map<Integer, Object> returnValues = new Map<Integer, Object>();
        Object defaultReturnValue;
        Integer callCount = 0;

        Integer start;
        Integer stop;

        public Method(){
            defaultReturnValue = null;
        }

        public Method(Object defaultReturnValue){
            this.defaultReturnValue = defaultReturnValue; 
        }

        public Method defaultResponse(Object defaultResponse){
            defaultReturnValue = defaultResponse;
            return this;
        }

        public Method handleCall(Integer callNumber){
            this.start = callNumber;
            this.stop = callNumber + 1;
            return this;
        }

        public Method handleCalls(Integer start, Integer stop){
            this.start = start;
            this.stop = stop;
            return this;
        }

        public Method with(Object returnObject){
            for (Integer i = start; i < stop; i += 1){
                returnValues.put(i, returnObject);
            }
            return this;
        }

        public Object mock(){
            Object value = null;
            if (returnValues?.get(callCount) != null){
                if (returnValues?.get(callCount) instanceOf Exception){
                    errorOn((Exception)returnValues.get(callCount));
                }else{
                    value = returnValues.get(callCount);
                }
            }else{
                if (defaultReturnValue instanceOf Exception){
                    errorOn((Exception)defaultReturnValue);
                }else{
                    value = defaultReturnValue;
                }
            }
            callCount += 1;
            return value;
        } 
        
        private void errorOn(Exception e){
            callCount += 1;
            throw e;
        }
    }
    
    private static Integer num = 0;

    public static String getId(Schema.SObjectType sot){
        String result = String.valueOf(num++);
        return sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }

    public static String getId(Id recordId){
        String result = String.valueOf(num++);
        return recordId.getSObjectType().getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }

    public static String getId(sObject record){
        String result = String.valueOf(num++);
        return record.getSObjectType().getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    } 

    public static String getId(List<sObject> records){
        String result = String.valueOf(num++);
        return records[0].getSObjectType().getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    } 
}