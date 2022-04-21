//
//  AdminModel.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 19.04.22.
//

import Foundation

class AdminModel: PModel{
    private(set) var db: JSONDatabase
    var user: Admin
    var requests: [PRequest]
    
    init(_ user: Admin, _ requests: [PRequest]){
        self.db = JSONDatabase.shared
        self.user = user
        self.requests = requests
    }
    
    func approveRequest(_ id: String){
        db.approveRequest(id)
    }
    
    func denyRequest(_ id: String){
        db.denyRequest(id)
    }
    
    func requestInfo(_ id: String) -> String{
        if let request = db.requests.first(where: {$0.id == id}){
            return request.info()
        }
        return ""
    }
    
    func info() -> String{
        return user.info()
    }
    
    func log() -> String{
        return db.logstring
    }
}
