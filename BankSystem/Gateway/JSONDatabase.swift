//
//  JSONDatabase.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Foundation

class JSONDatabase{
    
    private(set) var banks = [Bank]()
    private(set) var requests = [PRequest]()
    private(set) var logstring = ""
    
    static var shared: JSONDatabase = {
        let instance = JSONDatabase()
        return instance
    }()
    
    
    private init(){
        loadData()
    }
    
    deinit{
        saveData()
    }
    
    func loadData(){
        if let path = Bundle.main.path(forResource: "Data", ofType: "json") {
            do {
                    print(path)
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(DataStruct.self, from: data)
                    for bank in jsonData.banks{
                        print(bank.name)
                    }
                self.banks = jsonData.banks
              } catch {
                  print(String(describing: error))
              }
        }
    }
    
    func saveData(){
        if let path = Bundle.main.url(forResource: "Data", withExtension: "json") {
            do{
                print(path)
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let json = try encoder.encode(DataStruct(banks: self.banks))
                let jsonString = String(data: json, encoding: .utf8)
                try jsonString?.write(to: path, atomically: true, encoding: .utf8)
            }catch{
                print(String(describing: error))
            }
        }
    }
    
    func login(_ login: String, _ password: String, _ bankName: String) -> PModel?{
        for bank in banks {
            if bank.name == bankName{
                for client in bank.clients{
                    if client.login == login && client.password == password{
                        return ClientModel(client, bankName, salaryProjects(bankName))
                    }
                }
                for _operator in bank.operators{
                    if _operator.login == login && _operator.password == password{
                        return OperatorModel(_operator, requests.filter({
                            ($0.bank == bankName && $0 is AddAccountRequestFromClient) ||
                            ($0.bank == bankName && $0 is CloseAccountRequestFromClient) ||
                            ($0.bank == bankName && $0 is SalaryProjectRequest) ||
                            ($0.bank == bankName && $0 is Transaction)
                        }))
                    }
                }
                for manager in bank.managers{
                    if manager.login == login && manager.password == password{
                        return ManagerModel(manager,requests.filter({
                            $0.bank == bankName
                        }))
                    }
                }
                for company in bank.companies{
                    for specialist in company.specialists{
                        if specialist.login == login && specialist.password == password{
                            return CompanySpecialistModel(bank.name, specialist, company)
                        }
                    }
                }
                for admin in bank.admins{
                    if(admin.login == login && admin.password == password){
                        return AdminModel(admin, requests.filter({ $0.bank == bankName }))
                    }
                }
                return nil
            }
        }
        return nil
    }
    
    func salaryProjects(_ bankName: String) -> [SalaryProject]{
        var sp = [SalaryProject]()
        if let bank = banks.first(where: { $0.name == bankName }){
            for company in bank.companies{
                sp.append(contentsOf: company.salaryProjects)
            }
        }
        return sp
    }
    
    func approveRequest(_ id: String){
        guard let request = requests.first(where: {$0.id == id}) else {return}
        if let accountRequest = request as? AddAccountRequestFromClient{
            guard let bankIndex = banks.firstIndex(where: {$0.name == accountRequest.bank}) else {return}
            guard let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == accountRequest.sender.login }) else {return}
            banks[bankIndex].clients[clientIndex].accounts.append(accountRequest.account)
            request.setStatus("Approved")
            logstring += "\n \(request.info()) \n"
        }
        if let accountRequest = request as? AddAccountRequestFromCompany{
            guard let bankIndex = banks.firstIndex(where: {$0.name == accountRequest.bank}) else {return}
            guard let companyIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == accountRequest.company.name }) else {return}
            banks[bankIndex].companies[companyIndex].accounts.append(accountRequest.account)
            request.setStatus("Approved")
            logstring += "\n \(request.info()) \n"
        }
        if let closeAccountRequestClient = request as? CloseAccountRequestFromClient{
            guard let bankIndex = banks.firstIndex(where: {$0.name == closeAccountRequestClient.bank}) else {return}
            guard let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == closeAccountRequestClient.senderLogin }) else {return}
            guard let accountIndex = banks[bankIndex].clients[clientIndex].accounts.firstIndex(where: {
                $0.id == closeAccountRequestClient.accountId
            }) else {return}
            let account = banks[bankIndex].clients[clientIndex].accounts[accountIndex]
            banks[bankIndex].clients[clientIndex].accounts.remove(at: accountIndex)
            banks[bankIndex].clients[clientIndex].accounts.append(Account(id: account.id, balance: account.balance, status: "Closed"))
            request.setStatus("Approved")
            logstring += "\n \(request.info()) \n"
        }
        if let closeAccountRequest = request as? CloseAccountRequestFromCompany{
            guard let bankIndex = banks.firstIndex(where: {$0.name == closeAccountRequest.bank}) else {return}
            guard let companyIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == closeAccountRequest.companyName }) else {return}
            guard let accountIndex = banks[bankIndex].companies[companyIndex].accounts.firstIndex(where: {
                $0.id == closeAccountRequest.accountId
            }) else {return}
            let account = banks[bankIndex].companies[companyIndex].accounts[accountIndex]
            banks[bankIndex].companies[companyIndex].accounts.remove(at: accountIndex)
            banks[bankIndex].companies[companyIndex].accounts.append(Account(id: account.id, balance: account.balance, status: "Closed"))
            request.setStatus("Approved")
            logstring += "\n \(request.info()) \n"
        }
        if let register = request as? RegistrationRequest{
            guard let bankIndex = banks.firstIndex(where: { $0.name == register.bank }) else {return}
            banks[bankIndex].clients.append(register.client)
            request.setStatus("Approved")
            logstring += "\n \(request.info()) \n"
        }
        if let credit = request as? AddCreditRequestFromClient{
            guard let bankIndex = banks.firstIndex(where: { $0.name == credit.bank }) else {return}
            guard let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == credit.sender.login }) else {return}
            banks[bankIndex].clients[clientIndex].credits.append(credit.credit)
            request.setStatus("Approved")
            logstring += "\n \(request.info()) \n"
        }
        
        if let installment = request as? AddInstallmentRequestFromClient{
            guard let bankIndex = banks.firstIndex(where: { $0.name == installment.bank }) else {return}
            guard let installmentIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == installment.sender.login }) else {return}
            banks[bankIndex].clients[installmentIndex].installments.append(installment.installment)
            request.setStatus("Approved")
            logstring += "\n \(request.info()) \n"
        }
        
        if let salaryProjectRequest = request as? SalaryProjectRequest{
            guard let bankIndex = banks.firstIndex(where: { $0.name == salaryProjectRequest.bank }) else {return}
            guard let clientIndex = banks[bankIndex].clients.firstIndex(where: {$0.login == salaryProjectRequest.user.login}) else {return}
            guard let accountIndex = banks[bankIndex].clients[clientIndex].accounts.firstIndex(where: {$0.id == salaryProjectRequest.userAccountId}) else {return}
            banks[bankIndex].clients[clientIndex].accounts[accountIndex].balance += salaryProjectRequest.salaryProject.sum
            request.setStatus("Approved")
            logstring += "\n \(request.info()) \n"
        }
        
        if let transaction = request as? Transaction{
            guard let bankIndex = banks.firstIndex(where: {$0.name == request.bank}) else {return}
            guard let senderIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == transaction.senderName }) else {return}
            guard let recieverIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == transaction.recieverName }) else {return}
            guard let senderAccountId = banks[bankIndex].companies[senderIndex].accounts.firstIndex(where: { $0.id == transaction.senderAccountId }) else {return}
            guard let recieverAccountId = banks[bankIndex].companies[recieverIndex].accounts.firstIndex(where: { $0.id == transaction.recieverAccountId }) else {return}
            banks[bankIndex].companies[senderIndex].accounts[senderAccountId].balance -= transaction.sum
            banks[bankIndex].companies[recieverIndex].accounts[recieverAccountId].balance += transaction.sum
            request.setStatus("Approved")
            logstring += "\n \(request.info()) \n"
        }
    }
    
    func cancelRequest(_ id: String){
        guard let request = requests.first(where: {$0.id == id}) else {return}
        if request.status == "Approved"{
            if let accountRequest = request as? AddAccountRequestFromClient{
                guard let bankIndex = banks.firstIndex(where: {$0.name == accountRequest.bank}) else {return}
                guard let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == accountRequest.sender.login }) else {return}
                guard let accountIndex = banks[bankIndex].clients[clientIndex].accounts.firstIndex(where: {$0.id == accountRequest.account.id}) else {return}
                banks[bankIndex].clients[clientIndex].accounts.remove(at: accountIndex)
                request.setStatus("Canceled")
                logstring += "\n \(request.info()) \n"
            }
            if let accountRequest = request as? AddAccountRequestFromCompany{
                guard let bankIndex = banks.firstIndex(where: {$0.name == accountRequest.bank}) else {return}
                guard let companyIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == accountRequest.company.name }) else {return}
                guard let accountIndex = banks[bankIndex].companies[companyIndex].accounts.firstIndex(where: {$0.id == accountRequest.account.id}) else {return}
                banks[bankIndex].companies[companyIndex].accounts.remove(at: accountIndex)
                request.setStatus("Canceled")
                logstring += "\n \(request.info()) \n"
            }
            if let closeAccountRequestClient = request as? CloseAccountRequestFromClient{
                guard let bankIndex = banks.firstIndex(where: {$0.name == closeAccountRequestClient.bank}) else {return}
                guard let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == closeAccountRequestClient.senderLogin }) else {return}
                guard let accountIndex = banks[bankIndex].clients[clientIndex].accounts.firstIndex(where: {
                    $0.id == closeAccountRequestClient.accountId
                }) else {return}
                let account = banks[bankIndex].clients[clientIndex].accounts[accountIndex]
                banks[bankIndex].clients[clientIndex].accounts.remove(at: accountIndex)
                banks[bankIndex].clients[clientIndex].accounts.append(Account(id: account.id, balance: account.balance, status: "InUse"))
                request.setStatus("Canceled")
                logstring += "\n \(request.info()) \n"
            }
            if let closeAccountRequest = request as? CloseAccountRequestFromCompany{
                guard let bankIndex = banks.firstIndex(where: {$0.name == closeAccountRequest.bank}) else {return}
                guard let companyIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == closeAccountRequest.companyName }) else {return}
                guard let accountIndex = banks[bankIndex].companies[companyIndex].accounts.firstIndex(where: {
                    $0.id == closeAccountRequest.accountId
                }) else {return}
                let account = banks[bankIndex].companies[companyIndex].accounts[accountIndex]
                banks[bankIndex].companies[companyIndex].accounts.remove(at: accountIndex)
                banks[bankIndex].companies[companyIndex].accounts.append(Account(id: account.id, balance: account.balance, status: "InUse"))
                request.setStatus("Canceled")
                logstring += "\n \(request.info()) \n"
            }
            if let register = request as? RegistrationRequest{
                guard let bankIndex = banks.firstIndex(where: { $0.name == register.bank }) else {return}
                guard let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == register.client.login }) else {return}
                banks[bankIndex].clients.remove(at: clientIndex)
                request.setStatus("Canceled")
                logstring += "\n \(request.info()) \n"
            }
            if let credit = request as? AddCreditRequestFromClient{
                guard let bankIndex = banks.firstIndex(where: { $0.name == credit.bank }) else {return}
                guard let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == credit.sender.login }) else {return}
                guard let creditIndex = banks[bankIndex].clients[clientIndex].credits.firstIndex(where: { $0.id == credit.credit.id }) else {return}
                banks[bankIndex].clients[clientIndex].credits.remove(at: creditIndex)
                request.setStatus("Canceled")
                logstring += "\n \(request.info()) \n"
            }
            
            if let installment = request as? AddInstallmentRequestFromClient{
                guard let bankIndex = banks.firstIndex(where: { $0.name == installment.bank }) else {return}
                guard let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == installment.sender.login }) else {return}
                guard let instIndex = banks[bankIndex].clients[clientIndex].installments.firstIndex(where: { $0.id == installment.installment.id }) else {return}
                banks[bankIndex].clients[clientIndex].installments.remove(at: instIndex)
                request.setStatus("Canceled")
                logstring += "\n \(request.info()) \n"
            }
            
            if let salaryProjectRequest = request as? SalaryProjectRequest{
                guard let bankIndex = banks.firstIndex(where: { $0.name == salaryProjectRequest.bank }) else {return}
                guard let clientIndex = banks[bankIndex].clients.firstIndex(where: {$0.login == salaryProjectRequest.user.login}) else {return}
                guard let accountIndex = banks[bankIndex].clients[clientIndex].accounts.firstIndex(where: {$0.id == salaryProjectRequest.userAccountId}) else {return}
                banks[bankIndex].clients[clientIndex].accounts[accountIndex].balance -= salaryProjectRequest.salaryProject.sum
                if banks[bankIndex].clients[clientIndex].accounts[accountIndex].balance <= 0{
                    banks[bankIndex].clients[clientIndex].accounts[accountIndex].balance = 0
                }
                request.setStatus("Canceled")
                logstring += "\n \(request.info()) \n"
            }
            
            if let transaction = request as? Transaction{
                guard let bankIndex = banks.firstIndex(where: {$0.name == request.bank}) else {return}
                guard let senderIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == transaction.senderName }) else {return}
                guard let recieverIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == transaction.recieverName }) else {return}
                guard let senderAccountId = banks[bankIndex].companies[senderIndex].accounts.firstIndex(where: { $0.id == transaction.senderAccountId }) else {return}
                guard let recieverAccountId = banks[bankIndex].companies[recieverIndex].accounts.firstIndex(where: { $0.id == transaction.recieverAccountId }) else {return}
                banks[bankIndex].companies[senderIndex].accounts[senderAccountId].balance += transaction.sum
                banks[bankIndex].companies[recieverIndex].accounts[recieverAccountId].balance -= transaction.sum
                if banks[bankIndex].companies[recieverIndex].accounts[recieverAccountId].balance <= 0{
                    banks[bankIndex].companies[recieverIndex].accounts[recieverAccountId].balance = 0
                }
                request.setStatus("Canceled")
                logstring += "\n \(request.info()) \n"
            }
        }
        if request.status == "Denied"{
            request.setStatus("Awaiting")
        }
    }
    
    func denyRequest(_ id: String){
        guard let request = requests.first(where: {$0.id == id}) else {return}
        request.setStatus("Denied")
    }
    
    func findClientAccount(_ bank: String, _ clientLogin: String, _ id: String) -> Account?{
        if let bank = banks.first(where: { $0.name == bank }){
            if let client = bank.clients.first(where: { $0.login == clientLogin }){
                if let account = client.accounts.first(where: { $0.id == id }){
                    return account
                }
            }
        }
        return nil
    }
    
    func findCompanies(_ bank: String, _ excludeCompany: String) -> [Company]{
        if let bank = banks.first(where: { $0.name == bank }){
            return bank.companies.filter({ $0.name != excludeCompany })
        }
        return []
    }
    
    func findCompanyAccount(_ bank: String, _ companyName: String, _ id: String) -> Account?{
        if let bank = banks.first(where: { $0.name == bank }){
            if let company = bank.companies.first(where: { $0.name == companyName}){
                if let account = company.accounts.first(where: { $0.id == id }){
                    return account
                }
            }
        }
        return nil
    }
    
    func findClientAccounts(_ bank: String, _ clientLogin: String) -> [Account]{
        if let bank = banks.first(where: { $0.name == bank }){
            if let client = bank.clients.first(where: { $0.login == clientLogin }){
                return client.accounts
            }
        }
        return []
    }
    
    func findCompanyAccounts(_ bank: String, _ companyName: String) -> [Account]{
        if let bank = banks.first(where: { $0.name == bank }){
            if let company = bank.companies.first(where: { $0.name == companyName }){
                return company.accounts
            }
        }
        return []
    }
    
    func findClientCredit(_ bank: String, _ clientLogin: String, _ id: String) -> Credit?{
        if let bank = banks.first(where: { $0.name == bank }){
            if let client = bank.clients.first(where: { $0.login == clientLogin }){
                if let credit = client.credits.first(where: { $0.id == id }){
                    return credit
                }
            }
        }
        return nil
    }
    
    func findClientInstallment(_ bank: String, _ clientLogin: String, _ id: String) -> Installment?{
        if let bank = banks.first(where: { $0.name == bank }){
            if let client = bank.clients.first(where: { $0.login == clientLogin }){
                if let installment = client.installments.first(where: { $0.id == id }){
                    return installment
                }
            }
        }
        return nil
    }
    
    func findClientCredits(_ bank: String, _ clientLogin: String) -> [Credit]{
        if let bank = banks.first(where: { $0.name == bank }){
            if let client = bank.clients.first(where: { $0.login == clientLogin }){
                return client.credits
            }
        }
        return []
    }
    
    func findClientInstallments(_ bank: String, _ clientLogin: String) -> [Installment]{
        if let bank = banks.first(where: { $0.name == bank }){
            if let client = bank.clients.first(where: { $0.login == clientLogin }){
                return client.installments
            }
        }
        return []
    }
    
    func findCompanySalaryProjects(_ bank: String, _ companyName: String) -> [SalaryProject]{
        if let bank = banks.first(where: { $0.name == bank }){
            if let company = bank.companies.first(where: { $0.name == companyName }){
                return company.salaryProjects
            }
        }
        return []
    }
    
    func topUpClientAccount(_ bank: String, _ clientLogin: String, _ id: String, _ sum: Double){
        if let bankIndex = banks.firstIndex(where: { $0.name == bank }){
            if let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == clientLogin }){
                if let accountIndex = banks[bankIndex].clients[clientIndex].accounts.firstIndex(where: { $0.id == id }){
                    banks[bankIndex].clients[clientIndex].accounts[accountIndex].balance += sum
                }
            }
        }
    }
    
    func withdrawClientAccount(_ bank: String, _ clientLogin: String, _ id: String){
        if let bankIndex = banks.firstIndex(where: { $0.name == bank }){
            if let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == clientLogin }){
                if let accountIndex = banks[bankIndex].clients[clientIndex].accounts.firstIndex(where: { $0.id == id }){
                    banks[bankIndex].clients[clientIndex].accounts[accountIndex].balance = 0
                }
            }
        }
    }
    
    func topUpCompanyAccount(_ bank: String, _ companyName: String, _ id: String, _ sum: Double){
        if let bankIndex = banks.firstIndex(where: { $0.name == bank }){
            if let companyIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == companyName }){
                if let accountIndex = banks[bankIndex].companies[companyIndex].accounts.firstIndex(where: { $0.id == id }){
                    banks[bankIndex].companies[companyIndex].accounts[accountIndex].balance += sum
                }
            }
        }
    }
    
    func withdrawCompanyAccount(_ bank: String, _ companyName: String, _ id: String){
        if let bankIndex = banks.firstIndex(where: { $0.name == bank }){
            if let companyIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == companyName }){
                if let accountIndex = banks[bankIndex].companies[companyIndex].accounts.firstIndex(where: { $0.id == id }){
                    banks[bankIndex].companies[companyIndex].accounts[accountIndex].balance = 0
                }
            }
        }
    }
    
    func addSalaryProject(_ bank: String, _ companyName: String, _ salaryProject: SalaryProject){
        if let bankIndex = banks.firstIndex(where: { $0.name == bank }){
            if let companyIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == companyName }){
                banks[bankIndex].companies[companyIndex].salaryProjects.append(salaryProject)
            }
        }
    }
    
    func removeSalaryProject(_ bank: String, _ companyName: String, _ salaryProject: SalaryProject){
        if let bankIndex = banks.firstIndex(where: { $0.name == bank }){
            if let companyIndex = banks[bankIndex].companies.firstIndex(where: { $0.name == companyName }){
                if let spIndex = banks[bankIndex].companies[companyIndex].salaryProjects.firstIndex(where: {$0.title == salaryProject.title && $0.description == salaryProject.description && $0.sum == salaryProject.sum}){
                    banks[bankIndex].companies[companyIndex].salaryProjects.remove(at: spIndex)
                }
            }
        }
    }
    
    func payCredit(_ bank: String, _ clientLogin: String, _ creditId: String, _ accountId: String, _ sum: Double){
        if let bankIndex = banks.firstIndex(where: { $0.name == bank }){
            if let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == clientLogin }){
                if let accountIndex = banks[bankIndex].clients[clientIndex].accounts.firstIndex(where: { $0.id == accountId }){
                    banks[bankIndex].clients[clientIndex].accounts[accountIndex].balance -= sum
                }
                if let creditIndex = banks[bankIndex].clients[clientIndex].credits.firstIndex(where: { $0.id == creditId }){
                    banks[bankIndex].clients[clientIndex].credits[creditIndex].payed += sum
                    if banks[bankIndex].clients[clientIndex].credits[creditIndex].payed >= banks[bankIndex].clients[clientIndex].credits[creditIndex].sum{
                        banks[bankIndex].clients[clientIndex].credits.remove(at: creditIndex)
                    }
                }
            }
        }
    }
    
    func payInstallment(_ bank: String, _ clientLogin: String, _ creditId: String, _ accountId: String, _ sum: Double){
        if let bankIndex = banks.firstIndex(where: { $0.name == bank }){
            if let clientIndex = banks[bankIndex].clients.firstIndex(where: { $0.login == clientLogin }){
                if let accountIndex = banks[bankIndex].clients[clientIndex].accounts.firstIndex(where: { $0.id == accountId }){
                    banks[bankIndex].clients[clientIndex].accounts[accountIndex].balance -= sum
                }
                if let installmentIndex = banks[bankIndex].clients[clientIndex].installments.firstIndex(where: { $0.id == creditId }){
                    banks[bankIndex].clients[clientIndex].installments[installmentIndex].payed += sum
                    if banks[bankIndex].clients[clientIndex].installments[installmentIndex].payed >= banks[bankIndex].clients[clientIndex].installments[installmentIndex].price{
                        banks[bankIndex].clients[clientIndex].installments.remove(at: installmentIndex)
                    }
                }
            }
        }
    }
    
    func notify(_ request: PRequest){
        requests.append(request)
        logstring += "\n \(request.info()) \n"
    }
}

extension JSONDatabase: NSCopying{
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
