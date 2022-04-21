//
//  ManagerModel.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 19.04.22.
//

import Foundation

class ManagerModel: PModel{
    private(set) var db: JSONDatabase
    private(set) var user: Manager
    private(set) var requests: [PRequest]
    
    init(_ user: Manager, _ requests: [PRequest]){
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
    
    func getRequest(_ id: String) -> PRequest?{
        guard let request = requests.first(where: {$0.id == id}) else {return nil}
        return request
    }
    
    func info() -> String{
        return user.info()
    }
}
