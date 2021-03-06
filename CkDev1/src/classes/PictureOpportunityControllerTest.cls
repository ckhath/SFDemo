@isTest
private class PictureOpportunityControllerTest {
	
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

        HP_Picture_Volunteer_Opportunty__c pvo = new HP_Picture_Volunteer_Opportunty__c(Name='Test', Image_Link__c='Test',
        	Image_Url__c='google.com', Sub_Community__c='Standard');

        System.runAs(u) 
        {
			PageReference pageRef = Page.hp_Picture_Opportunity;
	        Test.setCurrentPage(pageRef);
	        PictureOpportunityController controller = new PictureOpportunityController();
	    }
	}
	
	
}