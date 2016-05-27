@isTest(SeeAllData=true)
private class CommunityFooterControllerTest {
	
	@isTest static void test_method_one() 
	{
	 	Account a = new Account(name='testAcc');
        insert a;
		Contact c = new Contact(lastName='TestContact', AccountId=a.Id, Community_Experience_selected__c='Tufts University');
        insert c;
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser@test.com', ContactId=c.Id);
        insert u;

        System.runAs(u) 
        {
        	CommunityFooterController controller = new CommunityFooterController();            
        	PageReference pageRef = Page.CommunityFooter;
        }
	}
	
	@isTest static void test_method_two() 
	{
		Account a = new Account(name='testAcc');
        insert a;
		Contact c = new Contact(lastName='TestContact', AccountId=a.Id, Community_Experience_selected__c='The Fletcher School of Law and Diplomacy');
        insert c;
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser@test.com', ContactId=c.Id);
        insert u;

        System.runAs(u) 
        {
        	CommunityFooterController controller = new CommunityFooterController();            
        	PageReference pageRef = Page.CommunityFooter;
        }
	}
	
}