@isTest
private class CommunityContentHelperTest {
	 
	 static testMethod void TestUserUtils() {
		Community_Web_Content__c cwc = new Community_Web_Content__c(name='ContactSourceObjectFields', Content__c='Test');
		insert cwc;
		CommunityContentHelper.getContent('Community_Web_Content__c.ContactSourceObjectFields');
	}
}