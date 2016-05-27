trigger ContactTrigger on Contact (after update) {

    //if(trigger.isAfter && trigger.isUpdate && UserTriggerHandler_UserToContactSync.avoidRecursion()) {
    if(trigger.isAfter && trigger.isUpdate) {
        system.debug('This is Contact trigger...');
        new ContactTriggerHandler_ContactToUserSync(trigger.newMap, trigger.oldMap);
    }
}