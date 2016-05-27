/**
 * An apex page controller that exposes the site login functionality
 */
@IsTest global with sharing class CommunitiesLoginControllerTest {
    @IsTest(SeeAllData=true) 
    global static void testCommunitiesLoginController () {
    	ProfileDomainName__c objDomain = new ProfileDomainName__c();
        objDomain.DomainName__c = '/connect';
        objDomain.name='CommunityDomain';
        insert objDomain;

        ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');
        CommunitiesLoginController controller = new CommunitiesLoginController();
        controller.populateMobile();
     	controller.forwardToAuthPage();
     	//System.assertEquals(null, controller.forwardToAuthPage());       
    }    
}