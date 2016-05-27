@isTest
public class DynamicRelationshipQueriesControllerTest {
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

        Community_Web_Content__c cwc = new Community_Web_Content__c(name='ContactSourceObjectFields', Content__c='fname=FirstName, Nickname__c; lname=LastName; email=Emai;, phone=Phone; comtype=Community_Type__c; gradyear=GraduationYear__c; major=Major__c; city=MailingCity; state=MailingState; zip=MailingPostalCode;');
        insert cwc;

        DynamicQueryFields__c queryField1 = new DynamicQueryFields__c(name= 'Contact', SourceObjectName__c = 'Contact',
					FilterId__c = 'ContactId',Static_Where__c = 'ContactId!=null',
				  ListView__c = 'FirstName, LastName, GraduationYear__c, Major__c, Phone, Community_Type__c',
					Privacy_Fields__c = '',
				  Social_Icon_Map__c ='',
				  ForeignKey__c = 'id',
				  SourceObjectFields__c = 'Community_Web_Content__c.ContactSourceObjectFields');
        insert queryField1;
        DynamicQueryFields__c queryField2 = new DynamicQueryFields__c(name= 'User', SourceObjectName__c = 'User',
          FilterId__c = 'ContactId',Static_Where__c = 'ContactId!=null',
          ListView__c = 'Phone',
          Privacy_Fields__c = '',
          Social_Icon_Map__c ='',
          ForeignKey__c = '',
          SourceObjectFields__c = '');
        insert queryField2;

        ForeignKeys__c fk1 = new ForeignKeys__c(name='id', ObjectName__c='user');
        insert fk1;
        ForeignKeys__c fk2 = new ForeignKeys__c(name='Contact__c', ObjectName__c='Contact');
        insert fk2;
        
        System.runAs(u){
        	
        	PageReference pageRef = Page.DynamicQueryResultsPageJson;
            Test.setCurrentPage(pageRef);
            System.currentPageReference().getParameters().put('name', 'user');
            System.currentPageReference().getParameters().put('rel.Contact.lname', 'TestContact');
            System.currentPageReference().getParameters().put('pagesize', '10');
            System.currentPageReference().getParameters().put('pagenumber', '1');
            DynamicRelationshipQueriesController dynamicController = new DynamicRelationshipQueriesController();
        }
	 }
	 
}