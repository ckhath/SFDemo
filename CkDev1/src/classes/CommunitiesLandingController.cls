/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        //return Network.communitiesLanding();
        if(UserInfo.getUserType() == 'Guest')
        {
            ProfileDomainName__c Domain_Name = UtilityGeneral.getProfileDomainName();
            String page_url = '/' + Domain_Name.DomainName__c + '/login';
            return UtilityGeneral.redirect(page_Url, true);
        }
        else
        {
            ProfileDomainName__c Domain_Name = UtilityGeneral.getProfileDomainName();
            String page_url = '/' + Domain_Name.DomainName__c + '/HP_CommunityOptIn';
            return UtilityGeneral.redirect(page_Url, true);
        }

    }
    
    public CommunitiesLandingController() {}
}