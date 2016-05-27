/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: June 16, 2015
    Description: This  
-----------------------------------------------------------------------*/
@istest
public class TestDataFactoryClass {
    //Method to insert Domain name for community
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
    
    //Method to create profile custom Setting Data
    /*public static void AddClassNoteSettingData(){
        list<Class_Notes_Fields_CustomSetting__c> classnote = new list<Class_Notes_Fields_CustomSetting__c>();
        for(integer count = 1; count<= 200; count++)
            classnote.add(new Class_Notes_Fields_CustomSetting__c(Field_Name__c='Category__c' + count, Label__c = 'Category' + count, Order__c = String.ValueOf(count)));
        insert classnote;   
    }//End Method
    */
    //Method to create LoginFlowCustomSetting Data
    public static list<Sobject> AddLoginFlowCustomSettingData(){
        list<LoginFlowCustomSetting__c> loginFlow = new list<LoginFlowCustomSetting__c>();
        for(integer count = 1; count<=200 ; count++)
            loginFlow.add(new LoginFlowCustomSetting__c(Name = 'Page ' + count, PageName__c= 'Page_' + count, PageNumber__c = count));
        insert loginFlow;
        
        return (list<Sobject>)LoginFlowCustomSetting__c.getAll().Values();
    }//End Method    
    
    /*public static void addClassNoteSubmissionData(){
        list<Class_Note_Submission_Fields__c> lstClassNoteSubmission = new list<Class_Note_Submission_Fields__c>();
        lstClassNoteSubmission.add(new Class_Note_Submission_Fields__c(name='Category', Field_Name__c='Category__c',Label__c='Category',Order__c='1'));
        lstClassNoteSubmission.add(new Class_Note_Submission_Fields__c(name='Class Note', Field_Name__c='ClassNote__c',Label__c='Class Note',Order__c='2'));
        lstClassNoteSubmission.add(new Class_Note_Submission_Fields__c(name='Include in Allegheny magazine', Field_Name__c='Include_in_Allegheny_magazine__c',Label__c='Include in Allegheny magazine',Order__c='3'));
        lstClassNoteSubmission.add(new Class_Note_Submission_Fields__c(name='Post online', Field_Name__c='Post_online__c',Label__c='Post online',Order__c='4'));
        insert lstClassNoteSubmission;
    }*///End method
    
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
    
    //Method to create custom Setting Data for Mobile link page
    public static void AddMobileLinkSettingData(){
        list<HP_Mobile_Links__c> lstMobLink= new list<HP_Mobile_Links__c>();
        list<HP_Custom_Link_All_Communities__c> lstAllComm= new list<HP_Custom_Link_All_Communities__c>();
         list<HP_Custom_Link__c> lstCustLink = new list<HP_Custom_Link__c>();
        
        // Insert HP_Mobile_Links__c Custom setting data
        lstMobLink.add(new HP_Mobile_Links__c(name='AlumniResources',Custom_Setting__c='HP_Custom_Link_All_Communities__c',
                                            Title__c = 'Alumni Resources'));
        lstMobLink.add(new HP_Mobile_Links__c(name='ColumbiaUniversityResource',Custom_Setting__c='HP_Custom_Link__c',
                                            Title__c = 'Columbia University Resource'));
        insert lstMobLink;   
        
        // Insert HP_Custom_Link_All_Communities__c Custom setting data
        lstAllComm.add(new HP_Custom_Link_All_Communities__c(name='CareerConnections',Link_Text__c='Career Connections',
                                            Link_URL__c= '/CareerConnections'));
        lstAllComm.add(new HP_Custom_Link_All_Communities__c(name='VolunteerOpportunities',Link_Text__c='Volunteer Opportunities',
                                            Link_URL__c= '/VolunteerOpportunities'));
        insert lstAllComm;   
         
        // Insert HP_Custom_Link__c Custom setting data
        lstCustLink.add(new HP_Custom_Link__c(name='Admissions',Link_Text__c='Admissions',
                                            Link_URL__c = '/Admissions'));
        lstCustLink.add(new HP_Custom_Link__c(name='Transcripts',Link_Text__c='Transcripts',
                                            Link_URL__c = '/Transcripts'));
        insert lstCustLink;   
        
    }//End Method
    
    public static void insertCustomSearchRegistration(){
         Custom_Search_Registration__c objCustomSearchReg = new Custom_Search_Registration__c(name='testCustomSearch' ,PageName__c ='communityaccessrequest', Record_Name__c= 'TestWebContentPage');
         insert objCustomSearchReg;
     }
     
     
   public static Contact getBlankContactList()
   {
   Contact blankContact = new Contact();
   
   blankContact.FirstName = 'Test1';
   blankContact.LastName =  'Test1';
   //blankContact.Student_ID__c = null;
   
   blankContact.Email = 'test@thy.com';
   insert blankContact;
   return blankContact;
   }  
     
}//End class