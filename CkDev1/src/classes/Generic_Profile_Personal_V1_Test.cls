@isTest
private class Generic_Profile_Personal_V1_Test {
    
    @isTest static void test_method_one() {

        Account a = new Account(name='testAcc');
        insert a;
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser@test.com', ContactId=c.Id);
        insert u;

        Profile_Subsection__c ps = new Profile_Subsection__c(name='first Name', Column_Span__c='1', Field_API_Name__c='firstName', 
            Order__c='1', Field_Name__c='First Name');
        insert ps;
        Profile_Page_1__c twoCol = new Profile_Page_1__c(Name='2 Column Layout Test', Order__c='1', Custom_Setting__c='Profile_Subsection__c',
            Title__c='2 Column Layout Test', Object__c='Contact', Custom_Setting_Type__c='2 column', Field_API_For_Contact_Id__c='id');
        insert twoCol;
        
        //Custom object
        list<Community_Web_Content__c> lstWebContent = new list<Community_Web_Content__c>();
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage',Page_Content__c ='Profile_Personal_V1'));
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage2',Page_Content__c ='Profile_Page1'));
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage2',Page_Content__c ='Profile_Page2'));
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage2',Page_Content__c ='Profile_Page3'));
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage2',Page_Content__c ='Profile_Page4'));
        lstWebContent.add(new Community_Web_Content__c(name='TestWebContentPage2',Page_Content__c ='Profile_Page5'));
        insert lstWebContent;

        Profile_Page_2__c twoCol2 = new Profile_Page_2__c(Name='2 Column Layout Test', Order__c='1', Custom_Setting__c='Profile_Subsection__c',
            Title__c='2 Column Layout Test', Object__c='Contact', Custom_Setting_Type__c='2 column', Field_API_For_Contact_Id__c='id');
        insert twoCol2;
        Profile_Page_1__c subSection = new Profile_Page_1__c(Name='Subsection Test', Order__c='2', Custom_Setting__c='Profile_Page_2__c',
            Title__c='Subsection Test', Object__c='Contact', Custom_Setting_Type__c='subsection', Field_API_For_Contact_Id__c='id');
        insert subSection;


        System.runAs(u) 
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(u);
            Profile_Personal_V1 controller = new Profile_Personal_V1(sc);
            
            PageReference pageRef = Page.Profile_Page1;
            pageRef.getParameters().put('sfdc.userId', String.valueOf(u.Id));

            pageRef.getParameters().put('Id', String.valueOf(u.Id));
            Test.setCurrentPage(pageRef);
            
            controller.isEditMode = null;
            controller.currentUserContactId = '';
            
            controller.QueryPage1();
            controller.QueryPage2();
            controller.QueryPage3();
            controller.QueryPage4();
            controller.QueryPage5();

            controller.EditSobjectRecord();
            controller.currentContact = c;
            controller.saveSobjectRecord();
            controller.currentContact = null;
            controller.saveSobjectRecord();
            controller.cancel();  
            
            controller.setDesktopMode();
            controller.setMobileMode();
            controller.redirectOnBlankPage();
            controller.createRelatedListFullRecord();
            Profile_Personal_V1.wrapperEditableRecords objWrapper = new Profile_Personal_V1.wrapperEditableRecords(null, true);
            Profile_Personal_V1.fieldWrapperClass objFieldWrapper = new Profile_Personal_V1.fieldWrapperClass(null, null, null);
            
            controller.deleteRelatedList();
            controller.saveSobjectRecordToList();
            controller.cancelRelatedFullRecord();
            controller.editRelatedList();
            controller.UpdateRelatedFullRecord();
            controller.subTabHTML='';
          //  controller.sectionIdToBranchObj = null; // commented to resolve a test error - Sid
           // controller.mapWebContent = null;
           // controller.lstSectionCustomSetting= null;
          //  controller.mapCustomFieldWithSelectList= null;
            controller.lstWrapper= null;
            controller.isInit= null;
            controller.relatedFullCancelId= null;
            controller.strSelectOptionValue = null;
            //controller.lstRelatedFullRecordId = null;
        }      
    }
}