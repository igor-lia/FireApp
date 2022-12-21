//
//  TasksViewController.swift
//  FireApp
//
//  Created by Ігор Ляхович on 20.12.2022.
//

import UIKit
import FirebaseAuth

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks = ["Hello", "Swift", "C", "C++"]
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
    
    
    @IBAction func addTap(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func singOutTap(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true)
    }
}
