/**
	* sch_DeleteEmailSend - <
	* This class implements the standard SF Schedualble Interface that is used to
	* schedule a batch delete of Individual Email Sent and Individual Link assocciated 
	* to an Email Send that is over 30 days old. The data is loaded into an SObject 
	* and then a callout is made to the Database.batchable class passing the data for deletion.
	* >
	* Created by BrainEngine Cloud Studio
	* @author: Chanveasna Khath
	* @version: 1.0
*/


global class Sch_DeleteEmailSend implements Schedulable{
   
        
      global void execute(SchedulableContext sc){  
        
        /*getting custom metadata types configuration of days as xDays to use in query to identify Old Email Send.
        @final because incase an admin changes xDays setting during a scheduled run making sure 
        the underlying process don't get impacted .*/

    	list <Sch_Delete_Config__mdt> metaConfigDays = [SELECT Days_Old__c FROM Sch_Delete_Config__mdt  LIMIT 1];
		final Integer xDays = Integer.valueOf(metaConfigDays[0].Days_Old__c);	
 		system.debug('SCH_xDays>>>>>'+xDays);

		String qLimit = 'Limit 5000';
        
        
        /*Using dynamic query to get Invidual Email Results that are associated to Email Send older than 30 days into an Sobject.
        From that result get the ids and put into a unique set to be used for queryinging Individual Link related to an Individual Email Sent.*/
        
    	List<sObject> emailResults = Database.query('SELECT e.Id, e.et4ae5__SendDefinition__r.et4ae5__DateSent__c FROM et4ae5__IndividualEmailResult__c e WHERE e.et4ae5__SendDefinition__r.et4ae5__DateSent__c < LAST_N_Days:'+xDays+ ' ' +qlimit);
    	Set<Id> emailResultIds = (new Map<Id,SObject>(emailResults)).keySet();
        System.debug('SCH_Email Result IDs size >>>>>'+emailResultIds.size());  	

    	//Loading up the records to be deleted
    	list<sObject> delRecords = new List<sObject>();
                
                 try {
                        
                        if(!emailResults.isEmpty()){    
                            
                            //List of Individual Link to be deleted
                            delRecords.addAll((List<SObject>)[SELECT e.et4ae5__Individual_Email_Result__r.Id , e.Id 
                                                              FROM et4ae5__IndividualLink__c e 
                                                              WHERE  e.et4ae5__Individual_Email_Result__r.Id = :emailResultIds]);
                                                              
                            //Debug
							System.debug('SCH_Indivudal Link IDs size >>>>>'+delRecords.size()); 
                                                              
                    	    //List of Individual Email Sent to be deleted
                    	    delRecords.addAll((list<Sobject>) [SELECT Id 
                    	                                       FROM et4ae5__IndividualEmailResult__c 
                    	                                       WHERE id = :emailResultIds ]);
							
							 	
							
                            //Debug: Logging deleted total records and ids to be deleted.
                                Set<Id> IndlnkdeletedIds = (new Map<Id,SObject>(delRecords)).keySet();
                            	System.debug('Total Records to be deleted >>>>>'+delRecords.size());
                            	System.debug('Ids to be deleted >>>>>'+ IndlnkdeletedIds);
                            
                            
                          //Pass records to Batch Apex class for deletion.     
                          BatchEmailSndDelete delBatch = new BatchEmailSndDelete(delRecords);
                          //Store batch Process ID and excute batch job in set of 200.
                          Id BatchProcessId = Database.ExecuteBatch(delBatch,200);
                                
                        }        
                
                 } catch(DmlException e){}

    
           }
      
    }