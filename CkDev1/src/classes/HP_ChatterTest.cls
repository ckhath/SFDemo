@isTest
private class HP_ChatterTest {
	
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
        CollaborationGroup cg = new CollaborationGroup(Name='My Group', CollaborationType='Public');
		insert cg;
        HP_ChatterFeed__c cf = new HP_ChatterFeed__c(Name='StandardMyGroup', GroupId__c=cg.Id, Sub_Community__c='Standard');
        insert cf;

        System.runAs(u) 
        {
			PageReference pageRef = Page.HP_Chatter;
	        Test.setCurrentPage(pageRef);
	        HP_Chatter controller = new HP_Chatter();
	    }
	}
	
}