@isTest
private class HP_HeaderTest {
	
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
        HP_Header__c h = new HP_Header__c(Name='Standard', Image_URL__c='', Sub_Community__c='Standard');
        insert h;

        System.runAs(u) 
        {
			PageReference pageRef = Page.HP_Header;
	        Test.setCurrentPage(pageRef);
	        HP_Header controller = new HP_Header();
	    }
	}
	
}