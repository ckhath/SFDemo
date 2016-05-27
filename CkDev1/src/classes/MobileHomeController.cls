/*
	Created By 				Created Date
	Sophak Phou				16 Feb 2015
*/
public class MobileHomeController {
	public list<Mobile_HP__c> HP_MobileComponentobjList { get; set; }
	public Integer HP_MobileComponentobjListCount { get; set; }
	public HP_Header__c HP_HeaderObj { get; set; }
	
	//Constructor
	public MobileHomeController(){
		init();
		FetchMobileComponentList();
		
		UserUtils u = new UserUtils();
		String subCommunity = u.getSubCommunityName();
		HP_HeaderObj = getHeaderObj(subCommunity);
	}//End Constructor
	
	//Method to get Mobile Home Page Component Data from the Custom settings
	public list<Mobile_HP__c> getHP_MobileComponentobjList(){
		list<Mobile_HP__c> HP_MobileComponentList = new list<Mobile_HP__c>();
		HP_MobileComponentList = [SELECT Field_Title__c,
		 									 Image_URL__c,
		 									 Link_URL__c,
		 									 Hex_Color__c,
		 									 Font_Color__c
        							  FROM Mobile_HP__c
        							  ORDER BY Order__c
        							 ];
		return HP_MobileComponentList;
	}//End Method
	

	//Initializing Data Members
	public void init(){
		HP_MobileComponentobjList = new list<Mobile_HP__c>();
	}//End Method
	
	//Method to get mobile components from Custom setiings 
	public void FetchMobileComponentList(){
		HP_MobileComponentobjList = getHP_MobileComponentobjList();
		HP_MobileComponentobjListCount = HP_MobileComponentobjList.size();
	}//End Method

	public HP_Header__c getHeaderObj(String subCommunity)
	{
		HP_Header__c headerObj = new HP_Header__c();
		list<HP_Header__c> headerObjs = [select Image_URL__c, Sub_Community__c,mobile__c 
			from HP_Header__c where Sub_Community__c=:subCommunity];
		if(headerObjs.size() > 0)
		{
			for(HP_Header__c objHeader : headerObjs){
				if(objHeader.mobile__c){ //If mobile is checked
					headerObj = objHeader;
				}//End If
			}//End For
		}//End If
		return headerObj;
	}
}