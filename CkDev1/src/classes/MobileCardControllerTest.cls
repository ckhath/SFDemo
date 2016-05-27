@istest
public with sharing class MobileCardControllerTest {
    public static testmethod void testMobileController(){
     //   TestDataFactoryClass.AddDomainName();
        addCustomSetting();
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
                          
         MobileCardController mobCardController = new MobileCardController(new ApexPages.StandardController(u)); 
         system.assertEquals(true, mobCardController.lstMobileCardComponent.size() > 0);
    }//End testmethod

    public static void addCustomSetting()
    {
        Mobile_Card__c settingMobileCard = new Mobile_Card__c();
        settingMobileCard.Name = 'Academic';
        settingMobileCard.Link__c = 'https://www.google.co.in/';
        settingMobileCard.Title__c = 'Whatever';
        settingMobileCard.Label__c = 'View';
        insert settingMobileCard;
    }
    
}//End class