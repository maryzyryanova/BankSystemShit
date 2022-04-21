import Foundation

class AddCreditRequestFromClient : PRequest{
    private(set) var id: String
    private(set) var bank: String
    private(set) var status: String
    
    private(set) var credit: Credit
    private(set) var sender: Client
    
    init(_ bank: String, _ status: String, _ credit: Credit, _ sender: Client){
        self.id = UUID().uuidString
        self.bank = bank
        self.status = status
        self.credit = credit
        self.sender = sender
    }
    
    func setStatus(_ status: String){
        self.status = status
    }
    
    func info() -> String{
        return """
                Add credit request:
                To bank: \(bank)
                From client: \(sender.login)
                Credit sum: \(credit.sum)
                Condition: \(credit.condition)
                Status: \(status)
                """
    }
}
