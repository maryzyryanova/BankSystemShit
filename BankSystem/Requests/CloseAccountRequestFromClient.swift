import Foundation

class CloseAccountRequestFromClient: PRequest{
    private(set) var id: String
    private(set) var bank: String
    private(set) var senderLogin: String
    private(set) var status: String
    private(set) var accountId: String
    
    init(_ bank: String, _ status: String, _ accountId: String, _ senderLogin: String){
        self.id = UUID().uuidString
        self.bank = bank
        self.status = status
        self.accountId = accountId
        self.senderLogin = senderLogin
    }
    
    func setStatus(_ status: String) {
        self.status = status
    }
    
    func info() -> String{
        return """
                Close account request:
                To bank: \(bank)
                Account id: \(accountId)
                From client: \(senderLogin)
                Status: \(status)
                """
    }
}
