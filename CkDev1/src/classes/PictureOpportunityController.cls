/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: June 2, 2015
    Description: Controller class used to pull data from custom settings
        and display Image on homepage.
-----------------------------------------------------------------------*/

public with sharing class PictureOpportunityController {
public list<HP_Picture_Volunteer_Opportunty__c> HP_OppObjList { get; set; }

	//Constructor
    public PictureOpportunityController() 
    {
    	getHP_OppObjListFromProfileObj();
       
    }//End Constructor
    
	//Get custom setting object from sub-community
    public list<HP_Picture_Volunteer_Opportunty__c> getHP_Opp_Obj(String subCommunity){
   		 HP_OppObjList = new list<HP_Picture_Volunteer_Opportunty__c>();
    	 list<HP_Picture_Volunteer_Opportunty__c> HP_OppListTemp = new list<HP_Picture_Volunteer_Opportunty__c>();
    	 if(subCommunity != NULL){
             HP_OppObjList = [SELECT Image_Link__c,Image_Url__c,Sub_Community__c 
             				  	  FROM HP_Picture_Volunteer_Opportunty__c
             				      WHERE Sub_Community__c=:subCommunity];     
    	}
        return HP_OppObjList;
    }//End Method
    
    //Method which calls all the other methods to get volunteer custom settings from profile 
    public void getHP_OppObjListFromProfileObj(){
    	HP_OppObjList = new list<HP_Picture_Volunteer_Opportunty__c>();
        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_OppObjList = getHP_Opp_Obj(subCommunity);
    }//End Method
}//End Class