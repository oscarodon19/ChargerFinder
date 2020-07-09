//
//  User.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 05/07/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String?
  
  init(authData: Firebase.User) {
    uid = authData.uid
    email = authData.email
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}
