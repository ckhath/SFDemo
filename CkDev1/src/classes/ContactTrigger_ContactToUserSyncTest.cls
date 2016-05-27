@istest(SeeAllData=true)
public with sharing class ContactTrigger_ContactToUserSyncTest {
  public static testmethod void testUpdateContact(){
    //Query Conatct
    list<UserContactMapping__c> listUser_ContactMapping = new list<UserContactMapping__c>();
    listUser_ContactMapping = UserContactMapping__c.getAll().values();
    
            Account a = new Account(name='testAcc');
        insert a;
      
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
        
        Profile p = [select id from profile where name='Customer Community Login User'];
        User userComm = new User(alias = 'standt', email='standarduser@testorg.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id,
                                timezonesidkey='America/Los_Angeles', username='standarduser@test.com',
                                ContactId=c.Id);
        insert userComm;

            
         System.runAs(userComm) {
            Contact userContact = new Contact();
            userContact.id = userComm.ContactId;
            for(UserContactMapping__c objMappingUser : listUser_ContactMapping){
              system.debug('***objMappingUser.Contact_field__c' + objMappingUser.Contact_field__c);
              //userContact.put(objMappingUser.Contact_field__c,'12345');
            }
            
            /*userContact.Fax = '123';
            userContact.MobilePhone = '1234567890';
            userContact.Title = 'TestTitle';
            update userContact;*/
         }//End
  }
}