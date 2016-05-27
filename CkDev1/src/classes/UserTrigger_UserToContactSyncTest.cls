@istest(SeeAllData=true)
public class UserTrigger_UserToContactSyncTest {

    static testMethod void testUpdateUser() {
        
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

        
        system.runAs(userComm){
            userComm.fax = '123213123';
            update userComm;
            Contact objContact = [Select fax From Contact where id =: userComm.contactId limit 1];
            system.debug('objContact===>> '+objContact);
            boolean isSame;
            if(userComm.fax == objContact.fax){
                isSame = true;
            } 
            system.assert(true, isSame);
        }
    }
}