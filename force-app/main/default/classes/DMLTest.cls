@istest
public with sharing class DMLTest {
    @TestSetup
    public static void makeData(){
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 50; i += 1){
            accs.add(new Account (Name = 'test'+i.format()));
        }
        insert accs;
    }

    @istest
    public static void testDoInsertBulk(){
        DML dml = new DML();
        List<Account> accounts = new List<Account>();
        Account account = new Account();
        account.Name = 'bob';
        accounts.add(account);

        Test.startTest();
        accounts = dml.doInsert(accounts);
        Test.stopTest();
        System.assert(accounts[0].Id != null, 'The account should have an account Id as it has been inserted');
    }

    @istest
    public static void testDoInsert(){
        DML dml = new DML();
        Account account = new Account();
        account.Name = 'bob';

        Test.startTest();
        account = (Account)dml.doInsert(account);
        Test.stopTest();
        
        System.assert(account.Id != null, 'The account should have an account Id as it has been inserted');
    }

    @istest
    public static void testDoUpdateBulk(){
        List<Account> accounts = [SELECT Id, Name FROM Account];
        for (Account account : accounts){
            account.Name += 'A';
        }
        DML dml = new DML();
        Test.startTest();
        accounts = dml.doUpdate(accounts);
        Test.stopTest();
        List<Account> newAccounts = [SELECT Id, Name FROM Account];
        Integer r = Integer.valueOf(Math.random() * (newAccounts.size() - 1));// the valueof should be replaced by a Math.floor and the -1 removed for a more evenly distributed random number 
        System.assert(newAccounts[r].Name.endsWith('A'), 'The Accounts name should end with an A');
    }

    @istest
    public static void testDoUpdate(){
        Account a = [SELECT Id, Name FROM Account LIMIT 1];
        Id theAccountId = a.Id;
        a.Name += 'B';
        DML dml = new DML();
        Test.startTest();
        dml.doUpdate(a);
        Test.stopTest();
        Account aNew = [SELECT Id, Name FROM Account WHERE Id = :theAccountId LIMIT 1];
        System.assert(aNew.Name.endsWith('B'), 'The Accounts Name should end with B');
    }

    @istest
    public static void testDoUpsertBulk(){
        List<Account> accounts = [SELECT Id, Name FROM Account];
        for (Account account : accounts){
            account.Name += 'C';
        }
        DML dml = new DML();
        Test.startTest();
        accounts = dml.doUpsert(accounts);
        Test.stopTest();
        List<Account> newAccounts = [SELECT Id, Name FROM Account];
        Integer r = Integer.valueOf(Math.random() * (newAccounts.size() - 1));// the valueof should be replaced by a Math.floor and the -1 removed for a more evenly distributed random number 
        System.assert(newAccounts[r].Name.endsWith('C'), 'The Accounts name should end with an C');
    }

    @istest
    public static void testDoUpsert(){
        Account a = [SELECT Id, Name FROM Account LIMIT 1];
        Id theAccountId = a.Id;
        a.Name += 'D';
        DML dml = new DML();
        Test.startTest();
        dml.doUpsert(a);
        Test.stopTest();
        Account aNew = [SELECT Id, Name FROM Account WHERE Id = :theAccountId LIMIT 1];
        System.assert(aNew.Name.endsWith('D'), 'The Accounts Name should end with D');
    }

    @istest
    public static void testDoDeleteBulk(){
        Set<Id> accIds = new Set<Id>();
        List<Account> accs = [SELECT Id, Name FROM Account LIMIT 25];
        for (Account acc : accs){
            accIds.add(acc.Id);
        }
        DML dml = new DML();
        Test.startTest();
        dml.doDelete(accs);
        Test.stopTest();
        List<Account> newAs = [SELECT Id, Name FROM Account WHERE Id IN :accIds];
        System.assert(newAs.size() == 0, 'There should be no accounts in the select');
    }

    @istest
    public static void testDoDelete(){
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];
        Id accountId = acc.Id;
        DML dml = new DML();
        
        Test.startTest(); 
        dml.doDelete(acc);
        Test.stopTest();
        List<Account> aNew = [SELECT Id, Name FROM Account WHERE Id =:accountId];

        System.assert(aNew.size() == 0, 'The size of the reselected list should be 0');
        
    }
}