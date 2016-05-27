public class HP_Chatter {

	public String chatterId {get; set;}

	public HP_Chatter() 
	{
		chatterId = userinfo.getUserId();
		UserUtils u = new UserUtils();
		String subCommunity = u.getSubCommunityName();
		if(subCommunity!=null)
		{
			chatterId = getGroupId(subCommunity);
		}
	}

	public String getGroupId(String subCommunity)
	{
		list<HP_ChatterFeed__c> chatterFeedList = [select GroupId__c, Sub_Community__c 
			from HP_ChatterFeed__c where Sub_Community__c=:subCommunity];
		String groupId = userinfo.getUserId();
		if(chatterFeedList.size()>0)
		{
			groupId = chatterFeedList[0].GroupId__c;
		}
		return groupId;
	}
}