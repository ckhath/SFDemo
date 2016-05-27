global class SocialSSOHandler implements Auth.RegistrationHandler{

    global boolean canCreateUser(Auth.UserData data) {

    return false;
}
   


    global User createUser(Id portalId, Auth.UserData data){
    

       user u = [Select id from user where email = :data.email  AND user.profile.name ='Tufts Community User' limit 1]; 
       
       return u;

    }

    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        //Update the User
        
        User u = [select firstName, lastName, email, contactId from User where id =: userId];
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        update(u);
        
        Contact c = [select firstName, lastName, email from Contact where id =: u.contactId];
        c.email = data.email;
        c.lastName = data.lastName;
        c.firstName = data.firstName;
        update(c);
            
    }
    
}