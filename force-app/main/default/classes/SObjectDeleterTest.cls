@istest
public with sharing class SObjectDeleterTest {
    
    @TestSetup
    static void makeData(){
        Account a1 = new Account(Name='a');     
        Account a2 = new Account(Name='b');     
        Account a3 = new Account(Name='c');     
        List<Account> accounts = new List<Account>{a1, a2, a3};
        insert accounts;
    }

    @istest
    public static void singleConstructor(){
        Test.startTest();
        SObjectDeleter sObjectDeleter = new SObjectDeleter('');
        Test.stopTest();
        Assert.isTrue(sObjectDeleter != null, 'Expect the constructor to return not a null');
    }   

    @istest
    public static void multiConstructor(){
        Test.startTest();
        SObjectDeleter sObjectDeleter = new SObjectDeleter(new List<String>{'',''});
        Test.stopTest();
        Assert.isTrue(sObjectDeleter != null, 'Expect the constructor to return not a null');
    }

    @istest
    public static void batchableSingle(){
        String query = 'SELECT Id, Name FROM Account WHERE Name = \'a\' LIMIT 1';
        DML mockDml = (DML)Stub.Builder().create(DML.class);
        Test.startTest();
        SObjectDeleter sobjectDeleter = new SObjectDeleter(query, mockDml);
        Database.executeBatch(sobjectDeleter);
        Test.stopTest();

        List<Object> firstDeletesArgs = (List<Object>)Stub.callArgs.get(0);
        List<Account> accountDeleted = (List<Account>)firstDeletesArgs.get(0);
        Assert.isTrue(accountDeleted.get(0).Name == 'a', 'Expect to have deleted the account with Name \'a\', received account with Name \'' + accountDeleted.get(0).Name + '\'');
    }

    @istest
    public static void batchableMulti(){
        String accountQuery = 'SELECT Id, Name FROM Account WHERE Name = \'b\' LIMIT 1';
        String leadQuery = 'SELECT Id, Name FROM Lead WHERE Name = \'lead1\' LIMIT 1';
        String taskQuery = 'SELECT Id FROM Task WHERE Subject = \'t1\' LIMIT 1';
        List<String> queries = new List<String>{accountQuery, leadQuery, taskQuery};
        DML mockDml = (DML)Stub.Builder().create(DML.class);
        Test.startTest();
        SObjectDeleter sObjectDeleter = new SObjectDeleter(queries, mockDml);
        Database.executeBatch(sobjectDeleter);
        Test.stopTest();
    
        List<Object> firstDeletesArgs = (List<Object>)Stub.callArgs.get(0);
        List<Account> accountDeleted = (List<Account>)firstDeletesArgs.get(0);
        Assert.isTrue(accountDeleted.get(0).Name == 'b', 'Expect to have deleted the account with Name \'b\', received account with Name \'' + accountDeleted.get(0).Name + '\'');
    }

    @istest
    public static void batchablePair(){
        String accountQuery = 'SELECT Id, Name FROM Account WHERE Name = \'c\' LIMIT 1';
        String leadQuery = 'SELECT Id, Name FROM Lead WHERE Name = \'lead2\' LIMIT 1';
        List<String> queries = new List<String>{accountQuery, leadQuery};
        DML mockDml = (DML)Stub.Builder().create(DML.class);
        Test.startTest();
        SObjectDeleter sObjectDeleter = new SObjectDeleter(queries, mockDml);
        Database.executeBatch(sobjectDeleter);
        Test.stopTest();

        List<Object> firstDeletesArgs = (List<Object>)Stub.callArgs.get(0);
        List<Account> accountDeleted = (List<Account>)firstDeletesArgs.get(0);
        Assert.isTrue(accountDeleted.get(0).Name == 'c', 'Expect to have deleted the account with Name \'c\', received account with Name \'' + accountDeleted.get(0).Name + '\'');
    }
}