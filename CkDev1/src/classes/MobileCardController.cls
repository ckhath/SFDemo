/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: August 13,2015
    Description: Controller class used to get Custom Setting records Mobile Card
                         and display on the Page.
-----------------------------------------------------------------------*/

public with sharing class MobileCardController {
    public list<Mobile_Card__c> lstMobileCardComponent { get; set; }
    
    public MobileCardController(ApexPages.StandardController stdController) 
    {
        init();
        FetchMobileCardComponentList();
    }
    
    //Initializing Data Members
    public void init(){
        lstMobileCardComponent = new list<Mobile_Card__c>();
    }//End Method
    
    //Method to get mobile card component from Custom setiings 
    public void FetchMobileCardComponentList(){
        lstMobileCardComponent = getMobileCardComponentList();
        System.debug('>>>>>lstMobileCardComponent' + lstMobileCardComponent);
    }//End Method
    
    //Method to get Mobile Card Component Data from the Custom settings
    public list<Mobile_Card__c> getMobileCardComponentList(){
        list<Mobile_Card__c> MobileCardComponentList = new list<Mobile_Card__c>();
        MobileCardComponentList = [SELECT Link__c, 
                                   Title__c,
                                   Label__c
                                   FROM Mobile_Card__c
                                   ORDER BY Sort_By__c ASC NULLS LAST];
         system.debug('%%%% MobileCardComponentList'+MobileCardComponentList);
        return MobileCardComponentList;
    }//End Method
}