public class DirectorySearch {

    public list<sObject> dsFields {get; set;}
    public String inputFieldsHTML {get; set;}
    public DirectorySearch_Pagination_Fields__c settingPaginationDetails{get; set;}
    public ProfileDomainName__c profileDomainCustomSetting {get; set;}
    public String profileDomain{ get; set; }
    public String jsonDomainName { get; set; }
    public String jsonStrPageDetails {get; set;}
    public WarpperPaginationDetails WrappPageDetails{get;set;}
    //public list<wrapperContact> lstContact{get; set;}
    public String directoryUrlParams{get; set;}
    public Community_Web_Content__c communityWebContent{get; set;}
    public Decimal perPageRecords{get; set;}
    
    //Constructor
    public DirectorySearch() 
    {
        list<sObject> allDsFields = new list<sObject>();
        dsFields = queryCustomSetting();
        allDsFields.addall(dsFields);
        //inputFieldsHTML = createInputFieldsHTML(dsFields);

        UserUtils u = new UserUtils();
        String subCommunity = u.getSubCommunityName();
        String objName = createObjName(subCommunity);
        // If obj name directory_search_subcommunityname__c exists 
        // Add sub community input fields
        if(doesObjectExist(objName))
        {
            list<sObject> subCommunityCustomSetting = querySubCommunityCustomSetting(objName);
            //String subSectionInputFieldsHTML = createInputFieldsHTML(subCommunityCustomSetting);
            allDsFields.addall(subCommunityCustomSetting);
            //inputFieldsHTML = inputFieldsHTML + subSectionInputFieldsHTML;
        }
        
        if(DirectorySearch_Pagination_Fields__c.getall().values() != null){
            settingPaginationDetails = DirectorySearch_Pagination_Fields__c.getall().values().get(0);
            WrappPageDetails = new WarpperPaginationDetails();
            WrappPageDetails.perPageSize = settingPaginationDetails.Per_Page_Pagesize__c;
            WrappPageDetails.perPageRecords = settingPaginationDetails.Per_Page_Records__c;
            perPageRecords = settingPaginationDetails.Per_Page_Records__c;
            system.debug('\n\n\n perPageRecords: '+string.valueof(integer.valueOf(perPageRecords))+'\n\n\n');
            WrappPageDetails.sortingParameters = settingPaginationDetails.sortingParameters__c;
            
            jsonStrPageDetails = JSON.serialize(WrappPageDetails);
            profileDomainCustomSetting = UtilityGeneral.getProfileDomainName();
            profileDomain = profileDomainCustomSetting.DomainName__c;
        }
        inputFieldsHTML = createInputFieldsHTML(allDsFields);
        
        //Contact list for geo mapping
        //getContactList();
        
        //Static section
        communityWebContent = new Community_Web_Content__c();
        communityWebContent = UtilityGeneral.getWebContent(ApexPages.CurrentPage().getUrl());
    }

    public String createObjName(String subCommunityName)
    {
        String objName = 'directory_search_'+subCommunityName+'__c';
        return objName;
    }

    public Boolean doesObjectExist(String objName)
    {
        Boolean objExist = false;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objSchema = schemaMap.get(objName);
        if(objSchema!=null)
        {
            objExist = true;
        }
        return objExist;
    }

    public list<Directory_Search_Fields__c>  queryCustomSetting()
    {
        return [select Id, Name, Field_Label__c, Field_Name__c, Field_Order__c, Section_Label__c, 
            Section_Order__c, Field_Type__c, Picklist_Values__c 
            from Directory_Search_Fields__c order by Section_Order__c, Field_Order__c];
    }

    public list<sObject> querySubCommunityCustomSetting(String objName)
    {
        String queryString = 'select Id, Name, Field_Label__c, Field_Name__c, Field_Order__c, Section_Label__c, Section_Order__c, Field_Type__c, Picklist_Values__c'
            + ' from ' + objName + ' order by Section_Order__c, Field_Order__c';
        list<sObject> subCommunityCustomSetting = Database.query(queryString);
        return subCommunityCustomSetting;
    }

    public String createFieldHTML(String fieldType, String fieldName, String fieldLabel, String pickListValues)
    {
        String html = '';
        if(fieldType=='picklist')
        {
            html = '<div class="ds_inputFieldWrapper"><div class="ds_inputField">'; 
            html = html + '<select class="ds_selectlist" id="'+fieldName+'" name="'+fieldName+'">';
            html = html + '<option value="">'+fieldLabel+'</option>';
            for(String value : pickListValues.split(';'))
            {
                html = html + '<option value="'+value+'">'+value+'</option>';
            }
            html = html + '</select></div></div>';
        }
        else if(fieldType=='checkbox')
        {
            html = '<div class="ds_inputFieldWrapper"><div class="ds_inputField"><input id="'+fieldName+'" type="checkbox" name="'+fieldName+'" /><span class="ds_inputFielLabel">'+fieldLabel+'</span></div></div>';
        }
        else
        {
            html = '<div class="ds_inputFieldWrapper"><div class="ds_inputField"><input id="'+fieldName+'" class = "' + fieldType + '" type="text" name="'+fieldName+'" placeholder="'+fieldLabel+'"/></div></div>';
        }

        return html;
    }

    public String createInputFieldsHTML(list<sObject> fields)
    {
        
        String html = '';
        Boolean firstTime = true;
        Boolean firstSection = true;
        String oldSectionOrder = '';
        for(sObject field : fields)
        {
            String picklistValuesString = String.ValueOf(field.get('Picklist_Values__c'));
            if(String.ValueOf(field.get('Picklist_Values__c'))!=null && 
               String.ValueOf(field.get('Picklist_Values__c')).startsWith('Community_Web_Content__c.'))
            {
                picklistValuesString = CommunityContentHelper.getContent(String.ValueOf(field.get('Picklist_Values__c')));
            }

            String inputFiledHTML = createFieldHTML(String.ValueOf(field.get('Field_Type__c')), String.ValueOf(field.get('Field_Name__c')), String.ValueOf(field.get('Field_Label__c')), picklistValuesString);
            if(firstTime)
            {
                html = html + '<div class="firstSection"><div class="ds_header">Directory Search</div><div>';
                oldSectionOrder = String.ValueOf(field.get('Section_Order__c'));
                firstTime = false;
            }
            if(oldSectionOrder==String.ValueOf(field.get('Section_Order__c')))
            {
                html = html + inputFiledHTML;
            }
            if(firstSection && oldSectionOrder!=String.ValueOf(field.get('Section_Order__c')))
            {
                html = html + '</div><div class="ds_buttons"><input type="button" value="Search" onClick="acfsObj.runSearch('+string.valueof(integer.valueOf(perPageRecords))+',1)"></input><a onClick="acfsObj.clearfields()">Clear All</a></div></div><div class="ds_Collapsible"><div class="ds_SectionHeader"><h2>'+String.ValueOf(field.get('Section_Label__c'))+'</h2></div><div>'+inputFiledHTML;
                firstSection = false;
            }
            else if(!firstSection && oldSectionOrder!=String.ValueOf(field.get('Section_Order__c')))
            {
                html = html + '</div></div><div class="ds_Collapsible"><div class="ds_SectionHeader"><h2>'+String.ValueOf(field.get('Section_Label__c'))+'</h2></div><div>'+inputFiledHTML;
            }
            oldSectionOrder = String.ValueOf(field.get('Section_Order__c'));
        }
        html = html + '</div></div>';
        return html;
    }//End method
    
    //class to hold pagination details
    public class WarpperPaginationDetails{
        public decimal perPageSize{get;set;}
        public decimal perPageRecords{get;set;}
        public String sortingParameters{get;set;}
        
    }//End class 
    
    
    /*public void getContactList(){
        string Str = ' e square university road,Pune,India';
        lstContact = new list<wrapperContact>();
        for(Contact objCon : [select id, MailingStreet, MailingState, MailingPostalCode, MailingCountry from Contact]){
            lstContact.add(new wrapperContact(String.valueOf(objCon.id), Str));
        }
        system.debug('***lstContact' + lstContact);
        
    }//End Method*/
    
    /*public class wrapperContact{
        public String id {get; set;}
        public String mailingAddress {get; set;}
        
        public wrapperContact(String pId, String pMailingAddress){
            id = pId;
            mailingAddress = pMailingAddress;
        }
    }*/
}