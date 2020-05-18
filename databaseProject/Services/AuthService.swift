//
//  AuthService.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 4/24/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import Foundation
import Firebase


class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andUserName userName: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
        
        Auth.auth().createUser(withEmail: email, password: "password") { (authResult, error) in
            
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider":user.providerID, "email": user.email, "userName" : userName, "signUpTime": HelperFunctions.instance.getTime(), "signUpDate" : HelperFunctions.instance.getDate()]
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
            
            userCreationComplete(true, nil)
        }
        
        
    }
    
    
    
    
    
    
}
