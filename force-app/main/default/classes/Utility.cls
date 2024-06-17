public with sharing class Utility {
    // class for functionality and wrappers for non writeable system objects

    // example 1 isSandbox on the Organization object, is not writable therefore we can wrap it in a static context like below so we can set it in tests using sIsSandbox 
    public static Selector orgSelector = new Selector(Schema.Organization.getSObjectType());
    @testVisible static Boolean sIsSandbox = false;

    static {
        sIsSandbox = ((Organization)orgSelector.querySingle()).IsSandbox;
    }

    public static Boolean isSandbox(){
        return sIsSandbox;
    }
}