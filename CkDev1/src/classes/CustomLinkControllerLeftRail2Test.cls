@isTest
public with sharing class CustomLinkControllerLeftRail2Test {

    @isTest static void test_method_one() {

    Account a = new Account(name='testAcc');
    insert a;
    Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
    insert c;
    Profile p = [select id from profile where name='Customer Community Login User'];
    User u = new User(alias = 'standt', email='standarduser@testorg.com',
                      emailencodingkey='UTF-8', 
                      lastname='Testing',
                      languagelocalekey='en_US',
                      localesidkey='en_US', 
                      profileid = p.Id,
                      timezonesidkey='America/Los_Angeles', 
                      username='standarduser@test.com', ContactId=c.Id);
    insert u;
    HP_ProfileSubCommunityMap__c psc = new HP_ProfileSubCommunityMap__c(Name='Standard', 
                                                                        Profile__c='Customer Community User', 
                                                                        Sub_Community__c='Standard');
    insert psc;
    HP_Custom_Link_Left_Rail_2__c cl = new HP_Custom_Link_Left_Rail_2__c(Name='Standard', Link_Text__c='Test', 
                                                Link_URL__c='http://www.google.com', Sub_Community__c='Standard');
    insert cl;
    System.runAs(u) 
        {
        PageReference pageRef = Page.HP_CustomLinkLeftRail2;
        Test.setCurrentPage(pageRef);
        CustomLinkControllerLeftRail2 controller = new CustomLinkControllerLeftRail2 ();
        controller.getHP_CustomLinkLeftRail2Obj();
        controller.getHP_CustomLinkLeftRail2(psc.Sub_Community__c);
    }
  }
    
}