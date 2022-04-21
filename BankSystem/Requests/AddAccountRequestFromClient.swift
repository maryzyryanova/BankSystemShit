import Foundation

class AddAccountRequestFromClient: PRequest{
    
    private(set) var id: String
    private(set) var bank: String
    private(set) var status: String
    private(set) var account: Account
    private(set) var sender: Client
    
    init(_ bank: String, _ status: String, _ account: Account, _ sender: Client){
        self.id = UUID().uuidString
        self.bank = bank
        self.status = status
        self.account = account
        self.sender = sender
    }
    
    func setStatus(_ status: String){
        self.status = status
    }
    
    func info() -> String{
        return """
                Add account request:
                To bank: \(bank)
                From client: \(sender.login)
                Status: \(status)
                """
    }
}
