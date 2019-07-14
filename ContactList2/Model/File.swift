//
//  File.swift
//  ContactList2
//
//  Created by Madison Kaori Shino on 7/14/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    
    //Class Properties
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var cloudKitRecordID: CKRecord.ID
    
    //Designated Init
    init(firstName: String, lastName: String = "", phoneNumber: String = "", email: String = "", cloudKitRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.cloudKitRecordID = cloudKitRecordID
    }
    
    //Convenience init for a contact from a record
    convenience init?(record: CKRecord) {
        guard let firstName = record[ContactConstants.firstNameKey] as? String,
        let lastName = record[ContactConstants.lastNameKey] as? String,
        let phoneNumber = record[ContactConstants.phoneNumberKey] as? String,
        let email = record[ContactConstants.emailKey] as? String
            else { return nil }
        self.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, cloudKitRecordID: record.recordID)
    }
}

//Convenience init for a record
extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: ContactConstants.contactTypeKey, recordID: contact.cloudKitRecordID)
        self.setValue(ContactConstants.firstNameKey, forKey: contact.firstName)
        self.setValue(ContactConstants.lastNameKey, forKey: contact.lastName)
        self.setValue(ContactConstants.phoneNumberKey, forKey: contact.phoneNumber)
        self.setValue(ContactConstants.emailKey, forKey: contact.email)
    }
}

//Record key magic strings
struct ContactConstants {
    static let contactTypeKey = "Contact"
    fileprivate static let firstNameKey = "firstName"
    fileprivate static let lastNameKey = "lastName"
    fileprivate static let phoneNumberKey = "phoneNumber"
    fileprivate static let emailKey = "email"
}
