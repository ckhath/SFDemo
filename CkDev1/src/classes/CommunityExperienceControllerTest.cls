@isTest(SeeAllData=true)
public class CommunityExperienceControllerTest {
	//Get Contact Id for the current User
	
	public static testmethod void checkCommunityExperienceForInsert(){
	 	CommunityExperienceControllerTest.testCommunityExperience('true');
	}
	
	public static testmethod void checkCommunityExperienceForUpdate(){
	 	CommunityExperienceControllerTest.testCommunityExperience('false');
	}
	
	public static void testCommunityExperience(String pUrlParam){
		 User userComm = [select id, ContactId from User where ContactID != null limit 1];
      	 System.runAs(userComm) {
          //Setting Url Params
      	  Contact userContact = new Contact();
      	  userContact.id = userComm.ContactId;
      	  userContact.Community_Experience_Options__c = 'Athletics;Columbia,University';
      	  userContact.Community_Experience_selected__c = 'Columbia';
      	  update userContact;
      	 //ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/21.0');
      	 PageReference commExpPage = new PageReference('Page.CommunityExperiencePage');
      	 commExpPage.getHeaders().put('USER-AGENT', 'Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/21.0');
      	 Test.setCurrentPageReference(commExpPage);
      	  //Test.setCurrentPageReference(new PageReference('Page.CommunityExperiencePage'));
		  System.currentPageReference().getParameters().put('isCommExperience', pUrlParam);
		  CommunityExperienceController commExp = new CommunityExperienceController();
		  commExp.communityExperienceSelected = 'Columbia';
		  commExp.COMMUNITY_HOME_URL = '/community/home/home.jsp';
		  commExp.pageUrl = 'profile_personal_v1';
			//commExp.urlParam='true';
		  commExp.init();
		  commExp.updateCommunityExperience();
		  boolean mobile = true;
		  boolean isUpdatable = false;
		  commExp.setRedirectToHomePage(isUpdatable);
		  commExp.setRedirectTopage(isUpdatable);
		  commExp.redirectButtonLogic();
		  //commExp.CheckMobileOrDesktop();
		//  boolean mobile = true;
		  commExp.populateMobile();
		  if(pUrlParam == 'true'){
		  	system.assertequals('Columbia',commExp.currentUserContact.Community_Experience_selected__c);
		  }
		  if(pUrlParam == 'false'){
		  	system.assertequals('Columbia', commExp.currentUserContact.Community_Experience_selected__c);
		  }
			
		}
		}
}