public class UserUtils {
    
    public UserUtils(){
        
    }
    
    //Get Profile name of current User
    public String getUserProfileName()
    {
        Profile p = [SELECT Name from Profile where Id =: userinfo.getProfileid() limit 1];
        return p.Name;
    }//End Method
    
    //Get Selected Contact sub-community name of current User
    public String getSelectedContactSubCommunity(String ContactField)
    {
        // Todo Return the Selected Contact sub-community name field
        String conSubCommunityName = '';

        User u = [SELECT Id, ContactId from User where Id =: userinfo.getUserId() limit 1];
        
        String contactQueryString = 'SELECT Id, '+ContactField+' from Contact where Id=\''+u.ContactId+'\' limit 1';
        Contact c = Database.query(contactQueryString);

        if(c.Id!=null)
        {
            conSubCommunityName = String.valueOf(c.get(ContactField));
        }

        return conSubCommunityName;
    }//End Method

    // Determin if we use profile or contact field to find sub-community based on custom setting
    public HP_ProfileSubCommunityType__c getSubCommunityTypeObj()
    {
        HP_ProfileSubCommunityType__c subCommunityTypeObj = new HP_ProfileSubCommunityType__c();

        list<HP_ProfileSubCommunityType__c> HP_ProfileSubCommunityTypeList = [SELECT Sub_Community_Type__c, Field_API_Name__c FROM HP_ProfileSubCommunityType__c];
        if(HP_ProfileSubCommunityTypeList.size()>0)
        {
            subCommunityTypeObj = HP_ProfileSubCommunityTypeList[0];
        }
        return subCommunityTypeObj;
    }

    public String querySubCommunityName(String profileName)
    {
        String subCommunity = '';

        list<HP_ProfileSubCommunityMap__c> HP_ProfileSubCommunityMapList = [SELECT Profile__c, Sub_Community__c FROM HP_ProfileSubCommunityMap__c WHERE Profile__c=:profileName];

        if(HP_ProfileSubCommunityMapList.size()>0)
        {
            subCommunity = HP_ProfileSubCommunityMapList.get(0).Sub_Community__c;
        }

        return subCommunity;
    }

    // Get sub-community name from User
    public String getSubCommunityName()
    {
        String subCommunity = NULL;

        HP_ProfileSubCommunityType__c subCommunityTypeObj = getSubCommunityTypeObj();
        String subCommunityType = subCommunityTypeObj.Sub_Community_Type__c;
        String fieldAPIName = subCommunityTypeObj.Field_API_Name__c;

        if(subCommunityType=='contact')
        {
            String contactSubCommunity = getSelectedContactSubCommunity(fieldAPIName);
            subCommunity = querySubCommunityName(contactSubCommunity);
        }
        else
        {
            String profileName = getUserProfileName();
            subCommunity = querySubCommunityName(profileName);
        }
        
        return subCommunity;
    }//End Method



}