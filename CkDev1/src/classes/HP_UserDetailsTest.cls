@isTest
private class HP_UserDetailsTest {
	
	@isTest static void test_method_one() {
		Account a = new Account(name='testAcc');
    	insert a;
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
		Profile p = [select id from profile where name='Customer Community Login User'];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser@test.com', ContactId=c.Id);
        insert u;
        HP_ProfileSubCommunityMap__c psc = new HP_ProfileSubCommunityMap__c(Name='Standard', Profile__c='Customer Community Login User', 
        	Sub_Community__c='Standard');
        insert psc;
        HP_UserDetails__c ud = new HP_UserDetails__c(Name='Standard', Field_API_Name__c='name', Sub_Community__c='Standard');
        insert ud;

        System.runAs(u) 
        {
			PageReference pageRef = Page.HP_UserDetails;
	        Test.setCurrentPage(pageRef);
	        HP_UserDetails controller = new HP_UserDetails();
	    }
	}
}