@isTest
private class VolunteerOpportunityClassTest {
	
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
        HP_Event_Registration__c hpr = new HP_Event_Registration__c(Name='Event Register', 
        	Image_Url__c='http://www.biblecenterchurch.com/wp-content/uploads/2013/04/Register-for-an-Event1.jpg',
        	Sub_Community__c='Standard');

        System.runAs(u) 
        {
			PageReference pageRef = Page.VolunteerOpportunityPage;
	        Test.setCurrentPage(pageRef);
	        VolunteerOpportunityClass controller = new VolunteerOpportunityClass();
	    }
	}
	
}