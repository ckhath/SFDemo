@isTest
private class CommunityCSSHeadersTest {
	
	@isTest static void test_method_one() 
	{
		Account a = new Account(name='testAcc');
    	insert a;
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id, Community_Experience_selected__c='Tufts University');
        insert c;
		Profile p = [select id,name from profile where name='Customer Community Login User'];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser@test.com', ContactId=c.Id);
        insert u;

        System.runAs(u) 
        {
			CommunityCSSHeaders cch = new CommunityCSSHeaders();
			cch.getHeadersType();
		}
	}
	
	@isTest static void test_method_two() 
	{
		Account a = new Account(name='testAcc');
    	insert a;
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id, Community_Experience_selected__c='The Fletcher School of Law and Diplomacy');
        insert c;
		Profile p = [select id,name from profile where name='Customer Community Login User'];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser@test.com', ContactId=c.Id);
        insert u;

        System.runAs(u) 
        {
			CommunityCSSHeaders cch = new CommunityCSSHeaders();
			cch.getHeadersType();
		}
	}
	
}