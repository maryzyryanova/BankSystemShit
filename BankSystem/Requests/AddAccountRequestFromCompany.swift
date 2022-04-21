import Foundation

class AddAccountRequestFromCompany: PRequest{
    var id: String
    var bank: String
    var status: String
    var company: Company
    var account: Account
    
    init(_ bank: String, _ status: String, _ company: Company, _ account: Account){
        self.id = UUID().uuidString
        self.bank = bank
        self.status = status
        self.company = company
        self.account = account
    }
    
    func setStatus(_ status: String) {
        self.status = status
    }
    
    func info() -> String {
        return """
                Add account request:
                To bank: \(bank)
                From company: \(company.name)
                Status: \(status)
                """
    }
}
