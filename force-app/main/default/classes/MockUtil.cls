public class MockUtil {
    static Integer num = 1;

    private MockUtil() {}

    public static MockDMLProvider getDMLInstance(){
        return new MockDMLProvider();
    }

    public static MockErrorProvider getErrorInstance(){
        return new MockErrorProvider();
    }

    public static MockSelectorProvider getSelectorInstance(){
        return new MockSelectorProvider();
    }

    public static Object createDMLMock(Type typeToMock){
        return Test.createStub(typeToMock, MockUtil.getDMLInstance());
    }

    public static Object createErrorMock(Type typeToMock){
        return Test.createStub(typeToMock, MockUtil.getErrorInstance());
    }

    public static Object createSelectorMock(){
        Object stub = Test.createStub(Selector.class, MockUtil.getSelectorInstance());
        MockSelectorProvider.mockSelector = (Selector)stub;
        return stub;
    }

    public static String getFakeId(Schema.SObjectType sot){
        String result = String.valueOf(num++);
        return sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }

    public static String getFakeId(Id recordId){
        String result = String.valueOf(num++);
        return recordId.getSObjectType().getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }

    public static String getFakeId(sObject record){
        String result = String.valueOf(num++);
        return record.getSObjectType().getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    } 

    public static String getFakeId(List<sObject> records){
        String result = String.valueOf(num++);
        return records[0].getSObjectType().getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    } 

}