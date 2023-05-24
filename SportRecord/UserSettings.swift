//
//  UserSettings.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/22.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var isNotLoggedIn: Bool{
            didSet {
                UserDefaults.standard.set(isNotLoggedIn, forKey: "isNotLoggedIn")
            }
    }
    
    @Published var user : User?{
        didSet {
            UserDefaults.standard.set(user?.email, forKey: "email")
        }
    }
        
    init() {
        self.isNotLoggedIn = UserDefaults.standard.bool(forKey: "isNotLoggedIn")
        if let email = UserDefaults.standard.string(forKey: "email") {
            if let user = DBService.shared.getUser(email: email){
                self.user = user
            }
        }
    }
}

struct User{
    var id : Int
    var name : String
    var email : String
}


