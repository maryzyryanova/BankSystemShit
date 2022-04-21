import Foundation

class Transaction: PRequest{
    
    var id: String
    var bank: String
    var status: String
    
    
    var senderName: String
    var recieverName: String
    var senderAccountId: String
    var recieverAccountId: String
    var sum: Double
    
    init(_ bank: String, _ status: String, _ senderName: String, _ recieverName: String, _ senderAccountId: String, _ recieverAccountId: String, _ sum: Double){
        self.id = UUID().uuidString
        self.senderName = senderName
        self.recieverName = recieverName
        self.bank = bank
        self.status = status
        self.senderAccountId = senderAccountId
        self.recieverAccountId = recieverAccountId
        self.sum = sum
    }
    
    func setStatus(_ status: String) {
        self.status = status
    }
    
    func info() -> String {
        return """
                Transaction:
                Bank: \(bank)
                Sender: \(senderName)
                Sender account:
                \(senderAccountId)
                Reciever: \(recieverName)
                Reciever account:
                \(recieverAccountId)
                Sum: \(sum)
                Status: \(status)
                """
    }
    
}
