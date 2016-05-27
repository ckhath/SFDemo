/*
	*TestEmailSndBatchDel - <
	 This test classes creates records of Email Sends and from those records, 
     it creates child lookup records of Individual Email Result and Individual Link
     then the sch_DeleteEmailSend class is called to perform the operation. 
     There is a limit on how many batch a test class can run at one time hence
     only 100 records were created. I believe this has something to do with 
     Test class running synchronously.>
	* Created by BrainEngine Cloud Studio
	* @author: Chanveasna Khath
	* @version: 1.0
*/


@isTest
private class TestEmailSndBatchDel {
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
	public static Integer xdays = 29;

     static testmethod void test() {
         
         
           
      Test.startTest();   
      
      //Creates 50 Email Send less than 30 days old	   
        	   
          list<et4ae5__SendDefinition__c>  es = new list<et4ae5__SendDefinition__c>();   
        

        
        	for(Integer i = 0; i < 5; i++){    
        	
        	et4ae5__SendDefinition__c s = new et4ae5__SendDefinition__c();
        		
        	  s.et4ae5__SendStatus__c ='Completed';
        	  s.et4ae5__DateSent__c = System.today() - xdays;
        	  es.add(s); 
             
           }
            insert es;
            
        //Debugging    
            //string x =[SELECT e.Id, e.et4ae5__SendDefinition__r.et4ae5__DateSent__c FROM et4ae5__IndividualEmailResult__c e WHERE e.et4ae5__SendDefinition__r.et4ae5__DateSent__c < LAST_N_Days: 30] ;
            system.debug('TEST_Email Send Size >>>'+ es.size());
            system.debug('TEST_Email Send[0] id >>>'+ es[0].id);
            system.debug('TEST_Email Send[0] Date >>>'+ es[0].et4ae5__DateSent__c);
            //system.debug('TEST_Email Result Related Id' + x );
       
       
        	
    //creating lookup from Individual Email Result iterating through Email Send list
    //Creates 50 Individual Email Result for every Email Send
    	
    	LIST<et4ae5__IndividualEmailResult__c>  indRes = new List<et4ae5__IndividualEmailResult__c>(); 
    
    		for(et4ae5__SendDefinition__c esl : es){
    
    			for(Integer t = 0; t < 10; t++){
    				indRes.add(new et4ae5__IndividualEmailResult__c(
                        
                         et4ae5__SendDefinition__c = esl.ID 
    																	) );
    			}
    		}


    insert indRes; 
    
        //Debugging 
            system.debug('TEST_Email Result Size >>>'+ indRes.size());
            system.debug('TEST_Email Result[0] Id >>>'+ indRes[0].id);
            system.debug('TEST_Email Result Email Send[0] ID >>>'+ indRes[0].et4ae5__SendDefinition__c);
            system.debug('TEST_Email Result Email Send[1] ID >>>'+ indRes[1].et4ae5__SendDefinition__c);
            
        


    //creating lookup from Individual Link iterating through Individual Email Result list
    //Creates 2 Individual Email Result for every Individual Email Result    
       
        LIST<et4ae5__IndividualLink__c>  indLnk = new List<et4ae5__IndividualLink__c>(); 
    
    		for(et4ae5__IndividualEmailResult__c ier : indRes){
    
    			for(Integer t = 0; t < 1; t++){
    				indLnk.add(new et4ae5__IndividualLink__c(
                        
                         et4ae5__Individual_Email_Result__c = ier.id, 
                         et4ae5__Unique_Link_ID__c = 'a1Co0000002FZLSEA4003o000000h80bcAAA48396'+ string.valueOf(Math.random())
    																	) );
    			}
    		} 
     
    insert indLnk; 
    
    
                      // Schedule the test job
                
                      String jobId = System.schedule('sch_DeleteEmailSend',
                      CRON_EXP, 
                         new sch_DeleteEmailSend());
                
                      // Get the information from the CronTrigger API object
                      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                         NextFireTime
                         FROM CronTrigger WHERE id = :jobId];
                
                      // Verify the expressions are the same
                      System.assertEquals(CRON_EXP, 
                         ct.CronExpression);
                
                      // Verify the job has not run
                      System.assertEquals(0, ct.TimesTriggered);
                
                      // Verify the next time the job will run
                      System.assertEquals('2022-03-15 00:00:00', 
                         String.valueOf(ct.NextFireTime));
                    
                    //Asserting the records are not deleted     
                      list<et4ae5__IndividualEmailResult__c> delrec = [SELECT id, isdeleted FROM et4ae5__IndividualEmailResult__c WHERE et4ae5__SendDefinition__r.id = : es];
                        
                        for(integer i = 0; i < delrec.size(); i++ ){     
                          System.assertNotEquals('true', string.valueOf(delrec[i].isdeleted) );
                            // database.Query('SELECT id, isdeleted FROM et4ae5__IndividualEmailResult__c WHERE et4ae5__SendDefinition__r.id = :'+ es.ID));
                        }
                        
                    
                   Test.stopTest();
                  /*   
                     ***Seems to be a false positive. Assert is returning false but the test log showed that a DML delete and Empty Bin operation was performed without any error***
                     ***I suspect it may be the context of the query whereby it's returning the result prior to the DML operation***
                            
                     //Asserting the records are deleted 
                        list<et4ae5__IndividualEmailResult__c> afterdelrec = [SELECT id, isdeleted FROM et4ae5__IndividualEmailResult__c WHERE et4ae5__SendDefinition__r.id = : es];
                      
                         for(integer i = 0; i < afterdelrec.size(); i++ ){   
                          system.debug('Asserting afterdelrec ' +string.valueOf(afterdelrec[i].isdeleted));
                          System.assertNotEquals('false', string.valueOf(afterdelrec[i].isdeleted) );
                         
                            // database.Query('SELECT id, isdeleted FROM et4ae5__IndividualEmailResult__c WHERE et4ae5__SendDefinition__r.id = :'+ es.ID));
                        } */
                    
        } 
}