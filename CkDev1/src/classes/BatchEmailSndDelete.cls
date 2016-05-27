/**
	* BatchEmailSndDelete - <
	* This class takes the Sobject thats passed by the Scheduler class and 
	* execute the a DML delete and then ahard delete in bataches of 200 records. 
	* The batch size was set in the Scheduler class upon invocation of this class.>
	* Created by BrainEngine Cloud Studio
	* @author: Chanveasna Khath
	* @version: 1.0
*/

global class BatchEmailSndDelete implements Database.batchable<SObject>, Database.Stateful{
    
     global final list<SObject> delRecords = new list<sobject>();  

        
        //Constructor getting sobject from Scheduler 
        global BatchEmailSndDelete(list<SObject> del){
            
           delRecords.addAll(del);
           system.debug('Constructor delRecords \'JSON\' >>>' + delRecords);
         
          
            
        }
        
        //Load up the data
        global Iterable<SObject> start(Database.batchableContext BC){
            
            system.debug('Start Method delRecords \'JSON\' >>>' +delRecords);
            return delRecords;
            
            
        }
        
        
        
        //Execute the job    
         global void execute(Database.BatchableContext BC, List<SObject> scope){
             
             system.debug('excute scope deleted objets \'JSON\' >>>' +scope);
             delete scope;
             Database.emptyRecycleBin(scope);
             system.debug('execute empty recycle bin \'JSON\' >>>' +scope);
               
            }
        
        //Send email when batch job finishes
            global void finish(Database.BatchableContext BC){
                
             
          
         // Need to setup mall email permission on user(System.EmailException: SendEmail failed. First exception on row 0; first error: NO_MASS_MAIL_PERMISSION, Single email is not enabled for your organization or profile.: [] 
          
          
          
            AsyncApexJob a =  [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email
                               FROM AsyncApexJob 
                               WHERE Id = :BC.getJobId()];
            
                          
               // Send an email to the Apex job's submitter 
               // notifying of job completion. 
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               
               
               //String[] toAddresses = new String[] {a.CreatedBy.Email};
               
               String[] toAddresses = new String[] {'Chanveasna.khath@tufts.edu'};
              
               mail.setToAddresses( toAddresses);
               mail.setSubject('Record Clean Up Status: ' + a.Status);
               mail.setPlainTextBody
               ('The batch Apex job processed ' + a.TotalJobItems +
               ' batches with '+ a.NumberOfErrors + ' failures.');
               Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                
            }

}