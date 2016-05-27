public with sharing class EventRegistrationClass {
public list<HP_Event_Registration__c> HP_EventRegistrationObjList { get; set; }

	//Constructor
    public EventRegistrationClass() 
    {
    	getHP_EventRegFromProfileObj();
       
    }//End Constructor

	//Get custom setting object from sub-community
    public list<HP_Event_Registration__c> getHP_EventRegObj(String subCommunity)
    {
    	 HP_EventRegistrationObjList = new list<HP_Event_Registration__c>();
    	 
    	 if(subCommunity != NULL){
             HP_EventRegistrationObjList = [SELECT Image_Link__c,Image_Url__c,Sub_Community__c 
             				  	  FROM HP_Event_Registration__c
             				      WHERE Sub_Community__c=:subCommunity];
    	}
        return HP_EventRegistrationObjList;
    }
    
    //Method which calls all the other methods to get Picture custom settings from profile 
    public void getHP_EventRegFromProfileObj(){
    	HP_EventRegistrationObjList = new list<HP_Event_Registration__c>();

        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_EventRegistrationObjList = getHP_EventRegObj(subCommunity);
    }//End Method
}