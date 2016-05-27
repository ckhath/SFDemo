/*-----------------------------------------------------------------------
    ACF Solutions
    Created By: Siddharth Pandit
    Created Date: June 11, 2015
    Description: Generic Controller class which will dynamically return the results
                 based on input parametrs
                     
-----------------------------------------------------------------------*/


public with sharing class UtilityGeneral {
    public static final String COMMA = ',';
    public static final String NAMESPACE = '';
    public static final String UTF_EIGHT = 'UTF-8';
    public static final String APEX = 'apex';
    public static final String BACK_SLASH = '/';
    public static final String SINGLE_QUOTES = '';
    public static final String PERCENT_THREE_F = '%3F';
    public final static String PAGE_NAME = 'PageName__c';
    public final static String PAGE_NUMBER = 'PageNumber__c';

    //Generic mehod to construct dynamic query
    public static String construcuDynamicQueryforFields(list<Sobject> pLstCustomSettingFields, String pObjectName, String pFieldName, String pStaticWhere, String pLimit)
    {
        String queryFields='';
        list<String> lstQueryFields = new list<String>();
        /*integer countVar = 0;
        for(Sobject objCustomSetting : pLstCustomSettingFields){
            if(countVar == 0){
                queryFields = queryFields + objCustomSetting.get(pFieldName);
                countVar++;
            }
            else{
                queryFields = queryFields + COMMA + objCustomSetting.get(pFieldName);
                countVar++;
            }
            
            
        }//End for*/
        
        for(Sobject objCustomSetting : pLstCustomSettingFields){
            lstQueryFields.add(String.valueOf(objCustomSetting.get(pFieldName)));
            system.debug('$$$$ lstQueryFields'+lstQueryFields);
        }//End For
        
        if(!lstQueryFields.isEmpty())
            queryFields = String.join(lstQueryFields,',');
        
        system.debug('********queryFields : ' + queryFields );
        
        if(queryFields != ''){
            queryFields = 'SELECT ' + queryFields + ' from ' + pObjectName;
             system.debug('%%% queryFields : ' + queryFields );
        }

        if(pStaticWhere!='' && pStaticWhere!=null)
        {
            queryFields = queryFields + ' where ' + pStaticWhere;
             system.debug('&^% queryFields : ' + queryFields );
        }
        
        queryFields = queryFields + ' ORDER BY CreatedDate desc';
        
        if(pLimit!='' && pLimit!=null)
        {
            queryFields = queryFields + ' limit ' + pLimit;
             system.debug('!@# queryFields : ' + queryFields );
        }
        

        return queryFields;
    }//End method
    
    //Method to retrieve data based on Query
    public static list<Sobject> getObjectRecords(String pQuery){
        return database.query(pQuery);
    }//End Method
    
    /*//Method to get next page from the custom setting and generate Url accordingly. 
    public static String redirectionToNextPage(){
        map<integer, String> mapPageDetails = new map<integer, String>();
        integer pageNumber = 0 ;
        String page_url = '';
        ProfileDomainName__c Domain_Name = UtilityGeneral.getProfileDomainName();
        //page_url = Domain_Name.DomainName__c + '/HP_CommunityOptIn';
        list<Sobject> lstLoginFlow = LoginFlowCustomSetting__c.getall().values();
        mapPageDetails = UtilityGeneral.getRedirectionPageDetails(lstLoginFlow,'PageNumber__c', 'PageName__c');
        if(mapPageDetails!=null){
            //Get the current page number
            for(integer i = 0 ; i < lstLoginFlow.size(); i++){
                if(String.valueOf(lstLoginFlow[i].get('PageName__c')).equalsIgnoreCase(pCurrentPageName)){
                    pageNumber = integer.valueOf(lstLoginFlow[i].get('PageNumber__c'));
                }//End If
            }//End For
            pageNumber +=1;
            //Check for next PageNumber
            if(pageNumber !=0 && mapPageDetails.containsKey( pageNumber)){
                page_url = '/' + Domain_Name.DomainName__c +'/' + mapPageDetails.get(pageNumber);
            }//End If
            else{
                //page_url = '/' + Domain_Name.DomainName__c +'/home/home.jsp'; 
                //if(!String.isBlank(ApexPages.currentPage().getParameters().get('PageName'))){
                    //page_url = '/' + Domain_Name.DomainName__c +'/'+String.isBlank(ApexPages.currentPage().getParameters().get('PageName'));
                //}
                page_url = null;
            } //End Else
            
        }//End If
            //return UtilityGeneral.redirect(page_Url, true);
            return page_url;
   }//End Method*/
   
   //Method to get next page from the custom setting and generate Url accordingly. 
    public static map<integer, Sobject> getRedirectionPageInfo(){
        
        ProfileDomainName__c Domain_Name = UtilityGeneral.getProfileDomainName();
        list<Sobject> lstLoginFlow = LoginFlowCustomSetting__c.getall().values();
        map<integer, Sobject> mapPageInfo = UtilityGeneral.getRedirectionPageDetails(lstLoginFlow,'PageNumber__c', 'PageName__c');
        return mapPageInfo;
   }//End Method
    
    //Method which returns order wise records 
    public static list<Sobject> getOrderwiseFields(list<Sobject> pCustomSettingRecords,String customSettingOrderFieldName){
        map<Integer, Sobject> mapOrderedCustomSetting = new map<Integer, Sobject>();
        list<Sobject> lstCustomSettingOrderFields = new list<Sobject>();
        for(Sobject objRecord : pCustomSettingRecords){
            mapOrderedCustomSetting.put(integer.valueOf(objRecord.get(customSettingOrderFieldName)),objRecord);
            system.debug('### mapOrderedCustomSetting'+mapOrderedCustomSetting);
        }//End For
        for(integer i = 1 ; i <= mapOrderedCustomSetting.size() ; i++){
            lstCustomSettingOrderFields.add(mapOrderedCustomSetting.get(i)); 
        }//End For
        return lstCustomSettingOrderFields;
    }//End method
    
    //Method which redirects to particular Url 
    public static Pagereference redirect(String redirectUrl, boolean setRedirect){
        Pagereference pageRef;
        if(String.isBlank(redirectUrl)){
            return null;
        }
        else{
            pageRef = new Pagereference(redirectUrl);
            pageRef.setRedirect(setRedirect);
            return pageRef;
        }
    }//End method
    
    //Method to get Contact Id of logged in User
    public static String getContactIdFromUser(String pUserId){
        List<User> lstUser = [select ContactId from User where id =: pUserId limit 1];
        if (lstUser.size()>0 && lstUser[0].ContactId != null) {
            return lstUser[0].ContactId;
        }
        return null;
    }//End method
    
    //Method which generates Dynamic Query for Object
    public static String constructQueryForObject(String pFieldSetName, String pObjectName){
        String queryFields='';
        //integer countVar = 0;
        list<String> lstQueryFields = new list<String>();
        
         List<Schema.FieldSetMember> fieldSetMemberList = readFieldSet(pFieldSetName, pObjectName);
         /*
         for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList){
             if(countVar == 0){
                 system.debug('*****fieldSetMemberObj.getFieldPath()' + fieldSetMemberObj.getFieldPath());
                 queryFields = queryFields + string.valueOf(fieldSetMemberObj.getFieldPath());
                 countVar++;
             }//End If
             else{
                 queryFields = queryFields + COMMA + string.valueOf(fieldSetMemberObj.getFieldPath());
                 countVar++;
             }//End else
         }//End For
         */
         for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList){
            lstQueryFields.add(string.valueOf(fieldSetMemberObj.getFieldPath()));
         }//End For
         
         if(!lstQueryFields.isEmpty())
            queryFields = String.join(lstQueryFields, ',');
         //End If
         system.debug('*****queryFields' + queryFields);
         return queryFields;
    }//End method
    
    //Method to read Field set values
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName){
        system.debug('*****fieldSetMemberList' + fieldSetName);
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        system.debug('*****SObjectTypeObj' + SObjectTypeObj);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
    
        system.debug('====>' + DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName));
    
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        system.debug('====>###' + fieldSetObj);
        //List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
        system.debug('fieldSetMemberList ====>' + fieldSetObj.getFields());  
        return fieldSetObj.getFields(); 
    }//End method  
    
    //Method to fetch Community Domain Name
    public static ProfileDomainName__c getProfileDomainName(){
        ProfileDomainName__c profileDomain;
        if(ProfileDomainName__c.getall().values() == null){
            return null;
        }
        profileDomain = ProfileDomainName__c.getall().values().get(0);
        return profileDomain;
    }//End method 
    
    //Method to return map of page name with page number
    public static map<integer, Sobject> getRedirectionPageDetails(list<Sobject> pFlowCustomsetting, String pPageNumber, String pPageName){
        map<integer,Sobject> mapPageNamePageNumber = new map<integer, Sobject>();
        if(pFlowCustomsetting == null){
            return null;
        }
        
        for(integer i = 0 ; i < pFlowCustomsetting.size() ; i++){
            system.debug('****pFlowCustomsetting' + pFlowCustomsetting[i]);
            mapPageNamePageNumber.put(integer.valueOf(pFlowCustomsetting[i].get(pPageNumber)), pFlowCustomsetting[i]);
        }
        return mapPageNamePageNumber;
    }//End Method
    
    //Method to return Web content record based on the page name
    public static Community_Web_Content__c getWebContent(String pPageUrl) {
        /*system.debug('\n\n\n'+pageName+'\n\n\n');
        pageName = pageName.replaceFirst('/apex/','');
        system.debug('\n\n\n'+pageName+'\n\n\n');
        //pageName = pageName.substringAfter('__');
        //system.debug('\n\n\n'+pageName+'\n\n\n');
        pageName = EncodingUtil.urlEncode(pageName, 'UTF-8'); 
        system.debug('\n\n\n'+pageName+'\n\n\n');
        pageName = pageName.substringBefore('%3F');
        system.debug('\n\n\n'+pageName+'\n\n\n');
        pageName = pageName.replace('acfComm__', 'acfcomm__');
        system.debug('\n\n\n'+pageName+'\n\n\n');
        pageName = pageName.replace('acfcomm__', '');
        system.debug('\n\n\n'+pageName+'\n\n\n'); */
        return retriveWebContent (getPageNameFromUrl(pPageUrl));
    }
    
    //Methotd to return page name from the Url
     public static String  getPageNameFromUrl(String pPageUrl) {
        if(!String.isBlank(pPageUrl)){
            pPageUrl = pPageUrl.replaceFirst( BACK_SLASH + APEX + BACK_SLASH, SINGLE_QUOTES);
            pPageUrl = EncodingUtil.urlEncode(pPageUrl, UTF_EIGHT); 
            pPageUrl = pPageUrl.substringBefore(PERCENT_THREE_F);
            pPageUrl = pPageUrl.toLowerCase().replace(NAMESPACE.toLowerCase(), SINGLE_QUOTES);
            pPageUrl = pPageUrl.replace(NAMESPACE, SINGLE_QUOTES);
            system.debug('$$$$ pPageUrl '+pPageUrl);
        }
        return pPageUrl;
    }

    //Method to get web content record based on page name
    public static Community_Web_Content__c retriveWebContent (String pPageName) {
        list<Community_Web_Content__c> cwcList = new list<Community_Web_Content__c>();
        if (pPageName == null) {
            return null;
        }else{
            cwcList = [SELECT  Content__c, Page_Content__c
                    FROM    Community_Web_Content__c
                    WHERE   Name = :pPageName
                    LIMIT   1];
        }
        if(cwcList.size()>0)
        {
            return cwcList[0];
        }
        else
        {
            return null;
        }
    }
    
    
    //Get Page details from custom setting.
    public static Sobject getNextPageDetails(map<integer, Sobject> pMapPageInfo, String pCurrentPageName){
    list<Sobject> lstCustomFlowSetting = pMapPageInfo.values();
    Sobject objSetting;
    for(Sobject objCustomSetting : lstCustomFlowSetting)
    {
        if(String.valueOf(objCustomSetting.get(PAGE_NAME)).equalsIgnoreCase(pCurrentPageName))
        {
            if(pMapPageInfo.containskey(integer.valueOf(objCustomSetting.get(PAGE_NUMBER)) + 1))
            {
                return pMapPageInfo.get(integer.valueOf(objCustomSetting.get(PAGE_NUMBER)) + 1);
            }  
        }
    }
       return objSetting;
   }
}//End class