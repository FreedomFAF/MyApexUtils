@istest 
public with sharing class SelectorTest {
    @TestSetup
    static void makeData(){
        List<Account> accs = new List<Account>();
        accs.add(new Account(Name = 'bob'));
        insert accs;
    }
    
    // Integration test for the selector class 
    @istest
    public static void testConstructor(){
        
        Test.startTest();
        Selector accountSelector = new Selector(Schema.Account.getSObjectType());
        Test.stopTest();
        Assert.isTrue(accountSelector.fieldList.contains('Id'), 'The field list should at least contain the Id field');

    }

    @istest 
    public static void testConstructorExtra(){
        Test.startTest();
        Selector accountSelector = new Selector(Schema.Account.getSObjectType(), new List<String>{'Name'});
        Test.stopTest();
        Assert.isTrue(accountSelector.fieldList.contains('Name'), 'The field list should at least contain the Id field');
    }

    @istest 
    public static void testSelectByIdSingle(){
        Account a = [SELECT Id, Name FROM Account LIMIT 1];
        Selector accountSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        Account selectorAccount = (Account)accountSelector.selectById(a.Id);
        Test.stopTest();
        Assert.isTrue(selectorAccount.Name == a.Name, 'The name of the account received from the selector should be: ' + a.Name + '\nBut it was actually: ' + selectorAccount.Name);
    }   

    @istest 
    public static void testSelectByIdList(){
        Test.startTest();

        Test.stopTest();
    }
}