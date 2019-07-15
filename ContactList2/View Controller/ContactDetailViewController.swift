//
//  ContactDetailViewController.swift
//  ContactList2
//
//  Created by Madison Kaori Shino on 7/14/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    //Landing Pad
    var contact: Contact? {
        didSet {
            updateViews()
        }
    }
    
    //Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Helper Functions
    func updateViews() {
        guard let contact = contact else { return }
        firstNameTextField.text = contact.firstName
        lastNameTextField.text = contact.lastName
        emailTextField.text = contact.email
        phoneTextField.text = contact.phoneNumber
    }

    //Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let phoneNumber = phoneTextField.text
            else { return }
        if let contact = contact {
            ContactController.sharedInstance.updateContact(contact: contact, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email) { (success) in
                if success {
                    print("Contact successfully updated")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            ContactController.sharedInstance.createContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email) { (contact) in
                if contact != nil {
                    print("Contact successfully created")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
