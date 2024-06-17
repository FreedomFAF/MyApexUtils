@istest 
public with sharing class SelectorTest {
    @TestSetup
    static void makeData(){
        List<Account> accs = new List<Account>();
        accs.add(TestDataFactory.createAccount('agency', null));
        accs.add(TestDataFactory.createAccount('agency', null));
        accs.add(TestDataFactory.createAccount('agency', null));
        accs.add(TestDataFactory.createAccount('agency', null));
        accs.add(TestDataFactory.createAccount('agency', null));
        accs.add(TestDataFactory.createAccount('agency', null));
        accs.add(TestDataFactory.createAccount('primary', null));
        accs.add(TestDataFactory.createAccount('primary', null));
        accs.add(TestDataFactory.createAccount('select', null));
        insert accs;
    }
    
    // contructor tests
    @istest
    public static void testConstructor(){
        Test.startTest();
        Selector accountSelector = new Selector(Schema.Account.getSObjectType());
        Test.stopTest();
        Assert.isTrue(accountSelector.fieldList.contains('OwnerId'), 'The field list should at least contain the OwnerId field');
    }

    @istest 
    public static void testConstructorExtra(){
        Test.startTest();
        Selector accountSelector = new Selector(Schema.Account.getSObjectType(), new List<String>{'Name'});
        Test.stopTest();
        Assert.isTrue(accountSelector.fieldList.contains('Name'), 'The field list should at least contain the Name field');
    }

    @istest
    public static void testContructorType(){
        Test.startTest();
        Selector selector = new Selector(Schema.Account.getSObjectType(), 'update');
        Test.stopTest();
        Assert.isFalse(selector.fieldList.contains('CreatedDate'), 'the field list should not contain created date as it is not updatable');
    }

    @istest
    public static void testContructorTypeSystemMode(){
        Test.startTest();
        Selector selector = new Selector(Schema.Account.getSObjectType(), 'systemMode');
        Test.stopTest();
        Assert.isTrue(selector.fieldList.contains('SystemModstamp'), 'the field list should contain all the fields including SystemModstamp as we are selecting fields in system mode');
    }

    // actual query integration tests
    @istest 
    public static void testSelectByList(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        List<Account> accounts = (List<Account>)testSelector.queryList();
        Test.stopTest();
        Assert.isTrue(accounts.size() > 0, 'No accounts were returned when we expected to select accounts');
    }

    @istest 
    public static void testSelectBySingle(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Account account = null;
        Test.startTest();
        account = (Account)testSelector.querySingle();
        Test.stopTest();
        Assert.isTrue(account != null, 'No account was returned when we expected to select an account');
    }

    // Query maniplation methods 

    @istest
    public static void testWEqual(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.wEqual('Id', Stub.getId(Schema.Account.getSObjectType()));
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('Id = '),'the expected equals was not present in the query\'s where clause');
    }
    
    @istest
    public static void testWNotEqual(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.wNotEqual('Id', Stub.getId(Schema.Account.getSObjectType()));
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('Id != '),'the expected not equals was not present in the query\'s where clause');
    }

    @istest
    public static void testWInObject(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Set<Object> values = new Set<Object>{'bob'};
        Test.startTest();
        testSelector.wIn('Id', values);
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('Id IN '),'the expected IN was not present in the query\'s where clause');
    }

    @istest
    public static void testWInString(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Set<String> values = new Set<String>{'bob'};
        Test.startTest();
        testSelector.wIn('Id', values);
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('Id IN '),'the expected IN was not present in the query\'s where clause');
    }

    @istest
    public static void testWInId(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Set<Id> values = new Set<Id>{Stub.getId(Schema.Account.getSObjectType())};
        Test.startTest();
        testSelector.wIn('Id', values);
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('Id IN '),'the expected IN was not present in the query\'s where clause');
    }

    @istest
    public static void testWInInteger(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Set<Integer> values = new Set<Integer>{1};
        Test.startTest();
        testSelector.wIn('Id', values);
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('Id IN '),'the expected IN was not present in the query\'s where clause');
    }

    @istest
    public static void testWInDecimal(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Set<Decimal> values = new Set<Decimal>{0.5};
        Test.startTest();
        testSelector.wIn('Id', values);
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('Id IN '),'the expected IN was not present in the query\'s where clause');
    }

    @istest
    public static void testWInDate(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Set<Date> values = new Set<Date>{Date.today()};
        Test.startTest();
        testSelector.wIn('Id', values);
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('Id IN '),'the expected IN was not present in the query\'s where clause');
    }

    @istest
    public static void testWInDateTime(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Set<DateTime> values = new Set<DateTime>{DateTime.now()};
        Test.startTest();
        testSelector.wIn('Id', values);
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('Id IN '),'the expected IN was not present in the query\'s where clause');
    }


    @istest
    public static void testWAnd(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.wAnd();
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('AND'),'the expected AND was not present in the query\'s where clause');
    }

    @istest
    public static void testWOr(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.wOr();
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('OR'),'the expected OR was not present in the query\'s where clause');
    }

    @istest
    public static void testWLBrace(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.wLBrace();
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains('('),'the expected left brace was not present in the query\'s where clause');
    }

    @istest
    public static void testWRBrace(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.wRBrace();
        Test.stopTest();
        Assert.isTrue(testSelector.whereClause.contains(')'),'the expected right brace was not present in the query\'s where clause');
    }

    @istest
    public static void testOrderBy(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.orderBy('Id');
        Test.stopTest();
        Assert.isTrue(testSelector.extras.contains('ORDER BY'),'the expected Order By was not present in the query\'s extras');
    }

    @istest
    public static void testOrderByASC(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.orderBy('Id', true);
        Test.stopTest();
        Assert.isTrue(testSelector.extras.contains('ORDER BY'),'the expected Order By was not present in the query\'s extras');
        Assert.isTrue(testSelector.extras.contains('ASC'),'the expected ASC was not present in the query\'s extras');
    }

    @istest
    public static void testOrderByDESC(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.orderBy('Id', false);
        Test.stopTest();
        Assert.isTrue(testSelector.extras.contains('ORDER BY'),'the expected Order By was not present in the query\'s extras');
        Assert.isTrue(testSelector.extras.contains('DESC'),'the expected DESC was not present in the query\'s extras');
    }

    @istest
    public static void testOrderByList(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.orderBy(new List<String>{'Id', 'Name'});
        Test.stopTest();
        Assert.isTrue(testSelector.extras.contains('ORDER BY'),'the expected Order By was not present in the query\'s extras');
        Assert.isTrue(testSelector.extras.contains(',Name'),'the expected extra orderer Name was not present in the query\'s extras');
    }

    @istest
    public static void testOrderByASCList(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.orderBy(new List<String>{'Id', 'Name'}, new List<Boolean>{true, true});
        Test.stopTest();
        Assert.isTrue(testSelector.extras.contains('ORDER BY'),'the expected Order By was not present in the query\'s extras');
        Assert.isTrue(testSelector.extras.contains(',Name'),'the expected extra orderer Name was not present in the query\'s extras');
        Assert.isTrue(testSelector.extras.contains('ASC'),'the expected ASC was not present in the query\'s extras');
    }

    @istest
    public static void testOrderByDESCList(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.orderBy(new List<String>{'Id', 'Name'}, new List<Boolean>{false, false});
        Test.stopTest();
        Assert.isTrue(testSelector.extras.contains('ORDER BY'),'the expected Order By was not present in the query\'s extras');
        Assert.isTrue(testSelector.extras.contains(',Name'),'the expected extra orderer Name was not present in the query\'s extras');
        Assert.isTrue(testSelector.extras.contains('DESC'),'the expected DESC was not present in the query\'s extras');
    }
    
    @istest
    public static void testNullsLast(){
        Selector testSelector = new Selector(Schema.Account.getSObjectType());
        Test.startTest();
        testSelector.nullsLast();
        Test.stopTest();
        Assert.isTrue(testSelector.extras.contains('NULLS LAST'), 'the expected NULLS LAST was not present in the query\'s extras');
    }
}