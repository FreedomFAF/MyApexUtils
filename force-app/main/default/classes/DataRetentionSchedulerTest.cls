@istest
public with sharing class DataRetentionSchedulerTest {
    @istest
    public static void schedulable(){
        String cronExp = '0 0 3 * * ?';
        
        Selector mockDataRetentionDeletionSelector = (Selector)Stub.Builder()
            .addMethodHandler('queryList', new Stub.Method(new List<Data_Retention_Deletion__mdt>{TestDataFactory.createDataRetentionDeletion()}))
            .create(Selector.class);
        DML mockDML = (DML)Stub.Builder().create(DML.class);

        DataRetentionScheduler dts = new DataRetentionScheduler(mockDataRetentionDeletionSelector);
        Test.startTest();
        String jobId = System.schedule('Daily Data Retention Deletion', cronExp, dts);
        Test.stopTest();
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        Assert.isTrue(ct.CronExpression == cronExp, 'the received cron expression should be \'' + cronExp + '\' but received \'' +ct.CronExpression + '\'');
    }

    @istest
    public static void constructor(){
        Test.startTest();
        DataRetentionScheduler dts = new DataRetentionScheduler();
        Test.stopTest();

        Assert.isTrue(String.valueOf(dts).substringBefore(':') == 'DataRetentionScheduler', 'Expect dts to be of type DataRetentionScheduler, but received a type of \'' + String.valueOf(dts).substringBefore(':') + '\'');
    }
}