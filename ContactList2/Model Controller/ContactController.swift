//
//  ModelController.swift
//  ContactList2
//
//  Created by Madison Kaori Shino on 7/14/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    //Singleton
    static let sharedInstance = ContactController()
    
    //Source of Truth
    var contacts: [Contact] = []
    
    //Database
    let privateDatabase = CKContainer.default().publicCloudDatabase
    
    //Create Contact
    func createContact(firstName: String, lastName: String, phoneNumber: String, email: String, completion: @escaping (Contact?) -> Void) {
        let newContact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
        let contactRecord = CKRecord(contact: newContact)
        privateDatabase.save(contactRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record else { completion(nil); return }
            guard let contact = Contact(record: record) else { completion(nil); return }
            self.contacts.append(contact)
            completion(contact)
        }
    }
    
    //Update Existing Contact
    func updateContact(contact: Contact, firstName: String, lastName: String, phoneNumber: String, email: String, completion: @escaping (Bool) -> Void) {
        contact.firstName = firstName
        contact.lastName = lastName
        contact.phoneNumber = phoneNumber
        contact.email = email
        let updatedRecord = CKRecord(contact: contact)
        let updateOperation = CKModifyRecordsOperation()
        updateOperation.recordsToSave = [updatedRecord]
        updateOperation.savePolicy = .changedKeys
        updateOperation.qualityOfService = .userInteractive
        updateOperation.queuePriority = .high
        updateOperation.completionBlock = {
            completion(true)
        }
        privateDatabase.add(updateOperation)
    }
    
    //Fetch Contact
    func retrieveContactsFromCloud(completion: @escaping ([Contact]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactConstants.contactTypeKey, predicate: predicate)
        privateDatabase.perform(query, inZoneWith: nil) { (contactRecords, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) : \(error)")
                completion(nil)
                return
            }
            guard let records = contactRecords else { completion(nil); return }
            let contacts: [Contact] = records.compactMap{Contact(record: $0)}
            self.contacts = contacts
            completion(contacts)
        }
    }
}
