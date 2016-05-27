/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: December 11, 2015
    Description: Controller class used to pull data from custom settings
        and display as a custom link on homepage.
-----------------------------------------------------------------------*/
public with sharing class CustomLinkControllerLeftRail3 {

    public list<HP_Custom_Link_Left_Rail_3__c> HP_Custom_Link_LeftRail3 { get; set; }

    //Constructor
    public CustomLinkControllerLeftRail3() 
    {
      getHP_CustomLinkLeftRail3Obj();
       
    }//End Constructor
    
    //Get custom setting object from sub-community
    public list<HP_Custom_Link_Left_Rail_3__c> getHP_CustomLinkLeftRail3(String subCommunity){
        HP_Custom_Link_LeftRail3 = new list<HP_Custom_Link_Left_Rail_3__c>();
       
       if(subCommunity != NULL){
             HP_Custom_Link_LeftRail3 = [SELECT Link_Text__c,Link_URL__c,Link_Behaviour__c,Sub_Community__c,Order__c 
                           FROM HP_Custom_Link_Left_Rail_3__c
                           WHERE Sub_Community__c=:subCommunity ORDER BY Order__c NULLS Last];     
      }
        return HP_Custom_Link_LeftRail3;
    }//End Method
    
    //Method which calls all the other methods to get volunteer custom settings from profile 
    public void getHP_CustomLinkLeftRail3Obj(){
      HP_Custom_Link_LeftRail3 = new list<HP_Custom_Link_Left_Rail_3__c>();
        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        HP_Custom_Link_LeftRail3 = getHP_CustomLinkLeftRail3(subCommunity);
    }//End Method
}//End Class