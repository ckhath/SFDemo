@isTest
public with sharing class CustomLinkControllerLeftRail3Test {

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
    HP_Custom_Link_Left_Rail_3__c cl = new HP_Custom_Link_Left_Rail_3__c(Name='Standard', Link_Text__c='Test', 
                                                Link_URL__c='http://www.google.com', Sub_Community__c='Standard');
    insert cl;
    System.runAs(u) 
        {
        PageReference pageRef = Page.HP_CustomLinkLeftRail3;
        Test.setCurrentPage(pageRef);
        CustomLinkControllerLeftRail3  controller = new CustomLinkControllerLeftRail3();
        controller .getHP_CustomLinkLeftRail3Obj();
        controller.getHP_CustomLinkLeftRail3(psc.Sub_Community__c);
    }
  }



    
}