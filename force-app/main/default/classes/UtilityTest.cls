@istest
public with sharing class UtilityTest {
    @istest
    public static void isSandbox(){
        Boolean inSandbox = true;
        Utility.sIsSandbox = inSandbox;
        Test.startTest();
        Boolean isItASandbox = Utility.isSandbox();
        Test.stopTest();
        Assert.isTrue(isItASandbox == inSandbox, 'Expected isSandbox to return ' + String.valueOf(inSandbox) + ' \' but received ' + String.valueOf(isItASandbox));
    }   
}