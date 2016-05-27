public class HP_CommunityOptIn 
{
    public Community_Web_Content__c communityWebContent{ get; set; }
    public HP_CommunityOptIn__c HP_CommunityOptInObj { get; set; }
    public User currentUser { get; set; }
    public boolean mobile { get; set; }
    public String body { get; set; }
    public ProfileDomainName__c profileDomainCustomSetting {get; set;}
    public String profileDomain{ get; set; }
    public String currentPageName{ get; set; }
    public String pageUrl{ get; set; }
    public final static String BACK_SLASH = '/';
    public final static String WEB_CONTENT = 'Community_Web_Content__c.';
    public final static String MOBILE_URL = 'MobileUrl__c';
    public boolean isAgreeLink {get; set;}

    //Constructor
    public HP_CommunityOptIn() 
    {
        HP_CommunityOptInObj = new HP_CommunityOptIn__c();

        isAgreeLink = true;
        currentUser = queryUser(userinfo.getUserId());
        if (currentUser.Community_Terms_Opt_In__c == true) {
            isAgreeLink = false;
        }
        
        currentPageName = UtilityGeneral.getPageNameFromUrl(ApexPages.CurrentPage().getUrl());

        //String currentUserProfileName = queryCurrentUserProfileName();
        //String subCommunity = getSubCommunityByProfileName(currentUserProfileName);
        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_CommunityOptInObj = getCommunityOptInObj(subCommunity);
        body = HP_CommunityOptInObj.Body__c;
        if(HP_CommunityOptInObj.Body__c!=null && 
           HP_CommunityOptInObj.Body__c.startsWith(WEB_CONTENT))
        {
            body = CommunityContentHelper.getContent(HP_CommunityOptInObj.Body__c);
        }//End If
        
         profileDomainCustomSetting = UtilityGeneral.getProfileDomainName();
         profileDomain = profileDomainCustomSetting.DomainName__c;
    }//End Constructor

    //Get Community Option Object
    public HP_CommunityOptIn__c getCommunityOptInObj(String subCommunity)
    {
        HP_CommunityOptIn__c communityOptInObj = new HP_CommunityOptIn__c();
        list<HP_CommunityOptIn__c> communityOptInObjList = [select Body__c, Logo_URL__c, Title__c,
            Sub_Community__c
            from HP_CommunityOptIn__c where Sub_Community__c=:subCommunity];
        if(communityOptInObjList.size()>0)
        {
            communityOptInObj = communityOptInObjList[0];
        }
        return communityOptInObj;
    }//End Method
    
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
      /* if(!String.isBlank(Apexpages.currentPage().getParameters().get('p1')))
        mobile = boolean.valueOf(Apexpages.currentPage().getParameters().get('p1'));
         system.debug('mob: ' + mobile );*/
        
    }//End Method
    
    //Get next page details with redirection logic.
    public Pagereference agreeBtnAction(){
        system.debug('\n\n\n ***** in agreeBtnAction **** \n\n\n');
        currentUser.Community_Terms_Opt_In__c = true;
        update currentUser;
        
        map<integer, Sobject> mapPageDetails = new map<integer, Sobject>();
        Sobject sobj;
        ProfileDomainName__c Domain_Name = UtilityGeneral.getProfileDomainName();
        mapPageDetails = UtilityGeneral.getRedirectionPageInfo();
        if(mapPageDetails != null){
            sobj = UtilityGeneral.getNextPageDetails(mapPageDetails, currentPageName);
        }
        if(sobj != null){
            if(mobile)
            {
                pageUrl = String.valueOf(sobj.get(MOBILE_URL));
                return (new Pagereference(pageUrl));
            }
            else
            {
                if(sobj.get('PageName__c') != null)
                {
                   pageUrl =  BACK_SLASH + Domain_Name.DomainName__c + BACK_SLASH + String.valueOf(sobj.get('PageName__c'));
                }
                return (new Pagereference(pageUrl));
            }
        }
        else 
        {
            if(mobile)
            {
                //pageurl = '/one/one.app';
                pageurl = '/home/home.jsp';
            }
            else
            {
                pageurl = '/home/home.jsp';
            }
        }
        system.debug('\n\n\n pageUrl: '+pageUrl+' \n\n\n');
        return UtilityGeneral.redirect(pageUrl, true);
    }
    
   /* //Get Page details from custom setting.
     public Sobject getNextPageDetails(map<integer, Sobject> pMapPageInfo, String pCurrentPageName){
       list<Sobject> lstCustomFlowSetting = pMapPageInfo.values();
       Sobject objSetting;
              
       for(Sobject objCustomSetting : lstCustomFlowSetting){
            if(String.valueOf(objCustomSetting.get(PAGE_NAME)).equalsIgnoreCase(pCurrentPageName)){
                if(pMapPageInfo.containskey(integer.valueOf(objCustomSetting.get(PAGE_NUMBER)) + 1)){
                    return pMapPageInfo.get(integer.valueOf(objCustomSetting.get(PAGE_NUMBER)) + 1);
                }
            }
       }
       return objSetting;
   }*/

    //Query current user details.
    public User queryUser(String userId)
    {
        return [select Id, Community_Terms_Opt_In__c from User where Id=:userId];
    }//End Method

}//End Class