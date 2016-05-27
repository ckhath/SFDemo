@isTest
private class CustomLinkAllCommunitiesControllerTest {
	
	@isTest static void test_method_one() {
        CustomLinkAllCommunitiesController controller = new CustomLinkAllCommunitiesController();
        PageReference pageRef = Page.HP_CustomLinkAllCommunities;
        Test.setCurrentPage(pageRef);
        
	}
	
}