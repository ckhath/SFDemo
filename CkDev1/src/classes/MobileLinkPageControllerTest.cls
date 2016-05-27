@istest
public with sharing class MobileLinkPageControllerTest {
    public static testmethod void testMobileLinkController(){
       //Test without creating custom setting data
        MobileLinkPageController mobController = new  MobileLinkPageController();
        Boolean boolMap = false;
        for(HP_Mobile_Links__c objMobLink: HP_Mobile_Links__c.getAll().values()){
            if(mobController.mapMobLink.containsKey(objMobLink)){
                boolMap = true;
            }
        }
        system.assertequals( boolMap ,false);
       
        boolMap = false;
        //Test after creating custom setting data
        TestDataFactoryClass.AddMobileLinkSettingData();
        MobileLinkPageController mobController1 = new  MobileLinkPageController();
     
        for(HP_Mobile_Links__c objMobLink: HP_Mobile_Links__c.getAll().values()){
            if(mobController1.mapMobLink.containsKey(objMobLink)){
                boolMap = true;
            }
        }
        system.assertequals( boolMap ,true);
    }//End testmethod
}//End class