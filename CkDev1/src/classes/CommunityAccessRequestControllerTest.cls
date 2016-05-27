@istest
public class CommunityAccessRequestControllerTest {
    @isTest static void test_method_one(){

            Test.setCurrentPageReference(Page.CommunityAccessRequest);
            ApexPages.currentPage().getHeaders().put('USER-AGENT', '... internet explorer ...');

            Url_Pattern__c urlPat = new Url_Pattern__c(Name='Test', Url_User_Agent__c='Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile');
            insert urlPat;

            list<Community_Web_Content__c> lstWbContents = TestDataFactoryClass.getWebContentRecords();
            CommunityAccessRequestController objCommAccess = new CommunityAccessRequestController();
            objCommAccess.retriveCustomSetting(null);
            TestDataFactoryClass.insertCustomSearchRegistration();
            objCommAccess = new CommunityAccessRequestController();
            objCommAccess.saveContact();
            objCommAccess.objCommunityAccessRequest.FirstName__c = 'Test';
            objCommAccess.saveContact();
            objCommAccess.objCommunityAccessRequest.Former_First_Name__c = 'Test';
            objCommAccess.saveContact();
            objCommAccess.objCommunityAccessRequest.Last_Name__c = 'TestObject';
            objCommAccess.saveContact();
            objCommAccess.objCommunityAccessRequest.Former_Last_Name__c = 'TestObject';
            objCommAccess.saveContact();
            objCommAccess.objCommunityAccessRequest.Current_Email__c = 'Test@test.com';
            objCommAccess.saveContact();
            objCommAccess.objCommunityAccessRequest.Current_Email__c = '123456';
            objCommAccess.saveContact();
            TestDataFactoryClass.addDomainName('alumni');
            objCommAccess.backPage();
            objCommAccess.sendEmail();
            objCommAccess.objCommunityAccessRequest.Current_Email__c = null;
            objCommAccess.sendEmail();
            objCommAccess.clearFields();
           // System.assert(false, objCommAccess.IsInfoWindow);

    }
}