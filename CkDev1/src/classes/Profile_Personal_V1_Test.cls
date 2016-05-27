/*-----------------------------------------------------------------------
    ACF Solutions
    Description: Test class for controller used to pull data from custom settings
                 and display sections on the profile page.
                
-----------------------------------------------------------------------*/

@isTest
private class Profile_Personal_V1_Test {
    
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

        Profile_Subsection__c ps = new Profile_Subsection__c(name='first Name', 
                                                             Column_Span__c='1',
                                                             Field_API_Name__c='firstName', 
                                                             Order__c='1', 
                                                             Field_Name__c='First Name');
        insert ps; 
        Profile_Page_1__c twoCol = new Profile_Page_1__c(Name='2 Column Layout Test',
                                                         Order__c='1',
                                                         Custom_Setting__c='Profile_Subsection__c',
                                                         Title__c='2 Column Layout Test',
                                                         Object__c='Contact', 
                                                         Custom_Setting_Type__c='2 column',
                                                         Field_API_For_Contact_Id__c='id');
       insert twoCol;


        Profile_Page_2__c twoCol2 = new Profile_Page_2__c(Name='2 Column Layout Test', 
                                                          Order__c='1', 
                                                          Custom_Setting__c='Profile_Subsection__c',
                                                          Title__c='2 Column Layout Test', 
                                                          Object__c='Contact', 
                                                          Custom_Setting_Type__c='2 column', 
                                                          Field_API_For_Contact_Id__c='id');
        insert twoCol2;
        Profile_Page_1__c subSection = new Profile_Page_1__c(Name='Subsection Test',
                                                             Order__c='2',
                                                             Custom_Setting__c='Profile_Page_2__c',
                                                             Title__c='Subsection Test', 
                                                             Object__c='Contact',
                                                             Custom_Setting_Type__c='subsection',
                                                             Field_API_For_Contact_Id__c='id');
        insert subSection;
       
        Profile_Page_2__c relatedListFull  = new Profile_Page_2__c(Name = 'Other School Degrees',
                                                                Custom_Setting__c = 'Profile_P2_S2_Other_Degrees__c',
                                                                Custom_Setting_Type__c = 'related list full',
                                                                Field_API_For_Contact_Id__c ='Contact__c',
                                                                Object__c = 'Education__c',
                                                                Order__c = '2',
                                                                Create__c = true,
                                                                Title__c = 'Other School Degrees',
                                                                related_list_static_where__c = 'School__c=Null',
                                                                Related_List_Privacy_API__c = 'Private__c');
        insert relatedListFull;
        
        Profile_P2_S2_Other_Degrees__c otherDegreeRecord = new Profile_P2_S2_Other_Degrees__c(Name = 'Degree',
                                                                                          Field_API_Name__c = 'Self_Reported_Degree__c',
                                                                                          Edit_Mode__c = true ,
                                                                                          Order__c = '4',
                                                                                          Field_Name__c = 'Degree',
                                                                                          Read_Mode__c =true);
        insert otherDegreeRecord;
        
        Profile_Page_3__c twoCol3 = new Profile_Page_3__c(Name = 'Employment Address',
                                                      Custom_Setting__c = 'Profile_P3_S3_EmpAddress__c',
                                                      Custom_Setting_Type__c = '2 column',
                                                      Object__c = 'Contact',
                                                      Order__c = '3',
                                                      Title__c = 'Employment Address');
        insert twoCol3;
        
        Profile_P3_S3_EmpAddress__c empAdderess = new Profile_P3_S3_EmpAddress__c(Name = 'Business City',
                                                                              Field_API_Name__c = 'Business_City__c',
                                                                              Order__c = '6',
                                                                              Field_Name__c = 'Business City' ,
                                                                              Privacy_Field_API__c = 'Privacy_Business_City__c',
                                                                              Edit_Mode__c = true);
        insert empAdderess;
        
        Profile_Page_4__c twoColumn4 = new Profile_Page_4__c(Name = 'Community Experience',
                                                         Custom_Setting_Type__c = '2 column',
                                                         Custom_Setting__c = 'Profile_Subsection__c',
                                                         Field_API_For_Contact_Id__c = 'ID',
                                                         Object__c = 'Contact',
                                                         Order__c = '2',
                                                         Title__c = 'Community Experience');
        insert twoColumn4;
        
         Profile_Page_4__c subSection4 = new Profile_Page_4__c(Name = 'Email',
                                                         Custom_Setting_Type__c = 'subsection',
                                                         Custom_Setting__c = 'Profile_Pref_Subsection__c',
                                                         Field_API_For_Contact_Id__c = 'ID',
                                                         Object__c = 'Contact',
                                                         Order__c = '1',
                                                         Title__c = 'Email');
        insert subSection4;  
        Profile_Pref_Subsection__c preferences = new Profile_Pref_Subsection__c(Name = 'Email Preferenc',
                                                                                Custom_Setting_Type__c = 'preferences',
                                                                                Custom_Setting__c = 'Profile_P4_S1_Preferences__c',
                                                                                Object__c = 'Contact',
                                                                                Field_API_For_Contact_Id__c = 'id',
                                                                                Order__c = '1',
                                                                                Title__c = 'Email Preferenc');
        insert preferences;
        
        Profile_P4_S1_Preferences__c alumniAffinityPartnerRecord = new Profile_P4_S1_Preferences__c(Name = 'Alumni Affinity Partner',
                                                                                                Field_Name__c = 'Alumni Affinity Partner – Insurance',
                                                                                                Field_API_Name__c = 'Alumni_Affinity_Partner_Insurance__c',
                                                                                                Order__c = '1');
        insert alumniAffinityPartnerRecord;                                                                                     
                                        
        Profile_Pref_Subsection__c POBox = new Profile_Pref_Subsection__c(Name = 'POBox',
                                                                                Custom_Setting_Type__c = '2 column',
                                                                                Custom_Setting__c = 'Profile_P4_POBox__c',
                                                                                Object__c = 'Contact',
                                                                                Field_API_For_Contact_Id__c = 'Id',
                                                                                Order__c = '2',
                                                                                Title__c = 'Email POBox');
        insert POBox;
         
        Profile_P4_POBox__c forwardingRecord = new Profile_P4_POBox__c(Name = 'Fowarding',
                                                                       Field_Name__c= 'Target Email',
                                                                       Field_API_Name__c = 'PO_Box_Target__c',
                                                                       Order__c = '2');
        insert forwardingRecord;
        
        Profile_Subsection__c communityExperinceRecord = new  Profile_Subsection__c(Name = 'Experience',
                                                                      Column_Span__c = '4',
                                                                      Field_API_Name__c = 'Experience__c',
                                                                      Order__c = '1');  
        insert communityExperinceRecord;                          
        
        System.runAs(u) 
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(u);
            Profile_Personal_V1 controller = new Profile_Personal_V1(sc);
            TestDataFactoryClass.getWebContentRecords();
            
            PageReference pageRef = Page.Profile_Page1; 
            pageRef.getParameters().put('sfdc.userId', String.valueOf(u.Id));
            Test.setCurrentPage(pageRef);
            controller.subTabHTML = 'test';
            controller.colr = 'blue';
            controller.strSelectOptionValue = 'abc';
            controller.relatedFullCancelId = '123456';
            controller.isInit = true;
            controller.hide = false;
            controller.show=true;
            controller.displayPopup = false;
            controller.closePopup();
            controller.displayPopup = true;
            controller.showPopup();
            
            controller.QueryPage1();
            controller.QueryPage2();
            controller.QueryPage3(); 
            controller.QueryPage4(); 
            controller.QueryPage5();
            
            controller.determineShowEditBtn();
            controller.setMobileMode();
            controller.setDesktopMode();
            controller.getContactIdFromUser();
            controller.redirectOnBlankPage();
            controller.getProfilePersonal1();
            controller.getProfilePersonal2();
            controller.getProfilePersonal3();
            controller.getProfilePersonal4();
            controller.getProfilePersonal5();
            
            
            controller.EditSobjectRecord();
            
            controller.saveSobjectRecord();
            
            controller.saveSobjectRecordToList();
            controller.deleteRelatedList();
            controller.cancelRelatedFullRecord();
            controller.editRelatedList();
            controller.createRelatedListFullRecord();   
            controller.UpdateRelatedFullRecord();  
            controller.cancel(); 
            String customSettingName = 'subSection4';
            controller.constructDynamicQueryForSubSectionCustomSetting(customSettingName);
            controller.constructDynamicQueryForFieldsCustomSetting(customSettingName);
            controller.getPicklistFieldValues(null);
        
            Sobject objRecord;
            boolean isEditable = true; 
            Profile_Personal_V1.wrapperEditableRecords wrapperEditableRecordsInstance = new Profile_Personal_V1.wrapperEditableRecords(objRecord,isEditable);

            Profile_Personal_V1.wrapperSectionIdToObj wrapperSectionIdToObjInstance = new Profile_Personal_V1.wrapperSectionIdToObj(NULL,NULL); 
            
            String FieldApiName = 'testApi';
            String SelectedValue = 'testValue';
            Profile_Personal_V1.fieldWrapperClass fieldWrapperClassInstance = new Profile_Personal_V1.fieldWrapperClass(FieldApiName,NULL,SelectedValue); 
        }
    }
    
    @isTest static void test_method_two()
    {
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
        
        System.runAs(u) 
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(u);
            Profile_Personal_V1 controller = new Profile_Personal_V1(sc);
            
            PageReference pageRef = Page.Profile_Page1;
            pageRef.getParameters().put('sfdc.userId', String.valueOf(u.Id));
            Test.setCurrentPage(pageRef);
            
            Profile_Page_1__c twoCol = new Profile_Page_1__c(Name='2 Column Layout Test',
                                                             Order__c='1',
                                                             Custom_Setting__c='Profile_Subsection__c',
                                                             Title__c='2 Column Layout Test',
                                                             Object__c='Contact', 
                                                             Custom_Setting_Type__c='2 column',
                                                             Field_API_For_Contact_Id__c='id');
           insert twoCol;
           
           Profile_Subsection__c ps1 = new Profile_Subsection__c(name='Last Name', 
                                                                 Column_Span__c='1',
                                                                 Field_API_Name__c='LastName', 
                                                                 Order__c='1', 
                                                                 Field_Name__c='First Name');
           insert ps1;
            
           Profile_Subsection__c ps2 = new Profile_Subsection__c(name='first Name',  
                                                                 Column_Span__c='1',
                                                                 Field_API_Name__c='firstName', 
                                                                 Order__c='1', 
                                                                 Field_Name__c='First Name');
           insert ps2;
          
           controller.QueryPage1(); 
           controller.QueryPage1(); 
           controller.getProfilePersonal1();
           controller.InvokeShow();
           controller.getContactIdFromUser();
           controller.saveSobjectRecord();
       }
    }
    
     @isTest static void test_method_three() { 
        
        Account a = new Account(name='testAcc');
        insert a;
       
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
        
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User u = new User(alias = 'standt', 
                          email='standarduser@testorg.com',
                          emailencodingkey='UTF-8',
                          lastname='Testing', 
                          languagelocalekey='en_US',
                          localesidkey='en_US', 
                          profileid = p.Id,
                          timezonesidkey='America/Los_Angeles', 
                          username='standarduser@test.com', ContactId=c.Id);
        insert u;
        
        Profile_Page_2__c relatedListFull  = new Profile_Page_2__c(Name = 'Other School Degrees',
                                                                Custom_Setting__c = 'Profile_P2_S2_Other_Degrees__c',
                                                                Custom_Setting_Type__c = 'related list full',
                                                                Field_API_For_Contact_Id__c ='Contact__c',
                                                                Object__c = 'Education__c',
                                                                Order__c = '2',
                                                                Create__c = true,
                                                                Title__c = 'Other School Degrees',
                                                                related_list_static_where__c = 'School__c=Null',
                                                                Related_List_Privacy_API__c = 'Private__c');
        insert relatedListFull;
        
        Profile_P2_S2_Other_Degrees__c otherDegreeRecord = new Profile_P2_S2_Other_Degrees__c(Name = 'Degree',
                                                                                          Field_API_Name__c = 'Self_Reported_Degree__c',
                                                                                          Edit_Mode__c = true ,
                                                                                          Order__c = '4',
                                                                                          Field_Name__c = 'Degree',
                                                                                          Read_Mode__c =true);
        insert otherDegreeRecord; 

        System.runAs(u) 
        {       
            ApexPages.StandardController sc = new ApexPages.StandardController(u);
            Profile_Personal_V1 controller = new Profile_Personal_V1(sc);
            
            Sobject objRecord;
            boolean isEditable = true;
            Profile_Personal_V1.wrapperEditableRecords objwrapper = new Profile_Personal_V1.wrapperEditableRecords(objRecord,isEditable);
            
            PageReference pageRef = Page.Profile_Page2;
            pageRef.getParameters().put('sfdc.userId', String.valueOf(u.Id));
            Test.setCurrentPage(pageRef);
        
            controller.QueryPage2();
            controller.getProfilePersonal2();
            controller.determineShowEditBtn();
            controller.setMobileMode();
            controller.setDesktopMode();
            controller.getContactIdFromUser();
            controller.redirectOnBlankPage();
            controller.saveSobjectRecordToList();
            controller.deleteRelatedList();
            controller.cancelRelatedFullRecord();
            controller.editRelatedList();
            controller.createRelatedListFullRecord();   
            controller.UpdateRelatedFullRecord();  
            controller.cancel(); 
            controller.callPoBox();
            String realtedListObjId = '123459';
            String customSettingName = 'subSection4';
            controller.constructDynamicQueryForSubSectionCustomSetting(customSettingName);
            controller.constructDynamicQueryForFieldsCustomSetting(customSettingName);
            controller.getPicklistFieldValues(null);

            Profile_Personal_V1.wrapperSectionIdToObj wrapperSectionIdToObjInstance = new Profile_Personal_V1.wrapperSectionIdToObj(NULL,NULL); 
            
            String FieldApiName = 'testApi';
            String SelectedValue = 'testValue';
            Profile_Personal_V1.fieldWrapperClass fieldWrapperClassInstance = new Profile_Personal_V1.fieldWrapperClass(FieldApiName,NULL,SelectedValue); 
        }
     }
      @isTest static void test_method_four() {
        
        Account a = new Account(name='testAcc');
        insert a;
        
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
       
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        User u = new User(alias = 'standt', 
                          email='standarduser@testorg.com',
                          emailencodingkey='UTF-8',
                          lastname='Testing', 
                          languagelocalekey='en_US',
                          localesidkey='en_US', 
                          profileid = p.Id,
                          timezonesidkey='America/Los_Angeles', 
                          username='standarduser@test.com', ContactId=c.Id);
        insert u;
        Profile_Page_3__c twoCol3 = new Profile_Page_3__c(Name = 'Employment Address',
                                                      Custom_Setting__c = 'Profile_P3_S3_EmpAddress__c',
                                                      Custom_Setting_Type__c = '2 column',
                                                      Object__c = 'Contact',
                                                      Order__c = '3',
                                                      Title__c = 'Employment Address');
        insert twoCol3;
        
        Profile_P3_S3_EmpAddress__c empAdderess = new Profile_P3_S3_EmpAddress__c(Name = 'Business City',
                                                                              Field_API_Name__c = 'Business_City__c',
                                                                              Order__c = '6',
                                                                              Field_Name__c = 'Business City' ,
                                                                              Privacy_Field_API__c = 'Privacy_Business_City__c',
                                                                              Edit_Mode__c = true);
        insert empAdderess;
         
        Community_Web_Content__c cv = new Community_Web_Content__c(name='picklist', Content__c='AB;CD;EF;GH;IJ;KL;MN;OP;QR;ST;UV;WX;YZ', Page_Content__c='AB;CD;EF;GH;IJ;KL;MN;OP;QR;ST;UV;WX;YZ', Title__c='picklist');
        
        insert cv;

        System.runAs(u) 
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(u);
            Profile_Personal_V1 controller = new Profile_Personal_V1(sc);
            
            Sobject objRecord;
            boolean isEditable = true;
            Profile_Personal_V1.wrapperEditableRecords objwrapper = new Profile_Personal_V1.wrapperEditableRecords(objRecord,isEditable);
            
            PageReference pageRef = Page.Profile_Page3;
            pageRef.getParameters().put('sfdc.userId', String.valueOf(u.Id));
            Test.setCurrentPage(pageRef);

            controller.QueryPage3();
            controller.getProfilePersonal3();
            system.debug('\n\n\n sectionIdToObjMap4:After '+ controller.sectionIdToObjMap +'\n\n\n');
            controller.isEditMode = false;
            controller.createRelatedListFullRecord();
            //controller.EditSobjectRecord();
            controller.deleteRelatedList();
            controller.cancel();
            controller.isEditMode = true;
            controller.saveSobjectRecordToList();
            controller.editRelatedList();
            controller.UpdateRelatedFullRecord();
            controller.cancelRelatedFullRecord();
            controller.redirectOnBlankPage();
            controller.setMobileMode(); 
            controller.setDesktopMode();
            String realtedListObjId = '123459';
            String customSettingName = 'subSection4';
            controller.constructDynamicQueryForSubSectionCustomSetting(customSettingName);
            controller.constructDynamicQueryForFieldsCustomSetting(customSettingName);
          
            controller.getPicklistFieldValues(null);

            Profile_Personal_V1.wrapperSectionIdToObj wrapperSectionIdToObjInstance = new Profile_Personal_V1.wrapperSectionIdToObj(NULL,NULL); 
            
            String FieldApiName = 'testApi';
            String SelectedValue = 'testValue';
            Profile_Personal_V1.fieldWrapperClass fieldWrapperClassInstance = new Profile_Personal_V1.fieldWrapperClass(FieldApiName,NULL,SelectedValue); 
        }
    }
    
      @isTest static void test_method_five() {
        
        Account a = new Account(name='testAcc');
        insert a;
        
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
        
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User u = new User(alias = 'standt', 
                          email='standarduser@testorg.com',
                          emailencodingkey='UTF-8',
                          lastname='Testing', 
                          languagelocalekey='en_US',
                          localesidkey='en_US', 
                          profileid = p.Id,
                          timezonesidkey='America/Los_Angeles', 
                          username='standarduser@test.com', ContactId=c.Id);
        insert u;
        
        Profile_Page_4__c twoColumn4 = new Profile_Page_4__c(Name = 'Community Experience',
                                                         Custom_Setting_Type__c = '2 column',
                                                         Custom_Setting__c = 'Profile_Subsection__c',
                                                         Field_API_For_Contact_Id__c = 'ID',
                                                         Object__c = 'Contact',
                                                         Order__c = '2',
                                                         Title__c = 'Community Experience');
        insert twoColumn4;
        
        Profile_Page_4__c subSection4 = new Profile_Page_4__c(Name = 'Email',
                                                         Custom_Setting_Type__c = 'subsection',
                                                         Custom_Setting__c = 'Profile_Pref_Subsection__c',
                                                         Field_API_For_Contact_Id__c = 'ID',
                                                         Object__c = 'Contact',
                                                         Order__c = '1',
                                                         Title__c = 'Email');
        insert subSection4;  
        
        
        Profile_Pref_Subsection__c preferences = new Profile_Pref_Subsection__c(Name = 'Email Preferenc',
                                                                                Custom_Setting_Type__c = 'preferences',
                                                                                Custom_Setting__c = 'Profile_P4_S1_Preferences__c',
                                                                                Object__c = 'Contact',
                                                                                Field_API_For_Contact_Id__c = 'id',
                                                                                Order__c = '1',
                                                                                Title__c = 'Email Preferenc');
        insert preferences;
        
        Profile_P4_S1_Preferences__c alumniAffinityPartnerRecord = new Profile_P4_S1_Preferences__c(Name = 'Alumni Affinity Partner',
                                                                                                Field_Name__c = 'Alumni Affinity Partner – Insurance',
                                                                                                Field_API_Name__c = 'Alumni_Affinity_Partner_Insurance__c',
                                                                                                Order__c = '1');
        insert alumniAffinityPartnerRecord;                                                                                     
                                        
        Profile_Pref_Subsection__c POBox = new Profile_Pref_Subsection__c(Name = 'POBox',
                                                                                Custom_Setting_Type__c = '2 column',
                                                                                Custom_Setting__c = 'Profile_P4_POBox__c',
                                                                                Object__c = 'Contact',
                                                                                Field_API_For_Contact_Id__c = 'Id',
                                                                                Order__c = '2',
                                                                                Title__c = 'Email POBox');
        insert POBox;
         
        Profile_P4_POBox__c forwardingRecord = new Profile_P4_POBox__c(Name = 'Fowarding',
                                                                       Field_Name__c= 'Target Email',
                                                                       Field_API_Name__c = 'PO_Box_Target__c',
                                                                       Order__c = '2');
        insert forwardingRecord;
        
        
        
        Profile_Subsection__c communityExperinceRecord = new  Profile_Subsection__c(Name = 'Experience',
                                                                      Column_Span__c = '4',
                                                                      Field_API_Name__c = 'Experience__c',
                                                                      Order__c = '1');  
        insert communityExperinceRecord;                          
        
        
        System.runAs(u) 
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(u);
            Profile_Personal_V1 controller = new Profile_Personal_V1(sc);
            
            
            PageReference pageRef = Page.Profile_Page4;
            pageRef.getParameters().put('sfdc.userId', String.valueOf(u.Id));
            Test.setCurrentPage(pageRef);

            controller.QueryPage4();
            controller.getProfilePersonal4();
            controller.determineShowEditBtn();
            controller.setMobileMode();
            controller.setDesktopMode();
            controller.getContactIdFromUser();
            controller.redirectOnBlankPage();
            controller.saveSobjectRecordToList();
            controller.deleteRelatedList();
            controller.cancelRelatedFullRecord();
            controller.editRelatedList();
            controller.createRelatedListFullRecord();   
            //controller.UpdateRelatedFullRecord();  
            controller.cancel(); 
            String customSettingName = 'subSection4';
            controller.constructDynamicQueryForSubSectionCustomSetting(customSettingName);
            controller.constructDynamicQueryForFieldsCustomSetting(customSettingName);
            controller.getPicklistFieldValues(null);
        
            Sobject objRecord;
            boolean isEditable = true; 
            Profile_Personal_V1.wrapperEditableRecords wrapperEditableRecordsInstance = new Profile_Personal_V1.wrapperEditableRecords(objRecord,isEditable);

            Profile_Personal_V1.wrapperSectionIdToObj wrapperSectionIdToObjInstance = new Profile_Personal_V1.wrapperSectionIdToObj(NULL,NULL); 
            
            String FieldApiName = 'testApi';
            String SelectedValue = 'testValue';
            Profile_Personal_V1.fieldWrapperClass fieldWrapperClassInstance = new Profile_Personal_V1.fieldWrapperClass(FieldApiName,NULL,SelectedValue); 
        }
        
      }
      
       @isTest static void test_method_six() {
        
        Account a = new Account(name='testAcc');
        insert a;
        
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
        
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User u = new User(alias = 'standt', 
                          email='standarduser@testorg.com',
                          emailencodingkey='UTF-8',
                          lastname='Testing', 
                          languagelocalekey='en_US',
                          localesidkey='en_US', 
                          profileid = p.Id,
                          timezonesidkey='America/Los_Angeles', 
                          username='standarduser@test.com', ContactId=c.Id);
        insert u;
        
        Profile_Page_5__c twoCol5 = new Profile_Page_5__c(Name='2 Column Layout Test', 
                                                        Order__c='1', 
                                                        Custom_Setting__c='Profile_Personal_Employee_Info_Fields__c',
                                                        Title__c='2 Column Layout Test', 
                                                        Object__c='Contact', 
                                                        Custom_Setting_Type__c='2 column', 
                                                        Field_API_For_Contact_Id__c='id');
        insert twoCol5;
         
        System.runAs(u) 
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(u);
            Profile_Personal_V1 controller = new Profile_Personal_V1(sc);
            
            Sobject objRecord;
            boolean isEditable = true;
            Profile_Personal_V1.wrapperEditableRecords objwrapper = new Profile_Personal_V1.wrapperEditableRecords(objRecord,isEditable);
            
            PageReference pageRef = Page.Profile_Page5;
            pageRef.getParameters().put('sfdc.userId', String.valueOf(u.Id));
            Test.setCurrentPage(pageRef);

            controller.QueryPage5();
            controller.getProfilePersonal5();
            controller.determineShowEditBtn();
            controller.setMobileMode();
            controller.setDesktopMode();
            controller.getContactIdFromUser();
            controller.redirectOnBlankPage();
            controller.saveSobjectRecordToList();
            controller.deleteRelatedList();
            controller.cancelRelatedFullRecord();
            controller.editRelatedList();
            controller.createRelatedListFullRecord();   
            controller.UpdateRelatedFullRecord();  
            controller.cancel(); 
            Pagereference updateRelatedPage =  controller.UpdateRelatedCompactRecord();
            Pagereference editRelatedPage =  controller.editRelatedListCompact();
            String customSettingName = 'subSection4';
            controller.constructDynamicQueryForSubSectionCustomSetting(customSettingName);
            controller.constructDynamicQueryForFieldsCustomSetting(customSettingName);
            controller.getPicklistFieldValues(null);
            Profile_Personal_V1.wrapperSectionIdToObj wrapperSectionIdToObjInstance = new Profile_Personal_V1.wrapperSectionIdToObj(NULL,NULL); 
            
            String FieldApiName = 'testApi';
            String SelectedValue = 'testValue';
            Profile_Personal_V1.fieldWrapperClass fieldWrapperClassInstance = new Profile_Personal_V1.fieldWrapperClass(FieldApiName,NULL,SelectedValue); 
        }
      } 
      
      @isTest static void test_method_seven()
      {
        Account a = new Account(name='testAcc');
        insert a;
        
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
        
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User u = new User(alias = 'standt', 
                          email='standarduser@testorg.com',
                          emailencodingkey='UTF-8',
                          lastname='Testing', 
                          languagelocalekey='en_US',
                          localesidkey='en_US', 
                          profileid = p.Id,
                          timezonesidkey='America/Los_Angeles', 
                          username='standarduser@test.com', ContactId=c.Id);
        insert u;

        System.runAs(u) 
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(u);
            Profile_Personal_V1 controller = new Profile_Personal_V1(sc);
            
            PageReference pageRef = Page.Profile_Page1;
            pageRef.getParameters().put('sfdc.userId', String.valueOf(u.Id));
            Test.setCurrentPage(pageRef);
            try {
                controller.QueryPage1();
            } catch (QueryException ex) { 
            
            }
        }
      }
}