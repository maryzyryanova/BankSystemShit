import Foundation

class SalaryProjectRequest: PRequest{
    var id: String
    var bank: String
    var status: String
    var company: Company
    var salaryProject: SalaryProject
    var user: Client
    var userAccountId: String
    
    init(_ bank: String, _ status: String, _ company: Company, _ salaryProject: SalaryProject, _ user: Client, _ userAccountId: String){
        self.id = UUID().uuidString
        self.bank = bank
        self.status = status
        self.company = company
        self.salaryProject = salaryProject
        self.user = user
        self.userAccountId = userAccountId
    }
    
    func setStatus(_ status: String) {
        self.status = status
    }
    
    func info() -> String {
       return """
        Salary project request:
        Bank: \(bank)
        Status: \(status)
        Company: \(company.name)
        SalaryProject:
        \(salaryProject.info())
        From client: \(user.login)
        To user account: \(userAccountId)
        """
    }
    
}
