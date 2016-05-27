/*
	Created By 				Created Date
	Siddharth Pandit		10 Feb 2015
*/
public class HP_SchoolSocialBadges {
	public list<HP_SchoolSocialBadges__c> HP_SchoolSocialBadgesObjList { get; set; }

	//Constructor
    public HP_SchoolSocialBadges() 
    {
    	getHP_SchoolSocialBadgesFromProfileObj();
    	
    }//End Constructor

	//Get custom setting object from sub-community
    public list<HP_SchoolSocialBadges__c> getHP_SchoolSocialBadgesObjList(String subCommunity)
    {
    	HP_SchoolSocialBadgesObjList = new list<HP_SchoolSocialBadges__c>();
    	if(subCommunity != NULL){
        	HP_SchoolSocialBadgesObjList = [SELECT Logo_URL__c, URL__c,Sub_Community__c, Order__c
        								FROM HP_SchoolSocialBadges__c
        								WHERE Sub_Community__c=:subCommunity
        								ORDER BY Order__c ASC NULLS LAST];
        								
    	}//End If
        return HP_SchoolSocialBadgesObjList;
    }
    
    //Method which calls all the other methods to get School's social badges custom settings from profile 
    public void getHP_SchoolSocialBadgesFromProfileObj(){
    	HP_SchoolSocialBadgesObjList = new list<HP_SchoolSocialBadges__c>();

        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_SchoolSocialBadgesObjList = getHP_SchoolSocialBadgesObjList(subCommunity);
    }//End Method
}//End Class