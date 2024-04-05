/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Phi Huynh
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account newAccount = new Account();
        // Set some fields on the Account
        newAccount.Name = 'Exact Home Remodeling'; // Set the Account name
        newAccount.Description = 'Home Renovation'; // Set the Account description
        newAccount.Industry = 'Technology'; // Set the Industry field
        newAccount.Type = 'Customer';
        // Insert the Account into the database
        insert newAccount;
        // Return the Id of the newly created Account
        return newAccount.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account newAccount = new Account();
        newAccount.Name = name;
        newAccount.Industry = industry;
        // Insert the Account
        insert newAccount;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact();
        // Set some fields on the Contact
        // Set the AccountId field to the given accountId
        newContact.LastName = 'Smith';
        //Set accountId field to new contact
        newContact.AccountId = accountId;
        // Insert the Contact into the database
        insert newContact;
        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        List<Contact> contactsToUpdate = [SELECT Id, LastName FROM Contact WHERE Id = :contactId];
        for (Integer i = 0; i < contactsToUpdate.size(); i++) {
            // Get the Contact record at index i
            Contact contactToUpdate = contactsToUpdate[i];
            // Update the Contact's last name
            contactToUpdate.LastName = newLastName;
        }
        // Update the Contact in the database
        update contactsToUpdate;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        List<Opportunity> opportunitiesToUpdate = [SELECT Id FROM Opportunity WHERE Id = :oppId];
        // Check if any Opportunity records are found
        if (!opportunitiesToUpdate.isEmpty()) {
        // Iterate over the retrieved Opportunity records
        for (Integer i = 0; i < opportunitiesToUpdate.size(); i++) {
        // Get the Opportunity record using the index variable
        Opportunity oppToUpdate = opportunitiesToUpdate[i];
        
        // Update the Opportunity's stage
        oppToUpdate.StageName = newStage;
    }
        // Update the Opportunity in the database
        update opportunitiesToUpdate;
    }
}

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        List<Account> accountsToUpdate = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId];
        // Update the Account with the given Id with the new name and industry
        // Check if any Account records are found
        if (!accountsToUpdate.isEmpty()) {
        // Iterate over the retrieved Account records
        for (Integer i = 0; i < accountsToUpdate.size(); i++) {
            // Get the Account record using the index variable
            Account accToUpdate = accountsToUpdate[i];
            
            // Update the Account's Name and Industry fields
            accToUpdate.Name = newName;
            accToUpdate.Industry = newIndustry;
            // Update the Account records in the database
            update accountsToUpdate;
        }
    }
}


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Get today's date
        Date currentDate = Date.today();

        // Calculate the close date 3 months from today
        Date closeDate = currentDate.addMonths(3);

        // Loop through each Opportunity in the list
        for (Integer i = 0; i < opportunities.size(); i++) {
            Opportunity opp = opportunities[i];
            
            // Set the Opportunity's Stage to Qualification
            opp.StageName = 'Qualification';
            
            // Set the Opportunity's Close Date to 3 months from today
            opp.CloseDate = closeDate;
    
            // Set the Opportunity's Amount to 50000
            opp.Amount = 50000;
        }
        // Upsert the opportunities List so that records are either updated or created
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Query the Account based on the provided accountName
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
        Account acc;
        // Check if any account was found
        if (accounts.isEmpty()) {
            acc = new Account(Name = accountName);
            insert acc;
        } else {
            // Retrieve the first Account
            acc = accounts[0];
        }
        // Set to store unique Opportunity names
        Set<String> existingOpportunityNames = new Set<String>();
        // Retrieve existing Opportunity names for the Account
        List<Opportunity> existingOpps = [SELECT Name FROM Opportunity WHERE AccountId = :acc.Id];
        for (Opportunity existingOpp : existingOpps) {
            existingOpportunityNames.add(existingOpp.Name);
        }
        // List to hold Opportunity records
        List<Opportunity> opportunitiesToUpsert = new List<Opportunity>();
        // Loop through each Opportunity name
        for (String oppName : oppNames) {
            // Check if the name already exists
            if (existingOpportunityNames.contains(oppName)) {
                continue;
            }
            // Create an Opportunity with the given name
            Opportunity opp = new Opportunity(
                AccountId = acc.Id,
                Name = oppName,
                StageName = 'Prospecting',
                CloseDate = Date.today().addMonths(3)
            );
            opportunitiesToUpsert.add(opp);
            existingOpportunityNames.add(oppName);
        }
        // Upsert the opportunities
        upsert opportunitiesToUpsert;
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [  SELECT Id 
                                    FROM Account 
                                    WHERE Name = :accountName];
        // Initialize a variable to hold the Account to be upserted
        Account accountToUpsert;
        // If the Account exists, update the description to "Updated Account"
        if (!accounts.isEmpty()) {
            Account existingAccount = accounts[0];
            existingAccount.Description = 'Updated Account';
            accountToUpsert = existingAccount;
        } else {
            // If no such Account exists, create a new one and set the description to "New Account"
            Account newAccount = new Account(Name = accountName, Description = 'New Account');
            accountToUpsert = newAccount;
        }
        upsert accountToUpsert;
		// Upsert the Account
		return accountToUpsert;
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// list to hold the Contacts to upsert
        List<Contact> contactsToUpsertFinal = new List<Contact>();
        // Loop through each Contact
        for (Contact contact : contactsToUpsert) {
            // Extract the Account Name from Contact's LastName
            String accountName = contact.LastName;
            // Get the account based on the name or create one if it doesn't exist
            Account account = upsertAccount(accountName);
            // Link the Contact to its Account using the Account Id
            if (account != null) {
                contact.AccountId = account.Id;
                contactsToUpsertFinal.add(contact);
            }
        }
		// Upsert the Contacts
        upsert contactsToUpsertFinal;
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Loop through each Lead name and directly insert and delete the Lead
        for (Integer i = 0; i < leadNames.size(); i++) {
            String leadName = leadNames[i];

            // Insert the Lead
            Lead newLead = new Lead(
                FirstName = 'Example', 
                LastName = leadName,
                Company = 'Example Company'
            );
            insert newLead;

            // Delete the Lead
            delete newLead;
        }
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases
        for (Integer i = 0; i < numOfCases; i++) {
            Case newCase = new Case(
                AccountId = accountId,
                Subject = 'Test Case ' + String.valueOf(i + 1)
                // You can set other fields as needed
            );
            insert newCase;
        }
        // Delete the cases
        List<Case> casesToDelete = [SELECT Id FROM Case WHERE AccountId = :accountId LIMIT :numOfCases];
        delete casesToDelete;
    }
}