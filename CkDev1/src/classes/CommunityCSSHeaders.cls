public with sharing class CommunityCSSHeaders {

	public static Final String FLETCHER_DOC_DEV_NAME = 'Static_Comm_Header_Fletcher';
	public static Final String TUFTS_DOC_DEV_NAME = 'Static_Comm_Header_Tufts';

	public String userCommunity {get; set;}
	public String headerType {get; set;}

	public CommunityCSSHeaders() 
	{
		
	}

	public String getHeadersType()
	{
		headerType = '';
		userCommunity = getUserCommunityType();
		if(userCommunity=='Tufts University')
		{
			headerType = 'tufts';
		}
		else if(userCommunity=='The Fletcher School of Law and Diplomacy')
		{
			headerType = 'flethcer';
		}
		return headerType;
	}
	
	public String getUserCommunityType()
	{
		User u = [SELECT id, ContactId FROM User WHERE id = :UserInfo.getUserId()];
		Contact c = [select Id, Community_Experience_selected__c from Contact where Id=:u.ContactId];
		
		return c.Community_Experience_selected__c;	
	}
	
	/*public String getFletcherDocumentBody()
	{
		Document doc = queryDocumentByDevName(FLETCHER_DOC_DEV_NAME);
		return doc.Body.toString();
	}

	public String getTuftsDocumentBody()
	{
		Document doc = queryDocumentByDevName(TUFTS_DOC_DEV_NAME);
		return doc.Body.toString();
	}

	public Document queryDocumentByDevName(String docDevName)
	{
		Document doc = [select Body FROM Document WHERE DeveloperName=:docDevName limit 1];
		return doc;
	}*/
	
}