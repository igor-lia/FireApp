//
//  User.swift
//  FireApp
//
//  Created by Ігор Ляхович on 21.12.2022.
//

import Foundation
import FirebaseAuth

struct UserModel {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
