/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: June 3, 2015
    Description: Controller class used to pull data from custom settings
        and display as a custom link on homepage.
-----------------------------------------------------------------------*/
public with sharing class CustomLinkControllerLeftRail {
public list<HP_Custom_Link_Left_Rail__c> HP_Custom_Link_LeftRail { get; set; }

    //Constructor
    public CustomLinkControllerLeftRail() 
    {
        getHP_CustomLinkLeftRailObj();
       
    }//End Constructor
    
    //Get custom setting object from sub-community
    public list<HP_Custom_Link_Left_Rail__c> getHP_CustomLinkLeftRail(String subCommunity){
         HP_Custom_Link_LeftRail = new list<HP_Custom_Link_Left_Rail__c>();
         
         if(subCommunity != NULL){
             HP_Custom_Link_LeftRail = [SELECT Link_Text__c,Link_URL__c,Link_Behaviour__c,Sub_Community__c,Order__c
                                  FROM HP_Custom_Link_Left_Rail__c
                                  WHERE Sub_Community__c=:subCommunity ORDER BY Order__c NULLS Last];     
        }
        return HP_Custom_Link_LeftRail;
    }//End Method
    
    //Method which calls all the other methods to get volunteer custom settings from profile 
    public void getHP_CustomLinkLeftRailObj(){
        HP_Custom_Link_LeftRail = new list<HP_Custom_Link_Left_Rail__c>();
        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_Custom_Link_LeftRail = getHP_CustomLinkLeftRail(subCommunity);
    }//End Method
}//End Class