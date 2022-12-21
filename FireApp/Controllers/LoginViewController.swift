//
//  ViewController.swift
//  FireApp
//
//  Created by Ігор Ляхович on 20.12.2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTexField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        warningLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "fireSegue", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTexField.text = ""
        passwordTextField.text = ""
    }
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    func displayWarningLabel(withText text: String) {
        warningLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { [weak self] in
            self?.warningLabel.alpha = 1
        }) { [weak self] complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    @IBAction func loginTap(_ sender: UIButton) {
        guard let email = emailTexField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if error != nil  {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: "fireSegue", sender: nil)
            }
            
            self?.displayWarningLabel(withText: "No such user")
        }
    }
    
    @IBAction func registerTap(_ sender: UIButton) {
        guard let email = emailTexField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            guard error == nil , user != nil else {
                print(error!.localizedDescription)
                return
            }
            
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email": user?.user.email])
        }
    }
    
}

