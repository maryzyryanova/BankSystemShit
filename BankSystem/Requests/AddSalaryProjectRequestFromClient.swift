import Foundation

class AddSalaryProjectRequestFromClient : PRequest{
    private(set) var id: String
    private(set) var bank: String
    private(set) var status: String
    
    private(set) var salaryproject: SalaryProject
    private(set) var sender: Client
    
    init(_ bank: String, _ status: String, _ salaryproject: SalaryProject, _ sender: Client){
        self.id = UUID().uuidString
        self.bank = bank
        self.status = status
        self.salaryproject = salaryproject
        self.sender = sender
    }
    
    func setStatus(_ status: String){
        self.status = status
    }
    
    func info() -> String{
        return """
                Add salary project request:
                To bank: \(bank)
                From client: \(sender.login)
                Title: \(salaryproject.title)
                Description: \(salaryproject.description)
                Sum: \(salaryproject.sum)
                Status: \(status)
                """
    }
}
