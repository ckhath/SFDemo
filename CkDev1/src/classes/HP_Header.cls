public class HP_Header {

	public HP_Header__c HP_HeaderObj { get; set; }
	
	//constructor
	public HP_Header()
	{
		UserUtils u = new UserUtils();
		String subCommunity = u.getSubCommunityName();
		HP_HeaderObj = getHeaderObj(subCommunity);
	}//End constructor

	//method to fetch header information from custom setting
	public HP_Header__c getHeaderObj(String subCommunity)
	{
		HP_Header__c headerObj = new HP_Header__c();
		list<HP_Header__c> headerObjs = [select Image_URL__c, Sub_Community__c,mobile__c 
			from HP_Header__c where Sub_Community__c=:subCommunity];
		if(headerObjs.size() > 0)
		{
			for(HP_Header__c objHeader : headerObjs){
				if(!objHeader.mobile__c){ //If mobile is checked
					headerObj = objHeader;
				}//End If
			}//End For
		}//End If
		return headerObj;
	}//End method
}