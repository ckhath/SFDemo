public with sharing class ContactTriggerHandler_ContactToUserSync {

    public Map<String, String> contactToUserFieldMapping;
    public Map<String, Schema.SObjectField> objectFieldsMap;
    public static Boolean runContact = true;

    //This method is to set the boolean value to avoid recursion.
    public static Boolean avoidRecursion() {
        system.debug('runContact====>>' +runContact);
        if(runContact){
            runContact = false;
            return true;
        } else {
            return runContact;
        }
    }

    public ContactTriggerHandler_ContactToUserSync(Map<Id, Contact> newContactMap, Map<Id, Contact> oldContactMap) {

        init();
        updateUser(newContactMap, oldContactMap);
    }

    //Initialization block
    public void init(){

        contactToUserFieldMapping = new Map<String, String>();
        getUserContactMapping();
    }

    //Creates a map of mapping of Contact ID to user
    public Map<Id, User> createContactUserMap(Map<Id, Contact> newContactMap) {

        List<User> userList = new List<User>();
        set<Id> contactIdSet = newContactMap.keySet();
        Map<Id, User> mapUserToContactId = new Map<Id, User>();
        String queryUser = generateUserQuery();
        queryUser += ' where ContactId =: contactIdSet';
        system.debug('queryUser in processUser===>> '+queryUser);
        userList = database.query(queryUser);
        system.debug('userList.size()===>>> '+userList.size());
        if(userList!= null && userList.size() > 0) {
            for(User objUser : userList) {
                mapUserToContactId.put(objUser.ContactId, objUser);
            }
        } 
        return mapUserToContactId;
    }

    //Get the records from Custom setting and creates a map of UserField as key and contact fields as value.
    public void getUserContactMapping(){

        Map<String, UserContactMapping__c> userContactMappingCS = UserContactMapping__c.getAll();
        system.debug('UserContactMapping__c.getAll()====>> '+UserContactMapping__c.getAll());
        system.debug('userContactMappingCS===>> '+userContactMappingCS);
        system.debug('userContactMappingCS.getValues()====>> '+userContactMappingCS.values().size());
        for(String name : userContactMappingCS.keySet()) {
            system.debug('userContactMappingCS.get(name).Contact_field__c===>> '+userContactMappingCS.get(name).Contact_field__c);
            system.debug('userContactMappingCS.get(name).User_field__c===>> '+userContactMappingCS.get(name).User_field__c);
            contactToUserFieldMapping.put(userContactMappingCS.get(name).Contact_field__c, userContactMappingCS.get(name).User_field__c);
        }
        system.debug('contactToUserFieldMapping====>> '+contactToUserFieldMapping);
    }

    //Updates the user records associated to updated Contact records.
    public void updateUser(Map<Id, Contact> newContactMap, Map<Id, Contact> oldContactMap){

        system.debug('newContactMap===>> '+newContactMap);
        system.debug('oldContactMap===>> '+oldContactMap);
        system.debug('contactToUserFieldMapping in processUser===>> '+contactToUserFieldMapping);
        Set<User> updateUserSet = new Set<User>();
        Map<Id, User> contactIdUserMap = createContactUserMap(newContactMap);
        system.debug('contactIdUserMap===>> '+contactIdUserMap);

        for(String contactId : newContactMap.keySet()) {
            if(contactIdUserMap.containsKey(contactId)) {
                User objUser = contactIdUserMap.get(contactId);
                for(String contactField : contactToUserFieldMapping.keySet()) {
                //String contactFieldAfterSplit = userToContactFieldMapping.get(contactField).split(',')[0];
                    if(String.valueOf(newContactMap.get(contactId).get(contactField))!=String.valueOf(oldContactMap.get(contactId).get(contactField))) {
                            system.debug('contactIdUserMap.get(contactId)===>> '+contactIdUserMap.get(contactId));
                            objUser.put(contactToUserFieldMapping.get(contactField), newContactMap.get(contactId).get(contactField));
                    }
                }
                updateUserSet.add(objUser);
            }
        }
        system.debug('updateUserSet.size()===>> '+updateUserSet.size()+'updateUserSet===>> '+updateUserSet);
        try {
	        if(updateUserSet != null && updateUserSet.size() > 0){
	            List<User> updateUserList = new List<User>(updateUserSet);
	            database.update(updateUserList);
	        }
        }
       catch(Exception e)
      {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'System.DmlException: Update failed.');
             ApexPages.addMessage(myMsg);
      }
    }

    //Generates the string of query for the User object.
    public String generateUserQuery () {
        String queryUser = 'Select ';
        queryUser += getObjectFields('User') + ' from ';
        queryUser += SObjectType.User.Name;
        return queryUser;
    }

    //Getting all the fields of User object comma separated.
    private string getObjectFields(string objectName){

        string userFields = 'Id,ContactId,';
        /*objectFieldsMap = new Map<String, Schema.SObjectField>();
        if (objectName != null && Schema.getGlobalDescribe().get(objectName).getDescribe() != null){
            objectFieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            for (String s : objectFieldsMap.keySet()) {
                if ((objectFieldsMap.get(s).getDescribe().isAccessible())) {
                    userFields += String.escapeSingleQuotes(s);
                    userFields += ',';
                }
            }
            userFields = userFields.removeEnd(',');
        }*/
        for(String s : contactToUserFieldMapping.Values())
        {
            userFields += String.escapeSingleQuotes(s);
            userFields += ',';
        }
        userFields = userFields.removeEnd(',');

        return userFields;
    }
    
    
}