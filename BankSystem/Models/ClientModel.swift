//
//  ClientModel.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 19.04.22.
//

import Foundation

class ClientModel: PModel{
    private(set) var db: JSONDatabase
    private(set) var bank: String
    private(set) var user: Client
    private(set) var salaryProjects: [SalaryProject]
    
    init(_ user: Client, _ bank: String, _ salaryProjects: [SalaryProject]){
        self.db = JSONDatabase.shared
        self.bank = bank
        self.user = user
        self.salaryProjects = salaryProjects
    }
    
    func addAccount(){
        let account = Account(id: UUID().uuidString, balance: 0, status: "InUse")
        db.notify(AddAccountRequestFromClient(bank, "Awaiting", account , user))
    }
    
    func closeAccount(_ id: String){
        db.notify(CloseAccountRequestFromClient(bank, "Awaiting", id, user.login))
    }
    
    func getAccount(_ id: String) -> Account?{
        return db.findClientAccount(bank, user.login, id)
    }
    
    func topUpAccount(_ id: String, _ sum: Double){
        db.topUpClientAccount(bank, user.login, id, sum)
    }
    
    func withdrawAccount(_ id: String){
        db.withdrawClientAccount(bank, user.login, id)
    }
    
    func addCredit(_ condition: String, _ sum: Double){
        let credit = Credit(id: UUID().uuidString, sum: sum, payed: 0, condition: condition)
        db.notify(AddCreditRequestFromClient(bank, "Awaiting", credit, user))
    }
    
    func payCredit(_ id: String, _ sum: Double, _ accountId: String){
        db.payCredit(bank, user.login, id, accountId, sum)
    }
    
    func creditInfo(_ id: String) -> String{
        if let credit = db.findClientCredit(bank, user.login, id){
            return credit.info()
        }
        return ""
    }
    
    func updateCredits() -> [Credit]{
        return db.findClientCredits(bank, user.login)
    }
    
    func updateInstallments() -> [Installment]{
        return db.findClientInstallments(bank, user.login)
    }
    
    func updateAccounts(){
        let user = Client(login: user.login, password: user.password, name: user.name, passportData: user.passportData, passportId: user.passportId, phone: user.phone, email: user.email, credits: user.credits, installments: user.installments, accounts: db.findClientAccounts(bank, user.login))
        self.user = user
    }
    
    func addInstallment(_ condition: String, _ sum: Double){
        let installment = Installment(id: UUID().uuidString, price: sum, payed: 0, condition: condition)
        db.notify(AddInstallmentRequestFromClient(bank, "Awaiting", installment, user))
    }
    
    func installmentInfo(_ id: String) -> String{
        if let installment = db.findClientInstallment(bank, user.login, id){
            return installment.info()
        }
        return ""
    }
    
    func payInstallment(_ id: String, _ sum: Double, _ accountId: String){
        db.payInstallment(bank, user.login, id, accountId, sum)
    }
    
    func info() -> String{
        return user.info()
    }
    
    func getBank() -> Bank?{
        for b in db.banks{
            if b.name == bank{
                return b
            }
        }
        return nil
    }
    
    func requestSalaryProject(_ company: Company, _ salaryProject: SalaryProject, _ accountId: String){
        db.notify(SalaryProjectRequest(bank, "Awaiting", company, salaryProject, user, accountId))
    }
    
}
