/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Suhas Patil
    Created Date: June 16, 2015
    Description: Custom search Registration controller Test class
-----------------------------------------------------------------------*/
@isTest
private class CustomSearchRegistrationControllerTest {

    //Creates account object.
    private static Account createAccount(String accountName) {

        Account objAccount  = new Account() ;
        objAccount.Name = accountName;
        return objAccount; 
    }

    //Creates contact object.
    public static Contact createContact(String contactFirstName, String contactLastName, Id accountId, String bannerId) {

        Contact objContact = new Contact ();
        objContact.FirstName = contactFirstName;
        objContact.LastName = contactLastName;
        objContact.email = 'test@test.com';
        //objContact.Student_ID__c = bannerId;
        //objContact.Class_Year__c = 2000;
        //objContact.Degree__c = 'MS';
        objContact.Deceased__c = false;
        objContact.AccountId = accountId;
        return objContact;
    }

    //When the student Id is provided in the input.
    static testMethod void testUserUpdateStudentId() {
         Test.setCurrentPage(Page.CustomSearchRegistration);
         ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');
         
        ApexPages.currentPage().getParameters().put('g-recaptcha-response', 'true');
        Account objAccount = createAccount('Test Account');
        insert objAccount;

        Contact objContact = createContact('test','Test Contact', objAccount.Id, '1');
        insert objContact;

        //Id objProfileId = [Select Id From profile where Name='Partner Community User'].id;
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User objUser = new User(alias = 'test123', email='tester@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',
                                IsActive =false,ContactId = objContact.Id,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert objUser;

        Url_Pattern__c urlPat = new Url_Pattern__c(Name='Test', Url_User_Agent__c='Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile');
        insert urlPat;
        
        test.startTest();
            CustomSearchRegistrationController objCustomSearchRegistrationController = new CustomSearchRegistrationController();
            objCustomSearchRegistrationController.firstName = 'test';
            objCustomSearchRegistrationController.lastName = 'Test Contact';
            objCustomSearchRegistrationController.email = 'test@test.com';
            objCustomSearchRegistrationController.studentId = '1';
            //objCustomSearchRegistrationController.updateUser();
            Boolean userIsActive = [Select isActive from User where id =: objUser.Id].isActive;
            //system.assert(userIsActive, true);
        test.stopTest();
        
    }

    //When the Class year and Degree are provided in the input.
    /*static testMethod void testUserUpdateClassYearDegree() {
        Account objAccount = createAccount('Test Account');
        insert objAccount;

        Contact objContact = createContact('test','Test Contact', objAccount.Id, '1');
        insert objContact;

        Id objProfileId = [Select Id From profile where Name='Partner Community User'].id;
        
        User objUser = new User(alias = 'test123', email='test123@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = objProfileId, country='United States',
                                IsActive =false,ContactId = objContact.Id,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert objUser;
        test.startTest();
            CustomSearchRegistrationController objCustomSearchRegistrationController = new CustomSearchRegistrationController();
            objCustomSearchRegistrationController.firstName = 'test';
            objCustomSearchRegistrationController.lastName = 'Test Contact';
            objCustomSearchRegistrationController.email = 'test@test.com';
            objCustomSearchRegistrationController.classYear = '2000';
            objCustomSearchRegistrationController.degree = 'MS';
            objCustomSearchRegistrationController.updateUser();
            Boolean userIsActive = [Select isActive from User where id =: objUser.Id].isActive;
            system.assert(userIsActive, true);
        test.stopTest();
    }

    //When no match is found.
    static testMethod void testUserUpdateWhenNoMatchFound() {
        Account objAccount = createAccount('Test Account');
        insert objAccount;

        Contact objContact = createContact('test','Test Contact', objAccount.Id, '1');
        insert objContact;

        Id objProfileId = [Select Id From profile where Name='Partner Community User'].id;
        
        User objUser = new User(alias = 'test123', email='test123@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = objProfileId, country='United States',
                                IsActive =false,ContactId = objContact.Id,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert objUser;
        test.startTest();
            CustomSearchRegistrationController objCustomSearchRegistrationController = new CustomSearchRegistrationController();
            objCustomSearchRegistrationController.firstName = 'test1';
            objCustomSearchRegistrationController.lastName = 'Test Contact';
            objCustomSearchRegistrationController.email = 'test@test.com';
            objCustomSearchRegistrationController.classYear = '2000';
            objCustomSearchRegistrationController.degree = 'MS';
            objCustomSearchRegistrationController.updateUser();
            Boolean userIsActive = [Select isActive from User where id =: objUser.Id].isActive;
            //system.assert(userIsActive, true);
    
            Boolean messageFound = false;
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            system.debug('pageMessages===>>> '+pageMessages);
            for(ApexPages.Message message : pageMessages) {
                system.debug('message.getDetail()====>>> '+message.getDetail());
                system.debug('message.getSummary()====>>> '+message.getSummary());
                if(message.getDetail() == 'Error: No Match Found') {
                    messageFound = true;        
                }
            }
            System.assert(messageFound);
            //system.assert(userIsActive, false);
        test.stopTest();
    }*/
    
    
    //When more than 1 match found.
    static testMethod void testUserUpdateWhenMoreThanOneMatchFound() {
         Test.setCurrentPage(Page.CustomSearchRegistration);
        ApexPages.currentPage().getParameters().put('g-recaptcha-response', 'true');
        ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');
        Account objAccount = createAccount('Test Account');
        insert objAccount;

        Contact objContact = createContact('test','Test Contact', objAccount.Id, '1');
        insert objContact;
        system.debug('This is debug number 0....');
        Contact objContact_1 = createContact('test','Test Contact', objAccount.Id, '2');
        insert objContact_1;
        system.debug('This is debug number 1....');
        //Id objProfileId = [Select Id From profile where Name='Partner Community User'].id;
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User objUser = new User(alias = 'test123', email='tester@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',
                                IsActive =false,ContactId = objContact.Id,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert objUser;
        system.debug('This is debug number 2....');
        User objUser_1 = new User(alias = 'test345', email='tester@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing_1', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',
                                IsActive =true,ContactId = objContact_1.Id,
                                timezonesidkey='America/Los_Angeles', username='tester_1@noemail.com');
        insert objUser_1;

        Url_Pattern__c urlPat = new Url_Pattern__c(Name='Test', Url_User_Agent__c='Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile');
        insert urlPat;

        test.startTest();
            CustomSearchRegistrationController objCustomSearchRegistrationController = new CustomSearchRegistrationController();
            objCustomSearchRegistrationController.firstName = 'test';
            objCustomSearchRegistrationController.lastName = 'Test Contact';
            //objCustomSearchRegistrationController.updateUser();
            objCustomSearchRegistrationController.getSearchSelectionCriteria();
            //objCustomSearchRegistrationController.getDegreeList();
            //Boolean userIsActive = [Select isActive from User where id =: objUser.Id].isActive;
            //system.assert(userIsActive, true);
    
            Boolean messageFound = false;
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            system.debug('pageMessages===>>> '+pageMessages);
            for(ApexPages.Message message : pageMessages) {
                system.debug('message.getDetail()====>>> '+message.getDetail());
                system.debug('message.getSummary()====>>> '+message.getSummary());
                if(message.getDetail() == 'Error: No Exact Match or Too Many Records Found') {
                    messageFound = true;        
                }
            }
            //System.assert(messageFound);
            //system.assert(userIsActive, false);
        test.stopTest();
        
        
    }
    
    
    
    static testMethod void positiveTest() {
        
        Test.setCurrentPage(Page.CustomSearchRegistration);
        ApexPages.currentPage().getParameters().put('g-recaptcha-response', 'true');
        ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');
        // Data
        Account objAccount = createAccount('Test Account');
        insert objAccount;
        System.assertNotEquals(null, objAccount.Id);
        
        Contact objContact = createContact('test','Test Contact', objAccount.Id, '1');
        objContact.Student_ID__c = '0001452';
        insert objContact;
        System.assertNotEquals(null, objContact.Id);
        
        Contact objContact_1 = createContact('test','Test Contact', objAccount.Id, '2');
        objContact_1.Student_ID__c = '0001447';
        insert objContact_1;
        System.assertNotEquals(null, objContact_1.Id);
        
        
        //Id objProfileId = [Select Id From profile where Name='Partner Community User'].id;
        
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User objUser = new User(alias = 'test123', email='tester@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',
                                IsActive =false,ContactId = objContact.Id,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert objUser;
        System.assertNotEquals(null, objUser.Id);
        
        User objUser_1 = new User(alias = 'test345', email='tester@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing_1', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',
                                IsActive =true,ContactId = objContact_1.Id,
                                timezonesidkey='America/Los_Angeles', username='tester_1@noemail.com');
        insert objUser_1;
        System.assertNotEquals(null, objUser_1.Id);
        

        Url_Pattern__c urlPat = new Url_Pattern__c(Name='Test', Url_User_Agent__c='Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile');
        insert urlPat;
        
        CustomSearchRegistrationController SearchController = new CustomSearchRegistrationController();
        Boolean isString = true;
        String equateValue = 'demo@test.com';
        SearchController.email = equateValue;
        SearchController.formerEmail = equateValue;
        String pContactId = '014215478569854';
        
        String toEmailAddress = 'demo@test.com'; 
        String emailBody = 'This is a test mail body';
        String toEmailAddressBlank = ''; 
        
        
        // Test
        
        Test.startTest();
        
        List<Contact> contactlistTest = SearchController.queryContact();
        
        String buildQueryTest = SearchController.buildQueryWhere(contactlistTest);
        
        //String buildQueryWhereForUserTest = SearchController.buildQueryWhereForUser();
        
        List<User> userListTest = SearchController.queryUser(contactlistTest);
        
        //List<User> queryUserForContactInfoList = SearchController.queryUserForContactInfo();
        
        List<sObject> sobjList = SearchController.getContactFromId(pContactId);
        
        SearchController.sendEmail(toEmailAddress, emailBody);
        SearchController.sendEmail(toEmailAddressBlank, emailBody);
        
        String whereStringIf = CustomSearchRegistrationController.whereEquateValues(equateValue, isString);
        String whereStringElse = CustomSearchRegistrationController.whereEquateValues(equateValue, isString);
        
        SearchController.ClearFields();
        
        Test.stopTest();
        
        
        // Asserts 
        System.assert(!contactlistTest.isEmpty());
        
        System.assert(!userListTest.isEmpty());
        
        
        //System.assert(!queryUserForContactInfoList.isEmpty());
        
        //System.assert(!sobjList.isEmpty());
        
        System.assertNotEquals(null, buildQueryTest);
        //System.assertNotEquals(null, buildQueryWhereForUserTest);
        

        System.assertEquals('', SearchController.firstName);
        System.assertEquals('', SearchController.lastName);
        System.assertEquals('', SearchController.email);
        System.assertEquals('', SearchController.studentId);
        //System.assertEquals('', SearchController.formerEmail);
        System.assertEquals('', SearchController.degree);
        System.assertEquals('', SearchController.selectedSearchOption);
        System.assertEquals('', SearchController.selectedDegree);
        System.assertEquals(false, SearchController.IsTryAgain);
        System.assertEquals(false, SearchController.isPasswordReset);
        System.assertEquals(false, SearchController.IsInfoWindow);

        System.assertNotEquals(null, whereStringIf);
        System.assertNotEquals(null, whereStringElse);
        
    }
    
    
    
    static testMethod void checkRegistrationFlow1() {
        Test.setCurrentPage(Page.CustomSearchRegistration);
        ApexPages.currentPage().getParameters().put('g-recaptcha-response', 'true');
        ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');
        
        Custom_Search_Registration__c SearchRegistrationObj = new Custom_Search_Registration__c();
        SearchRegistrationObj.PageName__c = 'customsearchregistration';
        SearchRegistrationObj.Name = 'customsearchregistration';
        SearchRegistrationObj.Record_Name__c = 'customsearchregistration';
        insert SearchRegistrationObj;
        
        Community_Web_Content__c CommunityObj = new Community_Web_Content__c();
        CommunityObj.Name = 'customsearchregistration' ;
        insert CommunityObj;
        
        ProfileDomainName__c profileDomainInstance = new ProfileDomainName__c();
        profileDomainInstance.DomainName__c = 'connect';
        profileDomainInstance.Name = 'connect';
        insert profileDomainInstance;
        
        Account objAccount = createAccount('Test Account');
        insert objAccount;
        System.assertNotEquals(null, objAccount.Id);
        
        Contact objContact = createContact('test','Test Contact', objAccount.Id, '1');
        objContact.Student_ID__c = '0001452';
        insert objContact;
        System.assertNotEquals(null, objContact.Id);
        
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User objUser = new User(alias = 'test123', email='tester@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',
                                IsActive =false,ContactId = objContact.Id,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert objUser;
        System.assertNotEquals(null, objUser.Id);

        Url_Pattern__c urlPat = new Url_Pattern__c(Name='Test', Url_User_Agent__c='Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile');
        insert urlPat;
        
        CustomSearchRegistrationController SearchController = new CustomSearchRegistrationController();
        
        List<Contact> contactListTest = [
            SELECT 
                id 
            FROM 
                Contact
            LIMIT 1
        ];
        
        List<User> userListTest = [
            SELECT 
                id 
            FROM 
                User
            LIMIT 1
        ];
        /*
        List <Contact> conTest = SearchController.queryContact();
        System.debug('\n\n hahaha    conTest \n\n' + conTest);
        
        //SearchController.contactList = contactListTest;
        //SearchController.userList = userListTest;
        SearchController.email='tester@noemail.com';
        System.debug('hahaha' + contactListTest);
        System.debug('hahaha' + userListTest);
        */
        
        Pagereference registrationTest = SearchController.checkRegistrationFlow();
        
    }
    
    
    
    
    // Negative
    static testMethod void negativeTest()
    {
     
        Test.setCurrentPage(Page.CustomSearchRegistration);
        ApexPages.currentPage().getParameters().put('g-recaptcha-response', 'true');
        system.debug('****ApexPages.currentPage().getParameters()' + ApexPages.currentPage().getParameters());   
        ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');
        
        // Data
        Account objAccount = createAccount('Test Account');
        insert objAccount;
        System.assertNotEquals(null, objAccount.Id);
        
        Contact objContact = createContact('test','Test Contact', objAccount.Id, '1');
        objContact.Student_ID__c = '0001452';
        insert objContact;
        System.assertNotEquals(null, objContact.Id);
        
        Contact objContact_1 = createContact('test','Test Contact', objAccount.Id, '2');
        objContact_1.Student_ID__c = '0001447';
        insert objContact_1;
        System.assertNotEquals(null, objContact_1.Id);

        // ProfileDomainName__c Data
        ProfileDomainName__c profileDomainInstance = new ProfileDomainName__c();
        profileDomainInstance.DomainName__c = 'connect';
        profileDomainInstance.Name = 'connect';
        insert profileDomainInstance;
        System.assertNotEquals(null, profileDomainInstance.Id);
        
        //Id objProfileId = [Select Id From profile where Name='Partner Community User'].id;
        
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User objUser = new User(alias = 'test123', email='tester@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',
                                IsActive =true,ContactId = objContact.Id,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert objUser;
        System.assertNotEquals(null, objUser.Id);
        
        User objUser_1 = new User(alias = 'test345', email='tester1@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing_1', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',
                                IsActive =true,ContactId = objContact_1.Id,
                                timezonesidkey='America/Los_Angeles', username='tester_1@noemail.com');
        insert objUser_1;
        System.assertNotEquals(null, objUser_1.Id);

        Url_Pattern__c urlPat = new Url_Pattern__c(Name='Test', Url_User_Agent__c='Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile');
        insert urlPat;
        
        CustomSearchRegistrationController SearchController = new CustomSearchRegistrationController();
        
        Boolean isString = false;
        String equateValue = '2415';
        
        SearchController.firstName = 'test';
        SearchController.lastName = 'demo';
        SearchController.email = 'tester@noemail.com';
        SearchController.formerEmail = 'demo1@test.com';
        SearchController.selectedSearchOption = 'Student_Id';
        SearchController.studentId = '01245';
        
        List<Contact> contactlistTest = new List<Contact>();
        String buildQueryNegativeTest = SearchController.buildQueryWhere(contactlistTest);
        Pagereference studentId = SearchController.checkRegistrationFlow();
        System.assertNotEquals(null, buildQueryNegativeTest);
        
        
        SearchController.selectedSearchOption = 'Former_Email';
        Pagereference formerEmail = SearchController.checkRegistrationFlow();
        String whereQueryTest = SearchController.buildQueryWhere(contactlistTest);
        System.assertNotEquals(null, whereQueryTest);
        
        SearchController.email = 'tester@noemail.com';
        
        
        SearchController.validUser = objUser;
        System.debug('>>>>>  SearchController.validUser \n\n ' + SearchController.validUser);
        
        //SearchController.resetUserPassword();
        
        
        String whereEquateValuesTest = CustomSearchRegistrationController.whereEquateValues(equateValue, isString);
        System.assertNotEquals(null, whereEquateValuesTest);
        
        
        
        //Apexpages.currentPage().getParameters.get().put('true');
        
        SearchController.checkRegistrationFlow();
        
    }
    
    
    static testMethod void testPageMessages()
    {

        Test.setCurrentPage(Page.CustomSearchRegistration);
        ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');
        ApexPages.currentPage().getParameters().put('g-recaptcha-response', 'true');

        Url_Pattern__c urlPat = new Url_Pattern__c(Name='Test', Url_User_Agent__c='Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile');
        insert urlPat;
        
        CustomSearchRegistrationController SearchController = 
            new CustomSearchRegistrationController();
        
        
       
        
        
        
        
        
        // Test No Match Found 
        SearchController.addNoMatchFoundErrorMessage();
        System.assertEquals(true, SearchController.IsTryAgain);
        System.assertEquals(false, SearchController.isPasswordReset); 
        
        // Test No Match Email Found
        SearchController.addNoMatchEmailFoundErrorMessage();
        System.assertEquals(true, SearchController.IsTryAgain);
        System.assertEquals(false, SearchController.isPasswordReset); 
        
        // Test Too Many Record Found
        SearchController.addTooManyRecordFoundErrorMessage();
        System.assertEquals(true, SearchController.IsTryAgain);
        System.assertEquals(false, SearchController.isPasswordReset); 
        
        // Test Match Found 
        SearchController.addMatchFoundInfoMessage();
        System.assertEquals(true, SearchController.IsTryAgain);
        System.assertEquals(true, SearchController.isPasswordReset); 
        
                
        ProfileDomainName__c profileDomainInstance = new ProfileDomainName__c();
        profileDomainInstance.DomainName__c = 'connect';
        profileDomainInstance.Name = 'connect';
        insert profileDomainInstance;
        System.assertNotEquals(null, profileDomainInstance.Id);
        
        Pagereference moreInfoRedirectTest = SearchController.redirectToMoreInformation();
        
        
        System.assertNotEquals(null, CustomSearchRegistrationController.EMAIL_UPDATED);
        System.assertNotEquals(null, CustomSearchRegistrationController.WELCOME_EMAIL);
        System.assertNotEquals(null, CustomSearchRegistrationController.FORWARD_SLASH);
        System.assertNotEquals(null, CustomSearchRegistrationController.ADD_COMMUNITYACCESS);
        //System.assertNotEquals(null, CustomSearchRegistrationController.USER_FOUND);
        
    }
    
    
    static testMethod void testCheckRegistrationFlow()
    {
        Test.setCurrentPage(Page.CustomSearchRegistration);
        ApexPages.currentPage().getParameters().put('g-recaptcha-response', 'true');
        ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');
        
        Url_Pattern__c urlPat = new Url_Pattern__c(Name='Test', Url_User_Agent__c='Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile');
        insert urlPat;
        
        CustomSearchRegistrationController SearchController = new CustomSearchRegistrationController();
        
        Community_Web_Content__c CommunityObj = new Community_Web_Content__c();
        CommunityObj.Name = 'customsearchregistration' ;
        insert CommunityObj;
        
        Custom_Search_Registration__c SearchRegistrationObj = new Custom_Search_Registration__c();
        SearchRegistrationObj.PageName__c = 'customsearchregistration';
        SearchRegistrationObj.Name = 'customsearchregistration';
        SearchRegistrationObj.Record_Name__c = 'customsearchregistration';
        insert SearchRegistrationObj;
        
        Account objAccount = createAccount('Test Account');
        insert objAccount;

        Contact objContact = createContact('test','Test Contact', objAccount.Id, '1');
        insert objContact;

       
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User objUser = new User(alias = 'test123', email='tester@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',
                                IsActive =false,ContactId = objContact.Id,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert objUser;

        ProfileDomainName__c ProfileObj = new ProfileDomainName__c();
         ProfileObj.Name = 'Alumni';
         insert ProfileObj;
       
       SearchController.firstName = 'test';
       SearchController.lastName = 'Test Contact';
       SearchController.email = 'test@test.com';
       SearchController.studentId = '1';
     //  SearchController.formerEmail = 'test@test.com';
       SearchController.selectedSearchOption = 'Student_Id';
       test.startTest();
       SearchController.checkRegistrationFlow();
       User UserList = [select email from User where  username='tester@noemail.com'];
       System.assert(UserList!= null);
         test.stopTest();
    }
    
    
    
    static testMethod void testCheckRegistrationFlowNull()
    {
     Test.setCurrentPage(Page.CustomSearchRegistration);
     ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');
     
     Url_Pattern__c urlPat = new Url_Pattern__c(Name='Test', Url_User_Agent__c='Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile');
     insert urlPat;

     CustomSearchRegistrationController SearchController = new CustomSearchRegistrationController();
     
     Community_Web_Content__c CommunityObj = new Community_Web_Content__c();
       CommunityObj.Name = 'customsearchregistration' ;
       insert CommunityObj;
       
       Custom_Search_Registration__c SearchRegistrationObj = new Custom_Search_Registration__c();
       SearchRegistrationObj.PageName__c = 'customsearchregistration';
       SearchRegistrationObj.Name = 'customSearchregistration';
       SearchRegistrationObj.Record_Name__c = 'customSearchregistration';
       insert SearchRegistrationObj;
        
    
    
    
      Account objAccount = createAccount('Test Account');
        insert objAccount;

        Contact objContact = createContact('test','Test Contact', objAccount.Id, '1');
        insert objContact;

       
        Profile p = [select id from profile where UserLicenseId IN (Select id From UserLicense u where u.name='Customer Community Login') limit 1];
        
        User objUser = new User(alias = 'test123', email='tester@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',
                                IsActive =false,ContactId = objContact.Id,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert objUser;

         ProfileDomainName__c ProfileObj = new ProfileDomainName__c();
         ProfileObj.Name = 'Alumni';
         insert ProfileObj;
         
         Test.startTest();
         
         SearchController.studentId = '1025841';
         SearchController.selectedSearchOption = 'Student_Id';
         SearchController.firstName = null;
         SearchController.checkRegistrationFlow();
         
         SearchController.studentId = '1025841';
         SearchController.selectedSearchOption = 'Student_Id';
         SearchController.firstName = 'a';
         SearchController.lastName = null;
         SearchController.checkRegistrationFlow();
         
         SearchController.studentId = '1025841';
         SearchController.selectedSearchOption = 'Student_Id';
         SearchController.firstName = 'a';
         SearchController.lastName = 'b';
         SearchController.email = null;
         SearchController.checkRegistrationFlow();
         
         
         SearchController.checkRegistrationFlow();
         User UserList = [select email from User where  username='tester@noemail.com'];
         System.assert(UserList != null);
         
         Test.stopTest();
         
    }
    
    

}