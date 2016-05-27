/*
    Created By              Created Date
    Siddharth Pandit        11 Feb 2015
*/
public class HP_UserDetails {
    public HP_UserDetails__c HP_UserDetailsObj { get; set; }
    public Contact HP_ContactDetailsobj { get; set; }
    public list<String> HP_UserDetailsFieldList{ get; set; }
    public String userFullPhotoUrl { get; set; }
    public String headerType { get; set; }
    //public static final string dummyUserImageUrl = '/profilephoto/005/T';
    
    //Construcor
    public HP_UserDetails(){
        init();
        getUserInformation();
        CommunityCSSHeaders commHeaders = new CommunityCSSHeaders();
        headerType = commHeaders.getHeadersType();
    }//End Construcor
    
    //Initialization of Class Data Members
    public void init(){
        HP_UserDetailsObj = new HP_UserDetails__c();
        HP_UserDetailsFieldList = new list<String>();
    }//End Method
    
    //Method which calls all the other methods to get Contact Information For current User
    public void getUserInformation(){
        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_UserDetailsObj = getHP_UserDetailsObj(subCommunity);
        String userId = getUserId();
        String contactId = getContactId(userId);
        HP_ContactDetailsobj = new Contact();
        HP_ContactDetailsobj = getContactInformation(contactId, HP_UserDetailsObj);
        userFullPhotoUrl = getFullPhotoUrl(userId);
    }//End Method
    
    //Method to fetch User Details from the custom settings
    public HP_UserDetails__c getHP_UserDetailsObj(String subCommunity ){
         list<HP_UserDetails__c> HP_UserDetailsList = new list<HP_UserDetails__c>();
         if(subCommunity != NULL){
             HP_UserDetailsList = [SELECT Field_API_Name__c,
                                          Sub_Community__c
                                   FROM HP_UserDetails__c
                                   WHERE Sub_Community__c =:subCommunity];
         }//End If
         if(HP_UserDetailsList.isEmpty()){
             return NULL;
         }//End If
          HP_UserDetailsFieldList = HP_UserDetailsList.get(0).Field_API_Name__c.split(',');
         
         return HP_UserDetailsList.get(0);
    }//End Method
    
    //Get UserId of Current User
    public string getUserId(){
        return userinfo.getUserId();
    }//End Method
    
    //Get Contact Id fot the current User
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
    public Contact getContactInformation(string pContactId, HP_UserDetails__c pHP_UserDetails){
        list<Contact> ContactList = new list<Contact>();
        if(pContactId != NULL && pHP_UserDetails != NULL){
            ContactList = Database.query('SELECT ' + pHP_UserDetails.Field_API_Name__c + ' FROM Contact where id = :pContactId');
        }//End If
        if(ContactList.isEmpty()){
            return NULL;
        }//End If
        return ContactList.get(0);
    }//End Method
    
    //Method to get Full Photo Url of User
    public String getFullPhotoUrl(String pUserId){
    	list<User> userList = new list<User>();
    	userList = [SELECT FullPhotoUrl FROM User where id =:pUserId];
    	if(userList.isEmpty()){
    		return NULL;
    	}
    	return userList.get(0).FullPhotoUrl;
    }//End Method
}//End Class