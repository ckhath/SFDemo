/*-----------------------------------------------------------------------
	ACF Solutions
	Created By: Siddharth Pandit
	Created Date: Feb 10, 2015
	Description: Controller class used to pull data from custom settings 
		and display carousel photos on homepage.
-----------------------------------------------------------------------*/

public class HP_Picture {
    public list<HP_Pictures__c> HP_PictureObjList { get; set; }

	//Constructor
    public HP_Picture() 
    {
    	getHP_PictureFromProfileObj();
       
    }//End Constructor

	//Get custom setting object from sub-community
    public list<HP_Pictures__c> getHP_PictureObj(String subCommunity)
    {
    	 HP_PictureObjList = new list<HP_Pictures__c>();
    	 
    	 if(subCommunity != NULL){
             HP_PictureObjList = [SELECT Logo_URL__c, Sub_Community__c 
             				  	  FROM HP_Pictures__c
             				      WHERE Sub_Community__c=:subCommunity];
    	}
        return HP_PictureObjList;
    }
    
    //Method which calls all the other methods to get Picture custom settings from profile 
    public void getHP_PictureFromProfileObj(){
    	HP_PictureObjList = new list<HP_Pictures__c>();

        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_PictureObjList = getHP_PictureObj(subCommunity);
    }//End Method
}