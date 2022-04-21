
import Foundation

struct DataStruct: Codable
{
    var banks: [Bank]
}

struct Bank: Codable
{
    var type: String
    var name: String
    var unp: String
    var bik: String
    var adress: String
    var clients: [Client]
    var managers: [Manager]
    var operators: [Operator]
    var companies: [Company]
    var admins: [Admin]
}

struct Client: Codable
{
    var login: String
    var password: String
    var name: String
    var passportData: String
    var passportId: String
    var phone: String
    var email: String
    var credits: [Credit]
    var installments: [Installment]
    var accounts: [Account]
    
    func info() -> String{
        return """
        name: \(name)
        passportData: \(passportData)
        passportId: \(passportId)
        phone: \(phone)
        email: \(email)
        login: \(login)
        password: \(password)
        """
    }
}

struct Manager: Codable
{
    var login: String
    var password: String
    
    func info() -> String{
        return """
        login: \(login)
        password: \(password)
        """
    }
}

struct Operator: Codable
{
    var login: String
    var password: String
    
    func info() -> String{
        return """
        login: \(login)
        password: \(password)
        """
    }
}

struct Company : Codable
{
    var type: String
    var name: String
    var unp: String
    var bik: String
    var adress: String
    var specialists: [CompanySpecialist]
    var accounts: [Account]
    var salaryProjects: [SalaryProject]
    
    func info() -> String{
        return """
                Компания: \(name)
                Тип: \(type)
                УНП: \(unp)
                БИК: \(bik)
                Адрес: \(adress)
                """
    }
}

struct CompanySpecialist: Codable
{
    var login: String
    var password: String
    
    func info() -> String{
        return """
        login: \(login)
        password: \(password)
        """
    }
}

struct Admin: Codable
{
    var login: String
    var password: String
    
    func info() -> String{
        return """
        login: \(login)
        password: \(password)
        """
    }
}

struct Account: Codable
{
    var id: String
    var balance: Double
    var status: String
    
    func info() -> String{
        return """
                id: \(id)
                balance: \(balance)
                status: \(status)
                """
    }
}

struct Credit: Codable
{
    var id: String
    var sum: Double
    var payed: Double
    var condition: String
    
    func getMonthSum() -> Double{
        switch condition {
        case "3 months":
            return (round(sum/3))
        case "6 months":
            return (round(sum/6))
        case "12 months":
            return (round(sum/12))
        case "24 months":
            return (round(sum/24))
        default:
            return round(sum/24 + sum*0.1)
        }
    }
    
    func info() -> String{
        return """
        id: \(id)
        sum: \(sum)
        payed: \(payed)
        sum per month: \(getMonthSum())
        condition: \(condition)
        """
    }
}

struct Installment: Codable
{
    var id: String
    var price: Double
    var payed: Double
    var condition: String
    
    func getMonthSum() -> Double{
        switch condition {
        case "3 months":
            return (round(price/3))
        case "6 months":
            return (round(price/6))
        case "12 months":
            return (round(price/12))
        case "24 months":
            return (round(price/24))
        default:
            return round(price/24 + price*0.1)
        }
    }
    
    func info() -> String{
        return """
        id: \(id)
        sum: \(price)
        payed: \(payed)
        sum per month: \(getMonthSum())
        condition: \(condition)
        """
    }
}

struct SalaryProject: Codable
{
    var title: String
    var description: String
    var sum: Double
    
    func info() -> String{
        return """
        title: \(title)
        description: \(description)
        sum: \(sum)
        """
    }
}
