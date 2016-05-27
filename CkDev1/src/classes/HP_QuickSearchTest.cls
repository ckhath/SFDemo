@istest
public with sharing class HP_QuickSearchTest {

  public static void addDomainName(String domainName){
        ProfileDomainName__c objDomain = new ProfileDomainName__c();
        objDomain.DomainName__c = domainName;
        objDomain.name='CommunityDomain';
        try{
            insert objDomain;
        }
        catch(DmlException d){
        }
    }//End Method

    public static testmethod void testHP_QuickSearch(){
        AddDomainName('alumni');
        Account a = new Account(name='testAcc');
        insert a;
      
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
        
        Profile p = [select id from profile where name='Customer Community Login User'];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id,
                          timezonesidkey='America/Los_Angeles', username='standarduser@test.com',
                          ContactId=c.Id);
        insert u;
        system.runAs(u){
            HP_QuickSearchController quickSearch = new HP_QuickSearchController();
            system.assertequals(quickSearch.profileDomain, UtilityGeneral.getProfileDomainName().domainName__c);
        }
    }//End testmethod
}//End class