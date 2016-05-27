public class CommunityContentHelper {
    public static String getContent(String webContentString)
    {
        String returnStr = '';
        List<String> splitPair = webContentString.split('[.]', 2);
        String obj = splitPair[0];
        String recordName = splitPair[1];

        String queryStr = 'Select content__c , Page_Content__c from ' + obj + ' where name=\'' + recordName + '\'';
        system.debug('\n\n\n'+queryStr+'\n\n\n');

        list<sObject> objs = Database.query(queryStr);

        if(objs.size()>0)
        {
            if(objs[0].get('Page_Content__c') != null && (!String.isBlank(String.valueOf(objs[0].get('Page_Content__c'))))){
                returnStr = String.valueOf(objs[0].get('Page_Content__c'));
            }
            else if(objs[0].get('content__c') != null && (!String.isBlank(String.valueOf(objs[0].get('content__c'))))){
                returnStr = String.valueOf(objs[0].get('content__c'));
            }
        }

        return returnStr;
    }
}