/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: 17-Apr-2015
    Description: Controller class used to pull data from contact object
        and display as list on page
-----------------------------------------------------------------------*/

public with sharing class CommunityExperienceController {
    public Contact currentUserContact { get; set; }
    public String urlParam { get; set; }
    public list<SelectOption> communityExperienceOptions{ get; set; }
    public String communityExperienceSelected { get; set; }
    public String homeUrl { get; set; }
    public String homeUrlMobile { get; set; }
    public String COMMUNITY_HOME_URL = '/connect/home/home.jsp';
    public String COMMUNITY_HOME_MOBILE_URL = '/connect/one/one.app';
    public boolean isUpdatable{ get; set; }
    public Pagereference loadPagereference{ get; set; }
    public String currentPageName{ get; set; }
    public boolean mobile{ get; set; }
    public String pageUrl{ get; set; }
    public String profileDomain{ get; set; }
    public ProfileDomainName__c profileDomainCustomSetting {get; set;}
    public static final String BACK_SLASH = '/';
    
    //Constructor
    public CommunityExperienceController(){
        system.debug('$$$$$ constructor');
         profileDomainCustomSetting = UtilityGeneral.getProfileDomainName();
         profileDomain = profileDomainCustomSetting.DomainName__c;
         system.debug('$$$$$ before populate mobile::');
         mobile = true;
       //  CheckMobileOrDesktop();
         
         system.debug('$$$$$ after populate mobile::');
    }//End Constructor
    
    //Method to initialize the variables
    public Pagereference init(){
        //variable declaration
        communityExperienceOptions = new list<SelectOption>();
        String userId;
        String contactId;
        //currentPageName = 'CommunityExperiencePage';
       // currentPageName = UtilityGeneral.getPageNameFromUrl(ApexPages.CurrentPage().getUrl());
        urlParam = getUrlParameters();
        userId = getUserId();
        contactId = getContactId(userId);
        currentUserContact = getContactInformation(contactId);
        communityExperienceOptions = preparePicklist(currentUserContact);
        communityExperienceSelected = currentUserContact.Community_Experience_selected__c;
        system.debug('$$$$ communityExperienceSelected'+communityExperienceSelected);
        if(communityExperienceOptions == null || communityExperienceOptions.isEmpty()){
            isUpdatable = false;
        }//End If
        else{
            isUpdatable = redirectOnPage();
        }//end Else
        isUpdatable = true;
        loadPagereference = setRedirectTopage(isUpdatable);
        return loadPagereference;
    }//End Method
    
    public String getUrlParameters(){
        return ApexPages.currentPage().getParameters().get('isCommExperience');
    }//end getUrlParameters
    
    //Method to check record update condition
    public boolean redirectOnPage(){
        Pagereference homePageRef;
        
        // Commented By: Siddharth Pandit on 18-Nov-2015 
        // Description : Commented because of change in functionallity (TUFTS-33)
        
        /*
        if((currentUserContact.Community_Experience_selected__c == null ||
             currentUserContact.Community_Experience_selected__c == '') || urlParam == 'true'){
             isUpdatable = true;
         }//End If
         else{
             isUpdatable = false;
         }//End else
         */
         
         isUpdatable = true;
         return isUpdatable;
    }//End Method
    
    //Get UserId of Current User
    public string getUserId(){
        return userinfo.getUserId();
    }//End Method
    
    //Get Contact Id for the current User
    public string getContactId(string pUserId){
        //string ContactId = NULL;
        list<User> ContactIdList = new list<User>();
        ContactIdList = [SELECT ContactId FROM User WHERE id =:pUserId];
        if(ContactIdList.isEmpty()){
            return NULL;
        }//End If
        return ContactIdList.get(0).ContactId;
    }//End Method
    
    //Get Contact Information
    public Contact getContactInformation(string pContactId){
        list<Contact> ContactList = new list<Contact>();
        if(pContactId != NULL){
            ContactList = Database.query('SELECT ID,Community_Experience_selected__c ,Community_Experience_Options__c FROM Contact where id = :pContactId');
            system.debug('$$$$ ContactList'+ContactList);
        }//End If
        if(ContactList.isEmpty()){
            return NULL;
        }//End If
        return ContactList.get(0);
    }//End Method
    
    //Method to populate picklist
    public list<SelectOption> preparePicklist(Contact pContactDetails){
        
        list<SelectOption> lstCommExperiene = new list<SelectOption>();
        list<String> lstCommunityExperience;
        String strCommunityExperience;
        
        if(pContactDetails != NULL){
            strCommunityExperience =  pContactDetails.Community_Experience_Options__c;
            if(strCommunityExperience != null && strCommunityExperience !=''){
                lstCommunityExperience = strCommunityExperience.split(';');
                for(String objCommunityExperience : lstCommunityExperience){
                    lstCommExperiene.add(new SelectOption(objCommunityExperience,objCommunityExperience));
                }//End For
            }//End If
        }//End If
        return lstCommExperiene;
    }//End Method
    
    //method to update Contact record and redirect to home page
    public Pagereference updateCommunityExperience() {
        Pagereference redirectPage;
        //isUpdatable = redirectOnPage();
        isUpdatable = true;
        if(isUpdatable) {
            currentUserContact.Community_Experience_selected__c = communityExperienceSelected;
            try {
                update currentUserContact;
                redirectPage = setRedirectToHomePage(isUpdatable);
            } catch(Exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'System.DmlException: Update failed.');
                ApexPages.addMessage(myMsg);
                return null;
           }
        } else {
            //homeUrl = COMMUNITY_HOME_URL;
            //homeUrlMobile = COMMUNITY_HOME_MOBILE_URL;
        }//End Else
        return redirectPage;
        //return redirectButtonLogic();
    }//End Method
    
    //method to redirect to home page after click on 'Go' button 
    public Pagereference setRedirectToHomePage(boolean pUpdatable){
        Pagereference homePage;
        if(pUpdatable){
            homePage = new Pagereference(COMMUNITY_HOME_URL);
        }//End If
        return homePage;
    }//End setRedirectToHomePage    
    
    //method to redirect to home page
    public Pagereference setRedirectTopage(boolean pUpdatable){
        Pagereference homePageReference;
        if(!pUpdatable){
            homePageReference = new Pagereference(COMMUNITY_HOME_URL);
        }//End If
        return homePageReference;
    }//End setRedirectTopage

   /*public Sobject getNextPageDetails(map<integer, Sobject> pMapPageInfo, String pCurrentPageName){
       list<Sobject> lstCustomFlowSetting = pMapPageInfo.values();
       Sobject objSetting;
              
       for(Sobject objCustomSetting : lstCustomFlowSetting){
            if(String.valueOf(objCustomSetting.get('PageName__c')).equalsIgnoreCase(pCurrentPageName)){
                if(pMapPageInfo.containskey(integer.valueOf(objCustomSetting.get('PageNumber__c')) + 1)){
                    return pMapPageInfo.get(integer.valueOf(objCustomSetting.get('PageNumber__c')) + 1);
                }
            }
       }
       return objSetting;
   }*/
   
   //Method to redirect to page based on custom setting values.
   public Pagereference redirectButtonLogic(){
       system.debug('***CurrentUrl***' + ApexPages.CurrentPage().getUrl());
          map<integer, Sobject> mapPageDetails = new map<integer, Sobject>();
          Sobject sobj;
          ProfileDomainName__c Domain_Name = UtilityGeneral.getProfileDomainName();
           mapPageDetails = UtilityGeneral.getRedirectionPageInfo();
           if(mapPageDetails != null){
            sobj = UtilityGeneral.getNextPageDetails(mapPageDetails, currentPageName);
           }
            if(sobj != null){
            if(mobile){
                system.debug('$$$$ inside mobile');
                pageUrl = String.valueOf(sobj.get('MobileUrl__c'));
                return (new Pagereference(pageUrl));
            }
            else{
                if(sobj.get('PageName__c') != null){
                   pageUrl =  BACK_SLASH + Domain_Name.DomainName__c + BACK_SLASH + String.valueOf(sobj.get('PageName__c'));
                }
                 return (new Pagereference(pageUrl));
            }
        }
        system.debug('PageUrl' + pageUrl);
        return UtilityGeneral.redirect(pageUrl, true);
    }//End Method

    public Pagereference CheckMobileOrDesktop()
    {
        system.debug('inside method..!!');
        system.debug('### mobilee value'+mobile);
        Sobject sobj;
          ProfileDomainName__c Domain_Name = UtilityGeneral.getProfileDomainName();
                if(mobile){
                system.debug('$$$$ inside mobile');
                pageUrl = String.valueOf(sobj.get('MobileUrl__c'));
                system.debug('$$pageUrl'+pageUrl);
                return (new Pagereference(pageUrl));
            }
            else{
                if(sobj.get('PageName__c') != null){
                   pageUrl =  BACK_SLASH + Domain_Name.DomainName__c + BACK_SLASH + String.valueOf(sobj.get('PageName__c'));
                }
                return (new Pagereference(pageUrl));
            }
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
                system.debug('***mobile'+mobile);
                mobile = true;
                //return new PageReference('/alumni/one/one.app'); 
            }
            else{
                //return new PageReference('/alumni/home/home.jsp');
                mobile = false;
            }
        }
     /*  if(!String.isBlank(Apexpages.currentPage().getParameters().get('p1')))
        mobile = boolean.valueOf(Apexpages.currentPage().getParameters().get('p1'));
        system.debug('%%% mobile '+mobile);*/
    }//End Method
}//End Class