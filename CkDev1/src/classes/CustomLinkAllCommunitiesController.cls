public class CustomLinkAllCommunitiesController 
{
    /*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Andrew Mann
    Created Date: July 28, 2015
    Description: Controller class used to pull data from custom settings
        and display as a custom link on homepage.
    -----------------------------------------------------------------------*/

    public list<HP_Custom_Link_All_Communities__c> HP_Custom_Link { get; set; }

    //Constructor
    public CustomLinkAllCommunitiesController() 
    {
        HP_Custom_Link = getHP_CustomLink();
    }
    
    //Get custom setting object from sub-community
    public list<HP_Custom_Link_All_Communities__c> getHP_CustomLink()
    {
        HP_Custom_Link = new list<HP_Custom_Link_All_Communities__c>(); 
        HP_Custom_Link = [SELECT Link_Text__c,Link_URL__c,Link_Behavior__c,Sub_Community__c,Order__c  
                FROM HP_Custom_Link_All_Communities__c ORDER BY Order__c NULLS Last];     
        return HP_Custom_Link;
    }//End Method
}