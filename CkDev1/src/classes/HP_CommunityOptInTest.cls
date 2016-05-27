@isTest
private class HP_CommunityOptInTest {
    
    @isTest static void test_method_one() {
        Account a = new Account(name='testAcc');
        insert a;
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser@test.com', ContactId=c.Id);
        insert u;
        HP_ProfileSubCommunityMap__c psc = new HP_ProfileSubCommunityMap__c(Name='Standard', Profile__c='Customer Community User', 
            Sub_Community__c='Standard');
        insert psc;
        CollaborationGroup cg = new CollaborationGroup(Name='My Group', CollaborationType='Public');
        insert cg;
        HP_CommunityOptIn__c coi = new HP_CommunityOptIn__c(Name='Standard', Sub_Community__c='Standard', Body__c='Test', Logo_URL__c='', Title__c='Test');
        insert coi;
        ProfileDomainName__c pdn = new ProfileDomainName__c(Name='CommunityDomain', DomainName__c='alumni');
        insert pdn;
        Url_Pattern__c urlPat = new Url_Pattern__c(Name='Test', Url_User_Agent__c='Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile');
        insert urlPat;

        System.runAs(u) 
        {
            PageReference pageRef = Page.HP_CommunityOptIn;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('p1', 'false');
            ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');
            HP_CommunityOptIn controller = new HP_CommunityOptIn();
            controller.populateMobile();
            controller.agreeBtnAction();
        }
    }
    
}