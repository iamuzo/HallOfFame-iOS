//
//  PersonTableViewController.swift
//  HallOfFame
//
//  Created by Uzo on 1/23/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import UIKit

class PersonTableViewController: UITableViewController {
    
    //Properties
    
    var people: [Person] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    //OUTLETS

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPeople()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func fetchPeople() {
        PersonController.getPeople { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let people):
                        print(people)
                        self.people = people
                    case .failure(let error):
                    print(error)
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }

    //ACTIONS
    @IBAction func addPersonButtonTapped(_ sender: UIBarButtonItem) {
        
        //Create Alert
        let alertController = UIAlertController(
            title: "New Hall of Famer",
            message: "Add a new Person",
            preferredStyle: .alert
        )
        
        // Add 2 Textfields for firstName and lastName
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter First Name"
        }

        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter Last Name"
        }
        
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter your Cohort"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            // Get Textfields
            guard
                let firstNameTextField = alertController.textFields?[0],
                let lastNameTextField = alertController.textFields?[1],
                let cohortTextField = alertController.textFields?[2],
                
                // Get First + Last names
                let firstName = firstNameTextField.text,
                let lastName = lastNameTextField.text,
                let cohort = cohortTextField.text,
                
                // Make sure name strings are not empty
                !firstName.isEmpty,
                !lastName.isEmpty,
                !cohort.isEmpty else { return }
            
            //Send Data to PersonController
            PersonController.postPerson(firstName: firstName, lastName: lastName, cohort: cohort) { (result) in
                
                //Return to the main thread
                DispatchQueue.main.async {
                    
                    //Find out which result you got
                    switch result {
                        case .success(let person):
                            self.people.append(person)
                        case .failure(let error):
                            self.presentErrorToUser(localizedError: error)
                    }
                }
            }
    
        }
        alertController.addAction(submitAction)
        

        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        let person = people[indexPath.row]
        let personFullName  = person.firstName + " " + person.lastName
        let personIDAsString = person.personID ?? 0
        
        cell.textLabel?.text = personFullName
        cell.detailTextLabel?.text = String(personIDAsString)
        return cell
    }
}
