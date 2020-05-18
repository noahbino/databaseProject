
//
//  AuthVC.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 4/24/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {
    
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var userNameInput: UITextField!
    
    @IBOutlet weak var charactersLeftLabel: UILabel!
    
    @IBOutlet weak var userNameTakenLabel: UILabel!
    
    
    var namesArray = [String]()
    var userNameTaken = false

    
    override func viewDidLoad() {
        charactersLeftLabel.isHidden = true
        userNameTakenLabel.isHidden = true
        userNameInput.delegate = self
        namesArray = DataService.instance.getAllUserNames()
        
    }
    
    
    @IBAction func getStartedPressed(_ sender: Any) {
        
        userNameTaken = false
        for name in namesArray {
            if(name == userNameInput.text){
                userNameTaken = true
                break
            }
        }
        
        if(userNameInput.text != "" && userNameInput.text != "" && !userNameTaken){
            AuthService.instance.registerUser(withEmail: emailInput.text!, andUserName: userNameInput.text!) { (success, loginerror) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    
                }
            }
        } else if(userNameTaken){
            
            userNameInput.text = ""
            userNameTakenLabel.isHidden = false
        } else {
            
        }
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

 

}
extension AuthVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        self.charactersLeftLabel.isHidden = false
        var amount = 0
        var count = self.userNameInput.text?.count
        amount = 14 - count!
        self.charactersLeftLabel.text = "\(amount)"
        if(amount <= 0){
            self.userNameInput.text?.remove(at: (self.userNameInput.text?.index(before: self.userNameInput.text!.endIndex))!)
        }
        
        return true
    }
}
