@isTest
private class MobileHomeControllerTest {
    public static integer totalRecords = 200;
    @isTest static void test_method_one() {
    	
        Account a = new Account(name='testAcc');
        insert a;
        
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
/*
        Profile p = [select id from profile where name='Customer Community Login User'];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser@test.com', ContactId=c.Id);
        insert u;
  */      
        list<Mobile_HP__c> custMobileList = new list<Mobile_HP__c>();
        for(integer i = 0 ; i < totalRecords ; i++){
       		custMobileList.add(new Mobile_HP__c(Name='MobileComponent ' + i , Field_Title__c='Find people ' + i , 
                                                   Image_URL__c='http://www.ivowed.com/images/hm3.jpg'));
        }
        insert custMobileList;

    //    System.runAs(u) 
        {
            PageReference pageRef = Page.HomePage_Mobile;
            Test.setCurrentPage(pageRef);
            MobileHomeController  controller = new MobileHomeController ();
            system.assertequals(totalRecords, controller.HP_MobileComponentobjListCount);
        }
    }
    
}