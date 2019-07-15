//
//  ContactListTableViewController.swift
//  ContactList2
//
//  Created by Madison Kaori Shino on 7/14/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    //Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshContacts()
    }
    
    //Helper Functions
    func refreshContacts() {
        ContactController.sharedInstance.retrieveContactsFromCloud { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.sharedInstance.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = ContactController.sharedInstance.contacts[indexPath.row]
        cell.textLabel?.text = "\(contact.firstName) \(contact.lastName)"
        return cell
    }

    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetailViewController" {
            let destinationVC = segue.destination as? ContactDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let contact = ContactController.sharedInstance.contacts[indexPath.row]
            destinationVC?.contact = contact
        }
    }
}
