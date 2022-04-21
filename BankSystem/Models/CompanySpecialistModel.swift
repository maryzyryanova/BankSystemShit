//
//  CompanySpecialistModel.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 19.04.22.
//

import Foundation

class CompanySpecialistModel: PModel{
    private(set) var db: JSONDatabase
    private(set) var bank: String
    private(set) var user: CompanySpecialist
    private(set) var company: Company
    
    init(_ bank: String, _ user: CompanySpecialist, _ company: Company){
        self.db = JSONDatabase.shared
        self.bank = bank
        self.user = user
        self.company = company
    }
    
    func getAccount(_ id: String) -> Account?{
        return db.findCompanyAccount(bank, company.name, id)
    }
    
    func addAccount(){
        let account = Account(id: UUID().uuidString, balance: 0, status: "InUse")
        db.notify(AddAccountRequestFromCompany(bank, "Awaiting", company , account))
    }
    
    func closeAccount(_ id: String){
        db.notify(CloseAccountRequestFromCompany(bank, "Awaiting", company.name, id))
    }
    
    func topUpAccount(_ id: String, _ sum: Double){
        db.topUpCompanyAccount(bank, company.name, id, sum)
    }
    
    func withdrawAccount(_ id: String){
        db.withdrawCompanyAccount(bank, company.name, id)
    }
    
    func updateAccounts(){
        let company = Company(type: company.type, name: company.name, unp: company.unp, bik: company.bik, adress: company.adress, specialists: company.specialists, accounts: db.findCompanyAccounts(bank, company.name), salaryProjects: company.salaryProjects)
        self.company = company
    }
    
    func updateSalaryProjects(){
        let company = Company(type: company.type, name: company.name, unp: company.unp, bik: company.bik, adress: company.adress, specialists: company.specialists, accounts: db.findCompanyAccounts(bank, company.name), salaryProjects: db.findCompanySalaryProjects(bank, company.name))
        self.company = company
    }
    
    func addSalaryProject(_ title: String, _ description: String, _ sum: Double){
        let salaryProject = SalaryProject(title: title, description: description, sum: sum)
        db.addSalaryProject(bank, company.name, salaryProject)
    }
    
    func removeSalaryProject(_ salaryProject: SalaryProject){
        db.removeSalaryProject(bank, company.name, salaryProject)
    }
    
    func transactionToCompany(_ toCompany: String, _ recieverAccountId: String, _ senderAccountId: String, _ sum: Double){
        db.notify(Transaction(bank, "Awaiting", company.name, toCompany, senderAccountId, recieverAccountId, sum))
    }
    
    func getCompanies() -> [Company]{
        return db.findCompanies(bank, company.name)
    }
    
    func info() -> String{
        return """
                Company specialist:
                \(user.info())
                \(company.info())
                """
    }
}
