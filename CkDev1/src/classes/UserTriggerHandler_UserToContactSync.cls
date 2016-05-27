public with sharing class UserTriggerHandler_UserToContactSync {

    public Map<String, String> userToContactFieldMapping;
    public Map<String, Schema.SObjectField> objectFieldsMap;
    public static Boolean runUser = true;

    //This method is to set the boolean value to avoid recursion.
    public static Boolean avoidRecursion() {
    	system.debug('runUser====>>' +runUser);
        if(runUser){
            runUser = false;
            return true;
        } else {
            return runUser;
        }
    }

    public UserTriggerHandler_UserToContactSync(Map<Id, User> newUsersMap, Map<Id, User> oldUsersMap) {

        init();
        updateContact(newUsersMap, oldUsersMap);
    }

    //Initialization block
    public void init(){

        userToContactFieldMapping = new Map<String, String>();
        getUserContactMapping();
    }

    //Get the records from Custom setting and creates a map of Contact Field as key and User fields as value.
    public void getUserContactMapping(){

        Map<String, UserContactMapping__c> userContactMappingCS = UserContactMapping__c.getAll();
        system.debug('UserContactMapping__c.getAll()====>> '+UserContactMapping__c.getAll());
        system.debug('userContactMappingCS===>> '+userContactMappingCS);
        system.debug('userContactMappingCS.getValues()====>> '+userContactMappingCS.values().size());
        for(String name : userContactMappingCS.keySet()) {
            system.debug('userContactMappingCS.get(name).Contact_field__c===>> '+userContactMappingCS.get(name).Contact_field__c);
            system.debug('userContactMappingCS.get(name).User_field__c===>> '+userContactMappingCS.get(name).User_field__c);
            userToContactFieldMapping.put(userContactMappingCS.get(name).User_field__c, userContactMappingCS.get(name).Contact_field__c);
        }
        system.debug('userToContactFieldMapping====>> '+userToContactFieldMapping);
    }

    //Generate the query in string format for Contact object.
    public String generateContactQuery () {

        String queryUser = 'Select ';
        queryUser += getObjectFields('Contact') + ' from ';
        queryUser += SObjectType.Contact.Name;
        return queryUser;
    }

    //Getting all the fields of User object comma separated.
    private string getObjectFields(string objectName){

        string contactFields = 'Id,';
        /*objectFieldsMap = new Map<String, Schema.SObjectField>();
        if (objectName != null && Schema.getGlobalDescribe().get(objectName).getDescribe() != null){
            objectFieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            system.debug(objectFieldsMap);
            for (String s : objectFieldsMap.keySet()) {
                if ((objectFieldsMap.get(s).getDescribe().isAccessible())) {
                    contactFields += String.escapeSingleQuotes(s);
                    contactFields += ',';
                }
            }
            contactFields = contactFields.removeEnd(',');
        }*/
        for(String s : userToContactFieldMapping.Values())
        {
            contactFields += String.escapeSingleQuotes(s);
            contactFields += ',';
        }
        contactFields = contactFields.removeEnd(',');
        return contactFields;
    }

    //Creates a map of User
    public Map<Id, Contact> createContactUserMap(Map<Id, User> newUsersMap) {

        List<Contact> contactList = new List<Contact>();
        Set<Id> contactIdFromUser = new Set<Id>();
        Map<Id,Id> contactToUserIdMap = new Map<Id,Id>();
        Map<Id, Contact> userIdToContactMap = new Map<Id, Contact>();
        String queryContact = generateContactQuery();

        for(User user : newUsersMap.values()) {
            contactToUserIdMap.put(user.ContactId, user.Id);
        }

        if(contactToUserIdMap != null && contactToUserIdMap.keySet().size() > 0) {
            contactIdFromUser = contactToUserIdMap.keySet();
        }
         
        queryContact+= ' where Id IN : contactIdFromUser ';
        contactList = database.query(queryContact);
        system.debug('contactList.size()===>> '+contactList.size()+ 'contactList==>> '+contactList);
        if(contactList!= null && contactList.size() > 0) {
            for(Contact objContact : contactList) {
                if(contactToUserIdMap.containsKey(objContact.Id)) {
                    userIdToContactMap.put(contactToUserIdMap.get(objContact.Id), objContact);
                }
            }
        }
        system.debug('userIdToContactMap====> '+userIdToContactMap);
        return userIdToContactMap;
    }

    public void updateContact(Map<Id, User> newUsersMap, Map<Id, User> oldUsersMap){

        system.debug('newUsersMap===>> '+newUsersMap);
        system.debug('oldUsersMap===>> '+oldUsersMap);
        system.debug('userToContactFieldMapping in processUser===>> '+userToContactFieldMapping);
        Set<Contact> updateContactSet = new Set<Contact>();
        Map<Id, Contact> userIdToContactMap = createContactUserMap(newUsersMap);
        system.debug('userIdToContactMap===>> '+userIdToContactMap);
        
        for(String userId : newUsersMap.keySet()) {
            Boolean conUpdated = false;
            if(userIdToContactMap.containsKey(userId)) {
	            Contact objContact = userIdToContactMap.get(userId);
	            for(String userField : userToContactFieldMapping.keySet()) {
	                if(String.valueOf(newUsersMap.get(userId).get(userField))!=String.valueOf(oldUsersMap.get(userId).get(userField))) {
	                        system.debug('userIdToContactMap.get(contactId)===>> '+userIdToContactMap.get(userId));
                            system.debug('userToContactFieldMapping.get(userField)===>> '+userToContactFieldMapping.get(userField));
	                        objContact.put(userToContactFieldMapping.get(userField), newUsersMap.get(userId).get(userField));
                            conUpdated = true;
                    }
                }
                if(conUpdated)
                {
                    updateContactSet.add(objContact);
                }
            }
        }
        system.debug('updateUserSet.size()===>> '+updateContactSet.size()+'updateUserSet===>> '+updateContactSet);
        try {
            if(updateContactSet != null && updateContactSet.size() > 0){
                List<Contact> updateContactList = new List<Contact>(updateContactSet);
                database.update(updateContactList);
            }
        }
        catch(Exception e) {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'System.DmlException: Update failed.');
                 ApexPages.addMessage(myMsg);
          }
    }

}