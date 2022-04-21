import Foundation

class CloseAccountRequestFromCompany: PRequest{
    var id: String
    var bank: String
    var status: String
    var companyName: String
    var accountId: String
    
    init(_ bank: String, _ status: String, _ companyName: String, _ accountId: String){
        self.id = UUID().uuidString
        self.bank = bank
        self.status = status
        self.companyName = companyName
        self.accountId = accountId
    }
    
    func setStatus(_ status: String) {
        self.status = status
    }
    
    func info() -> String {
        return """
                Close account request:
                To bank: \(bank)
                Account id: \(accountId)
                From company: \(companyName)
                Status: \(status)
                """
    }
}
