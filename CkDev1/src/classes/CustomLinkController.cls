/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: June 3, 2015
    Description: Controller class used to pull data from custom settings
        and display as a custom link on homepage.
-----------------------------------------------------------------------*/

public with sharing class CustomLinkController {

public list<HP_Custom_Link__c> HP_Custom_Link { get; set; }

    //Constructor
    public CustomLinkController() 
    {
        getHP_CustomLinkObj();
       
    }//End Constructor
    
    //Get custom setting object from sub-community
    public list<HP_Custom_Link__c> getHP_CustomLink(String subCommunity){
         HP_Custom_Link = new list<HP_Custom_Link__c>();
         
         if(subCommunity != NULL){
             HP_Custom_Link = [SELECT Link_Text__c,Link_URL__c,Link_Behaviour__c,Sub_Community__c,Order__c
                                  FROM HP_Custom_Link__c
                                  WHERE Sub_Community__c=:subCommunity ORDER BY Order__c ASC NULLS Last];     
        }
        return HP_Custom_Link;
    }//End Method
    
    //Method which calls all the other methods to get volunteer custom settings from profile 
    public void getHP_CustomLinkObj(){
        HP_Custom_Link = new list<HP_Custom_Link__c>();
        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_Custom_Link = getHP_CustomLink(subCommunity);
    }//End Method
}//End Class