@isTest
private class UserUtilsTest {
    public static integer totalRecords = 200;
    /*
    *   Test Method for saving the User Utils Class.
    */
    static testMethod void TestUserUtils() {
    	Account a = new Account(name='testAcc');
    	insert a;
        Contact c = new Contact(lastName='TestContact', AccountId=a.Id);
        insert c;
		Profile p = [select id,name from profile where name='Customer Community Login User'];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser@test.com', ContactId=c.Id);
        insert u;
      	
      	
      	List<HP_ProfileSubCommunityType__c> subCommunityTypeObjectList = new List<HP_ProfileSubCommunityType__c>();
        subCommunityTypeObjectList.add( new HP_ProfileSubCommunityType__c(
                                                Sub_Community_Type__c = 'Contact', Field_API_Name__c ='lastname'
                                                ,Name = 'testSubCommunityType'
                                                                         )
                                       );                                        	
      	for(integer counter = 0 ; counter < totalRecords ; counter++)
            subCommunityTypeObjectList.add( new HP_ProfileSubCommunityType__c(
                                                Sub_Community_Type__c = 'Contact', Field_API_Name__c = 'lastname'
                                                ,Name = 'testSubCommunityType' + counter
                                                                              )
                                          );  
        insert subCommunityTypeObjectList; 
        
        list<HP_ProfileSubCommunityMap__c> HP_ProfileSubCommunityMapList = new list<HP_ProfileSubCommunityMap__c>();
        for(integer counter = 0 ; counter < totalRecords ; counter++)
            HP_ProfileSubCommunityMapList.add(new HP_ProfileSubCommunityMap__c(
                                                  Profile__c = 'Customer Community Login User' + counter, 
                                                  Sub_Community__c = 'Contact' + counter ,
                                                  Name = 'testProfileSubCommunityMap' + counter       
                                             ));
        insert HP_ProfileSubCommunityMapList;    
                                                                    	
      	System.runAs(u) 
        {
            UserUtils  utils = new UserUtils();
            
            //Test for getUserProfileName
            string profileName = utils.getUserProfileName();
            system.assertequals(profileName, p.name);
            
            //Test for getSelectedContactSubCommunity(String ContactField)
            string conSubCommunityName = utils.getSelectedContactSubCommunity('lastName');
            system.assertequals(conSubCommunityName, c.lastName);
            
            //Test for  getSubCommunityTypeObj
            HP_ProfileSubCommunityType__c subCommunityTypeObj = utils.getSubCommunityTypeObj();
            system.assertequals(subCommunityTypeObj.Sub_Community_Type__c, subCommunityTypeObjectList[0].Sub_Community_Type__c);
            system.assertequals(subCommunityTypeObj.Field_API_Name__c, subCommunityTypeObjectList[0].Field_API_Name__c);
            
            //Test for querySubCommunityName
            string subCommunity = utils.querySubCommunityName(p.name);
            system.debug('subCommunity : ' + subCommunity);
            //Test for getSubCommunityName
            subCommunity = utils.getSubCommunityName();
            system.debug('subCommunity : ' + subCommunity);
        }
      	
    }
}