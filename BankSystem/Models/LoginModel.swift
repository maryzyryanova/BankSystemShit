//
//  LoginModel.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 19.04.22.
//

import Foundation

class LoginModel: PModel{
    private(set) var db: JSONDatabase
    
    init(){
        self.db = JSONDatabase.shared
    }
    
    func loginMethod(_ login: String, _ password: String, _ bank: String) -> PModel?{
        return db.login(login, password, bank)
    }
    
    func registerMethod(_ client: Client, _ bank: String){
        db.notify(RegistrationRequest(bank, "Awaiting", client))
    }
}
