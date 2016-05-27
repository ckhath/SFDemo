/*-----------------------------------------------------------------------
    ACF Solutions
    Created By : Siddharth Pandit
    Description: Controller class used to pull data from custom settings
                 and display sections on the profile page.
                 
-----------------------------------------------------------------------*/
public with sharing class MobileLinkPageController {
    
   public Map<sobject,List<Sobject>> mapMobLink {get;set;}   
    
    //Constructor
    public  MobileLinkPageController ()
    {
        init();    
        getUserInfo();
    }

    //Method call from constructor to initialize the variables and lists and maps
    public void init()
    {
        String subCommunity = getUserInfo();
        mapMobLink = new Map<sobject,List<Sobject>>();
        for(HP_Mobile_Links__c objMobLink: HP_Mobile_Links__c.getAll().values()){
            if(!String.isBlank(objMobLink.Custom_Setting__c)){
                //Main custom setting reffers related custom setting records which results query inside for loop.
                mapMobLink.put(objMobLink,getCustomSetLinkRec(objMobLink.Custom_Setting__c, subCommunity)); 
            }            
        }    
    }
    
    public String getUserInfo()
    {
         UserUtils u = new UserUtils();
         String subCommunity = u.getSubCommunityName();  
         system.debug('++++++++subCommunity ++++++++'+subCommunity );
         return subCommunity ;
    }
   
    // Method is used to query the custom setting for getting the link urls
    public List<Sobject> getCustomSetLinkRec (String objName, String pSubcommunity){    
         
         if(!String.isBlank(objName)){
        
            String Query = 'Select Name,Link_Text__c,Link_URL__c,Sub_Community__c  From ' + objName+' Where Sub_Community__c = :pSubcommunity';
            return database.query (Query);
            
        }
        else{
            return null;
        }
    }

}