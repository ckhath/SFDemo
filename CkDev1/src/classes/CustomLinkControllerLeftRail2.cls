/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: December 11, 2015
    Description: Controller class used to pull data from custom settings
        and display as a custom link on homepage.
-----------------------------------------------------------------------*/
public with sharing class CustomLinkControllerLeftRail2 {

    public list<HP_Custom_Link_Left_Rail_2__c> HP_Custom_Link_LeftRail2 { get; set; }

    //Constructor
    public CustomLinkControllerLeftRail2() 
    {
        getHP_CustomLinkLeftRail2Obj();
       
    }//End Constructor
    
    //Get custom setting object from sub-community
    public list<HP_Custom_Link_Left_Rail_2__c> getHP_CustomLinkLeftRail2(String subCommunity){
        HP_Custom_Link_LeftRail2 = new list<HP_Custom_Link_Left_Rail_2__c>();
       
       if(subCommunity != NULL){
             HP_Custom_Link_LeftRail2 = [SELECT Link_Text__c,Link_URL__c,Link_Behaviour__c,Sub_Community__c,Order__c 
                           FROM HP_Custom_Link_Left_Rail_2__c
                           WHERE Sub_Community__c=:subCommunity ORDER BY Order__c NULLS Last];     
      }
        return HP_Custom_Link_LeftRail2;
    }//End Method
    
    //Method which calls all the other methods to get volunteer custom settings from profile 
    public void getHP_CustomLinkLeftRail2Obj(){
      HP_Custom_Link_LeftRail2 = new list<HP_Custom_Link_Left_Rail_2__c>();
        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_Custom_Link_LeftRail2 = getHP_CustomLinkLeftRail2(subCommunity);
    }//End Method
}//End Class