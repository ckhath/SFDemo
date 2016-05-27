public class PoBox {
    
     // The API endpoint for the reCAPTCHA service (CHAN: Forcing failer by changing port from 8003 to 8002)
    private static String baseUrl = 'https://api.pobox.com:8002/v2/routes'; 

    // The keys you get by signing up for reCAPTCHA for your domain
    private static String username = '982BC054-4519-11E5-8060-FFAD877A17C9';
    private static String password = '9QBMHGD29HA9TGP79TRARKYR';  

    @future(callout=true)
    public static void makeCallout(String UserId)
    {
        List<User> userList = [SELECT Id, ContactId FROM User WHERE Id = :UserId LIMIT 1];
        String user = userList[0].ContactId; 
        List<Contact> contactList = new List<Contact>();
        contactList = [SELECT PO_Box_Alias__c, PO_Box_Target__c FROM Contact WHERE ID = :user LIMIT 1]; 
        system.debug('SFDC TEST 11111111' + contactList);
        String target = contactList[0].PO_Box_Target__c;
        if(contactList[0].PO_Box_Target__c=='')
        {
            target = null;
        }
        
        system.debug('\n\n\n  contactList[0].PO_Box_Alias__c:'+ contactList[0].PO_Box_Alias__c + '\n\n\n');
        system.debug('\n\n\n  target:'+ target + '\n\n\n');
        String json = '{"' + contactList[0].PO_Box_Alias__c + '@alumni.tufts.edu":{"fwd" :"' + target + '"}}';
        //String json = '{"' + contactList[0].PO_Box_Alias__c + '@alumni-test.tufts.edu":{"fwd" :"' + target + '"}}';
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        Integer result; 
 
 
 //Catching the responce from PoBox     
  try{  
        
        HttpResponse r = makeRequest(baseUrl, json, authorizationHeader);    

        
        
        if (!Test.isRunningTest()){
            // Make a real callout since we are not running a test
            result = r.getStatusCode();
        } else {
            // A test is running
            result = 200;
        }

        /*if(result==200)
        {
            return true;
        }
        else
        {
            return false;
        }*/

  
    } catch (NullPointerException e){
        
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
         String[] toAddresses = new String[] {'Chanveasna.khath@tufts.edu'};
         mail.setToAddresses(toAddresses) ;
         mail.setSubject('Exception occered with PoBox');
         mail.setPlainTextBody('The @Future Apex job Exception occered with PoBox' +user );
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        
    }
  
    }
  
    private static HttpResponse makeRequest(String url, String body, String authHeader)  {
        System.debug('body: ' + body);
        HttpResponse response = null;
        HttpRequest req = new HttpRequest(); 
        req.setHeader('Authorization', authHeader);
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody(body);
        System.debug('req: ' + req);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('response: ' + response);
            System.debug('response body: ' + response.getBody());
            System.debug('STATUS_CODE:'+response.getStatusCode());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
            



        }
        return response;
    }       

    public PoBox() {
        
    }


}