import Foundation

class RegistrationRequest: PRequest{
    private(set) var id: String
    private(set) var bank: String
    private(set) var status: String
    private(set) var client: Client
    
    init(_ bank: String, _ status: String, _ client: Client){
        self.id = UUID().uuidString
        self.bank = bank
        self.status = status
        self.client = client
    }
    
    func setStatus(_ status: String){
        self.status = status
    }
    
    func info() -> String{
        return """
                Registration request:
                To bank: \(bank)
                Client info:
                Login: \(client.login)
                Name: \(client.name)
                Passport data: \(client.passportData)
                Passport id: \(client.passportId)
                Email: \(client.email)
                Phone: \(client.phone)
                Status: \(status)
                """
    }
}
