public class DynamicRelationshipQueriesController 
{
    public list<sObject> queriedParentRecords{get; set;}
    
    public List<String> queriesGenerated {get; set;}    
    private Map<String, List<String>> objectNameToSearchFieldsMap {get; set;}
    private Map<String, Integer> objectLevelMap {get; set;}
    private Map<Integer, String> levelObjectMap {get; set;}
    public Integer deepestLevel {get; set;}
    
    private sObject queriedFields {get; set;}              //Parent fields to be queried
    private List<sObject> queriedSourceRecords {get;set;}
    private List<helperClass> queriedSourceWrapperRecords {get;set;}
    private String queryString {get; set;}
    public String jsonStr {get; set;}
    private Map<String, list<String>> labelApiNameMap {get; set;}
    private Map<String, String> apiNameLabelMap {get; set;}
    private boolean useSosl {get; set;}
    private String soslString {get; set;}
    
    public String parentObjectName {get; set;}
    public String childrenString {get; set;}
    public String grandchildrenString {get; set;}
    
    private String fieldsToDisplay {get; set;}
    private List<String> sourceObjectFields {get; set;}
    
    private String fieldsString {get; set;}
    private String filterString {get; set;}
    private String sortStr {get; set;}
    private List<String> labelList {get; set;}
        
    private final String CustomSettingName = 'DynamicQueryFields__c';

    private map<String, String> ForeignKeysMap{get; set;} 
    private map<String, String> ForeignKeyApiNameMap{get; set;} 
    
    //default custom setting record
    private String CustomSettingRecordName {get; set;}
    private String nameSpace {get; set;}
    
    //default View
    private String viewName {get; set;}
    
    private Integer pageNumber {get; set;}
    private Boolean pageNumberProvided {get; set;}
    private Integer positionOnPage {get; set;}
    private Integer pageSize {get; set;}
    private Integer offset {get; set;}

    private String staticWhere { get; set; }

    private String filterId {get; set;}

    private Boolean count {get; set;}
    
    private class helperClass 
    {
        private sObject sObj {get; set;}
        
        private list<String> fields = new list<String>();
        private map<String, String> socialIconURLMap = new map<String, String>();

        private Integer pageNumber = 0;
        private Integer positionOnPage = 0;
        private Integer recordCount = 0;
        
        public helperClass(sObject so, list<String> fieldValues,
            map<String, String> socialIconURLMapValues,
            Integer pn, Integer pos)
        {
            sObj = so;
            pageNumber = pn;
            positionOnPage = pos;
            fields = fieldValues;
            socialIconURLMap = socialIconURLMapValues;
        }

        public helperClass(Integer rc)
        {
            recordCount = rc;
        }       
    }
    
    public DynamicRelationshipQueriesController()
    {
        ForeignKeysMap = getForeignKeysMap(CustomSettingName);
        ForeignKeyApiNameMap = getForeignKeyApiNameMap();

        //Initialize variables
        queriedParentRecords = new List<sObject>();

        //default custom setting record
        CustomSettingRecordName = 'Profile';
        nameSpace = '';
        
        //default View
        viewName = 'ListView__c';
        
        pageNumber = 1;
        pageNumberProvided = false;
        positionOnPage = 0;
        pageSize = 20;
        offset = 0;
    
        queriesGenerated = new List<String>();
        objectNameToSearchFieldsMap = new Map<String, List<String>>();
        objectLevelMap = new Map<String, Integer>();
        levelObjectMap = new Map<Integer, String>();
        
        labelApiNameMap = new Map<String, list<String>>();
        apiNameLabelMap = new Map<String, String>();
        labelList = new List<String>();
        filterString = '';
        childrenString = '';
        grandchildrenString = '';
        useSosl = false;
        deepestLevel = 0;
        count = false;

        Map<String, String> pageParameters = ApexPages.currentPage().getParameters();
        system.debug('***pageParameters' + pageParameters);
        
        for (String parameterName : pageParameters.keySet())
        {
            if (parameterName.startsWith('rel'))
            {
                List<String> tmpStrs = parameterName.replace('rel.', '').split('\\.'); 
                system.debug('***tmpStrs' + tmpStrs);
                
                if (tmpStrs.size()==2)
                {           
                    String valueStr = tmpStrs[1] + '=' + pageParameters.get(parameterName);
                    
                    if (objectNameToSearchFieldsMap.containsKey(tmpStrs[0]))
                        objectNameToSearchFieldsMap.get(tmpStrs[0]).add(valueStr);
                    else objectNameToSearchFieldsMap.put(tmpStrs[0], new List <String> { valueStr });                   
                }
            }
        }
        
        System.debug('\n\n\nobjectNameToSearchFieldsMap is: ' + objectNameToSearchFieldsMap + '\n\n\n');
        
        if(ApexPages.currentPage().getParameters().get('name') != null && ApexPages.currentPage().getParameters().get('name') != '')
            CustomSettingRecordName = ApexPages.currentPage().getParameters().get('name');
            
        if(ApexPages.currentPage().getParameters().get('view') != null && ApexPages.currentPage().getParameters().get('view') != '')
        {
            String tmpStr = nameSpace + ApexPages.currentPage().getParameters().get('view') + 'View__c';
            
            Map<String, Schema.SObjectField> customSettingFields = Schema.getGlobalDescribe().get(CustomSettingName).getDescribe().fields.getMap(); 

            //check if ViewName is part of the Custom Setting
            if(customSettingFields.containsKey(tmpStr)) 
                viewName = tmpStr;            
        }
                        
        if(ApexPages.currentPage().getParameters().get('pagesize') != null && ApexPages.currentPage().getParameters().get('pagesize') != '')
        {
            if (Integer.valueOf(ApexPages.currentPage().getParameters().get('pagesize')) > 0)
                pageSize = Integer.valueOf(ApexPages.currentPage().getParameters().get('pagesize'));
        }
        
        if(ApexPages.currentPage().getParameters().get('pagenumber') != null && ApexPages.currentPage().getParameters().get('pagenumber') != '')
        {
            if (Integer.valueOf(ApexPages.currentPage().getParameters().get('pagenumber')) > 0)   
            {
                pageNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('pagenumber'));
                pageNumberProvided = true;
            }
        }
                
        offset = pageSize * (pageNumber-1);   
        
        if(ApexPages.currentPage().getParameters().get('q') != null && ApexPages.currentPage().getParameters().get('q') != '')
        {
            soslString = ApexPages.currentPage().getParameters().get('q');      
            useSosl = true;
        }

        if(ApexPages.currentPage().getParameters().get('count') != null && ApexPages.currentPage().getParameters().get('count') != '' && 
            ApexPages.currentPage().getParameters().get('count')=='true')
        {
            count = true;
        }
        
        queriedSourceRecords = new List<sObject>(); 
        queriedSourceWrapperRecords = new List<helperClass>();

        queriesGenerated = generateQueries();
        system.debug('***queriesGenerated' + queriesGenerated);
        
        if(count==true)
        {
            if(queriedParentRecords.size()>0)
            {
                convertQueriedRecordsToCountWrapperClass(true);
            }
            else
            {
                convertQueriedRecordsToCountWrapperClass(false);
            }
        }
        else
        {
            convertQueriedRecordsToWrapperClass();
        }
        system.debug('***queriesGenerated***End');
        
        jsonStr = JSON.serialize(queriedSourceWrapperRecords); 
        jSonStr = replaceApiNamesWithLabels(jsonStr);
        jSonStr = jSonStr.replace(parentObjectName, CustomSettingRecordName);   
    }
    
    private map<String, String> objectLabelToFilterIdMap = new map<String, String>();
    private void findObjectLevel(String objectLabel, String parentLabel)
    {
        Integer level = 0;
        
        //find Foreign Key Value on 'objectLabel' Custom Setting record
        //String foreignKey = getForeignKey(CustomSettingName, objectLabel);
        system.debug('\n\n\n ForeignKeysMap: '+ForeignKeysMap+'\n\n\n');
        system.debug('\n\n\n objectLabel: '+objectLabel+'\n\n\n');
        system.debug('\n\n\n ForeignKeysMap.get(objectLabel): '+ForeignKeysMap.get(objectLabel.toLowerCase())+'\n\n\n');
        String foreignKey = ForeignKeysMap.get(objectLabel.toLowerCase());

        System.debug('\n\n\nForeign Key for ' + objectLabel + ' is ' + foreignKey + '\n\n\n');
        
        //find object API name for Foreign Key found above
        //String objectName = getForeignKeyApiName(foreignKey);
        String objectName = ForeignKeyApiNameMap.get(foreignKey.toLowerCase());

        if (objectName == parentObjectName) level = 1;
        else 
        {
            String queryStr = 'Select ForeignKey__c, FilterId__c from ' + CustomSettingName + ' where SourceObjectName__c=\'' + objectName + '\'';
            sObject objectFields = Database.query(queryStr);    

            String objLabel = String.valueOf(objectFields.get('ForeignKey__c')); 
            //objectName = getForeignKeyApiName(objLabel);
            objectName = ForeignKeyApiNameMap.get(objLabel.toLowerCase());

            if (objectName == parentObjectName) level = 2;
            objectLabelToFilterIdMap.put(objectLabel, String.valueOf(objectFields.get('FilterId__c')));
        }
        
        if (deepestLevel < level) deepestLevel = level;
        
        objectLevelMap.put(objectLabel, level);
        levelObjectMap.put(level, objectLabel);
    }
    
    private void getParentFields(String customSettingName, String CustomSettingRecordName)
    {
        System.debug('\n\n\nIn getFields\n\n\n');
        System.debug('***ViewName***' + viewName);
        
        String queryStr = 'Select SourceObjectName__c, SourceObjectFields__c, Static_Where__c, Privacy_Fields__c, Social_Icon_Map__c, FilterId__c, MapView__c, ' + viewName + ' from ' + customSettingName + ' where Name=\'' + CustomSettingRecordName + '\''; 
        System.debug('\n\n\n queryStr:'+queryStr+'\n\n\n');
        queriedFields = Database.query(queryStr);   
        
        system.debug('queriedFields****' +  queriedFields);
        
        String sourceObjectFields = String.valueOf(queriedFields.get('SourceObjectFields__c'));
        if(String.valueOf(queriedFields.get('SourceObjectFields__c'))!=null && 
           String.valueOf(queriedFields.get('SourceObjectFields__c')).startsWith('Community_Web_Content__c.'))
        {
            sourceObjectFields = CommunityContentHelper.getContent(String.valueOf(queriedFields.get('SourceObjectFields__c')));
        }
        
        System.debug('sourceObjectFields' + sourceObjectFields);
        
        buildParentMaps(sourceObjectFields);
        
        
        
        //fieldsToDisplay = String.valueOf(queriedFields.get(viewName));
        fieldsToDisplay = getFieldsToDisplay();

        filterId = String.valueOf(queriedFields.get('FilterId__c'));

        System.debug('\n\n\n filterId: '+filterId+'\n\n\n');        

        staticWhere = String.valueOf(queriedFields.get('Static_Where__c'));
        
        System.debug('\n\n\n22222222222222222222222222222222\n\n\n');       
    }
    
    private String getFieldsToDisplay()
    {
        System.debug('\n\n\nIn getFieldsToDisplay\n\n\n');
        String fieldsTD = '';
        fieldsTD = String.valueOf(queriedFields.get(viewName));

        // Get map fields to return
        if(queriedFields.get('MapView__c')!='' && queriedFields.get('MapView__c')!=null)
        {
            fieldsTD = fieldsTD + ', ' + String.valueOf(queriedFields.get('MapView__c'));
        }

        Map<String, String> socialIconMap = createCustomSettingMap(String.valueOf(queriedFields.get('Social_Icon_Map__c')));
        system.debug('\n\n socialIconMap: '+socialIconMap+'\n\n');
        for(String socialIconField : socialIconMap.keySet())
        {
            fieldsTD = fieldsTD + ', ' + socialIconField;
        }

        Map<String, String> privacyMap = createCustomSettingMap(String.valueOf(queriedFields.get('Privacy_Fields__c')));
        for(String privacyField : privacyMap.values())
        {
            fieldsTD = fieldsTD + ', ' + privacyField;
        }

        // hard code some fields based on object
        if(String.valueOf(queriedFields.get('SourceObjectName__c')).toLowerCase()=='user')
        {
            fieldsTD = fieldsTD + ', FullPhotoUrl, Contact.Name';
        }
        return fieldsTD;
    }

    private void buildParentMaps(String fieldMapping)
    {
        System.debug('\n\n\nIn Build Maps\n\n\n');
        
        if(fieldMapping!=null)
        {   
            labelApiNameMap = new Map<String, list<String>>();
            apiNameLabelMap = new Map<String, String>();
            
            fieldMapping = fieldMapping.replaceAll(' ', '');    
            
            List<String> mappingPairs = fieldMapping.split(';');
            
            fieldsString = '';
            
            //populate Label to API Name Map and API Name to Label Map
            if (mappingPairs.size()>0)
            {
                for (String pair : mappingPairs)
                {
                    List<String> splitPair = pair.split('=');
                    
                    if (splitPair.size()==2)
                    {
                        String label = splitPair[0];
                        String apiNames = splitPair[1];

                        list<String> apiNameList =  new list<String>();
                        if(apiNames.contains(','))
                        {
                            list<String> splitAPIName = apiNames.split(',');
                            for(String apiName : splitAPIName)
                            {
                                apiNameList.add(apiName);   
                                apiNameLabelMap.put(apiName, label);
                                fieldsString += ', ' + apiName;
                            }
                        }
                        else
                        {
                            apiNameList.add(apiNames);  
                            apiNameLabelMap.put(apiNames, label);
                            fieldsString += ', ' + apiNames;
                        }
                        labelApiNameMap.put(label, apiNameList);
                        
                                
                        labelList.add(label);
                    } 
                }
            }
            
            System.debug('\n\n\nlabelApiNameMap is: ' + labelApiNameMap + '\n\n\n');
            System.debug('\n\n\napiNameLabelMap is: ' + apiNameLabelMap + '\n\n\n');
            System.debug('\n\n\nfieldsString is: ' + fieldsString + '\n\n\n');
            System.debug('\n\n\nlabelList is: ' + labelList + '\n\n\n');
            /*System.debug('\n\n\nIn Build Maps\n\n\n');
            
            labelApiNameMap = new Map<String, String>();
            apiNameLabelMap = new Map<String, String>();
            
            fieldMapping = fieldMapping.replaceAll(' ', '');    
            
            List<String> mappingPairs = fieldMapping.split(',');
            
            fieldsString = '';
            
            //populate Label to API Name Map and API Name to Label Map
            if (mappingPairs.size()>0)
            {
                for (String pair : mappingPairs)
                {
                    List<String> splitPair = pair.split('=');
                    
                    if (splitPair.size()==2)
                    {
                        String label = splitPair[0];
                        String apiName = splitPair[1];
                        
                        labelApiNameMap.put(label, apiName);
                        apiNameLabelMap.put(apiName, label);
                        
                        if (fieldsString.length()>0) fieldsString += ', ' + apiName;
                        else fieldsString = apiName;
                                
                        labelList.add(label);
                    } 
                }
            }
            
            System.debug('\n\n\nlabelApiNameMap is: ' + labelApiNameMap + '\n\n\n');
            System.debug('\n\n\napiNameLabelMap is: ' + apiNameLabelMap + '\n\n\n');
            System.debug('\n\n\nfieldsString is: ' + fieldsString + '\n\n\n');
            
            System.debug('\n\n\ntest\n\n\n');
                    
            System.debug('\n\n\nlabelList is: ' + labelList + '\n\n\n');
            */
            System.debug('\n\n\nLeaving buildParentMaps\n\n\n');
        }
    }

    private Schema.DisplayType getFieldType(String obj, String field)
    {
        system.debug('\n\n'+obj+'\n\n');
        system.debug('\n\n'+field+'\n\n');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        system.debug('\n\n'+schemaMap+'\n\n');
        Schema.SObjectType leadSchema = schemaMap.get(obj);
        system.debug('\n\n'+leadSchema+'\n\n');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        system.debug('\n\n'+fieldMap+'\n\n');
        Schema.SObjectField currentField = fieldMap.get(field);
        system.debug('\n\n'+currentField+'\n\n');
        Schema.DisplayType fldType = currentField.getDescribe().getType();
        system.debug('\n\n'+fldType+'\n\n');
        return fldType;
    }

    private Boolean dontNeedQuotes(String fldTypeStr)
    {
        Boolean dontNeedQuotes = false;
        if(fldTypeStr.toLowerCase()=='double' || fldTypeStr.toLowerCase()=='integer' || fldTypeStr.toLowerCase()=='boolean')
        {
            dontNeedQuotes = true;
        }
        return dontNeedQuotes;
    }
    
    private String replaceApiNamesWithLabels(String jStr)
    {
        System.debug('\n\n\nIn replaceApiNamesWithLabels\n\n\n');
        System.debug('\n\n\njStr before is: ' + jStr + '\n\n\n');
        
        for (String apiName : apiNameLabelMap.keySet())
        {
            String searchStr = '\"' + apiName + '\"';  
            String replacementStr = '\"' + apiNameLabelMap.get(apiName) + '\"';  
    
            System.debug('\n\n\nsearchStr is: ' + searchStr + '\n\n\n');
            System.debug('\n\n\nreplacementStr is: ' + replacementStr + '\n\n\n');
            
            if (jStr.contains(searchStr))
                jStr = jStr.replace(searchStr, replacementStr);
        }
        
        System.debug('\n\n\njStr after is: ' + jStr + '\n\n\n');
        
        return jStr;
    }
    
    private String replaceLabelsWithApiNames(String str)
    {
        String initialStr = str;
        
        System.debug('\n\n\nIn replaceLabelsWithApiNames\n\n\n');
        System.debug('\n\n\nstr is: ' + str + '\n\n\n');
        
        for (String label : labelApiNameMap.keySet())
        {
            String searchStr = label;  
            list<String> replacementStrs = labelApiNameMap.get(label);  
            
            System.debug('\n\n\nsearchStr is: ' + searchStr + '\n\n\n');
            System.debug('\n\n\nreplacementStr is: ' + replacementStrs + '\n\n\n');
        
            if (str.contains(searchStr))
            {
                System.debug('\n\n\nsearch str found\n\n\n');
                for(String replacementStr : replacementStrs)
                {
                    if (labelApiNameMap.get(label)!=null)
                        str = str.replace(searchStr, replacementStr);
                    else str = '';
                }
            }           
        }
        
        return str;
    }
    
    private sObject getChildObj(String customSettingName, String recordName)
    {
        system.debug('\n\n\n customSettingName: '+customSettingName+'\n\n\n');
        system.debug('\n\n\n recordName: '+recordName+'\n\n\n');
        String queryStr = 'Select sourceObjectName__c, Privacy_Fields__c, Static_Where__c from ' + customSettingName + ' where Name=\'' + recordName + '\''; 
        list<sObject> childObjs = Database.query(queryStr);
        return childObjs[0];
    }

    /*private String getObjectApiName(String customSettingName, String recordName)
    {   
        String objectName = '';
        sObject objectFields;
        
        String queryStr = 'Select sourceObjectName__c from ' + customSettingName + ' where Name=\'' + recordName + '\''; 
        objectFields = Database.query(queryStr);    
            
        return String.valueOf(objectFields.get('sourceObjectName__c'));
    }*/
    
    /*private String getPrivacyStr(String customSettingName, String recordName)
    {   
        String queryStr = 'Select Privacy_Fields__c from ' + customSettingName + ' where Name=\'' + recordName + '\''; 
        sObject customSettingFields = Database.query(queryStr); 
        
        String privacyStr = String.valueOf(customSettingFields.get('Privacy_Fields__c'));
        
        return privacyStr;
    }*/

    private map<String, String> getForeignKeysMap(String customSettingName)
    {   
        map<String, String> ForeignKeysMap = new map<String, String>();

        String queryStr = 'Select ForeignKey__c, Name from ' + customSettingName; 
        list<sObject> customSettingFields = Database.query(queryStr);   
        
        for(sObject csField : customSettingFields)
        {
            String foreignKey = String.valueOf(csField.get('ForeignKey__c'));
            String recordName = String.valueOf(csField.get('Name'));

            ForeignKeysMap.put(recordName.toLowerCase(), foreignKey);
        }

        system.debug('\n\n\n ForeignKeysMap1:'+ForeignKeysMap+'\n\n\n');
        return ForeignKeysMap;
    }   

    /*private String getForeignKey(String customSettingName, String recordName)
    {   
        String queryStr = 'Select ForeignKey__c from ' + customSettingName + ' where Name=\'' + recordName + '\''; 
        sObject customSettingFields = Database.query(queryStr); 
        
        String foreignKey = String.valueOf(customSettingFields.get('ForeignKey__c'));
        
        return foreignKey;
    }*/
    
    private map<String, String> getForeignKeyApiNameMap()
    {
        map<String, String> ForeignKeyApiNameMap = new map<String, String>();

        String queryStr = 'Select ObjectName__c, Name from ForeignKeys__c'; 
        list<sObject> customSettingFields = Database.query(queryStr);   

        for(sObject csField : customSettingFields)
        {
            String objectName = String.valueOf(csField.get('ObjectName__c'));
            String recordName = String.valueOf(csField.get('Name'));
            ForeignKeyApiNameMap.put(recordName.toLowerCase(), objectName);
        }
        
        return ForeignKeyApiNameMap;
    }

    /*private String getForeignKeyApiName(String recordName)
    {
        String queryStr = 'Select ObjectName__c from ForeignKeys__c where Name=\'' + recordName + '\''; 
        sObject customSettingFields = Database.query(queryStr); 
        
        String objectName = String.valueOf(customSettingFields.get('ObjectName__c'));
        
        return objectName;
    }*/
    
    private list<String> getFieldApiNames(String customSettingName, String recordName, String fieldLabel)
    {   
        String objectName = '';
        list<String> fieldNames = new list<String>();
        sObject customSettingFields;
        
        String queryStr = 'Select sourceObjectName__c, SourceObjectFields__c from ' + customSettingName + ' where Name=\'' + recordName + '\''; 
        customSettingFields = Database.query(queryStr); 
        
        String sourceObjectFields = String.valueOf(customSettingFields.get('SourceObjectFields__c'));
        if(String.valueOf(customSettingFields.get('SourceObjectFields__c'))!=null && 
           String.valueOf(customSettingFields.get('SourceObjectFields__c')).startsWith('Community_Web_Content__c.'))
        {
            sourceObjectFields = CommunityContentHelper.getContent(String.valueOf(customSettingFields.get('SourceObjectFields__c')));
        }

        String fieldMapping = sourceObjectFields;
        
        fieldMapping = fieldMapping.replaceAll(' ', '');        
        List<String> mappingPairs = fieldMapping.split(';');
        
        if (mappingPairs.size()>0)
        {
            for (String pair : mappingPairs)
            {
                if (pair.startsWith(fieldLabel))
                {
                    List<String> splitPair = pair.split('=');
                
                    if (splitPair.size()==2)
                    {
                        if(splitPair[1].contains(','))
                        {
                            list<String> splitAPIName = splitPair[1].split(',');
                            for(String apiName : splitAPIName)
                            {
                                fieldNames.add(apiName);
                            }
                        }
                        else
                        {
                            fieldNames.add(splitPair[1]);
                        }
                    }
                }
            }
        }
        
        return fieldNames;
    }
    
    private String wildCardHandler(String s)
    {
        String newStr = s.replace('*', '%');
        return newStr;
    }

    private String generateWhere(String objectLabel, List<String> fieldLabelValuePairs, String currentLevelObjectLabel)
    {
        system.debug('\n\n\n currentLevelObjectLabel: '+currentLevelObjectLabel+'\n\n\n');
        system.debug('\n\n\n ForeignKeysMap.get(currentLevelObjectLabel.toLowerCase()): '+ForeignKeysMap.get(currentLevelObjectLabel.toLowerCase())+'\n\n\n');

        String filterString = '';
        sObject childObj = getChildObj(CustomSettingName, objectLabel);
        String objectName = String.valueOf(childObj.get('sourceObjectName__c'));
        String privacyStr = String.valueOf(childObj.get('Privacy_Fields__c'));
        String whereStr = String.valueOf(childObj.get('Static_Where__c'));

        String parentObject = '';
        if(ForeignKeysMap.get(currentLevelObjectLabel.toLowerCase()).equalsIgnoreCase('id'))
        {
            parentObject = 'Contact';
        }
        else if(ForeignKeysMap.get(currentLevelObjectLabel.toLowerCase()).containsIgnoreCase('__c'))
        {
            parentObject = ForeignKeysMap.get(currentLevelObjectLabel.toLowerCase()).replace('__c', '__r');
        }
        else
        {
            system.debug('\n\n\n ERROR: Unknow Parent name for query! \n\n\n');
        }
    
        Map<String, String> privacyMap = createCustomSettingMap(privacyStr);    

        system.debug('\n\n\n parentObject: '+parentObject+'\n\n\n');
        system.debug('\n\n\n fieldLabelValuePairs.size(): '+fieldLabelValuePairs.size()+'\n\n\n');
        if (fieldLabelValuePairs.size()>0 && parentObject!='')
        {
            system.debug('%%%%% Inside fieldLabelValuePairs');
            for (Integer i=0; i < fieldLabelValuePairs.size(); i++)
            {
                system.debug('%%%%% Inside For looppp');
                List<String> fieldParts = fieldLabelValuePairs[i].split('=');
                system.debug('%%%%% fieldParts'+fieldParts.size());
                if (fieldParts.size()==2)
                {
                    system.debug('%%%%% fieldParts'+fieldParts);
                    String fieldLabel = fieldParts[0];
                    String fieldValue = String.escapeSingleQuotes(fieldParts[1]);

                    filterString = filterString + '(';
                    for(String fieldAPIName : getFieldApiNames(CustomSettingName, objectLabel, fieldLabel))
                    {
                        filterString = filterString + '(';
                        Schema.DisplayType fldType = getFieldType(objectName, fieldAPIName);

                        system.debug('\n\n\n currentAPIName: '+fieldAPIName+'\n\n\n');
                        if(privacyMap.get(fieldAPIName)!=null)
                        {
                            filterString = filterString + parentObject+'.'+privacyMap.get(fieldAPIName) + '=false AND ';
                        }
                        

                        if(dontNeedQuotes(String.valueOf(fldType)))
                        {
                            if(fieldValue.contains('*'))
                            {
                                filterString = filterString + parentObject+'.'+fieldAPIName + ' like ' + wildCardHandler(fieldValue);
                            }
                            else
                            {
                                filterString = filterString + parentObject+'.'+fieldAPIName + '=' + fieldValue;
                            }
                        }
                        else
                        {
                            if(fieldValue.contains('*'))
                            {
                                filterString = filterString + parentObject+'.'+fieldAPIName + ' like ' + '\'' + wildCardHandler(fieldValue) + '\'';
                            }
                            else
                            {
                                filterString = filterString + parentObject+'.'+fieldAPIName + '=' + '\'' + fieldValue + '\'';
                            }
                        }
                        filterString = filterString + ') OR ';
                    }
                    filterString = filterString.removeEndIgnoreCase(' OR ');
                    filterString = filterString + ') AND ';
                }
            
            }
            filterString = filterString.removeEndIgnoreCase(' AND ');
            if(whereStr!='' && whereStr!=null)
            {
                filterString = filterString + ' AND ' + whereStr;
            }
        }   
        return filterString;
    }

    private String generateChildQuery(String objectLabel, List<String> fieldLabelValuePairs, Integer childLevel)
    {
        String childQ = '';
        String filterString = '';
        
        sObject childObj = getChildObj(CustomSettingName, objectLabel);

        String objectName = String.valueOf(childObj.get('sourceObjectName__c'));
        String privacyStr = String.valueOf(childObj.get('Privacy_Fields__c'));
        String whereStr = String.valueOf(childObj.get('Static_Where__c'));

        //objectName = getObjectApiName(CustomSettingName, objectLabel);
        //String privacyStr = getPrivacyStr(CustomSettingName, objectLabel);
        //String whereStr = getWhereStr(CustomSettingName, objectLabel);
        Map<String, String> privacyMap = createCustomSettingMap(privacyStr);
        String.valueOf(queriedFields.get('Static_Where__c'));
        
        if (fieldLabelValuePairs.size()>0)
        {
            //childQ = 'Select ' + getForeignKey(CustomSettingName, objectLabel) +  ' from ' + objectName + ' where ';
            childQ = 'Select ' + ForeignKeysMap.get(objectLabel.toLowerCase()) +  ' from ' + objectName + ' where ';

            for (Integer i=0; i < fieldLabelValuePairs.size(); i++)
            {
                List<String> fieldParts = fieldLabelValuePairs[i].split('=');
            
                if (fieldParts.size()==2)
                {
                    String fieldLabel = fieldParts[0];
                    String fieldValue = fieldParts[1];

                    filterString = filterString + '(';
                    for(String fieldAPIName : getFieldApiNames(CustomSettingName, objectLabel, fieldLabel))
                    {
                        filterString = filterString + '(';
                        Schema.DisplayType fldType = getFieldType(objectName, fieldAPIName);

                        system.debug('\n\n\n currentAPIName: '+fieldAPIName+'\n\n\n');
                        if(privacyMap.get(fieldAPIName)!=null)
                        {
                            filterString = filterString + privacyMap.get(fieldAPIName) + '=false AND ';
                        }
                        

                        if(dontNeedQuotes(String.valueOf(fldType)))
                        {
                            if(fieldValue.contains('*'))
                            {
                                filterString = filterString + fieldAPIName + ' like ' + wildCardHandler(fieldValue);
                            }
                            else
                            {
                                filterString = filterString + fieldAPIName + '=' + fieldValue;
                            }
                        }
                        else
                        {
                            if(fieldValue.contains('*'))
                            {
                                filterString = filterString + fieldAPIName + ' like ' + '\'' + wildCardHandler(fieldValue) + '\'';
                            }
                            else
                            {
                                filterString = filterString + fieldAPIName + '=' + '\'' + fieldValue + '\'';
                            }
                        }
                        filterString = filterString + ') OR ';
                    }
                    filterString = filterString.removeEndIgnoreCase(' OR ');
                    filterString = filterString + ') AND ';
                    

                    //for(String currentAPIName : labelApiNameMap.get(fieldLabel))
                    //{
                    //system.debug('\n\n\n privacyMap: '+privacyMap+'\n\n\n');
                    //system.debug('\n\n\n getFieldApiNames: '+getFieldApiNames(CustomSettingName, objectLabel, fieldLabel)+'\n\n\n');
                    //}
                }
            
            }
            filterString = filterString.removeEndIgnoreCase(' AND ');
            if(whereStr!='' && whereStr!=null)
            {
                filterString = filterString + ' AND ' + whereStr;
            }
            childQ += filterString;
        }
        //else childQ = 'Select ' + getForeignKey(CustomSettingName, objectLabel) +  ' from ' + objectName;
        else childQ = 'Select ' + ForeignKeysMap.get(objectLabel.toLOwerCase()) +  ' from ' + objectName;

        if (childLevel == 1) if (childrenString=='') childrenString = objectName; else childrenString += ', ' + objectName;
        if (childLevel == 2) if (grandchildrenString=='') grandchildrenString = objectName; else grandchildrenString += ', ' + objectName;
        
        
        System.debug('\n\n\nchild query is: ' + childQ + '\n\n\n');
        
        return childQ;
    }
    
    private List<String> constructDynamicQueries(sObject dq)
    {
        System.debug('\n\n\nIn constructDynamicQueries\n\n\n'); 
        
        List<String> dynamicQueries = new List<String>{''};
        //List<String> childQueriesIdSetsDeepestLevel = new List<String>();
        List<String> childQueriesIdSetsMiddleLevel = new List<String>();

        List<String> childWhereList = new List<String>();
        //List<String> childWhereMiddleLevel = new List<String>();  
        
        String deepestLevelForeignKey = ''; 
                
        parentObjectName = String.valueOf(queriedFields.get('sourceObjectName__c'));
        
        //Construct children queries
        //Determine relationship level and build generation 1, 2, 3, etc. queries
        //String childDynamicQuery = '';

        Boolean childQueryRecordsFound = true;
        
        if (objectNameToSearchFieldsMap.size()>0)
        {
            //poopulate objectLevelMap
            for (String objectLabel : objectNameToSearchFieldsMap.keySet())
            {
                findObjectLevel(objectLabel, CustomSettingRecordName); 
            }
                
            System.debug('\n\n\nobjectLevelMap is: ' + objectLevelMap + '\n\n\n');  
            System.debug('\n\n\nlevelObjectMap is: ' + levelObjectMap + '\n\n\n');  
                
            //build queries, starting with deepest level        
            Integer counter = 1;        
            //for (String objectLabel : objectLevelMap.keySet())
            //{
                //if (objectLevelMap.get(objectLabel)>0)
                //{
                    if(deepestLevel==1)
                    {
                        system.debug('AAAAAAAAAAAAAAAAAAAA');
                        String childWhere = generateWhere(levelObjectMap.get(1), objectNameToSearchFieldsMap.get(levelObjectMap.get(1)), levelObjectMap.get(1));
                        childWhereList.add(childWhere);
                        system.debug('@@ childWhereList !!@@'+childWhereList);
                    }
                    else if(deepestLevel==2)
                    {
                        system.debug('BBBBBBBBBBBBBBBBBBBB');
                        String childDynamicQuery = generateChildQuery(levelObjectMap.get(2), objectNameToSearchFieldsMap.get(levelObjectMap.get(2)), objectLevelMap.get(levelObjectMap.get(2)));
                        childDynamicQuery = '('+childDynamicQuery+')';
                        system.debug('\n\n\n childDynamicQuery = '+childDynamicQuery+'\n\n\n');
                        if(levelObjectMap.get(1)!=null)
                        {
                            String childWhere = generateWhere(levelObjectMap.get(1), objectNameToSearchFieldsMap.get(levelObjectMap.get(1)), levelObjectMap.get(1));
                            if(childDynamicQuery.containsIgnoreCase('where'))
                            {
                                childDynamicQuery = childDynamicQuery + ' AND ' + childWhere;
                            }
                            else
                            {
                                childDynamicQuery = childDynamicQuery + ' where ' + childWhere;
                            }
                        }
                        system.debug('\n\n\n childDynamicQuery: '+childDynamicQuery+'\n\n\n');
                        //childDynamicQuery = '('+childDynamicQuery+')';
                        childQueriesIdSetsMiddleLevel.add(childDynamicQuery);
                    }
                //}
            //  if (objectLevelMap.get(objectLabel)>0)
            //  {
            //      if (objectLevelMap.get(objectLabel)==deepestLevel)
            //      {
            //          system.debug('AAAAAAAAAAAAAAAAAAAA');
                        //deepestLevelForeignKey = getForeignKeyApiName(getForeignKey(CustomSettingName, objectLabel));
                        //deepestLevelForeignKey = getForeignKeyApiName(ForeignKeysMap.get(objectLabel.toLowerCase()));
                        //deepestLevelForeignKey = ForeignKeyApiNameMap.get(ForeignKeysMap.get(objectLabel.toLowerCase()));

            //          String fk = ForeignKeysMap.get(objectLabel.toLowerCase());
            //          deepestLevelForeignKey = ForeignKeyApiNameMap.get(fk.toLowerCase());

            //          String childWhere = generateWhere(objectLabel, objectNameToSearchFieldsMap.get(objectLabel));

            //          childWhereDeepestLevel.add(childWhere);
            //          system.debug('\n\n\n childWhereDeepestLevel: '+childWhereDeepestLevel+'\n\n\n');
                        //childDynamicQuery = generateChildQuery(objectLabel, objectNameToSearchFieldsMap.get(objectLabel), objectLevelMap.get(objectLabel));   
                        //system.debug('\n\n\nchildDynamicQuery: '+childDynamicQuery+'\n\n\n');
                        //dynamicQueries.add('Level ' + objectLevelMap.get(objectLabel) + ' query ' + counter + ': ' + childDynamicQuery);          

                        //sObject childObj = getChildObj(CustomSettingName, objectLabel);
                        // Dont run query if object is Contact
                        /*if(String.valueOf(childObj.get('sourceObjectName__c'))!='contact')
                        {
                            dynamicQueries.add(childDynamicQuery);
                        
                            list<sObject> queriedChildRecords = Database.query(childDynamicQuery);
                            system.debug('\n\n queriedChildRecords: '+queriedChildRecords+'\n\n');

                            if(queriedChildRecords.size()==0)
                            {
                                childQueryRecordsFound = false;
                            }

                            //String foreignKey = getForeignKey(CustomSettingName, objectLabel);
                            String foreignKey = ForeignKeysMap.get(objectLabel.toLowerCase());

                            String childQueryStr = '(';
                            for(sObject childRecord : queriedChildRecords)
                            {
                                childQueryStr += '\''+childRecord.get(foreignKey) + '\',';
                            }
                            childQueryStr = childQueryStr.removeEnd(',');
                            childQueryStr += ')';
                            childQueriesIdSetsDeepestLevel.add(childQueryStr);  
                            system.debug('\n\n\n childQueryStr:'+childQueryStr+'\n\n\n');
                            //childQueriesIdSetsDeepestLevel.add('childQueryLevel' + objectLevelMap.get(objectLabel) + 'Number' + counter + 'IdSet');   
                            counter++;
                        }
                        else
                        {*/
                            /*if(childDynamicQuery.containsIgnoreCase('where'))
                            {
                                childDynamicQuery = '('+childDynamicQuery+')';
                                childQueriesIdSetsDeepestLevel.add(childDynamicQuery);
                            }*/
                        //}
            //      }
            //  }
            //} 
            
            
            //build queries next level up 
            //counter = 1;      
            //for (String objectLabel : objectLevelMap.keySet())
            //{
            //  if (objectLevelMap.get(objectLabel)>0)
            //  {
            //      if (objectLevelMap.get(objectLabel)==deepestLevel-1)
            //      {
            //          system.debug('1.1');
            //          String childWhere = generateWhere(objectLabel, objectNameToSearchFieldsMap.get(objectLabel));

            //          childWhereMiddleLevel.add(childWhere);
            //          system.debug('\n\n\n childWhereMiddleLevel: '+childWhereMiddleLevel+'\n\n\n');
                        //childDynamicQuery = generateChildQuery(objectLabel, objectNameToSearchFieldsMap.get(objectLabel), objectLevelMap.get(objectLabel));   
                        

                        //add Id sets from children queries
                        /*if (childQueriesIdSetsDeepestLevel.size()>0) 
                        {
                            for (Integer i=0; i<childQueriesIdSetsDeepestLevel.size(); i++)
                            {
                                filterId = objectLabelToFilterIdMap.get(objectLabel);
                                childDynamicQuery = concatFilterSetIds(childDynamicQuery, childQueriesIdSetsDeepestLevel[i]);
                            }
                        }*/
                                                                        
                        //dynamicQueries.add('Level ' + objectLevelMap.get(objectLabel) + ' query ' + counter + ': ' + childDynamicQuery);  
                        
                        //sObject childObj = getChildObj(CustomSettingName, objectLabel);
                        // Dont run query if object is Contact
                        /*if(String.valueOf(childObj.get('sourceObjectName__c'))!='contact')
                        {
                            dynamicQueries.add(childDynamicQuery);  
                            system.debug('\n\n childDynamicQuery: '+childDynamicQuery+'\n\n');

                            list<sObject> queriedChildRecords = Database.query(childDynamicQuery);
                            system.debug('\n\n queriedChildRecords: '+queriedChildRecords+'\n\n');

                            if(queriedChildRecords.size()==0)
                            {
                                childQueryRecordsFound = false;
                            }

                            String childQueryStr = '(';
                            for(sObject childRecord : queriedChildRecords)
                            {
                                //childQueryStr += '\''+childRecord.get(getForeignKey(CustomSettingName, objectLabel)) + '\',';
                                childQueryStr += '\''+childRecord.get(ForeignKeysMap.get(objectLabel.toLowerCase())) + '\',';
                            }
                            childQueryStr = childQueryStr.removeEnd(',');
                            childQueryStr += ')';
                            childQueriesIdSetsMiddleLevel.add(childQueryStr);   

                            //childQueriesIdSetsMiddleLevel.add('childQueryLevel' + objectLevelMap.get(objectLabel) + 'Number' + counter + 'IdSet');    
                        
                            counter++;
                        }
                        else
                        {*/
                            //if(childDynamicQuery.containsIgnoreCase('where'))
                            //{
                            //  childDynamicQuery = '('+childDynamicQuery+')';
                            //  childQueriesIdSetsMiddleLevel.add(childDynamicQuery);
                            //}
                        //}
                //  }
                //}
            //} 
            
            //if (deepestLevel==2 && childQueriesIdSetsMiddleLevel.size()==0)
            //if(deepestLevel==2 && childWhereMiddleLevel.size()==0)
            //{
            //  System.debug('\n\n\nMiddle level params not specified\n\n\n');
                
                //generate middle level query based on Foreign Key in deepest level
            //  String queryStr = 'Select Name, FilterId__c from ' + CustomSettingName + ' where SourceObjectName__c=\'' + deepestLevelForeignKey + '\'';
            //  sObject objectFields = Database.query(queryStr);    

            //  String objLabel = String.valueOf(objectFields.get('Name'));
                
            //  System.debug('\n\n\nobjectLabel is: ' + objLabel);
                
            //  childDynamicQuery = generateChildQuery(objLabel, new List<String>(), 1);
            //  String childWhere = generateWhere(objectLabel, objectNameToSearchFieldsMap.get(objectLabel));

            //  if(childDynamicQuery.containsIgnoreCase('where'))
            //  {
            //      childDynamicQuery = childDynamicQuery + ' AND ' + childWhere;
            //  }
            //  else
            //  {
            //      childDynamicQuery = childDynamicQuery + ' where ' + childWhere; 
            //  }
                

            //  system.debug('\n\n\n childDynamicQuery: '+childDynamicQuery+'\n\n\n');
                                                        
                //add Id sets from children queries
                /*if (childQueriesIdSetsDeepestLevel.size()>0) 
                {
                    for (Integer i=0; i<childQueriesIdSetsDeepestLevel.size(); i++)
                    {
                        filterId = String.valueOf(objectFields.get('FilterId__c'));
                        childDynamicQuery = concatFilterSetIds(childDynamicQuery, childQueriesIdSetsDeepestLevel[i]);
                    }
                }*/
                                                                                
                //dynamicQueries.add('Level 1 query 1: ' + childDynamicQuery);
                //sObject childObj = getChildObj(CustomSettingName, objLabel);
                // Dont run query if object is Contact
                /*if(String.valueOf(childObj.get('sourceObjectName__c'))!='contact')
                {   
                    dynamicQueries.add(childDynamicQuery);

                    system.debug('\n\n childDynamicQuery: '+childDynamicQuery+'\n\n');

                    list<sObject> queriedChildRecords = new list<sObject>();
                    if(childQueryRecordsFound)
                    {
                        queriedChildRecords = Database.query(childDynamicQuery);
                        system.debug('\n\n queriedChildRecords: '+queriedChildRecords+'\n\n');
                    }

                    if(queriedChildRecords.size()==0)
                    {
                        childQueryRecordsFound = false;
                    }

                    String childQueryStr = '(';
                    for(sObject childRecord : queriedChildRecords)
                    {
                        //childQueryStr += '\''+childRecord.get(getForeignKey(CustomSettingName, objLabel)) + '\',';
                        childQueryStr += '\''+childRecord.get(ForeignKeysMap.get(objLabel.toLowerCase())) + '\',';
                    }
                    childQueryStr = childQueryStr.removeEnd(',');
                    childQueryStr += ')';
                    childQueriesIdSetsMiddleLevel.add(childQueryStr);   
                        
                    //childQueriesIdSetsMiddleLevel.add('childQueryLevel1Number1IdSet');                
                }
                else
                {*/
                    //if(childDynamicQuery.containsIgnoreCase('where'))
                    //{
                    //  childDynamicQuery = '('+childDynamicQuery+')';
                    //  childQueriesIdSetsMiddleLevel.add(childDynamicQuery);
                    //}
                //}
            //}
            
        }


        //Construct parentQuery     
        String parentDynamicQuery = '';
        
        //parentObjectName = String.valueOf(queriedFields.get('sourceObjectName__c'));
        Map<String, String> privacyMap = createCustomSettingMap(String.valueOf(queriedFields.get('Privacy_Fields__c')));
        
        if (useSosl)
        {
            parentDynamicQuery = 'FIND \'' + soslString + '\' IN NAME FIELDS RETURNING ' + parentObjectName + '(' + fieldsToDisplay + ')';
        }
        else
        {
            for (String label : labelList)
            {
                if (ApexPages.currentPage().getParameters().get(label) != null && ApexPages.currentPage().getParameters().get(label) != '')
                {
                    filterString = filterString+'(';
                    for(String labelAPI : labelApiNameMap.get(label))
                    {
                        filterString = filterString+'(';
                        system.debug('\n\n\n labelAPI: '+labelAPI+'\n\n\n');
                        if(privacyMap.get(labelAPI)!=null)
                        {
                            filterString = filterString + privacyMap.get(labelAPI) + '=false AND ';
                        }

                        if(ApexPages.currentPage().getParameters().get(label).contains('*'))
                        {
                            filterString = filterString+labelAPI+' like '+'\''+wildCardHandler(ApexPages.currentPage().getParameters().get(label))+'\') OR ';
                        }
                        else
                        {
                            filterString = filterString+labelAPI+'='+'\''+ApexPages.currentPage().getParameters().get(label)+'\') OR ';
                        }
                    }
                    filterString = filterString.removeEndIgnoreCase(' OR ');
                    filterString = filterString + ') AND ';

                    /*for(String currentAPIName : labelApiNameMap.get(label))
                    {
                        system.debug('\n\n\n currentAPIName: '+currentAPIName+'\n\n\n');
                        if(privacyMap.get(currentAPIName)!=null)
                        {
                            filterString = filterString + '(' + privacyMap.get(currentAPIName) + '=false) AND ';
                        }
                    }*/
                    //if (filterString.length()>0) filterString =+ ' AND ' + labelApiNameMap.get(label) + '=' + '\'' + ApexPages.currentPage().getParameters().get(label) + '\''; 
                    //else filterString = labelApiNameMap.get(label) + '=' + '\'' + ApexPages.currentPage().getParameters().get(label) + '\''; 
                }
            }   
            filterString = filterString.removeEndIgnoreCase(' AND ');   
            system.debug('\n\n\n filterString: ' + filterString+'\n\n\n');

            if(count==true)
            {
                parentDynamicQuery = 'Select count(Id) from ' + parentObjectName;
            }
            else
            {
                parentDynamicQuery = 'Select ' + fieldsToDisplay + ' from ' + parentObjectName;
            }

            if (filterString.length()>0 ) 
            {
                parentDynamicQuery += ' where ' + filterString;
                 system.debug('\n\n\n Parent query: ' + parentDynamicQuery+'\n\n\n');
            }
            //add Id sets from children queries
            system.debug('\n\n\n deepestLevel: ' + deepestLevel+'\n\n\n');
            if (deepestLevel==1)
            {
                //if (childQueriesIdSetsDeepestLevel.size()>0) 
                //{
                system.debug('\n\n\n Parent query111: ' + parentDynamicQuery+'\n\n\n');
                system.debug('\n\n\n childWhereList.size()1: ' + childWhereList.size()+'\n\n\n');
                    for (Integer i=0; i<childWhereList.size(); i++)
                    {
                        if (parentDynamicQuery.contains('where'))
                            parentDynamicQuery += ' AND ' + childWhereList[i];
                        else parentDynamicQuery += ' where ' + childWhereList[i];
                //      filterId = String.valueOf(queriedFields.get('FilterId__c'));
                //      parentDynamicQuery = concatFilterSetIds(parentDynamicQuery, childQueriesIdSetsDeepestLevel[i]);
                        /*if (parentDynamicQuery.contains('where'))
                            parentDynamicQuery += ' AND Id in: ' + childQueriesIdSetsDeepestLevel[i];
                        else parentDynamicQuery += ' where Id in: ' + childQueriesIdSetsDeepestLevel[i];*/
                        //system.debug('\n\n\n Parent query: ' + parentDynamicQuery+'\n\n\n');
                    }
                //}
            }
            if (deepestLevel==2)
            {
                if (childQueriesIdSetsMiddleLevel.size()>0) 
                {
                    for (Integer i=0; i<childQueriesIdSetsMiddleLevel.size(); i++)
                    {
                        system.debug('\n\n\n childQueriesIdSetsMiddleLevel[i]: ' + childQueriesIdSetsMiddleLevel[i]+'\n\n\n');
                        filterId = String.valueOf(queriedFields.get('FilterId__c'));
                        parentDynamicQuery = concatFilterSetIds(parentDynamicQuery, childQueriesIdSetsMiddleLevel[i]);
                        /*if (parentDynamicQuery.contains('where'))
                            parentDynamicQuery += ' AND Id in: ' + childQueriesIdSetsMiddleLevel[i];
                        else parentDynamicQuery += ' where Id in: ' + childQueriesIdSetsMiddleLevel[i];*/
                        //system.debug('\n\n\n Parent query: ' + parentDynamicQuery+'\n\n\n');
                    }
                }
            }

            if (staticWhere!=null && staticWhere!='')
            {
                if(parentDynamicQuery.contains('where'))
                {
                    parentDynamicQuery += ' and ' + staticWhere;
                }
                else
                {
                    parentDynamicQuery += ' where ' + staticWhere;
                }
            }
            
            //add Order By if sort string was specified
            if(ApexPages.currentPage().getParameters().get('sort') != null && ApexPages.currentPage().getParameters().get('sort') != '')
            {
                System.debug('\n\n\nFound sort parameter\n\n\n');
                
                String tmpStr = replaceLabelsWithApiNames(ApexPages.currentPage().getParameters().get('sort'));  
                
                if (tmpStr!='') sortStr = 'ORDER BY ' + tmpStr; 
            }
        
            if (sortStr!=null && sortStr!='')
                parentDynamicQuery += ' ' + sortStr;
            
            //add OFFSET and LIMIT if page number was specified
            if (pageNumberProvided)
                parentDynamicQuery += ' LIMIT ' + pageSize + ' OFFSET ' + String.valueOf(offset);
        }
        
        //dynamicQueries.add('Parent query: ' + parentDynamicQuery);
        dynamicQueries.add(parentDynamicQuery);
        
        system.debug('\n\n\n Parent query: ' + parentDynamicQuery+'\n\n\n');
        if(childQueryRecordsFound)
        {
            queriedParentRecords = Database.query(parentDynamicQuery);
        }
        system.debug('\n\n queriedParentRecords: '+queriedParentRecords+'\n\n');

        return dynamicQueries;
    }

    private String concatFilterSetIds(String pChildDynamicQuery, String pChildQueriesIdSetsDeepestLevel)
    {
        system.debug('\n\n\n'+filterId+'\n\n\n');
        system.debug('\n\n\n'+pChildDynamicQuery+'\n\n\n');
        system.debug('\n\n\n'+pChildQueriesIdSetsDeepestLevel+'\n\n\n');
        if(filterId!=null)
        {
            if (pChildDynamicQuery.contains('where'))
            {
                pChildDynamicQuery += ' AND '+filterId+' in ' + pChildQueriesIdSetsDeepestLevel;
                system.debug('\n\n\n'+pChildDynamicQuery+'\n\n\n');
            }
            else 
            {
                pChildDynamicQuery += ' where '+filterId+' in ' + pChildQueriesIdSetsDeepestLevel;
                system.debug('\n\n\n'+pChildDynamicQuery+'\n\n\n');
            }
        }
        else
        {
            if (pChildDynamicQuery.contains('where'))
                pChildDynamicQuery += ' AND Id in ' + pChildQueriesIdSetsDeepestLevel;
            else pChildDynamicQuery += ' where Id in ' + pChildQueriesIdSetsDeepestLevel;
        }
        system.debug('\n\n\n'+pChildDynamicQuery+'\n\n\n');
        return pChildDynamicQuery;
    }
    
    /*private String constructDynamicQuery(sObject dq)
    {
        String dynamicQuery = '';
        parentObjectName = String.valueOf(queriedFields.get('sourceObjectName__c'));
        
        System.debug('\n\n\nIn constructDynamicQuery\n\n\n');       

        
        if (useSosl)
        {
            dynamicQuery = 'FIND \'' + soslString + '\' IN NAME FIELDS RETURNING ' + parentObjectName + '(' + fieldsToDisplay + ')';
            //FIND 'map' RETURNING Contact(FirstName, LastName)
        }
        
        else
        {
            for (String label : labelList)
            {
                if (ApexPages.currentPage().getParameters().get(label) != null && ApexPages.currentPage().getParameters().get(label) != '')
                {
                    if (filterString.length()>0) filterString =+ ' AND ' + labelApiNameMap.get(label) + '=' + ApexPages.currentPage().getParameters().get(label); 
                    else filterString = labelApiNameMap.get(label) + '=' + '\'' + ApexPages.currentPage().getParameters().get(label) + '\''; 
                }       
            }   
            
            dynamicQuery = 'Select ' + fieldsToDisplay + ' from ' + parentObjectName;
                    
            if (filterString.length()>0) dynamicQuery += ' where ' + filterString;
            
            //add Order By if sort string was specified
            if(ApexPages.currentPage().getParameters().get('sort') != null && ApexPages.currentPage().getParameters().get('sort') != '')
            {
                System.debug('\n\n\nFound sort parameter\n\n\n');
                
                String tmpStr = replaceLabelsWithApiNames(ApexPages.currentPage().getParameters().get('sort'));  
                
                if (tmpStr!='') sortStr = 'ORDER BY ' + tmpStr; 
            }
        
            if (sortStr!=null && sortStr!='')
                dynamicQuery += ' ' + sortStr;
            
            //add OFFSET and LIMIT if page number was specified
            if (pageNumberProvided)
                dynamicQuery += ' LIMIT ' + pageSize + ' OFFSET ' + String.valueOf(offset);
                
                
        }
        
        System.debug('\n\n\nFrom constructDynamicQuery, dynamicQuery is: ' + dynamicQuery + '\n\n\n');
        
        queriesGenerated.add(dynamicQuery);
                                
        return dynamicQuery;
    }*/
    
    private List<String> generateQueries()
    {
        System.debug('\n\n\nIn generateQueries\n\n\n');
        
        getParentFields(CustomSettingName, CustomSettingRecordName);
        
        return constructDynamicQueries(queriedFields);          
    }
    
    /*private sObject findQueriedSourceRecords()
    {
        System.debug('\n\n\nIn findqueriedSourceRecords\n\n\n');
        System.debug('\n\n\n queriesGenerated: '+queriesGenerated+'\n\n\n');
        try
        {
            getParentFields(CustomSettingName, CustomSettingRecordName);
            
            queryString = constructDynamicQuery(queriedFields);
                                    
            System.debug('\n\n\nQuery String is: ' + queryString);
                        
            if (useSosl) 
            {
                List<List<SObject>> searchList = search.query(queryString);
                queriedSourceRecords = ((List<SObject>)searchList[0]); 
            }
            else queriedSourceRecords = Database.query(queryString);
            
            System.debug('\n\n\nqueriedSourceRecords is: ' + queriedSourceRecords);
            
        }
        catch(Exception pEx)
        {
            System.debug('Error in Retrieving Queried Records');
        } 
        
        return queriedFields;
    }*/
    
    /*private void convertQueriedRecordsToWrapperClass()
    {
        System.debug('\n\n\nIn convertQueriedRecordsToWrapperClass()\n\n\n');
        System.debug('\n\n\nqueriedParentRecords: '+queriedParentRecords+'\n\n\n');
        
        for (Integer i = 0; i<queriedParentRecords.size(); i++)
        {
            System.debug('\n\n\nIn For loop');
            
            Integer pNumber = 0;
            Integer position = 0;
            
            System.debug('\n\n\nBefore: pNumber is: ' + pNumber + ',  position is: ' + position + '\n\n\n');
            
            if (pageNumber == 1)
                pNumber = Integer.valueOf(Decimal.valueOf((i/pageSize)).round(System.RoundingMode.DOWN)) + 1;
            else pNumber = pageNumber;
            
            if (pageNumber == 1)
                position = i - (pageSize * (pNumber - 1)) + 1;
            else position = i+1;
            
            System.debug('\n\n\nAfter: pNumber is: ' + pNumber + ',  position is: ' + position + '\n\n\n');
            
            System.debug('\n\n\nBefore helper class\n\n\n');
            helperClass hcRecord = new helperClass(queriedParentRecords[i], pNumber, position);
            System.debug('\n\n\nAfter helper class\n\n\n');
            
            queriedSourceWrapperRecords.add(hcRecord);
            
            
        }
        
        System.debug('\n\n\nLeaving convertQueriedRecordsToWrapperClass()\n\n\n');
    }*/
    private void convertQueriedRecordsToCountWrapperClass(Boolean recordsFound)
    {
        Integer recordCount = 0;
        if(recordsFound)
        {
            recordCount = Integer.valueOf(queriedParentRecords[0].get('expr0'));
        }
        helperClass hcRecord = new helperClass(recordCount);
        System.debug('\n\n\nAfter helper class\n\n\n');
            
        queriedSourceWrapperRecords.add(hcRecord);
    }

    private void convertQueriedRecordsToWrapperClass()
    {
        System.debug('\n\n\nIn convertQueriedRecordsToWrapperClass()\n\n\n');
        System.debug('queriedParentRecords****' + queriedParentRecords);
        
        for (Integer i = 0; i<queriedParentRecords.size(); i++)
        {
            System.debug('\n\n\nIn For loop');
            
            Integer pNumber = 0;
            Integer position = 0;
            
            System.debug('\n\n\nBefore: pNumber is: ' + pNumber + ',  position is: ' + position + '\n\n\n');
            
            if (pageNumber == 1)
                pNumber = Integer.valueOf(Decimal.valueOf((i/pageSize)).round(System.RoundingMode.DOWN)) + 1;
            else pNumber = pageNumber;
            
            if (pageNumber == 1)
                position = i - (pageSize * (pNumber - 1)) + 1;
            else position = i+1;
            
            System.debug('\n\n\nAfter: pNumber is: ' + pNumber + ',  position is: ' + position + '\n\n\n');
            
        
            
            setPrivacyFieldsOnObj(queriedParentRecords[i]);
            
            list<String> fieldValues = getfieldValues(viewName, queriedParentRecords[i]);
            system.debug('***fieldValues' + fieldValues);
            map<String, String> socialIconURLMap = new map<String, String>();
            socialIconURLMap = createSocialIconURLMap(queriedParentRecords[i]);
            
            system.debug('****socialIconURLMap' + socialIconURLMap);

            helperClass hcRecord = new helperClass(queriedParentRecords[i], fieldValues, 
                socialIconURLMap,
                pNumber, position);
            System.debug('\n\n\nAfter helper class\n\n\n');
            
            queriedSourceWrapperRecords.add(hcRecord);      
            
        }
    }

    private Map<String, String> createCustomSettingMap(String s)
    {
        System.debug('\n\n\nIn createCustomSettingMap\n\n\n');

        if(s!=null && s.startsWith('Community_Web_Content__c.'))
        {
            s = CommunityContentHelper.getContent(s);
        }

        Map<String, String> csMap = new Map<String, String>();
        system.debug('\n\n'+s+'\n\n');
        if(s!=null && s.length()>0)
        {
            List<String> mappingPairs = s.split(',');

            if (mappingPairs.size()>0)
            {
                for (String pair : mappingPairs)
                {
                    List<String> splitPair = pair.split('=', 2);
                    String fieldAPI = splitPair[0];
                    String privacyFieldAPI = splitPair[1];

                    csMap.put(fieldAPI, privacyFieldAPI);
                }
            }
        }
        return csMap;
    }

    private map<String, String> createSocialIconURLMap(sObject queriedSourceRecord)
    {
        String socialIconField = String.valueOf(queriedFields.get('Social_Icon_Map__c'));
        if(String.valueOf(queriedFields.get('Social_Icon_Map__c'))!=null && 
           String.valueOf(queriedFields.get('Social_Icon_Map__c')).startsWith('Community_Web_Content__c.'))
        {
            socialIconField = CommunityContentHelper.getContent(String.valueOf(queriedFields.get('Social_Icon_Map__c')));
        }

        Map<String, String> socialIconURLMap = new Map<String, String>();
        Map<String, String> socialIconMap = createCustomSettingMap(socialIconField);
        system.debug('\n\n\n socialIconMap: '+socialIconMap+'\n\n\n');
        for(String iconMapKey : socialIconMap.keySet())
        {
            socialIconURLMap.put(socialIconMap.get(iconMapKey), getFieldValueHelper(iconMapKey, queriedSourceRecord));
        }
        return socialIconURLMap;
    }

    private void setPrivacyFieldsOnObj(sObject queriedSourceRecord)
    {
        Map<String, String> privacyMap = createCustomSettingMap(String.valueOf(queriedFields.get('Privacy_Fields__c')));
        system.debug('***queriedSourceRecord' + queriedSourceRecord);
        system.debug('***queriedFields' + queriedFields);
        system.debug('***privacyMap' + privacyMap);
        for(String fieldAPIName : privacyMap.keySet())
        {
            if(getFieldValueHelper(privacyMap.get(fieldAPIName), queriedSourceRecord)=='true')
            {
                
                if(fieldAPIName.contains('.'))
                {
                    List<String> pathPartList = fieldAPIName.split('[.]', 2);
                    SObject currentSObject = (SObject) queriedSourceRecord.getSobject(pathPartList[0].trim());
                    String fieldPath = pathPartList[1];
                    currentSObject.put(fieldPath, null);
                }
                else
                {
                    queriedSourceRecord.put(fieldAPIName, null);
                }
            }
        }
        
        system.debug('***queriedSourceRecord' + queriedSourceRecord);
    }

    private list<String> getfieldValues(String apiFieldName, sObject queriedSourceRecord)
    {
        system.debug('***apiFieldName' + apiFieldName);
        system.debug('***queriedSourceRecord' + queriedSourceRecord);
        list<String> fieldValues = new list<String>();
        if(queriedFields.get(apiFieldName)!=null)
        {
            List<String> fieldsInCustomSetting = String.ValueOf(queriedFields.get(apiFieldName)).split ('[,]');
            for(String field : fieldsInCustomSetting)
            {
                fieldValues.add(getFieldValueHelper(field, queriedSourceRecord));
            }
        }
        return fieldValues;
    }

    private String getFieldValueHelper(String field, sObject queriedSourceRecord)
    {
        String fieldValue = '';
        SObject currentSObject;
        String fieldPath;
        if (field.contains('.'))
        {
            List<String> pathPartList = field.split('[.]', 2);
            currentSObject = (SObject) queriedSourceRecord.getSobject(pathPartList[0].trim());
            fieldPath = pathPartList[1];
            if(String.ValueOf(currentSObject.get(fieldPath.trim()))!=null)
            {
                fieldValue = String.ValueOf(currentSObject.get(fieldPath.trim()));
            }               
        }
        else
        {
            if(String.ValueOf(queriedSourceRecord.get(field))!=null)
            {
                fieldValue = String.ValueOf(queriedSourceRecord.get(field));
            }
        }
        return fieldValue;
    }

}