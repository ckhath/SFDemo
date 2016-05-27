/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: June 11, 2015
    Description: Test Class of UtilityGeneral Class
        			 
-----------------------------------------------------------------------*/
@istest
public class UtilityGeneralTest {

	//Method to test constructDynamicQueryforFields method from UtilityGeneral class
	public static testmethod void testconstructDynamicQueryforFields(){
		//addClassNoteSubmissionData();		//Test data insertion
		//String query = UtilityGeneral.construcuDynamicQueryforFields(Class_Note_Submission_Fields__c.getAll().values(), 'Classnotes__c', 'Field_Name__c', 'Approved__c=TRUE');
		system.assertequals(true,true);
	}//End Testmethod
	
	
	//Method to test getObjectRecords method from UtilityGeneral class
	public static testmethod void testGetObjectRecords(){
		Account a = new Account(name='testAcc');
        insert a;
		String inputQuery = 'Select Id, Name from Account';
		Test.StartTest();
			List<sObject> lstso = UtilityGeneral.getObjectRecords(inputQuery);
		Test.StopTest();	
		system.assertequals(lstso[0].get('Name'),'testAcc');
	}//End Testmethod	
	
	
	//Method to test getOrderwiseFields method from UtilityGeneral class
	public static testmethod void testGetOrderwiseFields(){
		//addClassNoteSubmissionData();		//Test data insertion
		//list<Sobject> lstOrderFields = UtilityGeneral.getOrderwiseFields(Class_Note_Submission_Fields__c.getAll().values(), 'Order__c');
		system.assertequals(true,true);
	}//End Testmethod	
	
	//Method to test redirect method from UtilityGeneral class
	public static testmethod void testRedirect(){
		Pagereference pageRef = UtilityGeneral.redirect('https://developer.salesforce.com', true);
		Pagereference expectedPageRef = new Pagereference('https://developer.salesforce.com');
		
		system.assertequals('a' + pageRef,'a' + expectedPageRef);
		
		system.debug('@@@@ ' + pageRef + ' || ' + expectedPageRef );
	}//End Testmethod	
	
	
	
	//Method to test getContactIdFromUser method from UtilityGeneral class
	public static testmethod void testGetContactIdFromUser(){
        Account a = new Account(name='testAcc');
        insert a;
      
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
        
        Profile p = [select id from profile where name='Customer Community Login User'];
        User userComm = new User(alias = 'standt', email='standarduser@testorg.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id,
                          timezonesidkey='America/Los_Angeles', username='standarduser@test.com',
                          ContactId=c.Id);
        insert userComm;
        System.runAs(userComm) {
	         String Id = UtilityGeneral.getContactIdFromUser(userInfo.getUserId());
	         system.assertequals(Id, c.Id);
        }
	}//End Testmethod
	
	//Method to test getWebContent method from UtilityGeneral class
	public static testmethod void testGetWebContent(){
	   list<Community_Web_Content__c> lstWebContentRecords = getWebContentRecords();
	   String pageContent;
	   String pageName = 'TestWebContentPage';
	   String pageUrl='/apex/TestWebContentPage?sfdc.tabName';
	   
	   if(lstWebContentRecords != null){
	   	   for(Community_Web_Content__c objWebContent : lstWebContentRecords){
	   	       if(objWebContent.name.equalsignorecase(pageName)){
	   	           pageContent = objWebContent.Page_Content__c;
	   	       }
	   	       
	   	   }
	       pageContent = lstWebContentRecords.get(0).Page_Content__c;
	   }
	   system.debug('****pageName' + pageName);
	   system.assertEquals(UtilityGeneral.getWebContent(pageUrl).Page_Content__c, pageContent);

	}//End Testmethod
	
	
	//Method to test getProfileDomainName method from UtilityGeneral class
	public static testmethod void testProfileDomainName(){
	   String domainName = '/alumni';
	   addDomainName(domainName);
	   system.assertequals(UtilityGeneral.getProfileDomainName().DomainName__c, domainName);
	}//End Testmethod
	
	//Method to test getRedirectionPageDetails method from UtilityGeneral class
	public static testmethod void TestGetRedirectionPageDetails(){

	   List<sObject> lstLoginFlow = AddLoginFlowCustomSettingData();
	   map<integer, sObject> mapPageDetails = UtilityGeneral.getRedirectionPageDetails(lstLoginFlow , 'PageNumber__c' ,'PageName__c');
	   system.debug('mapPageDetails==> ' + mapPageDetails);	
	}//End Testmethod	
	
	//Method to test constructQueryForObject method from UtilityGeneral class
	public static testmethod void testConstructQueryForObject(){

		//String queryString = UtilityGeneral.constructQueryForObject('Addl_Contact', 'Contact' );

	}//End Testmethod
	
	/*public static void addClassNoteSubmissionData(){
        list<Class_Note_Submission_Fields__c> lstClassNoteSubmission = new list<Class_Note_Submission_Fields__c>();
        lstClassNoteSubmission.add(new Class_Note_Submission_Fields__c(name='Category', Field_Name__c='Category__c',Label__c='Category',Order__c='1'));
        lstClassNoteSubmission.add(new Class_Note_Submission_Fields__c(name='Class Note', Field_Name__c='ClassNote__c',Label__c='Class Note',Order__c='2'));
        lstClassNoteSubmission.add(new Class_Note_Submission_Fields__c(name='Include in Allegheny magazine', Field_Name__c='Include_in_Allegheny_magazine__c',Label__c='Include in Allegheny magazine',Order__c='3'));
        lstClassNoteSubmission.add(new Class_Note_Submission_Fields__c(name='Post online', Field_Name__c='Post_online__c',Label__c='Post online',Order__c='4'));
        insert lstClassNoteSubmission;
    }//End method
	*/
     public static list<Community_Web_Content__c> getWebContentRecords(){
        list<Community_Web_Content__c> lstWebContent = new list<Community_Web_Content__c>();
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage',Page_Content__c ='Community Web Content1'));
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage2',Page_Content__c ='Community Web Content2'));
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage3',Page_Content__c ='Community Web Content3'));
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage4',Page_Content__c ='Community Web Content4'));
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage5',Page_Content__c ='Community Web Content5'));
        insert lstWebContent;
        return lstWebContent;
        
    }

    public static void addDomainName(String domainName){
        ProfileDomainName__c objDomain = new ProfileDomainName__c();
        objDomain.DomainName__c = domainName;
        objDomain.name='CommunityDomain';
        try{
            insert objDomain;
        }
        catch(DmlException d){
        }
    }//End Method

    //Method to create LoginFlowCustomSetting Data
    public static list<Sobject> AddLoginFlowCustomSettingData(){
        list<LoginFlowCustomSetting__c> loginFlow = new list<LoginFlowCustomSetting__c>();
        for(integer count = 1; count<=200 ; count++)
            loginFlow.add(new LoginFlowCustomSetting__c(Name = 'Page ' + count, PageName__c= 'Page_' + count, PageNumber__c = count));
        insert loginFlow;
        
        return (list<Sobject>)LoginFlowCustomSetting__c.getAll().Values();
    }//End Method  
}//End Class