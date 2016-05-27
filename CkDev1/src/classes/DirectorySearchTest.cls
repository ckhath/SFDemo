@istest
public class DirectorySearchTest {
	 @isTest static void test_method_one() {
	 	Account a = new Account(name='testAcc');
        insert a;
      
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
        
        Profile p = [select id from profile where name='Customer Community Login User'];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
          				  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          				  localesidkey='en_US', profileid = p.Id,
          				  timezonesidkey='America/Los_Angeles', username='standarduser@test.com',
          				  ContactId=c.Id);
        insert u;
        
        HP_ProfileSubCommunityType__c  subCommType = new HP_ProfileSubCommunityType__c(name='testCommunity', Sub_Community_Type__c='contact', Field_API_Name__c='firstname');
        insert subCommType;
        
        Directory_Search_Fields__c fielCustomSetting = new Directory_Search_Fields__c(name='firstname', Field_Label__c = 'name',Field_Name__c='rel.contact.firstname',Field_Order__c='2',Section_Label__c='Personal/Location',Section_Order__c='1',Picklist_Values__c ='city1; city2');
        insert fielCustomSetting;
        
        DirectorySearch_Pagination_Fields__c pageFields = new DirectorySearch_Pagination_Fields__c(name='pageFields', Per_Page_Pagesize__c = 1, Per_Page_Records__c= 1, sortingParameters__c ='First Name:contact.firstname,Last Name:contact.lastname');
        insert pageFields;
        
        ProfileDomainName__c pfDomain = new ProfileDomainName__c(name='CommunityDomain',DomainName__c='alumni');
        insert pfDomain;
        
        system.runAs(u){
        	
        	PageReference pageRef = Page.DirectorySearch;
            Test.setCurrentPage(pageRef);
            
            DirectorySearch dirController = new DirectorySearch();
            system.assertEquals(true, dirController.inputFieldsHTML.length() > 0);
        }
	 }
}