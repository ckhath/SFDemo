/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: July 31, 2015
    Description: Controller class used to save Community Access Request record.
-----------------------------------------------------------------------*/

public with sharing class CommunityAccessRequestController {
    public Community_Access_Request__c objCommunityAccessRequest {get;set;}
    public String messageBody{get; set;}
    public boolean IsInfoWindow {get; set;}
    public Community_Web_Content__c communityWebContent{get; set;}

    public static final String REGISTRATION_COMPLETE = '<b>Thank you.</b><br/>Your information is being processed.<br/>A Tufts staff member will be in touch as soon as possible.';
    public static final String FIRST_NAME_ERROR = 'Please add First Name';
    public static final String LAST_NAME_ERROR = 'Please add Last Name';
    public static final String EMAIL_ERROR = 'Please add Email';
    public static final String CUSTOM_SEARCH_REGISTRATION = '/apex/CustomSearchRegistration';
    public static final String SINGLE_QUOTE = '';
    public static final String SPACE_BAR = ' ';
    public static final String BACK_SLASH = '/';

    public boolean mobile { get; set; }

    public CommunityAccessRequestController ()
    {
        populateMobile();
        IsInfoWindow = false;
        messageBody = SINGLE_QUOTE;
        objCommunityAccessRequest = new Community_Access_Request__c();
        communityWebContent = new Community_Web_Content__c();
       // communityWebContent = UtilityGeneral.getPageNameFromUrl(ApexPages.CurrentPage().getUrl());
     
       if(ApexPages.currentPage().getParameters().get('email')!=null)
          objCommunityAccessRequest.Current_Email__c = ApexPages.currentPage().getParameters().get('email');
        if(ApexPages.currentPage().getParameters().get('firstName')!=null)
          objCommunityAccessRequest.FirstName__c = ApexPages.currentPage().getParameters().get('firstName');
        if(ApexPages.currentPage().getParameters().get('lastName')!=null)
          objCommunityAccessRequest.Last_Name__c = ApexPages.currentPage().getParameters().get('lastName');
        
        String pageName = UtilityGeneral.getPageNameFromUrl(ApexPages.CurrentPage().getUrl());
       if(!String.isBlank(pageName)){
           communityWebContent = this.retriveCustomSetting(pageName);
       }
    }
    public  Community_Web_Content__c retriveCustomSetting(String pPageName) {
        list<Custom_Search_Registration__c> customSearchList = new list<Custom_Search_Registration__c>();
        if (pPageName == null) {
            return null;
        }else{
            customSearchList = [SELECT  PageName__c, Record_Name__c
                    FROM    Custom_Search_Registration__c
                    WHERE   PageName__c = : pPageName
                    LIMIT   1];
        }
        if(customSearchList.size()>0)
        {
            list<Community_Web_Content__c> cwcList = new list<Community_Web_Content__c>();
            cwcList = [SELECT  Content__c, Page_Content__c ,Title__c
                    FROM    Community_Web_Content__c
                    WHERE   Name = :customSearchList[0].Record_Name__c
                    LIMIT   1];
          if(cwcList.size() > 0) {
            return cwcList[0];
          } else
            return null;
        }
        else {
            return null;
        }
    }
    //Method to save community access object record
    public Pagereference saveContact(){
        try{
            if(String.isBlank(objCommunityAccessRequest.FirstName__c ))
            {
                objCommunityAccessRequest.FirstName__c.addError(FIRST_NAME_ERROR);
            }
            if(String.isBlank(objCommunityAccessRequest.Last_Name__c))
            {
                objCommunityAccessRequest.Last_Name__c.addError(LAST_NAME_ERROR);
            }
            if(String.isBlank(objCommunityAccessRequest.Current_Email__c ))
            {
                objCommunityAccessRequest.Current_Email__c.addError(EMAIL_ERROR);
            }
            if(String.isNotBlank(objCommunityAccessRequest.FirstName__c ) &&  
                String.isNotBlank(objCommunityAccessRequest.Last_Name__c) && 
                String.isNotBlank(objCommunityAccessRequest.Current_Email__c )) {
                    objCommunityAccessRequest.Name = objCommunityAccessRequest.FirstName__c + SPACE_BAR + objCommunityAccessRequest.Last_Name__c;
                    insert objCommunityAccessRequest;
                    system.debug('***objCommunityAccessRequest' + objCommunityAccessRequest);
                    IsInfoWindow = true;
                    messageBody = REGISTRATION_COMPLETE;
            }
        }
         catch(DmlException ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            ApexPages.addMessage(myMsg);
         }
        return null;
    }
    
    //Method which returns to the previuos page
    public Pagereference backPage(){
        ProfileDomainName__c profileDomainCustomSetting = UtilityGeneral.getProfileDomainName();
        return UtilityGeneral.redirect(BACK_SLASH + profileDomainCustomSetting.DomainName__c + CUSTOM_SEARCH_REGISTRATION,true);
    }

    //Method to send Email notification
    public void sendEmail(){
        // Step 0: Create a master list to hold the emails we'll send
        List<Messaging.SingleEmailMessage> mails = 
        new List<Messaging.SingleEmailMessage>();

        // Step 1: Create a new Email
          Messaging.SingleEmailMessage mail = 
          new Messaging.SingleEmailMessage();
        
          // Step 2: Set list of people who should get the email
          List<String> sendTo = new List<String>();
          sendTo.add(objCommunityAccessRequest.Current_Email__c);
          mail.setToAddresses(sendTo);
          
          String emailBody = REGISTRATION_COMPLETE;
          // Step 3: Set who the email is sent from
          mail.setReplyTo(objCommunityAccessRequest.Current_Email__c);
          //mail.setSenderDisplayName('Alumni Tufts');
        
          // (Optional) Set list of people who should be CC'ed
         //List<String> ccTo = new List<String>();
         //ccTo.add('business@bankofnigeria.com');
         //mail.setCcAddresses(ccTo);
    
          // Step 4. Set email contents - you can use variables!
          mail.setSubject(emailBody);
          /*String body = 'User Details :  \n' ;
          body += 'First name : ' + firstName;
          body += '\n Preferred first name : ' + preferredFirstName;
          body += '\n Last name : ' + lastName;
          body += '\n Former last name : ' + formerlastName;
          body += '\n Graduate Info : ' + GraduateInfo;*/
          
          

          mail.setHtmlBody(emailBody);
        
          // Step 5. Add your email to the master list
          mails.add(mail);
          // Step 6: Send all emails in the master list
          
          //Commented to restrict sending emails
          try{
            Messaging.sendEmail(mails);
          }
          catch(EmailException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
          }
    }
    
    //Method to redirect back to the Custom search registration
    public Pagereference clearFields(){
        IsInfoWindow = false;
        return UtilityGeneral.redirect(CUSTOM_SEARCH_REGISTRATION, true);
    }
    
    public void populateMobile()
    {
        list<Url_Pattern__c> lstUrlPatterns = Url_Pattern__c.getall().values();
        system.debug('lstUrlPatterns in populateMobile***' + lstUrlPatterns);
        if(lstUrlPatterns != null)
        {
            Pattern MyPattern = Pattern.compile(lstUrlPatterns.get(0).Url_User_Agent__c);
            system.debug('***Url_User_Agent__c? in populateMobile ' +MyPattern);
            Matcher MyMatcher = MyPattern.matcher(ApexPages.currentPage().getHeaders().get('USER-AGENT'));
            system.debug('***USER_AGENT ' +ApexPages.currentPage().getHeaders().get('USER-AGENT'));
            system.debug('***Matches? in populateMobile ' +MyMatcher.find());
            if(MyMatcher.find())
            {
                mobile = true;
                system.debug('inside mobile in populateMobile ***');
            }
            else
            {
                system.debug('not mobile in populateMobile ***');
                mobile = false;
            }
            system.debug('***Matches? in populateMobile ' +MyMatcher.find());
        }
    }
}//End class