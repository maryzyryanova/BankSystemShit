import Cocoa

class AddInstallmentRequestFromClient : PRequest{
    private(set) var id: String
    private(set) var bank: String
    private(set) var status: String
    
    private(set) var installment: Installment
    private(set) var sender: Client
    
    init(_ bank: String, _ status: String, _ installment: Installment, _ sender: Client){
        self.id = UUID().uuidString
        self.bank = bank
        self.status = status
        self.installment = installment
        self.sender = sender
    }
    
    func setStatus(_ status: String){
        self.status = status
    }
    
    func info() -> String{
        return """
                Add installment request:
                To bank: \(bank)
                From client: \(sender.login)
                Credit sum: \(installment.price)
                Condition: \(installment.condition)
                Status: \(status)
                """
    }
}
