/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {
    public String currentPageName{get; set; } 
    public String page_url { get; set; }
    public static final String BACK_SLASH ='/';
    public boolean mobile{ get; set; }
    global CommunitiesLoginController () {
       //currentPageName = 'CommunitiesLogin';
        //currentPageName = UtilityGeneral.getPageNameFromUrl(ApexPages.CurrentPage().getUrl());
        page_url = '';
    }
    
     //Get mobile parameter passed form the javascript
   public void populateMobile()
    {
        list<Url_Pattern__c> lstUrlPatterns = Url_Pattern__c.getall().values();
        system.debug('lstUrlPatterns***' + lstUrlPatterns);
        if(lstUrlPatterns != null){
            Pattern MyPattern = Pattern.compile(lstUrlPatterns.get(0).Url_User_Agent__c);
	        Matcher MyMatcher = MyPattern.matcher(ApexPages.currentPage().getHeaders().get('USER-AGENT'));
	        system.debug('***Matches? ' +MyMatcher.find());
	        if(MyMatcher.find()){
	            mobile = true;
	            //return new PageReference('/alumni/one/one.app'); 
	        }
	        else{
	            //return new PageReference('/alumni/home/home.jsp');
	            mobile = false;
	        }
    	}
        
       /*if(!String.isBlank(Apexpages.currentPage().getParameters().get('p1')))
        mobile = boolean.valueOf(Apexpages.currentPage().getParameters().get('p1'));*/
    }//End Method
    
    
    // Code we will invoke on page load.
   global PageReference forwardToAuthPage() {
        //String startUrl = System.currentPageReference().getParameters().get('startURL');
        //String displayType = System.currentPageReference().getParameters().get('display');
        //return Network.forwardToAuthPage(startUrl, displayType);
        map<integer, Sobject> mapPageDetails = new map<integer, Sobject>();
        //map<integer, String> mapPageDetails = new map<integer, String>();
        integer pageNumber = 0 ;
        
        ProfileDomainName__c Domain_Name = UtilityGeneral.getProfileDomainName();
        
        if(UserInfo.getUserType() == 'Guest')
        {
            String startUrl = System.currentPageReference().getParameters().get('startURL');
            String displayType = System.currentPageReference().getParameters().get('display');
            return Network.forwardToAuthPage(startUrl, displayType);
        }//End If
        else
        {
            
            currentPageName = UtilityGeneral.getPageNameFromUrl(ApexPages.CurrentPage().getUrl());
            
            Sobject sobj;
            //ProfileDomainName__c Domain_Name = UtilityGeneral.getProfileDomainName();
            mapPageDetails = UtilityGeneral.getRedirectionPageInfo();
            if(mapPageDetails != null){
                sobj = UtilityGeneral.getNextPageDetails(mapPageDetails, currentPageName);
            }
            
            if(sobj != null){
	            if(mobile){
	                system.debug('**mobileUrl__c' + sobj.get('MobileUrl__c'));
	                page_url = String.valueOf(sobj.get('MobileUrl__c'));
	                return (new Pagereference(page_url));
	            }
	            else{
	                if(sobj.get('PageName__c') != null){
	                   page_url =  BACK_SLASH + Domain_Name.DomainName__c + BACK_SLASH + String.valueOf(sobj.get('PageName__c'));
	                }
                    return (new Pagereference(page_url));
	            }
            }
	            system.debug('***page_url' + page_url);
	            return UtilityGeneral.redirect(page_url, true);
            
    }//End method
    
}
    /*global PageReference forwardToCustomAuthPage() {
        return new PageReference('/HP_CommunityOptIn');
    }*/
}//End class