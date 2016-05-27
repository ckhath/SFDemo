/*-----------------------------------------------------------------------
    ACF Solutions
    Description: Controller class used to pull data from custom settings
                 and display sections on the profile page.
                 
                 **This class convert "Web Content" object field value to
                 picklist values based on field custom setting record.
                 Modified date : 28/07/2015**
-----------------------------------------------------------------------*/

public class Profile_Personal_V1 {

    public String subTabHTML { get; set; }
    public Sobject objStudent {get; set;}
    public String colr {get; set;}
    public String currentUserContactId {get;set;}
    public Contact currentContact {get; set;}

    public map<String, list<sObject>> sectionIdToObjMap {get; set;}
    public map<String, list<sObject>> sectionIdToFieldsMap {get; set;}
    public map<String, list<sObject>> sectionIdToBranchObj {get; set;}
    public list<sObject> subSectionCustomSettings {get; set;}
    public map<String, sObject> subSectionCustomSettingMap {get; set;}
    public map<String, sObject> sectionObjIdToSectionObj {get; set;}
    public map<String, Community_Web_Content__c> mapWebContent {get; set;}
    
    public list<sObject> lstSubsectionCustomSetting {get; set;}
    public list<sObject> lstSectionCustomSetting {get; set;}
    public map<String, list<sObject>> mapOfLstSubsectionCustomSetting {get; set;}

    public map<String, sObject> sectionIdToRelatedListObjectMap {get; set;}

    public map<String, list<SelectOption>> mapCustomFieldWithSelectList {get; set;}
    public list<fieldWrapperClass> lstWrapper {get; set;}
    
    public String strSelectOptionValue {get; set;}
    public list<string> lstRelatedFullRecordId {get; set;}
    public String realtedListEditObjId {get; set;}   //Row Id for related List Full
    public String relatedListCompEditId {get; set;}   //Row Id for related List Compact
    public map<String, boolean> mapEditableFields {get; set;}

    //parameters for Edit/Create/Delete functionality

    public String relatedFullId {get; set;}
    public String relatedFullCancelId {get; set;}
    public Community_Web_Content__c communityWebContent {get; set;}
    Set<String> setWebContentRecordName = new Set<String>();
    public list<wrapperSectionIdToObj> lstwrapperSectionIdToObj {get; set;}
    public static final String BLANK_PAGE = '/apex/BlankPage';
    
    public boolean isEditMode {get; set;}
    public boolean isMobileMode {get;set;}
    public Boolean showEditBtn {get; set;}
    public boolean isInit {get; set;}
    public boolean isCreate {get; set;}
    public boolean pageFailed {get; set;}
    public boolean show {get;set;}
    public boolean hide {get;set;}
    public boolean showEdit {get;set;}
    public boolean displayPopup {get; set;}
    
    public boolean isDisplayAdd {get;set; }
    public boolean isCreateAccessRelatedCompact {get; set;}

    public String headerType { get; set; }

    public void closePopup() {
        displayPopup = false;
    }

    public void showPopup() {
        displayPopup = true;
    }

    /*public void QueryPage()
    {
        retriveWebContent();
        subSectionCustomSettings = getProfilePersonal();
        init(subSectionCustomSettings);
        
    }*/

    public void InvokeShow() {
        editRelatedList();
    }

    public Pagereference QueryPage1() {
        if(String.isBlank(getContactIdFromUser())) {
            return UtilityGeneral.redirect(BLANK_PAGE, true);
        }
        subSectionCustomSettings = getProfilePersonal1();
        system.debug('***subSectionCustomSettings' + subSectionCustomSettings);
        init(subSectionCustomSettings);
        return null;
    }

    public Pagereference QueryPage2() {
        if(String.isBlank(getContactIdFromUser())) {
            return UtilityGeneral.redirect(BLANK_PAGE, true);
        }
        subSectionCustomSettings = getProfilePersonal2();
        init(subSectionCustomSettings);
        return null;
    }

    public Pagereference QueryPage3() {
        if(String.isBlank(getContactIdFromUser())) {
            return UtilityGeneral.redirect(BLANK_PAGE, true);
        }
        subSectionCustomSettings = getProfilePersonal3();
        init(subSectionCustomSettings);
        return null;
    }

    public Pagereference QueryPage4() {
        if(String.isBlank(getContactIdFromUser())) {
            return UtilityGeneral.redirect(BLANK_PAGE, true);
        }
        subSectionCustomSettings = getProfilePersonal4();
        init(subSectionCustomSettings);
        return null;
    }

    public Pagereference QueryPage5() {
        if(String.isBlank(getContactIdFromUser())) {
            return UtilityGeneral.redirect(BLANK_PAGE, true);
        }
        subSectionCustomSettings = getProfilePersonal5();
        init(subSectionCustomSettings);
        return null;
    }

    public Boolean determineShowEditBtn() {
        Boolean showBtns = false;
        String userIdParam = '';
            userIdParam = apexpages.currentpage().getparameters().get('sfdc.userId');
            system.debug('***userIdParam' + userIdParam);
            if(userIdParam == null) {
                userIdParam = apexpages.currentpage().getparameters().get('id'); 
            }
        String userIdSystem = UserInfo.getUserId().substring(0, 15);
        system.debug('\n\n\n userIdParam: '+userIdParam+'\n\n\n');
        system.debug('\n\n\n userIdSystem: '+userIdSystem+'\n\n\n');
        if(userIdParam.equalsIgnoreCase(userIdSystem)) {
            showBtns = true;
        }
        return showBtns;
    }

    public boolean callPoBox = false;
    public void init(list<sObject> csSubSection) {
        pageFailed = false;
        relatedFullId ='';
        currentUserContactId = getContactIdFromUser();
        sectionIdToObjMap = new map<String, list<sObject>>();
        sectionIdToFieldsMap = new map<String, list<sObject>>();
        sectionIdToRelatedListObjectMap = new map<String, sObject>();
        subSectionCustomSettingMap = new map<String, sObject>();
        sectionObjIdToSectionObj = new map<String, sObject>();
        lstwrapperSectionIdToObj = new list<wrapperSectionIdToObj>();
        setWebContentRecordName = new set<String>();
        mapOfLstSubsectionCustomSetting = new map<String, list<sObject>>();
        //subSectionCustomSettings = getSubSectionCustomSetting();
        system.debug('$$$$ setWebContentRecordName'+setWebContentRecordName);
        showEditBtn = determineShowEditBtn();
        system.debug('***Custom Settings' + csSubSection);
        set<String> fieldAPINamesForCon = new set<String>();
        if(csSubSection.size() > 0 || csSubSection != null) 
        for(sObject subSectionCustomSetting : csSubSection) {
            system.debug('\n\n\n sectionIdToObjMap5: '+sectionIdToObjMap+'\n\n\n');
            fieldAPINamesForCon.addAll(createListOfFieldAPINames(subSectionCustomSetting, 'Privacy_Field_API__c'));

            subSectionCustomSettingMap.put(subSectionCustomSetting.Id, subSectionCustomSetting);
            system.debug('\n\n\n String.ValueOf(subSectionCustomSetting.get(Custom_Setting_Type__c)): '+String.ValueOf(subSectionCustomSetting.get('Custom_Setting_Type__c'))+'\n\n\n');
            if(String.ValueOf(subSectionCustomSetting.get('Custom_Setting_Type__c')).equalsIgnoreCase('subsection')) {
                //String queryStringForsectionCustomSetting = constructDynamicQueryForSubSectionCustomSetting(String.valueOf(subSectionCustomSetting.get('Custom_Setting__c')));
                //lstSectionCustomSetting = Database.query(queryStringForsectionCustomSetting);

                system.debug('\n\n\n sectionIdToObjMap6: '+sectionIdToObjMap+'\n\n\n');
                set<String> setTotalFields = new set<String>();
                map<Sobject, list<Sobject>> mapSectionWithSubHeaderFields = new map<Sobject, list<Sobject>>();
                //String queryStringForFields = '';    

                String queryStringForSubsectionCustomSetting = 
                    constructDynamicQueryForSubSectionCustomSetting(String.valueOf(subSectionCustomSetting.get('Custom_Setting__c')));

                list<sObject> customSettingSectionFields;
                set<String> fieldAPINames = new set<String>();
                list<sObject> sectionObj;
                system.debug('%%% queryStringForSubsectionCustomSetting'+queryStringForSubsectionCustomSetting);
                try {
                    // **** QUERY INSIDE OF FOR LOOP ****
                    lstSubsectionCustomSetting = Database.query(queryStringForSubsectionCustomSetting);
                    mapOfLstSubsectionCustomSetting.put(
                        String.valueOf(subSectionCustomSetting.get('Custom_Setting__c')) ,lstSubsectionCustomSetting);
                } catch(Exception e) {
                    system.debug('\n\n\n ERROR: '+e+'\n\n\n');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The page failed to load due to an internal error. The error has been reported. Thank you for your patience while we resolve this error.');
                    ApexPages.addMessage(myMsg);
                    pageFailed = true;
                    return;
                }

                system.debug('%%% mapOfLstSubsectionCustomSetting'+mapOfLstSubsectionCustomSetting);
                system.debug('%%% lstSubsectionCustomSetting'+lstSubsectionCustomSetting);

                fieldAPINames.addAll(createListOfFieldAPINames(subSectionCustomSetting, 'Privacy_Field_API__c'));
                system.debug('\n\n\n fieldAPINames12: '+fieldAPINames+'\n\n\n');
                if(lstSubsectionCustomSetting != null && !lstSubsectionCustomSetting.isEmpty()) {
                    system.debug('\n\n\n sectionIdToObjMap7: '+sectionIdToObjMap+'\n\n\n');
                    //fieldAPINames.addAll(createListOfFieldAPINames(lstSubsectionCustomSetting, 'Privacy_Field_API__c'));
                    system.debug('\n\n\n fieldAPINames: '+fieldAPINames+'\n\n\n');
                    if(fieldAPINames != null && !fieldAPINames.isEmpty()){
                        String queryStringForFields = constructDynamicQueryForFields(subSectionCustomSetting, fieldAPINames);
                        fieldAPINames = new set<String>();
                        system.debug('\n\nqueryStringForFields: '+queryStringForFields+'\n\n');
                        try {
                            // **** QUERY INSIDE OF FOR LOOP ****
                            sectionObj = Database.query(queryStringForFields);
                        } catch(Exception e) {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The page failed to load due to an internal error. The error has been reported. Thank you for your patience while we resolve this error.');
                            ApexPages.addMessage(myMsg);
                            pageFailed = true;
                            return;
                        }
                        system.debug('\n\n\n sectionIdToObjMap4: '+sectionIdToObjMap+'\n\n\n');
                        sectionIdToObjMap.put(subSectionCustomSetting.Id, sectionObj);
                        system.debug('\n\n\n sectionIdToObjMap3: '+sectionIdToObjMap+'\n\n\n');
                    }
                    sectionIdToFieldsMap.put(subSectionCustomSetting.Id, lstSubsectionCustomSetting);
                }
                list<wrapperEditableRecords> lstWrapperEditableRecords = new list<wrapperEditableRecords>();
                if(sectionObj != null) {
                    for(Sobject objSection : sectionObj) {
                        lstWrapperEditableRecords.add(new wrapperEditableRecords(objSection, false));
                    }
                }
                lstwrapperSectionIdToObj.add(new wrapperSectionIdToObj(subSectionCustomSetting.Id, lstWrapperEditableRecords));
                system.debug('****lstwrapperSectionIdToObj' + lstwrapperSectionIdToObj);
                for(sObject objSubsection : lstSubsectionCustomSetting) {
                    String queryStringForCustomSettingFields = 
                    constructDynamicQueryForFieldsCustomSetting(string.ValueOf(objSubsection.get('Custom_Setting__c')));

                    //list<sObject> customSettingSectionFields;
                    fieldAPINames = new set<String>();
                    //list<sObject> sectionObj;
                    try {
                        // **** QUERY INSIDE OF FOR LOOP ****
                        customSettingSectionFields = Database.query(queryStringForCustomSettingFields);
                    } catch(Exception e) {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The page failed to load due to an internal error. The error has been reported. Thank you for your patience while we resolve this error.');
                        ApexPages.addMessage(myMsg);
                        pageFailed = true;
                        return;
                    }
                    system.debug('***customSettingSectionFields' + customSettingSectionFields);
                    if(customSettingSectionFields != null && !customSettingSectionFields.isEmpty()) {
                        fieldAPINames.addAll(createListOfFieldAPINames(objSubsection, 'Privacy_Field_API__c'));
                        fieldAPINames.addAll(createListOfFieldAPINames(customSettingSectionFields, 'Field_API_Name__c'));
                        fieldAPINames.addAll(createListOfFieldAPINames(customSettingSectionFields, 'Privacy_Field_API__c'));

                        if(fieldAPINames != null && !fieldAPINames.isEmpty()){
                            String queryStringForFields = constructDynamicQueryForFields(subSectionCustomSetting, fieldAPINames);
                            fieldAPINames = new set<String>();
                            try {
                                // **** QUERY INSIDE OF FOR LOOP ****
                                sectionObj = Database.query(queryStringForFields);
                            } catch(Exception e) {
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The page failed to load due to an internal error. The error has been reported. Thank you for your patience while we resolve this error.');
                                ApexPages.addMessage(myMsg);
                                pageFailed = true;
                                return;
                            }
                            sectionIdToFieldsMap.put(objSubsection.Id, customSettingSectionFields);

                            sectionIdToObjMap.put(objSubsection.Id, sectionObj);
                            system.debug('\n\n\n sectionIdToObjMap1: '+sectionIdToObjMap+'\n\n\n');
                            system.debug('\n\n\n sectionObj: '+sectionObj+'\n\n\n');
                        }
                    }
                    //sectionIdToObjMap.put(objSubsection.Id, sectionObj);
                    //system.debug('\n\n\n sectionIdToObjMap1: '+sectionIdToObjMap+'\n\n\n');
                    for(sObject sobj : sectionObj) {
                        sectionObjIdToSectionObj.put(sobj.Id, sobj);
                    }
                    if(String.ValueOf(objSubsection.get('Custom_Setting_Type__c')).equalsIgnoreCase('related list compact') || 
                    String.ValueOf(objSubsection.get('Custom_Setting_Type__c')).equalsIgnoreCase('related list full')) {
                        sObject newObjForRelatedList = 
                            Schema.getGlobalDescribe().get(String.valueOf(subSectionCustomSetting.get('Object__c'))).newSObject();
                        sectionIdToRelatedListObjectMap.put(objSubsection.Id, newObjForRelatedList);
                    }

                    subSectionCustomSettingMap.put(objSubsection.Id, objSubsection);
                }
            } else {
                String queryStringForCustomSettingFields = constructDynamicQueryForFieldsCustomSetting(String.ValueOf(subSectionCustomSetting.get('Custom_Setting__c')));
                System.debug('\n\n\nQuery String is: ' + queryStringForCustomSettingFields);
                
                list<sObject> customSettingSectionFields;
                set<String> fieldAPINames = new set<String>();
                list<sObject> sectionObj;
                try {
                    // **** QUERY INSIDE OF FOR LOOP ****
                    customSettingSectionFields = Database.query(queryStringForCustomSettingFields);
                } catch(Exception e) {
                    system.debug('\n\n\n ERROR: '+e+'\n\n\n');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The page failed to load due to an internal error. The error has been reported. Thank you for your patience while we resolve this error.');
                    ApexPages.addMessage(myMsg);
                    pageFailed = true;
                    return;
                }

                //getPicklistFieldValues(customSettingSectionFields);
                system.debug('subSectionCustomSetting***' + subSectionCustomSetting);
                system.debug('customSettingSectionFields***' + customSettingSectionFields);
                if(customSettingSectionFields != null && !customSettingSectionFields.isEmpty()) {
                    fieldAPINames.addAll(createListOfFieldAPINames(subSectionCustomSetting, 'Related_List_Privacy_API__c'));
                    fieldAPINames.addAll(createListOfFieldAPINames(subSectionCustomSetting, 'Related_List_Read_Only_API__c'));
                    fieldAPINames.addAll(createListOfFieldAPINames(subSectionCustomSetting, 'Privacy_Field_API__c'));
                    fieldAPINames.addAll(createListOfFieldAPINames(customSettingSectionFields, 'Privacy_Field_API__c'));
                    fieldAPINames.addAll(createListOfFieldAPINames(customSettingSectionFields, 'Field_API_Name__c'));
                    //fieldAPINames.addAll(createListOfFieldAPINames(customSettingSectionFields, 'Picklist__c'));

                    if(fieldAPINames != null && !fieldAPINames.isEmpty()) {
                        system.debug('****fieldAPINames*** : ' + fieldAPINames);
                        if(fieldAPINames.contains('PO_Box_Alias__c') && fieldAPINames.contains('PO_Box_Target__c'))
                        {
                            callPoBox = true;
                        }
                        String queryStringForFields = constructDynamicQueryForFields(subSectionCustomSetting, fieldAPINames);
                        system.debug('****Type*** : ' + String.valueOf(subSectionCustomSetting.get('Custom_Setting__c')));
                        system.debug('\n\nqueryStringForFields: '+queryStringForFields+'\n\n');
                        try {
                            // **** QUERY INSIDE OF FOR LOOP ****
                            sectionObj = Database.query(queryStringForFields);
                        } catch(Exception e) {
                            system.debug('\n\n\n ERROR: '+e+'\n\n\n');
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The page failed to load due to an internal error. The error has been reported. Thank you for your patience while we resolve this error.');
                            ApexPages.addMessage(myMsg);
                            pageFailed = true;
                            return;
                        }
                        fieldAPINames = new set<String>();
                        sectionIdToFieldsMap.put(subSectionCustomSetting.Id, customSettingSectionFields);
                    
                        sectionIdToObjMap.put(subSectionCustomSetting.Id, sectionObj);
                        system.debug('\n\n\n sectionIdToObjMap2: '+sectionIdToObjMap+'\n\n\n');
                        system.debug('***sectionObj' + sectionObj);
                    }
                }
                if(sectionObj.size() > 0 || sectionObj != null)
                for(sObject sobj : sectionObj) {
                    sectionObjIdToSectionObj.put(sobj.Id, sobj);
                }
                system.debug('***sectionObjIdToSectionObj****' + sectionObjIdToSectionObj);
                if(String.ValueOf(subSectionCustomSetting.get('Custom_Setting_Type__c')).equalsIgnoreCase('related list compact') || 
                String.ValueOf(subSectionCustomSetting.get('Custom_Setting_Type__c')).equalsIgnoreCase('related list full'))
                {
                    sObject newObjForRelatedList = Schema.getGlobalDescribe().get(String.valueOf(subSectionCustomSetting.get('Object__c'))).newSObject();
                    sectionIdToRelatedListObjectMap.put(subSectionCustomSetting.Id, newObjForRelatedList);
                }
                if(String.ValueOf(subSectionCustomSetting.get('Custom_Setting_Type__c')).equalsIgnoreCase('related list compact')){
                    isCreateAccessRelatedCompact = boolean.valueOf(subSectionCustomSetting.get('Create__c'));
                }
            }
        } // end for

        if(mapEditableFields == null){
            //system.debug('***mapEditableFields*Inside***' + mapEditableFields);
            mapEditableFields = new map<String, boolean>();
        }
        for(list<sObject> sobj : sectionIdToObjMap.values())
        {
            if(sobj!=null)
            {
                for(Sobject objFieldValue : sobj){
                    if(!mapEditableFields.containsKey(objFieldValue.Id))
                    {
                        mapEditableFields.put(objFieldValue.Id, false);
                        //mapEditableFields.put(String.valueOf(objFieldValue.Id).subString(0, 15), false);
                    }   
                }
            }
        }
        system.debug('***mapEditableFields' + mapEditableFields);
        /* for(list<sObject> sobj : sectionIdToObjMap.values()){
            for(Sobject objFieldValue : sobj){
                if(!mapEditableFields.containsKey(objFieldValue.Id)){
                    mapEditableFields.put(objFieldValue.Id, false);
                    //mapEditableFields.put(String.valueOf(objFieldValue.Id).subString(0, 15), false);
                }
            }
        } else if(!String.isBlank(relatedFullCancelId)) {
            mapEditableFields.put(relatedFullCancelId, false);
        }*/
        system.debug('***mapEditableFields****' + mapEditableFields);
        String ConQuery = 'Select Id ';
        if(fieldAPINamesForCon.size() > 0) {
            String fieldsToSearch = convertListIntoFieldsToSearchString(fieldAPINamesForCon);
            ConQuery = ConQuery+', '+fieldsToSearch;
        }
        ConQuery = ConQuery + ' from Contact where Id=\''+currentUserContactId+'\'';
        try {
            currentContact = Database.query(ConQuery);
        } catch(Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The page failed to load due to an internal error. The error has been reported. Thank you for your patience while we resolve this error.');
            ApexPages.addMessage(myMsg);
            pageFailed = true;
            return;
        }
        if(isEditMode == null) {
            isEditMode = false;
        }
        //subTabHTML = CreateHTMLForPage(subSectionCustomSettings, sectionIdToObjMap, sectionIdToFieldsMap);
        system.debug('\n\n\n **sectionIdToObjMap**: '+sectionIdToObjMap+'\n\n\n');
        system.debug('\n\n\n **sectionIdToFieldsMap**: '+sectionIdToFieldsMap+'\n\n\n');
    }

    public void setMobileMode() {
        isMobileMode = true;
        System.debug ('Sid:::::::: #304 isMobileMode '+isMobileMode);
    }

    public void setDesktopMode() {
        isMobileMode = false;
        System.debug ('Sid:::::::: #308 isMobileMode '+isMobileMode);
    }

    public Profile_Personal_V1(ApexPages.StandardController stdController) {
        //Id devRecordTypeId = Schema.SObjectType.Student_Enrollment__c.getRecordTypeInfosByName().get('Student Activities').getRecordTypeId();
        //system.debug('%%%%% devRecordTypeId'+devRecordTypeId);

        //Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get('Student_Enrollment__c').getDescribe();
        //List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        //Map<String,Id> mapofCaseRecordTypeNameandId = new Map<String,Id>();
        //Map<Id,String> mapofCaseRecordTypeNameandId = new Map<Id,String>();
        //for(Schema.RecordTypeInfo info : recordTypeInfo){
        //mapofCaseRecordTypeNameandId.put(info.getRecordTypeId(),info.getName());
        //}
        //system.debug('***mapofCaseRecordTypeNameandId*'+mapofCaseRecordTypeNameandId);

        show = false;
        showEdit = true;
        isDisplayAdd = true; 
        communityWebContent = new Community_Web_Content__c();
        communityWebContent = UtilityGeneral.getWebContent(ApexPages.CurrentPage().getUrl());
        if(isEditMode == null) {
            isEditMode = false;
        }
        CommunityCSSHeaders commHeaders = new CommunityCSSHeaders();
        headerType = commHeaders.getHeadersType();
    }

    //Fetch Custom Setting to get field custom Setting
    public String constructDynamicQueryForSubSectionCustomSetting(String customSettingName) {
        String querySubsection = 'SELECT Id, Custom_Setting__c, Custom_Setting_Type__c, Object__c, Order__c, Privacy_Field_API__c, Title__c, Help_Text__c, Field_API_For_Contact_Id__c, Related_List_Privacy_API__c, Related_List_Read_Only_API__c, related_list_static_where__c,Sort__c'
                + ' FROM ' + customSettingName + ' ORDER BY Order__c';
       return querySubsection;
    }

    public String getContactIdFromUser() {
        String userIdParam = '';
        if(apexpages.currentpage().getparameters().get('sfdc.userId') != null) {
            userIdParam = apexpages.currentpage().getparameters().get('sfdc.userId');
        } else {
           userIdParam = apexpages.currentpage().getparameters().get('id'); 
        }
        system.debug('***userIdParam' + userIdParam);
        //currentUserContactId = UtilityGeneral.getContactIdFromUser(userIdParam);
        //User currentUser = [Select ContactId from User u where Id=:userIdParam limit 1];
        //User currentUser = [Select ContactId from User u where Id=:UserInfo.getUserId() limit 1];
        return UtilityGeneral.getContactIdFromUser(userIdParam);
    }

    public Pagereference redirectOnBlankPage() {
        System.debug('****BlankPage');
        return UtilityGeneral.redirect('/apex/BlankPage', true);
    }

    /*public list<Profile_Personal__c> getProfilePersonal() {
        return [SELECT Id, Custom_Setting__c, Custom_Setting_Type__c, Object__c, 
                Order__c, Privacy_Field_API__c, Title__c, Field_API_For_Contact_Id__c,
                Related_List_Privacy_API__c, Related_List_Read_Only_API__c,Help_Text__c,
                related_list_static_where__c,Sort__c, Read_Only__c
                FROM Profile_Personal__c ORDER BY Order__c];
    }*/

    public list<Profile_Page_1__c> getProfilePersonal1() {
        return [SELECT Id, Custom_Setting__c, Custom_Setting_Type__c, Object__c,
                Create__c,Edit__c,Delete__c,
                Order__c, Privacy_Field_API__c, Title__c, Field_API_For_Contact_Id__c,
                Related_List_Privacy_API__c, Related_List_Read_Only_API__c, Record_Type_Id__c,
                related_list_static_where__c,Sort__c, Help_Text__c, Read_Only__c
                FROM Profile_Page_1__c ORDER BY Order__c];
    }

    public list<Profile_Page_2__c> getProfilePersonal2() {
        return [SELECT Id, Custom_Setting__c, Custom_Setting_Type__c, Object__c,
                Create__c,Edit__c,Delete__c,
                Order__c, Privacy_Field_API__c, Title__c, Field_API_For_Contact_Id__c,
                Related_List_Privacy_API__c, Related_List_Read_Only_API__c, Record_Type_Id__c,
                related_list_static_where__c,Sort__c, Help_Text__c, Read_Only__c
                FROM Profile_Page_2__c ORDER BY Order__c];
    }

    public list<Profile_Page_3__c> getProfilePersonal3() {
        return [SELECT Id, Custom_Setting__c, Custom_Setting_Type__c, Object__c, 
                Create__c,Edit__c,Delete__c,
                Order__c, Privacy_Field_API__c, Title__c, Field_API_For_Contact_Id__c,
                Related_List_Privacy_API__c, Related_List_Read_Only_API__c, Record_Type_Id__c,
                related_list_static_where__c, Sort__c,Help_Text__c, Read_Only__c
                FROM Profile_Page_3__c ORDER BY Order__c];
    }

    public list<Profile_Page_4__c> getProfilePersonal4() {
        return [SELECT Id, Custom_Setting__c, Custom_Setting_Type__c, Object__c,
                Create__c,Edit__c,Delete__c, 
                Order__c, Privacy_Field_API__c, Title__c, Field_API_For_Contact_Id__c,
                Related_List_Privacy_API__c, Related_List_Read_Only_API__c, Record_Type_Id__c,
                related_list_static_where__c,Sort__c, Help_Text__c, Read_Only__c
                FROM Profile_Page_4__c ORDER BY Order__c];
    }

    public list<Profile_Page_5__c> getProfilePersonal5() {
        return [SELECT Id, Custom_Setting__c, Custom_Setting_Type__c, Object__c, 
                Create__c,Edit__c,Delete__c,
                Order__c, Privacy_Field_API__c, Title__c, Field_API_For_Contact_Id__c,
                Related_List_Privacy_API__c, Related_List_Read_Only_API__c, Record_Type_Id__c,
                related_list_static_where__c, Sort__c,Help_Text__c, Read_Only__c
                FROM Profile_Page_5__c ORDER BY Order__c];
    }

    public String constructDynamicQueryForFieldsCustomSetting(String customSettingName) {
        system.debug('***customSettingName' + customSettingName);
        String dynamicQuery = '';
        if(customSettingName != null) {
            String fieldsToSearch = 'Column_Span__c, Field_API_Name__c, Field_Name__c, Order__c,' 
                + ' Privacy_Field_API__c, Read_Only__c, Read_Mode__c, Edit_Mode__c';
            dynamicQuery = 'SELECT ' + fieldsToSearch + ' FROM ' + customSettingName + ' ORDER BY Order__c';
        }
        return dynamicQuery;
    }

    public String constructDynamicQueryForFields(Sobject pSubSectionCustomSetting, set<String> fields) {
        String objName = String.valueOf(pSubSectionCustomSetting.get('Object__c'));
        String ConIdAPIName = String.ValueOf(pSubSectionCustomSetting.get('Field_API_For_Contact_Id__c'));
        String privacyStr = String.valueOf(pSubSectionCustomSetting.get('Related_List_Privacy_API__c'));
        String whereClause = String.valueOf(pSubSectionCustomSetting.get('related_list_static_where__c'));
        String sortByParam = String.valueOf(pSubSectionCustomSetting.get('Sort__c'));
        String recordTypeId = String.valueOf(pSubSectionCustomSetting.get('Record_Type_Id__c'));
        
        //if(currentUserContactId==null){ currentUserContactId='003o000000B9m2D'; }
        String dynamicQuery = '';
        String fieldsToSearch = convertListIntoFieldsToSearchString(fields);

        dynamicQuery = 'SELECT ' + fieldsToSearch + ' FROM ' + objName + ' WHERE ' + ConIdAPIName + '=\'' + currentUserContactId + '\'';
        
        if(!String.isblank(whereClause)) {
            dynamicQuery = dynamicQuery + ' AND ' + whereClause;
        }
        if(!String.isblank(recordTypeId)) {
            dynamicQuery = dynamicQuery + ' and recordTypeId=\'' + recordTypeId + '\'';   
        }
        system.debug('\n\n\n isEditMode: '+isEditMode+'\n\n\n');
        system.debug('\n\n\n privacyStr: '+privacyStr+'\n\n\n');
        if(isEditMode == false && privacyStr != null) {
            dynamicQuery = dynamicQuery + ' and ' + privacyStr + '=false';
        }
        if(!String.isblank(sortByParam)){
               dynamicQuery = dynamicQuery +  ' ORDER BY ' + sortByParam;
        }
        
        System.debug('dynamicQuery : ' + dynamicQuery + '\n\n');
        return dynamicQuery;
    }

    public String convertListIntoFieldsToSearchString(set<String> fields) {
        String fieldsToSearch = '';
        for(String field : fields) {
            fieldsToSearch = fieldsToSearch + field + ', ';
        }
        fieldsToSearch = fieldsToSearch.removeEndIgnoreCase(', ');
        return fieldsToSearch;
    }

    public list<String> createListOfFieldAPINames(list<sObject> customSettingSectionFields, String fieldNameForAPIName) {
        list<String> fieldAPINames = new list<String>();
        system.debug('***customSettingSectionFields' + customSettingSectionFields);
        system.debug('***fieldNameForAPIName: ' + fieldNameForAPIName);
        for(sObject customSettingSectionField : customSettingSectionFields) {
             system.debug('customSettingSectionField***' + customSettingSectionField);
            if(String.valueOf(customSettingSectionField.get(fieldNameForAPIName))!=null) {
                system.debug('PrivacyField *** : ' + customSettingSectionField.get(fieldNameForAPIName));
                fieldAPINames.add(String.valueOf(customSettingSectionField.get(fieldNameForAPIName)));
            }
        }
        return fieldAPINames;
    }

    public list<String> createListOfFieldAPINames(sObject customSettingSectionField, String fieldNameForAPIName) {
        list<String> fieldAPINames = new list<String>();
        if(String.valueOf(customSettingSectionField.get(fieldNameForAPIName))!=null) {
                fieldAPINames.add(String.valueOf(customSettingSectionField.get(fieldNameForAPIName)));
        }
        return fieldAPINames;
    }

    //Method to display page in edit mode
    public void EditSobjectRecord() {
        isDisplayAdd = true;
        for(String objEditFields : mapEditableFields.keySet()) {
            mapEditableFields.put(objEditFields, false);
        }
        isEditMode = true;
        realtedListEditObjId ='';
        relatedListCompEditId ='';
        system.debug('*****sectionIdToRelatedListObjectMap' + sectionIdToRelatedListObjectMap);
        init(subSectionCustomSettings);
    }

    public PageReference saveSobjectRecord() {
        isDisplayAdd = true;
        relatedListCompEditId ='';
        show = false;
        //hide = true;
        
       /* Id devRecordTypeId = Schema.SObjectType.Student_Enrollment__c.getRecordTypeInfosByName().get('Record_Type_Id__c').getRecordTypeId();
        system.debug('%%%%% devRecordTypeId'+devRecordTypeId);
        
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get('Student_Enrollment__c').getDescribe();
           List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
            //Map<String,Id> mapofCaseRecordTypeNameandId = new Map<String,Id>();
            Map<Id,String> mapofCaseRecordTypeNameandId = new Map<Id,String>();
            for(Schema.RecordTypeInfo info : recordTypeInfo){
             mapofCaseRecordTypeNameandId.put(info.getRecordTypeId(),info.getName());
            }
           system.debug('***mapofCaseRecordTypeNameandId*'+mapofCaseRecordTypeNameandId);*/ 
         
        system.debug('\n\n SAVE \n\n');
        system.debug('\n\n sectionIdToObjMap ****' + sectionIdToObjMap);
        list<sObject> objs = new list<sObject>();
        map<String, sObject> objsToUpdateMap = new map<String, sObject>();
        for(sObject subSectionCustomSetting : subSectionCustomSettings) {
            if(String.ValueOf(subSectionCustomSetting.get('Custom_Setting_Type__c')).equalsIgnoreCase('2 column') || 
               String.ValueOf(subSectionCustomSetting.get('Custom_Setting_Type__c')).equalsIgnoreCase('preferences')) {
                system.debug('$$$$ inside object...::');
                objs = sectionIdToObjMap.get(subSectionCustomSetting.Id);
                sObject obj = objs[0];
                String objectCS = String.valueOf(subSectionCustomSetting.get('Object__c'));
                sObject objToUpdate = Schema.getGlobalDescribe().get(objectCS).newSObject();
                objToUpdate.Id = obj.Id;
                if(objsToUpdateMap.get(obj.Id) != null) {
                    objToUpdate = objsToUpdateMap.get(obj.Id);
                }
                for(sObject fieldsCS : sectionIdToFieldsMap.get(subSectionCustomSetting.Id)) {
                    if(fieldsCS.get('Read_Only__c') == false) {
                        objToUpdate.put(String.valueOf(fieldsCS.get('Field_API_Name__c')), obj.get(String.valueOf(fieldsCS.get('Field_API_Name__c')))); 
                    }
                    if(fieldsCS.get('Privacy_Field_API__c') != null) {
                        objToUpdate.put(String.valueOf(fieldsCS.get('Privacy_Field_API__c')), obj.get(String.valueOf(fieldsCS.get('Privacy_Field_API__c'))));                     
                    }
                }
                if(subSectionCustomSetting.get('Privacy_Field_API__c') != null) {
                    objToUpdate.put(String.valueOf(subSectionCustomSetting.get('Privacy_Field_API__c')), obj.get(String.valueOf(subSectionCustomSetting.get('Privacy_Field_API__c')))); 
                }
                objsToUpdateMap.put(obj.Id, objToUpdate);
            }
            if(String.ValueOf(subSectionCustomSetting.get('Custom_Setting_Type__c')).equalsIgnoreCase('subsection')) {
                system.debug('@@### inside custom setting...::');
                system.debug('\n\n\n subSectionCustomSetting.Id: '+subSectionCustomSetting.Id+'\n\n\n');
                objs = sectionIdToObjMap.get(subSectionCustomSetting.Id);
                system.debug('\n\n\n *objs**: '+objs+'\n\n\n');
                if(objs != null && objs.size() > 0) {
                    system.debug('\n\n\n not nulllll *objs**: '+objs+'\n\n\n');
                    sObject obj = objs[0];
                    system.debug('\n\n\n objIDD ###########: '+obj.id+'\n\n\n');
                    if(objsToUpdateMap.get(obj.Id) != null) {
                        system.debug('\n\n\ninside ifff ID ###########: '+obj.id+'\n\n\n');
                        system.debug('\n\n *objsToUpdateMap '+objsToUpdateMap+'\n\n\n');
                        sObject objToUpdate = objsToUpdateMap.get(obj.Id);
                        system.debug('\n\n\n Privacy Field API: '+subSectionCustomSetting.get('Privacy_Field_API__c')+'\n\n\n');
                        if(subSectionCustomSetting.get('Privacy_Field_API__c') != null) {
                            objToUpdate.put(String.valueOf(subSectionCustomSetting.get('Privacy_Field_API__c')), obj.get(String.valueOf(subSectionCustomSetting.get('Privacy_Field_API__c')))); 
                        }
                        //objsToUpdateMap.put(obj.Id, objToUpdate);
                    } else {
                        //system.debug('Inside else;;;;;::::');
                        if(subSectionCustomSetting.get('Privacy_Field_API__c') != null) {
                            system.debug('subSectionCustomSetting'+subSectionCustomSetting);
                            obj.put(String.valueOf(subSectionCustomSetting.get('Privacy_Field_API__c')), obj.get(String.valueOf(subSectionCustomSetting.get('Privacy_Field_API__c')))); 
                            system.debug('obj'+obj);
                        }
                        objsToUpdateMap.put(obj.Id, obj);
                        system.debug('!@#$$$ objsToUpdateMap'+objsToUpdateMap);
                    }
                }

                /*for(sObject subSectionObj : lstSectionCustomSetting)
                {
                    system.debug('\n\n\n sectionIdToObjMap: '+sectionIdToObjMap+'\n\n\n');
                    system.debug('\n\n\n subSectionObj.Id: '+subSectionObj.Id+'\n\n\n');
                    
                    objs = sectionIdToObjMap.get(subSectionObj.Id);
                    sObject obj = objs[0];
                    String objectCS = String.valueOf(subSectionObj.get('Object__c'));
                    sObject objToUpdate = Schema.getGlobalDescribe().get(objectCS).newSObject();
                    objToUpdate.Id = obj.Id;
                    system.debug('\n\n\n obj: '+obj+'\n\n\n');
                    system.debug('\n\n\n objsToUpdateMap: '+objsToUpdateMap+'\n\n\n');
                    if(objsToUpdateMap.get(obj.Id)!=null)
                    {
                         system.debug('\n\n\n objsToUpdateMap: '+objsToUpdateMap+'\n\n\n');
                        objToUpdate = objsToUpdateMap.get(obj.Id);
                    }

                    system.debug('\n\n\n objsToUpdateMap: '+objsToUpdateMap+'\n\n\n');
                    
                    system.debug('\n\n\n sectionIdToFieldsMap: '+sectionIdToFieldsMap+'\n\n\n');
                    system.debug('\n\n\n sectionIdToFieldsMap.get(subSectionObj.Id): '+sectionIdToFieldsMap.get(subSectionObj.Id)+'\n\n\n');
                    for(sObject fieldsCS : sectionIdToFieldsMap.get(subSectionObj.Id))
                    {
                        system.debug('\n\n\n %%% fieldsCS: '+fieldsCS+'\n\n\n');
                        if(fieldsCS.get('Read_Only__c')==false)
                        {
                            system.debug('^^^ inside Readonly..!! ');
                            system.debug('\n\n\n fieldsCS.get(Read_Only__c): '+fieldsCS.get('Read_Only__c')+'\n\n\n');
                            objToUpdate.put(String.valueOf(fieldsCS.get('Field_API_Name__c')), obj.get(String.valueOf(fieldsCS.get('Field_API_Name__c')))); 
                            system.debug('\n\n\n @!@!objToUpdate..!! ;'+ objToUpdate);
                        }
                        if(fieldsCS.get('Privacy_Field_API__c')!=null)
                        {
                            system.debug('\n\n\n fieldsCS.get(Privacy_Field_API__c): '+fieldsCS.get('Privacy_Field_API__c')+'\n\n\n');
                            objToUpdate.put(String.valueOf(fieldsCS.get('Privacy_Field_API__c')), obj.get(String.valueOf(fieldsCS.get('Privacy_Field_API__c'))));
                            system.debug('\n\n\n ## objToUpdate: '+objToUpdate+'\n\n\n');              
                        }
                        objsToUpdateMap.put(objToUpdate.Id, objToUpdate);
                        system.debug('\n\n\n objsToUpdateMap: '+objsToUpdateMap+'\n\n\n');
                    }
                }*/

                system.debug('\n\n\n subSectionCustomSetting.Custom_Setting__c: '+subSectionCustomSetting.get('Custom_Setting__c')+'\n\n\n');
                system.debug('\n\n\n lstSubsectionCustomSetting: '+lstSubsectionCustomSetting+'\n\n\n');

                list<sObject> currentLstSubsectionCustomSetting = mapOfLstSubsectionCustomSetting.get(String.valueOf(subSectionCustomSetting.get('Custom_Setting__c')));
                system.debug('\n\n\n currentLstSubsectionCustomSetting: '+currentLstSubsectionCustomSetting+'\n\n\n');
                for(sObject subSectionObj : currentLstSubsectionCustomSetting) {
                    system.debug('\n\n\n sectionIdToObjMap: '+sectionIdToObjMap+'\n\n\n');
                    system.debug('\n\n\n subSectionObj.Id: '+subSectionObj.Id+'\n\n\n');
                    
                    objs = sectionIdToObjMap.get(subSectionObj.Id);
                    sObject obj = objs[0];
                    String objectCS = String.valueOf(subSectionObj.get('Object__c'));
                    sObject objToUpdate = Schema.getGlobalDescribe().get(objectCS).newSObject();
                    objToUpdate.Id = obj.Id;
                    system.debug('\n\n\n obj: '+obj+'\n\n\n');
                    system.debug('\n\n\n objsToUpdateMap: '+objsToUpdateMap+'\n\n\n');
                    if(objsToUpdateMap.get(obj.Id) != null) {
                         system.debug('\n\n\n objsToUpdateMap: '+objsToUpdateMap+'\n\n\n');
                        objToUpdate = objsToUpdateMap.get(obj.Id);
                    }
                    system.debug('\n\n\n objsToUpdateMap: '+objsToUpdateMap+'\n\n\n');
                    system.debug('\n\n\n sectionIdToFieldsMap: '+sectionIdToFieldsMap+'\n\n\n');
                    system.debug('\n\n\n sectionIdToFieldsMap.get(subSectionObj.Id): '+sectionIdToFieldsMap.get(subSectionObj.Id)+'\n\n\n');
                    for(sObject fieldsCS : sectionIdToFieldsMap.get(subSectionObj.Id)) {
                        system.debug('\n\n\n %%% fieldsCS: '+fieldsCS+'\n\n\n');
                        if(fieldsCS.get('Read_Only__c') == false) {
                            system.debug('^^^ inside Readonly..!! ');
                            system.debug('\n\n\n fieldsCS.get(Read_Only__c): '+fieldsCS.get('Read_Only__c')+'\n\n\n');
                            objToUpdate.put(
                                String.valueOf(fieldsCS.get('Field_API_Name__c')), 
                                obj.get(String.valueOf(fieldsCS.get('Field_API_Name__c')))
                            ); 
                            system.debug('\n\n\n @!@!objToUpdate..!! ;'+ objToUpdate);
                        }
                        if(fieldsCS.get('Privacy_Field_API__c') != null) {
                            system.debug('\n\n\n fieldsCS.get(Privacy_Field_API__c): '+fieldsCS.get('Privacy_Field_API__c')+'\n\n\n');
                            objToUpdate.put(
                                String.valueOf(fieldsCS.get('Privacy_Field_API__c')), 
                                obj.get(String.valueOf(fieldsCS.get('Privacy_Field_API__c')))
                            );
                            system.debug('\n\n\n ## objToUpdate: '+objToUpdate+'\n\n\n');              
                        }
                        objsToUpdateMap.put(objToUpdate.Id, objToUpdate);
                        system.debug('\n\n\n objsToUpdateMap: '+objsToUpdateMap+'\n\n\n');
                    }
                }
            }
        }
        try {
            system.debug('\n\n\n objsToUpdateMap.Values(): '+objsToUpdateMap.Values()+'\n\n\n');
            system.debug('\n\n\n currentContact '+ currentContact +'\n\n\n');
            update objsToUpdateMap.Values();
            update currentContact;
            system.debug('****currentContact******'+currentContact);
            callPoBox();
        } catch(Exception e) {
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'System.DmlException: Update failed.');
             //ApexPages.addMessage(myMsg);
             ApexPages.addMessages(e);
             //pageFailed = true;
             return null;
        }
        isEditMode = false;
        init(subSectionCustomSettings);
        
        //Clear map to display edit links
        for(String objRecord : mapEditableFields.keyset()) { 
            mapEditableFields.put(objRecord, false);
        }
        return null;
    }

    public void callPoBox()
    {
        system.debug('\n\n\n ********* callPoBox: ' + callPoBox + '**************\n\n\n');
        if(callPoBox)
        {
            //PoBox pobox = new PoBox();
            PoBox.makeCallout(userinfo.getUserId());
            //system.debug('\n\n\n ********* poBoxSuccess: ' + poBoxSuccess + '**************\n\n\n');
            /*if(poBoxSuccess)
            {
                 ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Email forwarding successfully updated to '+currentContact.PO_Box_Target__c));
            }*/
        }
    }

    public PageReference cancel() {
        isDisplayAdd = false;
        show = false;
        system.debug('\n\n CANCEL \n\n');
        isEditMode = false;
        init(subSectionCustomSettings);
        return null;
    }

    public String pageSectionId {get; set;}

    //Method to save related list record
    public void saveSobjectRecordToList() {
        try {
            if(String.isNotBlank(pageSectionId)) {
                system.debug('***sectionIdToRelatedListObjectMap' + sectionIdToRelatedListObjectMap);
                system.debug('***subSectionCustomSettingMap' + subSectionCustomSettingMap);
                if(sectionIdToRelatedListObjectMap.containsKey(pageSectionId)) {
                    sObject objToInsert = sectionIdToRelatedListObjectMap.get(pageSectionId);
                    if(subSectionCustomSettingMap.containsKey(pageSectionId)) {
                        sObject csObj = subSectionCustomSettingMap.get(pageSectionId);
                        objToInsert.put(String.valueOf(csObj.get('Field_API_For_Contact_Id__c')), currentUserContactId);
                        system.debug('***csObj.get(Record_Type_Id__c)' + csObj.get('Record_Type_Id__c'));
                        if(String.isNotBlank(String.valueOf(csObj.get('Record_Type_Id__c')))) {
                            objToInsert.put('RecordTypeId', String.valueOf(csObj.get('Record_Type_Id__c')));
                        }
                    }
                    
                    insert objToInsert;
                    system.debug('***objToInsert' + objToInsert);
                    init(subSectionCustomSettings);
                    mapEditableFields.put(objToInsert.id, false);
                    //mapEditableFields.put(String.valueOf(objToInsert.id).subString(0, 15), false);
                    //return null; 
                }
            }
        } catch(Exception e) {
            system.debug('\n\n ERROR: '+e+'\n\n');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'System.DmlException: Insert failed.');
            ApexPages.addMessage(myMsg);
            ApexPages.addMessages(e);
            //pageFailed = true;
            //return;
        }
    }

    public String realtedListObjId {get; set;}

    //Method to delete Related list Record
    public PageReference deleteRelatedList() {
        try {
            sObject objToDelete = sectionObjIdToSectionObj.get(realtedListObjId);
            delete objToDelete;
            system.debug('***objToDelete' + objToDelete);
            init(subSectionCustomSettings);
            system.debug('***AfterdeleteRelatedList' + sectionObjIdToSectionObj);
            system.debug('***mapEditableFields' + mapEditableFields);
            //mapEditableFields.remove(realtedListObjId);
        } catch(Exception e) {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'System.DmlException: Delete failed.');
                 ApexPages.addMessage(myMsg);
                 ApexPages.addMessages(e);
                 //pageFailed = true;
                 //return null;
        }
        return null;
    }

    //Method to cancel edit row view
    public PageReference cancelRelatedFullRecord() {
        init(subSectionCustomSettings);
        return null;
    }

    public PageReference editRelatedList() {
        show = true;
        isDisplayAdd = false;
        showEdit = true; 
        system.debug('sectionIdToRelatedListObjectMap***' + sectionIdToRelatedListObjectMap);
        mapEditableFields = new map<String, boolean>();
        system.debug('\n\n realtedListEditObjId***:' + realtedListEditObjId + '\n\n');
        if(!String.isBlank(realtedListEditObjId)) {
            mapEditableFields.put(realtedListEditObjId,true);
            //mapEditableFields.put(String.valueOf(realtedListEditObjId).subString(0, 15), true);
        }
        system.debug('***mapEditableFields' + mapEditableFields);
        init(subSectionCustomSettings);
        system.debug('***mapEditableFields' + mapEditableFields);
        
        //Student_Enrollment__c obj = new Student_Enrollment__c(LastEnrollmentTerm__c= '2020', name='test');
        //insert obj;
        //system.debug('***sectionObjIdToSectionObj' + sectionObjIdToSectionObj);
        //system.debug('***realtedListEditObjId' + realtedListEditObjId);
        if(sectionObjIdToSectionObj.containsKey(realtedListEditObjId)) {
            objStudent = sectionObjIdToSectionObj.get(realtedListEditObjId);
        }
        system.debug('***objStudent' + objStudent);
        init(subSectionCustomSettings);
        return null;
    }

    //Method for related list compact edit link
     public PageReference editRelatedListCompact() {
        show = false;
        isDisplayAdd = false;
        showEdit = true; 
        mapEditableFields = new map<String, boolean>();
        system.debug('relatedListCompEditId***' + relatedListCompEditId);
        if(!String.isBlank(relatedListCompEditId)) {
            mapEditableFields.put(relatedListCompEditId,true);
            //mapEditableFields.put(String.valueOf(realtedListEditObjId).subString(0, 15), true);
        }
        system.debug('***mapEditableFields' + mapEditableFields);
        init(subSectionCustomSettings);
        system.debug('***mapEditableFields' + mapEditableFields);
        
        //Student_Enrollment__c obj = new Student_Enrollment__c(LastEnrollmentTerm__c= '2020', name='test');
        //insert obj;
        //system.debug('***sectionObjIdToSectionObj' + sectionObjIdToSectionObj);
        //system.debug('***realtedListEditObjId' + realtedListEditObjId);
        if(sectionObjIdToSectionObj.containsKey(relatedListCompEditId)) {
            objStudent = sectionObjIdToSectionObj.get(relatedListCompEditId);
        }
        system.debug('***objStudent' + objStudent);
        return null;
    }

    /*public Pagereference saveSobjectRecordToListFull()
    {
        system.debug('\n\n TEST \n\n');
        sObject objToInsert = sectionIdToRelatedListObjectMap.get(pageSectionId);
        insert objToInsert;
        return null;
    }*/

    /* public String CreateHTMLForPage(list<sObject> subSections,  map<String, sObject> sectionIdToObjMap, map<String, list<sObject>> sectionIdToFieldsMap)
    {
        String html = '';
        for(sObject subSection : subSections)
        {   
            sObject obj = sectionIdToObjMap.get(String.ValueOf(subSection.get('Id')));
            list<Sobject> customSettingFields = sectionIdToFieldsMap.get(String.ValueOf(subSection.get('Id')));
            html = html + '<div><b>'+subSection.get('Title__c')+'</b><hr/></div>';
            system.debug('\n\n\n'+subSection.get('Custom_Setting_Type__c')+'\n\n\n');
        
            if(obj != null || customSettingFields != null){
                html = html + create2ColumnHTML(obj, customSettingFields,string.valueOf(subSection.get('Custom_Setting_Type__c')).substring(0,1));
            }
        }
        return html;
    }
*/
/*  public String create2ColumnHTML(sObject obj, list<sObject> customSettingFields)
    {
        Integer rowNum = 1;
        String html = '<table>';
        for(sObject field : customSettingFields)
        {
            if(math.MOD(rowNum, 2)!=0)
            {
                html = html + '<tr><td>'+obj.get(String.valueOf(field.get('Field_API_Name__c')))+'</td>';
            }
            else
            {
                html = html + '<td>'+obj.get(String.valueOf(field.get('Field_API_Name__c')))+'</td></tr>';
            }
            rowNum++;
        }   
        html = html + '</table>';
        return html;
    }*/
    
   /* public String create2ColumnHTML(sObject obj, list<sObject> customSettingFields, string pColumns)
    {
        Integer columnSize = integer.valueOf(pColumns);
        String html = '<table>';
        if(columnSize > 1){
            Integer rowNum = 1;
            for(sObject field : customSettingFields){
                if(math.MOD(rowNum, columnSize)!=0 && obj.get(String.valueOf(field.get('Field_API_Name__c'))) != null){
                    
                    html = html + '<tr><td>'+obj.get(String.valueOf(field.get('Field_API_Name__c')))+'</td>';
                }
                else{
                    if(obj.get(String.valueOf(field.get('Field_API_Name__c'))) != null){
                        html = html + '<td>'+obj.get(String.valueOf(field.get('Field_API_Name__c')))+'</td></tr>';
                    }
                }
                rowNum++;
            }   
        }
        else{
            for(sObject field : customSettingFields){
                if(obj.get(String.valueOf(field.get('Field_API_Name__c'))) != null){
                    html = html + '<tr><td>'+obj.get(String.valueOf(field.get('Field_API_Name__c')))+'</td></tr>';
                }
            }
        }
        html = html + '</table>';
        return html;
    }*/

    //Method which returns all the web content records
    public Pagereference createRelatedListFullRecord() {
        isCreate = true;
        return null;
    }

    public void test() {
        System.debug('----relatedFullId---'+relatedFullId);
        system.debug('***sectionIdToObjMap' + sectionIdToObjMap);
    }

    //Method to update related list full record
    public Pagereference UpdateRelatedFullRecord () {
        /*show = false;
        isDisplayAdd = true;
        system.debug('***sectionIdToObjMap' + sectionIdToObjMap);
        system.debug('***relatedFullId' + relatedFullId);
        system.debug('***relatedListCompEditId' + relatedListCompEditId);
        String idSobjectRecord;
        Sobject objUpdatRelatedListRecord;
        set<Id> setStoreId = new set<Id>();
        for(list<Sobject> lstRelatedFull : sectionIdToObjMap.values()) {
            for(Sobject objRelatedFull : lstRelatedFull) {
                idSobjectRecord = String.valueOf(objRelatedFull.get('id'));
                system.debug('***objRelatedFull' + objRelatedFull);
                if(idSobjectRecord.equalsIgnoreCase(relatedFullId) && !setStoreId.contains(idSobjectRecord)) {
                    setStoreId.add(idSobjectRecord);
                    system.debug('***Inside' + idSobjectRecord);
                    system.debug('***objRelatedFull' + objRelatedFull);
                    objUpdatRelatedListRecord =  objRelatedFull;
                    system.debug('***objUpdatRelatedListRecord---------------' + objUpdatRelatedListRecord);
                }
            }
        }
        if(objUpdatRelatedListRecord != null){
            system.debug('***objUpdatRelatedListRecord' + objUpdatRelatedListRecord);
            update objUpdatRelatedListRecord;
            system.debug('***objUpdatRelatedListRecord' + objUpdatRelatedListRecord);
            mapEditableFields.put(realtedListEditObjId, false);
        }
        //relatedFullId ='';
        init(subSectionCustomSettings);
        realtedListEditObjId = '';
        return null;*/

        show = false;
        isDisplayAdd = true;
        system.debug('***sectionIdToObjMapCompact' + sectionIdToObjMap);
        system.debug('***mapEditableFields' + mapEditableFields);
        system.debug('***realtedListEditObjId' + realtedListEditObjId);
        String idSobjectRecord;
        Sobject objUpdatRelatedListRecord;
        /*set<Id> setStoreId = new set<Id>();
        for(list<Sobject> lstRelatedFull : sectionIdToObjMap.values()) {
            for(Sobject objRelatedFull : lstRelatedFull) {
                idSobjectRecord = String.valueOf(objRelatedFull.get('id'));
                system.debug('***objRelatedFull' + objRelatedFull);
                if(idSobjectRecord.equalsIgnoreCase(relatedFullId) && !setStoreId.contains(idSobjectRecord)){
                    setStoreId.add(idSobjectRecord);
                    system.debug('***Inside' + idSobjectRecord);
                    objUpdatRelatedListRecord =  objRelatedFull;
                }
            }
        }*/
        for(list<Sobject> lstRelatedCompact : sectionIdToObjMap.values()) {
            for(Sobject objRelatedCompact : lstRelatedCompact){
                if(realtedListEditObjId.equalsIgnoreCase(String.valueOf(objRelatedCompact.get('Id')))) {
                    objUpdatRelatedListRecord = objRelatedCompact;
                }
            }
        }
        if(objUpdatRelatedListRecord != null) {
            update objUpdatRelatedListRecord;
            
            system.debug('***objUpdatRelatedListRecord' + objUpdatRelatedListRecord);
            system.debug('***mapEditableFields' + mapEditableFields);
            mapEditableFields.put(realtedListEditObjId,false);
           // mapEditableFields.put(String.valueOf(relatedFullId).subString(0, 15), false);
            system.debug('***mapEditableFields' + mapEditableFields);
        }
        init(subSectionCustomSettings);
        realtedListEditObjId ='';
        return null;
    }

    //Method to update related list Compact record
    public Pagereference UpdateRelatedCompactRecord () {
        show = false;
        isDisplayAdd = true;
        system.debug('***sectionIdToObjMapCompact' + sectionIdToObjMap);
        system.debug('***mapEditableFields' + mapEditableFields);
        system.debug('***realtedListEditObjId' + realtedListEditObjId);
        String idSobjectRecord;
        Sobject objUpdatRelatedListRecord;
        /*set<Id> setStoreId = new set<Id>();
        for(list<Sobject> lstRelatedFull : sectionIdToObjMap.values()) {
            for(Sobject objRelatedFull : lstRelatedFull){
                idSobjectRecord = String.valueOf(objRelatedFull.get('id'));
                system.debug('***objRelatedFull' + objRelatedFull);
                if(idSobjectRecord.equalsIgnoreCase(relatedFullId) && !setStoreId.contains(idSobjectRecord)) {
                    setStoreId.add(idSobjectRecord);
                    system.debug('***Inside' + idSobjectRecord);
                    objUpdatRelatedListRecord =  objRelatedFull;
                }
            }
        }*/
        for(list<Sobject> lstRelatedCompact : sectionIdToObjMap.values()) {
            for(Sobject objRelatedCompact : lstRelatedCompact){
                if(relatedListCompEditId.equalsIgnoreCase(String.valueOf(objRelatedCompact.get('Id')))) {
                    objUpdatRelatedListRecord = objRelatedCompact;
                }
            }
        }
        if(objUpdatRelatedListRecord != null) {
            update objUpdatRelatedListRecord;
            system.debug('***objUpdatRelatedListRecord' + objUpdatRelatedListRecord);
            system.debug('***mapEditableFields' + mapEditableFields);
            mapEditableFields.put(relatedListCompEditId,false);
            // mapEditableFields.put(String.valueOf(relatedFullId).subString(0, 15), false);
            system.debug('***mapEditableFields' + mapEditableFields);
        }
        init(subSectionCustomSettings);
        relatedListCompEditId ='';
        return null;
    }

    //Method to convert web content record to picklist values
    public void getPicklistFieldValues(list<Sobject> pLstCustomSettingFields) {
        system.debug('****pLstCustomSettingFields' + pLstCustomSettingFields);
        String picklistValuesString ='';
        list<String> lstSelectOptionValues;
        
        //mapCustomFieldWithSelectList = new map<String , list<SelectOption>>();
        lstWrapper = new list<fieldWrapperClass>();
        if(pLstCustomSettingFields != null) {
            for(Sobject objCustomSettingField : pLstCustomSettingFields) {
                list<SelectOption> lstSelectOption = new list<SelectOption>();
                //lstSelectOption.add(new selectOption('--None--', '--None--'));
                if(String.ValueOf(objCustomSettingField.get('Picklist__c'))!=null && 
                    String.ValueOf(objCustomSettingField.get('Picklist__c')).startsWith('Community_Web_Content__c.')) {
                    picklistValuesString = 
                        CommunityContentHelper.getContent(String.ValueOf(objCustomSettingField.get('Picklist__c')));
                    if(!String.IsBlank(picklistValuesString)){
                        lstSelectOptionValues = picklistValuesString.split(';');
                    }
                    for(String objSelectOptionValue : lstSelectOptionValues) {
                        lstSelectOption.add(new selectOption(objSelectOptionValue, objSelectOptionValue));
                    }
                }
                lstWrapper.add(new fieldWrapperClass(String.valueOf(objCustomSettingField.get('Field_API_Name__c')),lstSelectOption,''));
            }
        }
    }

    public class wrapperSectionIdToObj {

        public String customSettingId {get; set;}
        public list<wrapperEditableRecords> lstRecords {get; set;}

        public wrapperSectionIdToObj(String pCustomSettingId, list<wrapperEditableRecords> pLstRecords) {
            customSettingId = pCustomSettingId;
            lstRecords = pLstRecords;
        }
    }

    public class wrapperEditableRecords {

        public Sobject objRecord{ get; set;}
        public boolean isEditable { get; set;}

        public wrapperEditableRecords(Sobject pObjRecord, boolean pIsEditable) {
            this.objRecord = pObjRecord;
            this.isEditable = pIsEditable;
        }
    }

    public class fieldWrapperClass {

        public String FieldApiName {get; set;}
        public list<selectOption> lstSelectOption {get; set;}
        public String SelectedValue {get; set;}

        public fieldWrapperClass(String pFieldApiName, list<SelectOption> plstselectOption, String pSelectedValue) {
            this.FieldApiName = pFieldApiName;
            this.lstSelectOption = plstselectOption;
            this.SelectedValue = pSelectedValue;
        }
    }

}//End Class