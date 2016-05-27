public with sharing class VolunteerOpportunityClass {
public list<HP_Volunteer_Opportunity__c> HP_VolunteerOppObjList { get; set; }

	//Constructor
    public VolunteerOpportunityClass() 
    {
    	getHP_VolunteerOppObjListFromProfileObj();
       
    }//End Constructor
    
	//Get custom setting object from sub-community
    public list<HP_Volunteer_Opportunity__c> getHP_VolunteerOppObj(String subCommunity)
    {
    	 HP_VolunteerOppObjList = new list<HP_Volunteer_Opportunity__c>();
    	 
    	 if(subCommunity != NULL){
             HP_VolunteerOppObjList = [SELECT Image_Link__c,Image_Url__c,Sub_Community__c 
             				  	  FROM HP_Volunteer_Opportunity__c
             				      WHERE Sub_Community__c=:subCommunity];
    	}
        return HP_VolunteerOppObjList;
    }
    
    //Method which calls all the other methods to get volunteer custom settings from profile 
    public void getHP_VolunteerOppObjListFromProfileObj(){
    	HP_VolunteerOppObjList = new list<HP_Volunteer_Opportunity__c>();

        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_VolunteerOppObjList = getHP_VolunteerOppObj(subCommunity);
    }//End Method
}